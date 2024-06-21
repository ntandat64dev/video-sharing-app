abstract class AuthRepository {
  Future<String?> signUp({required String username, required String password});

  Future<String?> signIn({required String username, required String password});

  Future<bool> signOut();

  bool wasUserLoggedIn();

  bool isFirstLaunched();

  void markFirstLaunched();
}
