# CribAlert — Trust-First Baby Sleep Safety Monitor

## 1. Product Overview

**CribAlert** is a trust-first, non-medical baby sleep safety monitoring app.

Its goal is to give parents peace of mind by:
- Monitoring visible sleep safety conditions using a camera and microphone
- Alerting parents when something *may* need attention
- Doing so calmly, transparently, and without panic or medical claims

CribAlert is **not a medical device** and does **not** monitor vital signs.  
It is designed to *support parents*, not replace supervision.

---

## 2. Core Principles (Do Not Violate)

These principles override all other considerations.

### 2.1 Non-Medical Positioning (Critical)
- Do NOT claim to detect breathing, oxygen, heart rate, or health conditions
- Do NOT claim to prevent SIDS or guarantee safety
- Use observational language only (e.g. “may be covered”, “unusual stillness”)

### 2.2 Trust & Calm UX
- Alerts must be serious but not panic-inducing
- No red flashing, sirens, or emergency wording
- Light / white UI for most screens
- Warm accent colors only for alerts (amber / yellow / blue)

### 2.3 Privacy-First Architecture
- All safety analysis runs **on-device**
- No video or audio is recorded or uploaded by default
- Cloud is optional and only for premium features
- Accounts are optional; core safety works without sign-in

### 2.4 Safety Is Always Free
- Live monitoring and core safety alerts are never paywalled
- Monetization applies only to convenience features (history, summaries, sharing)

---

## 3. Supported Platforms & Hardware

### 3.1 Camera Model
- Uses a **phone-as-camera** approach (e.g. spare iPhone)
- Camera device is mounted above the crib with a top-down view
- Monitoring device and parent device may be different phones

### 3.2 Device Capabilities
- Camera: live video feed (low FPS acceptable)
- Microphone: sound pattern detection (crying)
- On-device ML (e.g. Core ML)
- Device must be plugged in during monitoring

---

## 4. App Structure (High Level)

The app consists of **five major parts**:

1. Welcome & Safety Disclosure  
2. Setup & Calibration  
3. Live Monitoring + Alerts  
4. History & Review  
5. Settings & Support (including optional account)

---

## 5. Welcome & Safety Disclosure

### Purpose
- Set expectations
- Establish trust
- Clearly state non-medical nature

### Requirements
- Explicit statement: “This is not a medical device”
- User acknowledgment checkbox
- Calm, reassuring language
- No forced account creation

---

## 6. Setup Flow

### Step 1 - What do you call your baby?
- User enters baby's name or nickname for personalization

### Step 2 — Camera Placement
- Guide user to mount camera above crib
- Explain distance and angle
- Reassure: “You can adjust this later”

### Step 3 — Define Sleep Area
- User selects crib area in camera view
- Purpose: reduce false alerts
- Simple explanation (no technical jargon)

### Step 4 — Final Setup Check (Calibration)
- Title: **“Final setup check”**
- Purpose: validate camera placement and lighting
- Show progress indicator (not urgent)
- Explicit privacy message:
  “No video is recorded or saved. Analysis happens on your device.”

---

## 7. Live Monitoring (Main Screen)

### Purpose
- Show current monitoring state
- Provide reassurance
- Offer quick access to live view

### Key Elements
- Status card (e.g. “Liam’s sleep looks normal”)
- Live camera preview
- Movement & position indicators
- Safety alerts toggle
- Recent activity preview

### States
- Monitoring Active
- Monitoring Paused (camera disconnected, app closed, etc.)

---

## 8. Monitoring Paused State

This is **not a separate page**, but a state of the main monitoring screen.

### Requirements
- Replace normal status card with:
  “Monitoring paused”
- Clearly state reason (e.g. camera disconnected)
- Neutral colors (gray / soft blue)
- No alarm language
- Clear recovery action:
  “Reconnect camera”
- Reassurance:
  “Alerts will resume once monitoring is active.”

---

## 9. Safety Alerts

Alerts are **full-screen**, calm, and actionable.

### Alert Types & Severity

#### High Severity
- Baby rolled onto stomach
- Baby’s face may be covered

#### Medium Severity
- Unusual stillness detected
- Crying detected

### Alert Design Rules
- Observational language only
- No medical wording
- Primary action: “View live camera” or “I’m checking”
- Secondary actions are optional and low emphasis
- Alerts acknowledge “hands busy” scenarios (doing nothing is allowed)

---

## 10. History & Review

### Purpose
- Reassure parents retrospectively
- Avoid re-triggering anxiety

### Design Rules
- Light / white background
- Narrative tone (“Monitoring continued normally”)
- All events framed as resolved
- No scores, grades, or medical analysis

### Free vs Premium
- Free: last 24 hours
- Premium (future): extended history & summaries

---

## 11. Settings

### Sections
- Camera Calibration
- Safety Alerts
- Alert Preferences
- Privacy & Transparency
- Baby Profile
- Help & Support
- Account (optional)

### Design Rules
- Light background
- No fear-based language
- All changes reversible
- Clear explanations of effects

---

## 12. Alert Preferences

### Includes
- Alert sound selection (with preview)
- Volume control
- Override silent mode (recommended)
- Vibration patterns

### UX Rules
- One option marked “Recommended”
- Clear descriptions for each choice
- No implication that one choice is “safer”

---

## 13. Baby Profile

### Purpose
- Personalization only

### Fields
- Baby’s name (required)
- Sleep location (optional)
- Profile photo (optional, personalization only)

### Explicitly State
- Profile details do NOT affect monitoring or alerts

---

## 14. Privacy & Transparency

### Must Clearly State
- On-device processing
- No cloud storage by default
- Accounts required only for optional premium features

### Tone
- Plain language
- Non-marketing
- Trust-first

---

## 15. Help & Support

### Purpose
- Reassure users
- Provide clear next steps

### Content
- Common questions
- Troubleshooting
- Contact support
- Gentle reminder:
  “This app supports you but does not replace supervision.”

---

## 16. Accounts & Monetization (V1.1 Ready)

### Account Rules
- No account required for basic monitoring
- Account required only when enabling premium features
- Entry point lives in Settings (not main screen)

### Monetization Targets (Future)
- Extended history
- Night summaries
- Caregiver sharing
- Advanced alert customization

### Never Monetize
- Core safety alerts
- Live monitoring
- Monitoring paused warnings

---

## 17. Technical Expectations (High Level)

- On-device ML inference (e.g. Core ML)
- No continuous cloud video streaming
- Graceful handling of failure states
- Battery & thermal safeguards
- Clear separation of camera device vs parent device

---

## 18. What the LLM Must NOT Do

- Do NOT add medical claims
- Do NOT introduce panic UX
- Do NOT force account creation
- Do NOT upload or store video by default
- Do NOT invent features beyond this scope without explicit instruction

---

## 19. Success Criteria

The app is considered successful if:
- Parents feel calmer after using it
- Alerts prompt checking, not panic
- App Store reviewers find no medical or privacy violations
- Core safety works without sign-up or payment

---

**CribAlert is a safety companion, not a medical device.  
Trust, calmness, and clarity come first.**
