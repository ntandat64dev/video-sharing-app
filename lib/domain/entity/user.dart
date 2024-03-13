class User {
  const User({
    required this.id,
    required this.email,
    required this.photoUrl,
    required this.channelName,
  });

  final int id;
  final String email;
  final String photoUrl;
  final String channelName;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      channelName: json['channelName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'photoUrl': photoUrl,
      'channelName': channelName,
    };
  }
}
