import 'package:video_sharing_app/domain/entity/thumbnail.dart';

class Follow {
  Follow({
    required this.id,
    required this.publishedAt,
    required this.userId,
    required this.username,
    required this.userThumbnails,
    required this.followerId,
    required this.followerThumbnails,
  });

  Follow.post({
    required this.userId,
    required this.followerId,
  });

  String? id;
  DateTime? publishedAt;
  String? userId;
  String? username;
  Map<String, Thumbnail>? userThumbnails;
  String? followerId;
  Map<String, Thumbnail>? followerThumbnails;

  factory Follow.fromJson(Map<String, dynamic> json) => Follow(
        id: json['id'],
        publishedAt: DateTime.parse(json['snippet']['publishedAt']),
        userId: json['snippet']['userId'],
        username: json['snippet']['username'],
        userThumbnails: (json['snippet']['thumbnails'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, Thumbnail.fromJson(value))),
        followerId: json['followerSnippet']['username'],
        followerThumbnails: (json['followerSnippet']['thumbnails'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, Thumbnail.fromJson(value))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'snippet': {
          'publishedAt': publishedAt?.toIso8601String(),
          'userId': userId,
          'username': username,
          'thumbnails': userThumbnails?.map((key, value) => MapEntry(key, value.toJson())),
        },
        'followerSnippet': {
          'userId': followerId,
          'thumbnails': followerThumbnails?.map((key, value) => MapEntry(key, value.toJson())),
        }
      };
}
