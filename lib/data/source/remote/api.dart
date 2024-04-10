import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/user.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';

abstract class Api {
  Future<User?> signUp({required String email, required String password});

  Future<User?> signIn({required String email, required String password});

  Future<List<Video>> fetchRecommendVideos({required String userId});

  Future<Video?> fetchVideoById({required String videoId});

  Future<Video> uploadVideo({required String videoPath, required String title, required String description});

  Future<List<String>> fetchHashtags({required String userId});

  Future<bool> viewVideo({required String videoId, required String userId});

  Future<VideoRating> fetchVideoRating({required String videoId, required String userId});

  Future<List<Video>> fetchRelatedVideos({required String videoId, required String userId});

  Future<Comment?> fetchMostLikeComment({required String videoId});

  Future<bool> rateVideo({required String videoId, required String userId, required String rating});
}
