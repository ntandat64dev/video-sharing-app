import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
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
import 'package:video_thumbnail/video_thumbnail.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key, required String videoPath}) : _videoPath = videoPath;

  final String _videoPath;

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final audioPlayer = AudioPlayer();

  Image? thumbnailImage;
  bool processingVideo = false;

  @override
  void initState() {
    super.initState();

    VideoThumbnail.thumbnailData(
      video: widget._videoPath,
      imageFormat: ImageFormat.JPEG,
    ).then((bytes) {
      if (bytes != null) {
        setState(() => thumbnailImage = Image.memory(bytes));
      }
    });

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
                title: Text(AppLocalizations.of(context)!.addDetailsAppBarTitle),
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
                                      child: thumbnailImage ?? const Center(child: CircularProgressIndicator()),
                                    ),
                                  ),
                                ),
                                // Title
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
                                // Description
                                videoDetailListTile(
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
                                  leading: const Icon(Icons.edit),
                                  title: AppLocalizations.of(context)!.addDescription,
                                ),
                                // Category
                                videoDetailListTile(
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
                                  leading: const Icon(Icons.category),
                                  title: AppLocalizations.of(context)!.category,
                                  value: provider.category?.category,
                                ),
                                // Privacy
                                videoDetailListTile(
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
                                  leading: const Icon(Icons.remove_red_eye_sharp),
                                  title: AppLocalizations.of(context)!.privacy,
                                  value: provider.privacy.capitalize(),
                                ),
                                // Select Audience
                                videoDetailListTile(
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
                                  leading: const Icon(Icons.group),
                                  title: AppLocalizations.of(context)!.selectAudience,
                                ),
                                // Comment
                                videoDetailListTile(
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
                                  leading: const Icon(Icons.comment),
                                  title: AppLocalizations.of(context)!.comment,
                                  value: provider.commentAllowed
                                      ? AppLocalizations.of(context)!.commentAllow
                                      : AppLocalizations.of(context)!.commentDisallow,
                                ),
                                // Location
                                videoDetailListTile(
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
                                  leading: const Icon(Icons.location_pin),
                                  title: AppLocalizations.of(context)!.location,
                                  value: provider.location,
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
                                        child: Text(
                                          AppLocalizations.of(context)!.uploadVideo,
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
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

  Widget videoDetailListTile({
    required void Function() onTap,
    required Widget leading,
    required String title,
    String? value,
  }) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: leading,
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            value != null
                ? Wrap(
                    direction: Axis.vertical,
                    children: [
                      Text(value, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal)),
                      const SizedBox(width: 8.0),
                    ],
                  )
                : const SizedBox.shrink(),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
