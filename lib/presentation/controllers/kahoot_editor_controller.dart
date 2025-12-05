import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../application/editor/kahoot_editor.dart';
import '../../domain/entities/question.dart' as ent_question;
import '../../domain/entities/kahoot.dart' as ent_kahoot;
import '../../domain/entities/author.dart';
import '../services/kahoot_service.dart';

/// Este controlador gestiona toda la lógica de la pantalla de creación/edición de un Kahoot.
/// Extiende de [ChangeNotifier] para poder notificar a la UI (vistas) cuando los datos cambian
/// y así reconstruir los widgets necesarios.
class KahootEditorController extends ChangeNotifier {
  // Servicio para comunicarse con el Backend (API).
  final KahootService _service;
  
  // Modelo mutable que representa el Kahoot que se está editando actualmente.
  // A diferencia de la entidad de dominio, este objeto está diseñado para ser modificado fácilmente.
  final EditorKahoot editor;

  // IDs de respaldo (fallback) por si faltan datos obligatorios al enviar al servidor.
  static const String _fallbackAuthorId = 'f1986c62-7dc1-47c5-9a1f-03d34043e8f4';
  static const String _fallbackThemeId = 'f1986c62-7dc1-47c5-9a1f-03d34043e8f4';

  // Variable para almacenar temporalmente una imagen seleccionada de la galería.
  XFile? _pickedImage;
  XFile? get pickedImage => _pickedImage;

  // Índice que rastrea qué pregunta está viendo/editando el usuario actualmente.
  int selectedQuestionIndex = 0;

  // Constructor: Inyecta el servicio y opcionalmente un Kahoot existente para editar.
  // Si no se pasa 'initial', crea un EditorKahoot nuevo (vacío).
  KahootEditorController({required KahootService service, EditorKahoot? initial})
      : _service = service,
        editor = initial ?? EditorKahoot();

  // --- Getters para la UI ---

  // Devuelve la lista de preguntas actuales.
  List<EditorQuestion> get questions => editor.questions;

  // Devuelve el objeto de la pregunta que está actualmente seleccionada.
  EditorQuestion get selectedQuestion => editor.questions[selectedQuestionIndex];

  // --- Gestión de Navegación de Preguntas ---

  // Cambia la pregunta activa y notifica a la UI para que actualice la vista.
  void selectQuestion(int index) {
    if (index >= 0 && index < editor.questions.length) {
      selectedQuestionIndex = index;
      notifyListeners();
    }
  }

  // Añade una nueva pregunta al final y la selecciona automáticamente.
  void addQuestion() {
    final idx = editor.addQuestion();
    selectQuestion(idx);
  }

  // Elimina una pregunta y ajusta el índice seleccionado para evitar errores de "fuera de rango".
  void removeQuestion(int index) {
    editor.removeQuestion(index);
    if (selectedQuestionIndex >= editor.questions.length) selectedQuestionIndex = editor.questions.length - 1;
    notifyListeners();
  }

  // --- Gestión de Respuestas ---

  // Añade una opción de respuesta a la pregunta actual.
  void addAnswerToSelected({String? text, bool isCorrect = false}) {
    editor.addAnswer(selectedQuestionIndex, text: text, isCorrect: isCorrect);
    notifyListeners();
  }

  // Elimina una opción de respuesta específica de la pregunta actual.
  void removeAnswerFromSelected(int answerIndex) {
    editor.removeAnswer(selectedQuestionIndex, answerIndex);
    notifyListeners();
  }

  // Alterna (true/false) si una respuesta es correcta. Útil para preguntas de selección múltiple.
  void toggleAnswerCorrect(int answerIndex) {
    final q = selectedQuestion;
    if (answerIndex >= 0 && answerIndex < q.answers.length) {
      q.answers[answerIndex].isCorrect = !q.answers[answerIndex].isCorrect;
      notifyListeners();
    }
  }

