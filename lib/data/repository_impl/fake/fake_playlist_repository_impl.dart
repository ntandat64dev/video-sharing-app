import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/playlist.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/repository/playlist_repository.dart';

class FakePlaylistRepositoryImpl implements PlaylistRepository {
  final playlists = [
    Playlist(
      id: '111',
      publishedAt: DateTime.now(),
      userId: '123',
      username: 'username',
      userImageUrl: 'https://via.placeholder.com/100x100.png/d13328/fff?text=Avatar',
      title: 'Watch Later',
      description: null,
      thumbnails: {
        Thumbnail.kDefault: const Thumbnail(
          url: 'https://dummyimage.com/720x450/5f8dfa/fff/',
          width: 720,
          height: 450,
        )
      },
      privacy: 'private',
      isDefaultPlaylist: true,
      itemCount: 1,
    ),
    Playlist(
      id: '222',
      publishedAt: DateTime.now(),
      userId: '123',
      username: 'username',
      userImageUrl: 'https://via.placeholder.com/100x100.png/d13328/fff?text=Avatar',
      title: 'Liked Videos',
      description: null,
      thumbnails: {
        Thumbnail.kDefault: const Thumbnail(
          url: 'https://dummyimage.com/720x450/5f8dfa/fff/',
          width: 720,
          height: 450,
        )
      },
      privacy: 'private',
      isDefaultPlaylist: true,
      itemCount: 4,
    ),
    Playlist(
      id: '333',
      publishedAt: DateTime.now(),
      userId: '123',
      username: 'username',
      userImageUrl: 'https://via.placeholder.com/100x100.png/d13328/fff?text=Avatar',
      title: 'My Favorite Videos',
      description: null,
      thumbnails: {
        Thumbnail.kDefault: const Thumbnail(
          url: 'https://dummyimage.com/720x450/5f8dfa/fff/',
          width: 720,
          height: 450,
        )
      },
      privacy: 'private',
      isDefaultPlaylist: false,
      itemCount: 4,
    ),
  ];

  @override
  Future<Playlist?> createPlaylist(Playlist playlist) async {
    playlists.add(playlist);
    return playlist;
  }

  @override
  Future<Playlist?> updatePlaylist(Playlist playlist) async {
    playlists[playlists.indexWhere((element) => element.id == playlist.id)] = playlist;
    return playlist;
  }

  @override
  Future<bool> deletePlaylistById(String playlistId) async {
    playlists.removeWhere((element) => element.id == playlistId);
    return true;
  }

  @override
  Future<PageResponse<Playlist>> getMyPlaylists([Pageable? pageable]) async {
    return PageResponse(
      pageNumber: 0,
      pageSize: playlists.length,
      totalElements: playlists.length,
      totalPages: 1,
      items: playlists,
    );
  }
}
