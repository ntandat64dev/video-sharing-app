import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/enum/rating.dart';
import 'package:video_sharing_app/domain/repository/comment_repository.dart';
import 'package:video_sharing_app/presentation/pages/feature/video_player/video_detail/component/comment_item.dart';
import 'package:video_sharing_app/presentation/pages/feature/video_player/video_detail/video_detail_provider.dart';

class ReplySheet extends StatefulWidget {
  const ReplySheet({
    super.key,
    required Comment comment,
    required void Function() onRepliesButtonClick,
    required void Function() hideMe,
  })  : _comment = comment,
        _onRepliesButtonClick = onRepliesButtonClick,
        _hideMe = hideMe;

  final Comment _comment;
  final void Function() _onRepliesButtonClick;
  final void Function() _hideMe;

  @override
  State<ReplySheet> createState() => _ReplySheetState();
}

class _ReplySheetState extends State<ReplySheet> {
  static const commentPageSize = 10;

  final commentRepository = getIt<CommentRepository>();
  final commentController = TextEditingController();
  var isCommentFocus = false;

  PagingController<int, Comment>? commentPagingController = PagingController(firstPageKey: 0);

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
    return Scaffold(
      body: Consumer<VideoDetailProvider>(
        builder: (context, provider, child) {
          if (provider.shouldUpdateReplies) {
            commentPagingController!.refresh();
            provider.shouldUpdateReplies = false;
          }
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: FutureBuilder(
                  future: commentRepository.getCommentById(widget._comment.id!),
                  builder: (context, snapshot) {
                    final Comment? freshComment = snapshot.data;
                    final comment = freshComment ?? widget._comment;
                    var rating = provider.commentRatings.where((e) => e.commentId == comment.id).firstOrNull;
                    return CommentItem.isReply(
                      comment: comment,
                      rating: rating != null ? rating.rating : Rating.none,
                      onReplyButtonClicked: widget._onRepliesButtonClick,
                      onDelete: () async {
                        final isDeleted = await provider.deleteComment(comment);
                        if (isDeleted) widget._hideMe();
                        return isDeleted;
                      },
                    );
                  },
                ),
              ),
              PagedSliverList<int, Comment>(
                pagingController: commentPagingController!,
                builderDelegate: PagedChildBuilderDelegate(
                  noItemsFoundIndicatorBuilder: (context) => const SizedBox.shrink(),
                  itemBuilder: (context, item, index) {
                    var rating = provider.commentRatings.where((e) => e.commentId == item.id).firstOrNull;
                    return CommentItem.reply(
                      rating: rating != null ? rating.rating : Rating.none,
                      comment: item,
                      onDelete: () async {
                        return await provider.deleteComment(item);
                      },
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void fetchCommentPage(int page) async {
    final pageResponse = await commentRepository.getRepliesByCommentId(
      widget._comment.id!,
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
}
