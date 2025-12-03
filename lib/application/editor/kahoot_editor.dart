import '../../domain/entities/answer.dart' as ent_answer;
import '../../domain/entities/question.dart' as ent_question;
import '../../domain/entities/kahoot.dart' as ent_kahoot;
import '../../domain/entities/author.dart';






class EditorAnswer {
  String? id;
  String? mediaId;
  String? text;
  bool isCorrect;

  EditorAnswer({this.id, this.mediaId, this.text, this.isCorrect = false});

  ent_answer.Answer toEntity({String? questionId}) => ent_answer.Answer(
        id: id,
        questionId: questionId,
        text: text,
        mediaId: mediaId,
        isCorrect: isCorrect,
      );

  factory EditorAnswer.fromEntity(ent_answer.Answer a) => EditorAnswer(
        id: a.id,
        mediaId: a.mediaId,
        text: a.text,
        isCorrect: a.isCorrect,
      );
}

class EditorQuestion {
  String? id;
  String? mediaId;
  String text;
  ent_question.QuestionType type;
  int timeLimit;
  int points;
  List<EditorAnswer> answers;

  EditorQuestion({
    this.id,
    this.mediaId,
    this.text = '',
    this.type = ent_question.QuestionType.quiz,
    this.timeLimit = 20,
    this.points = 1000,
    List<EditorAnswer>? answers,
  }) : answers = answers ?? [EditorAnswer(), EditorAnswer()];

  ent_question.Question toEntity({String? quizId}) => ent_question.Question(
        id: id,
        quizId: quizId,
        text: text,
        mediaId: mediaId,
        type: type,
        timeLimit: timeLimit,
        points: points,
        answers: answers.map((a) => a.toEntity(questionId: id)).toList(),
      );

  factory EditorQuestion.fromEntity(ent_question.Question q) => EditorQuestion(
        id: q.id,
        mediaId: q.mediaId,
        text: q.text,
        type: q.type,
        timeLimit: q.timeLimit,
        points: q.points,
        answers: q.answers.map((a) => EditorAnswer.fromEntity(a)).toList(),
      );
}

class EditorKahoot {
  String? id;
  String title;
  String description;
  String? coverImageId;
  String? category;
  String? status;
  String visibility;
  String? themeId;
  Author author;
  DateTime createdAt;
  List<EditorQuestion> questions;

  EditorKahoot({
    this.id,
    this.title = '',
    this.description = '',
    this.coverImageId,
    this.category,
    this.status,
    this.visibility = 'private',
    this.themeId,
    Author? author,
    DateTime? createdAt,
    List<EditorQuestion>? questions,
  })  : author = author ?? Author(authorId: '', name: ''),
        createdAt = createdAt ?? DateTime.now(),
        questions = questions ?? [EditorQuestion()];


  int addQuestion() {
    questions.add(EditorQuestion());
    return questions.length - 1;
  }

  void removeQuestion(int index) {
    if (index >= 0 && index < questions.length) {
      questions.removeAt(index);
    }
  }

  int addAnswer(int questionIndex, {String? text, bool isCorrect = false}) {
    final q = questions[questionIndex];
    q.answers.add(EditorAnswer(text: text, isCorrect: isCorrect));
    return q.answers.length - 1;
  }

  void removeAnswer(int questionIndex, int answerIndex) {
    final q = questions[questionIndex];
    if (answerIndex >= 0 && answerIndex < q.answers.length) q.answers.removeAt(answerIndex);
  }



  ent_kahoot.Kahoot toEntity({String? kahootId}) {
    return ent_kahoot.Kahoot(
      id: kahootId ?? id,
      title: title,
      description: description,
      coverImageId: coverImageId,
      category: category,
      status: status,
      visibility: visibility,
      themeId: themeId,
      author: author,
      createdAt: createdAt,
      questions: questions.map((q) => q.toEntity()).toList(),
    );
  }

    factory EditorKahoot.fromEntity(ent_kahoot.Kahoot k) => EditorKahoot(
        id: k.id,
        title: k.title,
        description: k.description,
        coverImageId: k.coverImageId,
      category: k.category,
      status: k.status,
        visibility: k.visibility,
        themeId: k.themeId,
        author: k.author,
        createdAt: k.createdAt,
        questions: k.questions.map((q) => EditorQuestion.fromEntity(q)).toList(),
      );


  List<String> validate() {
    final errors = <String>[];
    if (title.trim().isEmpty) errors.add('El título no puede estar vacío');
    for (var i = 0; i < questions.length; i++) {
      final q = questions[i];
      if (q.text.trim().isEmpty) errors.add('Pregunta ${i + 1}: el enunciado está vacío');
      if (q.answers.length < 2) errors.add('Pregunta ${i + 1}: debe tener al menos 2 respuestas');
      final correct = q.answers.where((a) => a.isCorrect).length;
      if (q.type == ent_question.QuestionType.quiz && correct < 1) errors.add('Pregunta ${i + 1}: debe tener al menos 1 respuesta correcta');
      if (q.timeLimit <= 0) errors.add('Pregunta ${i + 1}: timeLimit debe ser mayor que 0');
    }
    return errors;
  }
}