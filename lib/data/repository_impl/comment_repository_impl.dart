import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/data/source/remote/comment_api.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/comment_rating.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/enum/rating.dart';
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
  Future<Comment?> postComment(Comment comment) async {
    try {
      comment.authorId = _prefs.getUserId();
      return await _commentApi.postComment(comment);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> deleteById(String commentId) async {
    try {
      await _commentApi.deleteCommentById(commentId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Comment?> getCommentById(String commentId) async {
    try {
      return await _commentApi.getCommentById(commentId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<PageResponse<Comment>> getCommentsByVideoId(String videoId, [Pageable? pageable]) async {
    try {
      return await _commentApi.getCommentsByVideoId(videoId, pageable ?? Pageable());
    } catch (e) {
      return PageResponse.empty();
    }
  }

  @override
  Future<PageResponse<Comment>> getRepliesByCommentId(String commentId, [Pageable? pageable]) async {
    try {
      return await _commentApi.getRepliesByCommentId(commentId, pageable ?? Pageable());
    } catch (e) {
      return PageResponse.empty();
    }
  }

  @override
  Future<CommentRating?> rateComment({required String commentId, required Rating rating}) async {
    try {
      return await _commentApi.postCommentRating(commentId: commentId, rating: rating.name);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<CommentRating?> getCommentRating(String commentId) async {
    try {
      return await _commentApi.getCommentRating(commentId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<PageResponse<CommentRating>> getAllCommentRatingsOfVideo(String videoId) async {
    try {
      return await _commentApi.getCommentRatingsOfVideo(videoId, null);
    } catch (e) {
      return PageResponse.empty();
    }
  }
}
