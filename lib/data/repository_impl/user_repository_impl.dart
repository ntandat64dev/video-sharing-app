import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/data/source/remote/user_api.dart';
import 'package:video_sharing_app/domain/entity/user.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    required UserApi userApi,
    required PreferencesService pref,
  })  : _userApi = userApi,
        _pref = pref;

  late final UserApi _userApi;
  late final PreferencesService _pref;

  @override
  Future<User?> changeProfileImage({required String imageLocalPath}) async {
    try {
      return await _userApi.changeProfileImage(imagePath: imageLocalPath);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> getUserInfo({String? userId}) async {
    try {
      return userId == null ? await _userApi.getMyInfo() : await _userApi.getUserByUserId(userId);
    } catch (e) {
      return null;
    }
  }

  @override
  String? getMyId() => _pref.getUserId();

  @override
  String? getMyImageUrl() => _pref.getUserImageUrl();
}
