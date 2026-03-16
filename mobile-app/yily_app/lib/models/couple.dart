import 'user.dart';

class Couple {
  final int id;
  final String token;
  final List<User> users;

  DateTime? anniversaryDate;

  Couple({
    required this.id,
    required this.token,
    this.anniversaryDate,
    required this.users,
  });

  factory Couple.fromJson(Map<String, dynamic> json) {
    return Couple(
      id: json['id'] as int,
      token: json['token'] as String,
      anniversaryDate: json['anniversaryDate'] != null
          ? DateTime.parse(json['anniversaryDate'] as String)
          : null,
      users: (json['users'] as List<dynamic>)
          .map((userJson) => User.fromJson(userJson as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'token': token,
        'anniversaryDate': anniversaryDate?.toIso8601String(),
        'users': users.map((user) => user.toJson()).toList(),
      };
}