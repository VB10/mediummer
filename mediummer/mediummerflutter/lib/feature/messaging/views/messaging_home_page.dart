import 'package:flutter/material.dart';
import 'package:mediummerflutter/feature/messaging/mixins/messaging_home_mixins.dart';
import 'package:mediummerflutter/feature/messaging/models/message.dart';

class MessagingHomePage extends StatefulWidget {
  const MessagingHomePage({super.key});

  @override
  State<MessagingHomePage> createState() => _MessagingHomePageState();
}

class _MessagingHomePageState extends State<MessagingHomePage>
    with MessagingHomeMixins {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messaging App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: showUserProfile,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: showCreateRoomDialog,
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar - Chat Rooms
          Expanded(
            child: Column(
              children: [
                // Current User Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        currentUser?.avatar ?? '👤',
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser?.name ?? 'Unknown User',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Online',
                              style: TextStyle(
                                color: Colors.green.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Chat Rooms List
                Expanded(
                  child: availableRooms.isEmpty
                      ? _buildEmptyRoomsView()
                      : _buildRoomsListView(),
                ),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: ColoredBox(
              color: Colors.grey.shade50,
              child: _buildWelcomeContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyRoomsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No chat rooms yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first room!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomsListView() {
    return ListView.builder(
      itemCount: availableRooms.length,
      itemBuilder: (context, index) {
        final room = availableRooms[index];
        final participantCount = room.participants.length;
        final lastMessage = _getLastMessage(room.id);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                room.name[0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              room.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$participantCount participants'),
                if (lastMessage != null)
                  Text(
                    '${lastMessage.sender.name}: ${lastMessage.content}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
            trailing: lastMessage != null
                ? Text(
                    _formatTime(lastMessage.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  )
                : null,
            onTap: () => navigateToChat(room),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 120,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 24),
          Text(
            'Welcome to Messaging App',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Select a chat room from the sidebar to start messaging',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: showCreateRoomDialog,
            icon: const Icon(Icons.add),
            label: const Text('Create New Room'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Message? _getLastMessage(String roomId) {
    final messages = messagingSystem.getMessagesForRoom(roomId);
    if (messages.isNotEmpty) {
      return messages.last;
    }
    return null;
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')}';
    }
  }
}
