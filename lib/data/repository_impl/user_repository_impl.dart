import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/data/source/local/preferences_service_impl.dart';
import 'package:video_sharing_app/data/source/remote/api.dart';
import 'package:video_sharing_app/data/source/remote/api_impl.dart';
import 'package:video_sharing_app/domain/entity/follow.dart';
import 'package:video_sharing_app/domain/entity/user.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final PreferencesService _prefs = PreferencesServiceImpl.getInstance();
  final Api _api = ApiImpl();

  @override
  Future<bool> signUp({required String email, required String password}) async {
    final user = await _api.signUp(email: email, password: password);
    if (user == null) return false;
    _prefs.setUser(user);
    return true;
  }

  @override
  Future<bool> signIn({required String email, required String password}) async {
    final user = await _api.signIn(email: email, password: password);
    if (user == null) return false;
    _prefs.setUser(user);
    return true;
  }

  @override
  Future<User?> getUserInfo({String? userId}) => _api.getUserInfo(userId: userId ?? _prefs.getUser()!.id);

  @override
  Future<List<Follow>> getFollows() => _api.getFollows(userId: _prefs.getUser()!.id);

  @override
  Future<Follow?> getFollowFor({required String userId}) async {
    final follows = await _api.getFollows(userId: _prefs.getUser()!.id, forUserId: userId);
    if (follows.isEmpty) return null;
    return follows[0];
  }

  @override
  Future<Follow> follow({required Follow follow}) {
    follow.followerId = _prefs.getUser()!.id;
    return _api.postFollow(follow: follow);
  }

  @override
  void signOut() => _prefs.removeUser();

  @override
  User? getLoggedUser() => _prefs.getUser();

  @override
  bool isFirstLaunch() => _prefs.isFirstLaunched;

  @override
  void markFirstLaunch() => _prefs.isFirstLaunched = true;
}
