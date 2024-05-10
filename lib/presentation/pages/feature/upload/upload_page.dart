import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_sharing_app/domain/entity/category.dart';
import 'package:video_sharing_app/presentation/components/app_bar_back_button.dart';
import 'package:video_sharing_app/presentation/pages/feature/home/video_player_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/add_description_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/add_location_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/comment_setting_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/provider/upload_provider.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/select_audience_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/select_category_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/set_privacy_page.dart';
import 'package:video_sharing_app/presentation/shared/asset.dart';
import 'package:video_sharing_app/presentation/shared/ext.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key, required String videoPath}) : _videoPath = videoPath;

  final String _videoPath;

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  late VideoPlayerController videoPlayerController;
  final audioPlayer = AudioPlayer();

  bool initVideoPlayer = false;
  bool processingVideo = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.file(File(widget._videoPath))
      ..initialize().then((value) => setState(() => initVideoPlayer = true));

    // Play background music.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await audioPlayer.setAsset(Asset.motivate);
      await audioPlayer.play();
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
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
                title: Text(AppLocalizations.of(context)!.addDetails),
                leading: appBarBackButton(context),
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
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    AppLocalizations.of(context)!.addTitle,
                                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
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
                                  child: ListTile(
                                    leading: const Icon(Icons.edit),
                                    title: Text(AppLocalizations.of(context)!.addDescription),
                                    trailing: const Icon(Icons.chevron_right),
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
                                    title: Text(AppLocalizations.of(context)!.category),
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
                                    title: Text(AppLocalizations.of(context)!.privacy),
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
                                  child: ListTile(
                                    leading: const Icon(Icons.group),
                                    title: Text(AppLocalizations.of(context)!.selectAudience),
                                    trailing: const Row(
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
                                    title: Text(AppLocalizations.of(context)!.comment),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          provider.commentAllowed
                                              ? AppLocalizations.of(context)!.commentAllow
                                              : AppLocalizations.of(context)!.commentDisallow,
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
                                    title: Text(AppLocalizations.of(context)!.location),
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
                                            if (context.mounted) Navigator.popUntil(context, (route) => route.isFirst);
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
                                        child: Text(AppLocalizations.of(context)!.uploadVideo),
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
