import 'package:flutter/material.dart';
import '../data/sample_extra_content.dart';

class CreatorCard extends StatelessWidget {
  final Creator creator;
  const CreatorCard({super.key, required this.creator});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primaryContainer,
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(creator.imageUrl),
              radius: 26,
            ),
            const SizedBox(height: 12),
            Text(
              creator.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            Text('Art', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}