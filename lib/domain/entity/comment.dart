class Comment {
  const Comment({
    required this.id,
    required this.content,
    required this.parentId,
    required this.commentedAt,
    required this.userId,
    required this.videoId,
  });

  final String id;
  final String content;
  final String? parentId;
  final DateTime commentedAt;
  final String userId;
  final String videoId;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'],
        content: json['content'],
        parentId: json['parentId'],
        commentedAt: DateTime.parse(json['commentedAt']),
        userId: json['commentedBy'],
        videoId: json['videoId'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'parentId': parentId,
        'commentedAt': commentedAt,
        'userId': userId,
        'videoId': videoId,
      };
}
