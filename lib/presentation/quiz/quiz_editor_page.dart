import 'dart:io';

import 'package:flutter/material.dart' hide Visibility;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/application/quiz/use_cases/create_quiz.dart';
import 'package:flutter_application_1/infrastructure/injection.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/visibility.dart';
import 'package:flutter_application_1/domain/quiz/entities/question.dart' as d;
import 'package:flutter_application_1/domain/quiz/entities/option.dart' as dopt;
import 'package:flutter_application_1/domain/quiz/value_objects/unique_id.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/question_statement.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/option_text.dart';
import 'package:flutter_application_1/domain/quiz/entities/author.dart';

class QuizEditorPage extends StatefulWidget {
  const QuizEditorPage({Key? key}) : super(key: key);

  @override
  State<QuizEditorPage> createState() => _QuizEditorPageState();
}

class _QuizEditorPageState extends State<QuizEditorPage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  final List<_QuestionDraft> _questions = [];
  String? _quizImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _addQuestion() {
    setState(() => _questions.add(_QuestionDraft()));
  }

  Future<void> _pickQuizImage() async {
    final f = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1200);
    if (f != null) setState(() => _quizImagePath = f.path);
  }

  void _removeQuestion(int index) {
    setState(() => _questions.removeAt(index));
  }

  Future<void> _saveQuiz() async {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El título es requerido')));
      return;
    }

    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Añade al menos una pregunta')));
      return;
    }

    // build domain questions
    final domainQuestions = _questions.map((q) {
      final opts = List.generate(q.options.length, (i) => dopt.Option(id: UniqueId(), text: OptionText(q.options[i])));
      final correct = opts[q.correctIndex.clamp(0, opts.length - 1)];
      return d.Question(id: UniqueId(), statement: QuestionStatement(q.statement), options: opts, correctOption: correct);
    }).toList();

    final repo = createQuizRepository();
    final create = CreateQuiz(repo);
    final author = Author(id: UniqueId(), name: 'Autor demo');

    final res = await create.call(name: _titleCtrl.text.trim(), description: _descCtrl.text.trim(), visibility: Visibility.public, author: author, questions: domainQuestions);

    res.match(
      (l) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error creando quiz'))),
      (r) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quiz creado'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear / Editar Quiz'),
        actions: [
          TextButton(
            onPressed: _saveQuiz,
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Row(
        children: [
          // Left: questions list
          Container(
            width: 220,
            color: Colors.grey.shade100,
            child: Column(
              children: [
                const SizedBox(height: 12),
                ElevatedButton.icon(onPressed: _addQuestion, icon: const Icon(Icons.add), label: const Text('Añadir pregunta')),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: _questions.length,
                    itemBuilder: (context, idx) {
                      return ListTile(
                        title: Text('Pregunta ${idx + 1}'),
                        trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => _removeQuestion(idx)),
                        selected: _selected == idx,
                        onTap: () => setState(() => _selected = idx),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          // Center: editor
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header with quiz image and title
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _pickQuizImage,
                          child: Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: _quizImagePath == null
                                ? const Icon(Icons.add_a_photo, color: Colors.grey, size: 36)
                                : ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(File(_quizImagePath!), fit: BoxFit.cover)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Título del Quiz')),
                              const SizedBox(height: 8),
                              TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Descripción (opcional)'), maxLines: 2),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Editar preguntas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    ..._questions.asMap().entries.map((e) {
                      final idx = e.key;
                      final q = e.value;
                      return _QuestionEditor(
                        index: idx,
                        draft: q,
                        onChanged: (d) => setState(() => _questions[idx] = d),
                      );
                    }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _selected = -1;
}

class _QuestionDraft {
  String statement = '';
  List<String> options = ['', '', '', ''];
  int correctIndex = 0;
  String? imagePath;
}


class _QuestionEditor extends StatefulWidget {
  final int index;
  final _QuestionDraft draft;
  final ValueChanged<_QuestionDraft> onChanged;

  const _QuestionEditor({Key? key, required this.index, required this.draft, required this.onChanged}) : super(key: key);

  @override
  State<_QuestionEditor> createState() => _QuestionEditorState();
}

class _QuestionEditorState extends State<_QuestionEditor> {
  late _QuestionDraft draft;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    draft = widget.draft;
  }

  Future<void> _pickImage() async {
    final f = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1200);
    if (f != null) setState(() { draft.imagePath = f.path; widget.onChanged(draft); });
  }

  _updateOptions(int i, String v) {
    setState(() {
      draft.options[i] = v;
      widget.onChanged(draft);
    });
  }

  _updateStatement(String v) {
    setState(() {
      draft.statement = v;
      widget.onChanged(draft);
    });
  }

  _setCorrectIndex(int i) {
    setState(() {
      draft.correctIndex = i;
      widget.onChanged(draft);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text('Pregunta ${widget.index + 1}', style: const TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                IconButton(onPressed: _pickImage, icon: const Icon(Icons.image)),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(labelText: 'Enunciado'),
              onChanged: _updateStatement,
              controller: TextEditingController(text: draft.statement),
            ),
            const SizedBox(height: 12),
            if (draft.imagePath != null) Padding(padding: const EdgeInsets.only(bottom: 12), child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(draft.imagePath!), height: 140, fit: BoxFit.cover))),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(4, (i) {
                final color = [Color(0xFFd64545), Color(0xFF2b7edf), Color(0xFFe6b11a), Color(0xFF2fa84f)][i];
                final symbol = ['▲', '◆', '●', '■'][i];
                return SizedBox(
                  width: 320,
                  child: Row(
                    children: [
                      Container(width: 44, height: 44, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)), child: Center(child: Text(symbol, style: const TextStyle(color: Colors.white)))),
                      const SizedBox(width: 8),
                      Expanded(child: TextField(decoration: InputDecoration(labelText: 'Añadir respuesta ${i + 1}${i < 2 ? '' : ' (opcional)'}'), onChanged: (v) => _updateOptions(i, v), controller: TextEditingController(text: draft.options[i])),),
                      Radio<int>(value: i, groupValue: draft.correctIndex, onChanged: (v) => _setCorrectIndex(v ?? 0)),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
