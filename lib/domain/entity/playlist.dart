import 'package:video_sharing_app/domain/entity/thumbnail.dart';

class Playlist {
  Playlist({
    required this.id,
    required this.publishedAt,
    required this.userId,
    required this.username,
    required this.userImageUrl,
    required this.title,
    required this.description,
    required this.thumbnails,
    required this.privacy,
    required this.isDefaultPlaylist,
    required this.itemCount,
  });

  Playlist.post({
    required this.title,
    required this.description,
    required this.userId,
    required this.privacy,
  });

  String? id;
  DateTime? publishedAt;
  String? userId;
  String? username;
  String? userImageUrl;
  String? title;
  String? description;
  Map<String, Thumbnail>? thumbnails;
  String? privacy;
  bool? isDefaultPlaylist;
  int? itemCount;

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
        id: json['id'],
        publishedAt: DateTime.parse(json['snippet']['publishedAt']),
        userId: json['snippet']['userId'],
        username: json['snippet']['username'],
        userImageUrl: json['snippet']['userImageUrl'],
        title: json['snippet']['title'],
        description: json['snippet']['description'],
        thumbnails: (json['snippet']['thumbnails'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, Thumbnail.fromJson(value))),
        privacy: json['status']['privacy'],
        isDefaultPlaylist: json['status']['isDefaultPlaylist'],
        itemCount: json['contentDetails']['itemCount'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'snippet': {
          'publishedAt': publishedAt?.toIso8601String(),
          'userId': userId,
          'username': username,
          'userImageUrl': userImageUrl,
          'title': title,
          'description': description,
          'thumbnails': thumbnails?.map((key, value) => MapEntry(key, value.toJson())),
        },
        'status': {
          'privacy': privacy,
          'isDefaultPlaylist': isDefaultPlaylist,
        },
        'contentDetails': {
          'itemCount': itemCount,
        }
      };

  static Playlist fromJsonModel(Map<String, dynamic> json) => Playlist.fromJson(json);
}
