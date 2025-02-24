# remote_mh

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

### **🔹 DB changes
- **Database Version Update**: Upgraded from **version 2 to 3** to support new features.
- **New Column (`emotion_data`)**: Added to `TestResults` table to store extra emotional data.
- **Improved Logging**: Added `print` statements for better debugging and tracking.
- **Updated `insertTestResult`**: Now requires `emotionData` as a parameter.
- **Enhanced Database Upgrades**: Migration now ensures `emotion_data` is added when upgrading from v2 to v3.
- **New `checkTableStructure` Method**: Helps debug table structures.
- **Updated Queries**: `getUserScores` now includes `emotion_data`.
# Action changes 
### **🔹 Action Flow in `CameraScreen`**

- **On Start:** Initializes camera & loads emotion model.
- **Switch Camera Button:** Toggles between front & back cameras.
- **Capture Button:** Takes a selfie → Detects emotion → Shows a dialog.
    - Click **"Proceed to Test"** → Closes dialog & navigates to `DepressionTestScreen`.
- **Take Test Button:** Skips capture & directly opens `DepressionTestScreen`.
- **Emotion Text:** Updates dynamically when emotion is detected.
simple way

### **🔹 Action Flow in `Profile creation

1. **Screen opens** → Loads user profile (if it exists).
2. **If profile exists** → Fills in name and age.
3. **User enters details** → Types name and age.
4. **Clicks "Save Profile"** → Saves or updates profile.
5. **If valid** → Shows a welcome message and goes to home screen.
6. **If invalid** → Shows an error message.
### **🔹 Pub spec 
1. Dependency Updates**

- **Updated** `permission_handler` to a newer version.
- **Added** new packages:
    - `win32` (Windows support)
    - `tflite_flutter` (Machine learning)
    - `image` (Image processing)
    - `google_mlkit_face_detection` (Face recognition)

2. Asset Changes**

- **Added** new files:
    - `model.tflite` (ML model)
    - `labels.txt` (Labels for ML)

