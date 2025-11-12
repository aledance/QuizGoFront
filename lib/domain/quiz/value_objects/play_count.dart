import 'package:flutter/foundation.dart';

@immutable
class PlayCount {
  final int value;

  const PlayCount(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayCount &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
