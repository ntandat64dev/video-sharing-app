import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/playlist.dart';
import 'package:video_sharing_app/domain/entity/playlist_item.dart';
import 'package:video_sharing_app/domain/entity/video.dart';

abstract class PlaylistRepository {
  Future<Playlist?> createPlaylist(Playlist playlist);

  Future<Playlist?> updatePlaylist(Playlist playlist);

  Future<bool> deletePlaylistById(String playlistId);

  Future<PageResponse<Playlist>> getMyPlaylists([Pageable? pageable]);

  Future<Playlist?> getPlaylistById(String id);

  Future<List<String>> getPlaylistIdsContainingVideo(String videoId);

  Future<PlaylistItem?> addPlaylistItem({required String playlistId, required String videoId});

  Future<bool> addPlaylistItems({required String videoId, required Set<String> oldIds, required Set<String> newIds});

  Future<bool> removePlaylistItem({required String playlistId, required String videoId});

  Future<PageResponse<PlaylistItem>> getPlaylistItemByPlaylistId(String playlistId, [Pageable? pageable]);

  Future<PageResponse<Video>> getPlaylistItemVideos(String playlistId, [Pageable? pageable]);
}
