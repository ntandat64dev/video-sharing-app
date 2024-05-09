import 'dart:math';

import 'package:video_sharing_app/domain/entity/comment.dart';

class FakeCommentApi  {

  Future<List<Comment>> getCommentsByVideoId(String videoId) async {
    final comments = <Comment>[];
    for (int i = 0; i < 10; i++) {
      final comment = Comment(
        id: Random().nextInt(16).toRadixString(16),
        videoId: videoId,
        authorId: Random().nextInt(16).toRadixString(16),
        authorDisplayName: 'Fake User',
        authorProfileImageUrl:
            'https://ui-avatars.com/api/?name=Fake+User&size=500&background=0D8ABC&color=fff&rouded=true&bold=true',
        text: 'Comment $i',
        parentId: null,
        publishedAt: DateTime.now(),
        updatedAt: null,
        likeCount: BigInt.zero,
        dislikeCount: BigInt.zero,
        replyCount: BigInt.zero,
      );
      comments.add(comment);
    }

    return comments;
  }

  Future<Comment?> postComment(Comment comment) async {
    return Comment(
      id: Random().nextInt(16).toRadixString(16),
      videoId: comment.videoId,
      authorId: comment.authorId,
      authorDisplayName: 'Fake User',
      authorProfileImageUrl:
          'https://ui-avatars.com/api/?name=Fake+User&size=500&background=0D8ABC&color=fff&rouded=true&bold=true',
      text: comment.text,
      parentId: comment.parentId,
      publishedAt: DateTime.now(),
      updatedAt: null,
      likeCount: BigInt.zero,
      dislikeCount: BigInt.zero,
      replyCount: BigInt.zero,
    );
  }
}
