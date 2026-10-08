# Changelog

All notable changes to **StudyQuest** are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

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
