import 'package:mediummerflutter/feature/messaging/mediator/messaging_mediator.dart';
import 'package:mediummerflutter/feature/messaging/models/user.dart';

/// UserManager is a colleague that manages users
/// It communicates with other components through the mediator
class UserManager {
  // userId -> chatRoomIds

  UserManager(this._mediator) {
    // Register with the mediator
    _mediator.registerColleague(this);
  }
  final MessagingMediator _mediator;
  final Map<String, User> _users = {};
  final Map<String, List<String>> _userChatRooms = {};

  /// Create a new user
  User createUser(String name, String avatar) {
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      avatar: avatar,
    );

    _users[user.id] = user;
    _userChatRooms[user.id] = [];

    print('UserManager: Created user ${user.name}');
    return user;
  }

  /// Join a user to a chat room
  void joinChatRoom(User user, String chatRoomId) {
    if (_users.containsKey(user.id)) {
      _userChatRooms[user.id] ??= [];
      _userChatRooms[user.id]!.add(chatRoomId);

      // Notify mediator about user joining
      _mediator.notify(
        sender: this,
        event: MessagingEvent.userJoined,
        data: {
          'user': user,
          'chatRoomId': chatRoomId,
        },
      );

      print('UserManager: User ${user.name} joined chat room $chatRoomId');
    }
  }

  /// Remove a user from a chat room
  void leaveChatRoom(User user, String chatRoomId) {
    if (_users.containsKey(user.id)) {
      _userChatRooms[user.id]?.remove(chatRoomId);

      // Notify mediator about user leaving
      _mediator.notify(
        sender: this,
        event: MessagingEvent.userLeft,
        data: {
          'user': user,
          'chatRoomId': chatRoomId,
        },
      );

      print('UserManager: User ${user.name} left chat room $chatRoomId');
    }
  }

  /// Start typing indicator for a user
  void startTyping(User user, String chatRoomId) {
    // Notify mediator about user typing
    _mediator.notify(
      sender: this,
      event: MessagingEvent.userTyping,
      data: {
        'user': user,
        'chatRoomId': chatRoomId,
      },
    );

    print('UserManager: User ${user.name} started typing in room $chatRoomId');
  }

  /// Stop typing indicator for a user
  void stopTyping(User user, String chatRoomId) {
    // Notify mediator about user stopped typing
    _mediator.notify(
      sender: this,
      event: MessagingEvent.userStoppedTyping,
      data: {
        'user': user,
        'chatRoomId': chatRoomId,
      },
    );

    print('UserManager: User ${user.name} stopped typing in room $chatRoomId');
  }

  /// Mark a message as read by a user
  void markMessageAsRead(String messageId, String userId) {
    // Notify mediator about message read
    _mediator.notify(
      sender: this,
      event: MessagingEvent.messageRead,
      data: {
        'messageId': messageId,
        'userId': userId,
      },
    );

    print('UserManager: User $userId marked message $messageId as read');
  }

  /// Get all users
  List<User> get users => _users.values.toList();

  /// Get a user by ID
  User? getUserById(String userId) {
    return _users[userId];
  }

  /// Get chat rooms for a specific user
  List<String> getUserChatRooms(String userId) {
    return _userChatRooms[userId] ?? [];
  }

  /// Check if a user is in a specific chat room
  bool isUserInChatRoom(String userId, String chatRoomId) {
    return _userChatRooms[userId]?.contains(chatRoomId) ?? false;
  }

  /// Dispose the manager
  void dispose() {
    _mediator.unregisterColleague(this);
  }
}
