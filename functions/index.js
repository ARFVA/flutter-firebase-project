const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

// Cloud SQL (PostgreSQL) callables + sync trigger.
const cloudsql = require('./cloudsql');
exports.recordStudySession = cloudsql.recordStudySession;
exports.getFriendLeaderboard = cloudsql.getFriendLeaderboard;
exports.syncUserToSql = cloudsql.syncUserToSql;

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/** Level = floor(sqrt(XP / 100)) + 1 — must match client GamificationUtils. */
function calculateLevel(xp) {
  return Math.floor(Math.sqrt(xp / 100)) + 1;
}

/** Returns YYYY-MM-DD (UTC) for a date, used for streak/idempotency checks. */
function dateKey(date) {
  return date.toISOString().slice(0, 10);
}

// ---------------------------------------------------------------------------
// Firestore triggers
// ---------------------------------------------------------------------------

/**
 * onQuestComplete
 *
 * Runs when a quest document is updated. Awards XP exactly once when a quest
 * transitions from incomplete -> complete.
 *
 * Idempotency strategy:
 *  - Firestore triggers can fire more than once for the same event, so we use
 *    a transaction that flips `xpAwarded` on the quest document. Only the
 *    transaction that successfully flips the flag awards XP.
 *  - The activity document ID is derived from the quest ID, so retries cannot
 *    create duplicate activity entries either.
 *
 * Validation (server-side, never trusted from client):
 *  - quest must have a positive integer XP reward (max 10,000)
 *  - quest must belong to an existing user profile
 */
exports.onQuestComplete = functions.firestore
  .document('quests/{questId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    const questId = context.params.questId;

    // Only act on the incomplete -> complete transition.
    if (before.isCompleted === true || after.isCompleted !== true) {
      return null;
    }

    // Validation: XP reward must be sane.
    const xp = after.xp;
    if (!Number.isInteger(xp) || xp <= 0 || xp > 10000) {
      console.warn(`[onQuestComplete] Invalid xp on quest ${questId}: ${xp}`);
      return null;
    }

    const userId = after.userId;
    if (!userId) {
      console.warn(`[onQuestComplete] Quest ${questId} has no userId`);
      return null;
    }

    const questRef = db.collection('quests').doc(questId);
    const userRef = db.collection('users').doc(userId);
    const activityRef = db.collection('activities').doc(`quest_${questId}`);

    try {
      await db.runTransaction(async (transaction) => {
        const [questSnap, userSnap, activitySnap] = await Promise.all([
          transaction.get(questRef),
          transaction.get(userRef),
          transaction.get(activityRef),
        ]);

        // Idempotency guard 1: XP already awarded for this quest.
        if (questSnap.exists && questSnap.data().xpAwarded === true) {
          return;
        }

        // Idempotency guard 2: activity already recorded for this quest.
        if (activitySnap.exists) {
          transaction.update(questRef, { xpAwarded: true });
          return;
        }

        if (!userSnap.exists) {
          console.warn(
            `[onQuestComplete] Missing user profile ${userId}; skipping award`
          );
          return;
        }

        const userData = userSnap.data();
        const previousXp = userData.xp || 0;
        const newXp = previousXp + xp;
        const newLevel = calculateLevel(newXp);
        const leveledUp = newLevel > (userData.level || 1);

        // Streak: increment once per day when daily target is met.
        const today = dateKey(new Date());
        const lastStreakDate = userData.lastStreakDate || null;
        let streak = userData.streak || 0;
        if (lastStreakDate !== today) {
          // Continue if streak was already active yesterday, otherwise start over.
          const yesterday = dateKey(new Date(Date.now() - 86400000));
          streak = lastStreakDate === yesterday ? streak + 1 : 1;
        }

        transaction.update(userRef, {
          xp: newXp,
          level: newLevel,
          streak: streak,
          lastStreakDate: today,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        transaction.set(activityRef, {
          id: `quest_${questId}`,
          userId: userId,
          type: 'quest_complete',
          description: `Completed "${after.title}"`,
          xpGained: xp,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        // Mark the quest so retried invocations skip the award.
        transaction.update(questRef, { xpAwarded: true });

        console.log(
          `[onQuestComplete] Awarded ${xp} XP to ${userId} ` +
            `(level ${newLevel}${leveledUp ? ', LEVEL UP' : ''})`
        );
      });
    } catch (e) {
      console.error(`[onQuestComplete] Transaction failed for ${questId}:`, e);
    }

    return null;
  });

// Auth triggers
exports.onUserCreated = functions.auth.user().onCreate(async (user) => {
  const userRef = db.collection('users').doc(user.uid);
  const snapshot = await userRef.get();
  if (snapshot.exists) return null; // never overwrite an existing profile

  const displayName = (user.displayName || user.email || 'User')
    .toString()
    .trim()
    .slice(0, 80);

  await userRef.set({
    uid: user.uid,
    displayName: displayName || 'User',
    email: user.email || '',
    photoURL: user.photoURL || null,
    phoneNumber: user.phoneNumber || null,
    level: 1,
    xp: 0,
    dailyTargetXp: 500,
    streak: 0,
    lastStreakDate: null,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  console.log(`[onUserCreated] Profile created for ${user.uid}`);
  return null;
});

// Scheduled functions
exports.dailyStreakCheck = functions.pubsub
  .schedule('0 0 * * *')
  .timeZone('UTC')
  .onRun(async () => {
    const yesterday = dateKey(new Date(Date.now() - 86400000));
    const usersRef = db.collection('users');

    // Reset the streak of users whose last activity is older than yesterday.
    const staleUsers = await usersRef
      .where('streak', '>', 0)
      .where('lastStreakDate', '<', yesterday)
      .get();

    if (staleUsers.empty) {
      console.log('[dailyStreakCheck] No stale streaks');
      return null;
    }

    let processed = 0;
    // Firestore batch limit is 500 operations per commit.
    const docs = staleUsers.docs;
    for (let i = 0; i < docs.length; i += 500) {
      const batch = db.batch();
      docs.slice(i, i + 500).forEach((doc) => {
        batch.update(doc.ref, {
          streak: 0,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        processed++;
      });
      await batch.commit();
    }

    console.log(`[dailyStreakCheck] Reset streak for ${processed} users`);
    return null;
  });
