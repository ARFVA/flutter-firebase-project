# Changelog

All notable changes to **StudyQuest** are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [0.4.0-beta.1] - 2026-10-08

### Added
- Activity model for tracking user actions
- GamificationUtils with XP and level calculation
- ActivityRemoteDataSource for Firestore operations
- ActivityRepository with clean architecture
- ProfileController for user profile management
- XP calculation on quest completion
- Level calculation formula (Level = floor(sqrt(XP/100)) + 1)
- Level up notifications
- Activity history recording
- Daily XP tracking
- Streak calculation (simplified - server-side in Phase 10)
- Home screen redesign with stats display
- Enhanced Firestore Security Rules to prevent XP manipulation

### Changed
- Updated QuestController to integrate XP system
- Updated home screen to show user stats (XP, level, streak)
- Updated Firestore Security Rules for users and activities
- Activities are now immutable (prevent updates)

### Fixed
- Type casting issue in activity datasource

### Security
- Security rules prevent direct manipulation of xp, level, and streak from client
- Activities are immutable once created
- User profile updates restricted to safe fields only

## [0.3.0-beta.1] - 2026-10-08

### Added
- Quest system with CRUD operations
- QuestModel with support for checklist and timer quest types
- QuestRemoteDataSource for Firestore operations
- QuestRepository with clean architecture
- QuestController with GetX state management
- QuestListScreen with active/completed tabs
- CreateQuestScreen with form validation
- Quest completion functionality
- UUID dependency for unique quest IDs
- Routing for quest screens
- Quest integration in home screen
- Enhanced Firestore Security Rules for quests

### Changed
- Updated main.dart to initialize quest dependencies
- Updated firestore.rules with quest-specific security rules
- Improved security rules to prevent unauthorized quest modifications

### Fixed
- TabBar dynamic text rendering issue

## [0.2.0-beta.1] - 2026-10-08

### Added
- Firebase Authentication (email/password)
- User registration and login screens
- User logout functionality
- Password reset functionality
- Protected home screen with authentication middleware
- User model for authentication
- Auth repository with clean architecture
- Auth controller with GetX state management
- Routing with GetX
- Firestore dependency
- User profile model
- Firestore datasource
- User profile repository
- .env.example for environment configuration
- version.json for version tracking
- CHANGELOG.md for change tracking
- docs/ folder for documentation

### Changed
- Updated main.dart to use routing and dependency injection
- Updated analysis_options.yaml to allow constant identifier names
- Restructured documentation (moved to docs/ folder in progress)

### Fixed
- Firebase initialization graceful fallback when not configured

## [0.1.0-beta.1] - 2026-10-08

### Added
- Initial Flutter project setup
- GetX state management integration
- Clean architecture structure (core, data, features layers)
- App constants and Firebase constants
- Error handling classes (exceptions and failures)
- Firebase Core dependency
- Git repository initialization
- .gitignore with Firebase secrets exclusion
- Initial documentation (README.md, ARCHITECTURE.md, DEVELOPMENT.md, FIREBASE.md, DATABASE.md, SECURITY.md)

### Changed
- Updated main.dart with GetX integration
- Updated tests to match new app structure
