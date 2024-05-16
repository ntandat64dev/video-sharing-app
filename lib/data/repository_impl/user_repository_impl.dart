import 'package:video_sharing_app/data/source/remote/user_api.dart';
import 'package:video_sharing_app/domain/entity/user.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required UserApi userApi}) : _userApi = userApi;
  late final UserApi _userApi;

  @override
  Future<User?> getUserInfo({String? userId}) async {
    try {
      return userId == null ? await _userApi.getMyInfo() : await _userApi.getUserByUserId(userId);
    } catch (e) {
      return null;
    }
  }
}
