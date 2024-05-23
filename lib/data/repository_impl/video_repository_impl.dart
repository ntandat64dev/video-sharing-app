import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/data/source/remote/video_api.dart';
import 'package:video_sharing_app/domain/entity/category.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';
import 'package:video_sharing_app/domain/enum/rating.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  VideoRepositoryImpl({
    required PreferencesService pref,
    required VideoApi videoApi,
  })  : _prefs = pref,
        _videoApi = videoApi;

  late final PreferencesService _prefs;
  late final VideoApi _videoApi;

  @override
  Future<Video?> getVideoById(String videoId) async {
    try {
      return await _videoApi.getVideoById(videoId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Video?> uploadVideo({
    required String videoPath,
    required String thumbnailPath,
    required Video video,
  }) async {
    try {
      video.userId = _prefs.getUserId();
      return await _videoApi.postVideo(
        videoLocalPath: videoPath,
        thumbnailLocalPath: thumbnailPath,
        video: video,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Video?> updateVideo({
    String? thumbnailPath,
    required Video video,
  }) async {
    try {
      return await _videoApi.updateVideo(
        thumbnailLocalPath: thumbnailPath,
        video: video,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> deleteVideoById(String videoId) async {
    try {
      await _videoApi.deleteVideo(videoId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<PageResponse<Video>> getVideosByCategoryAll([Pageable? pageable]) async {
    try {
      return await _videoApi.getVideoByCategoryAll(pageable ?? Pageable());
    } catch (e) {
      return PageResponse.empty();
    }
  }

  @override
  Future<PageResponse<Video>> getMyVideos([Pageable? pageable]) async {
    try {
      return await _videoApi.getMyVideos(pageable ?? Pageable());
    } catch (e) {
      return PageResponse.empty();
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
  Future<PageResponse<Video>> getRelatedVideos(String videoId, [Pageable? pageable]) async {
    try {
      return await _videoApi.getRelatedVideos(videoId, pageable ?? Pageable());
    } catch (e) {
      return PageResponse.empty();
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

  @override
  Future<PageResponse<Video>> getFollowingVideos([Pageable? pageable]) async {
    try {
      return await _videoApi.getFollowingVideos(pageable ?? Pageable());
    } catch (e) {
      return PageResponse.empty();
    }
  }
}
