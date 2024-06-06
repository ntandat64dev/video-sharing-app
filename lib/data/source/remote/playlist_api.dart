import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:video_sharing_app/data/source/remote/constants.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/playlist.dart';

class PlaylistApi {
  PlaylistApi({required this.token}) {
    bearerHeader = {'Authorization': 'Bearer $token'};
  }

  final String token;
  late final Map<String, String> bearerHeader;

  Future<Playlist> postPlaylist(Playlist playlist) async {
    final response = await http.post(
      Uri.http(baseURL, '/api/v1/playlists'),
      body: jsonEncode(playlist.toJson()),
      headers: {'Content-Type': 'application/json', ...bearerHeader},
    );
    if (response.statusCode != 201) throw Exception('postPlaylist() [${response.statusCode}] ${response.body}');
    return Playlist.fromJson(jsonDecode(response.body));
  }

  Future<Playlist> updatePlaylist(Playlist playlist) async {
    final response = await http.put(
      Uri.http(baseURL, '/api/v1/playlists'),
      body: jsonEncode(playlist.toJson()),
      headers: {'Content-Type': 'application/json', ...bearerHeader},
    );
    if (response.statusCode != 200) throw Exception('updatePlaylist() [${response.statusCode}] ${response.body}');
    return Playlist.fromJson(jsonDecode(response.body));
  }

  Future<void> deletePlaylist(String playlistId) async {
    final response = await http.delete(
      Uri.http(baseURL, '/api/v1/playlists', {'id': playlistId}),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 204) throw Exception('deletePlaylist() [${response.statusCode}] ${response.body}');
  }

  Future<PageResponse<Playlist>> getMyPlaylists(Pageable pageable) async {
    var response = await http.get(
      Uri.http(baseURL, '/api/v1/playlists/mine', pageable.toParam()),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) {
      throw Exception('getMyPlaylists() [${response.statusCode}] ${response.body}');
    }
    return PageResponse.fromJson(jsonDecode(response.body), Playlist.fromJsonModel);
  }
}
