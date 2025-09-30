// Popup Script for LinkedIn Easy Apply Extension
document.addEventListener('DOMContentLoaded', () => {
  const toggleBtn = document.getElementById('toggleBtn');
  const resetBtn = document.getElementById('resetBtn');
  const statusElement = document.getElementById('status');
  const appliedCountElement = document.getElementById('appliedCount');
  
  let isEnabled = false;
  let appliedCount = 0;
  
  // Load current status
  loadStatus();
  
  // Toggle auto-apply
  toggleBtn.addEventListener('click', () => {
    isEnabled = !isEnabled;
    updateUI();
    saveSettings();
    
    // Send message to content script
    chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
      if (tabs[0]) {
        chrome.tabs.sendMessage(tabs[0].id, {
          action: 'toggleAutoApply',
          enabled: isEnabled
        }, (response) => {
          if (chrome.runtime.lastError) {
            console.log('Content script not loaded yet');
          }
        });
      }
    });
  });
  
  // Reset counter
  resetBtn.addEventListener('click', () => {
    appliedCount = 0;
    updateUI();
    saveSettings();
  });
  
  // Update UI based on current state
  function updateUI() {
    if (isEnabled) {
      toggleBtn.textContent = 'Stop Auto-Apply';
      toggleBtn.classList.add('active');
      statusElement.textContent = 'Active';
      statusElement.classList.add('active');
      statusElement.classList.remove('inactive');
    } else {
      toggleBtn.textContent = 'Start Auto-Apply';
      toggleBtn.classList.remove('active');
      statusElement.textContent = 'Inactive';
      statusElement.classList.add('inactive');
      statusElement.classList.remove('active');
    }
    
    appliedCountElement.textContent = appliedCount;
  }
  
  // Save settings to storage
  function saveSettings() {
    chrome.storage.sync.set({
      autoApplyEnabled: isEnabled,
      appliedCount: appliedCount
    });
  }
  
  // Load status from storage
  function loadStatus() {
    chrome.storage.sync.get(['autoApplyEnabled', 'appliedCount'], (result) => {
      isEnabled = result.autoApplyEnabled || false;
      appliedCount = result.appliedCount || 0;
      updateUI();
    });
    
    // Also try to get status from content script
    chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
      if (tabs[0] && tabs[0].url && tabs[0].url.includes('linkedin.com')) {
        chrome.tabs.sendMessage(tabs[0].id, {
          action: 'getStatus'
        }, (response) => {
          if (response && !chrome.runtime.lastError) {
            isEnabled = response.enabled;
            appliedCount = response.appliedCount;
            updateUI();
          }
        });
      }
    });
  }
  
  // Refresh status every 2 seconds
  setInterval(loadStatus, 2000);
});
