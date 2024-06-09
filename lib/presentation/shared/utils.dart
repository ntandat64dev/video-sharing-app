String formatDuration(Duration duration) {
  int minutes = duration.inMinutes;
  int seconds = duration.inSeconds % 60;
  return '${minutes.toString()}:${seconds.toString().padLeft(2, '0')}';
}
