import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/data/source/remote/comment_api.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/repository/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final PreferencesService _prefs = PreferencesService.getInstance();
  late final CommentApi _commentApi;

  CommentRepositoryImpl() {
    final token = _prefs.getToken();
    if (token == null) throw Exception('Cannot instantiate CommentRepositoryImpl because token is null');

    _commentApi = CommentApi(token: token);
  }

  @override
  Future<List<Comment>> getCommentsByVideoId(String videoId) async {
    try {
      return await _commentApi.getCommentsByVideoId(videoId);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Comment?> postComment(Comment comment) async {
    try {
      comment.authorId = _prefs.getUserId();
      return _commentApi.postComment(comment);
    } catch (e) {
      return null;
    }
  }
}
