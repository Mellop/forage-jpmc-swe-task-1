# LinkedIn Easy Apply Chrome Extension

A Chrome extension that helps you apply to jobs on LinkedIn using the Easy Apply feature.

## Features

- **Easy Apply Detection**: Automatically detects and highlights Easy Apply buttons on LinkedIn job listings
- **Auto-Apply Mode**: Automatically clicks Easy Apply buttons and completes multi-step applications
- **Multi-Step Application Handling**: Automatically clicks "Next" buttons and navigates through application steps
- **Smart Form Detection**: Pauses when required fields need user input, then continues when filled
- **Auto-Submit**: Automatically submits applications when all steps are complete
- **Job Queue Processing**: Automatically moves to the next job after completing an application
- **Application Tracking**: Keeps count of jobs you've applied to
- **Safety First**: Waits for user input on required fields before proceeding
- **User-Friendly Interface**: Clean popup interface to control the extension

## Installation

### From Source

1. Clone or download this repository
2. Open Chrome and navigate to `chrome://extensions/`
3. Enable "Developer mode" in the top right corner
4. Click "Load unpacked"
5. Select the `linkedin-easy-apply-extension` folder
6. The extension should now appear in your Chrome toolbar

## How to Use

1. **Navigate to LinkedIn Jobs**
   - Go to [LinkedIn Jobs](https://www.linkedin.com/jobs/)
   - Search for jobs you're interested in
   - Use LinkedIn's filters to show only "Easy Apply" jobs

2. **Activate the Extension**
   - Click the extension icon in your Chrome toolbar
   - Click "Start Auto-Apply" to enable the feature

3. **Review Applications**
   - The extension will highlight Easy Apply buttons
   - It will open the Easy Apply modal when activated
   - **Multi-Step Applications**: The extension will automatically click "Next" to progress through steps
   - **User Input Required**: When required fields are empty, the extension pauses and waits for you to fill them
   - **Auto-Submit**: Once all steps are complete and fields are filled, the extension submits the application
   - **Next Job**: After submission, the extension automatically moves to the next job

4. **Track Your Progress**
   - View the number of applications started in the popup
   - Reset the counter anytime using the "Reset Counter" button

## Safety & Ethics

⚠️ **Important Notes**:

- This extension is designed as an assistive tool, not for spam applications
- Always review each job posting carefully before applying
- Customize your resume and cover letter for each position when possible
- The extension will pause when it encounters required fields that need input
- Fill in required fields (marked with *) when the extension pauses
- The extension automatically completes multi-step applications and submits them
- Use responsibly and in accordance with LinkedIn's Terms of Service

## File Structure

```
linkedin-easy-apply-extension/
├── manifest.json          # Extension configuration
├── background.js          # Background service worker
├── content.js            # Content script for LinkedIn pages
├── popup.html            # Popup interface HTML
├── popup.css             # Popup interface styles
├── popup.js              # Popup interface logic
├── icons/                # Extension icons
│   ├── icon16.png
│   ├── icon48.png
│   └── icon128.png
└── README.md             # This file
```

## Technical Details

### Permissions

- `activeTab`: To interact with the current LinkedIn tab
- `storage`: To save settings and track applied jobs
- `host_permissions`: Limited to LinkedIn.com for security

### Browser Compatibility

- Chrome (Manifest V3)
- Edge (Chromium-based)
- Other Chromium-based browsers

## Privacy

This extension:
- Does NOT collect any personal data
- Does NOT send data to external servers
- Stores settings locally in Chrome's sync storage
- Only runs on LinkedIn.com pages

## Limitations

- Only works with LinkedIn's "Easy Apply" feature
- Pauses on multi-step applications when required fields need user input
- Cannot automatically fill custom questions or upload documents
- Rate limiting may apply based on LinkedIn's policies
- Automatically submits applications once all required fields are complete

## Development

### Requirements

- Chrome browser with Developer mode enabled
- Basic knowledge of JavaScript, HTML, and CSS

### Making Changes

1. Edit the source files
2. Go to `chrome://extensions/`
3. Click the refresh icon on the extension card
4. Test your changes

## Troubleshooting

**Extension not working?**
- Make sure you're on a LinkedIn jobs page
- Check that the extension is enabled in Chrome
- Try refreshing the page

**Easy Apply buttons not highlighted?**
- The page may still be loading
- Try scrolling down to load more jobs
- Refresh the extension

**Auto-apply not starting applications?**
- This is intentional for safety
- The extension highlights buttons but requires user confirmation
- Review the console for any errors

## License

This extension is provided as-is for educational and assistive purposes.

## Disclaimer

This extension is not affiliated with, endorsed by, or sponsored by LinkedIn Corporation. Use at your own risk and in accordance with LinkedIn's Terms of Service.

## Contributing

Contributions are welcome! Please ensure any changes:
- Maintain user safety and privacy
- Follow existing code style
- Include appropriate documentation

## Support

For issues or questions, please open an issue in the repository.
