import 'package:mediummerflutter/feature/messaging/colleagues/chat_room_manager.dart';
import 'package:mediummerflutter/feature/messaging/colleagues/message_logger.dart';
import 'package:mediummerflutter/feature/messaging/colleagues/notification_service.dart';
import 'package:mediummerflutter/feature/messaging/colleagues/user_manager.dart';
import 'package:mediummerflutter/feature/messaging/mediator/messaging_mediator.dart';
import 'package:mediummerflutter/feature/messaging/models/chat_room.dart';
import 'package:mediummerflutter/feature/messaging/models/message.dart';
import 'package:mediummerflutter/feature/messaging/models/user.dart';

/// Concrete Mediator implementation that coordinates all messaging system components
class ConcreteMessagingMediator implements MessagingMediator {
  // Colleagues that the mediator coordinates
  ChatRoomManager? _chatRoomManager;
  UserManager? _userManager;
  NotificationService? _notificationService;
  MessageLogger? _messageLogger;

  // Event history for debugging
  final List<Map<String, dynamic>> _eventHistory = [];

  @override
  void registerColleague(Object colleague) {
    if (colleague is ChatRoomManager) {
      _chatRoomManager = colleague;
      print('Mediator: ChatRoomManager registered');
    } else if (colleague is UserManager) {
      _userManager = colleague;
      print('Mediator: UserManager registered');
    } else if (colleague is NotificationService) {
      _notificationService = colleague;
      print('Mediator: NotificationService registered');
    } else if (colleague is MessageLogger) {
      _messageLogger = colleague;
      print('Mediator: MessageLogger registered');
    }
  }

  @override
  void unregisterColleague(Object colleague) {
    if (colleague is ChatRoomManager) {
      _chatRoomManager = null;
      print('Mediator: ChatRoomManager unregistered');
    } else if (colleague is UserManager) {
      _userManager = null;
      print('Mediator: UserManager unregistered');
    } else if (colleague is NotificationService) {
      _notificationService = null;
      print('Mediator: NotificationService unregistered');
    } else if (colleague is MessageLogger) {
      _messageLogger = null;
      print('Mediator: MessageLogger unregistered');
    }
  }

  @override
  void notify({
    required Object sender,
    required MessagingEvent event,
    Map<String, dynamic>? data,
  }) {
    // Log the event for debugging
    _logEvent(sender, event, data);

    // Route the event to appropriate colleagues based on the event type
    switch (event) {
      case MessagingEvent.userJoined:
        _handleUserJoined(sender, data);
      case MessagingEvent.userLeft:
        _handleUserLeft(sender, data);
      case MessagingEvent.messageSent:
        _handleMessageSent(sender, data);
      case MessagingEvent.messageReceived:
        _handleMessageReceived(sender, data);
      case MessagingEvent.chatRoomCreated:
        _handleChatRoomCreated(sender, data);
      case MessagingEvent.chatRoomDeleted:
        _handleChatRoomDeleted(sender, data);
      case MessagingEvent.userTyping:
        _handleUserTyping(sender, data);
      case MessagingEvent.userStoppedTyping:
        _handleUserStoppedTyping(sender, data);
      case MessagingEvent.messageRead:
        _handleMessageRead(sender, data);
      case MessagingEvent.notificationSent:
        _handleNotificationSent(sender, data);
    }
  }

  // Private methods to handle specific events
  void _handleUserJoined(Object sender, Map<String, dynamic>? data) {
    print('Mediator: Handling user joined event');

    if (data != null && data['user'] != null && data['chatRoomId'] != null) {
      final user = data['user'] as User;
      final chatRoomId = data['chatRoomId'] as String;

      // Notify chat room manager about new user
      _chatRoomManager?.addUserToRoom(chatRoomId, user);

      // Log the event
      _messageLogger
          ?.logEvent('User ${user.name} joined chat room $chatRoomId');

      // Send notification to other users in the room
      _notificationService?.notifyUserJoined(user, chatRoomId);
    }
  }

  void _handleUserLeft(Object sender, Map<String, dynamic>? data) {
    print('Mediator: Handling user left event');

    if (data != null && data['user'] != null && data['chatRoomId'] != null) {
      final user = data['user'] as User;
      final chatRoomId = data['chatRoomId'] as String;

      // Remove user from chat room
      _chatRoomManager?.removeUserFromRoom(chatRoomId, user);

      // Log the event
      _messageLogger?.logEvent('User ${user.name} left chat room $chatRoomId');

      // Notify other users
      _notificationService?.notifyUserLeft(user, chatRoomId);
    }
  }

