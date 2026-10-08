# StudyQuest Firebase Learning Project

## Phased Development Plan for Devin

> **Project Goal:** Build StudyQuest as a production-like learning
> project for mastering Firebase and backend architecture step by step.
>
> **Important:** Devin must implement one phase at a time. Do not jump
> to later phases before the current phase passes its acceptance
> criteria.

------------------------------------------------------------------------

# 1. Project Overview

**StudyQuest** is a productivity and study-tracking application based on
gamification.

Users can:

-   Register and log in
-   Use phone number authentication
-   Create and complete quests
-   Earn XP
-   Level up
-   Maintain daily streaks
-   Track activity history
-   Join realtime study rooms
-   Upload profile pictures and quest proofs

The project is intentionally designed to teach:

1.  Firebase Authentication
2.  Firebase Phone Authentication
3.  Firebase App Check
4.  Cloud Firestore
5.  Firebase Realtime Database
6.  Firebase Storage
7.  Cloud Functions
8.  Cloud SQL PostgreSQL
9.  Firebase Security Rules
10. Firebase Emulator Suite

------------------------------------------------------------------------

# 2. Tech Stack

## Frontend

-   Flutter
-   Dart
-   GetX
-   Responsive UI
-   Android-first
-   Keep architecture compatible with Flutter Web where practical

## Firebase

-   Firebase Authentication
-   Firebase App Check
-   Cloud Firestore
-   Firebase Realtime Database
-   Firebase Storage
-   Cloud Functions
-   Firebase Emulator Suite

## SQL

-   Cloud SQL
-   PostgreSQL

## Development

-   Firebase CLI
-   FlutterFire CLI
-   Git
-   GitHub

------------------------------------------------------------------------

# 3. Core Architecture Principle

Each backend service must have a clear responsibility.

  Service             Responsibility
  ------------------- ---------------------------------------------
  Firebase Auth       Identity and authentication
  Firestore           Main document-oriented application data
  Realtime Database   Realtime presence and live study room state
  Storage             Uploaded files
  App Check           App/device integrity protection
  Cloud Functions     Trusted server-side business logic
  PostgreSQL          Relational SQL data and SQL learning
  Emulator Suite      Local Firebase development/testing

Do **not** treat Firebase services as interchangeable.

------------------------------------------------------------------------

# 4. Development Rules

1.  Implement one phase at a time.
2.  Do not skip acceptance criteria.
3.  Do not introduce unnecessary technologies.
4.  Do not replace Firebase services without approval.
5.  Do not connect Flutter directly to PostgreSQL.
6.  Never commit secrets.
7.  Keep Firebase Security Rules under version control.
8.  Keep the application buildable after every phase.
9.  Update documentation when architecture changes.
10. Do not over-engineer the MVP.
11. Business-critical logic must not rely entirely on client-side
    calculations.
12. Use Firebase Emulator Suite where practical.
13. Explain major architectural decisions in documentation.
14. Do not silently change the project scope.
15. If a requirement conflicts with Firebase best practices, explain the
    issue before implementing the alternative.

------------------------------------------------------------------------

# 5. Phase Overview

``` text
Phase 0  → Project Planning & Repository Setup
Phase 1  → Firebase Setup & Flutter Integration
Phase 2  → Email/Password Authentication
Phase 3  → User Profile & Firestore Foundation
Phase 4  → Quest System
Phase 5  → XP, Level, Streak & Activity
Phase 6  → Phone Number Authentication
Phase 7  → Realtime Study Room
Phase 8  → Firebase Storage
Phase 9  → Firebase App Check
Phase 10 → Cloud Functions
Phase 11 → Cloud SQL PostgreSQL
Phase 12 → Security Hardening
Phase 13 → Testing & Emulator Suite
Phase 14 → Documentation & Final Review
```

------------------------------------------------------------------------

# PHASE 0 --- Project Planning & Repository Setup

## Goal

Prepare a clean repository and development structure before implementing
Firebase features.

## Tasks

-   Create Flutter project if not already available.
-   Initialize Git.
-   Create initial repository structure.
-   Create `.gitignore`.
-   Define Flutter package/application identifier.
-   Define environment/configuration strategy.
-   Create initial documentation.
-   Define development branches.

Recommended branches:

