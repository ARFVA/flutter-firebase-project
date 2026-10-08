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
      appBar: AppBar(
        title: const Text('Study Room'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          Obx(() => PopupMenuButton<String>(
            icon: Icon(roomController.currentStatus == 'studying' ? Icons.book : Icons.coffee),
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
            icon: const Icon(Icons.exit_to_app),
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
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'No active room',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _showCreateRoomDialog(roomController),
                  icon: const Icon(Icons.add),
                  label: const Text('Create Room'),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _showJoinRoomDialog(roomController),
                  icon: const Icon(Icons.login),
                  label: const Text('Join Room'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
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

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.2),
          child: Icon(statusIcon, color: statusColor),
        ),
        title: Text(participant.displayName),
        subtitle: Text(participant.status.toUpperCase()),
        trailing: Text(
          _formatTime(participant.lastSeen),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
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
            hintText: 'Firebase Study Room',
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
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }
}
