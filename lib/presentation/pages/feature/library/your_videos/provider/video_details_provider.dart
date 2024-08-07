import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/entity/category.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';

class VideoDetailsProvider extends ChangeNotifier {
  final _videoRepository = getIt<VideoRepository>();

  VideoDetailsProvider(Video video) : _video = video..privacy = video.privacy!.toLowerCase() {
    // Download thumbnail image then write to temp file.
    final thumbnailUrl = video.thumbnails![Thumbnail.kDefault]!.url;
    Future.wait([http.get(Uri.parse(thumbnailUrl)), syspaths.getTemporaryDirectory()]).then((value) {
      final thumbnailResponse = value[0] as http.Response;
      final thumbnailBytes = thumbnailResponse.bodyBytes;
      final tempDir = value[1] as Directory;
      final thumbnailFile = File('${tempDir.path}/thumbnail');
      thumbnailFile.createSync();
      thumbnailFile.writeAsBytesSync(thumbnailBytes);
      _thumbnailPath = thumbnailFile.path;
      notifyListeners();
    });
  }

  String? _thumbnailPath;
  final Video _video;

  Future<Video?> updateVideo() async {
    _validateVideo();
    return await _videoRepository.updateVideo(
      thumbnailPath: thumbnailPath,
      video: _video,
    );
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
    if (_video.title == null || _video.title!.trim().isEmpty) throw Exception('be null.');
    if (_video.hashtags == null) throw Exception('be null.');
    if (_video.privacy == null) throw Exception('be null.');
    if (_video.privacy! != 'public' && _video.privacy! != 'private') {
      throw Exception('or \'public\'.');
    }
    if (_video.madeForKids == null) throw Exception('be null.');
    if (_video.ageRestricted == null) throw Exception('be null.');
    if (_video.madeForKids! && _video.ageRestricted!) {
      throw Exception('is true.');
    }
    if (_video.category == null) throw Exception('be null.');
    if (_video.commentAllowed == null) throw Exception('be null.');
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
