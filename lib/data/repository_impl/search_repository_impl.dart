import 'package:video_sharing_app/data/source/remote/search_api.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/repository/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl({required SearchApi searchApi}) : _searchApi = searchApi;

  late final SearchApi _searchApi;
  @override
  Future<PageResponse> search({required String keyword, String? sort, String? type, Pageable? pageable}) async {
    try {
      return await _searchApi.search(keyword: keyword, sort: sort, type: type, pageable: pageable ?? Pageable());
    } catch (e) {
      return PageResponse.empty();
    }
  }
}
