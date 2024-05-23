import 'package:video_sharing_app/domain/entity/thumbnail.dart';

class Notification {
  Notification({
    required this.id,
    required this.publishedAt,
    required this.thumbnails,
    required this.actorId,
    required this.actorImageUrl,
    required this.recipientId,
    required this.message,
    required this.isSeen,
    required this.isRead,
    required this.actionType,
    required this.objectType,
    required this.objectId,
  });

  String id;
  DateTime publishedAt;
  Map<String, Thumbnail> thumbnails;
  String actorId;
  String actorImageUrl;
  String recipientId;
  String message;
  bool isSeen;
  bool isRead;
  int actionType;
  String objectType;
  String objectId;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json['id'],
        publishedAt: DateTime.parse(json['snippet']['publishedAt']),
        thumbnails: (json['snippet']['thumbnails'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, Thumbnail.fromJson(value))),
        actorId: json['snippet']['actorId'],
        actorImageUrl: json['snippet']['actorImageUrl'],
        recipientId: json['snippet']['recipientId'],
        message: json['snippet']['message'],
        isSeen: json['snippet']['isSeen'],
        isRead: json['snippet']['isRead'],
        actionType: json['snippet']['actionType'],
        objectType: json['snippet']['objectType'],
        objectId: json['snippet']['objectId'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'snippet': {
          'publishedAt': publishedAt.toIso8601String(),
          'thumbnails': thumbnails.map((key, value) => MapEntry(key, value.toJson())),
          'actorId': actorId,
          'actorImageUrl': actorImageUrl,
          'recipientId': recipientId,
          'message': message,
          'isSeen': isSeen,
          'isRead': isRead,
          'actionType': actionType,
          'objectType': objectType,
          'objectId': objectId,
        },
      };

  static Notification fromJsonModel(Map<String, dynamic> json) => Notification.fromJson(json);
}
