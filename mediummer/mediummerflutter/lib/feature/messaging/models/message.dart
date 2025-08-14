import 'package:mediummerflutter/feature/messaging/models/user.dart';

class Message {
  Message({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    required this.chatRoomId,
  });
  final String id;
  final String content;
  final User sender;
  final DateTime timestamp;
  final String chatRoomId;

  @override
  String toString() =>
      'Message(id: $id, content: $content, sender: ${sender.name})';
}
