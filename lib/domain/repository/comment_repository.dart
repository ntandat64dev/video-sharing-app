import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/comment_rating.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/enum/rating.dart';

abstract class CommentRepository {
  Future<Comment?> postComment(Comment comment);

  Future<bool> deleteById(String commentId);

  Future<Comment?> getCommentById(String commentId);

  Future<PageResponse<Comment>> getCommentsByVideoId(String videoId, [Pageable? pageable]);

  Future<PageResponse<Comment>> getRepliesByCommentId(String commentId, [Pageable? pageable]);

  Future<CommentRating?> rateComment({required String commentId, required Rating rating});

  Future<CommentRating?> getCommentRating(String commentId);

  Future<PageResponse<CommentRating>> getAllCommentRatingsOfVideo(String videoId);
}
