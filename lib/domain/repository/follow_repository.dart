import 'package:video_sharing_app/domain/entity/follow.dart';

abstract class FollowRepository {
  Future<List<Follow>> getFollows();

  Future<Follow?> getFollowFor(String userId);

  Future<Follow?> follow(Follow follow);

  Future<bool> unFollow(String followId);
}
