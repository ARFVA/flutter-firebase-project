import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyquest/data/models/room_model.dart';
import 'package:studyquest/data/repositories/room_repository_impl.dart';
import 'package:studyquest/controllers/auth_controller.dart';
import 'package:uuid/uuid.dart';

class RoomController extends GetxController {
  final RoomRepository repository;
  final AuthController authController;

  RoomController(this.repository, this.authController);

  final RxMap<String, ParticipantModel> _participants = <String, ParticipantModel>{}.obs;
  Map<String, ParticipantModel> get participants => _participants;

  final RxString _currentRoomId = ''.obs;
  String get currentRoomId => _currentRoomId.value;

  final RxString _currentStatus = 'studying'.obs;
  String get currentStatus => _currentStatus.value;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  StreamSubscription? _participantsSubscription;

  void createRoom(String roomName) {
    final user = authController.currentUser;
    if (user == null) return;

    _isLoading.value = true;

    final roomId = const Uuid().v4();
    final room = RoomModel.create(
      roomId: roomId,
      roomName: roomName,
      createdBy: user.uid,
    );

    repository.createRoom(room).then((result) {
      result.fold(
        (failure) {
          _isLoading.value = false;
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade700,
            colorText: Colors.white,
          );
        },
        (createdRoomId) {
          _currentRoomId.value = createdRoomId;
          _isLoading.value = false;
          joinRoom(createdRoomId);
        },
      );
    });
  }

  void joinRoom(String roomId) {
    final user = authController.currentUser;
    if (user == null) return;

    _isLoading.value = true;
    _currentRoomId.value = roomId;

    final participant = ParticipantModel.create(
      userId: user.uid,
      displayName: user.displayName ?? user.email ?? 'User',
    );

    repository.joinRoom(roomId, user.uid, participant).then((result) {
      result.fold(
        (failure) {
          _isLoading.value = false;
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade700,
            colorText: Colors.white,
          );
        },
        (_) {
          _isLoading.value = false;
          _listenToParticipants(roomId);
          Get.snackbar(
            'Success',
            'Joined room successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade700,
            colorText: Colors.white,
          );
        },
      );
    });
  }

  void _listenToParticipants(String roomId) {
    _participantsSubscription?.cancel();
    _participantsSubscription = repository.getParticipants(roomId).listen(
      (participants) {
        _participants.value = participants;
      },
    );
  }

  void updateStatus(String status) {
    final user = authController.currentUser;
    if (user == null || _currentRoomId.value.isEmpty) return;

    _currentStatus.value = status;

    repository.updateStatus(_currentRoomId.value, user.uid, status);
  }

  void leaveRoom() {
    final user = authController.currentUser;
    if (user == null || _currentRoomId.value.isEmpty) return;

    repository.leaveRoom(_currentRoomId.value, user.uid).then((result) {
      result.fold(
        (failure) {
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade700,
            colorText: Colors.white,
          );
        },
        (_) {
          _participantsSubscription?.cancel();
          _participants.value = {};
          _currentRoomId.value = '';
          Get.snackbar(
            'Success',
            'Left room',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade700,
            colorText: Colors.white,
          );
        },
      );
    });
  }

  @override
  void onClose() {
    _participantsSubscription?.cancel();
    super.onClose();
  }
}
