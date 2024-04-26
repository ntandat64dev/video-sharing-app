import 'package:video_sharing_app/domain/entity/thumbnail.dart';

class User {
  User({
    required this.id,
    required this.email,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.gender,
    required this.country,
    required this.username,
    required this.bio,
    required this.publishedAt,
    required this.thumbnails,
    required this.viewCount,
    required this.followerCount,
    required this.followingCount,
    required this.videoCount,
  });

  String id;
  String email;
  DateTime? dateOfBirth;
  String? phoneNumber;
  int? gender;
  String? country;
  String username;
  String? bio;
  DateTime publishedAt;
  Map<String, Thumbnail> thumbnails;
  BigInt? viewCount;
  BigInt? followerCount;
  BigInt? followingCount;
  BigInt? videoCount;

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      email: json['snippet']['email'],
      dateOfBirth: json['snippet']['dateOfBirth'] != null ? DateTime.parse(json['snippet']['dateOfBirth']) : null,
      phoneNumber: json['snippet']['phoneNumber'],
      gender: json['snippet']['gender'],
      country: json['snippet']['country'],
      username: json['snippet']['username'],
      bio: json['snippet']['bio'],
      publishedAt: DateTime.parse(json['snippet']['publishedAt']),
      thumbnails: (json['snippet']['thumbnails'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, Thumbnail.fromJson(value))),
      viewCount: BigInt.from(json['statistic']['viewCount']),
      followerCount: BigInt.from(json['statistic']['followerCount']),
      followingCount: BigInt.from(json['statistic']['followingCount']),
      videoCount: BigInt.from(json['statistic']['videoCount']));

  Map<String, dynamic> toJson() => {
        'id': id,
        'snippet': {
          'email': email,
          'dateOfBirth': dateOfBirth?.toIso8601String(),
          'phoneNumber': phoneNumber,
          'gender': gender,
          'country': country,
          'username': username,
          'bio': bio,
          'publishedAt': publishedAt.toIso8601String(),
          'thumbnails': thumbnails.map((key, value) => MapEntry(key, value.toJson())),
        },
        'statistic': {
          'viewCount': viewCount?.toInt(),
          'followerCount': followerCount?.toInt(),
          'followingCount': followingCount?.toInt(),
          'videoCount': videoCount?.toInt(),
        }
      };
}
