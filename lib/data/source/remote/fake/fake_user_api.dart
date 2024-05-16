import 'dart:math';

import 'package:video_sharing_app/data/source/remote/user_api.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/entity/user.dart';

class FakeUserApi extends UserApi {
  final users = <User>[];

  FakeUserApi({required super.token}) {
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

  @override
  Future<User> getMyInfo() async {
    return users[0];
  }

  @override
  Future<User> getUserByUserId(String userId) async {
    return users[0];
  }
}
