import 'package:video_sharing_app/data/source/local/shared_preferences_service.dart';
import 'package:video_sharing_app/data/source/remote/api.dart';
import 'package:video_sharing_app/domain/entity/user.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final _prefs = SharedPreferencesService.getInstance();
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
  User? getLoggedUser() => _prefs.getUser();

  @override
  bool isFirstLaunch() => _prefs.isFirstLaunched;

  @override
  void markFirstLaunch() => _prefs.isFirstLaunched = true;
}
