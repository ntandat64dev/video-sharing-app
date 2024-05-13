import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:video_sharing_app/data/source/remote/constants.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';

class CommentApi {
  CommentApi({required this.token}) {
    bearerHeader = {'Authorization': 'Bearer $token'};
  }

  final String token;
  late final Map<String, String> bearerHeader;

  Future<List<Comment>> getCommentsByVideoId(String videoId) async {
    final response = await http.get(
      Uri.http(baseURL, '/api/v1/comments', {'videoId': videoId}),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) throw Exception('getCommentsByVideoId() [${response.statusCode}] ${response.body}');
    return List<Comment>.from((jsonDecode(response.body) as List).map((model) => Comment.fromJson(model)));
  }

  Future<Comment> postComment(Comment comment) async {
    var response = await http.post(
      Uri.http(baseURL, '/api/v1/comments'),
      body: jsonEncode(comment.toJson()),
      headers: {'Content-Type': 'application/json', ...bearerHeader},
    );
    if (response.statusCode != 201) throw Exception('getCommentsByVideoId() [${response.statusCode}] ${response.body}');
    return Comment.fromJson(jsonDecode(response.body));
  }
}
