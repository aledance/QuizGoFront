import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter_application_1/presentation/quiz/quiz_form_view_model.dart';
import 'package:flutter_application_1/application/quiz/use_cases/create_quiz.dart';
import 'package:flutter_application_1/infrastructure/injection.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/visibility.dart';
import 'package:flutter_application_1/domain/quiz/entities/author.dart';
import 'package:flutter_application_1/domain/quiz/value_objects/unique_id.dart';

/// A simple form page that uses the [QuizFormViewModel] directly.
///
/// This implementation avoids adding extra DI packages — it constructs
/// a default `CreateQuiz` using `createQuizRepository()` if one is not provided.
class QuizFormPage extends StatefulWidget {
  final CreateQuiz? createQuizUseCase;

  const QuizFormPage({Key? key, this.createQuizUseCase}) : super(key: key);

  @override
  State<QuizFormPage> createState() => _QuizFormPageState();
}

class _QuizFormPageState extends State<QuizFormPage> {
  late final QuizFormViewModel _vm;
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final create = widget.createQuizUseCase ?? CreateQuiz(createQuizRepository());
    _vm = QuizFormViewModel(create);
    _vm.addListener(_onVmChanged);
  }

  void _onVmChanged() => setState(() {});

  @override
  void dispose() {
    _vm.removeListener(_onVmChanged);
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              if (_vm.state == QuizFormState.loading) ...[
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 12),
              ],

              if (_vm.state == QuizFormState.error && _vm.errorMessage != null) ...[
                Text(_vm.errorMessage!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
              ],

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _vm.state == QuizFormState.loading ? null : _onSubmit,
                  child: const Text('Crear'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    // In a real app you'd get the authenticated user as the author. Here we
    // create a placeholder author for demo purposes.
    final author = Author(id: UniqueId(), name: 'Autor de ejemplo');

    await _vm.createQuiz(
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      visibility: Visibility.public,
      author: author,
    );

    if (_vm.state == QuizFormState.success) {
      // Show confirmation and pop
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quiz creado')));
        Navigator.of(context).maybePop();
      }
    }
  }
}
