import 'package:flutter/material.dart';

class ProgressLinear extends StatelessWidget {
  final double value; // 0.0 .. 1.0
  const ProgressLinear({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(value: value),
        const SizedBox(height: 6),
        Text('${(value * 100).round()}% completado', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
