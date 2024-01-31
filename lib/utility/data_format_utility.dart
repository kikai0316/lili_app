// import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:lili_app/model/model.dart';

bool isTimePassed(String timeString) {
  final DateTime now = DateTime.now();
  final List<String> parts = timeString.split(':');
  final int hour = int.parse(parts[0]);
  final int minute = int.parse(parts[1]);
  final DateTime timeToCheck =
      DateTime(now.year, now.month, now.day, hour, minute);
  return now.isAfter(timeToCheck);
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
    case "24:00":
      return user.postList.pm24;
    default:
      return null;
  }
}

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
