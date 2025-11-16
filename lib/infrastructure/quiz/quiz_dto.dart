// DTOs implemented without Freezed to avoid depending on code generation.
// These classes are simple containers with toJson/fromJson and mapping to domain.
import 'package:flutter_application_1/domain/quiz/entities/author.dart' as domain;
import 'package:flutter_application_1/domain/quiz/entities/option.dart' as domain;
import 'package:flutter_application_1/domain/quiz/entities/question.dart' as domain;
import 'package:flutter_application_1/domain/quiz/entities/quiz.dart' as domain;
import 'package:flutter_application_1/domain/quiz/value_objects/image_url.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/option_text.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/play_count.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/question_statement.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/quiz_description.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/quiz_name.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/quiz_theme.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/unique_id.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/visibility.dart';

class AuthorDto {
  final String id;
  final String name;

  AuthorDto({required this.id, required this.name});

  factory AuthorDto.fromJson(Map<String, dynamic> json) =>
      AuthorDto(id: json['id'] as String, name: json['name'] as String);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory AuthorDto.fromDomain(domain.Author author) {
    return AuthorDto(id: author.id.value, name: author.name);
  }

  domain.Author toDomain() {
    return domain.Author(id: UniqueId.fromUniqueString(id), name: name);
  }
}

class OptionDto {
  final String id;
  final String? text;
  final String? mediaId;
  final bool? isCorrect;

  OptionDto({required this.id, this.text, this.mediaId, this.isCorrect});

  factory OptionDto.fromJson(Map<String, dynamic> json) => OptionDto(
        id: json['id'] as String,
        text: json['answerText'] as String?,
        mediaId: json['mediaId'] as String?,
        isCorrect: json['isCorrect'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'answerText': text,
        'mediaId': mediaId,
        'isCorrect': isCorrect,
      };

  factory OptionDto.fromDomain(domain.Option option, {bool isCorrect = false}) {
    return OptionDto(id: option.id.value, text: option.text.value, mediaId: null, isCorrect: isCorrect);
  }

  domain.Option toDomain() {
    return domain.Option(id: UniqueId.fromUniqueString(id), text: OptionText(text ?? ''));
  }
}

class QuestionDto {
  final String id;
  final String questionText;
  final String? mediaId;
  final String? questionType;
  final int? timeLimit;
  final int? points;
  final List<OptionDto> answers;

  QuestionDto({
    required this.id,
    required this.questionText,
    this.mediaId,
    this.questionType,
    this.timeLimit,
    this.points,
    required this.answers,
  });

  factory QuestionDto.fromJson(Map<String, dynamic> json) => QuestionDto(
        id: json['id'] as String,
        questionText: json['questionText'] as String,
        mediaId: json['mediaId'] as String?,
        questionType: json['questionType'] as String?,
        timeLimit: json['timeLimit'] as int?,
        points: json['points'] as int?,
        answers: (json['answers'] as List<dynamic>).map((e) => OptionDto.fromJson(e as Map<String, dynamic>)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'questionText': questionText,
        'mediaId': mediaId,
        'questionType': questionType,
        'timeLimit': timeLimit,
        'points': points,
        'answers': answers.map((a) => a.toJson()).toList(),
      };

  factory QuestionDto.fromDomain(domain.Question question) {
    return QuestionDto(
      id: question.id.value,
      questionText: question.statement.value,
      mediaId: null,
      questionType: 'quiz',
      timeLimit: 30,
      points: 100,
      answers: question.options.map((o) => OptionDto.fromDomain(o, isCorrect: o.id.value == question.correctOption.id.value)).toList(),
    );
  }

  domain.Question toDomain() {
    final domainOptions = answers.map((dto) => dto.toDomain()).toList();
    final correct = domainOptions.firstWhere(
      (o) => answers.firstWhere((a) => a.id == o.id.value).isCorrect == true,
      orElse: () => domainOptions.isNotEmpty ? domainOptions.first : throw StateError('No options available'),
    );

    return domain.Question(id: UniqueId.fromUniqueString(id), statement: QuestionStatement(questionText), options: domainOptions, correctOption: correct);
  }
}

class QuizDto {
  final String id;
  final String title;
  final String? description;
  final String? coverImageId;
  final String visibility;
  final String? themeId;
  final AuthorDto author;
  final DateTime createdAt;
  final int? playCount;
  final List<QuestionDto> questions;

  QuizDto({
    required this.id,
    required this.title,
    this.description,
    this.coverImageId,
    required this.visibility,
    this.themeId,
    required this.author,
    required this.createdAt,
    this.playCount,
    required this.questions,
  });

  factory QuizDto.fromJson(Map<String, dynamic> json) => QuizDto(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        coverImageId: json['coverImageId'] as String?,
        visibility: json['visibility'] as String,
        themeId: json['themeId'] as String?,
        author: AuthorDto.fromJson(json['author'] as Map<String, dynamic>),
        createdAt: DateTime.parse(json['createdAt'] as String),
        playCount: json['playCount'] as int?,
        questions: (json['questions'] as List<dynamic>).map((e) => QuestionDto.fromJson(e as Map<String, dynamic>)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'coverImageId': coverImageId,
        'visibility': visibility,
        'themeId': themeId,
        'author': author.toJson(),
        'createdAt': createdAt.toIso8601String(),
        'playCount': playCount,
        'questions': questions.map((q) => q.toJson()).toList(),
      };

  factory QuizDto.fromDomain(domain.Quiz quiz) {
    final themeId = (quiz.themes != null && quiz.themes!.isNotEmpty) ? quiz.themes!.first.value : null;
    return QuizDto(
      id: quiz.id.value,
      title: quiz.name.value,
      description: quiz.description.value,
      coverImageId: null,
      visibility: quiz.visibility.name,
      themeId: themeId,
      author: AuthorDto.fromDomain(quiz.author),
      createdAt: quiz.createdAt,
      playCount: quiz.playCount?.value,
      questions: quiz.questions.map((q) => QuestionDto.fromDomain(q)).toList(),
    );
  }

  domain.Quiz toDomain() {
    return domain.Quiz(
      id: UniqueId.fromUniqueString(id),
      name: QuizName(title),
      description: QuizDescription(description ?? ''),
      kahootImage: coverImageId == null ? null : ImageUrl(coverImageId!),
      visibility: Visibility.values.firstWhere((e) => e.name == visibility),
      themes: themeId == null ? null : [QuizTheme(themeId!)],
      author: author.toDomain(),
      createdAt: createdAt,
      playCount: playCount == null ? null : PlayCount(playCount!),
      questions: questions.map((dto) => dto.toDomain()).toList(),
    );
  }
}
