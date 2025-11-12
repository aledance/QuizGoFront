// lib/infrastructure/quiz/quiz_repository_impl.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter_application_1/domain/quiz/entities/quiz.dart';
import 'package:flutter_application_1/domain/quiz/repositories/quiz_failure.dart';
import 'package:flutter_application_1/domain/quiz/repositories/quiz_repository.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/unique_id.dart';
import 'package:flutter_application_1/infrastructure/quiz/quiz_dto.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

class QuizRepositoryImpl implements QuizRepository {
  final http.Client _client;
  final String baseUrl;

  QuizRepositoryImpl(this._client, {this.baseUrl = 'https://api.example.com'});

  @override
  Future<Either<QuizFailure, Quiz>> create(Quiz quiz) async {
    final quizDto = QuizDto.fromDomain(quiz);
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/kahoots'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(quizDto.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final created = QuizDto.fromJson(json.decode(response.body));
        return Right(created.toDomain());
      }

      return Left(_mapStatusToFailure(response.statusCode));
    } on SocketException {
      return Left(QuizFailure.serverError());
    } catch (e) {
      return Left(QuizFailure.serverError());
    }
  }

  @override
  Future<Either<QuizFailure, Quiz>> getById(UniqueId id) async {
    final quizId = id.value;
    try {
      final response = await _client.get(Uri.parse('$baseUrl/kahoots/$quizId'));

      if (response.statusCode == 200) {
        final dto = QuizDto.fromJson(json.decode(response.body));
        return Right(dto.toDomain());
      } else if (response.statusCode == 404) {
        return Left(QuizFailure.notFound());
      }

      return Left(_mapStatusToFailure(response.statusCode));
    } on SocketException {
      return Left(QuizFailure.serverError());
    } catch (e) {
      return Left(QuizFailure.serverError());
    }
  }

  @override
  Future<Either<QuizFailure, Quiz>> update(Quiz quiz) async {
    final quizId = quiz.id.value;
    final quizDto = QuizDto.fromDomain(quiz);

    try {
      final response = await _client.patch(
        Uri.parse('$baseUrl/kahoots/$quizId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(quizDto.toJson()),
      );

      if (response.statusCode == 200) {
        final updated = QuizDto.fromJson(json.decode(response.body));
        return Right(updated.toDomain());
      } else if (response.statusCode == 404) {
        return Left(QuizFailure.notFound());
      }

      return Left(_mapStatusToFailure(response.statusCode));
    } on SocketException {
      return Left(QuizFailure.serverError());
    } catch (e) {
      return Left(QuizFailure.serverError());
    }
  }

  @override
  Future<Either<QuizFailure, List<Quiz>>> findPublishedQuizzes() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/kahoots?visibility=public'));

      if (response.statusCode == 200) {
        final List<dynamic> list = json.decode(response.body) as List<dynamic>;
        final quizzes = list.map((e) => QuizDto.fromJson(e as Map<String, dynamic>).toDomain()).toList();
        return Right(quizzes);
      }

      return Left(_mapStatusToFailure(response.statusCode));
    } on SocketException {
      return Left(QuizFailure.serverError());
    } catch (e) {
      return Left(QuizFailure.serverError());
    }
  }

  QuizFailure _mapStatusToFailure(int status) {
    if (status == 404) return QuizFailure.notFound();
    // Extend mapping as needed (400 -> validation, 401 -> unauthorized, etc.)
    return QuizFailure.serverError();
  }
}
