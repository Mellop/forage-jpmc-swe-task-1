# Test Plan - LinkedIn Easy Apply Extension v2.0

## Overview
This document outlines the testing strategy for the enhanced LinkedIn Easy Apply Extension with multi-step application automation.

## Prerequisites for Testing
- Chrome browser with Developer mode enabled
- Active LinkedIn account with a complete profile
- Resume uploaded to LinkedIn
- Access to LinkedIn Jobs with Easy Apply listings

## Test Environment Setup

### 1. Extension Installation
```
1. Navigate to chrome://extensions/
2. Enable Developer mode
3. Click "Load unpacked"
4. Select linkedin-easy-apply-extension folder
5. Verify extension icon appears in toolbar
```

### 2. LinkedIn Preparation
```
1. Log into LinkedIn
2. Navigate to linkedin.com/jobs
3. Search for jobs in your field
4. Apply "Easy Apply" filter
5. Verify Easy Apply buttons are visible
```

### 3. Console Monitoring
```
1. Press F12 to open Developer Tools
2. Navigate to Console tab
3. Keep console open during testing
4. Monitor logs for errors or warnings
```

## Test Cases

### TC-001: Extension Loading
**Objective**: Verify extension loads correctly on LinkedIn jobs page

**Steps**:
1. Open LinkedIn jobs page
2. Check browser console for load message
3. Verify Easy Apply buttons are highlighted with blue border

**Expected Results**:
- Console shows: "LinkedIn Easy Apply Extension: Content script loaded"
- Easy Apply buttons have blue border and shadow
- No JavaScript errors in console

**Status**: [ ] Pass [ ] Fail

---

### TC-002: Popup Interface
**Objective**: Verify popup displays correctly

**Steps**:
1. Click extension icon in toolbar
2. Verify popup UI elements
3. Check default state

**Expected Results**:
- Popup opens with proper styling
- Status shows "Inactive"
- Jobs Applied shows "0"
- "Start Auto-Apply" button is visible
- "Reset Counter" button is visible

**Status**: [ ] Pass [ ] Fail

---

### TC-003: Start Auto-Apply
**Objective**: Verify auto-apply can be started

**Steps**:
1. On LinkedIn jobs page with Easy Apply jobs
2. Click extension icon
3. Click "Start Auto-Apply" button
4. Check popup status

**Expected Results**:
- Button text changes to "Stop Auto-Apply"
- Status changes to "Active"
- Console shows: "LinkedIn Easy Apply Extension: Starting auto-apply"
- Extension starts processing jobs

**Status**: [ ] Pass [ ] Fail

---

### TC-004: Simple Application (Direct Submit)
**Objective**: Verify extension handles single-step applications

**Setup**: Find a job with Easy Apply that only requires submit (no additional steps)

**Steps**:
1. Start Auto-Apply
2. Let extension click Easy Apply button
3. Wait for modal to appear
4. Observe extension behavior

**Expected Results**:
- Console: "Clicked Easy Apply button"
- Console: "Handling application modal"
- Console: "Found Submit button, clicking..."
- Application submits successfully
- Jobs Applied counter increases by 1
- Extension moves to next job

**Status**: [ ] Pass [ ] Fail

---

### TC-005: Multi-Step Application (Next → Submit)
**Objective**: Verify extension handles multi-step applications

**Setup**: Find a job with Easy Apply that has multiple steps (e.g., resume, then info, then submit)

**Steps**:
1. Start Auto-Apply
2. Let extension click Easy Apply
3. Observe as it clicks through steps

**Expected Results**:
- Console: "Clicked Easy Apply button"
- Console: "Found Next button, clicking..." (may repeat)
- Console: "Found Submit button, clicking..."
- Application submits successfully
- Jobs Applied counter increases
- Extension moves to next job

**Status**: [ ] Pass [ ] Fail

---

### TC-006: Required Field Detection and Pause
**Objective**: Verify extension pauses when required fields are empty

**Setup**: Find a job with Easy Apply that has required custom questions

**Steps**:
1. Start Auto-Apply
2. Let extension click Easy Apply
3. Wait for it to encounter required field
4. Observe pause behavior

**Expected Results**:
- Console: "X required fields need user input, pausing"
- Extension does NOT click Next or Submit
- Modal stays open
- Extension keeps checking every 2 seconds
- No buttons are clicked while fields are empty

**Status**: [ ] Pass [ ] Fail

---

### TC-007: Resume After Field Fill
**Objective**: Verify extension continues after user fills required fields

**Setup**: Continue from TC-006

**Steps**:
1. Fill in the required field(s)
2. Wait without clicking anything
3. Observe extension behavior

