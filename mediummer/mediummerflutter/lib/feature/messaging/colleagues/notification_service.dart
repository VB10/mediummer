import 'package:mediummerflutter/feature/messaging/mediator/messaging_mediator.dart';
import 'package:mediummerflutter/feature/messaging/models/chat_room.dart';
import 'package:mediummerflutter/feature/messaging/models/message.dart';
import 'package:mediummerflutter/feature/messaging/models/user.dart';

/// NotificationService is a colleague that handles all notifications
/// It communicates with other components through the mediator
class NotificationService {
  NotificationService(this._mediator) {
    // Register with the mediator
    _mediator.registerColleague(this);
  }
  final MessagingMediator _mediator;
  final List<String> _notificationHistory = [];

  /// Notify when a user joins a chat room
  void notifyUserJoined(User user, String chatRoomId) {
    final notification = 'User ${user.name} joined the chat room';
    _addNotification(notification);

    // In a real app, this would send push notifications, in-app notifications, etc.
    print('NotificationService: $notification');

    // Notify mediator about notification sent
    _mediator.notify(
      sender: this,
      event: MessagingEvent.notificationSent,
      data: {'notification': notification},
    );
  }

  /// Notify when a user leaves a chat room
  void notifyUserLeft(User user, String chatRoomId) {
    final notification = 'User ${user.name} left the chat room';
    _addNotification(notification);

    print('NotificationService: $notification');

    _mediator.notify(
      sender: this,
      event: MessagingEvent.notificationSent,
      data: {'notification': notification},
    );
  }

  /// Notify about a new message
  void notifyNewMessage(Message message) {
    final notification =
        'New message from ${message.sender.name}: ${message.content}';
    _addNotification(notification);

    print('NotificationService: $notification');

    _mediator.notify(
      sender: this,
      event: MessagingEvent.notificationSent,
      data: {'notification': notification},
    );
  }

  /// Notify when a chat room is created
  void notifyChatRoomCreated(ChatRoom chatRoom) {
    final notification = 'New chat room created: ${chatRoom.name}';
    _addNotification(notification);

    print('NotificationService: $notification');

    _mediator.notify(
      sender: this,
      event: MessagingEvent.notificationSent,
      data: {'notification': notification},
    );
  }

  /// Notify when a chat room is deleted
  void notifyChatRoomDeleted(String chatRoomId) {
    final notification = 'Chat room deleted: $chatRoomId';
    _addNotification(notification);

    print('NotificationService: $notification');

    _mediator.notify(
      sender: this,
      event: MessagingEvent.notificationSent,
      data: {'notification': notification},
    );
  }

  /// Notify when a user is typing
  void notifyUserTyping(User user, String chatRoomId) {
    final notification = '${user.name} is typing...';
    _addNotification(notification);

    print('NotificationService: $notification');

    _mediator.notify(
      sender: this,
      event: MessagingEvent.notificationSent,
      data: {'notification': notification},
    );
  }

  /// Notify when a user stops typing
  void notifyUserStoppedTyping(User user, String chatRoomId) {
    final notification = '${user.name} stopped typing';
    _addNotification(notification);

    print('NotificationService: $notification');

    _mediator.notify(
      sender: this,
      event: MessagingEvent.notificationSent,
      data: {'notification': notification},
    );
  }

  /// Send a custom notification
  void sendCustomNotification(String message) {
    _addNotification(message);

    print('NotificationService: $message');

    _mediator.notify(
      sender: this,
      event: MessagingEvent.notificationSent,
      data: {'notification': message},
    );
  }

  /// Add notification to history
  void _addNotification(String notification) {
    _notificationHistory.add('${DateTime.now()}: $notification');

    // Keep only last 100 notifications
    if (_notificationHistory.length > 100) {
      _notificationHistory.removeAt(0);
    }
  }

  /// Get notification history
  List<String> get notificationHistory =>
      List.unmodifiable(_notificationHistory);

  /// Clear notification history
  void clearNotificationHistory() {
    _notificationHistory.clear();
  }

  /// Dispose the service
  void dispose() {
    _mediator.unregisterColleague(this);
  }
}
