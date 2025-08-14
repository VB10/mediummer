import 'package:mediummerflutter/feature/messaging/colleagues/chat_room_manager.dart';
import 'package:mediummerflutter/feature/messaging/colleagues/message_logger.dart';
import 'package:mediummerflutter/feature/messaging/colleagues/notification_service.dart';
import 'package:mediummerflutter/feature/messaging/colleagues/user_manager.dart';
import 'package:mediummerflutter/feature/messaging/mediator/concrete_messaging_mediator.dart';
import 'package:mediummerflutter/feature/messaging/mediator/messaging_mediator.dart';
import 'package:mediummerflutter/feature/messaging/models/chat_room.dart';
import 'package:mediummerflutter/feature/messaging/models/message.dart';
import 'package:mediummerflutter/feature/messaging/models/user.dart';

/// MessagingSystem is a facade that provides a simple interface to the messaging system
/// It demonstrates the Mediator pattern by coordinating all components through the mediator
class MessagingSystem {
  /// Initialize the messaging system with all components
  MessagingSystem() {
    // Create the mediator first
    _mediator = ConcreteMessagingMediator();

    // Create all colleagues and register them with the mediator
    _chatRoomManager = ChatRoomManager(_mediator);
    _userManager = UserManager(_mediator);
    _notificationService = NotificationService(_mediator);
    _messageLogger = MessageLogger(_mediator);

    print(
        'MessagingSystem: All components initialized and registered with mediator');
  }
  late final MessagingMediator _mediator;
  late final ChatRoomManager _chatRoomManager;
  late final UserManager _userManager;
  late final NotificationService _notificationService;
  late final MessageLogger _messageLogger;

  /// Create a new user
  User createUser(String name, String avatar) {
    return _userManager.createUser(name, avatar);
  }

  /// Create a new chat room
  ChatRoom createChatRoom(String name, List<User> participants) {
    return _chatRoomManager.createChatRoom(name, participants);
  }

  /// Join a user to a chat room
  void joinChatRoom(User user, String chatRoomId) {
    _userManager.joinChatRoom(user, chatRoomId);
  }

  /// Leave a chat room
  void leaveChatRoom(User user, String chatRoomId) {
    _userManager.leaveChatRoom(user, chatRoomId);
  }

  /// Send a message to a chat room
  void sendMessage(User sender, String content, String chatRoomId) {
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      sender: sender,
      timestamp: DateTime.now(),
      chatRoomId: chatRoomId,
    );

    // Notify mediator about message sent
    _mediator.notify(
      sender: this,
      event: MessagingEvent.messageSent,
      data: {'message': message},
    );
  }

  /// Start typing indicator
  void startTyping(User user, String chatRoomId) {
    _userManager.startTyping(user, chatRoomId);
  }

  /// Stop typing indicator
  void stopTyping(User user, String chatRoomId) {
    _userManager.stopTyping(user, chatRoomId);
  }

  /// Mark a message as read
  void markMessageAsRead(String messageId, String userId) {
    _userManager.markMessageAsRead(messageId, userId);
  }

  /// Get all chat rooms
  List<ChatRoom> get chatRooms => _chatRoomManager.chatRooms;

  /// Get all users
  List<User> get users => _userManager.users;

  /// Get messages for a specific room
  List<Message> getMessagesForRoom(String chatRoomId) {
    return _chatRoomManager.getMessagesForRoom(chatRoomId);
  }

  /// Get notification history
  List<String> get notificationHistory =>
      _notificationService.notificationHistory;

  /// Get log history
  List<String> get logHistory => _messageLogger.logHistory;

  /// Get event history from mediator (for debugging)
  List<Map<String, dynamic>> get eventHistory {
    if (_mediator is ConcreteMessagingMediator) {
      return (_mediator as ConcreteMessagingMediator).eventHistory;
    }
    return [];
  }

  /// Send a custom notification
  void sendCustomNotification(String message) {
    _notificationService.sendCustomNotification(message);
  }

  /// Search logs by keyword
  List<String> searchLogs(String keyword) {
    return _messageLogger.searchLogs(keyword);
  }

  /// Clear all history (for testing)
  void clearAllHistory() {
    _notificationService.clearNotificationHistory();
    _messageLogger.clearLogHistory();
    if (_mediator is ConcreteMessagingMediator) {
      (_mediator as ConcreteMessagingMediator).clearEventHistory();
    }
  }

  /// Dispose all components
  void dispose() {
    _chatRoomManager.dispose();
    _userManager.dispose();
    _notificationService.dispose();
    _messageLogger.dispose();
    print('MessagingSystem: All components disposed');
  }
}
