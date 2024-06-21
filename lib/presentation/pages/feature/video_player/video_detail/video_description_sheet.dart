import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_sharing_app/presentation/pages/feature/video_player/provider/video_detail_provider.dart';

class VideoDescriptionSheet extends StatelessWidget {
  const VideoDescriptionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoDetailProvider>(
      builder: (context, provider, child) {
        if (!provider.shouldLoadVideoDescription) return const Center(child: CircularProgressIndicator());
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  provider.video.title!,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              // Statistic
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.n(provider.video.likeCount!.toInt()),
                          style: const TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(AppLocalizations.of(context)!.likes),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.n(provider.video.dislikeCount!.toInt()),
                          style: const TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(AppLocalizations.of(context)!.dislikes),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.n(provider.video.viewCount!.toInt()),
                          style: const TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(AppLocalizations.of(context)!.views),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          DateFormat.MMMd().format(provider.video.publishedAt!),
                          style: const TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(provider.video.publishedAt!.year.toString()),
                      ],
                    ),
                  ],
                ),
              ),
              // Hashtags
              SizedBox(
                height: provider.video.hashtags!.isNotEmpty ? 48 : 0,
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(width: 8.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.video.hashtags!.length,
                  itemBuilder: (context, index) {
                    final tag = provider.video.hashtags![index];
                    return Text(
                      '#${tag.replaceAll(' ', '').toLowerCase()}',
                      style: TextStyle(color: Colors.blue.shade800),
                    );
                  },
                ),
              ),
              // Description (if any)
              provider.video.description != null
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(provider.video.description!),
                    )
                  : const SizedBox.shrink(),
              // Channel info
              InkWell(
                onTap: () {},
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: CachedNetworkImage(
                                imageUrl: provider.video.userImageUrl!,
                                fit: BoxFit.cover,
                                width: 48.0,
                                height: 48.0,
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  provider.video.username!,
                                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  AppLocalizations.of(context)!.nFollowers(provider.user.followerCount!.toInt()),
                                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ],
                        ),
                        provider.isThisMyVideo
                            ? const SizedBox.shrink()
                            : ElevatedButton(
                                onPressed: () async => await provider.followUser(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                ),
                                child: Text(
                                  provider.follow != null
                                      ? AppLocalizations.of(context)!.followingButton
                                      : AppLocalizations.of(context)!.followButton,
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
