import 'package:flutter/foundation.dart';
import '../../application/editor/kahoot_editor.dart';
import '../../domain/entities/question.dart' as ent_question;
import '../../domain/entities/kahoot.dart' as ent_kahoot;
import '../services/kahoot_service.dart';




class KahootEditorController extends ChangeNotifier {
  final KahootService _service;
  final EditorKahoot editor;

  int selectedQuestionIndex = 0;

  KahootEditorController({required KahootService service, EditorKahoot? initial})
      : _service = service,
        editor = initial ?? EditorKahoot();


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


  void setSingleCorrect(int answerIndex) {
    final q = selectedQuestion;
    if (answerIndex >= 0 && answerIndex < q.answers.length) {
      for (var i = 0; i < q.answers.length; i++) {
        q.answers[i].isCorrect = i == answerIndex;
      }
      notifyListeners();
    }
  }


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

  void setStatus(String? s) {
    editor.status = s;
    notifyListeners();
  }

  void setCategory(String? c) {
    editor.category = c;
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
    editor.status = e.status;
    editor.category = e.category;
    editor.themeId = e.themeId;
    editor.author = e.author;
    editor.createdAt = e.createdAt;
    editor.questions = e.questions;
    selectedQuestionIndex = 0;
    notifyListeners();
  }



  List<String> validate() => editor.validate();
}