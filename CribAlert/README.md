# CribAlert iOS App

Trust-first baby sleep safety monitoring app built with SwiftUI.

## Project Setup (Xcode)

Since the Swift source files were created on Windows, you need to create the Xcode project on a Mac:

### Step 1: Create New Xcode Project

1. Open Xcode (version 15.0 or later recommended)
2. File → New → Project
3. Select "App" under iOS
4. Configure:
   - **Product Name:** CribAlert
   - **Team:** Your Apple Developer Team
   - **Organization Identifier:** com.cribalert
   - **Bundle Identifier:** com.cribalert.app
   - **Interface:** SwiftUI
   - **Language:** Swift
   - **Storage:** None
   - **Include Tests:** Yes (for unit tests later)

### Step 2: Replace Generated Files

1. Delete the auto-generated `CribAlertApp.swift` and `ContentView.swift`
2. Drag the entire `CribAlert` folder (containing App, DesignSystem, Features, etc.) into the project
3. When prompted, select:
   - ✅ Copy items if needed
   - ✅ Create groups
   - Target: CribAlert

### Step 3: Configure Info.plist

1. Select your project in the navigator
2. Select the CribAlert target
3. Go to "Info" tab
4. Add the following keys (or use the provided Info.plist):

| Key | Value |
|-----|-------|
| Privacy - Camera Usage Description | CribAlert needs camera access to monitor your baby's sleep area. Video is analyzed on-device and never recorded or uploaded. |
| Privacy - Microphone Usage Description | CribAlert uses the microphone to detect if your baby is crying. Audio is processed on-device and never recorded or uploaded. |

### Step 4: Configure Capabilities

1. Select your project → CribAlert target → "Signing & Capabilities"
2. Add the following capabilities:
   - **Background Modes:**
     - ✅ Audio, AirPlay, and Picture in Picture
     - ✅ Background processing
   - **Push Notifications** (for future alerts)

### Step 5: Set Deployment Target

1. Select project → General → Deployment Info
2. Set **Minimum Deployments** to iOS 16.0

### Step 6: Build and Run

1. Select an iPhone simulator (iPhone 15 Pro recommended)
2. Press Cmd+R to build and run
3. The app should display the Welcome screen

---

## Project Structure

```
CribAlert/
├── App/
│   ├── CribAlertApp.swift       # Main app entry point
│   ├── AppState.swift           # Global state management
│   └── ContentView.swift        # Root navigation view
├── DesignSystem/
│   ├── Colors.swift             # Color tokens
│   ├── Typography.swift         # Font styles
│   ├── Spacing.swift            # Layout constants
│   └── Components/
│       ├── PrimaryButton.swift  # Green CTA button
│       ├── SecondaryButton.swift # Outlined/secondary buttons
│       ├── StatusCard.swift     # Status display cards
│       └── ToggleRow.swift      # Settings toggle rows
├── Features/
│   ├── Welcome/                 # Welcome & disclaimer (Phase 2)
│   ├── Setup/                   # Setup flow (Phase 3)
│   ├── Monitor/                 # Live monitoring (Phase 4-5)
│   ├── Alerts/                  # Safety alerts (Phase 6)
│   ├── History/                 # History tab (Phase 7)
│   └── Settings/                # Settings screens (Phase 8)
├── Services/
│   ├── CameraManager.swift      # AVFoundation camera (Phase 4)
│   ├── AudioManager.swift       # Audio input (Phase 9)
│   ├── DetectionManager.swift   # ML detection (Phase 9)
│   └── NotificationManager.swift # Push notifications
├── Models/
│   └── (data models)
└── Resources/
    ├── Assets.xcassets          # App icons, colors
    └── Sounds/                  # Alert sounds
```

---

## Validation Checklist (Step 1.1)

After building, verify the following:

### ✅ Build Success
- [ ] App compiles without errors
- [ ] App runs on iPhone Simulator

### ✅ UI Verification
- [ ] Welcome screen displays on first launch
- [ ] "CribAlert" logo/title visible
- [ ] Safety disclaimer card visible with shield icon
- [ ] Checkbox and "Start Setup" button visible
- [ ] Light/white background used (not dark mode)

### ✅ Navigation
- [ ] Tapping checkbox + "Start Setup" advances to Step 1
- [ ] Progress through all 4 setup steps works
- [ ] After setup, Tab Bar appears with 3 tabs
- [ ] Switching between Monitor, History, Settings tabs works

### ✅ Design System
- [ ] Green buttons use primary green color (#00D26A)
- [ ] Blue accents visible on links/toggles
- [ ] Fonts are readable and consistent

### ✅ Code Quality
- [ ] No medical language in any user-facing strings
- [ ] No "emergency", "SIDS", "breathing", "oxygen" terms
- [ ] Privacy messaging matches implementation

---

## Key Implementation Notes

### Non-Medical Positioning
This app is a **safety companion**, NOT a medical device. All code must:
- Use observational language ("may be covered", "unusual stillness")
- Never claim to detect breathing, oxygen, or vital signs
- Never claim to prevent SIDS or guarantee safety

### Privacy-First
- All video/audio analysis happens on-device
- No data is recorded or uploaded by default
- Core features work without account creation

### Calm UX
- No red flashing or emergency tones
- Alerts are serious but not panic-inducing
- Light/white UI with soft accent colors

---

## Next Steps

After validating Step 1.1, proceed to:
- **Step 1.2:** Define complete design system tokens
- **Step 1.3:** Complete navigation structure
- **Step 2.1:** Implement full Welcome screen matching UI design

See the main plan document for detailed implementation steps.
