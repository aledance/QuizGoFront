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

  /// Permite crear un UniqueId a partir de un String existente (ej. desde una API).
  factory UniqueId.fromUniqueString(String uniqueId) {
    return UniqueId._(uniqueId);
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
