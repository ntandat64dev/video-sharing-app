import 'package:video_sharing_app/domain/entity/channel.dart';

class Video {
  const Video({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.durationSec,
    required this.uploadDate,
    required this.isMadeForKids,
    required this.isAgeRestricted,
    required this.isCommentAllowed,
    required this.location,
    required this.hashtags,
    required this.visibility,
    required this.viewCount,
    required this.likeCount,
    required this.dislikeCount,
    required this.commentCount,
    required this.downloadCount,
    required this.userId,
    required this.channel,
  });

  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;
  final int durationSec;
  final DateTime uploadDate;
  final bool isMadeForKids;
  final bool isAgeRestricted;
  final bool isCommentAllowed;
  final String location;
  final Set<String> hashtags;
  final String visibility;
  final BigInt viewCount;
  final BigInt likeCount;
  final BigInt dislikeCount;
  final BigInt commentCount;
  final BigInt downloadCount;
  final String userId;
  final Channel channel;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        thumbnailUrl: json['thumbnailUrl'] != null ? 'http://10.0.2.2:8080${json['thumbnailUrl']}' : '',
        videoUrl: json['videoUrl'] != null ? 'http://10.0.2.2:8080${json['videoUrl']}' : '',
        durationSec: json['durationSec'] ?? '',
        uploadDate: DateTime.parse(json['uploadDate']),
        isMadeForKids: json['isMadeForKids'] ?? '',
        isAgeRestricted: json['isAgeRestricted'] ?? '',
        isCommentAllowed: json['isCommentAllowed'] ?? '',
        location: json['location'] ?? '',
        hashtags: json['hashtags'].map<String>((e) => e.toString()).toSet(),
        visibility: json['visibility'] ?? '',
        viewCount: BigInt.from(json['spec']['viewCount']),
        likeCount: BigInt.from(json['spec']['likeCount']),
        dislikeCount: BigInt.from(json['spec']['dislikeCount']),
        commentCount: BigInt.from(json['spec']['commentCount']),
        downloadCount: BigInt.from(json['spec']['downloadCount']),
        userId: json['userId'] ?? '',
        channel: Channel.fromJson(json['channel']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'thumbnailUrl': thumbnailUrl,
        'videoUrl': videoUrl,
        'durationSec': durationSec,
        'uploadDate': uploadDate.toIso8601String(),
        'isMadeForKids': isMadeForKids,
        'isAgeRestricted': isAgeRestricted,
        'isCommentAllowed': isCommentAllowed,
        'location': location,
        'hashtags': hashtags,
        'visibility': visibility,
        'viewCount': viewCount,
        'likeCount': likeCount,
        'dislikeCount': dislikeCount,
        'commentCount': commentCount,
        'downloadCount': downloadCount,
        'userId': userId,
        'channel': channel.toJson(),
      };
}
