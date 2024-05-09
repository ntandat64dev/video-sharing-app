import 'dart:math';

import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/entity/user.dart';

class FakeUserApi {
  final users = <User>[];

  FakeUserApi() {
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

  Future<User> getMyInfo() async {
    return users[0];
  }

  Future<User> getUserByUserId(String userId) async {
    return users[0];
  }
}
