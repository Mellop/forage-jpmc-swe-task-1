// LinkedIn Easy Apply Content Script
console.log('LinkedIn Easy Apply Extension: Content script loaded');

// Configuration
let autoApplyEnabled = false;
let appliedJobs = new Set();
let currentApplicationInProgress = false;
let applicationStepInterval = null;

// Listen for messages from popup
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.action === 'toggleAutoApply') {
    autoApplyEnabled = request.enabled;
    if (autoApplyEnabled) {
      startAutoApply();
    } else {
      stopAutoApply();
    }
    sendResponse({ success: true });
  } else if (request.action === 'getStatus') {
    sendResponse({ 
      enabled: autoApplyEnabled, 
      appliedCount: appliedJobs.size 
    });
  }
  return true;
});

// Find Easy Apply buttons on the page
function findEasyApplyButtons() {
  const buttons = [];
  
  // Look for "Easy Apply" buttons
  const easyApplyButtons = document.querySelectorAll('button');
  easyApplyButtons.forEach(button => {
    const buttonText = button.innerText.toLowerCase();
    if (buttonText.includes('easy apply')) {
      buttons.push(button);
    }
  });
  
  return buttons;
}

// Click the Easy Apply button
function clickEasyApplyButton(button) {
  try {
    button.click();
    console.log('LinkedIn Easy Apply Extension: Clicked Easy Apply button');
    return true;
  } catch (error) {
    console.error('LinkedIn Easy Apply Extension: Error clicking button', error);
    return false;
  }
}

// Handle the application modal - enhanced to complete multi-step applications
function handleApplicationModal() {
  console.log('LinkedIn Easy Apply Extension: Handling application modal');
  currentApplicationInProgress = true;
  
  // Start monitoring the modal for Next/Submit buttons
  applicationStepInterval = setInterval(() => {
    if (!autoApplyEnabled || !currentApplicationInProgress) {
      clearInterval(applicationStepInterval);
      return;
    }
    
    processApplicationStep();
  }, 2000); // Check every 2 seconds
}

// Process a single step in the application
function processApplicationStep() {
  // Look for the modal container
  const modal = document.querySelector('[role="dialog"]') || 
                document.querySelector('.jobs-easy-apply-modal');
  
  if (!modal) {
    console.log('LinkedIn Easy Apply Extension: Modal not found, application may be complete');
    currentApplicationInProgress = false;
    clearInterval(applicationStepInterval);
    
    // Wait a bit then move to next job
    setTimeout(() => {
      if (autoApplyEnabled) {
        moveToNextJob();
      }
    }, 2000);
    return;
  }
  
  // Check if there are required fields that need user input
  const requiredFields = modal.querySelectorAll('input[required]:not([disabled]), textarea[required]:not([disabled]), select[required]:not([disabled])');
  const emptyRequiredFields = Array.from(requiredFields).filter(field => {
    if (field.tagName === 'SELECT') {
      return !field.value || field.value === '';
    }
    return !field.value || field.value.trim() === '';
  });
  
  if (emptyRequiredFields.length > 0) {
    console.log(`LinkedIn Easy Apply Extension: ${emptyRequiredFields.length} required fields need user input, pausing`);
    // Pause but keep checking - user might fill them
    return;
  }
  
  // Look for buttons in the modal
  const buttons = Array.from(modal.querySelectorAll('button'));
  
  // Look for "Submit" or "Submit application" button
  const submitButton = buttons.find(btn => {
    const btnText = btn.innerText.toLowerCase();
    return btnText.includes('submit application') || 
           (btnText === 'submit' && !btnText.includes('review'));
  });
  
  if (submitButton && !submitButton.disabled) {
    console.log('LinkedIn Easy Apply Extension: Found Submit button, clicking...');
    submitButton.click();
    
    // Update applied jobs counter
    chrome.storage.sync.get(['appliedCount'], (result) => {
      const newCount = (result.appliedCount || 0) + 1;
      chrome.storage.sync.set({ appliedCount: newCount });
    });
    
    currentApplicationInProgress = false;
    clearInterval(applicationStepInterval);
    
    // Wait for submission to complete, then move to next job
    setTimeout(() => {
      if (autoApplyEnabled) {
        moveToNextJob();
      }
    }, 3000);
    return;
  }
  
  // Look for "Next" button
  const nextButton = buttons.find(btn => {
    const btnText = btn.innerText.toLowerCase();
    return btnText === 'next' || btnText.includes('continue');
  });
  
  if (nextButton && !nextButton.disabled) {
    console.log('LinkedIn Easy Apply Extension: Found Next button, clicking...');
    nextButton.click();
    // Continue checking for next step
    return;
  }
  
  // Look for "Review" button (some applications have review step)
  const reviewButton = buttons.find(btn => {
    const btnText = btn.innerText.toLowerCase();
    return btnText === 'review' || btnText.includes('review application');
  });
  
  if (reviewButton && !reviewButton.disabled) {
    console.log('LinkedIn Easy Apply Extension: Found Review button, clicking...');
    reviewButton.click();
    return;
  }
  
  console.log('LinkedIn Easy Apply Extension: No actionable buttons found in current step');
}

