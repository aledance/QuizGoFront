
import 'dart:convert';
import 'package:test/test.dart';
import 'package:quiz_go_front/infrastructure/dtos/kahoot_dto.dart';
import 'package:quiz_go_front/infrastructure/dtos/question_dto.dart';
import 'package:quiz_go_front/infrastructure/dtos/answer_dto.dart';

void main() {
  test('KahootDto.toJsonRequest matches Postman structure', () {
    final kahoot = KahootDto(
      id: '502fe9d9-80b4-4809-b743-0b01aa7bda9c',
      title: 'Mi Nuevo Quiz con Imágenes (Actualizado)',
      description: 'Un quiz de prueba para verificar la asociación de imágenes.',
      coverImageId: null,
      visibility: 'private',
      status: 'draft',
      category: 'Tecnología',
      themeId: 'f1986c62-7dc1-47c5-9a1f-03d34043e8f4',
      author: {'authorId': 'f1986c62-7dc1-47c5-9a1f-03d34043e8f4', 'name': 'Test User'},
      createdAt: DateTime.now().toIso8601String(),
      questions: [
        QuestionDto(
          text: '¿Cuál de estos es un framework de JavaScript?',
          mediaId: 'f1986c62-7dc1-47c5-9a1f-03d34043e8f4',
          type: 'quiz',
          timeLimit: 30,
          points: 1000,
          answers: [
            AnswerDto(text: 'React', mediaId: null, isCorrect: true),
            AnswerDto(text: 'Laravel', mediaId: null, isCorrect: false),
          ],
        ),
      ],
    );

    final json = kahoot.toJsonRequest(authorId: 'f1986c62-7dc1-47c5-9a1f-03d34043e8f4');
    
    // Check that 'author' object is NOT present
    expect(json.containsKey('author'), isFalse);
    
    // Check that 'authorId' IS present
    expect(json['authorId'], equals('f1986c62-7dc1-47c5-9a1f-03d34043e8f4'));
    
    // Check other fields
    expect(json['title'], equals('Mi Nuevo Quiz con Imágenes (Actualizado)'));
    expect(json['themeId'], equals('f1986c62-7dc1-47c5-9a1f-03d34043e8f4'));
    
    print(jsonEncode(json));
  });
}
