import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyquest/features/quests/controllers/quest_controller.dart';
import 'package:studyquest/data/models/quest_model.dart';
import 'package:studyquest/features/quests/views/create_quest_screen.dart';

class QuestListScreen extends StatelessWidget {
  const QuestListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final questController = Get.find<QuestController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Quests',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                Get.to(() => const CreateQuestScreen());
              },
              icon: const Icon(Icons.add, size: 20),
              label: const Text('New', style: TextStyle(fontSize: 14)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Create your first quest to start earning XP!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Get.to(() => const CreateQuestScreen()),
                  icon: const Icon(Icons.add),
                  label: const Text('Create Quest'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
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
              TabBar(
                labelColor: Colors.grey,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
                tabs: [
                  Tab(
                    text: 'Active (${questController.activeQuests.length})',
                  ),
                  Tab(
                    text: 'Completed (${questController.completedQuests.length})',
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildQuestList(questController.activeQuests, questController),
                    _buildQuestList(questController.completedQuests, questController),
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
            Text(
              'No quests in this category',
              style: TextStyle(
                color: Colors.grey,
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
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: quest.isCompleted ? Colors.grey.shade100 : Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            quest.type == 'timer' ? Icons.timer : Icons.checklist,
            color: quest.isCompleted ? Colors.grey : Colors.white,
          ),
        ),
        title: Text(
          quest.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: quest.isCompleted ? TextDecoration.lineThrough : null,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quest.description,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.black),
                const SizedBox(width: 4),
                Text(
                  '${quest.xp} XP',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (quest.durationMinutes != null) ...[
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${quest.durationMinutes} min',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: quest.isCompleted
            ? const Icon(Icons.check_circle, color: Colors.grey)
            : IconButton(
                icon: const Icon(Icons.check_circle_outline),
                onPressed: () async {
                  Get.defaultDialog(
                    title: 'Complete Quest',
                    middleText: 'Mark this quest as completed?',
                    textConfirm: 'Complete',
                    textCancel: 'Cancel',
                    onConfirm: () async {
                      Get.back();
                      await controller.completeQuest(quest.id);
                    },
                  );
                },
              ),
        onTap: () {
          // TODO: Navigate to quest detail/edit screen
        },
      ),
    );
  }
}
