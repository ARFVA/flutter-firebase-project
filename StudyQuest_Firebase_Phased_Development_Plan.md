# StudyQuest Firebase Learning Project

## Phased Development Plan for Devin

> **Project Goal:** Build StudyQuest as a production-like learning
> project for mastering Firebase and backend architecture step by step.
>
> **Important:** Devin must implement one phase at a time. Do not jump
> to later phases before the current phase passes its acceptance
> criteria.

## Document Control

| Version | Date | Change Description |
| :-: | :-: | :-- |
| 1.0 | - | Initial draft: StudyQuest Firebase phased development plan |
| 1.1 | 08/10/2026 | Standardized to company SOPs (coding & repository, versioning, environment/storage governance): added Section 5, branch/commit/versioning rules, repository structure, upload limits, and `/version` endpoint |

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Tech Stack](#2-tech-stack)
3. [Core Architecture Principle](#3-core-architecture-principle)
4. [Development Rules](#4-development-rules)
5. [Company Standards (SOP Compliance)](#5-company-standards-sop-compliance)
6. [Phase Overview](#6-phase-overview) (Phase 0 to Phase 14 follow this section)
7. [MVP Definition](#7-mvp-definition)
8. [Final Target Architecture](#8-final-target-architecture)
9. [Final Learning Outcomes](#9-final-learning-outcomes)
10. [Devin Execution Protocol](#10-devin-execution-protocol)
11. [Phase Completion Rule](#11-phase-completion-rule)
12. [Success Criteria](#12-success-criteria)
13. [Recommended Execution Order](#13-recommended-execution-order)

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
16. Follow the company SOPs summarized in Section 5 (naming, branching,
    commit messages, repository structure, versioning).
17. Never push directly to `main`. All changes go through a Merge
    Request (Pull Request on GitHub).
18. Update `version.json` and `CHANGELOG.md` at the final push of every
    feature branch.
19. Keep Staging/Dev and Production environments separated.

------------------------------------------------------------------------

# 5. Company Standards (SOP Compliance)

This plan follows the company SOPs listed below. If any instruction in
this plan conflicts with an SOP, the SOP takes precedence and Devin must
report the conflict before implementing.

| SOP | Document No. | Applies to |
| :-- | :-- | :-- |
| Standarisasi Coding dan Repository | SOP/GRC/DEV-COD/2026/002 | Naming, Flutter standards, repository structure, branching, commits, dependencies |
| Standard Versioning | SOP/GRC/DEV-VER/2026/001 | `version.json`, `CHANGELOG.md`, version numbering, Git tags |
| Standarisasi Teknis & Tata Kelola Penggunaan Supabase (Draft) | SOP/GRC/DEV-SPB/2026/008 | Environment separation, feature flags, storage limits (written for Supabase; applied here to Firebase by analogy) |
| Standarisasi: Alur Handover & Offboarding | SOP/GRC/DEV-VER/2026/009 | Not applicable to this plan (HR/GRC process for staff leaving the company) |

## 5.1 Language & Naming

-   All names (variables, functions, classes, files) must be in English.
    Do not mix Indonesian and English.
-   Use `camelCase` for variables, functions, and methods.
-   Use `PascalCase` for classes and widgets/components.
-   Use `snake_case` only where the framework or tool requires it:
    Dart file/folder names, `version.json` keys, and PostgreSQL
    table/column names.
-   Names must be short but meaningful. Avoid unnecessary verbs.

| Avoid | Prefer |
| :-- | :-- |
| `storeData()` / `insertData()` | `setData()` |
| `displayData()` / `viewData()` | `getData()` |
| `fetchUserData()` | `getUser()` |
| `processUserData()` | `processUser()` |

-   One function handles one responsibility.
-   Avoid functions with overly long logic.
-   Avoid magic numbers and hard-coded values.
-   Consistency beats preference: follow the pattern already agreed in
    the project. Change a pattern only through team discussion and code
    review.

## 5.2 Flutter Standards

-   Separate UI, state, and service.
-   Use reusable widgets.
-   Do not put logic in the `build` method.
-   Never store credentials in the repository; use environment
    variables/configuration for sensitive values.
-   Input validation is mandatory.

## 5.3 Repository Structure

Every repository must contain:

``` text
/docs
README.md
.gitignore
.env.example
version.json
CHANGELOG.md
```

`README.md` must contain at minimum: project description, tech stack,
local setup, and how to run & build.

## 5.4 Branching Strategy

| Branch | Purpose |
| :-- | :-- |
| `main` | Production |
| `develop` | Development |
| `feat/*` | New feature |
| `style/*` | Appearance / UI styling |
| `chore/*` | Installation / setup |
| `fix/*` | Bug fix |
| `hotfix/*` | Urgent fix |

Rules:

-   No direct push to `main`.
-   All changes go through a Merge Request (Pull Request on GitHub).

## 5.5 Commit Message Convention

``` text
<type>: [XX] short description
```

-   `<type>` is one of the branch prefixes above: `feat`, `style`,
    `chore`, `fix`, `hotfix`.
-   `[XX]` is the initials of the developer responsible for the work
    (e.g. *John Doe* becomes `JD`).
-   The short description is written in English and summarizes the task.

Examples:

``` text
feat: [JD] add email registration
fix: [JD] fix duplicate quest completion validation
style: [JD] change login submit button color
chore: [JD] bump version to 0.2.0-beta.1
```

## 5.6 Dependency Management

-   Use explicit dependency versions (pin versions in `pubspec.yaml` and
    Cloud Functions `package.json`).
-   Update dependencies in a planned way, not randomly.
-   Record every dependency change in the Merge Request description.

## 5.7 Versioning

Every repository must have `version.json` and `CHANGELOG.md` in the
root folder.

`version.json`:

``` json
{
  "service_name": "studyquest",
  "version": "0.1.0-beta.1",
  "updated_at": "YYYY-MM-DD HH:MM"
}
```

`CHANGELOG.md` follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/):

``` markdown
# Changelog

All notable changes to **StudyQuest** are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [v0.1.0-beta.1] - YYYY-MM-DD

### Added
- ...

### Changed
- ...

### Fixed
- ...

### Security
- ...
```

Numbering rules:

-   Format: `vMAJOR.MINOR.PATCH-beta.ITERATION`.
-   New feature: raise **MINOR**.
-   Bug fix: raise **ITERATION**.
-   `rc.x` (Release Candidate): final stage before production.
-   `v1.0.0`: Go-Live / Production.
-   If two developers work at the same time, the developer who merges
    last must change the version in their own branch so it does not
    duplicate the version already on Staging.

Workflow (version is updated **once**, at the final push of a feature):

1.  Raise the version number in `version.json` (current version on
    Staging + 1).
2.  Write the change details in `CHANGELOG.md`.
3.  Run:

``` text
# 1. Stage the required files
git add version.json CHANGELOG.md

# 2. Commit the version bump
git commit -m "chore: [XX] bump version to 0.1.0-beta.1"

# 3. Create the official tag
git tag -a v0.1.0-beta.1 -m "Release version 0.1.0-beta.1"

# 4. Push the branch together with the tag
git push origin <branch-name> --tags
```

Accessibility of the version:

-   Flutter (mobile): `version.json` is provided in the repository root
    and release package so QA/GRC can check it manually.
-   Cloud Functions (backend, Phase 10): must expose `GET /version`
    returning the content of `version.json`.
-   `GET /version-manifest` is **not required**, because StudyQuest is a
    single-repository project.

## 5.8 Environments & Configuration

Applied from SOP/GRC/DEV-SPB/2026/008 (written for Supabase) to Firebase
by analogy.

-   Use at least two physically separate Firebase projects:
    **Staging/Dev** (daily development, integration testing, UAT) and
    **Production** (real user data only).
-   Never run experiments, experimental scripts, or manual schema/data
    modifications directly in Production.
-   Switch between environments through environment
    variables/configuration, not by editing the main code.
-   New backend modules/functions that need a matching change on the
    user side must be controlled by a feature flag in `.env`. While
    still being integrated in Production, the flag defaults to `false`.

``` text
ENABLE_<FEATURE_NAME>=false
```

-   Upload limits for Firebase Storage are defined in Phase 8.

------------------------------------------------------------------------

# 6. Phase Overview

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
-   Create `.gitignore` (must exclude `.env` and other secret files).
-   Create `.env.example` (variable names only, no real values).
-   Create `docs/` folder.
-   Create `version.json` and `CHANGELOG.md` (initial version
    `0.1.0-beta.1`, see Section 5.7).
-   Define Flutter package/application identifier.
-   Define environment/configuration strategy (Staging/Dev vs
    Production, see Section 5.8).
-   Create initial documentation.
-   Define development branches (see Section 5.4).
-   Enforce the branching rule: no direct push to `main`; all changes go
    through a Merge Request.

Recommended branches (Section 5.4):

``` text
main
develop

feat/firebase-setup
feat/auth
feat/firestore
feat/quest-system
feat/phone-auth
feat/realtime-db
feat/storage
feat/app-check
feat/functions
feat/cloud-sql
feat/security
feat/testing
```

Use `style/*`, `chore/*`, `fix/*`, and `hotfix/*` branches when the work
matches those types.

## Required repository root

``` text
/
├── docs/
├── lib/
├── README.md
├── .gitignore
├── .env.example
├── version.json
└── CHANGELOG.md
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
-   `.env.example`, `docs/`, `version.json`, and `CHANGELOG.md`

## Acceptance Criteria

-   Project runs successfully.
-   `flutter analyze` passes without new critical issues.
-   Git repository is initialized.
-   No secrets are committed.
-   README contains project description, tech stack, local setup, and
    run & build instructions.
-   `.env.example`, `docs/`, `version.json`, and `CHANGELOG.md` exist in
    the repository.
-   `version.json` follows the format in Section 5.7.
-   `main` and `develop` branches exist and the branching rule is
    followed.

## Learning Checkpoint

Before moving on, understand:

-   Flutter project structure
-   Git workflow
-   Separation of UI, data, and services
-   Why environment configuration matters
-   Company naming, branching, commit, and versioning standards
    (Section 5)

------------------------------------------------------------------------

# PHASE 1 --- Firebase Setup & Flutter Integration

## Goal

Connect Flutter to Firebase correctly.

## Tasks

-   Create separate Firebase projects for Staging/Dev and Production
    (see Section 5.8).
-   Install/configure Firebase CLI.
-   Install/configure FlutterFire CLI.
-   Connect Flutter project to Firebase.
-   Configure required Firebase platforms.
-   Add Firebase Core (with an explicit dependency version).
-   Verify Firebase initialization.
-   Configure development environment.

## Deliverables

Flutter application successfully connected to Firebase.

## Acceptance Criteria

-   Firebase initializes successfully.
-   App starts without Firebase initialization errors.
-   Firebase configuration is not manually hardcoded unnecessarily.
-   Staging/Dev and Production use separate Firebase projects, selected
    through configuration instead of code changes.
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
dailyXp >= dailyTargetXp
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
-   Compress/resize images on the client before upload.
-   Validate file size and content type (client side and Storage
    Security Rules).
-   Storage Security Rules.

## Upload Standards

Applied from SOP/GRC/DEV-SPB/2026/008 (written for Supabase Storage) to
Firebase Storage by analogy.

-   Maximum image size: **5 MB**.
-   Compress/resize on the client before upload; the final size should
    ideally be under **1 MB**.
-   Allowed formats: `image/jpeg`, `image/png`, `image/webp`.
-   Do not upload raw video files. If video is ever needed, host it on
    an external video service and store only the reference URL in
    Firestore.

## Acceptance Criteria

-   User can upload avatar.
-   User can replace avatar.
-   User can upload quest proof.
-   User cannot access unauthorized private files.
-   Storage metadata is correctly associated with the user/quest.
-   Files over 5 MB or with a disallowed content type are rejected.
-   Uploaded images are compressed (ideally under 1 MB).

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
-   Expose `GET /version` returning the content of `version.json`
    (SOP/GRC/DEV-VER/2026/001).
-   New functions that need a matching user-side change must be
    controlled by a feature flag in `.env` (default `false` in Production
    while still being integrated).

## Acceptance Criteria

-   Client cannot arbitrarily grant itself XP.
-   Duplicate completion requests do not create duplicate rewards.
-   Business logic is documented.
-   Functions are testable.
-   `GET /version` returns the current `version.json` content.
-   Newly added functions stay disabled in Production until their
    feature flag is enabled.

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
-   File size and content-type limits

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
-   Oversized or disallowed file type rejected

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
CHANGELOG.md
version.json
.env.example
docs/
├── ARCHITECTURE.md
├── FIREBASE.md
├── DATABASE.md
├── SECURITY.md
└── DEVELOPMENT.md
```

`README.md`, `CHANGELOG.md`, `version.json`, and `.env.example` stay in
the repository root. Detailed documentation lives in `docs/`
(SOP/GRC/DEV-COD/2026/002).

## README.md

Must contain:

-   Project overview
-   Features
-   Tech stack
-   Installation
-   Firebase setup
-   Run instructions
-   Build instructions

## `docs/ARCHITECTURE.md`

Must contain:

-   Flutter architecture
-   Firebase architecture
-   Service responsibilities
-   Data flow
-   Cloud Functions
-   PostgreSQL architecture

## `docs/FIREBASE.md`

Must contain:

-   Firebase setup
-   Authentication
-   Phone Auth
-   Firestore
-   Realtime Database
-   Storage
-   App Check
-   Functions

## `docs/DATABASE.md`

Must contain:

-   Firestore schema
-   Realtime Database schema
-   PostgreSQL schema
-   Relationships
-   Reasoning behind database selection

## `docs/SECURITY.md`

Must contain:

-   Authentication
-   Authorization
-   Firestore Rules
-   Realtime Database Rules
-   Storage Rules
-   App Check
-   Server-side validation

## `docs/DEVELOPMENT.md`

Must contain:

-   Local setup
-   Firebase Emulator
-   Environment configuration
-   Development workflow
-   Branching, commit, and versioning workflow
-   Testing workflow

## Acceptance Criteria

-   All required files exist in the locations above.
-   `CHANGELOG.md` and `version.json` reflect the final state of the project.
-   Documentation matches the implemented architecture.

------------------------------------------------------------------------

# 7. MVP Definition

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

# 8. Final Target Architecture

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

# 9. Final Learning Outcomes

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

# 10. Devin Execution Protocol

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

Work on a dedicated branch (`feat/*`, `fix/*`, etc.) created from
`develop`. Write commit messages as `<type>: [XX] short description`
(Section 5.5). Never push directly to `main`.

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

At the final push of the phase (Section 5.7):

-   Update `CHANGELOG.md`.
-   Raise the version in `version.json`.
-   Commit and create the version tag.
-   Open a Merge Request that lists any dependency changes.

## Step 7 --- Report

For every phase, report:

``` text
Phase:
Status:
Branch:
Version:

Implemented:
- ...
- ...

Files changed:
- ...

Dependency changes:
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

# 11. Phase Completion Rule

Do not proceed automatically to the next phase if:

-   Build is broken.
-   Critical tests fail.
-   Security Rules are missing.
-   Authentication/authorization is incorrect.
-   Secrets are exposed.
-   Architecture is significantly different from this plan.
-   Existing functionality has regressed.
-   `CHANGELOG.md` / `version.json` are not updated.
-   Changes were pushed directly to `main`.

If blocked, report the blocker and explain the recommended solution.

------------------------------------------------------------------------

# 12. Success Criteria

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
15. The repository follows the company standards (naming, branching,
    commit convention, repository structure).
16. `version.json` and `CHANGELOG.md` are maintained and match the
    released tags.

------------------------------------------------------------------------

# 13. Recommended Execution Order

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
