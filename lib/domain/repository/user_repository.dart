import 'dart:async';

import 'package:video_sharing_app/domain/entity/user.dart';

abstract class UserRepository {
  Future<User?> getUserInfo({String? userId});
}
