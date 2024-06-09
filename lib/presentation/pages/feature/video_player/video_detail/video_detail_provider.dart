import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/comment_rating.dart';
import 'package:video_sharing_app/domain/entity/follow.dart';
import 'package:video_sharing_app/domain/entity/user.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';
import 'package:video_sharing_app/domain/enum/rating.dart';
import 'package:video_sharing_app/domain/repository/comment_repository.dart';
import 'package:video_sharing_app/domain/repository/follow_repository.dart';
import 'package:video_sharing_app/domain/repository/playlist_repository.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';

class VideoDetailProvider extends ChangeNotifier {
  final _userRepository = getIt<UserRepository>();
  final _followRepository = getIt<FollowRepository>();
  final _videoRepository = getIt<VideoRepository>();
  final _commentRepository = getIt<CommentRepository>();
  final _playlistRepository = getIt<PlaylistRepository>();

  late Video _video;
  late VideoRating _videoRating;
  late List<CommentRating> _commentRatings;
  late Follow? _follow;
  late User _user;
  late List<String> _containingPlaylistIds;

  var _isDetailLoaded = false;
  var _shouldLoadVideoDescription = false;
  var _shouldLoadComments = false;
  var _shouldUpdateComments = false;
  var _shouldUpdateReplies = false;

  VideoDetailProvider(Video initVideo) {
    _video = initVideo;
    Future.wait([
      _videoRepository.getVideoById(_video.id!),
      _videoRepository.getVideoRating(_video.id!),
      _followRepository.getFollowFor(_video.userId!),
      _userRepository.getUserInfo(userId: _video.userId!),
      _playlistRepository.getPlaylistIdsContainingVideo(_video.id!),
    ]).then((value) {
      _video = value[0] as Video;
      _videoRating = value[1] as VideoRating;
      _follow = value[2] as Follow?;
      _user = value[3] as User;
      _containingPlaylistIds = value[4] as List<String>;

      _isDetailLoaded = true;
      notifyListeners();
    });
  }

  Future<void> fetchCommentRatings() async {
    _commentRatings = (await _commentRepository.getAllCommentRatingsOfVideo(video.id!)).items;
  }

  Future<void> rateVideo(Rating rate) async {
    final rating = videoRating.rating == rate ? Rating.none : rate;
    final ratingResult = await _videoRepository.rateVideo(videoId: _video.id!, rating: rating);
    if (ratingResult != null) {
      _videoRating = ratingResult;

      // Reload video info (including like count, dislike count,...)
      _video = (await _videoRepository.getVideoById(_video.id!)) as Video;
      // Reload containingPlaylistIds
      _containingPlaylistIds = await _playlistRepository.getPlaylistIdsContainingVideo(_video.id!);
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
      final result = await _followRepository.follow(follow);
      if (result != null) _follow = result;
    }

    // Reload user info (including number of followers).
    _user = (await _userRepository.getUserInfo(userId: _video.userId)) as User;
    notifyListeners();
  }

  Future<void> sendComment(Comment comment) async {
    await _commentRepository.postComment(comment);
    // Reload video info (including comment count,...)
    _video = (await _videoRepository.getVideoById(_video.id!)) as Video;
    _shouldUpdateComments = true;
    if (comment.parentId != null) {
      _shouldUpdateReplies = true;
    }
    notifyListeners();
  }

  Future<void> rateComment(Comment comment, Rating rate) async {
    final userRating = _commentRatings.where((e) => e.commentId == comment.id).firstOrNull;
    final rating = userRating?.rating == rate ? Rating.none : rate;

    final ratingResult = await _commentRepository.rateComment(commentId: comment.id!, rating: rating);
    if (ratingResult != null) {
      _shouldUpdateComments = true;
      if (comment.parentId != null) _shouldUpdateReplies = true;
      fetchCommentRatings().then((value) => notifyListeners());
    }
  }

  Future<bool> deleteComment(Comment comment) async {
    final isDeleted = await _commentRepository.deleteById(comment.id!);
    if (isDeleted) {
      // Reload video info (including comment count,...)
      _video = (await _videoRepository.getVideoById(_video.id!)) as Video;
      _shouldUpdateComments = true;
      if (comment.parentId != null) {
        _shouldUpdateReplies = true;
      }
      notifyListeners();
    }
    return isDeleted;
  }

  void refreshPlaylists() async {
    _containingPlaylistIds = await _playlistRepository.getPlaylistIdsContainingVideo(_video.id!);
    notifyListeners();
  }

  Video get video => _video;
  VideoRating get videoRating => _videoRating;
  List<CommentRating> get commentRatings => _commentRatings;
  Follow? get follow => _follow;
  User get user => _user;
  List<String> get containingPlaylistIds => _containingPlaylistIds;

  bool get isDetailLoaded => _isDetailLoaded;

  bool get shouldLoadVideoDescription => _shouldLoadVideoDescription;
  set shouldLoadVideoDescription(value) {
    _shouldLoadVideoDescription = value;
    notifyListeners();
  }

  bool get shouldLoadComments => _shouldLoadComments;
  set shouldLoadComments(value) {
    _shouldLoadComments = value;
    fetchCommentRatings().then((value) => notifyListeners());
  }

  bool get shouldUpdateComments => _shouldUpdateComments;
  set shouldUpdateComments(value) => _shouldUpdateComments = false;

  bool get shouldUpdateReplies => _shouldUpdateReplies;
  set shouldUpdateReplies(value) => _shouldUpdateReplies = false;
}
