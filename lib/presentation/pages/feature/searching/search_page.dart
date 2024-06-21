import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/entity/follow.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/entity/user.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/repository/follow_repository.dart';
import 'package:video_sharing_app/domain/repository/search_repository.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';
import 'package:video_sharing_app/presentation/components/bottom_sheet.dart';
import 'package:video_sharing_app/presentation/components/custom_text_field.dart';
import 'package:video_sharing_app/presentation/components/video_card.dart';
import 'package:video_sharing_app/presentation/pages/feature/searching/search_not_found_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/user_info/user_info_page.dart';
import 'package:video_sharing_app/presentation/shared/asset.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

enum SortBy { relevance, uploadDate, viewCount }

extension on SortBy {
  String get displayName {
    switch (this) {
      case SortBy.relevance:
        return 'Relevance';
      case SortBy.uploadDate:
        return 'Upload date';
      case SortBy.viewCount:
        return 'View count';
    }
  }

  String get apiString {
    switch (this) {
      case SortBy.relevance:
        return 'RELEVANCE';
      case SortBy.uploadDate:
        return 'UPLOAD_DATE';
      case SortBy.viewCount:
        return 'VIEW_COUNT';
    }
  }
}

enum Type { all, video, user, playlist }

extension on Type {
  String get displayName {
    switch (this) {
      case Type.all:
        return 'All';
      case Type.video:
        return 'Video';
      case Type.user:
        return 'User';
      case Type.playlist:
        return 'Playlist';
    }
  }

  String get apiString {
    switch (this) {
      case Type.all:
        return 'ALL';
      case Type.video:
        return 'VIDEO';
      case Type.user:
        return 'USER';
      case Type.playlist:
        return 'PLAYLIST';
    }
  }
}

class _SearchPageState extends State<SearchPage> {
  static const pageSize = 10;

  final userRepository = getIt<UserRepository>();
  final followRepository = getIt<FollowRepository>();
  final searchRepository = getIt<SearchRepository>();

  final textController = TextEditingController();

  PagingController<int, dynamic>? pagingController = PagingController(firstPageKey: 0);
  final FocusNode textFieldFocusNode = FocusNode();
  var sortBy = SortBy.relevance;
  var type = Type.all;
  var showSuggestions = true;
  var firstSubmitted = false;

  @override
  void initState() {
    super.initState();
    pagingController!.addPageRequestListener(fetchPage);
    textFieldFocusNode.addListener(() {
      if (textFieldFocusNode.hasFocus) {
        setState(() => showSuggestions = true);
      }
    });
  }

