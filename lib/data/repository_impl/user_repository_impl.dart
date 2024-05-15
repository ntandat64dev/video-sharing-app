import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/data/source/remote/user_api.dart';
import 'package:video_sharing_app/domain/entity/user.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final _prefs = PreferencesService.getInstance();

  late final UserApi _userApi;

  UserRepositoryImpl() {
    final token = _prefs.getToken();
    if (token == null) throw Exception('Cannot instantiate UserRepositoryImpl because token is null');

    _userApi = UserApi(token: token);
  }

  @override
  Future<User?> getUserInfo({String? userId}) async {
    try {
      return userId == null ? await _userApi.getMyInfo() : await _userApi.getUserByUserId(userId);
    } catch (e) {
      return null;
    }
  }
}
