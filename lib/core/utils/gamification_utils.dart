import 'dart:math' as math;

class GamificationUtils {
  /// Level calculation formula
  /// Level = floor(sqrt(XP / 100)) + 1
  /// This means:
  /// - Level 1: 0-99 XP
  /// - Level 2: 100-399 XP (100-399)
  /// - Level 3: 400-899 XP (400-899)
  /// - Level 4: 900-1599 XP (900-1599)
  /// And so on...
  static int calculateLevel(int xp) {
    return math.sqrt(xp / 100).floor() + 1;
  }

  /// Calculate XP required for next level
  static int xpForNextLevel(int currentLevel) {
    return (currentLevel * currentLevel) * 100;
  }

  /// Calculate XP progress to next level (0.0 to 1.0)
  static double levelProgress(int xp, int currentLevel) {
    final xpAtCurrentLevel = ((currentLevel - 1) * (currentLevel - 1)) * 100;
    final xpForNext = xpForNextLevel(currentLevel);
    final xpRange = xpForNext - xpAtCurrentLevel;
    final currentProgress = xp - xpAtCurrentLevel;
    
    if (xpRange == 0) return 1.0;
    return (currentProgress / xpRange).clamp(0.0, 1.0);
  }

  /// Check if daily target is met
  static bool isDailyTargetMet(int dailyXp, int dailyTargetXp) {
    return dailyXp >= dailyTargetXp;
  }

  /// Calculate streak based on consecutive successful days
  /// This is a simplified version - in production, this should be
  /// calculated server-side to prevent client-side manipulation
  static int calculateStreak(
    int currentStreak,
    bool wasSuccessfulYesterday,
    bool isSuccessfulToday,
  ) {
    if (!isSuccessfulToday) {
      return 0; // Reset streak if today is not successful
    }
    
    if (wasSuccessfulYesterday) {
      return currentStreak + 1; // Continue streak
    }
    
    return 1; // Start new streak
  }

  /// Get total XP for today from a list of activities
  static int calculateDailyXp(List<dynamic> activities, DateTime date) {
    return activities
        .where((activity) {
          final activityDate = DateTime.parse(activity['createdAt']);
          return activityDate.year == date.year &&
                 activityDate.month == date.month &&
                 activityDate.day == date.day;
        })
        .fold(0, (sum, activity) => sum + (activity['xpGained'] as int));
  }
}
