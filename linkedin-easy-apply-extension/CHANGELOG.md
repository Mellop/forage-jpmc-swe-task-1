# Changelog

## Version 2.0.0 - Multi-Step Application Support

### New Features

#### Automated Multi-Step Application Flow
- **Next Button Automation**: Extension now automatically clicks "Next" buttons to progress through application steps
- **Submit Button Detection**: Automatically detects and clicks "Submit" or "Submit application" buttons
- **Review Step Handling**: Handles applications with review steps by clicking "Review" buttons

#### Smart Form Detection
- **Required Field Detection**: Detects when required fields are empty and pauses execution
- **User Input Wait**: Waits for user to fill required fields, then automatically continues
- **Field Validation**: Checks both input fields and select dropdowns for completion

#### Job Queue Management
- **Auto-Next Job**: Automatically moves to the next job after completing an application
- **Job Card Navigation**: Clicks on the next unapplied job card in the list
- **Progress Tracking**: Maintains a set of applied jobs to avoid duplicates

#### Enhanced State Management
- **Application Progress Tracking**: Tracks when an application is in progress
- **Interval-Based Monitoring**: Checks modal state every 2 seconds for button availability
- **Clean Shutdown**: Properly clears intervals when stopping auto-apply

### Implementation Details

#### New Variables
- `currentApplicationInProgress`: Tracks if an application is being processed
- `applicationStepInterval`: Interval ID for monitoring application progress

#### New Functions
- `processApplicationStep()`: Handles logic for each step of the application
- `moveToNextJob()`: Finds and clicks on the next unapplied job

#### Enhanced Functions
- `handleApplicationModal()`: Now uses interval-based monitoring instead of single timeout
- `stopAutoApply()`: Properly cleans up intervals and state

### User Experience Improvements

- Extension no longer closes modals prematurely
- Automatically progresses through multi-page applications
- Pauses intelligently when user input is needed
- Provides clear console logging for debugging

### Technical Notes

- Uses 2-second intervals for checking button states
- Waits 3 seconds after submission before moving to next job
- Waits 2 seconds after clicking a job card before opening Easy Apply
- Identifies modals using `[role="dialog"]` or `.jobs-easy-apply-modal` selectors

### Documentation Updates

- Updated README.md with new features and behavior
- Updated popup.html instructions to reflect automated behavior
- Added notes about pausing for required fields

## Version 1.0.0 - Initial Release

- Basic Easy Apply button detection
- Manual review workflow
- Application tracking
- Extension popup interface
