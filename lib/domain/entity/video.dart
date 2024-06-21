import 'package:video_sharing_app/domain/entity/category.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';

class Video {
  Video({
    required this.id,
    required this.publishedAt,
    required this.userId,
    required this.username,
    required this.userImageUrl,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnails,
    required this.hashtags,
    required this.duration,
    required this.location,
    required this.category,
    required this.privacy,
    required this.madeForKids,
    required this.ageRestricted,
    required this.commentAllowed,
    required this.viewCount,
    required this.likeCount,
    required this.dislikeCount,
    required this.commentCount,
    required this.downloadCount,
  });

  Video.post({
    required this.userId,
    required this.title,
    required this.description,
    required this.hashtags,
    required this.duration,
    required this.location,
    required this.category,
    required this.privacy,
    required this.madeForKids,
    required this.ageRestricted,
    required this.commentAllowed,
  });

  Video.playlistItem({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.username,
    required this.videoUrl,
    required this.thumbnails,
    required this.duration,
  });

  String? id;
  DateTime? publishedAt;
  String? userId;
  String? username;
  String? userImageUrl;
  String? title;
  String? description;
  String? videoUrl;
  Map<String, Thumbnail>? thumbnails;
  List<String>? hashtags;
  String? duration;
  String? location;
  Category? category;
  String? privacy;
  bool? madeForKids;
  bool? ageRestricted;
  bool? commentAllowed;
  BigInt? viewCount;
  BigInt? likeCount;
  BigInt? dislikeCount;
  BigInt? commentCount;
  BigInt? downloadCount;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json['id'],
        publishedAt: DateTime.parse(json['snippet']['publishedAt']),
        userId: json['snippet']['userId'],
        username: json['snippet']['username'],
        userImageUrl: json['snippet']['userImageUrl'],
        title: json['snippet']['title'],
        description: json['snippet']['description'],
        videoUrl: json['snippet']['videoUrl'],
        thumbnails: (json['snippet']['thumbnails'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, Thumbnail.fromJson(value))),
        hashtags: (json['snippet']['hashtags'] as List<dynamic>).map<String>((e) => e.toString()).toList(),
        duration: json['snippet']['duration'],
        location: json['snippet']['location'],
        category: Category.fromJson(json['snippet']['category']),
        privacy: json['status']['privacy'],
        madeForKids: json['status']['madeForKids'],
        ageRestricted: json['status']['ageRestricted'],
        commentAllowed: json['status']['commentAllowed'],
        viewCount: BigInt.from(json['statistic']['viewCount']),
        likeCount: BigInt.from(json['statistic']['likeCount']),
        dislikeCount: BigInt.from(json['statistic']['dislikeCount']),
        commentCount: BigInt.from(json['statistic']['commentCount']),
        downloadCount: BigInt.from(json['statistic']['downloadCount']),
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
          'videoUrl': videoUrl,
          'thumbnails': thumbnails?.map((key, value) => MapEntry(key, value.toJson())),
          'hashtags': hashtags,
          'duration': duration,
          'location': location,
          'category': category?.toJson(),
        },
        'status': {
          'privacy': privacy,
          'madeForKids': madeForKids,
          'ageRestricted': ageRestricted,
          'commentAllowed': commentAllowed,
        },
        'statistic': {
          'viewCount': viewCount?.toInt(),
          'likeCount': likeCount?.toInt(),
          'dislikeCount': dislikeCount?.toInt(),
          'commentCount': commentCount?.toInt(),
          'downloadCount': downloadCount?.toInt(),
        }
      };

  static Video fromJsonModel(Map<String, dynamic> json) => Video.fromJson(json);
}
