import 'package:fpdart/fpdart.dart';
import 'package:flutter_application_1/domain/quiz/entities/quiz.dart';
import 'package:flutter_application_1/domain/quiz/repositories/quiz_failure.dart';
import 'package:flutter_application_1/domain/quiz/repositories/quizRepository';
import 'package:flutter_application_1/domain/quiz/value_objects/unique_id.dart';

/// El QuizService actúa como un intermediario entre la capa de presentación (UI)
/// y la capa de dominio. Orquesta las operaciones pero no contiene lógica de negocio compleja.
class QuizService {
  final QuizRepository _quizRepository;

  QuizService(this._quizRepository);

  /// Busca un quiz por su ID.
  ///
  /// Recibe un [id] en formato String desde la UI, lo convierte en un
  /// ValueObject [UniqueId] y llama al repositorio.
  /// Devuelve el resultado (éxito o fallo) para que la UI lo maneje.
  Future<Either<QuizFailure, Quiz>> getQuizById(String id) async {
    // La capa de aplicación es el lugar ideal para convertir tipos primitivos
    // de la UI en Value Objects del dominio.
    final quizId = UniqueId.fromUniqueString(id);
    return _quizRepository.getById(quizId);
  }

  /// Obtiene la lista de quices publicados.
  Future<Either<QuizFailure, List<Quiz>>> findPublishedQuizzes() async {
    // En este caso, es una simple delegación al repositorio.
    return _quizRepository.findPublishedQuizzes();
  }

  /// Guarda un quiz (lo crea o lo actualiza).
  ///
  /// Aquí se podrían añadir lógicas de aplicación como logging, analytics, etc.
  Future<Either<QuizFailure, Unit>> saveQuiz(Quiz quiz) async {
    // Podríamos añadir validaciones de la capa de aplicación aquí si fuera necesario.
    return _quizRepository.save(quiz);
  }
}
