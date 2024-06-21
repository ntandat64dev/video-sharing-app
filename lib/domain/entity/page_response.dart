

class PageResponse<T> {
  PageResponse({
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
    required this.items,
  });

  int pageNumber;
  int pageSize;
  int totalElements;
  int totalPages;
  List<T> items;

  factory PageResponse.empty() {
    return PageResponse(pageNumber: 0, pageSize: 0, totalElements: 0, totalPages: 0, items: []);
  }

  factory PageResponse.fromJson(Map<String, dynamic> json, Function fromJsonModel) => PageResponse<T>(
        pageNumber: json['pageNumber'],
        pageSize: json['pageSize'],
        totalElements: json['totalElements'],
        totalPages: json['totalPages'],
        items: List<T>.from(json['items'].map((itemsJson) => fromJsonModel(itemsJson))),
      );

  factory PageResponse.fromSearchJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    var itemsJson = json['items'] as List<dynamic>;
    var items = itemsJson.map((itemJson) => fromJson(itemJson)).toList();

    return PageResponse<T>(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
      items: items,
    );
  }

  Map<String, dynamic> toJson() => {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'totalElements': totalElements,
        'totalPages': totalPages,
        'items': items,
      };
}