  @override
  void dispose() {
    pagingController!.dispose();
    pagingController = null;
    textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 4.0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(CupertinoIcons.arrow_left),
          ),
          title: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CustomTextField(
              controller: textController,
              autoFocus: true,
              focusNode: textFieldFocusNode,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if (!firstSubmitted) setState(() => firstSubmitted = true);
                if (showSuggestions) setState(() => showSuggestions = false);
                pagingController!.refresh();
              },
              contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
              hintText: AppLocalizations.of(context)!.search,
              prefixIcon: const Icon(CupertinoIcons.search),
              suffixIcon: IconButton(
                onPressed: () => showFilterBottomSheet(
                  onApplyFilter: () {
                    Navigator.pop(context);
                    if (!showSuggestions) pagingController!.refresh();
                  },
                ),
                icon: const Icon(Icons.tune),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            !firstSubmitted
                ? const SizedBox.shrink()
                : PagedListView(
                    pagingController: pagingController!,
                    builderDelegate: PagedChildBuilderDelegate(
                      noItemsFoundIndicatorBuilder: (context) => const SearchNotFound(),
                      itemBuilder: (context, item, index) {
                        if (item.runtimeType == Video) {
                          return VideoCard(video: item as Video);
                        } else {
                          return userItem(item as User);
                        }
                      },
                    ),
                  ),
            showSuggestions ? Container(color: Theme.of(context).colorScheme.background) : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  void fetchPage(int page) async {
    final pageResponse = await searchRepository.search(
      keyword: textController.text,
      sort: sortBy.apiString,
      type: type.apiString,
      pageable: Pageable(page: page, size: pageSize),
    );

    final isLastPage = pageResponse.items.length < pageSize;
    if (isLastPage) {
      pagingController?.appendLastPage(pageResponse.items);
    } else {
      final nextPage = page + 1;
      pagingController?.appendPage(pageResponse.items, nextPage);
    }
  }

  void showFilterBottomSheet({required void Function() onApplyFilter}) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.0),
            topRight: Radius.circular(32.0),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: 280.0,
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 12.0),
                    Container(
                      width: 38.0,
                      height: 4.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            AppLocalizations.of(context)!.titleSearchFilter,
                            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          height: 0.0,
                          thickness: 0.5,
                          indent: 16.0,
                          endIndent: 16.0,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                filterItem(
                                  onTap: () async {
                                    final value = await showSortByFilterDialog();
                                    if (value != null) setState(() => sortBy = value);
                                  },
                                  title: AppLocalizations.of(context)!.searchSortBy,
                                  value: sortBy.displayName,
                                ),
                                filterItem(
                                  onTap: () async {
                                    final value = await showTypeFilterDialog();
                                    if (value != null) setState(() => type = value);
                                  },
                                  title: AppLocalizations.of(context)!.type,
                                  value: type.displayName,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Reset button
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: bottomSheetNegativeButton(
                                context: context,
                                text: AppLocalizations.of(context)!.reset,
                                onPressed: () {
                                  setState(() {
                                    sortBy = SortBy.relevance;
                                    type = Type.video;
                                  });
                                },
                              ),
                            ),
                          ),
                          // Apply button
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: bottomSheetConfirmButton(
                                context: context,
                                onPressed: onApplyFilter,
                                text: AppLocalizations.of(context)!.apply,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );

  Widget filterItem({
    required void Function() onTap,
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
            Text(title, style: const TextStyle(fontSize: 16.0)),
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
                                  fontWeight: FontWeight.w500,
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

  Future<SortBy?> showSortByFilterDialog() => showDialog(
        context: context,
        builder: (context) {
          var currentSortBy = sortBy;
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.surface,
                surfaceTintColor: Colors.transparent,
                title: Text(AppLocalizations.of(context)!.searchSortBy),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                contentPadding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
                actionsPadding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, currentSortBy),
                    child: Text(
                      AppLocalizations.of(context)!.ok,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => setState(() => currentSortBy = SortBy.relevance),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 26.0),
                        title: Text(SortBy.relevance.displayName),
                        trailing: currentSortBy == SortBy.relevance ? const Icon(Icons.check_rounded) : null,
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() => currentSortBy = SortBy.uploadDate),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 26.0),
                        title: Text(SortBy.uploadDate.displayName),
                        trailing: currentSortBy == SortBy.uploadDate ? const Icon(Icons.check_rounded) : null,
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() => currentSortBy = SortBy.viewCount),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 26.0),
                        title: Text(SortBy.viewCount.displayName),
                        trailing: currentSortBy == SortBy.viewCount ? const Icon(Icons.check_rounded) : null,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );

  Future<Type?> showTypeFilterDialog() => showDialog(
        context: context,
        builder: (context) {
          var currentType = type;
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.surface,
                surfaceTintColor: Colors.transparent,
                title: Text(AppLocalizations.of(context)!.type),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                ),
                contentPadding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
                actionsPadding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, currentType),
                    child: Text(
                      AppLocalizations.of(context)!.ok,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => setState(() => currentType = Type.all),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 26.0),
                        title: Text(Type.all.displayName),
                        trailing: currentType == Type.all ? const Icon(Icons.check_rounded) : null,
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() => currentType = Type.video),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 26.0),
                        title: Text(Type.video.displayName),
                        trailing: currentType == Type.video ? const Icon(Icons.check_rounded) : null,
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() => currentType = Type.user),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 26.0),
                        title: Text(Type.user.displayName),
                        trailing: currentType == Type.user ? const Icon(Icons.check_rounded) : null,
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() => currentType = Type.playlist),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 26.0),
                        title: Text(Type.playlist.displayName),
                        trailing: currentType == Type.playlist ? const Icon(Icons.check_rounded) : null,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );

  Widget userItem(User user) => Material(
        color: Theme.of(context).colorScheme.background,
        child: LayoutBuilder(
          builder: (context, constraints) {
            var currentUser = user;
            return StatefulBuilder(
              builder: (context, setState) {
                refresh() async {
                  final freshUser = await userRepository.getUserInfo(userId: currentUser.id);
                  if (freshUser != null) {
                    setState(() => currentUser = freshUser);
                  }
                }

                return FutureBuilder(
                  future: followRepository.getFollowFor(currentUser.id),
                  builder: (context, snapshot) {
                    final follow = snapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          height: 1,
                          thickness: 0.3,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        InkWell(
                          onTap: () async {
                            final isChangedFollow = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UserInfoPage(userId: user.id)),
                            );

                            if (isChangedFollow) {
                              refresh();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 36.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(100.0),
                                          child: CachedNetworkImage(
                                            imageUrl: currentUser.thumbnails[Thumbnail.kDefault]!.url,
                                            fadeInDuration: const Duration(milliseconds: 300),
                                            fadeOutDuration: const Duration(milliseconds: 1),
                                            height: 80.0,
                                            width: 80.0,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Image.asset(
                                              Asset.placeholder,
                                              height: 80.0,
                                              width: 80.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              currentUser.username,
                                              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                            ),
                                            Text(AppLocalizations.of(context)!
                                                .nFollowers(currentUser.followerCount!.toInt())),
                                            const SizedBox(height: 8.0),
                                            userRepository.getMyId() == user.id
                                                ? const SizedBox.shrink()
                                                : SizedBox(
                                                    width: 120.0,
                                                    child: TextButton(
                                                      style: follow == null
                                                          ? TextButton.styleFrom(
                                                              elevation: 8.0,
                                                              backgroundColor:
                                                                  Theme.of(context).colorScheme.onBackground,
                                                              foregroundColor: Theme.of(context).colorScheme.background,
                                                            )
                                                          : TextButton.styleFrom(
                                                              elevation: 8.0,
                                                              shape: RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                  color: Theme.of(context)
                                                                      .colorScheme
                                                                      .outlineVariant
                                                                      .withAlpha(100),
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius: BorderRadius.circular(100.0),
                                                              ),
                                                              backgroundColor: Theme.of(context).colorScheme.surface,
                                                              foregroundColor: Theme.of(context).colorScheme.onSurface,
                                                            ),
                                                      onPressed: () async {
                                                        if (follow != null) {
                                                          final isSuccessful =
                                                              await followRepository.unFollow(follow.id!);
                                                          if (isSuccessful) await refresh();
                                                        } else {
                                                          final result = await followRepository.follow(
                                                            Follow.post(userId: currentUser.id, followerId: null),
                                                          );
                                                          if (result != null) await refresh();
                                                        }
                                                      },
                                                      child: Text(
                                                        follow == null
                                                            ? AppLocalizations.of(context)!.followButton
                                                            : AppLocalizations.of(context)!.followingButton,
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.more_vert, size: 20.0),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 0.0,
                          thickness: 0.3,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      );
}
