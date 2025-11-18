class ExpirationDate {
  final DateTime value;

  ExpirationDate(this.value);

  bool get isExpired => DateTime.now().isAfter(value);

  String toJson() => value.toIso8601String();

  factory ExpirationDate.fromJson(dynamic json) => ExpirationDate(DateTime.parse(json as String));
}
