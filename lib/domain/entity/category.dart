class Category {
  const Category({
    required this.id,
    required this.category,
  });

  final String id;
  final String category;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        category: json['category'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
      };
}
