# Testing & Emulator Suite Documentation

## Firebase Emulator Suite

The Firebase Emulator Suite allows local development and testing without affecting production data.

## Emulators Used

### Authentication Emulator
- Simulates Firebase Auth
- Supports email/password and phone auth
- No real network calls
- Instant operations

### Firestore Emulator
- Simulates Cloud Firestore
- Runs in-memory
- Supports all Firestore operations
- Security rules testing

### Realtime Database Emulator
- Simulates Firebase Realtime Database
- Real-time event testing
- Connection management testing

### Storage Emulator
- Simulates Firebase Storage
- File upload/download testing
- Security rules testing

## Setup

### Install Emulator Suite
```bash
firebase emulators:start
```

### Configuration
Create `firebase.json`:
```json
{
  "emulators": {
    "auth": { "port": 9099 },
    "firestore": { "port": 8080 },
    "database": { "port": 9000 },
    "storage": { "port": 9199 },
    "ui": { "enabled": true }
  }
}
```

### Flutter Configuration
In `lib/firebase_options.dart`:
```dart
const firebaseOptions = FirebaseOptions(
  apiKey: 'test-api-key',
  authDomain: 'test-project.firebaseapp.com',
  projectId: 'test-project',
  storageBucket: 'test-project.appspot.com',
  // Other emulator-specific configs
);
```

## Unit Tests

### Model Tests
- Test serialization/deserialization
- Test validation logic
- Test copyWith methods

### Repository Tests
- Mock datasources
- Test error handling
- Test success scenarios

### Controller Tests
- Mock repositories
- Test state management
- Test error states

## Integration Tests

### Widget Tests
- Test UI rendering
- Test user interactions
- Test navigation

### End-to-End Tests
- Test complete user flows
- Test authentication flows
- Test quest completion flows

## Running Tests

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### With Emulators
```bash
firebase emulators:start --only firestore,auth
flutter test
```

## CI/CD Integration

Add to `.github/workflows/test.yml`:
```yaml
name: Test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
```
