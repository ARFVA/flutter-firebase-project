import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyquest/core/theme/app_theme.dart';
import 'package:studyquest/core/utils/formatters.dart';
import 'package:studyquest/controllers/quest_controller.dart';

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
      appBar: AppBar(title: const Text('Create Quest')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Quest Title',
                hintText: 'Learn Flutter basics',
                prefixIcon: const Icon(Icons.title_outlined, size: 20),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppTheme.primaryColor,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
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
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'What do you want to accomplish?',
                prefixIcon: const Icon(Icons.description_outlined, size: 20),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppTheme.primaryColor,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'checklist',
                  label: Row(
                    children: [
                      Icon(Icons.checklist, size: 20),
                      SizedBox(width: 8),
                      Text('Checklist'),
                    ],
                  ),
                ),
                ButtonSegment(
                  value: 'timer',
                  label: Row(
                    children: [
                      Icon(Icons.timer, size: 20),
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
              decoration: InputDecoration(
                labelText: 'XP Reward',
                hintText: '100',
                prefixIcon: const Icon(Icons.star_outlined, size: 20),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppTheme.primaryColor,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                suffixText: 'XP',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                ThousandsSeparatorInputFormatter(),
                LengthLimitingTextInputFormatter(
                  8,
                ), // Max 8 digits with separator
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter XP amount';
                }
                final xp = int.tryParse(value.replaceAll('.', ''));
                if (xp == null || xp <= 0) {
                  return 'Please enter a valid XP amount';
                }
                if (xp > 10000) {
                  return 'Maximum XP is 10.000';
                }
                return null;
              },
            ),
            if (_selectedType == 'timer') ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(
                  labelText: 'Duration (minutes)',
                  hintText: '30',
                  prefixIcon: const Icon(Icons.access_time_outlined, size: 20),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryColor,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  suffixText: 'min',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  ThousandsSeparatorInputFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter duration';
                  }
                  final duration = int.tryParse(value.replaceAll('.', ''));
                  if (duration == null || duration <= 0) {
                    return 'Please enter a valid duration';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 24),
            Obx(
              () => ElevatedButton(
                onPressed: questController.isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          // Remove dots from XP input before parsing
                          final xpValue = int.parse(
                            _xpController.text.replaceAll('.', ''),
                          );
                          final durationValue = _selectedType == 'timer'
                              ? int.parse(
                                  _durationController.text.replaceAll('.', ''),
                                )
                              : null;

                          questController.createQuest(
                            title: _titleController.text.trim(),
                            description: _descriptionController.text.trim(),
                            type: _selectedType,
                            xp: xpValue,
                            durationMinutes: durationValue,
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: questController.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Create Quest',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
