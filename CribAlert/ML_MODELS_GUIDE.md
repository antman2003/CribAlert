# CribAlert Custom ML Models Guide

This guide explains how to create and integrate custom Core ML models for improved detection accuracy.

## Overview

CribAlert supports three custom ML models:

| Model File | Purpose | Fallback |
|------------|---------|----------|
| `BabyPositionClassifier.mlmodel` | Detect if baby is on back, side, or stomach | Vision body pose |
| `BabyCryingClassifier.mlmodel` | Detect if baby is crying | Audio level analysis |
| `FaceCoverageDetector.mlmodel` | Detect if baby's face is covered | Vision face detection |

**The app works without custom models** - it uses Apple's built-in Vision and audio frameworks as fallbacks.

---

## Creating Models with Create ML

### Prerequisites
- Mac with Xcode installed
- macOS Monterey or later

### Step 1: Open Create ML

```bash
# Option 1: From Terminal
open -a "Create ML"

# Option 2: From Xcode
# Xcode → Open Developer Tool → Create ML
```

---

## Model 1: BabyPositionClassifier

### Purpose
Classifies baby's sleeping position from camera images.

### Training Data Required

Organize images into folders:

```
TrainingData/
├── on_back/
│   ├── back_001.jpg
│   ├── back_002.jpg
│   └── ... (50-100 images)
├── on_side/
│   ├── side_001.jpg
│   ├── side_002.jpg
│   └── ... (50-100 images)
├── on_stomach/
│   ├── stomach_001.jpg
│   ├── stomach_002.jpg
│   └── ... (50-100 images)
└── unknown/
    └── ... (20-30 images of empty crib, unclear views)
```

### Image Guidelines
- **Source**: Top-down view of crib (how camera would see it)
- **Resolution**: At least 224x224 pixels
- **Variety**: Different lighting, blankets, clothing
- **Format**: JPEG or PNG

### Create ML Steps

1. **New Project** → **Image Classification**
2. **Training Data**: Drag your `TrainingData` folder
3. **Parameters**:
   - Maximum Iterations: 25
   - Augmentations: Enable all (flip, rotate, blur, etc.)
4. **Click "Train"**
5. **Evaluate** with test images
6. **Output** → Name it `BabyPositionClassifier`
7. **Get** → Save as `BabyPositionClassifier.mlmodel`

### Expected Output Classes
- `on_back`
- `on_side`
- `on_stomach`
- `unknown`

---

## Model 2: BabyCryingClassifier

### Purpose
Classifies audio as crying or not crying.

### Training Data Required

Organize audio clips into folders:

```
AudioData/
├── crying/
│   ├── cry_001.wav
│   ├── cry_002.wav
│   └── ... (50-100 clips)
└── not_crying/
    ├── silence_001.wav
    ├── talking_001.wav
    ├── tv_001.wav
    ├── music_001.wav
    └── ... (50-100 clips)
```

### Audio Guidelines
- **Duration**: 3-10 seconds per clip
- **Format**: WAV or M4A (16kHz sample rate recommended)
- **Variety**: Different babies, volumes, environments
- **"not_crying" examples**:
  - Silence
  - Adults talking
  - TV/music playing
  - Other baby sounds (cooing, laughing)

### Create ML Steps

1. **New Project** → **Sound Classification**
2. **Training Data**: Drag your `AudioData` folder
3. **Parameters**:
   - Maximum Iterations: 25
4. **Click "Train"**
5. **Evaluate** with test audio
6. **Output** → Name it `BabyCryingClassifier`
7. **Get** → Save as `BabyCryingClassifier.mlmodel`

### Expected Output Classes
- `crying`
- `not_crying`

---

## Model 3: FaceCoverageDetector

### Purpose
Detects if baby's face may be covered by blanket/object.

### Training Data Required

```
FaceData/
├── clear/
│   └── ... (face clearly visible)
├── partially_covered/
│   └── ... (face partially obscured)
└── covered/
    └── ... (face not visible, covered by blanket)
```

### Create ML Steps

Same as BabyPositionClassifier but with face coverage categories.

---

## Adding Models to Xcode

### Step 1: Drag Model into Project

1. Open `CribAlert.xcodeproj` in Xcode
2. Drag `.mlmodel` files into `CribAlert/CribAlert/Resources/`
3. In the dialog:
   - ✅ Copy items if needed
   - ✅ Add to target: CribAlert

### Step 2: Verify in Xcode

Click on the `.mlmodel` file in Xcode to see:
- Model type (Image Classifier / Sound Classifier)
- Input/Output specifications
- Model size

### Step 3: Build and Run

The app automatically detects and uses models:

```
╔════════════════════════════════════════╗
║       CribAlert ML Model Status        ║
╠════════════════════════════════════════╣
║ Position Detection:  ✅ Custom Model   ║
║ Crying Detection:    ✅ Custom Model   ║
║ Face Coverage:       ⚡ Vision Fallback║
╚════════════════════════════════════════╝
```

---

## Model Specifications

### BabyPositionClassifier

```
Type: Image Classifier
Input: 224x224 RGB image
Output: Classification + Confidence
Classes: on_back, on_side, on_stomach, unknown
```

### BabyCryingClassifier

```
Type: Sound Classifier
Input: Audio buffer (15600 samples at 15.6kHz)
Output: Classification + Confidence
Classes: crying, not_crying
```

### FaceCoverageDetector

```
Type: Image Classifier
Input: 224x224 RGB image
Output: Classification + Confidence
Classes: clear, partially_covered, covered
```

---

## Testing Your Models

### In Xcode Preview

Click `.mlmodel` file → Preview tab → Drag test images/audio

### In App

1. Build and run on device/simulator
2. Check console for model loading status
3. Monitor detection results in MonitorView

---

## Tips for Better Models

### Image Classifiers
1. **More data = better accuracy** (aim for 100+ images per class)
2. **Include edge cases**: Poor lighting, partially visible baby
3. **Use augmentation**: Create ML can flip, rotate, blur automatically
4. **Test with real scenarios**: Different blankets, clothing, time of day

### Sound Classifiers
1. **Record in the nursery**: Background noise matters
2. **Multiple babies**: Different cry sounds
3. **Various volumes**: Soft whimpers to loud cries
4. **Clean labels**: Make sure "not_crying" has zero crying

---

## Troubleshooting

### Model Not Loading

Check Xcode console for errors:
```
⚠️ BabyPositionClassifier model found but failed to load: ...
```

Common fixes:
- Ensure model is added to target
- Clean build folder (Cmd+Shift+K)
- Check model format (must be .mlmodel)

### Low Accuracy

1. Add more training data
2. Check for mislabeled samples
3. Increase training iterations
4. Enable more augmentations

### Model Too Large

- Use "Reduce Model Size" option in Create ML
- Choose "Neural Network Classifier" over "Full"

---

## Resources

- [Apple Create ML Documentation](https://developer.apple.com/documentation/createml)
- [Core ML Models](https://developer.apple.com/machine-learning/models/)
- [Vision Framework](https://developer.apple.com/documentation/vision)
- [Sound Analysis](https://developer.apple.com/documentation/soundanalysis)
