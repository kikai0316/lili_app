// import 'package:intl/intl.dart';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:lili_app/constant/data.dart';
import 'package:lili_app/model/model.dart';

bool isTimePassed(String timeString) {
  final DateTime now = DateTime.now();
  final DateTime baseDate =
      now.hour < 3 ? DateTime(now.year, now.month, now.day - 1) : now;
  final DateTime timeToCheck =
      convertTimeStringToDateTime(timeString, baseDate);
  return now.isAfter(timeToCheck);
}

bool isAfterThreeAM(DateTime dateTime) {
  final DateTime now = DateTime.now();
  DateTime threeAMToday = DateTime(now.year, now.month, now.day, 3);
  if (now.isBefore(threeAMToday)) {
    threeAMToday = threeAMToday.subtract(const Duration(days: 1));
  }
  return dateTime.isAfter(threeAMToday);
}

List<String> pastPostDateStrings(Iterable<String> dateString) {
  final DateTime today = DateTime.now();
  final DateFormat format = DateFormat('yyyy/MM/dd');

  final List<DateTime> dates = dateString
      .map((dateStr) {
        try {
          return format.parse(dateStr);
        } catch (e) {
          return null;
        }
      })
      .where((date) => date != null && date.isBefore(today))
      .cast<DateTime>()
      .toList();
  dates.sort(
    (a, b) => a
        .difference(today)
        .inDays
        .abs()
        .compareTo(b.difference(today).inDays.abs()),
  );
  return dates.map((date) => format.format(date)).toList();
}

DateTime convertTimeStringToDateTime(String timeString, DateTime? baseDate) {
  final List<String> parts = timeString.split(':');
  final int hour = int.parse(parts[0]);
  final int minute = int.parse(parts[1]);
  final DateTime now = baseDate ?? DateTime.now();
  return DateTime(now.year, now.month, now.day, hour, minute);
}

bool isWithinPostTimeRange(DateTime dateTime) {
  for (final entry in postTimeData.entries) {
    final List<String> timeParts = entry.value.split(':');
    final int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);
    final DateTime startTime =
        DateTime(dateTime.year, dateTime.month, dateTime.day, hour, minute);
    final DateTime endTime = startTime.add(const Duration(minutes: 10));
    if (dateTime.isAfter(startTime) && dateTime.isBefore(endTime)) {
      return true;
    }
  }
  return false;
}

PostType? dataFormatUserDataToPostData(String dateText, UserType user) {
  switch (dateText) {
    case "起床":
      return user.postList.wakeUp;
    case "7:00":
      return user.postList.am7;
    case "10:00":
      return user.postList.am10;
    case "12:00":
      return user.postList.pm12;
    case "15:00":
      return user.postList.pm15;
    case "18:00":
      return user.postList.pm18;
    case "20:00":
      return user.postList.pm20;
    case "22:00":
      return user.postList.pm22;
    default:
      return null;
  }
}

// PostTimeType? dataFormatTextToPostTimeType(
//   String postTime,
// ) {
//   switch (postTime) {
//     case "起床":
//       return PostTimeType.wakeUp;
//     case "7:00":
//       return PostTimeType.am7;
//     case "10:00":
//       return PostTimeType.am10;
//     case "12:00":
//       return PostTimeType.pm12;
//     case "15:00":
//       return PostTimeType.pm15;
//     case "18:00":
//       return PostTimeType.pm18;
//     case "20:00":
//       return PostTimeType.pm20;
//     case "22:00":
//       return PostTimeType.pm22;
//     case "24:00":
//       return PostTimeType.pm24;
//     default:
//       return null;
//   }
// }

String notPostEmoji(PostType? wakeUpPost, String dateText) {
  final isWakeUpPost = wakeUpPost != null;
  switch (dateText) {
    case "起床":
      return "😴";
    case "7:00":
      return isWakeUpPost ? "😕" : "😴";
    case "10:00":
      return isWakeUpPost ? "😅" : "😴";
    case "12:00":
      return isWakeUpPost ? "😇" : "😴";
    case "15:00":
      return isWakeUpPost ? "😑" : "😴";
    case "18:00":
      return isWakeUpPost ? "😊" : "😴";
    case "20:00":
      return isWakeUpPost ? "😎" : "😴";
    case "22:00":
      return "😪";
    case "24:00":
      return "😪";
    default:
      return "😚";
  }
}

String formattedDate(DateTime dateTime) =>
    DateFormat('yyyy年M月d日EEEE', 'ja_JP').format(dateTime);

String formattedTime(DateTime dateTime) =>
    DateFormat('aah:mm', 'ja_JP').format(dateTime).toLowerCase();
String generateRandomString() {
  const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789._';
  final Random rnd = Random();
  return String.fromCharCodes(
    Iterable.generate(
      32,
      (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
    ),
  );
}

DateTime getTwentyYearsAgoJanFirst() {
  final DateTime now = DateTime.now();
  final int yearTwentyYearsAgo = now.year - 20;
  return DateTime(yearTwentyYearsAgo);
}

PostTimeType? getPostTimeType(DateTime dateTime) {
  final List<DateTime> postTimes = [
    DateTime(dateTime.year, dateTime.month, dateTime.day, 7),
    DateTime(dateTime.year, dateTime.month, dateTime.day, 10),
    DateTime(dateTime.year, dateTime.month, dateTime.day, 12),
    DateTime(dateTime.year, dateTime.month, dateTime.day, 15),
    DateTime(dateTime.year, dateTime.month, dateTime.day, 18),
    DateTime(dateTime.year, dateTime.month, dateTime.day, 20),
    DateTime(dateTime.year, dateTime.month, dateTime.day, 22),
  ];

  for (int i = 0; i < postTimes.length; i++) {
    final DateTime postTime = postTimes[i];
    final DateTime end = postTime.add(const Duration(minutes: 10));
    if (dateTime.isAtSameMomentAs(postTime) ||
        (dateTime.isAfter(postTime) && dateTime.isBefore(end))) {
      return PostTimeType.values[i + 1];
    }
  }
  return null;
}

String formatDuration(Duration duration) {
  // 時間の部分を計算
  final String twoDigitHours = duration.inHours.toString().padLeft(2, '0');
  final String twoDigitMinutes =
      duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final String twoDigitSeconds =
      duration.inSeconds.remainder(60).toString().padLeft(2, '0');

  // 1時間を超えるかどうかでフォーマットを変更
  if (duration.inHours > 0) {
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  } else {
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

List<PostTimeType> getPostTimeTypesAfterIncluding(PostTimeType postTime) {
  final List<PostTimeType> allPostTimes = List.from(PostTimeType.values);
  allPostTimes.removeAt(0);
  final int startIndex = allPostTimes.indexOf(postTime);
  return allPostTimes.sublist(startIndex);
}
