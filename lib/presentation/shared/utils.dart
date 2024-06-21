import 'package:intl/intl.dart';

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

  if (duration.inHours > 0) {
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  } else if (duration.inMinutes > 0) {
    return '$twoDigitMinutes:$twoDigitSeconds';
  } else {
    return '00:$twoDigitSeconds';
  }
}

String formatIsoDuration(String isoDuration) {
  String duration = isoDuration.replaceFirst('PT', '');

  int hours = 0, minutes = 0, seconds = 0;

  if (duration.contains('H')) {
    var parts = duration.split('H');
    hours = int.parse(parts[0]);
    duration = parts[1];
  }

  if (duration.contains('M')) {
    var parts = duration.split('M');
    minutes = int.parse(parts[0]);
    duration = parts[1];
  }

  if (duration.contains('S')) {
    var parts = duration.split('S');
    seconds = int.parse(parts[0]);
  }

  if (hours > 0) {
    return '${NumberFormat('00').format(hours)}:${NumberFormat('00').format(minutes)}:${NumberFormat('00').format(seconds)}';
  } else {
    return '${NumberFormat('00').format(minutes)}:${NumberFormat('00').format(seconds)}';
  }
}