  // Marca UNA sola respuesta como correcta y desmarca las demás. Útil para preguntas de selección simple.
  void setSingleCorrect(int answerIndex) {
    final q = selectedQuestion;
    if (answerIndex >= 0 && answerIndex < q.answers.length) {
      for (var i = 0; i < q.answers.length; i++) {
        q.answers[i].isCorrect = i == answerIndex;
      }
      notifyListeners();
    }
  }

  // --- Setters de Metadatos del Kahoot (Título, Descripción, etc.) ---
  // Cada método actualiza el modelo y llama a notifyListeners() para refrescar la UI.

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

  // Lógica asíncrona para seleccionar una imagen de la galería del dispositivo.
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _pickedImage = image;
        notifyListeners();
        // TODO: Aquí falta implementar la subida real al servidor cuando el endpoint esté listo.
        // final uploadedId = await _service.uploadImage(File(image.path));
        // setCoverImageId(uploadedId);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error picking image: $e');
      }
    }
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

  // --- Setters de Propiedades de la Pregunta Seleccionada ---

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

  // --- Interacción con el Backend (API) ---

  // Crea un nuevo Kahoot. Primero normaliza los datos y luego los convierte a la entidad final.
  Future<ent_kahoot.Kahoot> createKahoot() async {
    _normalizeBeforeSend();
    final entity = editor.toEntity();
    final created = await _service.create(entity);
    return created;
  }

  // Actualiza un Kahoot existente.
  Future<ent_kahoot.Kahoot> updateKahoot(String id) async {
    _normalizeBeforeSend();
    final entity = editor.toEntity(kahootId: id);
    final updated = await _service.update(id, entity);
    return updated;
  }

  // Elimina un Kahoot.
  Future<void> deleteKahoot(String id) async {
    await _service.delete(id);
  }

  // --- Lógica de Limpieza y Validación Interna ---

  /// Prepara los datos antes de enviarlos al servidor.
  /// Esto es crucial porque el backend puede ser estricto con formatos (como UUIDs)
  /// o no aceptar cadenas vacías ("") donde espera nulos (null).
  void _normalizeBeforeSend() {
    // Asegura que siempre haya un autor.
    if (editor.author.authorId.isEmpty) {
      editor.author = Author(authorId: _fallbackAuthorId, name: editor.author.name);
    }

    // Convierte cadenas vacías en null para campos opcionales.
    if (editor.themeId != null && editor.themeId!.trim().isEmpty) editor.themeId = null;
    if (editor.coverImageId != null && editor.coverImageId!.trim().isEmpty) editor.coverImageId = null;
    if (editor.category != null && editor.category!.trim().isEmpty) editor.category = null;
    if (editor.status != null && editor.status!.trim().isEmpty) editor.status = null;

    // Valida que el themeId sea un UUID v4 válido. Si no lo es, lo descarta.
    final themeId = editor.themeId;
    if (themeId != null) {
      final uuidV4 = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89ABab][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$');
      if (!uuidV4.hasMatch(themeId)) {
        editor.themeId = null;
      }
    }
    
    // Si no hay tema, usa el de respaldo.
    if (editor.themeId == null) {
      editor.themeId = _fallbackThemeId;
    }

    // Limpia también los campos dentro de las preguntas y respuestas (IDs vacíos a null).
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

  // Carga un Kahoot existente desde el servidor y rellena el editor con sus datos.
  Future<void> loadKahoot(String id) async {
    final loaded = await _service.getById(id);
    // Convierte la entidad inmutable (Entity) al modelo mutable (Editor).
    final e = EditorKahoot.fromEntity(loaded);
    
    // Copia propiedad por propiedad al editor actual.
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
    
    // Resetea la selección a la primera pregunta.
    selectedQuestionIndex = 0;
    notifyListeners();
  }

  // Ejecuta las validaciones definidas en el modelo EditorKahoot (ej: título obligatorio).
  // Devuelve una lista de errores (Strings) si los hay.
  List<String> validate() => editor.validate();
}