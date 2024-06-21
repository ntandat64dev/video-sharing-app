import 'package:video_sharing_app/domain/repository/auth_repository.dart';

class FakeAuthRepositoryImpl implements AuthRepository {
  @override
  Future<String?> signUp({required String username, required String password}) async {
    return null;
  }

  @override
  Future<String?> signIn({required String username, required String password}) async {
    return null;
  }

  @override
  bool wasUserLoggedIn() => true;

  @override
  Future<bool> signOut() async => true;

  @override
  bool isFirstLaunched() => true;

  @override
  void markFirstLaunched() {}
}
