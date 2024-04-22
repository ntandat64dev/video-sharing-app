import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/data/source/local/preferences_service_impl.dart';
import 'package:video_sharing_app/data/source/remote/api.dart';
import 'package:video_sharing_app/data/source/remote/api_impl.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/repository/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final PreferencesService _prefs = PreferencesServiceImpl.getInstance();
  final Api _api = ApiImpl();

  @override
  Future<List<Comment>> getCommentsByVideoId({required String videoId}) => _api.getCommentsByVideoId(videoId: videoId);

  @override
  Future<Comment> postComment({required Comment comment}) {
    comment.authorId = _prefs.getUser()!.id;
    return _api.postComment(comment: comment);
  }
}
