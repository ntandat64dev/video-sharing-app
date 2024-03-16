import 'package:video_sharing_app/domain/entity/video.dart';

abstract class VideoRepository {
  Future<List<Video>> getVideos();
  Future<bool> upload({required String videoPath, required String title, required String description});
}
