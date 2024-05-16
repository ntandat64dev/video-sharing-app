import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/data/source/remote/comment_api.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/repository/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  CommentRepositoryImpl({
    required PreferencesService pref,
    required CommentApi commentApi,
  })  : _prefs = pref,
        _commentApi = commentApi;

  late final PreferencesService _prefs;
  late final CommentApi _commentApi;

  @override
  Future<PageResponse<Comment>> getCommentsByVideoId(String videoId, [Pageable? pageable]) async {
    try {
      return await _commentApi.getCommentsByVideoId(videoId, pageable ?? Pageable());
    } catch (e) {
      return PageResponse.empty();
    }
  }

  @override
  Future<Comment?> postComment(Comment comment) async {
    try {
      comment.authorId = _prefs.getUserId();
      return await _commentApi.postComment(comment);
    } catch (e) {
      return null;
    }
  }
}
