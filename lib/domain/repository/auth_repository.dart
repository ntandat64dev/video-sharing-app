abstract class AuthRepository {
  Future<bool> signUp({required String username, required String password});

  Future<bool> signIn({required String username, required String password});

  bool wasUserLoggedIn();

  void signOut();

  bool isFirstLaunched();

  void markFirstLaunched();
}