``` text
main

feature/firebase-setup
feature/auth
feature/firestore
feature/quest-system
feature/phone-auth
feature/realtime-db
feature/storage
feature/app-check
feature/functions
feature/cloud-sql
feature/security
feature/testing
```

## Recommended Flutter structure

``` text
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

## Deliverables

-   Flutter project
-   Git repository
-   Initial README
-   Initial architecture document
-   Clean folder structure

## Acceptance Criteria

-   Project runs successfully.
-   `flutter analyze` passes without new critical issues.
-   Git repository is initialized.
-   No secrets are committed.
-   README contains setup instructions.

## Learning Checkpoint

Before moving on, understand:

-   Flutter project structure
-   Git workflow
-   Separation of UI, data, and services
-   Why environment configuration matters

------------------------------------------------------------------------

# PHASE 1 --- Firebase Setup & Flutter Integration

## Goal

Connect Flutter to Firebase correctly.

## Tasks

-   Create Firebase project.
-   Install/configure Firebase CLI.
-   Install/configure FlutterFire CLI.
-   Connect Flutter project to Firebase.
-   Configure required Firebase platforms.
-   Add Firebase Core.
-   Verify Firebase initialization.
-   Configure development environment.

## Deliverables

Flutter application successfully connected to Firebase.

## Acceptance Criteria

-   Firebase initializes successfully.
-   App starts without Firebase initialization errors.
-   Firebase configuration is not manually hardcoded unnecessarily.
-   README explains Firebase setup.

## Learning Checkpoint

Understand:

-   Firebase project
-   Firebase application
-   FlutterFire
-   Firebase configuration
-   Firebase CLI

------------------------------------------------------------------------

# PHASE 2 --- Email/Password Authentication

## Goal

Learn Firebase Authentication fundamentals.

## Features

-   Register
-   Login
-   Logout
-   Authentication state
-   Protected home screen
-   Authentication error handling

## Flow

``` text
Register
   ↓
Firebase Authentication
   ↓
Authenticated
   ↓
Home
```

## Tasks

-   Create auth service.
-   Create auth repository.
-   Implement register.
-   Implement login.
-   Implement logout.
-   Listen to auth state.
-   Redirect unauthenticated users to login.
-   Handle Firebase auth errors.

## Acceptance Criteria

-   New user can register.
-   Existing user can login.
-   User remains authenticated after app restart when appropriate.
-   User can logout.
-   Unauthenticated user cannot access protected screens.

## Learning Checkpoint

Understand:

-   Authentication vs authorization
-   Auth state
-   Firebase user identity
-   Authentication errors
-   Protected routes

------------------------------------------------------------------------

# PHASE 3 --- User Profile & Firestore Foundation

## Goal

Start using Cloud Firestore for application data.

## User Document

Recommended structure:

``` text
users/{userId}
```

Example:

``` json
{
  "displayName": "Riffat",
  "email": "user@example.com",
  "photoURL": null,
  "level": 1,
  "xp": 0,
  "dailyTargetXp": 500,
  "streak": 0,
  "createdAt": "...",
  "updatedAt": "..."
}
```

## Tasks

-   Create user model.
-   Create Firestore datasource.
-   Create repository.
-   Create profile after registration.
-   Read profile.
-   Update profile.
-   Add Firestore Security Rules.
-   Add timestamps.

## Acceptance Criteria

-   Registration creates a user profile document.
-   User can read their own profile.
-   User can update allowed profile fields.
-   User cannot modify another user's private profile.
-   Rules are tested.

## Learning Checkpoint

Understand:

-   Collection
-   Document
-   Document ID
-   Firestore query
-   Security Rules
-   Server timestamps
-   Client vs database data

------------------------------------------------------------------------

# PHASE 4 --- Quest System

## Goal

Build the core StudyQuest functionality.

## Quest Types

### Checklist

For short tasks.

Examples:

``` text
Clean room
Organize desk
Read documentation
```

### Timer

For tasks requiring a duration.

Examples:

``` text
Study Laravel — 60 minutes
Work on TA — 120 minutes
Study Firebase — 30 minutes
```

## Quest Fields

Minimum:

``` text
id
userId
title
description
type
xp
durationMinutes
isCompleted
createdAt
updatedAt
```

## Features

-   Create quest
-   Read quests
-   Update quest
-   Delete quest
-   Complete quest
-   Filter active/completed quests
-   Daily quest list

## Important Rule

A quest completion must not allow users to repeatedly generate XP
through invalid repeated requests.

## Acceptance Criteria

-   User can create a checklist quest.
-   User can create a timer quest.
-   User can edit a quest.
-   User can delete a quest.
-   User can complete a quest.
-   Completed state persists.
-   User cannot access another user's quests.

## Learning Checkpoint

Understand:

-   CRUD
-   Firestore document design
-   Querying
-   Filtering
-   Security Rules
-   Data ownership

------------------------------------------------------------------------

# PHASE 5 --- XP, Level, Streak & Activity

## Goal

Introduce the gamification system.

## XP

Example:

``` text
Quest A = 100 XP
Quest B = 150 XP
Quest C = 250 XP
```

## Daily Target

User can configure:

``` text
Daily Target XP = 500
```

Daily progress:

``` text
350 / 500 XP
```

## Level

Implement a simple deterministic level calculation.

The exact formula should be documented.

## Streak

A successful day means:

``` text
dailyXP >= dailyTargetXP
```

If the user fails a required day:

``` text
streak resets
```

Avoid relying entirely on client-side time manipulation.

## Activity History

Example:

``` text
Completed "Study Firebase Auth"
+100 XP

