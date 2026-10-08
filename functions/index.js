const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Firestore triggers
exports.onQuestComplete = functions.firestore
  .document('quests/{questId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    // Check if quest was just completed
    if (!before.isCompleted && after.isCompleted) {
      const userId = after.userId;
      const xp = after.xp;

      // Get user profile
      const userRef = admin.firestore().collection('users').doc(userId);
      const userDoc = await userRef.get();
      const userData = userDoc.data();

      if (userData) {
        // Calculate new XP and level
        const newXP = userData.xp + xp;
        const newLevel = Math.floor(Math.sqrt(newXP / 100)) + 1;

        // Update user profile
        await userRef.update({
          xp: newXP,
          level: newLevel,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        // Record activity
        const activityRef = admin.firestore().collection('activities').doc();
        await activityRef.set({
          userId: userId,
          type: 'quest_complete',
          description: `Completed "${after.title}"`,
          xpGained: xp,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      }
    }
  });

// Auth triggers
exports.onUserCreated = functions.auth.user().onCreate(async (user) => {
  const userRef = admin.firestore().collection('users').doc(user.uid);
  await userRef.set({
    uid: user.uid,
    displayName: user.displayName || user.email,
    email: user.email,
    photoURL: user.photoURL,
    phoneNumber: user.phoneNumber,
    level: 1,
    xp: 0,
    dailyTargetXp: 500,
    streak: 0,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });
});

// Scheduled functions
exports.dailyStreakCheck = functions.pubsub
  .schedule('0 0 * * *')
  .timeZone('UTC')
  .onRun(async (context) => {
    // Check all users and update streaks based on daily targets
    const usersRef = admin.firestore().collection('users');
    const snapshot = await usersRef.get();

    const batch = admin.firestore().batch();

    snapshot.forEach((doc) => {
      const userData = doc.data();
      // Logic to check if daily target was met
      // Update streak accordingly
      // This is a simplified version
    });

    await batch.commit();
  });
