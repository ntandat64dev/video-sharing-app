import 'dart:math';

import 'package:video_sharing_app/data/source/remote/video_api.dart';
import 'package:video_sharing_app/domain/entity/category.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';

class FakeVideoApi extends VideoApi {
  final videos = <Video>[];

  FakeVideoApi({required super.token}) {
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
        videoUrl: 'videoUrl',
        thumbnails: {
          Thumbnail.kDefault: const Thumbnail(
            url: 'https://dummyimage.com/720x450/fff/aaa',
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
        commentCount: BigInt.zero,
        downloadCount: BigInt.zero,
      );

      videos.add(video);
    }
  }

  @override
  Future<PageResponse<Video>> getMyVideos(Pageable pageable) async {
    return PageResponse.empty();
  }

  @override
  Future<Video> getVideoById(String videoId) async {
    return videos[0];
  }

  @override
  Future<Video> postVideo({
    required String videoLocalPath,
    required String thumbnailLocalPath,
    required Video video,
  }) async {
    return videos[0];
  }

  @override
  Future<Video> updateVideo({
    String? thumbnailLocalPath,
    required Video video,
  }) async {
    return videos[0];
  }

  @override
  Future<void> deleteVideo(String videoId) async {}

  @override
  Future<PageResponse<Video>> getVideoByCategoryAll(Pageable pageable) async {
    return PageResponse.empty();
  }

  @override
  Future<VideoRating> getVideoRating(String videoId) async {
    return VideoRating(
        videoId: videoId,
        userId: Random().nextInt(16).toRadixString(16),
        rating: Rating.like,
        publishedAt: DateTime.now());
  }

  @override
  Future<VideoRating> postVideoRating({required String videoId, required String rating}) async {
    return VideoRating(
        videoId: videoId,
        userId: Random().nextInt(16).toRadixString(16),
        rating: Rating.like,
        publishedAt: DateTime.now());
  }

  @override
  Future<PageResponse<Video>> getRelatedVideos(String videoId, Pageable pageable) async {
    return PageResponse.empty();
  }

  @override
  Future<List<String>> getVideoCategories() async {
    return ['Anime', 'Music', 'Sport'];
  }

  @override
  Future<List<Category>> getAllCategories() async {
    return [
      Category(id: Random().nextInt(16).toRadixString(16), category: 'Music'),
      Category(id: Random().nextInt(16).toRadixString(16), category: 'Sport'),
      Category(id: Random().nextInt(16).toRadixString(16), category: 'Anime'),
      Category(id: Random().nextInt(16).toRadixString(16), category: 'Film'),
    ];
  }
}
