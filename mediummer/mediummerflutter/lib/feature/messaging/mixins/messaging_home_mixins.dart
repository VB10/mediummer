import 'package:flutter/material.dart';
import 'package:mediummerflutter/feature/messaging/messaging_system.dart';
import 'package:mediummerflutter/feature/messaging/models/chat_room.dart';
import 'package:mediummerflutter/feature/messaging/models/user.dart';
import 'package:mediummerflutter/feature/messaging/views/chat_detail_page.dart';

mixin MessagingHomeMixins<T extends StatefulWidget> on State<T> {
  final MessagingSystem messagingSystem = MessagingSystem();
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  User? currentUser;
  List<ChatRoom> availableRooms = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    _userNameController.dispose();
    messagingSystem.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    // Create some initial users and rooms
    final alice = messagingSystem.createUser('Alice', '👩‍💼');
    final bob = messagingSystem.createUser('Bob', '👨‍💻');
    final charlie = messagingSystem.createUser('Charlie', '👨‍🎨');

    final generalRoom = messagingSystem.createChatRoom(
      'General Chat',
      [alice, bob, charlie],
    );
    final workRoom = messagingSystem.createChatRoom(
      'Work Discussion',
      [alice, bob],
    );
    final artRoom = messagingSystem.createChatRoom(
      'Art & Design',
      [charlie, alice],
    );

    setState(() {
      availableRooms = messagingSystem.chatRooms;
      currentUser = alice; // Default user
    });
  }

  void _createNewRoom() {
    if (_roomNameController.text.trim().isEmpty) return;

    final newRoom = messagingSystem.createChatRoom(
      _roomNameController.text.trim(),
      [currentUser!],
    );

    setState(() {
      availableRooms = messagingSystem.chatRooms;
      _roomNameController.clear();
    });

    Navigator.pop(context);
  }

  void navigateToChat(ChatRoom room) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailPage(
          chatRoom: room,
          currentUser: currentUser!,
          messagingSystem: messagingSystem,
        ),
      ),
    );
  }

  // Mixin method implementations
  @override
  User? getCurrentUser() => currentUser;

  @override
  TextEditingController getUserNameController() => _userNameController;

  @override
  TextEditingController getRoomNameController() => _roomNameController;

  @override
  void createNewRoom() => _createNewRoom();

  void showUserProfile() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Name: ${getCurrentUser()?.name ?? 'Unknown'}'),
            Text('Avatar: ${getCurrentUser()?.avatar ?? '👤'}'),
            const SizedBox(height: 16),
            TextField(
              controller: getUserNameController(),
              decoration: const InputDecoration(
                labelText: 'New Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (getUserNameController().text.trim().isNotEmpty) {
                // In a real app, you'd update the user name
                setState(() {
                  // Update user name logic would go here
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void showCreateRoomDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Chat Room'),
        content: TextField(
          controller: getRoomNameController(),
          decoration: const InputDecoration(
            labelText: 'Room Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: createNewRoom,
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
