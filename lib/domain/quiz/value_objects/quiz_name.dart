import 'package:flutter/foundation.dart';

@immutable
class QuizName {
  final String value;

  const QuizName(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizName &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
