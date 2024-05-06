import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:video_sharing_app/data/source/remote/constants.dart';
import 'package:video_sharing_app/domain/entity/follow.dart';

class FollowApi {
  FollowApi({required this.token});

  final String token;

  Future<List<Follow>> getMyFollows() async {
    final response = await http.get(
      Uri.http(baseURL, '/api/v1/follows/mine'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) throw Exception('getMyFollows() [${response.statusCode}] ${response.body}');
    return (jsonDecode(response.body) as List).map((model) => Follow.fromJson(model)).toList();
  }

  Future<Follow> getFollowsForUserId(String userId) async {
    final response = await http.get(
      Uri.http(baseURL, '/api/v1/follows/for-user', {'userId': userId}),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) throw Exception('getFollowsForUserId() [${response.statusCode}] ${response.body}');
    return Follow.fromJson(jsonDecode(response.body));
  }

  Future<Follow> postFollow(Follow follow) async {
    final response = await http.post(
      Uri.http(baseURL, '/api/v1/follows'),
      body: jsonEncode(follow.toJson()),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 201) throw Exception('postFollow() [${response.statusCode}] ${response.body}');
    return Follow.fromJson(jsonDecode(response.body));
  }

  Future<void> deleteFollow(String followId) async {
    final response = await http.delete(
      Uri.http(baseURL, '/api/v1/follows', {'id': followId}),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 204) throw Exception('deleteFollow() [${response.statusCode}] ${response.body}');
  }
}
