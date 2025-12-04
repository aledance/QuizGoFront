import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/admin/pages/admin_dashboard_page.dart';
import '../controllers/kahoot_editor_controller.dart';
import '../services/kahoot_service.dart';
import 'package:flutter_application_1/config.dart';
import '../../application/editor/kahoot_editor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/infrastructure/datasources/theme_remote_data_source.dart';


class KahootEditorPage extends StatefulWidget {
  final String? kahootId;

  const KahootEditorPage({super.key, this.kahootId});

  @override
  State<KahootEditorPage> createState() => _KahootEditorPageState();
}

class _KahootEditorPageState extends State<KahootEditorPage> {
  late KahootService _service;
  late KahootEditorController _controller;
  late VoidCallback _listener;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _categoryController;
  late TextEditingController _questionController;
  List<TextEditingController> _answerControllers = [];
  late ThemeRemoteDataSource _themesSource;
  late Future<List<Map<String, dynamic>>> _themesFuture;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _service = KahootService(baseUrl: apiBaseUrl);
    _controller = KahootEditorController(service: _service, initial: EditorKahoot());
    _listener = () => setState(() {});
    _controller.addListener(_listener);
  _themesSource = ThemeRemoteDataSource(client: http.Client(), baseUrl: apiBaseUrl);
  // Load themes but catch any error so the UI doesn't crash; return empty list on failure.
  _themesFuture = _themesSource.listThemes().catchError((e) {
    // Log the error for debugging and return an empty list so the FutureBuilder can continue.
    // ignore: avoid_print
    print('Failed to load themes: $e');
    return <Map<String, dynamic>>[];
  });
    _titleController = TextEditingController(text: _controller.editor.title);
    _descController = TextEditingController(text: _controller.editor.description);
    _categoryController = TextEditingController(text: _controller.editor.category ?? '');
    _categoryController.addListener(() => _controller.setCategory(_categoryController.text.isEmpty ? null : _categoryController.text));
    _titleController.addListener(() => _controller.setTitle(_titleController.text));
    _descController.addListener(() => _controller.setDescription(_descController.text));
    _setupQuestionControllers();



