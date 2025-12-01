import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KahootChallengePrototype extends StatefulWidget {
  const KahootChallengePrototype({Key? key}) : super(key: key);

  @override
  _KahootChallengePrototypeState createState() => _KahootChallengePrototypeState();
}

class _KahootChallengePrototypeState extends State<KahootChallengePrototype> {
  String screen = 'create';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Modos de juegos kahoot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _navButton('Crear Reto', 'create'),
                  const SizedBox(width: 8),
                  _navButton('Unirse', 'join'),
                  const SizedBox(width: 8),
                  _navButton('Responder', 'answer'),
                  const SizedBox(width: 8),
                  _navButton('Ranking', 'ranking'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _renderScreen()),
          ],
        ),
      ),
    );
  }

  Widget _navButton(String label, String value) {
    final isSelected = screen == value;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.deepPurple : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () => setState(() => screen = value),
      child: Text(label),
    );
  }

  Widget _renderScreen() {
    switch (screen) {
      case 'create':
        return const CreateChallengeUI();
      case 'join':
        return const JoinChallengeUI();
      case 'answer':
        return const AnswerUI();
      case 'ranking':
        return const RankingUI();
      default:
        return const SizedBox.shrink();
    }
  }
}

// ------------------ CREAR CHALLENGE ------------------
class CreateChallengeUI extends StatefulWidget {
  const CreateChallengeUI({Key? key}) : super(key: key);

  @override
  State<CreateChallengeUI> createState() => _CreateChallengeUIState();
}

class _CreateChallengeUIState extends State<CreateChallengeUI> {
  String? _selectedKahootTitle;

  @override
  Widget build(BuildContext context) {
    // Controllers can be added later if wiring to backend is needed.

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Crear Reto', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Kahoot selector (friendly title, hides UUID)
            GestureDetector(
              onTap: () async {
                final nameController = TextEditingController();
                final res = await showDialog<String?>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Seleccionar Kahoot'),
                    content: TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Título del Kahoot')),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, null), child: const Text('Cancelar')),
                      FilledButton(onPressed: () => Navigator.pop(context, nameController.text.trim()), child: const Text('Seleccionar')),
                    ],
                  ),
                );
                if (res != null && res.isNotEmpty) {
                  setState(() => _selectedKahootTitle = res);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.quiz, color: Colors.deepPurple),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedKahootTitle ?? 'Selecciona un Kahoot',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            // Kahoot-style CTA
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.deepPurple, padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () {
                  if (_selectedKahootTitle == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona un Kahoot antes de crear el reto')));
                    return;
                  }
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Reto creado'),
                      content: const Text('challengePin: 123456\nchallengeId: uuid\nshareLink: https://app/reto/123456'),
                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))],
                    ),
                  );
                },
                child: const Text('Crear reto con este Kahoot', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),

            const SizedBox(height: 20),
            const Text('Respuesta (simulada):', style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.grey[300],
              child: const Text('{ "challengePin": "123456", "challengeId": "uuid", "shareLink": "https://app/reto/123456" }'),
            )
          ],
        ),
      ),
    );
  }
}

// ------------------ UNIRSE A CHALLENGE ------------------
class JoinChallengeUI extends StatefulWidget {
  const JoinChallengeUI({Key? key}) : super(key: key);

  @override
  State<JoinChallengeUI> createState() => _JoinChallengeUIState();
}

