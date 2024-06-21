extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

extension DurationExtension on Duration {
  static const _hoursInDays = 24;
  static const _minutesInHours = 60;
  static const _secondsInMinutes = 60;

  String toIsoString() {
    final days = inDays.toInt();
    final hours = (inHours % _hoursInDays).toInt();
    final minutes = (inMinutes % _minutesInHours).toInt();
    final seconds = (inSeconds % _secondsInMinutes);
    return 'P${days}DT${hours}H${minutes}M${seconds}S';
  }
}
