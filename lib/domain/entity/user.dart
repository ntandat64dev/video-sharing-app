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
        email: json['email'],
        dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth']) : null,
        phoneNumber: json['phoneNumber'],
        gender: json['gender'],
        country: json['country'],
        channel: Channel.fromJson(json['channel']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'phoneNumber': phoneNumber,
        'gender': gender,
        'country': country,
        'channel': channel.toJson(),
      };
}
