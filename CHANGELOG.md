# Changelog

Semua perubahan penting dalam projek **StudyQuest**.
Format ini berdasar [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.1.0-beta.3] - 2026-10-16

### Changed
- Centralized GetX dependency registration in `InitialBinding`
- Moved controller implementations into the top-level `lib/controllers/` directory and documented the shared controller structure
- Decoupled route constants from `app_pages.dart` using a regular import

### Removed
- Removed the unused `PrimaryButton` widget after confirming it had no call sites

## [1.1.0-beta.2] - 2026-10-16

### Fixed
- Daily XP progress now loads through the activity repository and queries Firestore timestamps for the current local day
- Quest XP remains server-authoritative and updates from the profile snapshot instead of optimistic client-side increments
- Profile loading now surfaces repository failures instead of presenting a default profile as a successful load

## [1.1.0-beta.1] - 2026-10-15

### Added
- Firebase App Check aktif (debug provider untuk debug, Play Integrity/DeviceCheck untuk release)
- Presence Realtime Database dengan `onDisconnect()` (user otomatis offline saat koneksi terputus)
- FCM background handler (`@pragma('vm:entry-point')`) dan tampilan notifikasi foreground via `flutter_local_notifications`
- Penyimpanan FCM token ke profil user + subscribe topic `user_{uid}` untuk push terarah
- Cloud Functions idempoten: `onQuestComplete` dengan transaction + guard `xpAwarded` (XP tidak mungkin dobel)
- Logika streak server-side (`lastStreakDate`) dan `dailyStreakCheck` yang benar-benar me-reset streak basi
- Validasi server-side pada pembuatan user (panjang displayName, sanitasi email)
- Cloud SQL PostgreSQL: skema relasional (`users`, `friendships`, `study_sessions`, `user_stats`, `xp_events`) dengan foreign key, index, unique constraint
- Callable Functions `recordStudySession` (transaction + idempotency key) dan `getFriendLeaderboard` (JOIN + index)
- Sync trigger `syncUserToSql` untuk menjaga baris `users` di Cloud SQL konsisten dengan Firebase Auth
- Feature flag `ENABLE_CLOUD_SQL` (default false) sesuai SOP environment gating
- Theme Material 3 terpusat (`core/theme/app_theme.dart`) dengan indigo-violet gradient
- Stream reaktif profil user (`watchUserProfile`) sehingga XP/level/streak ter-update live dari server
- Permission Android `POST_NOTIFICATIONS` dan `INTERNET` untuk FCM

### Changed
- Alur penyelesaian quest menjadi server-authoritative: klien hanya menandai `isCompleted`, Cloud Function yang menghitung XP/level/streak
- Firestore Security Rules memblokir klien mengubah `xp`, `level`, `streak`, `lastStreakDate`, `xpAwarded`, `createdAt`, `uid`
- Realtime Database rules mematikan akses baca publik dan mengizinkan presence write per-participant
- Login screen didesain ulang dengan gradient hero, kartu glassmorphism, dan tombol sosial yang konsisten
- `main.dart` mengaktifkan App Check dan memakai FCMService.instance (menghilangkan duplikasi init)
- Model `UserProfileModel`, `ActivityModel`, `ParticipantModel` menangani timestamp Firestore (String/ Timestamp/epoch) dengan aman

### Removed
- Perhitungan XP/klien-side streak (duplikasi logika) — kini seluruhnya di Cloud Functions
- Tombol & method `resetXP` debug dari home screen dan ProfileController

### Security
- App Check melindungi Firestore, Realtime Database, Storage, dan Cloud Functions dari abuse
- Klien tidak lagi bisa memanipulasi XP/level/streak melalui aturan security rules
- Aktivitas dibuat hanya oleh Cloud Functions (klien read-only)

## [1.0.0-beta.1] - 2026-10-08

### Added
- Firebase Storage dependency and integration
- Firebase App Check for app integrity
- StorageRemoteDataSource for file operations
- StorageRepository with clean architecture
- Firebase Storage security rules
- Cloud Functions documentation and implementation
- Cloud SQL PostgreSQL documentation
- Security hardening documentation
- Testing and emulator suite documentation
- Updated README with comprehensive project info
- Cloud Functions for server-side logic (onQuestComplete, onUserCreated, dailyStreakCheck)
- Cloud Functions package.json configuration

### Changed
- Updated main.dart to initialize Firebase Storage and App Check
- Updated home screen to reflect Phase 8 completion
- Added functions/ directory for Cloud Functions

### Security
- Firebase Storage security rules for user and quest files
- Firebase App Check integration (debug provider for development)
- Comprehensive security documentation
- Cloud Functions for critical server-side logic

### Documentation
- Complete project documentation in docs/
- Cloud Functions implementation guide
- Cloud SQL PostgreSQL architecture
- Security hardening guidelines
- Testing and emulator suite setup
- Updated README with full feature list

### Architecture
- Cloud Functions for XP calculation
- Cloud Functions for user profile creation
- Cloud Functions for daily streak checks
- Server-side validation architecture documented

## [0.6.0-beta.1] - 2026-10-08

### Added
- Firebase Realtime Database dependency
- RoomModel for study rooms
- ParticipantModel for room participants
- RealtimeDBRemoteDataSource for Realtime DB operations
- RoomRepository with clean architecture
- RoomController with GetX state management
- StudyRoomScreen with real-time participant updates
- Room creation and joining functionality
- Participant status tracking (studying/break/offline)
- Real-time presence updates
- Routing for study room screen
- Realtime DB security rules
- Study room integration in home screen

### Changed
- Updated main.dart to initialize Realtime DB dependencies
- Updated home screen to include study room button

### Security
- Realtime DB security rules for rooms and participants
- Room ownership enforcement
- Participant read/write restrictions

## [0.5.0-beta.1] - 2026-10-08

### Added
- Phone number authentication screens
- OTP verification screen
- Phone auth integration in AuthController
- OTP sending and verification logic
- Phone number field in login screen
- Routing for phone auth and OTP screens
- Phone number field in UserModel and UserProfileModel
- Phone auth error handling

### Changed
- Updated AuthRepository to support phone auth
- Updated AuthRemoteDataSource with phone auth methods
- Updated UserModel to include phoneNumber
- Updated UserProfileModel to include phoneNumber
- Profile creation now supports phone number

### Fixed
- Async callback handling for OTP sending

### Security
- Phone auth uses Firebase's built-in security
- OTP codes are handled securely

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
