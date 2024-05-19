import 'dart:math';

import 'package:video_sharing_app/domain/entity/follow.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/repository/follow_repository.dart';

class FakeFollowRepositoryImpl implements FollowRepository {
  FakeFollowRepositoryImpl() {
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

  final follows = <Follow>[];

  @override
  Future<PageResponse<Follow>> getFollows([Pageable? pageable]) async {
    return PageResponse(
      pageNumber: 0,
      pageSize: follows.length,
      totalElements: follows.length,
      totalPages: 1,
      items: follows,
    );
  }

  @override
  Future<Follow?> getFollowFor(String userId) async {
    return follows[0];
  }

  @override
  Future<Follow?> follow(Follow follow) async {
    return follows[0];
  }

  @override
  Future<bool> unFollow(String followId) async {
    return true;
  }
}
