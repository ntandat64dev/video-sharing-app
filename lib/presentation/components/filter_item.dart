import 'package:flutter/material.dart';

class FilterItem extends StatelessWidget {
  const FilterItem({super.key, required this.onSelected, required this.text, this.isActive});

  final Function(bool value) onSelected;
  final String text;
  final bool? isActive;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
      onSelected: onSelected,
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      selectedColor: Theme.of(context).colorScheme.onSurfaceVariant,
      selected: isActive != null && isActive!,
      showCheckmark: false,
      side: BorderSide.none,
      label: Text(
        text,
        style: TextStyle(
          color: (isActive != null && isActive!)
              ? Theme.of(context).colorScheme.surfaceVariant
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
