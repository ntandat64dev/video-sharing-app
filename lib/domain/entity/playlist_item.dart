import 'package:video_sharing_app/domain/entity/thumbnail.dart';

class PlaylistItem {
  PlaylistItem({
    required this.playlistId,
    required this.videoId,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnails,
    required this.priority,
    required this.videoOwnerUsername,
    required this.videoOwnerUserId,
    required this.duration,
  });

  PlaylistItem.post({
    required this.playlistId,
    required this.videoId,
  });

  String? playlistId;
  String? videoId;
  String? title;
  String? description;
  String? videoUrl;
  Map<String, Thumbnail>? thumbnails;
  int? priority;
  String? videoOwnerUsername;
  String? videoOwnerUserId;
  String? duration;

  factory PlaylistItem.fromJson(Map<String, dynamic> json) => PlaylistItem(
        playlistId: json['snippet']['playlistId'],
        videoId: json['snippet']['videoId'],
        title: json['snippet']['title'],
        description: json['snippet']['description'],
        videoUrl: json['snippet']['videoUrl'],
        priority: json['snippet']['priority'],
        videoOwnerUsername: json['snippet']['videoOwnerUsername'],
        videoOwnerUserId: json['snippet']['videoOwnerUserId'],
        thumbnails: (json['snippet']['thumbnails'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, Thumbnail.fromJson(value))),
        duration: json['contentDetails']['duration'],
      );

  Map<String, dynamic> toJson() => {
        'snippet': {
          'playlistId': playlistId,
          'videoId': videoId,
          'title': title,
          'description': description,
          'videoUrl': videoUrl,
          'priority': priority,
          'videoOwnerUsername': videoOwnerUsername,
          'videoOwnerUserId': videoOwnerUserId,
          'thumbnails': thumbnails?.map((key, value) => MapEntry(key, value.toJson())),
        },
        'contentDetails': {
          'duration': duration,
        }
      };

  static PlaylistItem fromJsonModel(Map<String, dynamic> json) => PlaylistItem.fromJson(json);
}
