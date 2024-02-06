import 'package:lili_app/model/model.dart';

List<UserType> sortPostDataList(String dateText, List<UserType> allFriends) {
  PostType? getRelevantPost(UserType user) {
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

  // リストを並べ替える
  allFriends.sort((a, b) {
    final postA = getRelevantPost(a);
    final postB = getRelevantPost(b);
    if (postA == null || postB == null) {
      if (postA == null && postB != null) {
        return 1;
      } else if (postA != null && postB == null) {
        return -1;
      } else {
        return 0;
      }
    } else {
      return postB.postDateTime.compareTo(postA.postDateTime);
    }
  });

  // 並べ替えられたリストを返す
  return allFriends;
}
