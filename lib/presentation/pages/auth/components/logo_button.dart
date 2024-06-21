import 'package:flutter/material.dart';

Widget logoButton({
  required void Function() onTap,
  required BuildContext context,
  required Widget image,
}) =>
    Material(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
          child: image,
        ),
      ),
    );
