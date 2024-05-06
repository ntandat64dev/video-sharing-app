import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:video_sharing_app/data/source/remote/constants.dart';
import 'package:video_sharing_app/domain/entity/user.dart';

class UserApi {
  UserApi({required this.token});

  final String token;

  Future<User> getMyInfo() async {
    final response = await http.get(
      Uri.http(baseURL, '/api/v1/users/mine'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) throw Exception('getMyInfo() [${response.statusCode}] ${response.body}');
    return User.fromJson(jsonDecode(response.body));
  }

  Future<User> getUserByUserId(String userId) async {
    final response = await http.get(
      Uri.http(baseURL, '/api/v1/users/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) throw Exception('getUserByUserId() [${response.statusCode}] ${response.body}');
    return User.fromJson(jsonDecode(response.body));
  }
}