// Process jobs on the current page
function processCurrentPage() {
  const buttons = findEasyApplyButtons();
  console.log(`LinkedIn Easy Apply Extension: Found ${buttons.length} Easy Apply buttons`);
  
  buttons.forEach((button, index) => {
    if (!autoApplyEnabled) return;
    
    // Get job ID to avoid duplicates
    const jobCard = button.closest('[data-job-id]');
    const jobId = jobCard ? jobCard.getAttribute('data-job-id') : `job-${index}`;
    
    if (!appliedJobs.has(jobId)) {
      setTimeout(() => {
        if (autoApplyEnabled) {
          clickEasyApplyButton(button);
          appliedJobs.add(jobId);
          handleApplicationModal();
        }
      }, index * 3000); // Stagger clicks to avoid rate limiting
    }
  });
}

// Move to the next job in the list
function moveToNextJob() {
  console.log('LinkedIn Easy Apply Extension: Moving to next job');
  
  // Find all job cards
  const jobCards = document.querySelectorAll('[data-job-id]');
  
  if (jobCards.length === 0) {
    console.log('LinkedIn Easy Apply Extension: No job cards found');
    return;
  }
  
  // Find the next unapplied job
  for (let i = 0; i < jobCards.length; i++) {
    const jobCard = jobCards[i];
    const jobId = jobCard.getAttribute('data-job-id');
    
    if (!appliedJobs.has(jobId)) {
      // Click on this job card to view it
      const clickableElement = jobCard.querySelector('a') || jobCard;
      clickableElement.click();
      
      console.log(`LinkedIn Easy Apply Extension: Clicked on job card ${jobId}`);
      
      // Wait for the job to load, then look for Easy Apply button
      setTimeout(() => {
        if (autoApplyEnabled && !currentApplicationInProgress) {
          const easyApplyButtons = findEasyApplyButtons();
          if (easyApplyButtons.length > 0) {
            clickEasyApplyButton(easyApplyButtons[0]);
            appliedJobs.add(jobId);
            handleApplicationModal();
          }
        }
      }, 2000);
      
      return;
    }
  }
  
  console.log('LinkedIn Easy Apply Extension: All jobs on this page have been processed');
  // Could scroll down to load more jobs here if needed
}

// Start auto-apply process
function startAutoApply() {
  console.log('LinkedIn Easy Apply Extension: Starting auto-apply');
  processCurrentPage();
  
  // Observe DOM changes for dynamically loaded content
  const observer = new MutationObserver((mutations) => {
    if (autoApplyEnabled) {
      processCurrentPage();
    }
  });
  
  observer.observe(document.body, {
    childList: true,
    subtree: true
  });
}

// Stop auto-apply process
function stopAutoApply() {
  console.log('LinkedIn Easy Apply Extension: Stopping auto-apply');
  currentApplicationInProgress = false;
  if (applicationStepInterval) {
    clearInterval(applicationStepInterval);
    applicationStepInterval = null;
  }
}

// Highlight Easy Apply buttons for visibility
function highlightEasyApplyButtons() {
  const buttons = findEasyApplyButtons();
  buttons.forEach(button => {
    button.style.border = '2px solid #0073b1';
    button.style.boxShadow = '0 0 5px #0073b1';
  });
}

// Initialize
chrome.storage.sync.get(['autoApplyEnabled'], (result) => {
  autoApplyEnabled = result.autoApplyEnabled || false;
  if (autoApplyEnabled) {
    startAutoApply();
  }
  highlightEasyApplyButtons();
});
