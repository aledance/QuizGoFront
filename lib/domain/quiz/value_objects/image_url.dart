import 'package:flutter/foundation.dart';

@immutable
class ImageUrl {
  final String value;

  const ImageUrl(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageUrl &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
