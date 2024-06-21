import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';

abstract class SearchRepository {
  Future<PageResponse<dynamic>> search({required String keyword, String? sort, String? type, Pageable? pageable});
}
