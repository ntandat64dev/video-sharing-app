import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:video_sharing_app/presentation/components/app_bar_back_button.dart';

class CommentSettingPage extends StatefulWidget {
  const CommentSettingPage({super.key, required bool commentAllowed}) : _commentAllowed = commentAllowed;

  final bool _commentAllowed;

  @override
  State<CommentSettingPage> createState() => _CommentSettingPageState();
}

enum CommentAllowed { yes, no }

class _CommentSettingPageState extends State<CommentSettingPage> {
  CommentAllowed? commentAllowed = CommentAllowed.yes;

  @override
  void initState() {
    super.initState();
    commentAllowed = widget._commentAllowed ? CommentAllowed.yes : CommentAllowed.no;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: appBarBackButton(context),
        title: Text(
          AppLocalizations.of(context)!.comment,
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
                          AppLocalizations.of(context)!.chooseCommentType,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      RadioListTile<CommentAllowed>(
                        value: CommentAllowed.yes,
                        groupValue: commentAllowed,
                        onChanged: (CommentAllowed? value) => setState(() => commentAllowed = value),
                        title: Text(AppLocalizations.of(context)!.commentAllow),
                      ),
                      RadioListTile<CommentAllowed>(
                        value: CommentAllowed.no,
                        groupValue: commentAllowed,
                        onChanged: (CommentAllowed? value) => setState(() => commentAllowed = value),
                        title: Text(AppLocalizations.of(context)!.commentDisallow),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          final data = commentAllowed == CommentAllowed.yes;
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
