import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:video_sharing_app/data/source/remote/constants.dart';
import 'package:video_sharing_app/domain/entity/follow.dart';

class FollowApi {
  FollowApi({required this.token}) {
    bearerHeader = {'Authorization': 'Bearer $token'};
  }

  final String token;
  late final Map<String, String> bearerHeader;

  Future<List<Follow>> getMyFollows() async {
    final response = await http.get(
      Uri.http(baseURL, '/api/v1/follows/mine'),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) throw Exception('getMyFollows() [${response.statusCode}] ${response.body}');
    return (jsonDecode(response.body) as List).map((model) => Follow.fromJson(model)).toList();
  }

  Future<Follow> getFollowsForUserId(String userId) async {
    final response = await http.get(
      Uri.http(baseURL, '/api/v1/follows/for-user', {'userId': userId}),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) throw Exception('getFollowsForUserId() [${response.statusCode}] ${response.body}');
    return Follow.fromJson(jsonDecode(response.body));
  }

  Future<Follow> postFollow(Follow follow) async {
    final response = await http.post(
      Uri.http(baseURL, '/api/v1/follows'),
      body: jsonEncode(follow.toJson()),
      headers: {'Content-Type': 'application/json', ...bearerHeader},
    );
    if (response.statusCode != 201) throw Exception('postFollow() [${response.statusCode}] ${response.body}');
    return Follow.fromJson(jsonDecode(response.body));
  }

  Future<void> deleteFollow(String followId) async {
    final response = await http.delete(
      Uri.http(baseURL, '/api/v1/follows', {'id': followId}),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 204) throw Exception('deleteFollow() [${response.statusCode}] ${response.body}');
  }
}
