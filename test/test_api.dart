import 'package:test/test.dart';
import 'package:video_sharing_app/data/source/remote/api.dart';
import 'package:video_sharing_app/data/source/remote/api_impl.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';

void main() {
  const userId = '3303a85f-0628-4416-a1ab-04ed4ef6bb55';
  const videoId = '03bacc94-aaa3-46c2-bfaf-195d6ca79b43';

  test('Post video', () async {
    final Api api = ApiImpl.forTest();
    expect(() async {
      await api.postVideo(
        videoLocalPath: 'videoLocalPath',
        video: Video.upload(
          publishedAt: DateTime.now(),
          title: 'test',
          description: null,
          hashtags: [],
          location: null,
          privacy: 'public',
          madeForKids: false,
          ageRestricted: false,
          commentAllowed: true,
        ),
      );
    }, throwsException);
  });

  test('Get videos by all categories', () async {
    final Api api = ApiImpl.forTest();
    final recommendedVideos = await api.getVideosByAllCategories(userId: userId);
    expect(recommendedVideos.length, 4);
  });

  test('Get video rating', () async {
    final Api api = ApiImpl.forTest();
    final videoRating = await api.getVideoRating(videoId: videoId, userId: userId);
    expect(videoRating.rating, Rating.like);
  });

  test('Post video rating', () async {
    final Api api = ApiImpl.forTest();
    final result = await api.postVideoRating(videoId: videoId, userId: userId, rating: Rating.like.name);
    expect(result, true);

    final videoRating = await api.getVideoRating(videoId: videoId, userId: userId);
    expect(videoRating.rating, Rating.like);
  });

  test('Get related videos', () async {
    final Api api = ApiImpl.forTest();
    final relatedVideo = await api.getRelatedVideos(videoId: videoId, userId: userId);
    expect(relatedVideo.length, 4);
  });

  test('Get video categories', () async {
    final Api api = ApiImpl.forTest();
    final categories = await api.getVideoCategories(userId: userId);
    expect(categories.length, 6);
  });

  test('Get top level comment', () async {
    final Api api = ApiImpl.forTest();
    final comment = await api.getTopLevelComment(videoId: videoId);
    expect(comment != null, true);
    expect(comment!.text, 'Good video');
  });

  test('Sign in', () async {
    final Api api = ApiImpl.forTest();
    final user = await api.signIn(email: 'user1@gmail.com', password: '11111111');
    expect(user != null, true);
  });

  test('Sign up', () async {
    final Api api = ApiImpl.forTest();
    final user = await api.signUp(email: '', password: '');
    expect(user == null, true);
  });
}
