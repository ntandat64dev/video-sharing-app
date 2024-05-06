import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/data/source/remote/follow_api.dart';
import 'package:video_sharing_app/domain/entity/follow.dart';
import 'package:video_sharing_app/domain/repository/follow_repository.dart';

class FollowRepositoryImpl implements FollowRepository {
  final _prefs = PreferencesService.getInstance();

  late final FollowApi _followApi;

  FollowRepositoryImpl() {
    final token = _prefs.getToken();
    if (token == null) throw Exception('Cannot instantiate FollowRepositoryImpl because token is null');

    _followApi = FollowApi(token: token);
  }

  @override
  Future<List<Follow>> getFollows() async {
    try {
      return await _followApi.getMyFollows();
    } catch (e) {
      return [];
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
      return _followApi.postFollow(follow);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> unFollow(String followId) async {
    try {
      _followApi.deleteFollow(followId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
