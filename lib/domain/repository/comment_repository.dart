import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';

abstract class CommentRepository {
  Future<PageResponse<Comment>> getCommentsByVideoId(String videoId, [Pageable? pageable]);

  Future<Comment?> postComment(Comment comment);
}
