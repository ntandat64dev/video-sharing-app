import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/data/source/remote/playlist_api.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/playlist.dart';
import 'package:video_sharing_app/domain/repository/playlist_repository.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  PlaylistRepositoryImpl({
    required PreferencesService pref,
    required PlaylistApi playlistApi,
  })  : _prefs = pref,
        _playlistApi = playlistApi;

  late final PreferencesService _prefs;
  late final PlaylistApi _playlistApi;

  @override
  Future<Playlist?> createPlaylist(Playlist playlist) async {
    playlist.userId = _prefs.getUserId();
    try {
      return await _playlistApi.postPlaylist(playlist);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Playlist?> updatePlaylist(Playlist playlist) async {
    try {
      return await _playlistApi.updatePlaylist(playlist);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> deletePlaylistById(String playlistId) async {
    try {
      await _playlistApi.deletePlaylist(playlistId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<PageResponse<Playlist>> getMyPlaylists([Pageable? pageable]) async {
    try {
      return await _playlistApi.getMyPlaylists(pageable ?? Pageable(sort: 'publishedAt'));
    } catch (e) {
      return PageResponse.empty();
    }
  }
}
