enum Rating { like, dislike, none }

class VideoRating {
  const VideoRating({
    required this.videoId,
    required this.userId,
    required this.rating,
    required this.publishedAt,
  });

  final String videoId;
  final String userId;
  final Rating rating;
  final DateTime? publishedAt;

  factory VideoRating.fromJson(Map<String, dynamic> json) => VideoRating(
        videoId: json['videoId'],
        userId: json['userId'],
        rating: Rating.values.firstWhere((e) => e.name.toLowerCase() == (json['rating'] as String).toLowerCase()),
        publishedAt: json['publishedAt'] != null ? DateTime.parse(json['publishedAt']) : null,
      );

  Map<String, dynamic> toJson() => {
        'videoId': videoId,
        'userId': userId,
        'rating': rating,
        'publishedAt': publishedAt,
      };
}
