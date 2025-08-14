/// Abstract Mediator interface that defines communication contract
/// between messaging system components
abstract class MessagingMediator {
  /// Notify mediator about an event from a colleague
  void notify({
    required Object sender,
    required MessagingEvent event,
    Map<String, dynamic>? data,
  });

  /// Register a colleague with the mediator
  void registerColleague(Object colleague);

  /// Unregister a colleague from the mediator
  void unregisterColleague(Object colleague);
}

/// Events that can be sent through the mediator
enum MessagingEvent {
  userJoined,
  userLeft,
  messageSent,
  messageReceived,
  chatRoomCreated,
  chatRoomDeleted,
  userTyping,
  userStoppedTyping,
  messageRead,
  notificationSent,
}
