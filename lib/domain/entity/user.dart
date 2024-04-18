import 'package:video_sharing_app/domain/entity/channel.dart';

class User {
  const User({
    required this.id,
    required this.email,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.gender,
    required this.country,
    required this.channel,
  });

  final String id;
  final String email;
  final DateTime? dateOfBirth;
  final String? phoneNumber;
  final int? gender;
  final String? country;
  final Channel channel;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['snippet']['email'],
        dateOfBirth: json['snippet']['dateOfBirth'] != null ? DateTime.parse(json['snippet']['dateOfBirth']) : null,
        phoneNumber: json['snippet']['phoneNumber'],
        gender: json['snippet']['gender'],
        country: json['snippet']['country'],
        channel: Channel.fromJson(json['snippet']['channel']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'snippet': {
          'email': email,
          'dateOfBirth': dateOfBirth?.toIso8601String(),
          'phoneNumber': phoneNumber,
          'gender': gender,
          'country': country,
          'channel': channel.toJson(),
        }
      };
}
