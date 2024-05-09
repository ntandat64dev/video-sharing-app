import 'dart:math';

import 'package:video_sharing_app/domain/entity/category.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';

class FakeVideoApi {
  final videos = <Video>[];

  FakeVideoApi() {
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

  Future<List<Video>> getMyVideos() async {
    return videos;
  }

  Future<Video> getVideoById(String videoId) async {
    return videos[0];
  }

  Future<Video> postVideo({required String videoLocalPath, required Video video}) async {
    return videos[0];
  }

  Future<List<Video>> getVideoByCategoryAll() async {
    return videos;
  }

  Future<VideoRating> getVideoRating(String videoId) async {
    return VideoRating(
        videoId: videoId,
        userId: Random().nextInt(16).toRadixString(16),
        rating: Rating.like,
        publishedAt: DateTime.now());
  }

  Future<VideoRating> postVideoRating({required String videoId, required String rating}) async {
    return VideoRating(
        videoId: videoId,
        userId: Random().nextInt(16).toRadixString(16),
        rating: Rating.like,
        publishedAt: DateTime.now());
  }

  Future<List<Video>> getRelatedVideos(String videoId) async {
    return videos;
  }

  Future<List<String>> getVideoCategories() async {
    return ['Anime', 'Music', 'Sport'];
  }

  Future<List<Category>> getAllCategories() async {
    return [
      Category(id: Random().nextInt(16).toRadixString(16), category: 'Music'),
      Category(id: Random().nextInt(16).toRadixString(16), category: 'Sport'),
      Category(id: Random().nextInt(16).toRadixString(16), category: 'Anime'),
      Category(id: Random().nextInt(16).toRadixString(16), category: 'Film'),
    ];
  }
}
