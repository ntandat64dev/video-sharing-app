import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/data/source/remote/playlist_api.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/playlist.dart';
import 'package:video_sharing_app/domain/entity/playlist_item.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
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

  @override
  Future<Playlist?> getPlaylistById(String id) async {
    try {
      return await _playlistApi.getPlaylistById(id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<String>> getPlaylistIdsContainingVideo(String videoId) async {
    try {
      return await _playlistApi.getPlaylistIdsContainingVideo(videoId, [1]);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<PlaylistItem?> addPlaylistItem({required String playlistId, required String videoId}) async {
    try {
      return await _playlistApi.addPlaylistItem(PlaylistItem.post(playlistId: playlistId, videoId: videoId));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> addPlaylistItems({
    required String videoId,
    required Set<String> oldIds,
    required Set<String> newIds,
  }) async {
    try {
      Set<String> commonItems = oldIds.intersection(newIds);
      oldIds.removeAll(commonItems);
      newIds.removeAll(commonItems);

      final futures = <Future>[];

      for (final oldId in oldIds) {
        futures.add(_playlistApi.removePlaylistItem(playlistId: oldId, videoId: videoId));
      }

      for (final newId in newIds) {
        futures.add(_playlistApi.addPlaylistItem(PlaylistItem.post(playlistId: newId, videoId: videoId)));
      }

      await Future.wait(futures);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> removePlaylistItem({required String playlistId, required String videoId}) async {
    try {
      await _playlistApi.removePlaylistItem(playlistId: playlistId, videoId: videoId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<PageResponse<PlaylistItem>> getPlaylistItemByPlaylistId(String playlistId, [Pageable? pageable]) async {
    try {
      return await _playlistApi.getPlaylistItemByPlaylistId(playlistId, pageable ?? Pageable());
    } catch (e) {
      return PageResponse.empty();
    }
  }

  @override
  Future<PageResponse<Video>> getPlaylistItemVideos(String playlistId, [Pageable? pageable]) async {
    try {
      return await _playlistApi.getPlaylistItemVideos(playlistId, pageable ?? Pageable());
    } catch (e) {
      return PageResponse.empty();
    }
  }
}
