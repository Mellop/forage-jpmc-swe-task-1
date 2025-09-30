// LinkedIn Easy Apply Content Script
console.log('LinkedIn Easy Apply Extension: Content script loaded');

// Configuration
let autoApplyEnabled = false;
let appliedJobs = new Set();

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

// Handle the application modal
function handleApplicationModal() {
  // Wait for modal to appear
  setTimeout(() => {
    // Look for "Submit application" or "Next" buttons
    const submitButton = Array.from(document.querySelectorAll('button')).find(btn => 
      btn.innerText.toLowerCase().includes('submit application')
    );
    
    const nextButton = Array.from(document.querySelectorAll('button')).find(btn => 
      btn.innerText.toLowerCase().includes('next')
    );
    
    if (submitButton) {
      // If we can submit directly, do it
      console.log('LinkedIn Easy Apply Extension: Found submit button');
      // Note: Actual clicking is commented out for safety
      // submitButton.click();
    } else if (nextButton) {
      // If there are additional steps, we won't auto-complete them for safety
      console.log('LinkedIn Easy Apply Extension: Application requires additional steps');
    }
    
    // Close the modal for now (user should review)
    const closeButton = document.querySelector('[aria-label="Dismiss"]');
    if (closeButton) {
      closeButton.click();
    }
  }, 1000);
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
