// Background Service Worker for LinkedIn Easy Apply Extension
console.log('LinkedIn Easy Apply Extension: Background service worker loaded');

// Handle extension installation
chrome.runtime.onInstalled.addListener(() => {
  console.log('LinkedIn Easy Apply Extension installed');
  
  // Set default storage values
  chrome.storage.sync.set({
    autoApplyEnabled: false,
    appliedJobs: []
  });
});

// Handle messages from content script and popup
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.action === 'saveSettings') {
    chrome.storage.sync.set(request.settings, () => {
      sendResponse({ success: true });
    });
    return true;
  }
  
  if (request.action === 'getSettings') {
    chrome.storage.sync.get(null, (settings) => {
      sendResponse({ settings });
    });
    return true;
  }
});

// Listen for tab updates to inject content script on LinkedIn job pages
chrome.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
  if (changeInfo.status === 'complete' && tab.url && tab.url.includes('linkedin.com/jobs')) {
    console.log('LinkedIn Easy Apply Extension: LinkedIn jobs page detected');
  }
});
