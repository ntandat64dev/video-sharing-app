import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:video_sharing_app/data/source/remote/constants.dart';
import 'package:video_sharing_app/domain/entity/follow.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';

class FollowApi {
  FollowApi({required this.token}) {
    bearerHeader = {'Authorization': 'Bearer $token'};
  }

  final String token;
  late final Map<String, String> bearerHeader;

  Future<PageResponse<Follow>> getMyFollows(Pageable pageable) async {
    final response = await http.get(
      Uri.http(baseURL, '/api/v1/follows/mine', pageable.toParam()),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) throw Exception('[${response.statusCode}] ${response.body}');
    return PageResponse.fromJson(jsonDecode(response.body), Follow.fromJsonModel);
  }

  Future<Follow> getFollowsForUserId(String userId) async {
    final response = await http.get(
      Uri.http(baseURL, '/api/v1/follows/for-user', {'userId': userId}),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) throw Exception('[${response.statusCode}] ${response.body}');
    return Follow.fromJson(jsonDecode(response.body));
  }

  Future<Follow> postFollow(Follow follow) async {
    final response = await http.post(
      Uri.http(baseURL, '/api/v1/follows'),
      body: jsonEncode(follow.toJson()),
      headers: {'Content-Type': 'application/json', ...bearerHeader},
    );
    if (response.statusCode != 201) throw Exception('[${response.statusCode}] ${response.body}');
    return Follow.fromJson(jsonDecode(response.body));
  }

  Future<void> deleteFollow(String followId) async {
    final response = await http.delete(
      Uri.http(baseURL, '/api/v1/follows', {'id': followId}),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 204) throw Exception('[${response.statusCode}] ${response.body}');
  }
}
