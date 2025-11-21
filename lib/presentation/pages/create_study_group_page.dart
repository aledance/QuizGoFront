import 'package:flutter/material.dart';

class CreateStudyGroupPage extends StatefulWidget {
  const CreateStudyGroupPage({super.key});

  @override
  State<CreateStudyGroupPage> createState() => _CreateStudyGroupPageState();
}

class _CreateStudyGroupPageState extends State<CreateStudyGroupPage> {
  final TextEditingController _nameCtrl = TextEditingController();
  bool _hasImage = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.black.withOpacity(0.6),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: Card(
                color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2B2B2B) : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Crear un grupo de estudio', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 18),

                      // Image placeholder
                      GestureDetector(
                        onTap: () {
                          // placeholder for image picker
                          setState(() => _hasImage = !_hasImage);
                        },
                        child: Container(
                          width: 220,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: scheme.onSurface.withOpacity(0.12)),
                            color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1F1F1F) : Colors.grey[100],
                          ),
                          child: _hasImage
                              ? const Center(child: Icon(Icons.photo, size: 48))
                              : Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.image, size: 36, color: Colors.white70),
                                      const SizedBox(height: 10),
                                      Text('Pulsa para añadir una imagen de portada', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54)),
                                    ],
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 18),
                      Align(alignment: Alignment.centerLeft, child: Text('Añadir un nombre de grupo', style: Theme.of(context).textTheme.bodyMedium)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nameCtrl,
                        decoration: InputDecoration(
                          hintText: 'Escribe aquí el nombre del grupo...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF111111) : Colors.grey[200],
                              ),
                              child: const Text('Cancelar'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: (_nameCtrl.text.trim().isEmpty) ? null : () {
                                final name = _nameCtrl.text.trim();
                                final map = {
                                  'name': name,
                                  'members': 1,
                                  'description': 'Grupo creado por ti',
                                  'membersList': ['Tú'],
                                  'messages': []
                                };
                                Navigator.of(context).pop(map);
                              },
                              child: const Text('Crear grupo'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      Text('Únete a un grupo de estudio con un enlace de invitación o código.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
