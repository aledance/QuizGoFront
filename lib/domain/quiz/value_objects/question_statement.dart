import 'package:flutter/foundation.dart';

@immutable
class QuestionStatement {
  final String value;

  const QuestionStatement(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionStatement &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
