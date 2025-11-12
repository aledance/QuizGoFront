import 'package:flutter_application_1/domain/quiz/value_objects/unique_id.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/option_text.dart';

class Option {
  final UniqueId id;
  final OptionText text;

  Option({
    required this.id,
    required this.text,
  });
}