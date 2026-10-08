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
- Real-time presence tracking
- Status updates (studying/break/offline)
- Participant management

### Gamification
- XP calculation on quest completion
- Level progression
- Daily target tracking
- Streak system
- Activity history

## 📦 Architecture

The project follows Clean Architecture principles:

```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   └── utils/
├── data/
│   ├── models/
│   ├── datasources/
│   └── repositories/
├── features/
│   ├── auth/
│   ├── home/
│   ├── quests/
│   ├── profile/
│   └── study_room/
└── routes/
```

## 🔧 Technologies

- **Flutter**: Cross-platform UI framework
- **GetX**: State management and routing
- **Firebase Core**: Firebase initialization
- **Firebase Auth**: Authentication
- **Cloud Firestore**: NoSQL database
- **Firebase Realtime Database**: Real-time data sync
- **Firebase Storage**: File storage
- **Firebase App Check**: App integrity
- **Dartz**: Functional programming utilities

## 📋 Firebase Services

### Firestore Collections
- `users`: User profiles
- `quests`: User quests
- `activities`: Activity history
- `achievements`: Achievement definitions
- `user_achievements`: User achievements

### Realtime Database Structure
- `rooms/{roomId}`: Study rooms
- `rooms/{roomId}/participants/{userId}`: Room participants

### Storage Buckets
- `users/{userId}/`: User profile pictures
- `quests/{questId}/`: Quest attachments

## 🔐 Security

### Implemented
- Firestore Security Rules
- Realtime Database Security Rules
- Firebase Storage Security Rules
- Firebase App Check
- Protected routes
- Input validation

### Planned
- Cloud Functions for critical logic
- Rate limiting
- Server-side validation
- Secrets management

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

The project is developed in phases following the [Phased Development Plan](StudyQuest_Firebase_Phased_Development_Plan.md):

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
