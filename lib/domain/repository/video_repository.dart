import 'package:video_sharing_app/domain/entity/video.dart';

abstract class VideoRepository {
  Future<List<Video>> getVideos();
}