**Expected Results**:
- Extension detects field is now filled (within 2 seconds)
- Console: "Found Next button, clicking..." OR "Found Submit button, clicking..."
- Extension continues processing
- Application completes and submits
- Jobs Applied counter increases

**Status**: [ ] Pass [ ] Fail

---

### TC-008: Review Step Handling
**Objective**: Verify extension handles review steps

**Setup**: Find a job with a review step before submission

**Steps**:
1. Start Auto-Apply
2. Let extension process application
3. Wait for review step

**Expected Results**:
- Console: "Found Review button, clicking..."
- Extension clicks the review button
- Continues to submission step
- Clicks Submit
- Application completes

**Status**: [ ] Pass [ ] Fail

---

### TC-009: Move to Next Job
**Objective**: Verify extension navigates to next job after completing application

**Setup**: Have at least 2 Easy Apply jobs visible on page

**Steps**:
1. Start Auto-Apply
2. Let extension complete first application
3. Observe next job behavior

**Expected Results**:
- After first application submits
- Console: "Moving to next job"
- Console: "Clicked on job card [jobId]"
- Job card for second job is clicked/highlighted
- After 2 seconds, Easy Apply is clicked for new job
- Process repeats

**Status**: [ ] Pass [ ] Fail

---

### TC-010: Stop Auto-Apply
**Objective**: Verify auto-apply can be stopped mid-process

**Steps**:
1. Start Auto-Apply
2. Wait for application modal to open
3. Click extension icon
4. Click "Stop Auto-Apply"

**Expected Results**:
- Button text changes to "Start Auto-Apply"
- Status changes to "Inactive"
- Console: "Stopping auto-apply"
- No more automatic clicks occur
- Current modal stays open but unprocessed

**Status**: [ ] Pass [ ] Fail

---

### TC-011: Counter Reset
**Objective**: Verify jobs counter can be reset

**Steps**:
1. Apply to at least 1 job (counter > 0)
2. Click extension icon
3. Click "Reset Counter"

**Expected Results**:
- Jobs Applied changes to "0"
- Counter persists after closing popup
- Can continue applying jobs with counter at 0

**Status**: [ ] Pass [ ] Fail

---

### TC-012: Persistence Across Page Refresh
**Objective**: Verify state persists when page is refreshed

**Steps**:
1. Start Auto-Apply
2. Apply to 2-3 jobs
3. Refresh the LinkedIn jobs page
4. Check extension state

