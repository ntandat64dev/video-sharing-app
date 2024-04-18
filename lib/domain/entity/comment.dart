class Comment {
  const Comment({
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

  final String id;
  final String videoId;
  final String authorId;
  final String authorDisplayName;
  final String authorProfileImageUrl;
  final String text;
  final String? parentId;
  final DateTime publishedAt;
  final DateTime? updatedAt;
  final BigInt likeCount;
  final BigInt dislikeCount;
  final BigInt replyCount;

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
}
