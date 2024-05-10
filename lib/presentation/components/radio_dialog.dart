import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showRadioDialog<T>({
  required BuildContext context,
  required String title,
  required void Function(T? value) onOkClicked,
  required List<String> radioTitles,
  required List<T> radioValues,
  required T groupValue,
}) {
  showDialog(
    context: context,
    builder: (context) {
      T? tempValue = groupValue;
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            title: Text(title),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(32.0),
              ),
            ),
            contentPadding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
            actionsPadding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onOkClicked(tempValue);
                },
                child: Text(AppLocalizations.of(context)!.ok),
              ),
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final (index, radioValue) in radioValues.indexed)
                  InkWell(
                    onTap: () => setState(() => tempValue = radioValue),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                      child: Row(
                        children: [
                          Radio<T>(
                            value: radioValue,
                            groupValue: tempValue,
                            onChanged: (value) => setState(() => tempValue = value),
                          ),
                          const SizedBox(width: 12.0),
                          Text(
                            radioTitles[index],
                            style: const TextStyle(fontSize: 16.0),
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}
