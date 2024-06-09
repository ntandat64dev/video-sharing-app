import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:video_sharing_app/data/source/remote/constants.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/playlist.dart';
import 'package:video_sharing_app/domain/entity/playlist_item.dart';
import 'package:video_sharing_app/domain/entity/video.dart';

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
    if (response.statusCode != 201) throw Exception('[${response.statusCode}] ${response.body}');
    return Playlist.fromJson(jsonDecode(response.body));
  }

  Future<Playlist> updatePlaylist(Playlist playlist) async {
    final response = await http.put(
      Uri.http(baseURL, '/api/v1/playlists'),
      body: jsonEncode(playlist.toJson()),
      headers: {'Content-Type': 'application/json', ...bearerHeader},
    );
    if (response.statusCode != 200) throw Exception('[${response.statusCode}] ${response.body}');
    return Playlist.fromJson(jsonDecode(response.body));
  }

  Future<void> deletePlaylist(String playlistId) async {
    final response = await http.delete(
      Uri.http(baseURL, '/api/v1/playlists', {'id': playlistId}),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 204) throw Exception('[${response.statusCode}] ${response.body}');
  }

  Future<PageResponse<Playlist>> getMyPlaylists(Pageable pageable) async {
    var response = await http.get(
      Uri.http(baseURL, '/api/v1/playlists/mine', pageable.toParam()),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) {
      throw Exception('[${response.statusCode}] ${response.body}');
    }
    return PageResponse.fromJson(jsonDecode(response.body), Playlist.fromJsonModel);
  }

  Future<Playlist> getPlaylistById(String id) async {
    var response = await http.get(
      Uri.http(baseURL, '/api/v1/playlists', {'id': id}),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) {
      throw Exception('[${response.statusCode}] ${response.body}');
    }
    return Playlist.fromJson(jsonDecode(response.body));
  }

  Future<List<String>> getPlaylistIdsContainingVideo(String videoId, List<int> excludes) async {
    var response = await http.get(
      Uri.http(baseURL, '/api/v1/playlists/containing', {'videoId': videoId, 'excludes': excludes.join(',')}),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) {
      throw Exception('[${response.statusCode}] ${response.body}');
    }
    return List<String>.from(jsonDecode(response.body));
  }

  Future<PlaylistItem> addPlaylistItem(PlaylistItem playlistItem) async {
    var response = await http.post(
      Uri.http(baseURL, '/api/v1/playlists/items'),
      headers: {'Content-Type': 'application/json', ...bearerHeader},
      body: jsonEncode(playlistItem.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('[${response.statusCode}] ${response.body}');
    }
    return PlaylistItem.fromJson(jsonDecode(response.body));
  }

  Future<void> removePlaylistItem({required String playlistId, required String videoId}) async {
    var response = await http.delete(
      Uri.http(baseURL, '/api/v1/playlists/items', {'playlistId': playlistId, 'videoId': videoId}),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 204) {
      throw Exception('[${response.statusCode}] ${response.body}');
    }
  }

  Future<PageResponse<PlaylistItem>> getPlaylistItemByPlaylistId(String playlistId, Pageable pageable) async {
    var response = await http.get(
      Uri.http(baseURL, '/api/v1/playlists/items', {'playlistId': playlistId, ...pageable.toParam()}),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) {
      throw Exception('[${response.statusCode}] ${response.body}');
    }
    return PageResponse.fromJson(jsonDecode(response.body), PlaylistItem.fromJsonModel);
  }

  Future<PageResponse<Video>> getPlaylistItemVideos(String playlistId, Pageable pageable) async {
    var response = await http.get(
      Uri.http(baseURL, '/api/v1/playlists/items/videos', {'playlistId': playlistId, ...pageable.toParam()}),
      headers: {...bearerHeader},
    );
    if (response.statusCode != 200) {
      throw Exception('[${response.statusCode}] ${response.body}');
    }
    return PageResponse.fromJson(jsonDecode(response.body), Video.fromJsonModel);
  }
}
