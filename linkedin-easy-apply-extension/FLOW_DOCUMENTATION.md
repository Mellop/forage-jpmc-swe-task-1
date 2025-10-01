# LinkedIn Easy Apply Extension - Application Flow

## Overview
This document describes how the extension automatically completes multi-step LinkedIn Easy Apply applications.

## Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│ User clicks "Start Auto-Apply" in extension popup              │
└─────────────────────────┬───────────────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│ Extension scans page for Easy Apply buttons                    │
│ - Highlights buttons with blue border                          │
│ - Identifies job cards with [data-job-id]                      │
└─────────────────────────┬───────────────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│ Click first unapplied Easy Apply button                        │
│ - Mark job ID as applied                                        │
│ - Wait for modal to appear                                      │
└─────────────────────────┬───────────────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│ Start interval-based modal monitoring (every 2 seconds)        │
│ - Set currentApplicationInProgress = true                       │
│ - Call processApplicationStep() repeatedly                      │
└─────────────────────────┬───────────────────────────────────────┘
                          ▼
        ┌─────────────────────────────────────────────┐
        │ processApplicationStep() checks modal state │
        └─────────────────┬───────────────────────────┘
                          ▼
        ┌─────────────────────────────────────────────┐
        │ Is modal still visible?                     │
        └──────┬──────────────────────────────────┬───┘
               │ No                               │ Yes
               ▼                                  ▼
    ┌──────────────────┐            ┌────────────────────────────┐
    │ Application done │            │ Check for required fields  │
    │ Move to next job │            │ that are empty             │
    └──────────────────┘            └─────┬──────────────────────┘
                                          │
                               ┌──────────┴──────────┐
                               │                     │
                        Has empty required    All required fields
                        fields?                filled or N/A
                               │                     │
                               ▼                     ▼
                    ┌──────────────────┐   ┌────────────────────┐
                    │ PAUSE & WAIT     │   │ Look for buttons:  │
                    │ - Log message    │   │ 1. Submit          │
                    │ - Keep checking  │   │ 2. Next            │
                    │ - User fills in  │   │ 3. Review          │
                    └──────────────────┘   └─────┬──────────────┘
                                                 │
                                   ┌─────────────┼─────────────┐
                                   │             │             │
                                   ▼             ▼             ▼
                            ┌──────────┐  ┌──────────┐  ┌──────────┐
                            │ Submit   │  │ Next     │  │ Review   │
                            │ button   │  │ button   │  │ button   │
                            └────┬─────┘  └────┬─────┘  └────┬─────┘
                                 │             │             │
                                 ▼             ▼             ▼
                         ┌───────────┐  ┌──────────┐  ┌──────────┐
                         │ Click it! │  │ Click it!│  │ Click it!│
                         │ Update    │  │ Continue │  │ Continue │
                         │ counter   │  │ checking │  │ checking │
                         └─────┬─────┘  └──────────┘  └──────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │ Wait 3 seconds       │
                    │ Clear interval       │
                    │ Move to next job     │
                    └──────────┬───────────┘
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│ moveToNextJob()                                                 │
│ - Find all job cards on page                                    │
│ - Find first job not in appliedJobs set                         │
│ - Click on that job card                                        │
│ - Wait 2 seconds for job details to load                        │
│ - Click Easy Apply button for that job                          │
│ - Start modal monitoring again                                  │
└─────────────────────────────────────────────────────────────────┘
                               │
                               ▼
        ┌──────────────────────────────────────┐
        │ REPEAT until all jobs processed      │
        └──────────────────────────────────────┘
```

## Key Functions

### 1. findEasyApplyButtons()
- Scans all buttons on the page
- Returns array of buttons containing "easy apply" text

### 2. clickEasyApplyButton(button)
- Clicks the provided button
- Logs the action
- Returns success/failure status

### 3. handleApplicationModal()
- Sets `currentApplicationInProgress = true`
- Starts interval that calls `processApplicationStep()` every 2 seconds
- Continues until application is complete or stopped

### 4. processApplicationStep()
**Modal Detection:**
- Looks for `[role="dialog"]` or `.jobs-easy-apply-modal`
- If not found, assumes application complete → move to next job

**Required Field Check:**
- Finds all `[required]` inputs, textareas, and selects
- Filters for empty ones
- If any empty required fields exist → PAUSE (keep checking)
- If all filled → proceed to button detection

**Button Priority:**
1. **Submit button** - `btnText.includes('submit application')` or `btnText === 'submit'`
   - Clicks it
   - Updates appliedCount in storage
   - Waits 3 seconds
   - Moves to next job

2. **Next button** - `btnText === 'next'` or `btnText.includes('continue')`
   - Clicks it
   - Continues monitoring for next step

3. **Review button** - `btnText === 'review'` or `btnText.includes('review application')`
   - Clicks it
   - Continues monitoring

### 5. moveToNextJob()
- Queries all `[data-job-id]` elements
- Iterates through them to find first unapplied job
- Clicks the job card (or anchor within it)
- Waits 2 seconds for job to load
- Finds Easy Apply button in newly loaded job
- Clicks it and starts application process
- If no more unapplied jobs, logs completion

### 6. stopAutoApply()
- Sets `currentApplicationInProgress = false`
- Clears `applicationStepInterval`
- Stops all automation

## Timing Configuration

| Action | Delay | Reason |
|--------|-------|--------|
| Modal check interval | 2 seconds | Balance between responsiveness and performance |
| After modal closes | 2 seconds | Wait for animation/cleanup before next job |
| After submit click | 3 seconds | Wait for submission to process |
| After job card click | 2 seconds | Wait for job details to load |
| Between initial Easy Apply clicks | 3 seconds | Stagger to avoid rate limiting |

## State Variables

- `autoApplyEnabled`: Boolean - Is auto-apply currently active?
- `appliedJobs`: Set - Job IDs that have been processed
- `currentApplicationInProgress`: Boolean - Is an application modal open?
- `applicationStepInterval`: Number - Interval ID for monitoring

## User Interaction Points

Users need to interact when:
1. Required fields are empty (extension pauses automatically)
2. Custom questions need answers (not auto-fillable)
3. Documents need to be uploaded (manual action required)

The extension will wait at these points and continue once fields are filled.
