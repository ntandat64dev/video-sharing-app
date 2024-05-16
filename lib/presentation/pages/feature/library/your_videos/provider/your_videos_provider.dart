import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:video_sharing_app/domain/entity/video.dart';

class YourVideosProvider extends ChangeNotifier {
  late final PagingController<int, Video> pagingController;

  YourVideosProvider(this.pagingController);

  void reload() {
    pagingController.refresh();
  }
}
