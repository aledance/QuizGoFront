class ChallengeId {
  final String value;

  ChallengeId(this.value) {
    final uuidRegEx = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\$');
    if (!uuidRegEx.hasMatch(value)) {
      throw ArgumentError.value(value, 'value', 'Invalid UUID for ChallengeId');
    }
  }

  @override
  String toString() => value;

  String toJson() => value;

  factory ChallengeId.fromJson(dynamic json) => ChallengeId(json as String);
}
