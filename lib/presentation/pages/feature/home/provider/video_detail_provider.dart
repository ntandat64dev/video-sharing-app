import 'package:flutter/material.dart';
import 'package:video_sharing_app/data/repository_impl/comment_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/follow_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/user_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/video_repository_impl.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/follow.dart';
import 'package:video_sharing_app/domain/entity/user.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';
import 'package:video_sharing_app/domain/repository/comment_repository.dart';
import 'package:video_sharing_app/domain/repository/follow_repository.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';

class VideoDetailProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepositoryImpl();
  final FollowRepository _followRepository = FollowRepositoryImpl();
  final VideoRepository _videoRepository = VideoRepositoryImpl();
  final CommentRepository _commentRepository = CommentRepositoryImpl();

  late Video _initVideo;

  late Video _video;
  late VideoRating _videoRating;
  late Follow? _follow;
  late User _user;

  var _isDetailLoaded = false;

  VideoDetailProvider(Video video) {
    _initVideo = video;
    Future.wait([
      _videoRepository.getVideoById(_initVideo.id!),
      _videoRepository.getVideoRating(_initVideo.id!),
      _followRepository.getFollowFor(_initVideo.userId!),
      _userRepository.getUserInfo(userId: _initVideo.userId!)
    ]).then((value) {
      _video = value[0] as Video;
      _videoRating = value[1] as VideoRating;
      _follow = value[2] as Follow?;
      _user = value[3] as User;

      _isDetailLoaded = true;
      notifyListeners();
    });
  }

  Future<void> rateVideo(Rating rate) async {
    final rating = videoRating.rating == rate ? Rating.none : rate;
    var ratingResult = await _videoRepository.rateVideo(videoId: _initVideo.id!, rating: rating);
    if (ratingResult != null) {
      _videoRating = ratingResult;
      _video = (await _videoRepository.getVideoById(_initVideo.id!)) as Video;
      notifyListeners();
    }
  }

  Future<void> followUser() async {
    if (follow != null) {
      // Delete follow.
      final result = await _followRepository.unFollow(follow!.id!);
      if (result) _follow = null;
    } else {
      // Post follow.
      final follow = Follow.post(userId: video.userId, followerId: null);
      await _followRepository.follow(follow);
    }

    await onFollowUpdated();
  }

  Future<void> sendComment(String text) async {
    final comment = Comment.post(
      videoId: video.id!,
      authorId: null,
      text: text,
    );
    await _commentRepository.postComment(comment);
    await onSentComment();
  }

  onFollowUpdated() async {
    _follow = await _followRepository.getFollowFor(_initVideo.userId!);
    _user = (await _userRepository.getUserInfo(userId: _initVideo.userId)) as User;
    notifyListeners();
  }

  onSentComment() async {
    _video = (await _videoRepository.getVideoById(_initVideo.id!)) as Video;
    notifyListeners();
  }

  Video get video => _video;
  VideoRating get videoRating => _videoRating;
  Follow? get follow => _follow;
  User get user => _user;

  bool get isDetailLoaded => _isDetailLoaded;
}
