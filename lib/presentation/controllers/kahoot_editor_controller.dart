import 'package:flutter/foundation.dart';
import '../../application/editor/kahoot_editor.dart';
import '../../domain/entities/question.dart' as ent_question;
import '../../domain/entities/kahoot.dart' as ent_kahoot;
import '../services/kahoot_service.dart';

/// ChangeNotifier controller that presentation/UI can use directly. It wraps
/// the application-layer EditorKahoot model and forwards persistence calls to
/// `KahootService` (which in turn uses the repository).
class KahootEditorController extends ChangeNotifier {
  final KahootService _service;
  final EditorKahoot editor;

  int selectedQuestionIndex = 0;

  KahootEditorController({required KahootService service, EditorKahoot? initial})
      : _service = service,
        editor = initial ?? EditorKahoot();

  // UI-oriented helpers --------------------------------------------------
  List<EditorQuestion> get questions => editor.questions;

  EditorQuestion get selectedQuestion => editor.questions[selectedQuestionIndex];

  void selectQuestion(int index) {
    if (index >= 0 && index < editor.questions.length) {
      selectedQuestionIndex = index;
      notifyListeners();
    }
  }

  void addQuestion() {
    final idx = editor.addQuestion();
    selectQuestion(idx);
  }

  void removeQuestion(int index) {
    editor.removeQuestion(index);
    if (selectedQuestionIndex >= editor.questions.length) selectedQuestionIndex = editor.questions.length - 1;
    notifyListeners();
  }

  void addAnswerToSelected({String? text, bool isCorrect = false}) {
    editor.addAnswer(selectedQuestionIndex, text: text, isCorrect: isCorrect);
    notifyListeners();
  }

  void removeAnswerFromSelected(int answerIndex) {
    editor.removeAnswer(selectedQuestionIndex, answerIndex);
    notifyListeners();
  }

  void toggleAnswerCorrect(int answerIndex) {
    final q = selectedQuestion;
    if (answerIndex >= 0 && answerIndex < q.answers.length) {
      q.answers[answerIndex].isCorrect = !q.answers[answerIndex].isCorrect;
      notifyListeners();
    }
  }

  /// Set a single answer as correct and unset the others (for single-choice quizzes)
  void setSingleCorrect(int answerIndex) {
    final q = selectedQuestion;
    if (answerIndex >= 0 && answerIndex < q.answers.length) {
      for (var i = 0; i < q.answers.length; i++) {
        q.answers[i].isCorrect = i == answerIndex;
      }
      notifyListeners();
    }
  }

  // Mutators for top-level kahoot fields
  void setTitle(String t) {
    editor.title = t;
    notifyListeners();
  }

  void setDescription(String d) {
    editor.description = d;
    notifyListeners();
  }

  void setCoverImageId(String? id) {
    editor.coverImageId = id;
    notifyListeners();
  }

  void setVisibility(String v) {
    editor.visibility = v;
    notifyListeners();
  }

  void setThemeId(String? id) {
    editor.themeId = id;
    notifyListeners();
  }

  void setQuestionText(String text) {
    selectedQuestion.text = text;
    notifyListeners();
  }

  void setQuestionType(ent_question.QuestionType type) {
    selectedQuestion.type = type;
    notifyListeners();
  }

  void setQuestionTimeLimit(int seconds) {
    selectedQuestion.timeLimit = seconds;
    notifyListeners();
  }

  void setQuestionPoints(int points) {
    selectedQuestion.points = points;
    notifyListeners();
  }

  // Persistence ----------------------------------------------------------
  Future<ent_kahoot.Kahoot> createKahoot() async {
    final entity = editor.toEntity();
    final created = await _service.create(entity);
    return created;
  }

  Future<ent_kahoot.Kahoot> updateKahoot(String id) async {
    final entity = editor.toEntity(kahootId: id);
    final updated = await _service.update(id, entity);
    return updated;
  }

  Future<void> loadKahoot(String id) async {
    final loaded = await _service.getById(id);
    final e = EditorKahoot.fromEntity(loaded);
    editor.id = e.id;
    editor.title = e.title;
    editor.description = e.description;
    editor.coverImageId = e.coverImageId;
    editor.visibility = e.visibility;
    editor.themeId = e.themeId;
    editor.author = e.author;
    editor.createdAt = e.createdAt;
    editor.questions = e.questions;
    selectedQuestionIndex = 0;
    notifyListeners();
  }

  /// Validate current editor state and return errors. Useful to show UI
  /// messages before attempting to save.
  List<String> validate() => editor.validate();
}
