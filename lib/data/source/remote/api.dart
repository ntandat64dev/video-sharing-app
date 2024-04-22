import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/user.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';

abstract class Api {
  Future<Video?> getVideoById({required String videoId});

  Future<Video> postVideo({required String videoLocalPath, required Video video});

  Future<List<Video>> getVideosByAllCategories({required String userId});

  Future<VideoRating> getVideoRating({required String videoId, required String userId});

  Future<bool> postVideoRating({required String videoId, required String userId, required String rating});

  Future<List<Video>> getRelatedVideos({required String videoId, required String userId});

  Future<List<String>> getVideoCategories({required String userId});

  Future<List<Comment>> getCommentsByVideoId({required String videoId});

  Future<Comment> postComment({required Comment comment});

  Future<Comment?> getTopLevelComment({required String videoId});

  Future<User?> signUp({required String email, required String password});

  Future<User?> signIn({required String email, required String password});
}
