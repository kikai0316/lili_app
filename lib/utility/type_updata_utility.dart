import 'package:lili_app/model/model.dart';

UserType userTypeUpDate(
  UserType oldData, {
  bool? isImg,
  String? img,
  String? toDayMood,
  String? name,
  String? userId,
  String? comment,
  String? birthday,
  PostListType? postListType,
}) {
  return UserType(
    img: isImg == true ? img : oldData.img,
    name: name ?? oldData.name,
    userId: userId ?? oldData.userId,
    openId: oldData.openId,
    postList: postListType ?? oldData.postList,
    toDayMood: toDayMood ?? oldData.toDayMood,
    phoneNumber: oldData.phoneNumber,
    comment: comment ?? oldData.comment,
    birthday: birthday ?? oldData.birthday,
    friendList: oldData.friendList,
    friendRequestList: oldData.friendRequestList,
  );
}

PostListType postListTypeUpDate(
  PostListType oldData,
  PostTimeType postTime,
  PostType postData,
) {
  return PostListType(
    wakeUp: postTime == PostTimeType.wakeUp ? postData : oldData.wakeUp,
    am7: postTime == PostTimeType.am7 ? postData : oldData.am7,
    am10: postTime == PostTimeType.am10 ? postData : oldData.am10,
    pm12: postTime == PostTimeType.pm12 ? postData : oldData.pm12,
    pm15: postTime == PostTimeType.pm15 ? postData : oldData.pm15,
    pm18: postTime == PostTimeType.pm18 ? postData : oldData.pm18,
    pm20: postTime == PostTimeType.pm20 ? postData : oldData.pm20,
    pm22: postTime == PostTimeType.pm22 ? postData : oldData.pm22,
  );
}

PastPostListType pastPstListTypeUpDate(
  PastPostListType oldData,
  PostTimeType postTime,
  PastPostType postData,
) {
  return PastPostListType(
    wakeUp: postTime == PostTimeType.wakeUp ? postData : oldData.wakeUp,
    am7: postTime == PostTimeType.am7 ? postData : oldData.am7,
    am10: postTime == PostTimeType.am10 ? postData : oldData.am10,
    pm12: postTime == PostTimeType.pm12 ? postData : oldData.pm12,
    pm15: postTime == PostTimeType.pm15 ? postData : oldData.pm15,
    pm18: postTime == PostTimeType.pm18 ? postData : oldData.pm18,
    pm20: postTime == PostTimeType.pm20 ? postData : oldData.pm20,
    pm22: postTime == PostTimeType.pm22 ? postData : oldData.pm22,
  );
}
