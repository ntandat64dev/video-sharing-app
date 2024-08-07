import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/data/source/remote/follow_api.dart';
import 'package:video_sharing_app/domain/entity/follow.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/repository/follow_repository.dart';

class FollowRepositoryImpl implements FollowRepository {
  FollowRepositoryImpl({
    required PreferencesService pref,
    required FollowApi followApi,
  })  : _prefs = pref,
        _followApi = followApi;

  late final PreferencesService _prefs;
  late final FollowApi _followApi;

  @override
  Future<PageResponse<Follow>> getFollows([Pageable? pageable]) async {
    try {
      return await _followApi.getMyFollows(pageable ?? Pageable());
    } catch (e) {
      return PageResponse.empty();
    }
  }

  @override
  Future<Follow?> getFollowFor(String userId) async {
    try {
      return await _followApi.getFollowsForUserId(userId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Follow?> follow(Follow follow) async {
    try {
      follow.followerId = _prefs.getUserId();
      return await _followApi.postFollow(follow);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> unFollow(String followId) async {
    try {
      await _followApi.deleteFollow(followId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
