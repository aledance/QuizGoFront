import 'package:flutter/material.dart';

class ChallengeCard extends StatelessWidget {
  final String challengeId;
  final int pin;
  final DateTime deadline;
  final String shareLink;

  const ChallengeCard({super.key, required this.challengeId, required this.pin, required this.deadline, required this.shareLink});

  @override
  Widget build(BuildContext context) {
    final remaining = deadline.difference(DateTime.now());
    final days = remaining.inDays;

    // Styled card with a left accent and purple highlights
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          // left accent bar
          Container(width: 8, height: 84, decoration: BoxDecoration(color: Colors.deepPurple.shade400, borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)))),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  // info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reto $challengeId', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text('PIN: ${pin.toString().padLeft(6, '0')}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple.shade700)),
                        const SizedBox(height: 8),
                        Text(days >= 0 ? 'Expira en $days días' : 'Expirado', style: TextStyle(color: days >= 0 ? Colors.black54 : Colors.red)),
                      ],
                    ),
                  ),

                  // actions
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () => _share(context), icon: Icon(Icons.share, color: Colors.deepPurple.shade600)),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 34,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple.shade600, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                          onPressed: () {},
                          child: const Text('Unirse', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _share(BuildContext context) {
    // In a real app use share_plus; here show a snackbar with the link.
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Compartir: $shareLink')));
  }
}
