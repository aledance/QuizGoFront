import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/admin/pages/admin_dashboard_page.dart';
import '../controllers/kahoot_editor_controller.dart';
import '../services/kahoot_service.dart';
import '../../application/editor/kahoot_editor.dart';
// domain question import not required here

class KahootEditorPage extends StatefulWidget {
  const KahootEditorPage({super.key});

  @override
  State<KahootEditorPage> createState() => _KahootEditorPageState();
}

class _KahootEditorPageState extends State<KahootEditorPage> {
  late KahootService _service;
  late KahootEditorController _controller;
  late VoidCallback _listener;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _questionController;
  List<TextEditingController> _answerControllers = [];

  @override
  void initState() {
    super.initState();
    _service = KahootService(baseUrl: 'http://localhost:3000');
    _controller = KahootEditorController(service: _service, initial: EditorKahoot());
    _listener = () => setState(() {});
    _controller.addListener(_listener);
    _titleController = TextEditingController(text: _controller.editor.title);
    _descController = TextEditingController(text: _controller.editor.description);
    _titleController.addListener(() => _controller.setTitle(_titleController.text));
    _descController.addListener(() => _controller.setDescription(_descController.text));
    _setupQuestionControllers();
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _titleController.dispose();
    _descController.dispose();
    _questionController.dispose();
    for (final c in _answerControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _setupQuestionControllers() {
    // Ensure there is at least one question to avoid out-of-range access
    if (_controller.questions.isEmpty) {
      _controller.addQuestion();
    }
    // Clamp selected index
    if (_controller.selectedQuestionIndex >= _controller.questions.length) {
      _controller.selectedQuestionIndex = _controller.questions.length - 1;
    }

    // Dispose previous controllers if any
    try {
      _questionController.dispose();
    } catch (_) {}
    for (final c in _answerControllers) {
      c.dispose();
    }

    final selected = _controller.selectedQuestion;
    _questionController = TextEditingController(text: selected.text);
    _answerControllers = selected.answers.map((a) => TextEditingController(text: a.text)).toList();
    // update model when controllers change
    _questionController.addListener(() => _controller.setQuestionText(_questionController.text));
    for (var i = 0; i < _answerControllers.length; i++) {
      final idx = i;
      _answerControllers[i].addListener(() {
        final val = _answerControllers[idx].text;
        if (idx < _controller.selectedQuestion.answers.length) _controller.selectedQuestion.answers[idx].text = val;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear / Editar Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: [
          IconButton(
            tooltip: 'Admin',
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminDashboardPage())),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 600;
          if (isSmall) {
            // Mobile layout: questions as horizontal chips and editor below
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.photo_camera, size: 28, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                decoration: const InputDecoration(labelText: 'Título del Quiz'),
                                controller: _titleController,
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                decoration: const InputDecoration(labelText: 'Descripción (opcional)'),
                                controller: _descController,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),

                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Preguntas', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextButton.icon(onPressed: () { _controller.addQuestion(); _setupQuestionControllers(); }, icon: const Icon(Icons.add), label: const Text('Añadir')),
                      ],
                    ),

                    SizedBox(
                      height: 84,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _controller.questions.length,
                        itemBuilder: (context, index) {
                          final selected = index == _controller.selectedQuestionIndex;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text('Pregunta ${index + 1}'),
                              selected: selected,
                              onSelected: (_) {
                                _controller.selectQuestion(index);
                                _setupQuestionControllers();
                              },
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),
                    // Editor card
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: Colors.grey[50],
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Pregunta ${_controller.selectedQuestionIndex + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                IconButton(
                                  tooltip: 'Eliminar pregunta',
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Eliminar pregunta'),
                                        content: const Text('¿Estás seguro que quieres eliminar esta pregunta?'),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
                                          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Eliminar')),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      _controller.removeQuestion(_controller.selectedQuestionIndex);
                                      // If all questions removed, add an empty one to keep editor usable
                                      if (_controller.questions.isEmpty) _controller.addQuestion();
                                      _setupQuestionControllers();
                                    }
                                  },
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              decoration: const InputDecoration(labelText: 'Enunciado'),
                              controller: _questionController,
                            ),
                            const SizedBox(height: 12),
                            Column(
                              children: List.generate(_controller.selectedQuestion.answers.length, (i) {
                                final a = _controller.selectedQuestion.answers[i];
                                final color = [Colors.red, Colors.blue, Colors.yellow[700], Colors.green][i % 4] ?? Colors.grey;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Row(
                                    children: [
                                      Container(width: 36, height: 36, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6))),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(hintText: 'Añadir respuesta ${i + 1}${i >= 2 ? ' (opcional)' : ''}'),
                                          controller: i < _answerControllers.length ? _answerControllers[i] : null,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () {
                                          _controller.setSingleCorrect(i);
                                          setState(() {});
                                        },
                                        child: Icon(a.isCorrect ? Icons.radio_button_checked : Icons.radio_button_off, color: a.isCorrect ? Theme.of(context).primaryColor : Colors.grey),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(onPressed: () { _controller.addAnswerToSelected(); _setupQuestionControllers(); }, icon: const Icon(Icons.add_circle_outline), label: const Text('Añadir respuesta')),
                                ElevatedButton(onPressed: () async {
                                  final errors = _controller.validate();
                                  if (errors.isNotEmpty) {
                                    showMessage(errors.join('\n'));
                                    return;
                                  }
                                  try {
                                    final created = await _controller.createKahoot();
                                    showMessage('Kahoot creado');
                                    await _controller.loadKahoot(created.id ?? '');
                                  } catch (e) {
                                    showMessage('Error: $e');
                                  }
                                }, child: const Text('Guardar'))
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          // Desktop / wide layout (original)
          return Row(
            children: [
              // Left panel: questions list
              Container(
                width: 220,
                color: Colors.grey[100],
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ElevatedButton.icon(onPressed: () { _controller.addQuestion(); _setupQuestionControllers(); }, icon: const Icon(Icons.add), label: const Text('Añadir pregunta')),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _controller.questions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            selected: index == _controller.selectedQuestionIndex,
                            title: Text('Pregunta ${index + 1}'),
                            trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () { _controller.removeQuestion(index); _setupQuestionControllers(); }),
                            onTap: () { _controller.selectQuestion(index); _setupQuestionControllers(); },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Right panel: editor
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(width: 96, height: 96, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.photo_camera, size: 32, color: Colors.grey)),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            TextField(decoration: const InputDecoration(labelText: 'Título del Quiz'), controller: _titleController),
                            const SizedBox(height: 8),
                            TextField(decoration: const InputDecoration(labelText: 'Descripción (opcional)'), controller: _descController),
                          ]),
                        ),
                        const SizedBox(width: 20),
                      ]),

                      const SizedBox(height: 20),
                      const Text('Editar preguntas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),

                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: Colors.grey[50],
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Pregunta ${_controller.selectedQuestionIndex + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            TextField(decoration: const InputDecoration(labelText: 'Enunciado'), controller: _questionController),
                            const SizedBox(height: 12),

                            // Answers grid
                            Column(children: List.generate(_controller.selectedQuestion.answers.length, (i) {
                              final a = _controller.selectedQuestion.answers[i];
                              final color = [Colors.red, Colors.blue, Colors.yellow[700], Colors.green][i % 4] ?? Colors.grey;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: Row(children: [
                                  Container(width: 40, height: 40, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6))),
                                  const SizedBox(width: 12),
                                  Expanded(child: TextField(decoration: InputDecoration(hintText: 'Añadir respuesta ${i + 1}${i >= 2 ? ' (opcional)' : ''}'), controller: i < _answerControllers.length ? _answerControllers[i] : null)),
                                  const SizedBox(width: 12),
                                  // Radio for single correct
                                  GestureDetector(onTap: () { _controller.setSingleCorrect(i); setState(() {}); }, child: Icon(a.isCorrect ? Icons.radio_button_checked : Icons.radio_button_off, color: a.isCorrect ? Theme.of(context).primaryColor : Colors.grey)),
                                ]),
                              );
                            })),

                            const SizedBox(height: 8),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              TextButton.icon(onPressed: () { _controller.addAnswerToSelected(); _setupQuestionControllers(); }, icon: const Icon(Icons.add_circle_outline), label: const Text('Añadir respuesta')),
                              ElevatedButton(onPressed: () async {
                                final errors = _controller.validate();
                                if (errors.isNotEmpty) {
                                  showMessage(errors.join('\n'));
                                  return;
                                }
                                try {
                                  final created = await _controller.createKahoot();
                                  showMessage('Kahoot creado');
                                  await _controller.loadKahoot(created.id ?? '');
                                } catch (e) {
                                  showMessage('Error: $e');
                                }
                              }, child: const Text('Guardar'))
                            ])
                          ]),
                        ),
                      )
                    ]),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void showMessage(String text) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    });
  }
}
