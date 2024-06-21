import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:video_sharing_app/presentation/components/app_bar_actions.dart';
import 'package:video_sharing_app/presentation/components/app_bar_back_button.dart';
import 'package:video_sharing_app/presentation/components/custom_text_field.dart';

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
        leading: appBarBackButton(context),
        title: Text(
          AppLocalizations.of(context)!.addDescription,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: const [
          MoreButon(),
        ],
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
                        child: CustomTextField(
                          controller: descriptionController,
                          maxLines: 12,
                          minLines: 12,
                          maxLength: 10000,
                          hintText: AppLocalizations.of(context)!.yourDescription,
                        ),
                      ),
                      // Hashtag
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          AppLocalizations.of(context)!.hashtag,
                          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CustomTextField(
                          controller: hashtagsController,
                          onSubmitted: (value) {
                            if (value.trim().isEmpty) return;
                            setState(() {
                              hashtags.add(value.trim());
                              hashtagsController.text = '';
                            });
                          },
                          onEditingComplete: () {},
                          maxLines: 1,
                          minLines: 1,
                          hintText: AppLocalizations.of(context)!.typeAndEnter,
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
                                deleteIcon: const Icon(Icons.close_rounded, size: 20.0),
                                onDeleted: () => setState(() => hashtags.remove(e)),
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
                        child: Text(
                          AppLocalizations.of(context)!.apply,
                          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                        ),
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
