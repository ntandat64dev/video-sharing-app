import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';

abstract class VideoRepository {
  Future<List<Video>> getRecommendVideos();

  Future<Video?> getVideoById({required String videoId});

  Future<Video> uploadVideo({required String videoPath, required String title, required String description});

  Future<bool> viewVideo({required String videoId});

  Future<VideoRating> getVideoRating({required String videoId});

  Future<List<Video>> getRelatedVideos({required String videoId});

  Future<Comment?> getMostLikeComment({required String videoId});

  Future<bool> rateVideo({required String videoId, required Rating rating});
}
