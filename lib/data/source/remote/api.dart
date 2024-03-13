import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:video_sharing_app/domain/entity/user.dart';

const String _baseUrl = 'http://10.0.2.2:8080';

abstract class Api {
  Future<User?> signUp({required String email, required String password});
  Future<User?> signIn({required String email, required String password});
}

class ApiImpl implements Api {
  @override
  Future<User?> signIn({required String email, required String password}) async {
    try {
      var response = await http.post(
        Uri.parse('$_baseUrl/api/auth/signin'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode != 200) return null;
      return User.fromJson(jsonDecode(response.body)['userInfo']);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<User?> signUp({required String email, required String password}) async {
    try {
      var response = await http.post(
        Uri.parse('$_baseUrl/api/auth/signup'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode != 201) return null;
      return User.fromJson(jsonDecode(response.body)['userInfo']);
    } catch (_) {
      return null;
    }
  }
}
