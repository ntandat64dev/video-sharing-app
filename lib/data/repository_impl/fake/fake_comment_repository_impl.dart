import 'dart:math';

import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/repository/comment_repository.dart';

class FakeCommentRepositoryImpl implements CommentRepository {
  FakeCommentRepositoryImpl() {
    final comments = <Comment>[];
    for (int i = 0; i < 10; i++) {
      final comment = Comment(
        id: Random().nextInt(16).toRadixString(16),
        videoId: '12345678',
        authorId: Random().nextInt(16).toRadixString(16),
        authorDisplayName: 'Fake User',
        authorProfileImageUrl:
            'https://ui-avatars.com/api/?name=Fake+User&size=500&background=0D8ABC&color=fff&rouded=true&bold=true',
        text: 'Comment $i',
        parentId: null,
        publishedAt: DateTime.now(),
        updatedAt: null,
        likeCount: BigInt.zero,
        dislikeCount: BigInt.zero,
        replyCount: BigInt.zero,
      );
      comments.add(comment);
    }
  }

  final comments = <Comment>[];

  @override
  Future<PageResponse<Comment>> getCommentsByVideoId(String videoId, [Pageable? pageable]) async {
    return PageResponse(
      pageNumber: 0,
      pageSize: comments.length,
      totalElements: comments.length,
      totalPages: 1,
      items: comments,
    );
  }

  @override
  Future<Comment?> postComment(Comment comment) async {
    return comments[0];
  }
}
