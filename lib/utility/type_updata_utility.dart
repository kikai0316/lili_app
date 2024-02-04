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
}) {
  return UserType(
    img: isImg == true ? img : oldData.img,
    name: name ?? oldData.name,
    userId: userId ?? oldData.userId,
    openId: oldData.openId,
    postList: oldData.postList,
    toDayMood: toDayMood ?? oldData.toDayMood,
    phoneNumber: oldData.phoneNumber,
    comment: comment ?? oldData.comment,
    birthday: birthday ?? oldData.birthday,
    friendList: oldData.friendList,
    friendRequestList: oldData.friendRequestList,
  );
}
