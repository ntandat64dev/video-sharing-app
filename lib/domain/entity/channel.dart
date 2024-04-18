import 'package:video_sharing_app/domain/entity/thumbnail.dart';

class Channel {
  const Channel({
    required this.id,
    required this.title,
    required this.description,
    required this.publishedAt,
    required this.thumbnails,
  });

  final String id;
  final String title;
  final String? description;
  final DateTime publishedAt;
  final Map<String, Thumbnail> thumbnails;

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        id: json['id'],
        title: json['snippet']['title'],
        description: json['snippet']['description'],
        publishedAt: DateTime.parse(json['snippet']['publishedAt']),
        thumbnails: (json['snippet']['thumbnails'] as Map<String, dynamic>).map((key, value) => MapEntry(key, Thumbnail.fromJson(value))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'snippet': {
          'title': title,
          'description': description,
          'publishedAt': publishedAt.toIso8601String(),
          'thumbnails': thumbnails.map((key, value) => MapEntry(key, value.toJson())),
        }
      };
}
