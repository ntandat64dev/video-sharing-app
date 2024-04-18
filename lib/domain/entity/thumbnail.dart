class Thumbnail {
  static const kDefault = 'DEFAULT';
  static const kMedium = 'MEDIUM';
  static const kHigh = 'HIGH';
  static const kStandard = 'STANDARD';

  const Thumbnail({
    required this.url,
    required this.width,
    required this.height,
  });

  final String url;
  final int width;
  final int height;

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
        url: json['url'],
        width: json['width'],
        height: json['height'],
      );

  Map<String, dynamic> toJson() => {
        'url': url,
        'width': width,
        'height': height,
      };
}
