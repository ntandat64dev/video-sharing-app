import 'dart:async';

import 'package:video_sharing_app/domain/entity/user.dart';

abstract class UserRepository {
  Future<User?> changeProfileImage({required String imageLocalPath});

  Future<User?> getUserInfo({String? userId});

  String? getMyId();

  String? getMyImageUrl();
}
