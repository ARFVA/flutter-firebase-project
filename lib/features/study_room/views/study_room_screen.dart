import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyquest/features/study_room/controllers/room_controller.dart';
import 'package:studyquest/data/models/room_model.dart';

class StudyRoomScreen extends StatelessWidget {
  const StudyRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roomController = Get.find<RoomController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Study Room',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Obx(() => PopupMenuButton<String>(
            icon: Icon(
              roomController.currentStatus == 'studying' ? Icons.book : Icons.coffee,
              color: Colors.black,
            ),
            onSelected: (status) {
              roomController.updateStatus(status);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'studying',
                child: Row(
                  children: [
                    Icon(Icons.book, size: 20),
                    SizedBox(width: 8),
                    Text('Studying'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'break',
                child: Row(
                  children: [
                    Icon(Icons.coffee, size: 20),
                    SizedBox(width: 8),
                    Text('Break'),
                  ],
                ),
              ),
            ],
          )),
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.black),
            onPressed: () {
              Get.defaultDialog(
                title: 'Leave Room',
                middleText: 'Are you sure you want to leave?',
                textConfirm: 'Leave',
                textCancel: 'Cancel',
                onConfirm: () {
                  Get.back();
                  roomController.leaveRoom();
                },
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (roomController.currentRoomId.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.meeting_room,
                  size: 80,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 24),
                const Text(
                  'No active room',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Create or join a study room to study together',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _showCreateRoomDialog(roomController),
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text('Create Room'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () => _showJoinRoomDialog(roomController),
                      icon: const Icon(Icons.login, size: 20),
                      label: const Text('Join Room'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
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
            // Room info header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.meeting_room, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Room ID',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              roomController.currentRoomId,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 20),
                        onPressed: () {
                          // Copy room ID to clipboard
                          // Note: Need to add flutter/services dependency for clipboard
                          Get.snackbar(
                            'Room ID',
                            roomController.currentRoomId,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.black87,
                            colorText: Colors.white,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final participants = roomController.participants;
                
                if (participants.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
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
        statusColor = Colors.green;
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
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.2),
          child: Icon(statusIcon, color: statusColor),
        ),
        title: Text(
          participant.displayName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              participant.status.toUpperCase(),
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(participant.lastSeen),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
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
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (roomNameController.text.trim().isNotEmpty) {
                Get.back();
                controller.createRoom(roomNameController.text.trim());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
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
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (roomIdController.text.trim().isNotEmpty) {
                Get.back();
                controller.joinRoom(roomIdController.text.trim());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }
}
