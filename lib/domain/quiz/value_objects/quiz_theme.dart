import 'package:flutter/foundation.dart';

@immutable
class QuizTheme {
  final String value;

  const QuizTheme(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizTheme &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
