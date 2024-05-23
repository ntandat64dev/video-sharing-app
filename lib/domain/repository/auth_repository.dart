abstract class AuthRepository {
  Future<bool> signUp({required String username, required String password});

  Future<bool> signIn({required String username, required String password});

  Future<bool> signOut();

  bool wasUserLoggedIn();

  bool isFirstLaunched();

  void markFirstLaunched();
}
