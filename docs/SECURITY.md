# Security Guidelines

This document consolidates security guidance and hardening status for StudyQuest.

## Security Principles

1. Never commit secrets
2. Use Firebase Security Rules
3. Implement App Check
4. Validate all inputs
5. Use Cloud Functions for sensitive operations
6. Follow least privilege principle

## Implemented Security Measures

### 1. Authentication
- Email/password authentication with Firebase Auth
- Google Sign-In authentication
- Phone number authentication with OTP verification
- Session management with auth state listeners
- Protected routes with middleware

### 2. Firestore Security Rules
- User data: Only owner can read/write
- Quest data: Owner can read/write, creation requires auth
- Activity data: Owner can read, create requires auth, immutable
- XP/Level/Streak: Cannot be modified directly from client (server-side via Cloud Functions)

### 3. Realtime Database Security Rules
- Room creation: Only by authenticated users
- Room participation: Owner can read/write own participant data
- Room ownership: Only creator can modify room settings

### 4. Firebase Storage Security Rules
- User files: Only owner can read/write
- Quest files: Read-only for authenticated users
- Write access: Server-only for quest files
- Upload limits: max 5 MB per file; images only (jpeg/png/webp), compressed below 1 MB before upload

### 5. Firebase App Check
- App integrity verification via `firebase_app_check`
- Debug provider for development builds
- Play Integrity (Android) / DeviceCheck (Apple) for production
- Enforced on Firestore, Realtime Database, Storage, and Cloud Functions

## Security Architecture

### Cloud Functions for Critical Logic
- XP calculation
- Level calculation
- Streak calculation
- Quest completion validation (server-side)
- Idempotency guard so XP is awarded exactly once per quest
- Server-side validation of all critical operations

### Rate Limiting
- OTP resend attempts limited by Firebase Auth
- Future: rate limiting on callable endpoints

### Secrets Management
- Firebase config files (google-services.json, firebase_options.dart) are gitignored
- Environment-specific configuration via `.env` (see `.env.example`)
- Feature flags gate unfinished functionality (default `false` in production)

## Security Best Practices
1. Never trust client-side calculations for critical logic
2. Always validate on server-side
3. Use least privilege principle
4. Regular security audits
5. Keep dependencies updated
6. Monitor for suspicious activity
