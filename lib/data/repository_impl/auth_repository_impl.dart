import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/data/source/remote/auth_api.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/repository/auth_repository.dart';
import 'package:video_sharing_app/domain/repository/notification_repository.dart';
import 'package:video_sharing_app/service/firebase_service.dart' as firebase_service;

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required PreferencesService pref,
    required AuthApi authApi,
  })  : _prefs = pref,
        _authApi = authApi;

  late final PreferencesService _prefs;
  late final AuthApi _authApi;

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
      final jwtToken = await _authApi.signIn(username: username, password: password);
      final claims = JwtDecoder.decode(jwtToken);
      _prefs.setToken(jwtToken);
      _prefs.setUserId(claims['uid']);

      // Register FCM token.
      final fcmToken = await firebase_service.getToken();
      if (fcmToken == null) throw Exception('signIn(): Message token is null');
      final result = await getIt<NotificationRepository>().registerMessageToken(fcmToken);
      if (result == false) throw Exception('Register message token failed');

      return true;
    } catch (e) {
      _prefs.clearUser();
      return false;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      final fcmToken = await firebase_service.getToken();
      if (fcmToken == null) throw Exception('signOut(): Message token is null');
      final result = await getIt<NotificationRepository>().unregisterMessageToken(fcmToken);
      if (result == false) throw Exception('Unregister message token failed');
      _prefs.clearUser();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  bool wasUserLoggedIn() => _prefs.getToken() != null && _prefs.getUserId() != null;

  @override
  bool isFirstLaunched() => _prefs.isFirstLaunched;

  @override
  void markFirstLaunched() => _prefs.isFirstLaunched = true;
}
