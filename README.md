# StudyQuest - Firebase Learning Project

A comprehensive Flutter application demonstrating Firebase integration with best practices for authentication, database management, real-time features, and cloud storage.

## 🚀 Features

### Authentication
- Email/Password authentication
- Phone number authentication with OTP
- Session management
- Protected routes

### User Profile
- Profile creation and management
- XP and level system
- Daily targets
- Streak tracking
- Activity history

### Quest System
- Create, read, update, delete quests
- Checklist and timer quest types
- Quest completion tracking
- XP rewards

### Real-time Study Rooms
- Create and join study rooms
- Real-time participant sync
- Presence tracking with `onDisconnect` (auto-offline on disconnect)
- Status updates (studying/break/offline)
- Participant management

### Gamification
- XP calculation on quest completion (server-authoritative via Cloud Functions)
- Level progression
- Daily target tracking
- Streak system
- Activity history

### Push Notifications (FCM)
- Permission handling (iOS + Android 13+)
- Foreground notification display
- Background message handler
- Per-user topic targeting

## 📦 Architecture

The project follows Clean Architecture principles:

```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── services/
│   ├── theme/
│   └── utils/
├── bindings/
│   └── initial_binding.dart
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── controllers/
│   ├── auth_controller.dart
│   ├── profile_controller.dart
│   ├── quest_controller.dart
│   └── room_controller.dart
├── features/
│   ├── auth/       # views/
│   ├── home/       # views/
│   ├── profile/
│   ├── quests/     # views/
│   └── study_room/ # views/
└── routes/
```

All application controllers live in `lib/controllers/`. Views remain grouped
under `lib/features/`; shared dependencies are registered in
`lib/bindings/initial_binding.dart`. Controllers in `lib/controllers/` are
implementations, not re-export shims.

## 🔧 Technologies

- **Flutter**: Cross-platform UI framework
- **GetX**: State management, routing, and dependency injection
- **Firebase Core**: Firebase initialization
- **Firebase Auth**: Authentication (email/password, Google, phone OTP)
- **Cloud Firestore**: NoSQL database
- **Firebase Realtime Database**: Real-time data sync & presence
- **Firebase Storage**: File storage
- **Firebase App Check**: App integrity protection
- **Firebase Cloud Messaging**: Push notifications
- **Cloud Functions**: Server-side business logic (XP, validation, idempotency)
- **Cloud SQL PostgreSQL**: Relational data (FK, JOIN, index, transaction)
- **Dartz**: Functional programming utilities

## 📋 Firebase Services

### Firestore Collections
- `users`: User profiles (XP/level/streak owned by Cloud Functions)
- `quests`: User quests (with server-side `xpAwarded` flag)
- `activities`: Activity history (created only by Cloud Functions)
- `achievements`: Achievement definitions
- `user_achievements`: User achievements

### Realtime Database Structure
- `rooms/{roomId}`: Study rooms
- `rooms/{roomId}/participants/{userId}`: Room participants (with presence via `onDisconnect`)

### Cloud SQL (PostgreSQL)
- `users`, `friendships`, `study_sessions`, `user_stats`, `xp_events`
- Accessed only through Cloud Functions — see [docs/CLOUD_SQL.md](docs/CLOUD_SQL.md)

### Storage Buckets
- `users/{userId}/`: User profile pictures
- `quests/{questId}/`: Quest attachments

## 🔐 Security

### Implemented
- Firestore Security Rules (server-authoritative XP/level/streak)
- Realtime Database Security Rules
- Firebase Storage Security Rules
- Firebase App Check (debug/Play Integrity/DeviceCheck)
- Cloud Functions for critical logic (XP, streak, validation, idempotency)
- Protected routes and input validation

### Planned
- Rate limiting on callable endpoints
- Enhanced secrets management

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run widget tests
flutter test test/widget_test.dart

# Static analysis
flutter analyze
```

## 📝 Development Phases

The project is developed in phases following the [Development Plan](docs/DEVELOPMENT_PLAN.md):

- ✅ Phase 0: Project Planning & Repository Setup
- ✅ Phase 1: Firebase Setup & Flutter Integration
- ✅ Phase 2: Email/Password Authentication
- ✅ Phase 3: User Profile & Firestore Foundation
- ✅ Phase 4: Quest System
- ✅ Phase 5: XP, Level, Streak & Activity
- ✅ Phase 6: Phone Number Authentication
- ✅ Phase 7: Realtime Study Room
- ✅ Phase 8: Firebase Storage
- ✅ Phase 9: Firebase App Check
- ✅ Phase 10: Cloud Functions (Documentation)
- ✅ Phase 11: Cloud SQL PostgreSQL (Documentation)
- ✅ Phase 12: Security Hardening (Documentation)
- ✅ Phase 13: Testing & Emulator Suite (Documentation)
- ✅ Phase 14: Documentation (In Progress)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>= 3.11.5)
- Firebase CLI
- Firebase project

### Setup

1. Clone the repository
```bash
git clone <repository-url>
cd flutter-with-firebase-project
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
```bash
flutterfire configure
```

4. Run the app
```bash
flutter run
```

## 📄 Documentation

- [Architecture](docs/ARCHITECTURE.md)
- [Database](docs/DATABASE.md)
- [Firebase Setup](docs/FIREBASE.md)
- [Security](docs/SECURITY.md)
- [Development](docs/DEVELOPMENT.md)
- [Cloud Functions](docs/CLOUD_FUNCTIONS.md)
- [Cloud SQL](docs/CLOUD_SQL.md)
- [Security Hardening](docs/SECURITY_HARDENING.md)
- [Testing](docs/TESTING.md)

## 📄 License

This project is for learning purposes.

## 🤝 Contributing

This is a learning project. Contributions are welcome but please follow the existing code style and architecture.
