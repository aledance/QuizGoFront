import 'dart:math';
import '../components/categories_grid.dart';
import 'categories_data.dart';
import 'partner_collections.dart';
import 'sample_extra_content.dart';
import 'sample_quizzes.dart';

/// A simulation of an API that returns data from the local sample files
/// with a simulated network delay.
class ApiSimulation {
  final Random _random = Random();

  /// Simulates a network delay between 500ms and 1500ms
  Future<void> _simulateDelay() async {
    final delay = 500 + _random.nextInt(1000);
    await Future.delayed(Duration(milliseconds: delay));
  }

  Future<List<CategoryItem>> getCategories() async {
    await _simulateDelay();
    return kDefaultCategories;
  }

  Future<List<PartnerCollection>> getPartnerCollections() async {
    await _simulateDelay();
    return partnerCollections;
  }

  Future<List<Course>> getCourses() async {
    await _simulateDelay();
    return sampleCourses;
  }

  Future<List<Quiz>> getQuizzes() async {
    await _simulateDelay();
    return sampleQuizzes;
  }

  Future<List<Map<String, dynamic>>> getUserGroups() async {
    await _simulateDelay();
    // Simulating fetching user groups
    return [
      {
        'name': 'Matemáticas Avanzadas',
        'members': 5,
        'description': 'Grupo de estudio para cálculo y álgebra',
        'membersList': ['Ana', 'Carlos', 'Beatriz', 'David', 'Elena'],
        'messages': [
          {'from': 'Ana', 'text': '¿Alguien resolvió el ejercicio 3?', 'date': DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String()},
          {'from': 'Carlos', 'text': 'Sí, te paso la foto.', 'date': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String()},
        ]
      },
      {
        'name': 'Historia del Arte',
        'members': 3,
        'description': 'Repaso para el examen final',
        'membersList': ['Fernando', 'Gabriela', 'Hugo'],
        'messages': [
          {'from': 'Gabriela', 'text': 'Nos vemos a las 5.', 'date': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String()},
        ]
      },
    ];
  }
}
