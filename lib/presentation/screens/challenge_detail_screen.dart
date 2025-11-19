import 'package:flutter/material.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final String challengeId;
  const ChallengeDetailScreen({super.key, required this.challengeId});

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  int _currentIndex = 0;
  int? _selectedOptionIndex;

  // sample question set
  final _questions = const [
    {
      'title': 'Más vale estar solo',
      'text': '¿Qué significa la expresión?',
      'options': [
        'que vivir como un soldado.',
        'que mal acompañado.',
        'que estar con mucha gente.',
        'que estar en el campo.'
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    final total = _questions.length;
    final q = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(q['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // skip behavior: go to next question or finish
              _skip();
            },
            child: const Text('Skip', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            // top area: timer, image, answers count
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timer circle
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: const Text('21', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                const SizedBox(width: 12),
                // Image / media placeholder
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text('Kahoot!', style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 28, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // answers count
                Column(
                  children: const [
                    Text('0', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Answers', style: TextStyle(color: Colors.black54)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 18),

            // Question text
            Align(
              alignment: Alignment.centerLeft,
              child: Text(q['text'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 12),

            // Options: 2x2 grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 3.5,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate((q['options'] as List).length, (i) {
                  final option = (q['options'] as List<String>)[i];
                  final colors = [Colors.red[600], Colors.blue[600], Colors.amber[700], Colors.green[700]];
                  final bg = colors[i % colors.length] ?? Colors.grey;
                  final isSelected = _selectedOptionIndex == i;

                  return InkWell(
                    onTap: _selectedOptionIndex == null ? () => _onAnswer(i) : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? bg.withOpacity(0.85) : bg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Align(alignment: Alignment.centerLeft, child: Text(option, style: const TextStyle(color: Colors.white, fontSize: 16))),
                    ),
                  );
                }),
              ),
            ),

            // bottom actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: _currentIndex > 0 ? _prev : null, child: const Text('Anterior')),
                ElevatedButton(
                  onPressed: _selectedOptionIndex != null ? () {
                    if (_currentIndex < total - 1) {
                      setState(() {
                        _currentIndex++;
                        _selectedOptionIndex = null;
                      });
                    } else {
                      _finish();
                    }
                  } : null,
                  child: Text(_currentIndex < total - 1 ? 'Siguiente' : 'Finalizar'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onAnswer(int index) {
    // mark selection; in a real app, send to service
    setState(() {
      _selectedOptionIndex = index;
    });
  }

  void _skip() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = null;
      });
    } else {
      _finish();
    }
  }

  // (removed unused _next helper)

  void _prev() {
    if (_currentIndex > 0) setState(() => _currentIndex--);
  }

  void _finish() {
    Navigator.pushReplacementNamed(context, '/results');
  }
}
