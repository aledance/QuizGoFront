// lib/infrastructure/injection.dart

import 'package:http/http.dart' as http;
import 'package:flutter_application_1/domain/quiz/repositories/quiz_repository.dart';
import 'package:flutter_application_1/infrastructure/quiz/quiz_repository_impl.dart';

/// Small helper to create repository instances.
QuizRepository createQuizRepository({http.Client? client, String? baseUrl}) {
  final c = client ?? http.Client();
  return QuizRepositoryImpl(c, baseUrl: baseUrl ?? 'https://api.example.com');
}