Completed "Firestore CRUD"
+150 XP
```

## Acceptance Criteria

-   Completing a valid quest adds XP exactly once.
-   Daily XP is updated correctly.
-   Level updates correctly.
-   Daily target can be changed.
-   Successful days increase streak.
-   Failed days reset streak according to documented rules.
-   Activity is recorded.

## Learning Checkpoint

Understand:

-   Business logic
-   Idempotency
-   Date-based logic
-   Server-side validation
-   Why important calculations should not rely only on Flutter

------------------------------------------------------------------------

# PHASE 6 --- Phone Number Authentication

## Goal

Learn Firebase Phone Authentication and OTP.

## Flow

``` text
Phone Number
      ↓
Send OTP
      ↓
Enter OTP
      ↓
Verify
      ↓
Authenticated
```

## Tasks

-   Phone number screen.
-   OTP screen.
-   Send verification code.
-   Verify OTP.
-   Handle invalid OTP.
-   Handle expired OTP.
-   Handle resend.
-   Handle authentication state.

## Acceptance Criteria

-   User can authenticate with phone number in supported environments.
-   Invalid OTP is handled gracefully.
-   OTP resend works according to Firebase constraints.
-   Existing user identity is handled correctly.

## Learning Checkpoint

Understand:

-   OTP
-   Phone verification
-   Authentication providers
-   Verification state
-   Account linking considerations

------------------------------------------------------------------------

# PHASE 7 --- Realtime Study Room

## Goal

Learn Firebase Realtime Database through a feature that actually
requires realtime behavior.

## Study Room

Example:

``` text
Firebase Study Room

Participants:

🟢 Riffat — Studying
🟢 Budi — Break
⚪ Dimas — Offline
```

## Realtime Database Structure

Example:

``` text
rooms/
  {roomId}/
    participants/
      {userId}/
        displayName
        status
        lastSeen
```

## Features

-   Create room
-   Join room
-   Leave room
-   Participant list
-   Online/offline presence
-   Current status
-   Realtime updates

Statuses:

``` text
studying
break
offline
```

## Acceptance Criteria

-   Two clients can join the same room.
-   Status changes appear on other clients without manual refresh.
-   User leaving the room removes/updates presence correctly.
-   Unauthorized users cannot modify protected room data.

## Learning Checkpoint

Understand:

-   Realtime listeners
-   Presence
-   Realtime data modeling
-   Difference between Firestore and Realtime Database

------------------------------------------------------------------------

# PHASE 8 --- Firebase Storage

## Goal

Learn file upload and file security.

## Features

### Profile Avatar

``` text
/users/{userId}/avatar/
```

### Quest Proof

``` text
/users/{userId}/proofs/{questId}/
```

## Flow

``` text
Flutter
  ↓
Select Image
  ↓
Firebase Storage
  ↓
Download URL / metadata
  ↓
