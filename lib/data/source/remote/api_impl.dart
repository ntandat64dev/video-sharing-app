import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:video_sharing_app/data/source/remote/api.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/user.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';

class ApiImpl implements Api {
  ApiImpl();

  factory ApiImpl.forTest() => ApiImpl().._baseUrl = 'localhost:8080';

  var _baseUrl = '10.0.2.2:8080';

  @override
  Future<User?> signIn({required String email, required String password}) async {
    try {
      var response = await http.post(
        Uri.http(_baseUrl, '/api/auth/signin'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode != 200) return null;
      return User.fromJson(jsonDecode(response.body)['userInfo']);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> signUp({required String email, required String password}) async {
    try {
      var response = await http.post(
        Uri.http(_baseUrl, '/api/auth/signup'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode != 201) return null;
      return User.fromJson(jsonDecode(response.body)['userInfo']);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Video>> fetchRecommendVideos({required String userId}) async {
    try {
      var response = await http.get(Uri.http(_baseUrl, '/api/videos/recommend', {'userId': userId}));
      if (response.statusCode != 200) return [];
      return jsonDecode(response.body).map<Video>((e) => Video.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Video?> fetchVideoById({required String videoId}) async {
    try {
      var response = await http.get(Uri.http(_baseUrl, '/api/videos/$videoId'));
      if (response.statusCode != 200) return null;
      return Video.fromJson(jsonDecode(response.body));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Video> uploadVideo({required String videoPath, required String title, required String description}) async {
    try {
      final request = http.MultipartRequest('POST', Uri.http(_baseUrl, '/api/videos'));
      final videoFile = await http.MultipartFile.fromPath('videoFile', videoPath);
      final metadata = http.MultipartFile.fromString(
        'metadata',
        jsonEncode({
          'title': title,
          'description': description,
          'user': {'id': 1}
        }),
        contentType: MediaType('application', 'json'),
      );
      request.files.add(videoFile);
      request.files.add(metadata);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      return Video.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> fetchHashtags({required String userId}) async {
    try {
      var response = await http.get(Uri.http(_baseUrl, '/api/user/hashtags/$userId'));
      if (response.statusCode != 200) return [];
      return List<String>.from(jsonDecode(response.body));
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> viewVideo({required String videoId, required String userId}) async {
    try {
      var response = await http.post(Uri.http(_baseUrl, '/api/videos/view'), body: {
        'videoId': videoId,
        'userId': userId,
      });
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<VideoRating> fetchVideoRating({required String videoId, required String userId}) async {
    try {
      var response = await http.get(Uri.http(_baseUrl, '/api/videos/rate', {
        'videoId': videoId,
        'userId': userId,
      }));
      return VideoRating.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Video>> fetchRelatedVideos({required String videoId, required String userId}) async {
    try {
      var response = await http.get(Uri.http(_baseUrl, '/api/videos/related', {
        'videoId': videoId,
        'userId': userId,
      }));
      if (response.statusCode != 200) return [];
      return jsonDecode(response.body).map<Video>((e) => Video.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Comment?> fetchMostLikeComment({required String videoId}) async {
    try {
      var response = await http.get(Uri.http(_baseUrl, '/api/comments/most-like', {'videoId': videoId}));
      if (response.statusCode != 200) return Comment.fromJson(jsonDecode(response.body));
      return Comment.fromJson(jsonDecode(response.body));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> rateVideo({required String videoId, required String userId, required String rating}) async {
    try {
      var response = await http.post(
        Uri.http(_baseUrl, '/api/videos/rate'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: {
          'videoId': videoId,
          'userId': userId,
          'rating': rating.toUpperCase(),
          'ratedAt': DateTime.now(),
        },
      );
      return (response.statusCode == 204);
    } catch (e) {
      return false;
    }
  }
}
