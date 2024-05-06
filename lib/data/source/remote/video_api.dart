import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:video_sharing_app/data/source/remote/constants.dart';
import 'package:video_sharing_app/domain/entity/category.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';

class VideoApi {
  VideoApi({required this.token});

  final String token;

  Future<Video> getVideoById(String videoId) async {
    var response = await http.get(
      Uri.http(baseURL, '/api/v1/videos/$videoId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) throw Exception('getVideoById() [${response.statusCode}] ${response.body}');
    return Video.fromJson(jsonDecode(response.body));
  }

  Future<Video> postVideo({required String videoLocalPath, required Video video}) async {
    final request = http.MultipartRequest('POST', Uri.http(baseURL, '/api/v1/videos'));
    request.headers['Authorization'] = 'Bearer $token';
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
    if (response.statusCode != 201) throw Exception('postVideo() [${response.statusCode}] ${response.body}');
    return Video.fromJson(jsonDecode(response.body));
  }

  Future<List<Video>> getVideoByCategoryAll() async {
    var response = await http.get(
      Uri.http(baseURL, '/api/v1/videos/category/all/mine'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('getVideoByCategoryAll() [${response.statusCode}] ${response.body}');
    }
    return jsonDecode(response.body).map<Video>((e) => Video.fromJson(e)).toList();
  }

  Future<VideoRating> getVideoRating(String videoId) async {
    var response = await http.get(
      Uri.http(baseURL, '/api/v1/videos/rate/mine', {'videoId': videoId}),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) throw Exception('getVideoRating() [${response.statusCode}] ${response.body}');
    return VideoRating.fromJson(jsonDecode(response.body));
  }

  Future<VideoRating> postVideoRating({required String videoId, required String rating}) async {
    var response = await http.post(
      Uri.http(baseURL, '/api/v1/videos/rate/mine', {
        'videoId': videoId,
        'rating': rating.toLowerCase(),
      }),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) throw Exception('postVideoRating() [${response.statusCode}] ${response.body}');
    return VideoRating.fromJson(jsonDecode(response.body));
  }

  Future<List<Video>> getRelatedVideos(String videoId) async {
    var response = await http.get(
      Uri.http(baseURL, '/api/v1/videos/related/mine', {'videoId': videoId}),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) throw Exception('getRelatedVideos() [${response.statusCode}] ${response.body}');
    return jsonDecode(response.body).map<Video>((e) => Video.fromJson(e)).toList();
  }

  Future<List<String>> getVideoCategories() async {
    var response = await http.get(
      Uri.http(baseURL, '/api/v1/videos/video-categories/mine'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) throw Exception('getVideoCategories() [${response.statusCode}] ${response.body}');
    return List<String>.from(jsonDecode(response.body));
  }

  Future<List<Category>> getAllCategories() async {
    final response = await http.get(
      Uri.http(baseURL, '/api/v1/categories'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) throw Exception('getAllCategories() [${response.statusCode}] ${response.body}');
    return List<Category>.from((jsonDecode(response.body) as List).map((e) => Category.fromJson(e)));
  }
}
