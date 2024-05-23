import 'package:video_sharing_app/domain/enum/rating.dart';

class CommentRating {
  CommentRating({
    required this.commentId,
    required this.userId,
    required this.rating,
    required this.publishedAt,
  });

  String commentId;
  String userId;
  Rating rating;
  DateTime? publishedAt;

  factory CommentRating.fromJson(Map<String, dynamic> json) => CommentRating(
        commentId: json['commentId'],
        userId: json['userId'],
        rating: Rating.values.firstWhere((e) => e.name.toLowerCase() == (json['rating'] as String).toLowerCase()),
        publishedAt: json['publishedAt'] != null ? DateTime.parse(json['publishedAt']) : null,
      );

  Map<String, dynamic> toJson() => {
        'commentId': commentId,
        'userId': userId,
        'rating': rating,
        'publishedAt': publishedAt,
      };

  static CommentRating fromJsonModel(Map<String, dynamic> json) => CommentRating.fromJson(json);
}
