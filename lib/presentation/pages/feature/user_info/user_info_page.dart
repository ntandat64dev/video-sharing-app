import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/entity/follow.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/entity/user.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/repository/follow_repository.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';
import 'package:video_sharing_app/presentation/components/app_bar_actions.dart';
import 'package:video_sharing_app/presentation/components/video_card.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key, required this.userId});

  final String userId;

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  static const pageSize = 5;

  final userRepository = getIt<UserRepository>();
  final followRepository = getIt<FollowRepository>();
  final videoRepository = getIt<VideoRepository>();

  PagingController<int, Video>? pagingController = PagingController(firstPageKey: 0);
  final refreshController = RefreshController(initialRefresh: false);

  late User user;
  late Follow? follow;
  bool isInitialized = false;
  bool changedFollow = false;

  @override
  void initState() {
    super.initState();
    pagingController!.addPageRequestListener(fetchPage);

    Future.wait([
      userRepository.getUserInfo(userId: widget.userId),
      followRepository.getFollowFor(widget.userId),
    ]).then((value) {
      if (value.length != 2) return;
      setState(() {
        user = value[0] as User;
        follow = value[1] as Follow?;
        isInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    pagingController!.dispose();
    pagingController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.pop(context, changedFollow);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context, changedFollow),
            icon: const Icon(CupertinoIcons.arrow_left),
          ),
          actions: const [
            SearchButton(),
            MoreButon(),
          ],
        ),
        body: SafeArea(
          child: !isInitialized
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  width: double.infinity,
                  child: DefaultTabController(
                    length: 4,
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 8.0),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: CachedNetworkImage(
                                  imageUrl: user.thumbnails[Thumbnail.kDefault]!.url,
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              Text(
                                user.username,
                                style: const TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(
                                      width: 80.0,
                                      child: Column(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.n(user.followerCount!.toInt()),
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(AppLocalizations.of(context)!.followers),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12.0, right: 20.0),
                                      child: Container(
                                        color: Theme.of(context).colorScheme.outlineVariant.withAlpha(200),
                                        height: 16.0,
                                        width: 1.0,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.n(user.videoCount!.toInt()),
                                          style: const TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(AppLocalizations.of(context)!.videos),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12.0, left: 20.0),
                                      child: Container(
                                        color: Theme.of(context).colorScheme.outlineVariant.withAlpha(200),
                                        height: 16.0,
                                        width: 1.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 80.0,
                                      child: Column(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.n(user.viewCount!.toInt()),
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(AppLocalizations.of(context)!.views),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              follow != null
                                  ? SizedBox(
                                      width: 150.0,
                                      child: TextButton(
                                        onPressed: () async {
                                          final isSuccess = await followRepository.unFollow(follow!.id!);
                                          if (!isSuccess) return;
                                          final updatedUser = await userRepository.getUserInfo(userId: user.id);
                                          if (updatedUser == null) return;
                                          setState(() {
                                            user = updatedUser;
                                            follow = null;
                                            changedFollow = true;
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Theme.of(context).colorScheme.surface,
                                          foregroundColor: Theme.of(context).colorScheme.onSurface,
                                          elevation: 8.0,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Theme.of(context).colorScheme.outlineVariant.withAlpha(100),
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(100.0),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 4.0),
                                          child: Text(
                                            AppLocalizations.of(context)!.followingButton,
                                            style: const TextStyle(fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      width: 150.0,
                                      child: TextButton(
                                        onPressed: () async {
                                          final postFollow = Follow.post(
                                            userId: user.id,
                                            followerId: userRepository.getMyId(),
                                          );
                                          final updatedFollow = await followRepository.follow(postFollow);
                                          final updatedUser = await userRepository.getUserInfo(userId: user.id);
                                          if (updatedUser == null) return;
                                          setState(() {
                                            user = updatedUser;
                                            follow = updatedFollow;
                                            changedFollow = true;
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Theme.of(context).colorScheme.primary,
                                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                          elevation: 8.0,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Theme.of(context).colorScheme.primary,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(100.0),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 4.0),
                                          child: Text(
                                            AppLocalizations.of(context)!.followButton,
                                            style: const TextStyle(fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                              user.bio == null || user.bio!.isEmpty
                                  ? const SizedBox.shrink()
                                  : const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                                      child: Text(
                                        'Don\'t take life to seriously. Giving you all a bit of laughter. Reported vids',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                              const SizedBox(height: 16.0),
                            ],
                          ),
                        ),
                        const SliverAppBar(
                          titleSpacing: 0.0,
                          automaticallyImplyLeading: false,
                          pinned: true,
                          toolbarHeight: kToolbarHeight - 8.0,
                          title: TabBar(
                            tabs: [
                              Tab(icon: Icon(CupertinoIcons.home)),
                              Tab(icon: Icon(CupertinoIcons.play)),
                              Tab(icon: Icon(CupertinoIcons.list_bullet)),
                              Tab(icon: Icon(CupertinoIcons.person)),
                            ],
                          ),
                        ),
                        PagedSliverList<int, Video>(
                          pagingController: pagingController!,
                          builderDelegate: PagedChildBuilderDelegate(
                            itemBuilder: (context, item, index) {
                              return VideoCard(video: item);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  void fetchPage(int page) async {
    final pageResponse = await videoRepository.getVideosByUserId(widget.userId, Pageable(page: page, size: pageSize));
    final isLastPage = pageResponse.items.length < pageSize;
    if (isLastPage) {
      pagingController?.appendLastPage(pageResponse.items);
    } else {
      final nextPage = page + 1;
      pagingController?.appendPage(pageResponse.items, nextPage);
    }
  }
}
