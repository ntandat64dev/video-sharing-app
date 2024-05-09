import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/data/source/remote/fake/fake_user_api.dart';
import 'package:video_sharing_app/domain/entity/user.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final _prefs = PreferencesService.getInstance();

  late final FakeUserApi _userApi;

  UserRepositoryImpl() {
    final token = _prefs.getToken();
    if (token == null) throw Exception('Cannot instantiate UserRepositoryImpl because token is null');

    _userApi = FakeUserApi();
  }

   @override
  Future<User?> getUserInfo({String? userId}) async {
    try {
      return userId == null ? _userApi.getMyInfo() : _userApi.getUserByUserId(userId);
    } catch (e) {
      return null;
    }
  }
}
