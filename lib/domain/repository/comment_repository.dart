import 'package:video_sharing_app/domain/entity/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> getCommentsByVideoId(String videoId);

  Future<Comment?> postComment(Comment comment);
}
