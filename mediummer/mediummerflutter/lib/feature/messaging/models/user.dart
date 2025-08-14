class User {
  User({
    required this.id,
    required this.name,
    required this.avatar,
  });
  final String id;
  final String name;
  final String avatar;

  @override
  String toString() => 'User(id: $id, name: $name)';
}
