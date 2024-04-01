import 'package:video_sharing_app/data/source/remote/api.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  final Api _api = ApiImpl();

  @override
  Future<List<Video>> getVideos(String userId) async {
    return await _api.fetchRecommendVideos(userId);
  }

  @override
  Future<bool> upload({required String videoPath, required String title, required String description}) async {
    return await _api.uploadVideo(videoPath: videoPath, title: title, description: description);
  }
}
