class Comment {
  Comment({
    required this.id,
    required this.videoId,
    required this.authorId,
    required this.authorDisplayName,
    required this.authorProfileImageUrl,
    required this.text,
    required this.parentId,
    required this.publishedAt,
    required this.updatedAt,
    required this.likeCount,
    required this.dislikeCount,
    required this.replyCount,
  });

  Comment.post({
    required this.videoId,
    required this.authorId,
    required this.text,
  });

  String? id;
  String? videoId;
  String? authorId;
  String? authorDisplayName;
  String? authorProfileImageUrl;
  String? text;
  String? parentId;
  DateTime? publishedAt;
  DateTime? updatedAt;
  BigInt? likeCount;
  BigInt? dislikeCount;
  BigInt? replyCount;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'],
        videoId: json['snippet']['videoId'],
        authorId: json['snippet']['authorId'],
        authorDisplayName: json['snippet']['authorDisplayName'],
        authorProfileImageUrl: json['snippet']['authorProfileImageUrl'],
        text: json['snippet']['text'],
        parentId: json['snippet']['parentId'],
        publishedAt: DateTime.parse(json['snippet']['publishedAt']),
        updatedAt: json['snippet']['updatedAt'] != null ? DateTime.parse(json['snippet']['updatedAt']) : null,
        likeCount: BigInt.from(json['statistic']['likeCount']),
        dislikeCount: BigInt.from(json['statistic']['dislikeCount']),
        replyCount: BigInt.from(json['statistic']['replyCount']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'snippet': {
          'videoId': videoId,
          'authorId': authorId,
          'authorDisplayName': authorDisplayName,
          'authorProfileImageUrl': authorProfileImageUrl,
          'text': text,
          'parentId': parentId,
          'publishedAt': publishedAt,
          'updatedAt': updatedAt,
        },
        'likeCount': likeCount,
        'dislikeCount': dislikeCount,
        'replyCount': replyCount,
      };

  static Comment fromJsonModel(Map<String, dynamic> json) => Comment.fromJson(json);
}
