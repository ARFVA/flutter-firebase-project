# StudyQuest

A gamified study tracking application built with Flutter and Firebase.

## Project Overview

StudyQuest is a productivity and study-tracking application based on gamification. Users can:

- Register and log in
- Use phone number authentication
- Create and complete quests
- Earn XP and level up
- Maintain daily streaks
- Track activity history
- Join realtime study rooms
- Upload profile pictures and quest proofs

## Tech Stack

### Frontend
- Flutter
- Dart
- GetX (State Management)
- Responsive UI
- Android-first (Flutter Web compatible)

### Firebase
- Firebase Authentication
- Firebase App Check
- Cloud Firestore
- Firebase Realtime Database
- Firebase Storage
- Cloud Functions
- Firebase Emulator Suite

### SQL
- Cloud SQL PostgreSQL

### Development
- Firebase CLI
- FlutterFire CLI
- Git
- GitHub

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── services/
│   └── utils/
│
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
│
├── features/
│   ├── auth/
│   ├── home/
│   ├── quests/
│   ├── profile/
│   ├── achievements/
│   ├── activity/
│   └── study_room/
│
├── routes/
│
└── main.dart
```

## Development Phases

This project follows a phased development approach. See [StudyQuest_Firebase_Phased_Development_Plan.md](StudyQuest_Firebase_Phased_Development_Plan.md) for detailed phase information.

- Phase 0: Project Planning & Repository Setup ✅
- Phase 1: Firebase Setup & Flutter Integration
- Phase 2: Email/Password Authentication
- Phase 3: User Profile & Firestore Foundation
- Phase 4: Quest System
- Phase 5: XP, Level, Streak & Activity
- Phase 6: Phone Number Authentication
- Phase 7: Realtime Study Room
- Phase 8: Firebase Storage
- Phase 9: Firebase App Check
- Phase 10: Cloud Functions
- Phase 11: Cloud SQL PostgreSQL
- Phase 12: Security Hardening
- Phase 13: Testing & Emulator Suite
- Phase 14: Documentation & Final Review

## Getting Started

### Prerequisites

- Flutter SDK (3.11.5 or higher)
- Dart SDK
- Firebase CLI
- FlutterFire CLI
- Android Studio / VS Code
- Git

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd flutter-with-firebase-project
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Firebase Setup

Firebase setup will be completed in Phase 1. This includes:
- Creating a Firebase project
- Configuring Firebase CLI
- Connecting Flutter to Firebase
- Setting up required Firebase platforms

## Development Branches

Recommended branches for development:
- `main` - Production code
- `feature/firebase-setup` - Firebase integration
- `feature/auth` - Authentication features
- `feature/firestore` - Firestore integration
- `feature/quest-system` - Quest functionality
- `feature/phone-auth` - Phone authentication
- `feature/realtime-db` - Realtime database
- `feature/storage` - Firebase Storage
- `feature/app-check` - App Check integration
- `feature/functions` - Cloud Functions
- `feature/cloud-sql` - PostgreSQL integration
- `feature/security` - Security hardening
- `feature/testing` - Testing implementation

## Documentation

- [Phased Development Plan](StudyQuest_Firebase_Phased_Development_Plan.md)
- [Architecture Documentation](ARCHITECTURE.md) (To be created)
- [Firebase Setup Guide](FIREBASE.md) (To be created)
- [Database Schema](DATABASE.md) (To be created)
- [Security Guidelines](SECURITY.md) (To be created)
- [Development Guide](DEVELOPMENT.md) (To be created)

## Learning Objectives

This project is designed to teach:
1. Firebase Authentication
2. Firebase Phone Authentication
3. Firebase App Check
4. Cloud Firestore
5. Firebase Realtime Database
6. Firebase Storage
7. Cloud Functions
8. Cloud SQL PostgreSQL
9. Firebase Security Rules
10. Firebase Emulator Suite

## Contributing

This is a learning project. Follow the phased development plan and implement one phase at a time.

## License

This project is for educational purposes.
