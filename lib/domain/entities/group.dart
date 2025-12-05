class Group {
  final String id;
  final String name;
  final String role; // admin | member
  final int memberCount;
  final DateTime createdAt;
  final String? description;
  final String? imageUrl;

  Group({
    required this.id,
    required this.name,
    required this.role,
    required this.memberCount,
    required this.createdAt,
    this.description,
    this.imageUrl,
  });
}
