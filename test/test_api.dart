import 'package:test/test.dart';
import 'package:video_sharing_app/data/source/remote/api.dart';
import 'package:video_sharing_app/data/source/remote/api_impl.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';

void main() {
  const userId = '04497fee-f10d-49ff-9e5c-a6caec499d71';
  const videoId = '0065ea2d-ce99-45e2-bfd3-bd3c5e0c334e';

  test('Sign in', () async {
    final Api api = ApiImpl.forTest();
    final user = await api.signIn(email: 'user74@gmail.com', password: '22222222');
    expect(user != null, true);
  });

  test('Sign up', () async {
    final Api api = ApiImpl.forTest();
    final user = await api.signUp(email: '', password: '');
    expect(user != null, false);
  });

  test('Fetch recommend videos', () async {
    final Api api = ApiImpl.forTest();
    final recommendedVideos = await api.fetchRecommendVideos(userId: userId);
    expect(recommendedVideos.length, 3);
  });

  test('Fetch video by ID', () async {
    final Api api = ApiImpl.forTest();
    final video = await api.fetchVideoById(videoId: videoId);
    expect(video != null, true);
  });

  // TODO: Test viewVideo()

  test('Fetch hashtags', () async {
    final Api api = ApiImpl.forTest();
    final hashtags = await api.fetchHashtags(userId: userId);
    expect(hashtags.length, 4);
  });

  // TODO: Test uploadVideo()

  test('Fetch related videos', () async {
    final Api api = ApiImpl.forTest();
    final relatedVideo = await api.fetchRelatedVideos(videoId: videoId, userId: userId);
    expect(relatedVideo.length, 3);
  });

  test('Fetch video rating', () async {
    final Api api = ApiImpl.forTest();
    final videoRating = await api.fetchVideoRating(videoId: videoId, userId: userId);
    expect(videoRating.rating, Rating.none);
  });

  test('Fetch most like comment', () async {
    final Api api = ApiImpl.forTest();
    final comment = await api.fetchMostLikeComment(videoId: videoId);
    expect(comment != null, true);
    expect(comment!.content, 'Good video');
  });

  // TODO: Ordering with 'Fetch video rating' test
  test('Rate video', () async {
    // final Api api = ApiImpl.forTest();
    // final result = await api.rateVideo(videoId: videoId, userId: userId, rating: 'none');
    // expect(result, true);
  });
}
