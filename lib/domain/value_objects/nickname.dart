class Nickname {
  final String value;

  Nickname(String v) : value = v.trim() {
    if (value.isEmpty) throw ArgumentError('Nickname cannot be empty');
    if (value.length > 30) throw ArgumentError('Nickname too long (max 30)');
  }

  String toJson() => value;

  factory Nickname.fromJson(dynamic json) => Nickname(json as String);
}
