import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/data/source/remote/video_api.dart';
import 'package:video_sharing_app/domain/entity/category.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  final PreferencesService _prefs = PreferencesService.getInstance();
  late final VideoApi _videoApi;

  VideoRepositoryImpl() {
    final token = _prefs.getToken();
    if (token == null) throw Exception('Cannot instantiate VideoRepositoryImpl because token is null');

    _videoApi = VideoApi(token: token);
  }

  @override
  Future<Video?> getVideoById(String videoId) async {
    try {
      return await _videoApi.getVideoById(videoId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Video?> uploadVideo({required String videoPath, required Video video}) async {
    try {
      video.userId = _prefs.getUserId();
      return _videoApi.postVideo(videoLocalPath: videoPath, video: video);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Video>> getVideosByCategoryAll() async {
    try {
      return await _videoApi.getVideoByCategoryAll();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<VideoRating?> getVideoRating(String videoId) async {
    try {
      return await _videoApi.getVideoRating(videoId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<VideoRating?> rateVideo({required String videoId, required Rating rating}) async {
    try {
      return await _videoApi.postVideoRating(videoId: videoId, rating: rating.name);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Video>> getRelatedVideos(String videoId) async {
    try {
      return await _videoApi.getRelatedVideos(videoId);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<String>> getVideoCategories() async {
    try {
      return await _videoApi.getVideoCategories();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Category>> getAllCategories() async {
    try {
      return await _videoApi.getAllCategories();
    } catch (e) {
      return [];
    }
  }
}
