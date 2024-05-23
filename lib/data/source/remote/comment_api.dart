import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:video_sharing_app/data/source/remote/constants.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/comment_rating.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';

class CommentApi {
  CommentApi({required this.token}) {
    bearerHeader = {'Authorization': 'Bearer $token'};
  }

  final String token;
  late final Map<String, String> bearerHeader;

  Future<Comment> postComment(Comment comment) async {
    var response = await http.post(
      Uri.http(baseURL, '/api/v1/comments'),
      body: jsonEncode(comment.toJson()),
      headers: {'Content-Type': 'application/json', ...bearerHeader},
    );
    if (response.statusCode != 201) throw Exception('getCommentsByVideoId() [${response.statusCode}] ${response.body}');
    return Comment.fromJson(jsonDecode(response.body));
  }

  Future<void> deleteCommentById(String commentId) async {
    var response = await http.delete(
      Uri.http(baseURL, '/api/v1/comments', {'id': commentId}),
      headers: bearerHeader,
    );
    if (response.statusCode != 204) throw Exception('deleteCommentById() [${response.statusCode}] ${response.body}');
  }

  Future<Comment> getCommentById(String commentId) async {
    final response = await http.get(
      Uri.http(baseURL, '/api/v1/comments/$commentId'),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) throw Exception('getCommentById() [${response.statusCode}] ${response.body}');
    return Comment.fromJson(jsonDecode(response.body));
  }

  Future<PageResponse<Comment>> getCommentsByVideoId(String videoId, Pageable pageable) async {
    final response = await http.get(
      Uri.http(baseURL, '/api/v1/comments', {'videoId': videoId, ...pageable.toParam()}),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) throw Exception('getCommentsByVideoId() [${response.statusCode}] ${response.body}');
    return PageResponse.fromJson(jsonDecode(response.body), Comment.fromJsonModel);
  }

  Future<PageResponse<Comment>> getRepliesByCommentId(String commentId, Pageable pageable) async {
    final response = await http.get(
      Uri.http(baseURL, '/api/v1/comments/replies', {'commentId': commentId, ...pageable.toParam()}),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) {
      throw Exception('getRepliesByCommentId() [${response.statusCode}] ${response.body}');
    }
    return PageResponse.fromJson(jsonDecode(response.body), Comment.fromJsonModel);
  }

  Future<CommentRating> postCommentRating({required String commentId, required String rating}) async {
    var response = await http.post(
      Uri.http(baseURL, '/api/v1/comments/rate/mine', {
        'commentId': commentId,
        'rating': rating.toLowerCase(),
      }),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) throw Exception('postCommentRating() [${response.statusCode}] ${response.body}');
    return CommentRating.fromJson(jsonDecode(response.body));
  }

  Future<CommentRating> getCommentRating(String commentId) async {
    var response = await http.get(
      Uri.http(baseURL, '/api/v1/comments/rate/mine', {'commentId': commentId}),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) throw Exception('getCommentRating() [${response.statusCode}] ${response.body}');
    return CommentRating.fromJson(jsonDecode(response.body));
  }

  Future<PageResponse<CommentRating>> getCommentRatingsOfVideo(String videoId, Pageable? pageable) async {
    final page = pageable?.toParam();
    var response = await http.get(
      Uri.http(baseURL, '/api/v1/comments/rates/mine', {'videoId': videoId, ...page ?? {}}),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) {
      throw Exception('getCommentRatingsOfVideo() [${response.statusCode}] ${response.body}');
    }
    return PageResponse.fromJson(jsonDecode(response.body), CommentRating.fromJsonModel);
  }
}
