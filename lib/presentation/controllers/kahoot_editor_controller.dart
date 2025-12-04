import 'package:flutter/foundation.dart';
import '../../application/editor/kahoot_editor.dart';
import '../../domain/entities/question.dart' as ent_question;
import '../../domain/entities/kahoot.dart' as ent_kahoot;
import '../../domain/entities/author.dart';
import '../services/kahoot_service.dart';




class KahootEditorController extends ChangeNotifier {
  final KahootService _service;
  final EditorKahoot editor;
  static const String _fallbackAuthorId = 'f1986c62-7dc1-47c5-9a1f-03d34043e8f4';
  static const String _fallbackThemeId = 'f1986c62-7dc1-47c5-9a1f-03d34043e8f4';

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

  void setCategory(String? category) {
    editor.category = category;
    notifyListeners();
  }

  void setStatus(String? status) {
    editor.status = status;
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


  Future<ent_kahoot.Kahoot> createKahoot() async {
    _normalizeBeforeSend();
    final entity = editor.toEntity();
    final created = await _service.create(entity);
    return created;
  }

  Future<ent_kahoot.Kahoot> updateKahoot(String id) async {
    _normalizeBeforeSend();
    final entity = editor.toEntity(kahootId: id);
    final updated = await _service.update(id, entity);
    return updated;
  }

  void _normalizeBeforeSend() {
    // Ensure authorId is present
    if (editor.author.authorId.isEmpty) {
      editor.author = Author(authorId: _fallbackAuthorId, name: editor.author.name);
    }

    // Normalize top-level optional fields: empty string -> null
    if (editor.themeId != null && editor.themeId!.trim().isEmpty) editor.themeId = null;
    if (editor.coverImageId != null && editor.coverImageId!.trim().isEmpty) editor.coverImageId = null;
    if (editor.category != null && editor.category!.trim().isEmpty) editor.category = null;
    if (editor.status != null && editor.status!.trim().isEmpty) editor.status = null;

    // Validate themeId: backend expects a UUID v4 or null
    final themeId = editor.themeId;
    if (themeId != null) {
      final uuidV4 = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89ABab][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$');
      if (!uuidV4.hasMatch(themeId)) {
        // Invalid themeId -> drop it
        editor.themeId = null;
      }
    }
    
    // If themeId is missing, use fallback to satisfy backend requirement
    if (editor.themeId == null) {
      editor.themeId = _fallbackThemeId;
    }

    // Normalize question and answer fields: convert empty strings to null for optional fields
    for (var q in editor.questions) {
      if (q.id != null && q.id!.trim().isEmpty) q.id = null;
      if (q.mediaId != null && q.mediaId!.trim().isEmpty) q.mediaId = null;
      for (var a in q.answers) {
        if (a.id != null && a.id!.trim().isEmpty) a.id = null;
        if (a.mediaId != null && a.mediaId!.trim().isEmpty) a.mediaId = null;
        if (a.text != null && a.text!.trim().isEmpty) a.text = null;
      }
    }
  }

  Future<void> loadKahoot(String id) async {
    final loaded = await _service.getById(id);
    final e = EditorKahoot.fromEntity(loaded);
    editor.id = e.id;
    editor.title = e.title;
    editor.description = e.description;
    editor.coverImageId = e.coverImageId;
    editor.category = e.category;
    editor.status = e.status;
    editor.visibility = e.visibility;
    editor.themeId = e.themeId;
    editor.author = e.author;
    editor.createdAt = e.createdAt;
    editor.questions = e.questions;
    selectedQuestionIndex = 0;
    notifyListeners();
  }



  List<String> validate() => editor.validate();
}