Firestore
```

## Tasks

-   Image picker integration.
-   Avatar upload.
-   Avatar replacement.
-   Avatar deletion.
-   Quest proof upload.
-   Store metadata in Firestore.
-   Storage Security Rules.

## Acceptance Criteria

-   User can upload avatar.
-   User can replace avatar.
-   User can upload quest proof.
-   User cannot access unauthorized private files.
-   Storage metadata is correctly associated with the user/quest.

## Learning Checkpoint

Understand:

-   Object storage
-   Storage paths
-   Upload
-   Download URL
-   Metadata
-   Storage Rules

------------------------------------------------------------------------

# PHASE 9 --- Firebase App Check

## Goal

Learn application integrity protection.

## Important Concept

App Check is not authentication.

``` text
Authentication
= Who is the user?

App Check
= Is the request coming from an authorized/recognized app environment?
```

## Tasks

-   Configure App Check for development.
-   Verify tokens/requests.
-   Test protected Firebase resources.
-   Configure production enforcement carefully.
-   Document development vs production behavior.

## Acceptance Criteria

-   App Check works in development.
-   Firebase functionality remains usable.
-   Invalid/unverified requests are handled according to configuration.
-   Documentation explains App Check.

## Important Rule

Do not enable strict production enforcement before verifying the
complete application flow.

## Learning Checkpoint

Understand:

-   Authentication
-   Authorization
-   App integrity
-   App Check
-   Why App Check does not replace Security Rules

------------------------------------------------------------------------

# PHASE 10 --- Cloud Functions

## Goal

Move trusted business logic to the backend/serverless environment.

## Candidate Logic

-   Quest completion validation
-   XP calculation
-   Level calculation
-   Streak calculation
-   Activity creation

## Example

``` text
Client
  ↓
Complete Quest Request
  ↓
Cloud Function
  ↓
Validate user
  ↓
Validate quest
  ↓
Prevent duplicate completion
  ↓
Calculate XP
  ↓
Update progress
  ↓
Create activity
```

## Requirements

-   Functions must validate user identity.
-   Functions must not blindly trust client-provided XP.
-   Important operations should be designed to be idempotent.
-   Errors should be safe and meaningful.

## Acceptance Criteria

-   Client cannot arbitrarily grant itself XP.
-   Duplicate completion requests do not create duplicate rewards.
-   Business logic is documented.
-   Functions are testable.

## Learning Checkpoint

Understand:

-   Serverless backend
-   Trusted execution
-   Callable/HTTP/event-driven functions as appropriate
-   Idempotency
-   Backend validation

------------------------------------------------------------------------

# PHASE 11 --- Cloud SQL PostgreSQL

## Goal

Learn how Firebase-based applications can coexist with relational SQL.

## Important Rule

Flutter must never connect directly to PostgreSQL.

Correct:

``` text
Flutter
   ↓
Backend / Cloud Function
   ↓
PostgreSQL
```

Incorrect:

``` text
Flutter
   ↓
