import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showConsistentBottomSheet({
  required BuildContext context,
  required double height,
  Widget? title,
  required Widget content,
  Widget? negativeButton,
  Widget? confirmButton,
}) =>
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        ),
      ),
      builder: (context) => SizedBox(
        height: height,
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 12.0),
            Container(
              width: 38.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            title != null
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: title,
                      ),
                      Divider(
                        height: 0.0,
                        thickness: 0.5,
                        indent: 16.0,
                        endIndent: 16.0,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 16.0),
            Expanded(child: content),
            negativeButton != null || confirmButton != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        negativeButton != null
                            ? Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: negativeButton,
                                ),
                              )
                            : const SizedBox.shrink(),
                        confirmButton != null
                            ? Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: confirmButton,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );

Widget bottomSheetNegativeButton({
  required BuildContext context,
  String? text,
  void Function()? onPressed,
}) {
  return TextButton(
    onPressed: onPressed ?? () => Navigator.pop(context),
    style: TextButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      foregroundColor: Theme.of(context).colorScheme.onInverseSurface,
      padding: const EdgeInsets.all(16.0),
    ),
    child: Text(
      text ?? AppLocalizations.of(context)!.cancel,
      style: const TextStyle(fontWeight: FontWeight.w600),
    ),
  );
}

Widget bottomSheetConfirmButton({
  required BuildContext context,
  String? text,
  required void Function() onPressed,
}) {
  return TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      padding: const EdgeInsets.all(16.0),
    ),
    child: Text(
      text ?? AppLocalizations.of(context)!.ok,
      style: const TextStyle(fontWeight: FontWeight.w600),
    ),
  );
}
