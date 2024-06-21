import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:video_sharing_app/data/source/remote/constants.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/user.dart';
import 'package:video_sharing_app/domain/entity/video.dart';

class SearchApi {
  SearchApi({required this.token}) {
    bearerHeader = {'Authorization': 'Bearer $token'};
  }

  final String token;
  late final Map<String, String> bearerHeader;

  Future<PageResponse<Object>> search({
    required String keyword,
    String? sort,
    String? type,
    required Pageable pageable,
  }) async {
    var response = await http.get(
      Uri.http(baseURL, '/api/v1/search', {
        'q': keyword,
        's_type': type,
        's_sort': sort,
        ...pageable.toParam(),
      }),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) {
      throw Exception('[${response.statusCode}] ${response.body}');
    }
    return PageResponse.fromSearchJson(
      jsonDecode(response.body),
      (itemJson) {
        if (itemJson['type'] == 'VIDEO') {
          return Video.fromJson(itemJson['snippet']);
        } else {
          return User.fromJson(itemJson['snippet']);
        }
      },
    );
  }
}
