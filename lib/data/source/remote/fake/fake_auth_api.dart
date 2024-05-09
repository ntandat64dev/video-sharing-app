class FakeAuthApi {
  Future<void> signUp({required String username, required String password}) async {}

  Future<String> signIn({required String username, required String password}) async {
    return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJ1aWQiOiIxMjM0NTY3OCJ9.ieXXRN1hMxAPshOm6MH-e-Os6zUmRTPlHTbANpDgOBc';
  }
}
