import 'dart:async';

import 'package:video_sharing_app/domain/entity/user.dart';

abstract class UserRepository {
  Future<bool> signUp({required String email, required String password});
  Future<bool> signIn({required String email, required String password});
  Future<bool> signOut();
  User? getLoggedUser();
  bool isFirstLaunch();
  void markFirstLaunch();
  Future<List<String>> getHasgtags();
}
