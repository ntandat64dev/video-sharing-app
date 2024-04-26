import 'dart:async';

import 'package:video_sharing_app/domain/entity/follow.dart';
import 'package:video_sharing_app/domain/entity/user.dart';

abstract class UserRepository {
  Future<bool> signUp({required String email, required String password});

  Future<bool> signIn({required String email, required String password});

  Future<User?> getUserInfo({String? userId});

  Future<List<Follow>> getFollows();

  Future<Follow?> getFollowFor({required String userId});

  Future<Follow> follow({required Follow follow});

  Future<bool> unFollow({required String followId});

  void signOut();

  User? getLoggedUser();

  bool isFirstLaunch();

  void markFirstLaunch();
}