PostgreSQL
```

## Suggested Tables

``` text
users
quests
quest_completions
quest_categories
achievements
user_achievements
```

## Tasks

-   Create Cloud SQL PostgreSQL instance.
-   Create database.
-   Create schema.
-   Create tables.
-   Add primary keys.
-   Add foreign keys.
-   Add indexes.
-   Implement basic queries.
-   Connect backend/service layer.
-   Document SQL architecture.

## Acceptance Criteria

-   PostgreSQL is reachable only through the backend layer.
-   Schema is documented.
-   Relationships work correctly.
-   CRUD/query operations are tested.
-   Database credentials are never committed.

## Learning Checkpoint

Understand:

-   Relational database
-   Primary key
-   Foreign key
-   JOIN
-   Index
-   Transactions
-   SQL vs NoSQL

------------------------------------------------------------------------

# PHASE 12 --- Security Hardening

## Goal

Review and harden the entire backend.

## Review

### Authentication

-   Auth state
-   Unauthorized access
-   Account ownership

### Firestore

-   Read rules
-   Write rules
-   User ownership
-   Validation

### Realtime Database

-   Room membership
-   Presence access
-   Write permissions

### Storage

-   User ownership
-   File path validation
-   File access

### Functions

-   Authentication checks
-   Input validation
-   Duplicate request handling
-   Sensitive operations

### App Check

-   Development configuration
-   Production enforcement

### PostgreSQL

-   Credentials
-   Network access
-   Backend-only access
-   Secrets management

## Acceptance Criteria

Perform negative tests:

``` text
User A attempts to read User B data
User A attempts to modify User B data
Unauthenticated user attempts protected action
Client attempts to grant itself XP
Invalid file access
Invalid room modification
```

All should be rejected appropriately.

------------------------------------------------------------------------

# PHASE 13 --- Testing & Firebase Emulator Suite

## Goal

Create a safe and repeatable local testing environment.

## Emulator Targets

Where practical:

-   Authentication
-   Firestore
-   Realtime Database
-   Storage
-   Functions

## Tests

### Authentication

-   Register
-   Login
-   Logout
-   Invalid credentials

### Firestore

-   CRUD
-   Ownership
-   Security Rules

### Realtime Database

-   Join room
-   Leave room
-   Presence
-   Realtime updates

### Storage

-   Upload
-   Delete
-   Unauthorized access

### Functions

-   Valid request
-   Invalid request
-   Duplicate request
-   Unauthorized request

## Acceptance Criteria

-   Emulator environment starts correctly.
-   Core tests can run without production data.
-   Security Rules are tested.
-   No test requires hardcoded production credentials.

------------------------------------------------------------------------

# PHASE 14 --- Documentation & Final Review

## Required Files

``` text
README.md
ARCHITECTURE.md
FIREBASE.md
DATABASE.md
SECURITY.md
DEVELOPMENT.md
```

## README.md

Must contain:

-   Project overview
-   Features
-   Tech stack
-   Installation
-   Firebase setup
-   Run instructions

## ARCHITECTURE.md

Must contain:

-   Flutter architecture
-   Firebase architecture
-   Service responsibilities
-   Data flow
-   Cloud Functions
-   PostgreSQL architecture

## FIREBASE.md

Must contain:

-   Firebase setup
-   Authentication
-   Phone Auth
-   Firestore
-   Realtime Database
-   Storage
-   App Check
-   Functions

## DATABASE.md

Must contain:

-   Firestore schema
-   Realtime Database schema
-   PostgreSQL schema
-   Relationships
-   Reasoning behind database selection

## SECURITY.md

Must contain:

-   Authentication
-   Authorization
-   Firestore Rules
-   Realtime Database Rules
-   Storage Rules
-   App Check
-   Server-side validation

## DEVELOPMENT.md

Must contain:

-   Local setup
-   Firebase Emulator
-   Environment configuration
-   Development workflow
-   Testing workflow

------------------------------------------------------------------------

# 6. MVP Definition

The MVP should be completed before advanced Firebase services are added.

## MVP

``` text
Authentication
      ↓
User Profile
      ↓
Quest CRUD
      ↓
Quest Completion
      ↓
XP
      ↓
Level
      ↓
Daily Target
      ↓
Streak
      ↓
Activity History
```

MVP does NOT require:

-   Phone authentication
-   Realtime study room
-   Storage
-   App Check
-   Cloud SQL
-   Advanced achievements

Those come in later phases.

------------------------------------------------------------------------

# 7. Final Target Architecture

``` text
                         Flutter
                            │
                            ▼
                     Firebase App Check
                            │
              ┌─────────────┼─────────────┐
              │             │             │
              ▼             ▼             ▼
        Firebase Auth   Firestore    Realtime DB
              │             │             │
              │             │             │
              │             ▼             ▼
              │        User/Quest      Study Room
              │        /Activity       /Presence
              │
              ▼
        User Identity


Flutter
   │
   ▼
Firebase Storage
   │
   ├── Avatar
   └── Quest Proof


Flutter
   │
   ▼
Cloud Functions
   │
   ├── Validation
   ├── XP
   ├── Level
   └── Streak
            │
            ▼
      PostgreSQL
