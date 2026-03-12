class Reason {
  final int id;
  final int fromUserId;
  final int toUserId;
  final String content;
  final DateTime createdAt;

  Reason({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.content,
    required this.createdAt,
  });

  factory Reason.fromJson(Map<String, dynamic> json) {
    return Reason(
      id: json['id'] as int,
      fromUserId: json['from_user_id'] as int,
      toUserId: json['to_user_id'] as int,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'from_user_id': fromUserId,
        'to_user_id': toUserId,
        'content': content,
        'created_at': createdAt.toIso8601String(),
      };
}