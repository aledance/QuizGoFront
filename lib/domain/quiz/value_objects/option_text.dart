import 'package:flutter/foundation.dart';

@immutable
class OptionText {
  final String value;

  const OptionText(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OptionText &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
