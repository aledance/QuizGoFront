class Pin {
  final int value;

  Pin(this.value) {
    if (value < 0 || value > 999999) {
      throw ArgumentError.value(value, 'value', 'PIN must be between 0 and 999999');
    }
  }

  String padded() => value.toString().padLeft(6, '0');

  int toJson() => value;

  factory Pin.fromJson(dynamic json) => Pin((json as num).toInt());
}
