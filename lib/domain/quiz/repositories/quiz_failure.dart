import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_failure.freezed.dart';

@freezed
abstract class QuizFailure with _$QuizFailure {
  const factory QuizFailure.notFound() = NotFound;
  const factory QuizFailure.serverError() = ServerError;
}
