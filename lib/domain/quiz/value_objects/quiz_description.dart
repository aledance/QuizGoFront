import 'package:flutter/foundation.dart';

@immutable
class QuizDescription {
  final String value;

  const QuizDescription(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizDescription &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
