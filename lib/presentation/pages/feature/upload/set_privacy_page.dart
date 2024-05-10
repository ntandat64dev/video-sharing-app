import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SetPrivacyPage extends StatefulWidget {
  const SetPrivacyPage({super.key, required String privacy}) : _privacy = privacy;

  final String _privacy;

  @override
  State<SetPrivacyPage> createState() => _SetPrivacyPageState();
}

enum Privacy { public, private }

class _SetPrivacyPageState extends State<SetPrivacyPage> {
  Privacy? privacy;

  @override
  void initState() {
    super.initState();
    privacy = Privacy.values.firstWhere((e) => e.name == widget._privacy);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          AppLocalizations.of(context)!.setPrivacy,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      RadioListTile<Privacy>(
                        value: Privacy.public,
                        groupValue: privacy,
                        onChanged: (Privacy? value) => setState(() => privacy = value),
                        title: Text(AppLocalizations.of(context)!.public),
                        subtitle: Text(AppLocalizations.of(context)!.privacyPublicSubtext),
                      ),
                      RadioListTile<Privacy>(
                        value: Privacy.private,
                        groupValue: privacy,
                        onChanged: (Privacy? value) => setState(() => privacy = value),
                        title: Text(AppLocalizations.of(context)!.privacy),
                        subtitle: Text(AppLocalizations.of(context)!.privacyPrivateSubtext),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, privacy?.name);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          padding: const EdgeInsets.all(16.0),
                        ),
                        child: Text(AppLocalizations.of(context)!.apply),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
