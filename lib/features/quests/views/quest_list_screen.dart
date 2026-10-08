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
      appBar: AppBar(
        title: const Text('My Quests'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.to(() => const CreateQuestScreen());
            },
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
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'No quests yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Get.to(() => const CreateQuestScreen()),
                  child: const Text('Create Your First Quest'),
                ),
              ],
            ),
          );
        }

        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Obx(() => TabBar(
                labelColor: Colors.deepPurple,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'Active (${questController.activeQuests.length})'),
                  Tab(text: 'Completed (${questController.completedQuests.length})'),
                ],
              )),
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
        child: Text(
          'No quests in this category',
          style: TextStyle(color: Colors.grey[600]),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: quest.isCompleted ? Colors.green : Colors.deepPurple,
          child: Icon(
            quest.type == 'timer' ? Icons.timer : Icons.checklist,
            color: Colors.white,
          ),
        ),
        title: Text(
          quest.title,
          style: TextStyle(
            decoration: quest.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(quest.description),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text('${quest.xp} XP'),
                if (quest.durationMinutes != null) ...[
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('${quest.durationMinutes} min'),
                ],
              ],
            ),
          ],
        ),
        trailing: quest.isCompleted
            ? const Icon(Icons.check_circle, color: Colors.green)
            : IconButton(
                icon: const Icon(Icons.check_circle_outline),
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Complete Quest',
                    middleText: 'Mark this quest as completed?',
                    textConfirm: 'Complete',
                    textCancel: 'Cancel',
                    onConfirm: () {
                      Get.back();
                      controller.completeQuest(quest.id);
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
