# StudyQuest Architecture

## Flutter Architecture

### Clean Architecture Pattern

StudyQuest follows a Clean Architecture pattern with clear separation of concerns:

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│  (UI, Controllers, GetX Controllers)    │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│          Domain Layer                   │
│  (Entities, Use Cases, Repositories)   │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│           Data Layer                    │
│  (Data Sources, Models, DTOs)          │
└─────────────────────────────────────────┘
```

### Directory Structure

#### Core Layer (`lib/core/`)
- **constants/**: App-wide constants (API endpoints, Firebase collection names, etc.)
- **errors/**: Custom exceptions and failures
- **services/**: Shared services (networking, logging, etc.)
- **utils/**: Utility functions and helpers

#### Bindings (`lib/bindings/`)
- **initial_binding.dart**: Registers shared data sources, repositories, and feature controllers through GetX.

#### Data Layer (`lib/data/`)
- **datasources/**: Remote and local data sources (Firebase, SharedPreferences, etc.)
- **models/**: Data models and DTOs
- **repositories/**: Repository implementations

#### Controllers (`lib/controllers/`)
- Contains the controller implementations for auth, profile, quests, and study rooms.
- Controllers are grouped in this top-level folder rather than duplicated inside feature directories.

#### Features Layer (`lib/features/`)
Features contain their user-facing views and are organized by product capability:
```
features/
├── auth/
│   └── views/
├── home/
│   └── views/
├── profile/
├── quests/
│   └── views/
└── study_room/
    └── views/
```

Controller files in `lib/controllers/` contain the actual implementations.
Views import those implementations directly. Application dependencies are
registered in `lib/bindings/`.

### State Management

StudyQuest uses **GetX** for state management:
- Reactive state management with GetX observables
- Route management
- Dependency injection
- Navigation

## Firebase Architecture

### Service Responsibilities

Each Firebase service has a clear, defined responsibility:

| Service | Responsibility |
|---------|----------------|
| Firebase Auth | Identity and authentication |
| Firestore | Main document-oriented application data |
| Realtime Database | Realtime presence and live study room state |
| Storage | Uploaded files (avatars, quest proofs) |
| App Check | App/device integrity protection |
| Cloud Functions | Trusted server-side business logic |
| PostgreSQL | Relational SQL data and SQL learning |
| Emulator Suite | Local Firebase development/testing |

### Firestore Collections

#### Users Collection
```
users/{userId}
```
- User profile data
- XP, level, streak information
- Daily target settings

#### Quests Collection
```
quests/{questId}
```
- Quest definitions
- Quest metadata
- Completion status

#### Activities Collection
```
activities/{activityId}
```
- Activity history
- XP changes
- Timestamps

#### Achievements Collection
```
achievements/{achievementId}
```
- Achievement definitions
- Criteria for unlocking

#### User Achievements Collection
```
user_achievements/{userAchievementId}
```
- User-specific achievement unlocks
- Unlock timestamps

### Realtime Database Structure

```
rooms/
  {roomId}/
    participants/
      {userId}/
        displayName
        status
        lastSeen
```

### Storage Paths

#### Profile Avatars
```
/users/{userId}/avatar/
```

#### Quest Proofs
```
/users/{userId}/proofs/{questId}/
```

## Data Flow

### Authentication Flow
```
User Input
  ↓
Auth Controller
  ↓
Auth Repository
  ↓
Firebase Auth Service
  ↓
Firebase Authentication
```

### Quest Completion Flow (Phase 10+)
```
User Input
  ↓
Quest Controller
  ↓
Quest Repository
  ↓
Firestore transaction
  ↓
Security rules validate ownership, immutable reward, and one-time award
  ↓
Quest + profile XP/level + activity updated atomically
  ↓
Response to Client
```

### File Upload Flow
```
User Input
  ↓
Image Picker
  ↓
Storage Controller
  ↓
Storage Repository
  ↓
Firebase Storage
  ↓
Download URL
  ↓
Firestore Update
```

## Cloud Functions Architecture

### Business Logic Functions

#### Quest Completion Validation
- Validates user identity
- Validates quest ownership
- Prevents duplicate completion
- Calculates XP server-side
- Updates user progress
- Creates activity record

#### XP and Level Calculation
- Deterministic level formula
- Server-side validation
- Idempotent operations

#### Streak Calculation
- Daily progress validation
- Streak reset logic
- Timezone-aware calculations

## PostgreSQL Architecture

### Important Rule
Flutter must **never** connect directly to PostgreSQL. All database access must go through Cloud Functions.

```
Flutter
  ↓
Cloud Function
  ↓
PostgreSQL
```

### Database Schema

#### Tables
- `users` - User data
- `quests` - Quest definitions
- `quest_completions` - Quest completion records
- `quest_categories` - Quest categories
- `achievements` - Achievement definitions
- `user_achievements` - User achievement unlocks

### Database Access Pattern

```
Flutter App
  ↓ (HTTP Callable)
Cloud Function
  ↓ (Cloud SQL Proxy)
PostgreSQL Instance
```

## Security Architecture

### Authentication
- Firebase Authentication for user identity
- Auth state persistence
- Protected routes

### Authorization
- Firestore Security Rules
- Realtime Database Rules
- Storage Security Rules
- Cloud Functions authentication checks

### App Integrity
- Firebase App Check
- Development vs production configuration
- Request verification

### Data Ownership
- User data isolation
- Collection-level security
- Document-level security

## Development vs Production

### Development
- Firebase Emulator Suite
- Debug configuration
- App Check in debug mode
- Local testing environment

### Production
- Production Firebase project
- Release configuration
- App Check enforcement
- Optimized builds

## Architecture Principles

1. **Single Responsibility**: Each service has one clear purpose
2. **Separation of Concerns**: Clear separation between UI, business logic, and data
3. **Dependency Injection**: Use GetX for dependency management
4. **Immutable Data**: Use immutable data models where possible
5. **Error Handling**: Comprehensive error handling at all layers
6. **Security First**: Security considerations in all architectural decisions
7. **Scalability**: Design for growth from the start
8. **Testability**: Architecture should support testing at all levels

## Technology Choices

### Why Flutter?
- Cross-platform development
- Fast development cycle
- Hot reload
- Rich UI components
- Strong community support

### Why GetX?
- Lightweight and fast
- Built-in state management
- Route management
- Dependency injection
- Minimal boilerplate

### Why Firebase?
- Real-time capabilities
- Authentication built-in
- Scalable backend
- Strong security model
- Offline support
- Emulator suite for development

### Why PostgreSQL?
- Relational data for learning
- Complex queries support
- Transaction support
- Mature and stable
- SQL learning opportunity

## Future Considerations

- CI/CD pipeline setup
- Automated testing
- Performance monitoring
- Analytics integration
- Push notifications
- Multi-language support
- Web platform optimization
