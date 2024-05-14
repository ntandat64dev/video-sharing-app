import 'package:video_sharing_app/domain/entity/category.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';

abstract class VideoRepository {
  Future<Video?> getVideoById(String videoId);

  Future<Video?> uploadVideo({
    required String videoPath,
    required String thumbnailPath,
    required Video video,
  });

  Future<Video?> updateVideo({
    String? thumbnailPath,
    required Video video,
  });

  Future<bool> deleteVideoById(String videoId);

  Future<List<Video>> getVideosByCategoryAll();

  Future<List<Video>> getMyVideos();

  Future<VideoRating?> getVideoRating(String videoId);

  Future<VideoRating?> rateVideo({required String videoId, required Rating rating});

  Future<List<Video>> getRelatedVideos(String videoId);

  Future<List<String>> getVideoCategories();

  Future<List<Category>> getAllCategories();
}
