import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:video_sharing_app/data/source/remote/constants.dart';
import 'package:video_sharing_app/domain/entity/notification.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';

class NotificationApi {
  NotificationApi({required this.token}) {
    bearerHeader = {'Authorization': 'Bearer $token'};
  }

  final String token;
  late final Map<String, String> bearerHeader;

  Future<void> registerMessageToken(String token) async {
    var response = await http.post(
      Uri.http(baseURL, '/api/v1/notifications/message-token'),
      headers: {...bearerHeader},
      body: token,
    );
    if (response.statusCode != 201) throw Exception('[${response.statusCode}] ${response.body}');
  }

  Future<void> unregisterMessageToken(String token) async {
    var response = await http.delete(
      Uri.http(baseURL, '/api/v1/notifications/message-token'),
      headers: {...bearerHeader},
      body: token,
    );
    if (response.statusCode != 204) {
      throw Exception('[${response.statusCode}] ${response.body}');
    }
  }

  Future<void> readNotification(String id) async {
    var response = await http.post(
      Uri.http(baseURL, '/api/v1/notifications/read/mine', {'id': id}),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 204) throw Exception('[${response.statusCode}] ${response.body}');
  }

  Future<int> countUnseenNotifications() async {
    var response = await http.get(
      Uri.http(baseURL, '/api/v1/notifications/count-unseen/mine'),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) {
      throw Exception('[${response.statusCode}] ${response.body}');
    }
    return int.parse(response.body);
  }

  Future<PageResponse<Notification>> getMyNotifications(Pageable pageable) async {
    var response = await http.get(
      Uri.http(baseURL, '/api/v1/notifications/mine', pageable.toParam()),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) {
      throw Exception('[${response.statusCode}] ${response.body}');
    }
    return PageResponse.fromJson(jsonDecode(response.body), Notification.fromJsonModel);
  }
}
