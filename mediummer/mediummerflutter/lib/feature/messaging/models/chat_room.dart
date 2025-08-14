import 'package:mediummerflutter/feature/messaging/models/user.dart';

class ChatRoom {
  ChatRoom({
    required this.id,
    required this.name,
    required this.participants,
    required this.createdAt,
  });
  final String id;
  final String name;
  final List<User> participants;
  final DateTime createdAt;

  @override
  String toString() =>
      'ChatRoom(id: $id, name: $name, participants: ${participants.length})';
}
