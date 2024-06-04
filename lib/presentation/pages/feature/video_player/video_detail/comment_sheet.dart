import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/enum/rating.dart';
import 'package:video_sharing_app/domain/repository/comment_repository.dart';
import 'package:video_sharing_app/presentation/components/custom_text_field.dart';
import 'package:video_sharing_app/presentation/components/filter_item.dart';
import 'package:video_sharing_app/presentation/pages/feature/video_player/video_detail/component/comment_item.dart';
import 'package:video_sharing_app/presentation/pages/feature/video_player/video_detail/reply_sheet.dart';
import 'package:video_sharing_app/presentation/pages/feature/video_player/video_detail/video_detail_provider.dart';

class CommentSheet extends StatefulWidget {
  const CommentSheet({
    super.key,
    required double snapPoint,
    required DraggableScrollableController sheetController,
    required void Function(bool showingReplies) showingReplies,
  })  : _snapPoint = snapPoint,
        _sheetController = sheetController,
        _showingReplies = showingReplies;

  final double _snapPoint;
  final DraggableScrollableController _sheetController;
  final void Function(bool showingReplies) _showingReplies;

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> with TickerProviderStateMixin {
  static const commentPageSize = 10;

  final commentRepository = getIt<CommentRepository>();
  final commentController = TextEditingController();
  var isCommentFocus = false;
  final focusNode = FocusNode();

  PagingController<int, Comment>? commentPagingController = PagingController(firstPageKey: 0);

  var opacity = 0.0;
  var titleOffset = const Offset(0.2, 0.0);
  var bodyOffset = const Offset(1.0, 0.0);

  Comment? replyComment;

  @override
  void initState() {
    super.initState();
    commentPagingController!.addPageRequestListener(fetchCommentPage);
  }

  @override
  void dispose() {
    commentPagingController!.dispose();
    commentPagingController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (replyComment != null) {
          // If replies sheet is showing.
          hideRepliesSheet();
          return;
        }
      },
      child: DraggableScrollableSheet(
        controller: widget._sheetController,
        expand: true,
        snap: true,
        snapSizes: [widget._snapPoint],
        initialChildSize: 0.0,
        minChildSize: 0.0,
        maxChildSize: 1.0,
        builder: (context, scrollController) {
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                // Header.
                SliverAppBar(
                  toolbarHeight: 72.0,
                  titleSpacing: 0.0,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  title: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        Container(
                          width: 42.0,
                          height: 4.0,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  // Comment title.
                                  AnimatedOpacity(
                                    opacity: 1 - opacity,
                                    duration: Durations.short4,
                                    child: Text(
                                      AppLocalizations.of(context)!.comments,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                                    ),
                                  ),
                                  // Replies title.
                                  AnimatedSlide(
                                    offset: titleOffset,
                                    duration: Durations.medium1,
                                    child: AnimatedOpacity(
                                      opacity: opacity,
                                      duration: Durations.medium1,
                                      child: Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          InkWell(
                                            borderRadius: BorderRadius.circular(100.0),
                                            onTap: hideRepliesSheet,
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(CupertinoIcons.arrow_left),
                                            ),
                                          ),
                                          const SizedBox(width: 12.0),
                                          Text(
                                            AppLocalizations.of(context)!.replies,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Close button.
                              InkWell(
                                borderRadius: BorderRadius.circular(100.0),
                                onTap: () async {
                                  await widget._sheetController.animateTo(
                                    0.0,
                                    duration: Durations.medium1,
                                    curve: Curves.linearToEaseOut,
                                  );
                                  hideRepliesSheet();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.close_rounded),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1.0),
                    child: AnimatedOpacity(
                      opacity: opacity,
                      duration: Durations.medium1,
                      child: Divider(
                        height: 1.0,
                        thickness: 0.5,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                  ),
                ),
                // Body.
                SliverFillRemaining(
                  child: Consumer<VideoDetailProvider>(
                    builder: (context, provider, child) {
                      if (!provider.shouldLoadComments) return const Center(child: CircularProgressIndicator());
                      if (provider.shouldUpdateComments) {
                        commentPagingController!.refresh();
                        provider.shouldUpdateComments = false;
                      }
                      return Stack(
                        children: [
                          // Comments
                          CustomScrollView(
                            slivers: [
                              SliverAppBar(
                                snap: true,
                                automaticallyImplyLeading: false,
                                titleSpacing: 0.0,
                                floating: true,
                                // Filters.
                                title: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      FilterItem(
                                        onSelected: (value) {},
                                        text: AppLocalizations.of(context)!.filterTop,
                                        isActive: true,
                                      ),
                                      const SizedBox(width: 8.0),
                                      FilterItem(
                                        onSelected: (value) {},
                                        text: AppLocalizations.of(context)!.filterNewest,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Divider.
                              SliverAppBar(
                                toolbarHeight: 1.0,
                                automaticallyImplyLeading: false,
                                titleSpacing: 0.0,
                                pinned: true,
                                title: Divider(
                                  height: 1.0,
                                  thickness: 0.5,
                                  color: Theme.of(context).colorScheme.outlineVariant,
                                ),
                              ),
                              // Comments list.
                              PagedSliverList<int, Comment>(
                                pagingController: commentPagingController!,
                                builderDelegate: PagedChildBuilderDelegate(
                                  // No items layout.
                                  noItemsFoundIndicatorBuilder: (context) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.noComments,
                                          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(AppLocalizations.of(context)!.saySomething),
                                      ],
                                    );
                                  },
                                  itemBuilder: (context, item, index) {
                                    var rating =
                                        provider.commentRatings.where((e) => e.commentId == item.id).firstOrNull;
                                    return CommentItem(
                                      comment: item,
                                      rating: rating != null ? rating.rating : Rating.none,
                                      onReplyButtonClicked: () {
                                        showRepliesSheet(item);
                                        FocusScope.of(context).requestFocus(focusNode);
                                      },
                                      onShowRepliesClicked: () => showRepliesSheet(item),
                                      onDelete: () async {
                                        return await provider.deleteComment(item);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          // Replies.
                          AnimatedSlide(
                            offset: bodyOffset,
                            duration: Durations.medium2,
                            curve: Curves.linearToEaseOut,
                            child: replyComment == null
                                ? const Center(child: CircularProgressIndicator())
                                : ReplySheet(
                                    onRepliesButtonClick: () => FocusScope.of(context).requestFocus(focusNode),
                                    comment: replyComment!,
                                    hideMe: hideRepliesSheet,
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Consumer<VideoDetailProvider>(
              builder: (context, provider, child) {
                return Wrap(
                  children: [
                    Divider(
                      height: 1.0,
                      thickness: 0.5,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: CachedNetworkImage(
                          imageUrl: provider.video.userImageUrl!,
                          fit: BoxFit.cover,
                          width: 48.0,
                          height: 48.0,
                        ),
                      ),
                      title: CustomTextField(
                        controller: commentController,
                        focusNode: focusNode,
                        hintText: replyComment != null
                            ? AppLocalizations.of(context)!.hintAddReply
                            : AppLocalizations.of(context)!.hintAddComment,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        suffixIcon: IconButton(
                            onPressed: () async {
                              provider.sendComment(
                                Comment.post(
                                  videoId: provider.video.id!,
                                  text: commentController.text,
                                  parentId: replyComment?.id,
                                ),
                              );
                              setState(() {
                                FocusScope.of(context).requestFocus(FocusNode());
                                commentController.text = '';
                              });
                            },
                            icon: const Icon(Icons.send_rounded),
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    )
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  void fetchCommentPage(int page) async {
    final pageResponse = await commentRepository.getCommentsByVideoId(
      Provider.of<VideoDetailProvider>(context, listen: false).video.id!,
      Pageable(page: page, size: commentPageSize),
    );
    final isLastPage = pageResponse.items.length < commentPageSize;
    if (isLastPage) {
      commentPagingController?.appendLastPage(pageResponse.items);
    } else {
      final nextPage = page + 1;
      commentPagingController?.appendPage(pageResponse.items, nextPage);
    }
  }

  void showRepliesSheet(Comment replyComment) {
    setState(() {
      opacity = 1.0;
      titleOffset = Offset.zero;
      bodyOffset = Offset.zero;
      this.replyComment = replyComment;
      widget._showingReplies(true);
    });
  }

  void hideRepliesSheet() {
    setState(() {
      opacity = 0.0;
      titleOffset = const Offset(0.2, 0.0);
      bodyOffset = const Offset(1.0, 0.0);
      replyComment = null;
      widget._showingReplies(false);
    });

    // Hide soft keyboard if opened.
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
