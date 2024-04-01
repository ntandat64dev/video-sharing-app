class Channel {
  const Channel({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureUrl,
    required this.joinDate,
  });

  final String id;
  final String name;
  final String description;
  final String pictureUrl;
  final DateTime joinDate;

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        pictureUrl: json['pictureUrl'] != null ? 'http://10.0.2.2:8080${json['pictureUrl']}' : '',
        joinDate: DateTime.parse(json['joinDate']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'pictureUrl': pictureUrl,
        'joinDate': joinDate.toIso8601String(),
      };
}
