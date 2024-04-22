import 'package:test/test.dart';
import 'package:video_sharing_app/data/source/remote/api.dart';
import 'package:video_sharing_app/data/source/remote/api_impl.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';

void main() {
  const userId = '2fd56dd0-8098-4b7a-9327-a01a21ee7c9d';
  const videoId = '03fc7379-ee27-4a6d-8dad-891c7644a746';

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
    expect(recommendedVideos.length, 3);
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
    expect(relatedVideo.length, 3);
  });

  test('Get video categories', () async {
    final Api api = ApiImpl.forTest();
    final categories = await api.getVideoCategories(userId: userId);
    expect(categories.length, 2);
  });

  test('Get comments by video ID', () async {
    final Api api = ApiImpl.forTest();
    final List<Comment> comments = await api.getCommentsByVideoId(videoId: videoId);
    expect(comments.length, 7);
  });

  test('Get top level comment', () async {
    final Api api = ApiImpl.forTest();
    final comment = await api.getTopLevelComment(videoId: videoId);
    expect(comment != null, true);
    expect(comment!.text, 'Great video!');
  });

  test('Post comment', () async {
    final Api api = ApiImpl.forTest();
    final comment = await api.postComment(
      comment: Comment.post(
        videoId: videoId,
        authorId: userId,
        text: 'Great video!',
      ),
    );
    expect(comment.text, 'Great video!');
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
