import 'dart:math';

import 'package:video_sharing_app/domain/entity/category.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';
import 'package:video_sharing_app/domain/enum/rating.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';

class FakeVideoRepositoryImpl implements VideoRepository {
  FakeVideoRepositoryImpl() {
    for (int i = 0; i < 20; i++) {
      final video = Video(
        id: Random().nextInt(16).toRadixString(16),
        publishedAt: DateTime.now(),
        userId: Random().nextInt(16).toRadixString(16),
        username: 'fakeuser',
        userImageUrl:
            'https://ui-avatars.com/api/?name=Fake+User&size=500&background=0D8ABC&color=fff&rouded=true&bold=true',
        title: 'Best Video Ever!',
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
        duration: 'PT50M',
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
  }

  final videos = <Video>[];

  @override
  Future<Video?> getVideoById(String videoId) async {
    return videos[0];
  }

  @override
  Future<Video?> uploadVideo({
    required String videoPath,
    required String thumbnailPath,
    required Video video,
  }) async {
    return videos[0];
  }

  @override
  Future<Video?> updateVideo({
    String? thumbnailPath,
    required Video video,
  }) async {
    return videos[0];
  }

  @override
  Future<bool> deleteVideoById(String videoId) async {
    return true;
  }

  @override
  Future<PageResponse<Video>> getVideosByCategoryAll([Pageable? pageable]) async {
    return PageResponse(
      pageNumber: 0,
      pageSize: videos.length,
      totalElements: videos.length,
      totalPages: 1,
      items: videos,
    );
  }

  @override
  Future<PageResponse<Video>> getVideosByUserId(String userId, [Pageable? pageable]) async {
    var myVideos = <Video>[];
    for (int i = 0; i < 20; i++) {
      final video = Video(
        id: Random().nextInt(16).toRadixString(16),
        publishedAt: DateTime.now(),
        userId: '12345678',
        username: 'fakeuser',
        userImageUrl:
            'https://ui-avatars.com/api/?name=Fake+User&size=500&background=0D8ABC&color=fff&rouded=true&bold=true',
        title: 'Best Video Ever!',
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
        duration: 'PT50M',
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

      myVideos.add(video);
    }
    return PageResponse(
      pageNumber: 0,
      pageSize: myVideos.length,
      totalElements: myVideos.length,
      totalPages: 1,
      items: myVideos,
    );
  }

  @override
  Future<PageResponse<Video>> getMyVideos([Pageable? pageable]) async {
    var myVideos = <Video>[];
    for (int i = 0; i < 20; i++) {
      final video = Video(
        id: Random().nextInt(16).toRadixString(16),
        publishedAt: DateTime.now(),
        userId: '12345678',
        username: 'fakeuser',
        userImageUrl:
            'https://ui-avatars.com/api/?name=Fake+User&size=500&background=0D8ABC&color=fff&rouded=true&bold=true',
        title: 'Best Video Ever!',
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
        duration: 'PT50M',
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

      myVideos.add(video);
    }
    return PageResponse(
      pageNumber: 0,
      pageSize: myVideos.length,
      totalElements: myVideos.length,
      totalPages: 1,
      items: myVideos,
    );
  }

  @override
  Future<bool> viewVideo({required String videoId}) async => true;

  @override
  Future<VideoRating?> getVideoRating(String videoId) async {
    return VideoRating(
      videoId: videoId,
      userId: Random().nextInt(16).toRadixString(16),
      rating: Rating.like,
      publishedAt: DateTime.now(),
    );
  }

  @override
  Future<VideoRating?> rateVideo({required String videoId, required Rating rating}) async {
    return VideoRating(
      videoId: videoId,
      userId: Random().nextInt(16).toRadixString(16),
      rating: Rating.like,
      publishedAt: DateTime.now(),
    );
  }

  @override
  Future<PageResponse<Video>> getRelatedVideos(String videoId, [Pageable? pageable]) async {
    return PageResponse(
      pageNumber: 0,
      pageSize: videos.length,
      totalElements: videos.length,
      totalPages: 1,
      items: videos,
    );
  }

  @override
  Future<List<String>> getVideoCategories() async {
    return ['Sport', 'Music', 'Football', 'Sport', 'Music', 'Football', 'Sport', 'Music', 'Football'];
  }

  @override
  Future<List<Category>> getAllCategories() async {
    return const [
      Category(id: '11111111', category: 'Sport'),
      Category(id: '22222222', category: 'Music'),
      Category(id: '33333333', category: 'Entertainment'),
    ];
  }

  @override
  Future<PageResponse<Video>> getFollowingVideos([Pageable? pageable]) async {
    return PageResponse(
      pageNumber: 0,
      pageSize: videos.length,
      totalElements: videos.length,
      totalPages: 1,
      items: videos,
    );
  }
}
