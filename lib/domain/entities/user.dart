import 'role.dart';

class User {
  final String id;
  String name;
  String email;
  bool active;
  Role role;
  DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.active = true,
    Role? role,
    DateTime? createdAt,
  })  : role = role ?? Role.player,
        createdAt = createdAt ?? DateTime.now();

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        active: json['active'] as bool? ?? true,
        role: json['role'] != null ? RoleExt.fromString(json['role'] as String) : Role.player,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'active': active,
        'role': role.value,
        'createdAt': createdAt.toIso8601String(),
      };
}
