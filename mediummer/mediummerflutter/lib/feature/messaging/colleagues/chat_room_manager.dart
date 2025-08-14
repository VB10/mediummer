import 'package:mediummerflutter/feature/messaging/mediator/messaging_mediator.dart';
import 'package:mediummerflutter/feature/messaging/models/chat_room.dart';
import 'package:mediummerflutter/feature/messaging/models/message.dart';
import 'package:mediummerflutter/feature/messaging/models/user.dart';

/// ChatRoomManager is a colleague that manages chat rooms
/// It communicates with other components through the mediator
class ChatRoomManager {
  ChatRoomManager(this._mediator) {
    // Register with the mediator
    _mediator.registerColleague(this);
  }
  final MessagingMediator _mediator;
  final Map<String, ChatRoom> _chatRooms = {};
  final Map<String, List<Message>> _roomMessages = {};
  final Map<String, Set<String>> _roomParticipants = {};

  /// Create a new chat room
  ChatRoom createChatRoom(String name, List<User> participants) {
    final chatRoom = ChatRoom(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      participants: participants,
      createdAt: DateTime.now(),
    );

    _chatRooms[chatRoom.id] = chatRoom;
    _roomMessages[chatRoom.id] = [];
    _roomParticipants[chatRoom.id] = participants.map((u) => u.id).toSet();

    // Notify mediator about chat room creation
    _mediator.notify(
      sender: this,
      event: MessagingEvent.chatRoomCreated,
      data: {'chatRoom': chatRoom},
    );

    print(
        'ChatRoomManager: Created chat room "${chatRoom.name}" with ${participants.length} participants');
    return chatRoom;
  }

  /// Delete a chat room
  void deleteChatRoom(String chatRoomId) {
    if (_chatRooms.containsKey(chatRoomId)) {
      final chatRoom = _chatRooms[chatRoomId];
      _chatRooms.remove(chatRoomId);
      _roomMessages.remove(chatRoomId);
      _roomParticipants.remove(chatRoomId);

      // Notify mediator about chat room deletion
      _mediator.notify(
        sender: this,
        event: MessagingEvent.chatRoomDeleted,
        data: {'chatRoomId': chatRoomId},
      );

      print('ChatRoomManager: Deleted chat room "${chatRoom?.name}"');
    }
  }

  /// Add a user to a chat room
  void addUserToRoom(String chatRoomId, User user) {
    if (_chatRooms.containsKey(chatRoomId)) {
      _roomParticipants[chatRoomId]?.add(user.id);
      _chatRooms[chatRoomId]!.participants.add(user);

      print('ChatRoomManager: Added user ${user.name} to room $chatRoomId');
    }
  }

  /// Remove a user from a chat room
  void removeUserFromRoom(String chatRoomId, User user) {
    if (_chatRooms.containsKey(chatRoomId)) {
      _roomParticipants[chatRoomId]?.remove(user.id);
      _chatRooms[chatRoomId]!.participants.removeWhere((u) => u.id == user.id);

      print('ChatRoomManager: Removed user ${user.name} from room $chatRoomId');
    }
  }

  /// Add a message to a chat room
  void addMessageToRoom(String chatRoomId, Message message) {
    if (_roomMessages.containsKey(chatRoomId)) {
      _roomMessages[chatRoomId]!.add(message);
      print(
          'ChatRoomManager: Added message to room $chatRoomId: ${message.content}');
    }
  }

  /// Mark a message as read
  void markMessageAsRead(String chatRoomId, String messageId) {
    // Implementation for marking message as read
    print(
        'ChatRoomManager: Marked message $messageId as read in room $chatRoomId');
  }

  /// Mark a message as read by a specific user
  void markMessageAsReadByUser(String messageId, String userId) {
    // Implementation for marking message as read by specific user
    print('ChatRoomManager: User $userId marked message $messageId as read');
  }

  /// Get all chat rooms
  List<ChatRoom> get chatRooms => _chatRooms.values.toList();

  /// Get messages for a specific room
  List<Message> getMessagesForRoom(String chatRoomId) {
    return _roomMessages[chatRoomId] ?? [];
  }

  /// Get participants for a specific room
  Set<String> getParticipantsForRoom(String chatRoomId) {
    return _roomParticipants[chatRoomId] ?? {};
  }

  /// Dispose the manager
  void dispose() {
    _mediator.unregisterColleague(this);
  }
}