**Expected Results**:
- Counter persists (shows correct number)
- Auto-apply state resets to "Inactive" (expected behavior)
- Applied jobs are remembered (won't re-apply)
- Extension loads correctly on refresh

**Status**: [ ] Pass [ ] Fail

---

### TC-013: Multiple Jobs Processing
**Objective**: Verify extension can process multiple jobs in sequence

**Setup**: LinkedIn jobs page with 5+ Easy Apply jobs

**Steps**:
1. Start Auto-Apply
2. Let extension run through 5 jobs
3. Monitor each application

**Expected Results**:
- Each job is clicked in sequence
- Applications are completed
- Extension moves to next job after each
- Counter increases correctly (reaches 5)
- No duplicate applications
- Console shows clear progression

**Status**: [ ] Pass [ ] Fail

---

### TC-014: Error Handling - Modal Not Found
**Objective**: Verify graceful handling when modal doesn't appear

**Steps**:
1. Start Auto-Apply on a job
2. If modal fails to appear or closes unexpectedly
3. Observe extension behavior

**Expected Results**:
- Console: "Modal not found, application may be complete"
- Extension attempts to move to next job
- No JavaScript errors
- Extension continues functioning

**Status**: [ ] Pass [ ] Fail

---

### TC-015: Error Handling - No Jobs Found
**Objective**: Verify behavior when no jobs are available

**Setup**: LinkedIn page with no Easy Apply jobs visible

**Steps**:
1. Start Auto-Apply
2. Observe behavior

**Expected Results**:
- Console: "Found 0 Easy Apply buttons"
- Extension remains active
- No errors thrown
- Can still toggle off

**Status**: [ ] Pass [ ] Fail

---

## Performance Tests

### PT-001: Timing Validation
**Objective**: Verify timing delays work as expected

**Measurements**:
- [ ] Modal check interval: 2 seconds ±0.5s
- [ ] After submit delay: 3 seconds ±0.5s
- [ ] After job card click: 2 seconds ±0.5s
- [ ] Initial job stagger: 3 seconds ±0.5s

**Status**: [ ] Pass [ ] Fail

---

### PT-002: Memory Leak Check
**Objective**: Ensure no memory leaks during extended use

**Steps**:
1. Open Chrome Task Manager (Shift+Esc)
2. Start Auto-Apply
3. Let extension process 20+ jobs
4. Monitor memory usage

**Expected Results**:
- Memory usage stays relatively stable
- No continuous growth pattern
- Extension remains responsive

**Status**: [ ] Pass [ ] Fail

---

## Integration Tests

### IT-001: Console Logging
**Objective**: Verify all actions are logged appropriately

**Steps**:
1. Complete a full application cycle
2. Review console logs

**Expected Results**:
All these messages appear in order:
- "Content script loaded"
- "Starting auto-apply"
- "Found X Easy Apply buttons"
- "Clicked Easy Apply button"
- "Handling application modal"
- "Found [Next/Submit/Review] button, clicking..."
- "Moving to next job"
- "Clicked on job card [id]"

**Status**: [ ] Pass [ ] Fail

---

### IT-002: Storage Sync
**Objective**: Verify storage operations work correctly

**Steps**:
1. Apply to 3 jobs
2. Open chrome://extensions
3. Click "background page" for extension
4. Check chrome.storage.sync

**Expected Results**:
- autoApplyEnabled is stored
- appliedCount is stored and accurate
- Values persist across browser restart

**Status**: [ ] Pass [ ] Fail

---

## Security Tests

### ST-001: Permission Scope
**Objective**: Verify extension only runs on LinkedIn

**Steps**:
1. Navigate to non-LinkedIn site
2. Check if content script loads

**Expected Results**:
- Extension does not load on non-LinkedIn sites
- No console messages on other sites
- Extension only active on linkedin.com

**Status**: [ ] Pass [ ] Fail

---

### ST-002: No Data Leakage
**Objective**: Verify no data is sent externally

**Steps**:
1. Open Network tab in DevTools
2. Use extension to apply to jobs
3. Monitor network requests

**Expected Results**:
- No requests to non-LinkedIn domains from extension
- All requests are standard LinkedIn API calls
- No data sent to external servers

**Status**: [ ] Pass [ ] Fail

---

## Regression Tests

### RT-001: Original Features Still Work
**Objective**: Verify version 1.0 features still function

**Checklist**:
- [ ] Easy Apply button detection
- [ ] Button highlighting (blue border/shadow)
- [ ] Popup interface
- [ ] Counter tracking
- [ ] Start/Stop toggle
- [ ] Settings persistence

**Status**: [ ] Pass [ ] Fail

---

## Test Summary

### Test Execution Results

| Category | Total | Passed | Failed | Skipped |
|----------|-------|--------|--------|---------|
| Functional | 15 | | | |
| Performance | 2 | | | |
| Integration | 2 | | | |
| Security | 2 | | | |
| Regression | 1 | | | |
| **TOTAL** | **22** | | | |

### Pass Rate: ___%

### Critical Issues Found:
1. 
2. 
3. 

### Non-Critical Issues Found:
1. 
2. 
3. 

### Testing Notes:
- 
- 
- 

### Tested By: _______________
### Date: _______________
### Environment: Chrome v_______ on _______

---

## Manual Testing Checklist

Quick checklist for manual testing:

- [ ] Extension loads on LinkedIn jobs page
- [ ] Popup opens and displays correctly
- [ ] Can start auto-apply
- [ ] Clicks Easy Apply button
- [ ] Handles single-step applications
- [ ] Clicks "Next" in multi-step applications
- [ ] Pauses on required fields
- [ ] Resumes when fields are filled
- [ ] Clicks "Submit" button
- [ ] Updates counter correctly
- [ ] Moves to next job
- [ ] Processes multiple jobs in sequence
- [ ] Can be stopped mid-process
- [ ] Counter can be reset
- [ ] No JavaScript errors in console
- [ ] No duplicate applications
- [ ] Proper timing between actions

---

## Notes for Testers

1. **Be Ready to Fill Fields**: Extension will pause when it needs input. Have answers ready.

2. **Watch Console**: Most debugging info is in the console. Keep it open.

3. **Start Small**: Test with 2-3 jobs first before running on many jobs.

4. **Use Test Jobs**: If possible, use jobs you're willing to apply to, or test on a secondary account.

5. **Document Unexpected Behavior**: Note any behavior that doesn't match expected results.

6. **LinkedIn Changes**: LinkedIn's UI may change. Note if selectors fail to find elements.

7. **Timing Issues**: If extension seems slow or fast, note the actual delays observed.

8. **Error Recovery**: Test what happens when things go wrong (network errors, modal doesn't open, etc.)
