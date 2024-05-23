import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_sharing_app/domain/entity/category.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/presentation/components/app_bar_back_button.dart';
import 'package:video_sharing_app/presentation/components/sink_animated.dart';
import 'package:video_sharing_app/presentation/pages/feature/video_player/my_video_player.dart';
import 'package:video_sharing_app/presentation/pages/feature/library/your_videos/provider/video_details_provider.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/add_description_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/add_location_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/comment_setting_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/select_audience_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/select_category_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/set_privacy_page.dart';
import 'package:video_sharing_app/presentation/shared/ext.dart';

class UpdateVideoPage extends StatefulWidget {
  const UpdateVideoPage({super.key, required Video video}) : _video = video;

  final Video _video;

  @override
  State<UpdateVideoPage> createState() => _UpdateVideoPageState();
}

class _UpdateVideoPageState extends State<UpdateVideoPage> {
  bool processingVideo = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VideoDetailsProvider(widget._video),
      builder: (context, child) {
        return Consumer<VideoDetailsProvider>(
          builder: (context, provider, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.updateVideoAppBarTitle),
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
                                  aspectRatio: MediaQuery.of(context).size.width / videoPlayerHeight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SinkAnimated(
                                      onTap: () => uploadThumbnail(context),
                                      child: Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          Positioned.fill(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(16.0),
                                                child: provider.thumbnailPath != null
                                                    ? Image.file(
                                                        File(provider.thumbnailPath!),
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : const Center(child: CircularProgressIndicator()),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 4.0, right: 4.0),
                                            child: IconButton(
                                              onPressed: () => uploadThumbnail(context),
                                              style: IconButton.styleFrom(
                                                backgroundColor: const Color.fromARGB(80, 0, 0, 0),
                                              ),
                                              icon: const Icon(
                                                Icons.add_to_photos_rounded,
                                                color: Colors.white,
                                                size: 24.0,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
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
                                    controller: TextEditingController(text: widget._video.title)
                                      ..selection = TextSelection.collapsed(offset: widget._video.title!.length),
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
                                videoDetailItem(
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
                                  icon: (Icons.edit),
                                  title: AppLocalizations.of(context)!.addDescription,
                                ),
                                // Category
                                videoDetailItem(
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
                                  icon: (Icons.category),
                                  title: AppLocalizations.of(context)!.category,
                                  value: provider.category?.category,
                                ),
                                // Privacy
                                videoDetailItem(
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
                                  icon: (Icons.remove_red_eye_sharp),
                                  title: AppLocalizations.of(context)!.privacy,
                                  value: provider.privacy.capitalize(),
                                ),
                                // Select Audience
                                videoDetailItem(
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
                                  icon: (Icons.group),
                                  title: AppLocalizations.of(context)!.selectAudience,
                                ),
                                // Comment
                                videoDetailItem(
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
                                  icon: (Icons.comment),
                                  title: AppLocalizations.of(context)!.comment,
                                  value: provider.commentAllowed
                                      ? AppLocalizations.of(context)!.commentAllow
                                      : AppLocalizations.of(context)!.commentDisallow,
                                ),
                                // Location
                                videoDetailItem(
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
                                  icon: Icons.location_pin,
                                  title: AppLocalizations.of(context)!.location,
                                  value: provider.location,
                                ),
                              ],
                            ),
                            // Update button
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
                                            final updatedVideo = await provider.updateVideo();
                                            if (updatedVideo != null && context.mounted) {
                                              setState(() => processingVideo = false);
                                              Navigator.pop(context, true);
                                            }
                                          } on Exception catch (e) {
                                            if (context.mounted) {
                                              setState(() => processingVideo = false);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(content: Text(e.toString())));
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context).colorScheme.primary,
                                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                          padding: const EdgeInsets.all(16.0),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!.updateVideoAppBarTitle,
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

  void uploadThumbnail(context) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null && mounted) {
      Provider.of<VideoDetailsProvider>(context, listen: false).setThumbnailPath(file.path);
    }
  }

  Widget videoDetailItem({
    required void Function() onTap,
    required IconData icon,
    required String title,
    String? value,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.onSurface),
                const SizedBox(width: 16.0),
                Text(title, style: const TextStyle(fontSize: 16.0)),
              ],
            ),
            const SizedBox(width: 32.0),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  value != null
                      ? Expanded(
                          child: Wrap(
                            alignment: WrapAlignment.end,
                            children: [
                              Text(
                                value,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
