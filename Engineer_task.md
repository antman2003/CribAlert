# CribAlert — Engineering Tasks & Milestones

This document breaks the CribAlert product into engineering milestones and tasks.
Each milestone includes:
- Scope
- Deliverables
- Validation criteria

The app must follow all principles defined in README.md.
Non-medical positioning, calm UX, and privacy-first behavior are mandatory.

---

## Milestone 0 — Project Foundation & Guardrails

### Goal
Establish the technical foundation and prevent unsafe assumptions early.

### Tasks
- Initialize iOS project (Swift / SwiftUI recommended)
- Set up basic navigation structure
- Define global design system tokens (colors, typography, spacing)
- Add README.md as a required reference for all contributors

### Validation
- App builds and runs on simulator
- Light/white background is default across views
- No medical or emergency language exists in codebase
- README.md is referenced in project documentation

---

## Milestone 1 — Welcome & Safety Disclosure

### Goal
Set expectations, establish trust, and meet App Store requirements.

### Tasks
- Implement Welcome screen
- Display non-medical disclaimer clearly
- Add user acknowledgment checkbox
- Allow user to continue without account creation

### Validation
- User cannot proceed without acknowledging disclaimer
- Wording contains:
  - “Not a medical device”
  - No mention of breathing, oxygen, SIDS, or guarantees
- App Store reviewer can clearly identify safety disclaimer

---

## Milestone 2 — Camera Setup & Calibration

### Goal
Enable reliable monitoring while reducing false alerts.

### Tasks

#### 2.1 Camera Placement Screen
- Instructional UI for mounting phone above crib
- Explain distance & angle
- Reassurance text: “You can adjust this later”

#### 2.2 Define Sleep Area
- Live camera preview
- User selects crib area (ROI)
- Explain purpose: reduce false alerts

#### 2.3 Final Setup Check (Calibration)
- Title: “Final setup check”
- Progress indicator (non-urgent)
- Validate lighting and camera angle
- Explicit privacy message:
  “No video is recorded or saved. Analysis happens on your device.”

### Validation
- Setup completes successfully on real device
- No video is saved or uploaded during calibration
- User understands why each step exists (no opaque “AI training”)
- Calibration can be re-run from Settings

---

## Milestone 3 — Live Monitoring (Main Screen)

### Goal
Provide calm, continuous monitoring with clear system state.

### Tasks
- Implement Main Monitoring screen
- Show:
  - Status card (“Sleep looks normal”)
  - Live camera preview
  - Movement / position indicators
- Implement Monitoring Active state

### Validation
- Live camera feed visible
- UI remains responsive during long monitoring sessions
- No panic colors or emergency language used
- Monitoring works without account or payment

---

## Milestone 4 — Monitoring Paused State

### Goal
Handle failure states without causing anxiety.

### Tasks
- Detect paused conditions:
  - Camera disconnected
  - App closed on camera device
  - Battery unplugged
- Display Monitoring Paused state on main screen:
  - Replace status card
  - Neutral colors (gray / soft blue)
  - Clear reason text
  - Primary action: “Reconnect camera”
  - Reassurance message

### Validation
- Monitoring Paused is shown automatically when camera disconnects
- No alerts are fired while paused
- User clearly understands how to resume monitoring
- This is a state, not a separate page

---

## Milestone 5 — Safety Alert System

### Goal
Notify parents when attention may be needed, without panic.

### Tasks

#### 5.1 Alert Types
Implement the following alerts:
- Baby rolled onto stomach (High)
- Baby’s face may be covered (High)
- Unusual stillness detected (Medium)
- Crying detected (Medium)

#### 5.2 Alert UI
- Full-screen alert
- Observational language only
- Primary actions:
  - “View live camera”
  - “I’m checking”
- Support “hands busy” scenario (no forced interaction)

### Validation
- Alerts fire correctly under simulated conditions
- Alert wording avoids:
  - Medical terms
  - Emergency framing
- Dismissing or acknowledging alerts behaves correctly
- Alerts never require payment or account

---

## Milestone 6 — History & Review

### Goal
Allow parents to review past events calmly.

### Tasks
- Implement History page with:
  - Light/white background
  - Session summary
  - Event timeline
- Frame all events as resolved
- No scores, grades, or risk metrics

### Validation
- Reviewing history reduces anxiety (no alarming language)
- Free users can view last 24 hours
- History is readable and narrative, not technical

---

## Milestone 7 — Settings & Preferences

### Goal
Give users control without fear or confusion.

### Tasks

#### 7.1 Settings Main Page
- Camera Calibration
- Safety Alerts toggle
- Alert Preferences
- Privacy & Transparency
- Baby Profile
- Help & Support
- Account (optional)

#### 7.2 Alert Preferences
- Sound selection with preview
- Volume control
- Override silent mode
- Vibration patterns with descriptions
- One option marked “Recommended”

### Validation
- No setting disables core safety silently
- Changes are reversible
- No setting implies safety trade-offs

---

## Milestone 8 — Baby Profile

### Goal
Personalization only, no safety impact.

### Tasks
- Baby name (required)
- Sleep location (optional)
- Profile photo (optional)
- Explicit statement:
  “Profile details don’t affect monitoring or alerts.”

### Validation
- Profile data does not affect detection logic
- No medical or developmental fields exist
- User can edit profile at any time

---

## Milestone 9 — Privacy & Transparency

### Goal
Make privacy guarantees explicit and verifiable.

### Tasks
- On-device processing explanation
- No cloud storage by default
- Optional account explanation
- Link to full privacy policy

### Validation
- All claims are technically accurate
- No misleading “100%” or marketing language
- Matches actual data flow implementation

---

## Milestone 10 — Help & Support

### Goal
Provide reassurance and assistance.

### Tasks
- Help & Support page with:
  - Common questions
  - Troubleshooting
  - Contact support
- Gentle supervision reminder

### Validation
- Page feels calm and supportive
- No medical disclaimers or panic wording
- Users can reach support easily

---

## Milestone 11 — Account System (Optional, V1.1 Ready)

### Goal
Prepare for monetization without forcing sign-in.

### Tasks
- Account entry in Settings
- Account creation page explaining optional nature
- No account required for core monitoring

### Validation
- App fully usable without account
- Account only required for premium features
- No login prompts during setup or alerts

---

## Milestone 12 — Monetization Hooks (Disabled by Default)

### Goal
Prepare UI hooks without gating safety.

### Tasks
- Feature flags for:
  - Extended history
  - Night summaries
  - Caregiver sharing
- Paywall placeholders (not active in V1)

### Validation
- No safety feature is blocked
- Premium UI does not appear in core flows
- App Store compliance maintained

---

## Milestone 13 — QA, Safety & App Store Review Readiness

### Goal
Ensure compliance and stability.

### Tasks
- Copy audit for medical language
- Failure mode testing
- Battery & thermal testing
- Privacy audit (no unintended data storage)

### Validation
- Apple App Store guidelines satisfied
- No crashes during long monitoring
- No data leaves device unexpectedly
- Reviewer can clearly identify non-medical positioning

---

## Definition of Done (Global)

The app is ready when:
- Core monitoring works without sign-up or payment
- Alerts are calm and actionable
- Privacy claims match implementation
- App Store reviewers find no medical violations
- Parents feel calmer after using the app

---

**CribAlert is a safety companion, not a medical device.  
Engineering decisions must reinforce trust, clarity, and calmness.**
