import 'dart:math';

import 'package:video_sharing_app/data/source/remote/follow_api.dart';
import 'package:video_sharing_app/domain/entity/follow.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';

class FakeFollowApi extends FollowApi {
  final follows = <Follow>[];

  FakeFollowApi({required super.token}) {
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

  @override
  Future<PageResponse<Follow>> getMyFollows(Pageable pageable) async {
    return PageResponse(
      pageNumber: 0,
      pageSize: 10,
      totalElements: 10,
      totalPages: 1,
      items: follows,
    );
  }

  @override
  Future<Follow> getFollowsForUserId(String userId) async {
    return follows[0];
  }

  @override
  Future<Follow> postFollow(Follow follow) async {
    return follows[0];
  }

  @override
  Future<void> deleteFollow(String followId) async {}
}
