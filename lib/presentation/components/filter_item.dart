import 'package:flutter/material.dart';

class FilterItem extends StatelessWidget {
  const FilterItem({super.key, required this.onSelected, required this.text, this.isActive});

  final Function(bool value) onSelected;
  final String text;
  final bool? isActive;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      onSelected: onSelected,
      backgroundColor: Theme.of(context).colorScheme.outlineVariant,
      selectedColor: Theme.of(context).colorScheme.inverseSurface,
      selected: isActive != null && isActive!,
      showCheckmark: false,
      side: BorderSide.none,
      label: Text(
        text,
        style: TextStyle(
          color: (isActive != null && isActive!)
              ? Theme.of(context).colorScheme.onInverseSurface
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
