import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/data/source/remote/auth_api.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/repository/auth_repository.dart';
import 'package:video_sharing_app/domain/repository/notification_repository.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';
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
  Future<String?> signUp({required String username, required String password}) async {
    try {
      await _authApi.signUp(username: username, password: password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<String?> signIn({required String username, required String password}) async {
    try {
      final jwtToken = await _authApi.signIn(username: username, password: password);
      final claims = JwtDecoder.decode(jwtToken);
      _prefs.setToken(jwtToken);
      _prefs.setUserId(claims['uid']);

      // Register FCM token.
      final fcmToken = await firebase_service.getToken();
      if (fcmToken == null) throw Exception('is null');
      final result = await getIt<NotificationRepository>().registerMessageToken(fcmToken);
      if (result == false) throw Exception('token failed');

      final me = await getIt<UserRepository>().getUserInfo();
      if (me == null) throw Exception('User is null');
      _prefs.setUserImageUrl(me.thumbnails[Thumbnail.kDefault]!.url);

      return null;
    } catch (e) {
      _prefs.clearUser();
      return e.toString();
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      final fcmToken = await firebase_service.getToken();
      if (fcmToken == null) throw Exception('is null');
      final result = await getIt<NotificationRepository>().unregisterMessageToken(fcmToken);
      if (result == false) throw Exception('token failed');
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
