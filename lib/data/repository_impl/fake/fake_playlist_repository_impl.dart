import 'dart:math';

import 'package:video_sharing_app/domain/entity/category.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/playlist.dart';
import 'package:video_sharing_app/domain/entity/playlist_item.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
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
      privacy: 'public',
      isDefaultPlaylist: false,
      itemCount: 4,
    ),
  ];

  @override
  Future<Playlist?> createPlaylist(Playlist playlist) async {
    await Future.delayed(const Duration(milliseconds: 500));
    playlists.add(playlist);
    return playlist;
  }

  @override
  Future<Playlist?> updatePlaylist(Playlist playlist) async {
    await Future.delayed(const Duration(milliseconds: 500));
    playlists[playlists.indexWhere((element) => element.id == playlist.id)] = playlist;
    return playlist;
  }

  @override
  Future<bool> deletePlaylistById(String playlistId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    playlists.removeWhere((element) => element.id == playlistId);
    return true;
  }

  @override
  Future<PageResponse<Playlist>> getMyPlaylists([Pageable? pageable]) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return PageResponse(
      pageNumber: 0,
      pageSize: playlists.length,
      totalElements: playlists.length,
      totalPages: 1,
      items: playlists,
    );
  }

  @override
  Future<Playlist?> getPlaylistById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return playlists[0];
  }

  @override
  Future<List<String>> getPlaylistIdsContainingVideo(String videoId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ['111', '222'];
  }

  @override
  Future<PlaylistItem?> addPlaylistItem({required String playlistId, required String videoId}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return null;
  }

  @override
  Future<bool> addPlaylistItems({
    required String videoId,
    required Set<String> oldIds,
    required Set<String> newIds,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    Set<String> commonItems = oldIds.intersection(newIds);
    oldIds.removeAll(commonItems);
    newIds.removeAll(commonItems);

    playlists.removeWhere((element) => oldIds.contains(element.id!));

    return true;
  }

  @override
  Future<bool> removePlaylistItem({required String playlistId, required String videoId}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  @override
  Future<PageResponse<PlaylistItem>> getPlaylistItemByPlaylistId(String playlistId, [Pageable? pageable]) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return PageResponse(
      pageNumber: 0,
      pageSize: 3,
      totalElements: 3,
      totalPages: 1,
      items: [
        for (int i = 0; i < 100; i++)
          PlaylistItem(
            playlistId: playlistId,
            videoId: 'videoId',
            title: 'Golden Sunset | Nature Relaxing',
            description: 'description',
            videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
            thumbnails: {
              Thumbnail.kDefault: const Thumbnail(
                url: 'https://dummyimage.com/720x450/5f8dfa/fff/',
                width: 720,
                height: 450,
              )
            },
            priority: i,
            videoOwnerUsername: 'videoOwnerUsername',
            videoOwnerUserId: 'videoOwnerUserId',
            duration: 'PT50M',
          ),
      ],
    );
  }

  @override
  Future<PageResponse<Video>> getPlaylistItemVideos(String playlistId, [Pageable? pageable]) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final videos = <Video>[];
    for (int i = 0; i < 100; i++) {
      final video = Video(
        id: Random().nextInt(16).toRadixString(16),
        publishedAt: DateTime.now(),
        userId: Random().nextInt(16).toRadixString(16),
        username: 'fakeuser',
        userImageUrl:
            'https://ui-avatars.com/api/?name=Fake+User&size=500&background=0D8ABC&color=fff&rouded=true&bold=true',
        title: 'Best Video Ever! $i',
        description: null,
        videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
        thumbnails: {
          Thumbnail.kDefault: const Thumbnail(
            url: 'https://dummyimage.com/720x450/5f8dfa/fff/',
            width: 720,
            height: 450,
          )
        },
        hashtags: ['music', 'sport', 'football'],
        duration: 'duration',
        location: null,
        category: Category(id: Random().nextInt(16).toRadixString(16), category: 'Music'),
        privacy: 'public',
        madeForKids: false,
        ageRestricted: false,
        commentAllowed: true,
        viewCount: BigInt.zero,
        likeCount: BigInt.zero,
        dislikeCount: BigInt.zero,
        commentCount: BigInt.from(100000),
        downloadCount: BigInt.zero,
      );

      videos.add(video);
    }

    return PageResponse(
      pageNumber: 0,
      pageSize: videos.length,
      totalElements: videos.length,
      totalPages: 1,
      items: videos,
    );
  }
}
