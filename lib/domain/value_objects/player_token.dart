class PlayerToken {
  final String value;

  PlayerToken(this.value) {
    if (value.isEmpty) throw ArgumentError('PlayerToken cannot be empty');
  }

  String toJson() => value;

  factory PlayerToken.fromJson(dynamic json) => PlayerToken(json as String);
}
