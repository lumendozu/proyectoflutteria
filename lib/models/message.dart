// lib/models/message.dart
class Message {
  final String content;
  final String role;
  final DateTime timestamp;

  Message({
    required this.content,
    required this.role,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'content': content,
    'role': role,
  };
}
