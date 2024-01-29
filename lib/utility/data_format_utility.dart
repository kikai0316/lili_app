bool isTimePassed(String timeString) {
  final DateTime now = DateTime.now();
  final List<String> parts = timeString.split(':');
  final int hour = int.parse(parts[0]);
  final int minute = int.parse(parts[1]);
  final DateTime timeToCheck =
      DateTime(now.year, now.month, now.day, hour, minute);
  return now.isAfter(timeToCheck);
}
