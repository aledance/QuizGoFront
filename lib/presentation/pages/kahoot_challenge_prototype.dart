import 'package:flutter/material.dart';

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
        title: const Text('Kahoot Challenge Prototype'),
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
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                child: Row(
                  children: [
                    const Icon(Icons.quiz, color: Colors.deepPurple),
                    const SizedBox(width: 12),
                    Expanded(child: Text(_selectedKahootTitle ?? 'Selecciona un Kahoot', style: const TextStyle(fontSize: 16))),
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
class JoinChallengeUI extends StatelessWidget {
  const JoinChallengeUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nicknameController = TextEditingController();
    final pinController = TextEditingController();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Unirse a Reto', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(controller: nicknameController, decoration: const InputDecoration(labelText: 'Nickname')),
            TextField(controller: pinController, decoration: const InputDecoration(labelText: 'PIN del Reto (6 dígitos)')),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final nickname = nicknameController.text;
                  final pin = pinController.text;

                  if (nickname.isEmpty || pin.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nickname and PIN are required')));
                    return;
                  }

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Unido al reto'),
                      content: const Text('playerId: uuid\nplayerToken: jwt-token'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
                      ],
                    ),
                  );
                },
                child: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Unirse (POST /challenges/:id/players)')),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Respuesta (simulada):', style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.grey[300],
              child: const Text('{ "playerId": "uuid", "playerToken": "jwt-token" }'),
            )
          ],
        ),
      ),
    );
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
  int slideIndex = 0;
  int selectedAnswer = 0;
  double timeMs = 1500;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Responder pregunta', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(controller: pinController, decoration: const InputDecoration(labelText: 'PIN del reto')),
          const SizedBox(height: 12),
          Row(children: [
            const Text('Slide:'),
            const SizedBox(width: 12),
            DropdownButton<int>(value: slideIndex, items: List.generate(10, (i) => DropdownMenuItem(value: i, child: Text('Slide ${i + 1}'))), onChanged: (v) => setState(() => slideIndex = v ?? 0)),
          ]),
          const SizedBox(height: 12),
          const Text('Selecciona la respuesta:'),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: List.generate(4, (i) {
            final isSelected = i == selectedAnswer;
            return ChoiceChip(label: Text('Opción ${i + 1}'), selected: isSelected, onSelected: (_) => setState(() => selectedAnswer = i));
          })),
          const SizedBox(height: 12),
          Row(children: [const Text('Tiempo (ms):'), const SizedBox(width: 12), Expanded(child: Slider(value: timeMs, min: 100, max: 3000, divisions: 29, label: timeMs.round().toString(), onChanged: (v) => setState(() => timeMs = v)))]),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: _loading ? const CircularProgressIndicator.adaptive() : const Text('Enviar respuesta')),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> _submit() async {
    final pin = pinController.text.trim();
    if (pin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN requerido')));
      return;
    }
    setState(() => _loading = true);
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Respuesta enviada (simulada)'),
          content: Text('status: OK\nisCorrect: ${selectedAnswer == 0 ? 'true' : 'false'}\npointsEarned: ${selectedAnswer == 0 ? 1000 : 0}\ncurrentScore: 1200'),
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
      setState(() => _rows = simulated);
    } catch (e) {
      showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Error'), content: Text(e.toString()), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))]));
    } finally {
      setState(() => _loading = false);
    }
  }
}
