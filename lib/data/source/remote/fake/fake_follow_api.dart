import 'dart:math';

import 'package:video_sharing_app/domain/entity/follow.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';

class FakeFollowApi {
  final follows = <Follow>[];

  FakeFollowApi() {
    for (int i = 0; i < 10; i++) {
      final follow = Follow(
        id: Random().nextInt(16).toRadixString(16),
        publishedAt: DateTime.now(),
        userId: Random().nextInt(16).toRadixString(16),
        username: 'Fake User',
        userThumbnails: {
          Thumbnail.kDefault: const Thumbnail(
            url:
                'https://ui-avatars.com/api/?name=Fake+User&size=500&background=0D8ABC&color=fff&rouded=true&bold=true',
            width: 500,
            height: 500,
          )
        },
        followerId: Random().nextInt(16).toRadixString(16),
        followerThumbnails: {
          Thumbnail.kDefault: const Thumbnail(
            url:
                'https://ui-avatars.com/api/?name=Fake+User&size=500&background=0D8ABC&color=fff&rouded=true&bold=true',
            width: 500,
            height: 500,
          )
        },
      );
      follows.add(follow);
    }
  }

  Future<List<Follow>> getMyFollows() async {
    return follows;
  }

  Future<Follow> getFollowsForUserId(String userId) async {
    return follows[0];
  }

  Future<Follow> postFollow(Follow follow) async {
    return follows[0];
  }

  Future<void> deleteFollow(String followId) async {}
}
