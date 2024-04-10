import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/data/source/local/preferences_service_impl.dart';
import 'package:video_sharing_app/data/source/remote/api.dart';
import 'package:video_sharing_app/data/source/remote/api_impl.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  final PreferencesService _prefs = PreferencesServiceImpl.getInstance();
  final Api _api = ApiImpl();

  @override
  Future<List<Video>> getRecommendVideos() => _api.fetchRecommendVideos(userId: _prefs.getUser()!.id);

  @override
  Future<Video?> getVideoById({required String videoId}) => _api.fetchVideoById(videoId: videoId);

  @override
  Future<Video> uploadVideo({required String videoPath, required String title, required String description}) =>
      _api.uploadVideo(videoPath: videoPath, title: title, description: description);

  @override
  Future<bool> viewVideo({required String videoId}) => _api.viewVideo(videoId: videoId, userId: _prefs.getUser()!.id);

  @override
  Future<VideoRating> getVideoRating({required String videoId}) => _api.fetchVideoRating(videoId: videoId, userId: _prefs.getUser()!.id);

  @override
  Future<List<Video>> getRelatedVideos({required String videoId}) => _api.fetchRelatedVideos(videoId: videoId, userId: _prefs.getUser()!.id);

  @override
  Future<Comment?> getMostLikeComment({required String videoId}) => _api.fetchMostLikeComment(videoId: videoId);

  @override
  Future<bool> rateVideo({required String videoId, required Rating rating}) =>
      _api.rateVideo(videoId: videoId, userId: _prefs.getUser()!.id, rating: rating.name);
}
