import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

@immutable
class UniqueId {
  final String value;

  factory UniqueId() {
    return UniqueId._(
      const Uuid().v4(),
    );
  }

  const UniqueId._(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UniqueId &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
