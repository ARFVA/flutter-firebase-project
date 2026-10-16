import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyquest/core/theme/app_theme.dart';
import 'package:studyquest/core/utils/formatters.dart';
import 'package:studyquest/core/utils/gamification_utils.dart';
import 'package:studyquest/controllers/auth_controller.dart';
import 'package:studyquest/controllers/profile_controller.dart';
import 'package:studyquest/features/quests/views/quest_list_screen.dart';
import 'package:studyquest/features/study_room/views/study_room_screen.dart';
import 'package:studyquest/data/models/user_profile_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showEditNameDialog(
    UserProfileModel? profile,
    dynamic user,
    ProfileController profileController,
    AuthController authController,
  ) {
    final nameController = TextEditingController(
      text: profile?.displayName ?? user.displayName ?? '',
    );

    Get.dialog(
      AlertDialog(
        title: const Text(
          'Edit Display Name',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Display Name',
            hintText: 'Enter your name',
            prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
            prefixIconColor: AppTheme.primaryColor,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final trimmedName = nameController.text.trim();
              if (trimmedName.isEmpty) {
                return;
              }

              Get.back();

              if (profile != null) {
                final updatedProfile = profile.copyWith(
                  displayName: trimmedName,
                  updatedAt: DateTime.now(),
                );
                await profileController.updateUserProfile(updatedProfile);
                await authController.refreshCurrentUserWithProfile(
                  updatedProfile,
                );
              }

              await profileController.loadProfile();

              Get.snackbar(
                'Success',
                'Display name updated!',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green.shade700,
                colorText: Colors.white,
                borderRadius: 12,
                margin: const EdgeInsets.all(16),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(AuthController authController) {
    Get.dialog(
      AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Get.back();
              authController.logout();
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final profileController = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.auto_stories_rounded,
              color: AppTheme.primaryColor,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text(
              'StudyQuest',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _showSignOutDialog(authController),
            icon: const Icon(Icons.logout_rounded, size: 20),
            label: const Text('Sign out', style: TextStyle(fontSize: 14)),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final user = authController.currentUser;
        final profile = profileController.profile;

        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentLevel = profile != null
            ? GamificationUtils.calculateLevel(profile.xp)
            : 1;
        final xpAtCurrentLevel =
            ((currentLevel - 1) * (currentLevel - 1)) * 100;
        final xpForNextLevel = (currentLevel * currentLevel) * 100;
        final xpInCurrentLevel = profile != null
            ? (profile.xp - xpAtCurrentLevel)
                  .clamp(0, xpForNextLevel)
                  .toInt()
            : 0;
        final xpNeededForNextLevel = profile != null
            ? (xpForNextLevel - xpAtCurrentLevel)
                  .clamp(1, 1 << 30)
                  .toInt()
            : 1;
        final levelProgress = profile != null
            ? (xpInCurrentLevel / xpNeededForNextLevel)
                  .clamp(0.0, 1.0)
                  .toDouble()
            : 0.0;
        final dailyTargetXp = profile?.dailyTargetXp ?? 500;
        final todayXp = profileController.todayXp;
        final dailyProgress = dailyTargetXp > 0
            ? (todayXp / dailyTargetXp).clamp(0.0, 1.0).toDouble()
            : 0.0;

        return RefreshIndicator(
          onRefresh: () => profileController.loadProfile(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User info header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: AppTheme.primaryColor.withValues(
                          alpha: 0.10,
                        ),
                        child: Text(
                          user.displayName?.substring(0, 1).toUpperCase() ??
                              'U',
                          style: const TextStyle(
                            fontSize: 28,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showEditNameDialog(
                                  profile,
                                  user,
                                  profileController,
                                  authController,
                                );
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      profile?.displayName ??
                                          user.displayName ??
                                          user.email ??
                                          'User',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF111827),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.edit_rounded,
                                    size: 16,
                                    color: AppTheme.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              user.email ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Stats
                if (profile != null) ...[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: AppTheme.accentColor,
                                size: 24,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                formatNumber(profile.xp),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                              const Text(
                                'Total XP',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 100,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.emoji_events_rounded,
                                color: AppTheme.primaryColor,
                                size: 24,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                formatNumber(profile.level),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const Text(
                                'Level',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 100,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.local_fire_department_rounded,
                                color: AppTheme.secondaryColor,
                                size: 24,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${profile.streak}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                              const Text(
                                'Streak',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Daily Target',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111827),
                              ),
                            ),
                            Text(
                              '${formatNumberWithSeparator(profile.dailyTargetXp)} XP',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: dailyProgress,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryColor,
                          ),
                          minHeight: 8,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${formatNumberWithSeparator(todayXp)}/${formatNumberWithSeparator(profile.dailyTargetXp)} XP today',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Level Progress',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111827),
                              ),
                            ),
                            Text(
                              'Level ${profile.level}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: levelProgress,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppTheme.secondaryColor,
                          ),
                          minHeight: 8,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${formatNumberWithSeparator(xpInCurrentLevel)}/${formatNumberWithSeparator(xpNeededForNextLevel)} XP to next level',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Get.to(() => const QuestListScreen()),
                        icon: const Icon(Icons.task_alt_rounded),
                        label: const Text('My Quests'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Get.to(() => const StudyRoomScreen()),
                        icon: const Icon(Icons.group_rounded),
                        label: const Text('Study Room'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