```

------------------------------------------------------------------------

# 8. Final Learning Outcomes

After completing all phases, the developer should be able to explain:

## Firebase Authentication

-   How Firebase Auth works
-   Email/password authentication
-   Phone OTP
-   Authentication state
-   Identity

## Firestore

-   Collections
-   Documents
-   Queries
-   Data modeling
-   Security Rules
-   When Firestore is appropriate

## Realtime Database

-   Realtime listeners
-   Presence
-   Live state
-   When Realtime Database is appropriate

## Storage

-   Object storage
-   Uploads
-   Download URLs
-   File security

## App Check

-   App integrity
-   How it differs from Authentication
-   How it works together with Security Rules

## Cloud Functions

-   Server-side logic
-   Trusted execution
-   Validation
-   Idempotency

## PostgreSQL

-   Relational modeling
-   Foreign keys
-   JOINs
-   Indexes
-   Transactions
-   When SQL is preferable

## Architecture

The developer should be able to answer:

> "Why is this data stored in Firestore instead of Realtime Database?"

> "Why is this file stored in Storage instead of Firestore?"

> "Why does this logic run in Cloud Functions instead of Flutter?"

> "Why does this data belong in PostgreSQL instead of Firestore?"

That understanding is more important than simply knowing how to call
each Firebase API.

------------------------------------------------------------------------

# 9. Devin Execution Protocol

Devin should follow this protocol for every phase.

## Step 1 --- Inspect

Inspect:

-   Existing repository
-   Current architecture
-   Dependencies
-   Existing Firebase configuration
-   Documentation
-   Git status

Do not overwrite existing work blindly.

## Step 2 --- Plan

Before implementation, identify:

-   Files to create/change
-   Dependencies required
-   Firebase configuration required
-   Security implications
-   Tests required

## Step 3 --- Implement

Implement only the current phase.

Do not implement future phases unless explicitly requested.

## Step 4 --- Test

Run relevant:

``` text
flutter analyze
flutter test
```

and Firebase/emulator tests when applicable.

## Step 5 --- Review

Check:

-   Security
-   Error handling
-   Architecture
-   Data ownership
-   Duplicate logic
-   Secrets

## Step 6 --- Document

Update relevant `.md` files.

## Step 7 --- Report

For every phase, report:

``` text
Phase:
Status:

Implemented:
- ...
- ...

Files changed:
- ...

Tests:
- ...

Security:
- ...

Architecture decisions:
- ...

Known limitations:
- ...

Next phase:
- ...
```

------------------------------------------------------------------------

# 10. Phase Completion Rule

Do not proceed automatically to the next phase if:

-   Build is broken.
-   Critical tests fail.
-   Security Rules are missing.
-   Authentication/authorization is incorrect.
-   Secrets are exposed.
-   Architecture is significantly different from this plan.
-   Existing functionality has regressed.

If blocked, report the blocker and explain the recommended solution.

------------------------------------------------------------------------

# 11. Success Criteria

The project is successful when:

1.  StudyQuest works as a usable productivity application.
2.  Firebase Authentication is implemented correctly.
3.  Phone authentication is understood and functional where supported.
4.  Firestore is used for appropriate document data.
5.  Realtime Database is used for genuine realtime state.
6.  Storage is used for files.
7.  App Check is configured.
8.  Cloud Functions handle trusted business logic.
9.  PostgreSQL is accessed through a backend layer.
10. Firebase Security Rules protect user data.
11. Emulator-based development/testing is available.
12. Documentation explains the architecture.
13. Every Firebase service has a clear reason for existing.
14. The developer can explain the tradeoffs between Firebase and SQL.

------------------------------------------------------------------------

# 12. Recommended Execution Order

**Devin must execute in this exact order:**

``` text
PHASE 0
Project Planning
      ↓
PHASE 1
Firebase Setup
      ↓
PHASE 2
Email/Password Auth
      ↓
PHASE 3
User Profile + Firestore
      ↓
PHASE 4
Quest System
      ↓
PHASE 5
XP + Level + Streak
      ↓
PHASE 6
Phone Auth
      ↓
PHASE 7
Realtime Database
      ↓
PHASE 8
Storage
      ↓
PHASE 9
App Check
      ↓
PHASE 10
Cloud Functions
      ↓
PHASE 11
Cloud SQL PostgreSQL
      ↓
PHASE 12
Security Hardening
      ↓
PHASE 13
Testing + Emulator
      ↓
PHASE 14
Documentation + Final Review
```

**Do not implement all phases in one pass.**

The purpose of this project is to learn the architecture progressively
while maintaining a working application at every stage.
