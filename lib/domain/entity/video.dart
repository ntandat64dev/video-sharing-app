import 'package:video_sharing_app/domain/entity/user.dart';

class Video {
  const Video({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.user,
  });

  final int id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;
  final User user;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        thumbnailUrl: json['thumbnailUrl'] ?? '',
        videoUrl: json['videoUrl'] ?? '',
        user: User.fromJson(json['user']),
      );
}
