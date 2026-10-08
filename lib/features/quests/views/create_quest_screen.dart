import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyquest/features/quests/controllers/quest_controller.dart';

class CreateQuestScreen extends StatefulWidget {
  const CreateQuestScreen({super.key});

  @override
  State<CreateQuestScreen> createState() => _CreateQuestScreenState();
}

class _CreateQuestScreenState extends State<CreateQuestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _xpController = TextEditingController(text: '100');
  final _durationController = TextEditingController();

  String _selectedType = 'checklist';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _xpController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questController = Get.find<QuestController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quest'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Quest Title',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Quest Type',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'checklist',
                  label: Row(
                    children: [
                      Icon(Icons.checklist),
                      SizedBox(width: 8),
                      Text('Checklist'),
                    ],
                  ),
                ),
                ButtonSegment(
                  value: 'timer',
                  label: Row(
                    children: [
                      Icon(Icons.timer),
                      SizedBox(width: 8),
                      Text('Timer'),
                    ],
                  ),
                ),
              ],
              selected: {_selectedType},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedType = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _xpController,
              decoration: const InputDecoration(
                labelText: 'XP Reward',
                prefixIcon: Icon(Icons.star),
                border: OutlineInputBorder(),
                suffixText: 'XP',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter XP amount';
                }
                final xp = int.tryParse(value);
                if (xp == null || xp <= 0) {
                  return 'Please enter a valid XP amount';
                }
                return null;
              },
            ),
            if (_selectedType == 'timer') ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Duration (minutes)',
                  prefixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                  suffixText: 'min',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter duration';
                  }
                  final duration = int.tryParse(value);
                  if (duration == null || duration <= 0) {
                    return 'Please enter a valid duration';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 24),
            Obx(() => ElevatedButton(
              onPressed: questController.isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        questController.createQuest(
                          title: _titleController.text.trim(),
                          description: _descriptionController.text.trim(),
                          type: _selectedType,
                          xp: int.parse(_xpController.text),
                          durationMinutes: _selectedType == 'timer'
                              ? int.parse(_durationController.text)
                              : null,
                        );
                        if (!questController.isLoading) {
                          Get.back();
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: questController.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Create Quest',
                      style: TextStyle(fontSize: 16),
                    ),
            )),
          ],
        ),
      ),
    );
  }
}