    if (widget.kahootId != null && widget.kahootId!.isNotEmpty) {
      _controller.loadKahoot(widget.kahootId!).then((_) {
        if (!mounted) return;

        _titleController.text = _controller.editor.title;
        _descController.text = _controller.editor.description;
            _categoryController.text = _controller.editor.category ?? '';
        _setupQuestionControllers();
        setState(() {});
      }).catchError((e) {

      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _titleController.dispose();
    _descController.dispose();
    _categoryController.dispose();
    _questionController.dispose();
    for (final c in _answerControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _setupQuestionControllers() {

    if (_controller.questions.isEmpty) {
      _controller.addQuestion();
    }

    if (_controller.selectedQuestionIndex >= _controller.questions.length) {
      _controller.selectedQuestionIndex = _controller.questions.length - 1;
    }


    try {
      _questionController.dispose();
    } catch (_) {}
    for (final c in _answerControllers) {
      c.dispose();
    }

    final selected = _controller.selectedQuestion;
    _questionController = TextEditingController(text: selected.text);
    _answerControllers = selected.answers.map((a) => TextEditingController(text: a.text)).toList();

    _questionController.addListener(() => _controller.setQuestionText(_questionController.text));
    for (var i = 0; i < _answerControllers.length; i++) {
      final idx = i;
      _answerControllers[i].addListener(() {
        final val = _answerControllers[idx].text;
        if (idx < _controller.selectedQuestion.answers.length) {
          _controller.selectedQuestion.answers[idx].text = val.isEmpty ? null : val;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final placeholderColor = isDark ? scheme.surfaceContainerHigh : scheme.surfaceContainerLowest;
    final placeholderIconColor = scheme.onSurfaceVariant;
    final editorCardColor = isDark ? scheme.surfaceContainerHigh : scheme.surface;
    final sidePanelColor = isDark ? scheme.surfaceContainerHighest : scheme.surfaceContainerLow;

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
                            decoration: BoxDecoration(color: placeholderColor, borderRadius: BorderRadius.circular(8)),
                            child: Icon(Icons.photo_camera, size: 28, color: placeholderIconColor),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                                                if (_controller.editor.author.authorId.isNotEmpty)
                                                  Padding(padding: const EdgeInsets.only(bottom: 8.0), child: Chip(label: Text('Autor: ${_controller.editor.author.name}'))),
                                                FutureBuilder<List<Map<String, dynamic>>>(
                                                  future: _themesFuture,
                                                  builder: (ctx, snap) {
                                                    final themes = snap.data ?? [];
                                                    // If themes list is empty but there's a selected themeId, show it as a Chip
                                                    if (themes.isEmpty) {
                                                      if (_controller.editor.themeId != null && _controller.editor.themeId!.isNotEmpty) {
                                                        return Padding(padding: const EdgeInsets.only(bottom: 8.0), child: Chip(label: Text('Tema: ${_controller.editor.themeId}')));
                                                      }
                                                      return const SizedBox.shrink();
                                                    }
                                                    // Find selected theme label if available
                                                    final selectedTheme = themes.firstWhere((t) => (t['id'] ?? '').toString() == (_controller.editor.themeId ?? ''), orElse: () => {});
                                                    final selectedLabel = selectedTheme.isNotEmpty ? (selectedTheme['name'] ?? selectedTheme['id'] ?? '').toString() : null;
                                                    return Padding(
                                                      padding: const EdgeInsets.only(bottom: 8.0),
                                                      child: Row(children: [
                                                        const Text('Tema: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                        const SizedBox(width: 8),
                                                        DropdownButton<String>(
                                                          value: (_controller.editor.themeId == null || _controller.editor.themeId == '') ? null : _controller.editor.themeId,
                                                          hint: Text(selectedLabel ?? 'Seleccionar tema'),
                                                          items: [
                                                            const DropdownMenuItem<String>(value: '', child: Text('Sin tema')),
                                                            ...themes.map((t) {
                                                              final id = (t['id'] ?? '').toString();
                                                              final label = (t['name'] ?? t['id'] ?? '').toString();
                                                              return DropdownMenuItem<String>(value: id, child: Text(label));
                                                            }).toList(),
                                                          ],
                                                          onChanged: (v) {
                                                            final val = (v != null && v.isEmpty) ? null : v;
                                                            _controller.setThemeId(val);
                                                          },
                                                        ),
                                                      ]),
                                                    );
                                                  },
                                                ),
                              TextField(
                                decoration: const InputDecoration(labelText: 'Título del Quiz'),
                                controller: _titleController,
                                enabled: !_isSaving,
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                decoration: const InputDecoration(labelText: 'Descripción (opcional)'),
                                controller: _descController,
                                enabled: !_isSaving,
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                decoration: const InputDecoration(labelText: 'Categoría'),
                                controller: _categoryController,
                                enabled: !_isSaving,
                              ),
                              const SizedBox(height: 8),
                              Row(children: [
                                const Text('Estado: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                DropdownButton<String>(
                                  value: _controller.editor.status ?? 'draft',
                                  items: const [
                                    DropdownMenuItem(value: 'draft', child: Text('Draft')),
                                    DropdownMenuItem(value: 'published', child: Text('Published')),
                                    DropdownMenuItem(value: 'archived', child: Text('Archived')),
                                  ],
                                  onChanged: (v) => _controller.setStatus(v),
                                )
                              ]),
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

                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: editorCardColor,
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
                                ElevatedButton(onPressed: _isSaving ? null : () async {
                                  final errors = _controller.validate();
                                  if (errors.isNotEmpty) {
                                    showMessage(errors.join('\n'));
                                    return;
                                  }
                                  setState(() { _isSaving = true; });
                                  try {
                                    if (_controller.editor.id != null && _controller.editor.id!.isNotEmpty) {
                                      final updated = await _controller.updateKahoot(_controller.editor.id!);
                                      showMessage('Kahoot actualizado');
                                      await _controller.loadKahoot(updated.id ?? '');
                                    } else {
                                      final created = await _controller.createKahoot();
                                      showMessage('Kahoot creado');
                                      await _controller.loadKahoot(created.id ?? '');
                                    }
                                  } catch (e) {
                                    final msg = e.toString();
                                    showMessage('Error: ${msg.length > 200 ? msg.substring(0,200) + "..." : msg}');
                                  } finally {
                                    if (mounted) setState(() { _isSaving = false; });
                                  }
                                }, child: _isSaving ? const SizedBox(width:16, height:16, child: CircularProgressIndicator(strokeWidth:2)) : const Text('Guardar'))
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


          return Row(
            children: [

              Container(
                width: 220,
                color: sidePanelColor,
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


              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(width: 96, height: 96, decoration: BoxDecoration(color: placeholderColor, borderRadius: BorderRadius.circular(8)), child: Icon(Icons.photo_camera, size: 32, color: placeholderIconColor)),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future: _themesFuture,
                              builder: (ctx, snap) {
                                final themes = snap.data ?? [];
                                if (themes.isEmpty) {
                                  if (_controller.editor.themeId != null && _controller.editor.themeId!.isNotEmpty) {
                                    return Padding(padding: const EdgeInsets.only(bottom: 8.0), child: Chip(label: Text('Tema: ${_controller.editor.themeId}')));
                                  }
                                  return const SizedBox.shrink();
                                }
                                final selectedTheme = themes.firstWhere((t) => (t['id'] ?? '').toString() == (_controller.editor.themeId ?? ''), orElse: () => {});
                                final selectedLabel = selectedTheme.isNotEmpty ? (selectedTheme['name'] ?? selectedTheme['id'] ?? '').toString() : null;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(children: [
                                    const Text('Tema: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    DropdownButton<String>(
                                      value: (_controller.editor.themeId == null || _controller.editor.themeId == '') ? null : _controller.editor.themeId,
                                      hint: Text(selectedLabel ?? 'Seleccionar tema'),
                                      items: [
                                        const DropdownMenuItem<String>(value: '', child: Text('Sin tema')),
                                        ...themes.map((t) {
                                          final id = (t['id'] ?? '').toString();
                                          final label = (t['name'] ?? t['id'] ?? '').toString();
                                          return DropdownMenuItem<String>(value: id, child: Text(label));
                                        }).toList(),
                                      ],
                                      onChanged: (v) {
                                        final val = (v != null && v.isEmpty) ? null : v;
                                        _controller.setThemeId(val);
                                      },
                                    ),
                                  ]),
                                );
                              },
                            ),
                            TextField(decoration: const InputDecoration(labelText: 'Título del Quiz'), controller: _titleController, enabled: !_isSaving),
                            const SizedBox(height: 8),
                            TextField(decoration: const InputDecoration(labelText: 'Descripción (opcional)'), controller: _descController, enabled: !_isSaving),
                            const SizedBox(height: 8),
                            Row(children: [
                              Expanded(child: TextField(decoration: const InputDecoration(labelText: 'Categoría'), controller: _categoryController, enabled: !_isSaving)),
                              const SizedBox(width: 12),
                              DropdownButton<String>(value: _controller.editor.status ?? 'draft', items: const [
                                DropdownMenuItem(value: 'draft', child: Text('Draft')),
                                DropdownMenuItem(value: 'published', child: Text('Published')),
                                DropdownMenuItem(value: 'archived', child: Text('Archived')),
                              ], onChanged: (v) => _controller.setStatus(v)),
                            ]),
                          ]),
                        ),
                        const SizedBox(width: 20),
                      ]),

                      const SizedBox(height: 20),
                      const Text('Editar preguntas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),

                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: editorCardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Pregunta ${_controller.selectedQuestionIndex + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            TextField(decoration: const InputDecoration(labelText: 'Enunciado'), controller: _questionController),
                            const SizedBox(height: 12),


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

                                  GestureDetector(onTap: () { _controller.setSingleCorrect(i); setState(() {}); }, child: Icon(a.isCorrect ? Icons.radio_button_checked : Icons.radio_button_off, color: a.isCorrect ? Theme.of(context).primaryColor : Colors.grey)),
                                ]),
                              );
                            })),

                            const SizedBox(height: 8),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              TextButton.icon(onPressed: () { _controller.addAnswerToSelected(); _setupQuestionControllers(); }, icon: const Icon(Icons.add_circle_outline), label: const Text('Añadir respuesta')),
                              ElevatedButton(onPressed: _isSaving ? null : () async {
                                final errors = _controller.validate();
                                if (errors.isNotEmpty) {
                                  showMessage(errors.join('\n'));
                                  return;
                                }
                                setState(() { _isSaving = true; });
                                try {
                                  if (_controller.editor.id != null && _controller.editor.id!.isNotEmpty) {
                                    final updated = await _controller.updateKahoot(_controller.editor.id!);
                                    showMessage('Kahoot actualizado');
                                    await _controller.loadKahoot(updated.id ?? '');
                                  } else {
                                    final created = await _controller.createKahoot();
                                    showMessage('Kahoot creado');
                                    await _controller.loadKahoot(created.id ?? '');
                                  }
                                } catch (e) {
                                  final msg = e.toString();
                                  showMessage('Error: ${msg.length > 200 ? msg.substring(0,200) + "..." : msg}');
                                } finally {
                                  if (mounted) setState(() { _isSaving = false; });
                                }
                              }, child: _isSaving ? const SizedBox(width:16, height:16, child: CircularProgressIndicator(strokeWidth:2)) : const Text('Guardar'))
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