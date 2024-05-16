import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:video_sharing_app/data/source/remote/constants.dart';

class AuthApi {
  Future<String> signIn({required String username, required String password}) async {
    var response = await http.post(Uri.http(baseURL, '/api/v1/auth/login', {
      'username': username,
      'password': password,
    }));
    if (response.statusCode != 200) throw Exception('signIn() [${response.statusCode}] ${response.body}');
    return jsonDecode(response.body)['token']!;
  }

  Future<void> signUp({required String username, required String password}) async {
    var response = await http.post(Uri.http(baseURL, '/api/v1/auth/signup', {
      'username': username,
      'password': password,
    }));
    if (response.statusCode != 201) throw Exception('signUp() [${response.statusCode}] ${response.body}');
  }
}
