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

  Video.upload({
    required this.publishedAt,
    required this.title,
    required this.description,
    required this.hashtags,
    required this.location,
    required this.privacy,
    required this.madeForKids,
    required this.ageRestricted,
    required this.commentAllowed,
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
        },
        'status': {
          'privacy': privacy,
          'madeForKids': madeForKids,
          'ageRestricted': ageRestricted,
          'commentAllowed': commentAllowed,
        },
        'statistic': {
          'viewCount': viewCount,
          'likeCount': likeCount,
          'dislikeCount': dislikeCount,
          'commentCount': commentCount,
          'downloadCount': downloadCount,
        }
      };
}
