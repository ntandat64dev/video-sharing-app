import 'dart:math';

import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/comment_rating.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/enum/rating.dart';
import 'package:video_sharing_app/domain/repository/comment_repository.dart';

class FakeCommentRepositoryImpl implements CommentRepository {
  FakeCommentRepositoryImpl() {
    for (int i = 0; i < 10; i++) {
      final comment = Comment(
        id: Random().nextInt(16).toRadixString(16),
        videoId: '12345678',
        authorId: Random().nextInt(16).toRadixString(16),
        authorDisplayName: 'Fake User',
        authorProfileImageUrl:
            'https://ui-avatars.com/api/?name=Fake+User&size=500&background=0D8ABC&color=fff&rouded=true&bold=true',
        text: 'Comment $i',
        parentId: i % 2 == 0 ? '123' : null,
        publishedAt: DateTime.now(),
        updatedAt: null,
        likeCount: BigInt.zero,
        dislikeCount: BigInt.zero,
        replyCount: BigInt.from(3),
      );
      comments.add(comment);
    }
  }

  final comments = <Comment>[];

  @override
  Future<Comment?> postComment(Comment comment) async {
    return comments[0];
  }

  @override
  Future<bool> deleteById(String commentId) async {
    return true;
  }

  @override
  Future<Comment?> getCommentById(String commentId) async {
    return comments[0];
  }

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
  Future<PageResponse<Comment>> getRepliesByCommentId(String commentId, [Pageable? pageable]) async {
    return PageResponse(
      pageNumber: 0,
      pageSize: comments.length,
      totalElements: comments.length,
      totalPages: 1,
      items: comments,
    );
  }

  @override
  Future<CommentRating?> rateComment({required String commentId, required Rating rating}) async {
    return CommentRating(
      commentId: commentId,
      userId: Random().nextInt(16).toRadixString(16),
      rating: Rating.like,
      publishedAt: DateTime.now(),
    );
  }

  @override
  Future<CommentRating?> getCommentRating(String commentId) async {
    return CommentRating(
      commentId: commentId,
      userId: Random().nextInt(16).toRadixString(16),
      rating: Rating.like,
      publishedAt: DateTime.now(),
    );
  }

  @override
  Future<PageResponse<CommentRating>> getAllCommentRatingsOfVideo(String videoIdo) async {
    return PageResponse(
      pageNumber: 0,
      pageSize: 1,
      totalElements: 1,
      totalPages: 1,
      items: [
        CommentRating(
          commentId: '123456',
          userId: Random().nextInt(16).toRadixString(16),
          rating: Rating.like,
          publishedAt: DateTime.now(),
        )
      ],
    );
  }
}