class _JoinChallengeUIState extends State<JoinChallengeUI> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  bool _joining = false;
  bool _joined = false;
  String? _playerId;
  String? _playerToken;

  @override
  void dispose() {
    _nicknameController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: _joined ? _buildJoined(context) : _buildForm(context),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Unirse al reto', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextField(controller: _nicknameController, decoration: const InputDecoration(labelText: 'Nickname')),
        const SizedBox(height: 12),
        TextField(
          controller: _pinController,
          decoration: const InputDecoration(labelText: 'PIN del Reto (6 dígitos)'),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 6,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _joining ? null : () => _onJoin(context),
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            child: _joining ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator.adaptive()) : const Text('Unirse'),
          ),
        ),
        const SizedBox(height: 12),
        const Text('Pista: introduce tu Nickname y el PIN de 6 dígitos que aparece en el reto.'),
      ],
    );
  }

  Widget _buildJoined(BuildContext context) {
    final maskedToken = _playerToken == null ? '' : _playerToken!.replaceRange(4, _playerToken!.length - 4, '...');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Bienvenido', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text('Jugador: ${_nicknameController.text}'),
        const SizedBox(height: 8),
        Text('ID de jugador: ${_playerId ?? ''}'),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: Text('Token: $maskedToken', overflow: TextOverflow.ellipsis)),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: _playerToken == null
                  ? null
                  : () async {
                      await Clipboard.setData(ClipboardData(text: _playerToken!));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Token copiado')));
                    },
            )
        ]),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () {
            // Placeholder: navigate to the challenge view or return to prototype
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Entrando al reto (simulado)')));
          },
          child: const Text('Entrar al reto'),
        ),
      ],
    );
  }

  Future<void> _onJoin(BuildContext context) async {
    final nickname = _nicknameController.text.trim();
    final pin = _pinController.text.trim();
    if (nickname.isEmpty || pin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nickname y PIN son obligatorios')));
      return;
    }
    if (pin.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El PIN debe tener 6 dígitos')));
      return;
    }
    setState(() => _joining = true);
    try {
      // Simulate network call
      await Future.delayed(const Duration(milliseconds: 400));
      final pid = 'player-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}';
      final token = 'tok-${DateTime.now().millisecondsSinceEpoch}';
      setState(() {
        _playerId = pid;
        _playerToken = token;
        _joined = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unido al reto (simulado)')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => _joining = false);
    }
  }
}

// ------------------ ENVIAR RESPUESTA ------------------
class AnswerUI extends StatefulWidget {
  const AnswerUI({Key? key}) : super(key: key);

  @override
  State<AnswerUI> createState() => _AnswerUIState();
}

class _AnswerUIState extends State<AnswerUI> {
  final pinController = TextEditingController();
  int selectedAnswer = -1; // -1 none, 0-3 options
  bool _loading = false;

    static const _colors = [Color(0xFFEA4335), Color(0xFF1E88E5), Color(0xFFF4B400), Color(0xFF0F9D58)];
    static const _shapeIcons = [Icons.change_history, Icons.diamond_outlined, Icons.circle, Icons.crop_square];
    static const _shapeNames = ['Opcion A', 'Opcion B', 'Opcion C', 'Opcion D'];

    @override
    void dispose() {
      pinController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Responder pregunta', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                // --- Question Text ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: const Text(
                    '¿Cuál es el framework de UI para crear apps nativas desde una base de código?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 16),

                // --- Image Placeholder ---
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: NetworkImage('https://flutter.dev/images/flutter-logo-sharing.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- Answer Options ---
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(4, (i) {
                    final isSelected = selectedAnswer == i;
                    return GestureDetector(
                      onTap: () => setState(() => selectedAnswer = i),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _colors[i],
                          borderRadius: BorderRadius.circular(12),
                        boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 6))] : null,
                        border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            child: Icon(_shapeIcons[i], color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(_shapeNames[i], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: _loading ? const CircularProgressIndicator.adaptive() : const Text('Enviar respuesta'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final pin = pinController.text.trim();
    if (pin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN requerido')));
      return;
    }
    if (selectedAnswer < 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona una opción')));
      return;
    }
    setState(() => _loading = true);
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final isCorrect = selectedAnswer == 0; // simulate option A as correct
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(isCorrect ? '¡Correcto!' : 'Incorrecto'),
          content: Text('status: OK\nisCorrect: $isCorrect\npointsEarned: ${isCorrect ? 1000 : 0}\ncurrentScore: 1200'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))],
        ),
      );
    } catch (e) {
      showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Error'), content: Text(e.toString()), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))]));
    } finally {
      setState(() => _loading = false);
    }
  }
}

// ------------------ RANKING ------------------
class RankingUI extends StatefulWidget {
  const RankingUI({Key? key}) : super(key: key);

  @override
  State<RankingUI> createState() => _RankingUIState();
}

class _RankingUIState extends State<RankingUI> {
  final pinController = TextEditingController();
  bool _loading = false;
  List<Map<String, dynamic>> _rows = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Ranking del Reto', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(controller: pinController, decoration: const InputDecoration(labelText: 'PIN del Reto')),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _fetchRanking,
              child: Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: _loading ? const CircularProgressIndicator.adaptive() : const Text('Obtener Ranking')),
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: _rows.isEmpty
                ? const Center(child: Text('No hay datos'))
                : ListView.builder(
                    itemCount: _rows.length,
                    itemBuilder: (context, index) {
                      final r = _rows[index];
                      return ListTile(
                        leading: CircleAvatar(child: Text((index + 1).toString())),
                        title: Text(r['nickname']?.toString() ?? ''),
                        subtitle: Text('Tiempo promedio: ${r['timeAvgMs']}ms'),
                        trailing: Text('Puntos: ${r['totalScore']}'),
                      );
                    },
                  ),
          )
        ]),
      ),
    );
  }

  Future<void> _fetchRanking() async {
    final pin = pinController.text.trim();
    if (pin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN requerido')));
      return;
    }
    setState(() => _loading = true);
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final simulated = [
        {'nickname': 'PlayerOne', 'totalScore': 5400, 'timeAvgMs': 1820},
        {'nickname': 'Gamer22', 'totalScore': 4700, 'timeAvgMs': 2100},
        {'nickname': 'Speedy', 'totalScore': 4300, 'timeAvgMs': 1700},
      ];
      setState(() {
        _rows = simulated;
      });
    } catch (e) {
      showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Error'), content: Text(e.toString()), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))]));
    } finally {
      setState(() => _loading = false);
    }
  }
}
