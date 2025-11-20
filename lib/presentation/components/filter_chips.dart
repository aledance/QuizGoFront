import 'package:flutter/material.dart';

class FilterChips extends StatefulWidget {
  final List<String> options;
  final ValueChanged<List<String>>? onSelectionChanged;

  const FilterChips({super.key, required this.options, this.onSelectionChanged});

  @override
  State<FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> {
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: widget.options.map((opt) {
          final selected = _selected.contains(opt);
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(opt),
              selected: selected,
              onSelected: (_) {
                setState(() {
                  if (selected) {
                    _selected.remove(opt);
                  } else {
                    _selected.add(opt);
                  }
                });
                widget.onSelectionChanged?.call(_selected.toList());
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}