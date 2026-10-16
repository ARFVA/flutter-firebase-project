import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyquest/core/theme/app_theme.dart';
import 'package:studyquest/controllers/quest_controller.dart';
import 'package:studyquest/data/models/quest_model.dart';
import 'package:studyquest/features/quests/views/create_quest_screen.dart';

class QuestListScreen extends StatelessWidget {
  const QuestListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final questController = Get.find<QuestController>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.task_alt_rounded,
              color: AppTheme.primaryColor,
              size: 24,
            ),
            const SizedBox(width: 10),
            const Text('My Quests'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: () => Get.to(() => const CreateQuestScreen()),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('New'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (questController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (questController.activeQuests.isEmpty &&
            questController.completedQuests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 80,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 24),
                const Text(
                  'No quests yet',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Create your first quest to start earning XP!',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => Get.to(() => const CreateQuestScreen()),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Create Quest'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF6B7280),
                  indicator: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                      text: 'Active (${questController.activeQuests.length})',
                    ),
                    Tab(
                      text:
                          'Completed (${questController.completedQuests.length})',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildQuestList(
                      questController.activeQuests,
                      questController,
                    ),
                    _buildQuestList(
                      questController.completedQuests,
                      questController,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildQuestList(List<QuestModel> quests, QuestController controller) {
    if (quests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            const Text(
              'No quests in this category',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: quests.length,
      itemBuilder: (context, index) {
        final quest = quests[index];
        return _buildQuestCard(quest, controller);
      },
    );
  }

  Widget _buildQuestCard(QuestModel quest, QuestController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: quest.isCompleted
                ? Colors.grey.shade100
                : AppTheme.primaryColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            quest.type == 'timer'
                ? Icons.timer_rounded
                : Icons.checklist_rounded,
            color: quest.isCompleted ? Colors.grey : AppTheme.primaryColor,
          ),
        ),
        title: Text(
          quest.title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            decoration: quest.isCompleted ? TextDecoration.lineThrough : null,
            color: const Color(0xFF111827),
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              quest.description,
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: AppTheme.accentColor,
                ),
                const SizedBox(width: 4),
                Text(
                  '${quest.xp} XP',
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (quest.durationMinutes != null) ...[
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.access_time_rounded,
                    size: 16,
                    color: Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${quest.durationMinutes} min',
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: quest.isCompleted
            ? const Icon(
                Icons.check_circle_rounded,
                color: AppTheme.successColor,
              )
            : IconButton(
                icon: const Icon(Icons.check_circle_outline_rounded),
                onPressed: () async {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Complete Quest'),
                      content: const Text('Mark this quest as completed?'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () async {
                            Get.back();
                            await controller.completeQuest(quest.id);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Complete'),
                        ),
                      ],
                    ),
                  );
                },
              ),
        onTap: () {
        },
      ),
    );
  }
}