  void _handleMessageSent(Object sender, Map<String, dynamic>? data) {
    print('Mediator: Handling message sent event');

    if (data != null && data['message'] != null) {
      final message = data['message'] as Message;

      // Log the message
      _messageLogger?.logMessage(message);

      // Notify other users in the chat room
      _notificationService?.notifyNewMessage(message);

      // Update chat room with new message
      _chatRoomManager?.addMessageToRoom(message.chatRoomId, message);
    }
  }

  void _handleMessageReceived(Object sender, Map<String, dynamic>? data) {
    print('Mediator: Handling message received event');

    if (data != null && data['message'] != null) {
      final message = data['message'] as Message;

      // Log the received message
      _messageLogger?.logEvent('Message received: ${message.content}');

      // Mark message as read if needed
      _chatRoomManager?.markMessageAsRead(message.chatRoomId, message.id);
    }
  }

  void _handleChatRoomCreated(Object sender, Map<String, dynamic>? data) {
    print('Mediator: Handling chat room created event');

    if (data != null && data['chatRoom'] != null) {
      final chatRoom = data['chatRoom'] as ChatRoom;

      // Log the event
      _messageLogger?.logEvent('Chat room created: ${chatRoom.name}');

      // Notify users about new chat room
      _notificationService?.notifyChatRoomCreated(chatRoom);
    }
  }

  void _handleChatRoomDeleted(Object sender, Map<String, dynamic>? data) {
    print('Mediator: Handling chat room deleted event');

    if (data != null && data['chatRoomId'] != null) {
      final chatRoomId = data['chatRoomId'] as String;

      // Log the event
      _messageLogger?.logEvent('Chat room deleted: $chatRoomId');

      // Notify users about chat room deletion
      _notificationService?.notifyChatRoomDeleted(chatRoomId);
    }
  }

  void _handleUserTyping(Object sender, Map<String, dynamic>? data) {
    print('Mediator: Handling user typing event');

    if (data != null && data['user'] != null && data['chatRoomId'] != null) {
      final user = data['user'] as User;
      final chatRoomId = data['chatRoomId'] as String;

      // Notify other users in the room
      _notificationService?.notifyUserTyping(user, chatRoomId);
    }
  }

  void _handleUserStoppedTyping(Object sender, Map<String, dynamic>? data) {
    print('Mediator: Handling user stopped typing event');

    if (data != null && data['user'] != null && data['chatRoomId'] != null) {
      final user = data['user'] as User;
      final chatRoomId = data['chatRoomId'] as String;

      // Notify other users in the room
      _notificationService?.notifyUserStoppedTyping(user, chatRoomId);
    }
  }

  void _handleMessageRead(Object sender, Map<String, dynamic>? data) {
    print('Mediator: Handling message read event');

    if (data != null && data['messageId'] != null && data['userId'] != null) {
      final messageId = data['messageId'] as String;
      final userId = data['userId'] as String;

      // Log the event
      _messageLogger?.logEvent('Message $messageId read by user $userId');

      // Update message status
      _chatRoomManager?.markMessageAsReadByUser(messageId, userId);
    }
  }

  void _handleNotificationSent(Object sender, Map<String, dynamic>? data) {
    print('Mediator: Handling notification sent event');

    if (data != null && data['notification'] != null) {
      // Log the notification
      _messageLogger?.logEvent('Notification sent: ${data['notification']}');
    }
  }

  void _logEvent(
      Object sender, MessagingEvent event, Map<String, dynamic>? data) {
    final eventLog = {
      'timestamp': DateTime.now(),
      'sender': sender.runtimeType.toString(),
      'event': event.toString(),
      'data': data,
    };

    _eventHistory.add(eventLog);

    // Keep only last 100 events
    if (_eventHistory.length > 100) {
      _eventHistory.removeAt(0);
    }
  }

  /// Get event history for debugging
  List<Map<String, dynamic>> get eventHistory =>
      List.unmodifiable(_eventHistory);

  /// Clear event history
  void clearEventHistory() {
    _eventHistory.clear();
  }
}
