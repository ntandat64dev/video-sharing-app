import 'package:test/test.dart';
import 'package:video_sharing_app/data/source/remote/api.dart';
import 'package:video_sharing_app/data/source/remote/api_impl.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/follow.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';

void main() {
  const userId = '23490c9e-9c50-42b6-82cb-58f010fbc73a';
  const videoId = '091e6352-2bf5-4d11-9a30-0c82d6ef4f02';

  // test('Post video', () async {
  //   final Api api = ApiImpl.forTest();
  //   expect(() async {
  //     await api.postVideo(
  //       videoLocalPath: 'videoLocalPath',
  //       video: Video.upload(
  //         publishedAt: DateTime.now(),
  //         title: 'test',
  //         description: null,
  //         hashtags: [],
  //         location: null,
  //         privacy: 'public',
  //         madeForKids: false,
  //         ageRestricted: false,
  //         commentAllowed: true,
  //       ),
  //     );
  //   }, throwsException);
  // });

  test('Post follow', () async {
    final Api api = ApiImpl.forTest();
    final follow =
        api.postFollow(follow: Follow.post(userId: userId, followerId: '5de7258a-9211-45af-ac76-fbbf5f43f245'));
    expect(follow, isNotNull);
  });

  test('Get videos by all categories', () async {
    final Api api = ApiImpl.forTest();
    final recommendedVideos = await api.getVideosByAllCategories(userId: userId);
    expect(recommendedVideos.length, 10);
  });

  test('Get video rating', () async {
    final Api api = ApiImpl.forTest();
    final videoRating = await api.getVideoRating(videoId: videoId, userId: userId);
    expect(videoRating.rating, Rating.dislike);
  });

  // test('Post video rating', () async {
  //   final Api api = ApiImpl.forTest();
  //   final result = await api.postVideoRating(videoId: videoId, userId: userId, rating: Rating.like.name);
  //   expect(result, true);

  //   final videoRating = await api.getVideoRating(videoId: videoId, userId: userId);
  //   expect(videoRating.rating, Rating.like);
  // });

  test('Get related videos', () async {
    final Api api = ApiImpl.forTest();
    final relatedVideo = await api.getRelatedVideos(videoId: videoId, userId: userId);
    expect(relatedVideo.length, 10);
  });

  test('Get video categories', () async {
    final Api api = ApiImpl.forTest();
    final categories = await api.getVideoCategories(userId: userId);
    expect(categories.length, 23);
  });

  test('Get comments by video ID', () async {
    final Api api = ApiImpl.forTest();
    final List<Comment> comments = await api.getCommentsByVideoId(videoId: videoId);
    expect(comments.length, 3);
  });

  test('Get top level comment', () async {
    final Api api = ApiImpl.forTest();
    final comment = await api.getTopLevelComment(videoId: videoId);
    expect(comment != null, true);
    expect(comment!.text, 'Good video');
  });

  // test('Post comment', () async {
  //   final Api api = ApiImpl.forTest();
  //   final comment = await api.postComment(
  //     comment: Comment.post(
  //       videoId: videoId,
  //       authorId: userId,
  //       text: 'Great video!',
  //     ),
  //   );
  //   expect(comment.text, 'Great video!');
  // });

  test('Sign in', () async {
    final Api api = ApiImpl.forTest();
    final user = await api.signIn(email: 'user1@gmail.com', password: '11111111');
    expect(user != null, true);
  });

  // test('Sign up', () async {
  //   final Api api = ApiImpl.forTest();
  //   final user = await api.signUp(email: '', password: '');
  //   expect(user == null, true);
  // });
}
