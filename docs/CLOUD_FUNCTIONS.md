# Cloud Functions Documentation

## Overview
Cloud Functions for Firebase are used to implement server-side business logic that cannot be safely executed on the client.

## Functions to Implement

### 1. onQuestComplete
Triggered when a quest is completed. This function:
- Validates the quest completion
- Updates user XP and level
- Records activity history
- Calculates streak
- Ensures XP is awarded only once

### 2. onUserCreated
Triggered when a new user is created. This function:
- Creates initial user profile
- Sets default daily target
- Initializes streak

### 3. dailyStreakCheck
Scheduled function (daily) to:
- Check if users met their daily targets
- Update streaks accordingly
- Reset daily XP counters

## Deployment
Functions will be deployed using Firebase CLI:
```bash
firebase deploy --only functions
```

## Security
- Functions run with admin privileges
- All validation happens server-side
- Cannot be bypassed by client manipulation
