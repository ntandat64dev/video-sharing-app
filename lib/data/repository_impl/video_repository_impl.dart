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
  Future<Video?> getVideoById({required String videoId}) => _api.getVideoById(videoId: videoId);

  @override
  Future<Video> uploadVideo({required String videoPath, required Video video}) => _api.postVideo(videoLocalPath: videoPath, video: video);

  @override
  Future<List<Video>> getVideosByAllCategories() => _api.getVideosByAllCategories(userId: _prefs.getUser()!.id);

  @override
  Future<VideoRating> getVideoRating({required String videoId}) => _api.getVideoRating(videoId: videoId, userId: _prefs.getUser()!.id);

  @override
  Future<bool> rateVideo({required String videoId, required Rating rating}) =>
      _api.postVideoRating(videoId: videoId, userId: _prefs.getUser()!.id, rating: rating.name);

  @override
  Future<List<Video>> getRelatedVideos({required String videoId}) => _api.getRelatedVideos(videoId: videoId, userId: _prefs.getUser()!.id);

  @override
  Future<List<String>> getVideoCategories() => _api.getVideoCategories(userId: _prefs.getUser()!.id);

  @override
  Future<Comment?> getTopLevelComment({required String videoId}) => _api.getTopLevelComment(videoId: videoId);
}
