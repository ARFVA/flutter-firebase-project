import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:studyquest/core/theme/app_theme.dart';
import 'package:studyquest/controllers/room_controller.dart';
import 'package:studyquest/data/models/room_model.dart';

class StudyRoomScreen extends StatelessWidget {
  const StudyRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roomController = Get.find<RoomController>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.groups_rounded,
              color: AppTheme.primaryColor,
              size: 24,
            ),
            const SizedBox(width: 10),
            const Text('Study Room'),
          ],
        ),
        actions: [
          Obx(() {
            if (roomController.currentRoomId.isEmpty) {
              return const SizedBox.shrink();
            }

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PopupMenuButton<String>(
                  icon: Icon(
                    roomController.currentStatus == 'studying'
                        ? Icons.book_rounded
                        : Icons.coffee_rounded,
                    color: AppTheme.primaryColor,
                  ),
                  onSelected: roomController.updateStatus,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'studying',
                      child: Row(
                        children: [
                          Icon(Icons.book_rounded, size: 20),
                          SizedBox(width: 8),
                          Text('Studying'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'break',
                      child: Row(
                        children: [
                          Icon(Icons.coffee_rounded, size: 20),
                          SizedBox(width: 8),
                          Text('Break'),
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.exit_to_app_rounded),
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Leave Room'),
                        content: const Text('Are you sure you want to leave?'),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () {
                              Get.back();
                              roomController.leaveRoom();
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Leave'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          }),
        ],
      ),
      body: Obx(() {
        if (roomController.currentRoomId.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.meeting_room_outlined,
                  size: 80,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 24),
                const Text(
                  'No active room',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Create or join a study room to study together',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.icon(
                      onPressed: () => _showCreateRoomDialog(roomController),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Create Room'),
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
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () => _showJoinRoomDialog(roomController),
                      icon: const Icon(Icons.login_rounded, size: 18),
                      label: const Text('Join Room'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        side: const BorderSide(color: AppTheme.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.meeting_room_outlined,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Room ID',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          roomController.currentRoomId,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 20),
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: roomController.currentRoomId),
                      );
                      Get.snackbar(
                        'Room ID',
                        'Copied to clipboard!',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green.shade700,
                        colorText: Colors.white,
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final participants = roomController.participants;

                if (participants.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: participants.length,
                  itemBuilder: (context, index) {
                    final participant = participants.values.elementAt(index);
                    return _buildParticipantCard(participant);
                  },
                );
              }),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildParticipantCard(ParticipantModel participant) {
    IconData statusIcon;
    Color statusColor;

    switch (participant.status) {
      case 'studying':
        statusIcon = Icons.circle;
        statusColor = AppTheme.successColor;
        break;
      case 'break':
        statusIcon = Icons.circle;
        statusColor = Colors.orange;
        break;
      default:
        statusIcon = Icons.circle;
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.14),
          child: Icon(statusIcon, color: statusColor),
        ),
        title: Text(
          participant.displayName,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              participant.status.toUpperCase(),
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(participant.lastSeen),
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showCreateRoomDialog(RoomController controller) {
    final roomNameController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Create Study Room'),
        content: TextField(
          controller: roomNameController,
          decoration: const InputDecoration(
            labelText: 'Room Name',
            hintText: 'Study Session 1',
            prefixIcon: Icon(Icons.meeting_room_outlined, size: 20),
            prefixIconColor: AppTheme.primaryColor,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final name = roomNameController.text.trim();
              if (name.isNotEmpty) {
                Get.back();
                controller.createRoom(name);
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showJoinRoomDialog(RoomController controller) {
    final roomIdController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Join Study Room'),
        content: TextField(
          controller: roomIdController,
          decoration: const InputDecoration(
            labelText: 'Room ID',
            hintText: 'Enter room ID',
            prefixIcon: Icon(Icons.key_rounded, size: 20),
            prefixIconColor: AppTheme.primaryColor,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final roomId = roomIdController.text.trim();
              if (roomId.isNotEmpty) {
                Get.back();
                controller.joinRoom(roomId);
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }
}
