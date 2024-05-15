import 'package:video_sharing_app/domain/entity/follow.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';

abstract class FollowRepository {
  Future<PageResponse<Follow>> getFollows([Pageable? pageable]);

  Future<Follow?> getFollowFor(String userId);

  Future<Follow?> follow(Follow follow);

  Future<bool> unFollow(String followId);
}
