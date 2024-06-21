import 'dart:math';

import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/entity/user.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';

class FakeUserRepositoryImpl implements UserRepository {
  FakeUserRepositoryImpl() {
    for (int i = 0; i < 10; i++) {
      final user = User(
        id: Random().nextInt(16).toRadixString(16),
        email: 'fakeuser@gmail.com',
        dateOfBirth: null,
        phoneNumber: null,
        gender: null,
        country: null,
        username: 'fakeuser',
        bio: null,
        publishedAt: DateTime.now(),
        thumbnails: {
          Thumbnail.kDefault: const Thumbnail(
            url:
                'https://ui-avatars.com/api/?name=Fake+User&size=500&background=0D8ABC&color=fff&rouded=true&bold=true',
            width: 500,
            height: 500,
          )
        },
        roles: ['ROLE_USER'],
        viewCount: BigInt.zero,
        followerCount: BigInt.zero,
        followingCount: BigInt.zero,
        videoCount: BigInt.zero,
      );
      users.add(user);
    }
  }

  final users = <User>[];

  @override
  Future<User?> changeProfileImage({required String imageLocalPath}) async {
    return users[0];
  }

  @override
  Future<User?> getUserInfo({String? userId}) async {
    return users[0];
  }

  @override
  String? getMyId() => '12345678';

  @override
  String? getMyImageUrl() =>
      'https://ui-avatars.com/api/?name=Fake+User&size=500&background=0D8ABC&color=fff&rouded=true&bold=true';
}
