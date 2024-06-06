import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/playlist.dart';

abstract class PlaylistRepository {
  Future<Playlist?> createPlaylist(Playlist playlist);

  Future<Playlist?> updatePlaylist(Playlist playlist);

  Future<bool> deletePlaylistById(String playlistId);

  Future<PageResponse<Playlist>> getMyPlaylists([Pageable? pageable]);
}
