# Firebase Setup Guide

## Prerequisites

- Firebase account (https://console.firebase.google.com/)
- Node.js installed (for Firebase CLI)
- Android Studio / Xcode configured
- Flutter SDK installed

## Installation Steps

### 1. Install Firebase CLI

```bash
npm install -g firebase-tools
```

Verify installation:
```bash
firebase --version
```

### 2. Login to Firebase

```bash
firebase login
```

This will open a browser window to authenticate with your Google account.

### 3. Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

Add to PATH (if needed):
```bash
# On Windows
$env:PATH += ";$env:LOCALAPPDATA\Pub\Cache\bin"

# On macOS/Linux
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

Verify installation:
```bash
flutterfire --version
```

### 4. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name (e.g., "studyquest-firebase")
4. Follow the setup wizard
5. Enable Google Analytics (optional but recommended)

### 5. Connect Flutter to Firebase

Navigate to your project directory and run:

```bash
flutterfire configure
```

This command will:
- List your Firebase projects
- Let you select the project
- Configure Firebase for all platforms (Android, iOS, Web, macOS, Windows, Linux)
- Generate `firebase_options.dart` file

### 6. Platform-Specific Configuration

#### Android Configuration

The FlutterFire CLI will automatically configure Android. You may need to:

1. Ensure `android/app/build.gradle` has the Google Services plugin
2. Download `google-services.json` from Firebase Console
3. Place it in `android/app/`

#### iOS Configuration

The FlutterFire CLI will automatically configure iOS. You may need to:

1. Download `GoogleService-Info.plist` from Firebase Console
2. Add it to your iOS project in Xcode
3. Ensure bundle identifier matches Firebase configuration

#### Web Configuration

The FlutterFire CLI will automatically configure web by updating `web/index.html`.

### 7. Initialize Firebase in App

Update `lib/main.dart` to initialize Firebase:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const StudyQuestApp());
}
```

### 8. Verify Firebase Initialization

Run the app:
```bash
flutter run
```

Check the console for successful Firebase initialization. You should see:
```
FirebaseCore: Successfully initialized Firebase
```

## Firebase Services Setup

This project will use the following Firebase services (to be configured in later phases):

- ✅ Firebase Core (Phase 1)
- ⏳ Firebase Authentication (Phase 2, 6)
- ⏳ Cloud Firestore (Phase 3)
- ⏳ Firebase Realtime Database (Phase 7)
- ⏳ Firebase Storage (Phase 8)
- ⏳ Firebase App Check (Phase 9)
- ⏳ Cloud Functions (Phase 10)

## Firebase Emulator Suite

For local development, install and configure the Firebase Emulator Suite (Phase 13):

```bash
firebase init emulators
```

Start emulators:
```bash
firebase emulators:start
```

## Important Notes

- **Never commit `firebase_options.dart`** - it contains sensitive configuration
- **Never commit `google-services.json`** - Android Firebase configuration
- **Never commit `GoogleService-Info.plist`** - iOS Firebase configuration
- These files are already in `.gitignore`

## Troubleshooting

### Firebase CLI not found
Ensure Node.js is installed and the Firebase CLI is in your PATH.

### FlutterFire CLI not found
Ensure Dart is in your PATH and the global activation worked.

### Platform configuration issues
- For Android: Check `android/app/build.gradle` and `google-services.json`
- For iOS: Check bundle identifier and `GoogleService-Info.plist`
- For Web: Check `web/index.html` script tags

### Initialization errors
- Verify Firebase project exists
- Check platform-specific configuration files
- Ensure bundle identifiers match Firebase console
- Check console logs for specific error messages

## Current Status

- ✅ Firebase Core dependency added
- ✅ Setup documentation completed
- ⏳ Firebase CLI installation (user action required)
- ⏳ FlutterFire CLI installation (user action required)
- ⏳ Firebase project creation (user action required)
- ⏳ Flutter-Firebase connection (user action required)
- ⏳ Firebase initialization verification (after configuration)

## Next Steps

After completing the setup above:
1. Run `flutterfire configure` to generate `firebase_options.dart`
2. Update `lib/main.dart` to initialize Firebase
3. Run the app to verify initialization
4. Proceed to Phase 2: Email/Password Authentication
