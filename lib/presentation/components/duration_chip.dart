import 'package:flutter/material.dart';
import 'package:video_sharing_app/presentation/shared/utils.dart';

class DurationChip extends StatelessWidget {
  const DurationChip({super.key, required this.isoDuration});

  final String isoDuration;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10.0,
      right: 10.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(170),
          borderRadius: BorderRadius.circular(6.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
        child: Text(
          formatIsoDuration(isoDuration),
          style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
    );
  }
}
