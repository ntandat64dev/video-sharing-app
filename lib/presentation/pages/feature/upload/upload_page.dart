import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_sharing_app/domain/entity/category.dart';
import 'package:video_sharing_app/presentation/pages/feature/home/video_player_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/add_description_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/add_location_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/comment_setting_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/provider/upload_provider.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/select_audience_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/select_category_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/set_privacy_page.dart';
import 'package:video_sharing_app/presentation/shared/ext.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key, required String videoPath}) : _videoPath = videoPath;

  final String _videoPath;

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  late VideoPlayerController videoPlayerController;

  bool initVideoPlayer = false;
  bool processingVideo = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.file(File(widget._videoPath))
      ..initialize().then((value) => setState(() => initVideoPlayer = true));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UploadProvider(widget._videoPath),
      builder: (context, child) {
        return Consumer<UploadProvider>(
          builder: (context, provider, child) {
            return Scaffold(
              appBar: AppBar(
                surfaceTintColor: Colors.transparent,
                title: const Text(
                  'Add Details',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              body: LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: MediaQuery.of(context).size.width / videoPlayerRatio,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16.0),
                                      child: !initVideoPlayer
                                          ? const Center(child: CircularProgressIndicator())
                                          : VideoPlayer(videoPlayerController),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'Add a Title',
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: TextField(
                                    onChanged: (value) => provider.updateVideoDetails((video) => video.title = value),
                                    cursorColor: Theme.of(context).colorScheme.primary,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      fillColor: Theme.of(context).colorScheme.onInverseSurface,
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide:
                                            BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide:
                                            BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                InkWell(
                                  onTap: () async {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    final data = await Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => AddDescriptionPage(
                                          description: provider.description,
                                          hashtags: provider.hashtags,
                                        ),
                                      ),
                                    ) as Map<String, dynamic>?;
                                    if (data != null) {
                                      provider.updateVideoDetails((video) {
                                        video.description = data[kDescription];
                                        video.hashtags = data[kHashtags];
                                      });
                                    }
                                  },
                                  child: const ListTile(
                                    leading: Icon(Icons.edit),
                                    title: Text('Add Description'),
                                    trailing: Icon(Icons.chevron_right),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    final category = await Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => const SelectCategoryPage(),
                                      ),
                                    ) as Category?;
                                    if (category != null) {
                                      provider.updateVideoDetails((video) => video.category = category);
                                    }
                                  },
                                  child: ListTile(
                                    leading: const Icon(Icons.category),
                                    title: const Text('Category'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          provider.category?.category ?? '',
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        const Icon(Icons.chevron_right),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    final privacy = await Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => SetPrivacyPage(privacy: provider.privacy),
                                      ),
                                    ) as String?;
                                    if (privacy != null) {
                                      provider.updateVideoDetails((video) => video.privacy = privacy);
                                    }
                                  },
                                  child: ListTile(
                                    leading: const Icon(Icons.remove_red_eye_sharp),
                                    title: const Text('Privacy'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          provider.privacy.capitalize(),
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        const Icon(Icons.chevron_right),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    final data = await Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => SelectAudiencePage(
                                          madeForKids: provider.madeForKids,
                                          ageRestricted: provider.ageRestricted,
                                        ),
                                      ),
                                    ) as Map<String, bool>?;
                                    if (data != null) {
                                      provider.updateVideoDetails((video) {
                                        video.madeForKids = data[kMadeForKids];
                                        video.ageRestricted = data[kAgeRestricted];
                                      });
                                    }
                                  },
                                  child: const ListTile(
                                    leading: Icon(Icons.group),
                                    title: Text('Select Audience'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.chevron_right),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    final commentAllowed = await Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => CommentSettingPage(
                                          commentAllowed: provider.commentAllowed,
                                        ),
                                      ),
                                    ) as bool?;
                                    if (commentAllowed != null) {
                                      provider.updateVideoDetails((video) => video.commentAllowed = commentAllowed);
                                    }
                                  },
                                  child: ListTile(
                                    leading: const Icon(Icons.comment),
                                    title: const Text('Comment'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          provider.commentAllowed ? 'Allow all comments' : 'Disable comments',
                                          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                                        ),
                                        const SizedBox(width: 8.0),
                                        const Icon(Icons.chevron_right),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    final location = await Navigator.push(
                                      context,
                                      CupertinoPageRoute(builder: (context) => const AddLocationPage()),
                                    ) as String?;
                                    if (location != null) {
                                      provider.updateVideoDetails((video) => video.location = location);
                                    }
                                  },
                                  child: ListTile(
                                    leading: const Icon(Icons.location_pin),
                                    title: const Text('Location'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          provider.location ?? '',
                                          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                                        ),
                                        const SizedBox(width: 8.0),
                                        const Icon(Icons.chevron_right),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Upload button
                            SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: processingVideo
                                    ? const Center(child: CircularProgressIndicator())
                                    : ElevatedButton(
                                        onPressed: () async {
                                          try {
                                            setState(() => processingVideo = true);
                                            await provider.uploadVideo();
                                            setState(() => Navigator.pop(context));
                                          } on Exception catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(content: Text(e.toString())));
                                            }
                                            setState(() => processingVideo = false);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context).colorScheme.primary,
                                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                          padding: const EdgeInsets.all(16.0),
                                        ),
                                        child: const Text('Upload video'),
                                      ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
