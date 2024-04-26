import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';

abstract class VideoRepository {
  Future<Video?> getVideoById({required String videoId});

  Future<Video> uploadVideo({required String videoPath, required Video video});

  Future<List<Video>> getVideosByAllCategories();

  Future<VideoRating> getVideoRating({required String videoId});

  Future<VideoRating> rateVideo({required String videoId, required Rating rating});

  Future<List<Video>> getRelatedVideos({required String videoId});

  Future<List<String>> getVideoCategories();
}
