class Pageable {
  Pageable({this.page = 0, this.size = 10, this.sort});
  int page;
  int size;
  String? sort;

  Map<String, String> toParam() => {
        'page': page.toString(),
        'size': size.toString(),
        if (sort != null) 'sort': sort!,
      };
}
