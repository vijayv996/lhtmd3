class User {
  final int userId;
  final String username;

  const User({
    required this.userId,
    required this.username,
  });

  Map<String, Object?> toMap() {
    return {
      'user_id': userId,
      'username': username,
    };
  }

  @override
  String toString() {
    return 'User(userId: $userId, username: $username)';
  }
}