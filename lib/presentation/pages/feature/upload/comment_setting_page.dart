import 'package:flutter/material.dart';

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
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Comment',
          style: TextStyle(fontWeight: FontWeight.w500),
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
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Choose whether viewer can comment on your video',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      RadioListTile<CommentAllowed>(
                        value: CommentAllowed.yes,
                        groupValue: commentAllowed,
                        onChanged: (CommentAllowed? value) => setState(() => commentAllowed = value),
                        title: const Text('Allow all comments'),
                      ),
                      RadioListTile<CommentAllowed>(
                        value: CommentAllowed.no,
                        groupValue: commentAllowed,
                        onChanged: (CommentAllowed? value) => setState(() => commentAllowed = value),
                        title: const Text('Disable comments'),
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
                        child: const Text('Apply'),
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
