import 'dart:convert';
import 'package:flutter_application_1/domain/quiz/entities/quiz.dart' as domain;
import 'package:flutter_application_1/infrastructure/quiz/quiz_dto.dart' as dto;
import 'package:http/http.dart' as http;

abstract class QuizRemoteDataSource {
  Future<domain.Quiz> createQuiz(domain.Quiz quiz);
  Future<domain.Quiz> updateQuiz(String quizId, domain.Quiz quiz);
  Future<domain.Quiz> getQuiz(String quizId);
  Future<List<domain.Quiz>> getUserQuizzes(String userId);
  Future<void> deleteQuiz(String quizId);
}

class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'http://localhost:3000'; // Replace with your API base URL

  QuizRemoteDataSourceImpl({required this.client});

  @override
  Future<domain.Quiz> createQuiz(domain.Quiz quiz) async {
    final quizDto = dto.QuizDto.fromDomain(quiz);
    final response = await client.post(
      Uri.parse('$baseUrl/kahoots'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(quizDto.toJson()),
    );

    if (response.statusCode == 201) {
      final created = dto.QuizDto.fromJson(json.decode(response.body));
      return created.toDomain();
    } else {
      throw Exception('Failed to create quiz');
    }
  }

  @override
  Future<void> deleteQuiz(String quizId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/kahoots/$quizId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete quiz');
    }
  }

  @override
  Future<domain.Quiz> getQuiz(String quizId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/kahoots/$quizId'),
    );

    if (response.statusCode == 200) {
      final dtoQuiz = dto.QuizDto.fromJson(json.decode(response.body));
      return dtoQuiz.toDomain();
    } else {
      throw Exception('Failed to get quiz');
    }
  }

  @override
  Future<List<domain.Quiz>> getUserQuizzes(String userId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/kahoots/user/$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> quizzesJson = json.decode(response.body);
      return quizzesJson.map((json) => dto.QuizDto.fromJson(json).toDomain()).toList();
    } else {
      throw Exception('Failed to get user quizzes');
    }
  }

  @override
  Future<domain.Quiz> updateQuiz(String quizId, domain.Quiz quiz) async {
    final quizDto = dto.QuizDto.fromDomain(quiz);
    final response = await client.put(
      Uri.parse('$baseUrl/kahoots/$quizId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(quizDto.toJson()),
    );

    if (response.statusCode == 200) {
      final updated = dto.QuizDto.fromJson(json.decode(response.body));
      return updated.toDomain();
    } else {
      throw Exception('Failed to update quiz');
    }
  }
}
