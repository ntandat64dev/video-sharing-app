import 'package:flutter/material.dart';
import 'package:video_sharing_app/data/repository_impl/comment_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/user_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/video_repository_impl.dart';
import 'package:video_sharing_app/domain/entity/follow.dart';
import 'package:video_sharing_app/domain/entity/user.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';
import 'package:video_sharing_app/domain/repository/comment_repository.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';

class VideoDetailProvider extends ChangeNotifier {
  final UserRepository userRepository = UserRepositoryImpl();
  final VideoRepository videoRepository = VideoRepositoryImpl();
  final CommentRepository commentRepository = CommentRepositoryImpl();

  late Video _initVideo;

  late Video _video;
  late VideoRating _videoRating;
  late Follow? _follow;
  late User _user;

  var _isDetailLoaded = false;

  VideoDetailProvider(Video video) {
    _initVideo = video;
    Future.wait([
      videoRepository.getVideoById(videoId: _initVideo.id!),
      videoRepository.getVideoRating(videoId: _initVideo.id!),
      userRepository.getFollowFor(userId: _initVideo.userId!),
      userRepository.getUserInfo(userId: _initVideo.userId)
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
    _videoRating = await videoRepository.rateVideo(videoId: _initVideo.id!, rating: rating);
    _video = (await videoRepository.getVideoById(videoId: _initVideo.id!)) as Video;
    notifyListeners();
  }

  Future<void> followUser() async {
    final follow = Follow.post(userId: video.userId, followerId: null);
    await userRepository.follow(follow: follow);
    await onFollowUpdated();
  }

  onFollowUpdated() async {
    _follow = await userRepository.getFollowFor(userId: _initVideo.userId!);
    _user = (await userRepository.getUserInfo(userId: _initVideo.userId)) as User;
    notifyListeners();
  }

  onSentComment() async {
    _video = (await videoRepository.getVideoById(videoId: _initVideo.id!)) as Video;
    notifyListeners();
  }

  Video get video => _video;
  VideoRating get videoRating => _videoRating;
  Follow? get follow => _follow;
  User get user => _user;

  bool get isDetailLoaded => _isDetailLoaded;
}
