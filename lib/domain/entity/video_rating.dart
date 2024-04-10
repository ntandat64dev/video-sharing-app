enum Rating { like, dislike, none }

class VideoRating {
  const VideoRating({
    required this.videoId,
    required this.rating,
    required this.ratedBy,
    required this.ratedAt,
  });

  final String videoId;
  final Rating rating;
  final String ratedBy;
  final DateTime? ratedAt;

  factory VideoRating.fromJson(Map<String, dynamic> json) => VideoRating(
        videoId: json['videoId'],
        rating: Rating.values.firstWhere((e) => e.name.toLowerCase() == (json['rating'] as String).toLowerCase()),
        ratedBy: json['ratedBy'],
        ratedAt: json['ratedAt'] != null ? DateTime.parse(json['ratedAt']) : null,
      );

  Map<String, dynamic> toJson() => {
        'videoId': videoId,
        'rating': rating,
        'ratedBy': ratedBy,
        'ratedAt': ratedAt,
      };
}
