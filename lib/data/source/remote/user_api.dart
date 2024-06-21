import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:video_sharing_app/data/source/remote/constants.dart';
import 'package:video_sharing_app/domain/entity/user.dart';

class UserApi {
  UserApi({required this.token}) {
    bearerHeader = {'Authorization': 'Bearer $token'};
  }

  final String token;
  late final Map<String, String> bearerHeader;

  Future<User> changeProfileImage({required String imagePath}) async {
    final request = http.MultipartRequest('POST', Uri.http(baseURL, '/api/v1/users/profile-image'));
    request.headers.addAll(bearerHeader);

    final imageFile = await http.MultipartFile.fromPath(
      'imageFile',
      imagePath,
      contentType: MediaType('image', '*'),
    );
    request.files.add(imageFile);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode != 200) throw Exception('[${response.statusCode}] ${response.body}');
    return User.fromJson(jsonDecode(response.body));
  }

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
