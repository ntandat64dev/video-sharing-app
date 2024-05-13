import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/data/source/remote/auth_api.dart';
import 'package:video_sharing_app/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _prefs = PreferencesService.getInstance();

  late final AuthApi _authApi;

  AuthRepositoryImpl() {
    _authApi = AuthApi();
  }

  @override
  Future<bool> signUp({required String username, required String password}) async {
    try {
      await _authApi.signUp(username: username, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> signIn({required String username, required String password}) async {
    try {
      final token = await _authApi.signIn(username: username, password: password);
      final claims = JwtDecoder.decode(token);
      _prefs.setToken(token);
      _prefs.setUserId(claims['uid']);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  bool wasUserLoggedIn() => _prefs.getToken() != null && _prefs.getUserId() != null;

  @override
  void signOut() => _prefs.clearUser();

  @override
  bool isFirstLaunched() => _prefs.isFirstLaunched;

  @override
  void markFirstLaunched() => _prefs.isFirstLaunched = true;
}
