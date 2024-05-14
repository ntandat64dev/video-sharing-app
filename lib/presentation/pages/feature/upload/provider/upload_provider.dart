import 'package:flutter/material.dart';
import 'package:video_sharing_app/data/repository_impl/video_repository_impl.dart';
import 'package:video_sharing_app/domain/entity/category.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:video_thumbnail/video_thumbnail.dart';

class UploadProvider extends ChangeNotifier {
  final VideoRepository _videoRepository = VideoRepositoryImpl();

  UploadProvider({required String videoPath}) {
    _videoPath = videoPath;

    // Generate thumbnail image path from video path.
    syspaths.getTemporaryDirectory().then((tempDir) => {
          VideoThumbnail.thumbnailFile(
            video: videoPath,
            thumbnailPath: tempDir.path,
            imageFormat: ImageFormat.JPEG,
          ).then((filePath) {
            if (filePath != null) {
              _thumbnailPath = filePath;
              notifyListeners();
            }
          })
        });
  }

  String? _thumbnailPath;
  String? _videoPath;

  final Video _video = Video.post(
    userId: null, // Repository will set userId
    title: null,
    description: null,
    hashtags: [],
    location: null,
    category: null,
    privacy: 'public',
    madeForKids: false,
    ageRestricted: false,
    commentAllowed: true,
  );

  Future<void> uploadVideo() async {
    _validateVideo();
    final result = await _videoRepository.uploadVideo(
      videoPath: _videoPath!,
      thumbnailPath: thumbnailPath!,
      video: _video,
    );
    if (result == null) throw Exception('Cannot upload video!');
  }

  void updateVideoDetails(Function(Video video) onUpdate) {
    onUpdate(_video);
    notifyListeners();
  }

  void setThumbnailPath(String path) {
    _thumbnailPath = path;
    notifyListeners();
  }

  void _validateVideo() {
    if (_video.title == null || _video.title!.trim().isEmpty) throw Exception('Video title can not be null.');
    if (_video.hashtags == null) throw Exception('Video hashtags can not be null.');
    if (_video.privacy == null) throw Exception('Video privacy can not be null.');
    if (_video.privacy! != 'public' && _video.privacy! != 'private') {
      throw Exception('Video privacy must be either \'private\' or \'public\'.');
    }
    if (_video.madeForKids == null) throw Exception('Video madeForKids can not be null.');
    if (_video.ageRestricted == null) throw Exception('Video ageRestricted can not be null.');
    if (_video.madeForKids! && _video.ageRestricted!) {
      throw Exception('Video ageRestricted can not be true if madeForKids is true.');
    }
    if (_video.category == null) throw Exception('Video category can not be null.');
    if (_video.commentAllowed == null) throw Exception('Video commentAllowed can not be null.');
  }

  String? get title => _video.title;
  String? get description => _video.description;
  List<String> get hashtags => _video.hashtags!;
  String get privacy => _video.privacy!;
  bool get madeForKids => _video.madeForKids!;
  bool get ageRestricted => _video.ageRestricted!;
  bool get commentAllowed => _video.commentAllowed!;
  String? get location => _video.location;
  Category? get category => _video.category;

  String? get thumbnailPath => _thumbnailPath;
}
