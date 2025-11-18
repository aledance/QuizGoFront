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

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reto $challengeId', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text('PIN: ${pin.toString().padLeft(6, '0')}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(days >= 0 ? 'Expira en $days días' : 'Expirado', style: TextStyle(color: days >= 0 ? Colors.black54 : Colors.red)),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(onPressed: () => _share(context), icon: const Icon(Icons.share)),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: () {}, child: const Text('Unirse'))
              ],
            )
          ],
        ),
      ),
    );
  }

  void _share(BuildContext context) {
    // In a real app use share_plus; here show a snackbar with the link.
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Compartir: $shareLink')));
  }
}
