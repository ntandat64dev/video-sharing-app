import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddDescriptionPage extends StatefulWidget {
  const AddDescriptionPage({
    super.key,
    required String? description,
    required List<String> hashtags,
  })  : _description = description,
        _hashtags = hashtags;

  final String? _description;
  final List<String> _hashtags;

  @override
  State<AddDescriptionPage> createState() => _AddDescriptionPageState();
}

const kDescription = 'description';
const kHashtags = 'hashtags';

class _AddDescriptionPageState extends State<AddDescriptionPage> {
  final descriptionController = TextEditingController();
  final hashtagsController = TextEditingController();

  late final List<String> hashtags = [];

  @override
  void initState() {
    super.initState();
    hashtags.addAll(widget._hashtags);
    descriptionController.text = widget._description ?? '';
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
          AppLocalizations.of(context)!.addDescription,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          AppLocalizations.of(context)!.description,
                          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: descriptionController,
                          minLines: 12,
                          maxLines: 12,
                          maxLength: 1000,
                          cursorColor: Theme.of(context).colorScheme.primary,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.yourDescription,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            fillColor: Theme.of(context).colorScheme.onInverseSurface,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          AppLocalizations.of(context)!.hashtag,
                          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: hashtagsController,
                          onSubmitted: (value) {
                            if (value.trim().isEmpty) return;
                            setState(() {
                              hashtags.add(value.trim());
                              hashtagsController.text = '';
                            });
                          },
                          onEditingComplete: () {},
                          minLines: 1,
                          maxLines: 1,
                          cursorColor: Theme.of(context).colorScheme.primary,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.typeAndEnter,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            fillColor: Theme.of(context).colorScheme.onInverseSurface,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Wrap(
                          spacing: 8.0,
                          children: [
                            ...hashtags.map(
                              (e) => Chip(
                                label: Text(e),
                                side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          final Map<String, dynamic> data = {
                            kDescription: descriptionController.text,
                            kHashtags: hashtags,
                          };
                          Navigator.pop(context, data);
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
