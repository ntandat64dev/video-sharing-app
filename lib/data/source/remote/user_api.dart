import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:video_sharing_app/data/source/remote/constants.dart';
import 'package:video_sharing_app/domain/entity/user.dart';

class UserApi {
  UserApi({required this.token}) {
    bearerHeader = {'Authorization': 'Bearer $token'};
  }

  final String token;
  late final Map<String, String> bearerHeader;

  Future<User> getMyInfo() async {
    final response = await http.get(
      Uri.http(baseURL, '/api/v1/users/mine'),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) throw Exception('[${response.statusCode}] ${response.body}');
    return User.fromJson(jsonDecode(response.body));
  }

  Future<User> getUserByUserId(String userId) async {
    final response = await http.get(
      Uri.http(baseURL, '/api/v1/users/$userId'),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) throw Exception('[${response.statusCode}] ${response.body}');
    return User.fromJson(jsonDecode(response.body));
  }
}
