import 'package:flutter/material.dart';
import 'package:video_sharing_app/data/repository_impl/video_repository_impl.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';

class YourVideosProvider extends ChangeNotifier {
  final VideoRepository videoRepository = VideoRepositoryImpl();

  late List<Video> _videos;
  bool _loading = false;

  YourVideosProvider() {
    _loadVideos();
  }

  void reload() {
    _loadVideos();
  }

  void _loadVideos() {
    _loading = true;
    notifyListeners();
    videoRepository.getMyVideos().then((value) {
      _videos = value;
      _loading = false;
      notifyListeners();
    });
  }

  List<Video> get videos => _videos;
  bool get loading => _loading;
}
