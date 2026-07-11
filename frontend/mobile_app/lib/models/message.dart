class Message {
  final int id;
  final String sender;
  final String content;
  final String type;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.sender,
    required this.content,
    required this.type,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? 0,
      sender: json['sender'] ?? '',
      content: json['content'] ?? '',
      type: json['type'] ?? 'text',
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
