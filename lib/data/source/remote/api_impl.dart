import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:video_sharing_app/data/source/remote/api.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/follow.dart';
import 'package:video_sharing_app/domain/entity/user.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';

class ApiImpl implements Api {
  ApiImpl();

  factory ApiImpl.forTest() => ApiImpl().._baseUrl = 'localhost:8080';

  var _baseUrl = '10.0.2.2:8080';

  @override
  Future<Video?> getVideoById({required String videoId}) async {
    try {
      var response = await http.get(Uri.http(_baseUrl, '/api/v1/videos', {'videoId': videoId}));
      if (response.statusCode != 200) return null;
      return Video.fromJson(jsonDecode(response.body));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Video> postVideo({required String videoLocalPath, required Video video}) async {
    try {
      final request = http.MultipartRequest('POST', Uri.http(_baseUrl, '/api/v1/videos'));
      final videoFile = await http.MultipartFile.fromPath('videoFile', videoLocalPath);
      final metadata = http.MultipartFile.fromString(
        'metadata',
        jsonEncode(video.toJson()),
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
  Future<List<Video>> getVideosByAllCategories({required String userId}) async {
    try {
      var response = await http.get(Uri.http(_baseUrl, '/api/v1/videos/category/all', {'userId': userId}));
      if (response.statusCode != 200) return [];
      return jsonDecode(response.body).map<Video>((e) => Video.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<VideoRating> getVideoRating({required String videoId, required String userId}) async {
    try {
      var response = await http.get(Uri.http(_baseUrl, '/api/v1/videos/rate', {
        'videoId': videoId,
        'userId': userId,
      }));
      return VideoRating.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> postVideoRating({required String videoId, required String userId, required String rating}) async {
    try {
      var response = await http.post(
          Uri.http(_baseUrl, '/api/v1/videos/rate', {
            'videoId': videoId,
            'userId': userId,
            'rating': rating.toLowerCase(),
          }),
          headers: {'Content-Type': 'application/json'});
      return (response.statusCode == 204);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Video>> getRelatedVideos({required String videoId, required String userId}) async {
    try {
      var response = await http.get(Uri.http(_baseUrl, '/api/v1/videos/related', {
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
  Future<User?> getUserInfo({required String userId}) async {
    try {
      final response = await http.get(Uri.http(_baseUrl, '/api/v1/users', {'userId': userId}));
      if (response.statusCode != 200) return null;
      return User.fromJson(jsonDecode(response.body));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Follow>> getFollows({required String userId, String? forUserId}) async {
    try {
      final response = await http.get(Uri.http(_baseUrl, '/api/v1/users/follows', {
        'userId': userId,
        'forUserId': forUserId,
      }));
      if (response.statusCode != 200) return [];
      return (jsonDecode(response.body) as List).map((model) => Follow.fromJson(model)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Follow> postFollow({required Follow follow}) async {
    try {
      final response = await http.post(
        Uri.http(_baseUrl, '/api/v1/users/follows'),
        body: jsonEncode(follow.toJson()),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode != 201) throw Exception('Something went wrong!');
      return Follow.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getVideoCategories({required String userId}) async {
    try {
      var response = await http.get(Uri.http(_baseUrl, '/api/v1/users/video-categories', {'userId': userId}));
      if (response.statusCode != 200) return [];
      return List<String>.from(jsonDecode(response.body));
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Comment>> getCommentsByVideoId({required String videoId}) async {
    try {
      final response = await http.get(Uri.http(_baseUrl, '/api/v1/comments', {'videoId': videoId}));
      if (response.statusCode != 200) return [];
      return List<Comment>.from((jsonDecode(response.body) as List).map((model) => Comment.fromJson(model)));
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Comment> postComment({required Comment comment}) async {
    try {
      var response = await http.post(
        Uri.http(_baseUrl, '/api/v1/comments'),
        body: jsonEncode(comment.toJson()),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode != 201) throw Exception('Something went wrong!');
      return Comment.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Comment?> getTopLevelComment({required String videoId}) async {
    try {
      var response = await http.get(Uri.http(_baseUrl, '/api/v1/comments/top-level', {'videoId': videoId}));
      if (response.statusCode != 200) return null;
      return Comment.fromJson(jsonDecode(response.body));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> signIn({required String email, required String password}) async {
    try {
      var response = await http.post(
          Uri.http(_baseUrl, '/api/v1/auth/login', {
            'email': email,
            'password': password,
          }),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode != 200) return null;
      return User.fromJson(jsonDecode(response.body));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> signUp({required String email, required String password}) async {
    try {
      var response = await http.post(
          Uri.http(_baseUrl, '/api/v1/auth/register', {
            'email': email,
            'password': password,
          }),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode != 201) return null;
      return User.fromJson(jsonDecode(response.body));
    } catch (e) {
      return null;
    }
  }
}
