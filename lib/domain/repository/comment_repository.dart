import 'package:video_sharing_app/domain/entity/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> getCommentsByVideoId({required String videoId});

  Future<Comment> postComment({required Comment comment});
}
