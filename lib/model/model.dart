import 'dart:typed_data';

import 'package:flutter/material.dart';

enum CamControllerState { success, systemError, accessError, unInitialize }

enum BackIconStyleType { cancelIcon, arrowBackLeftIcon, arrowBackBottomIcon }

enum FriendsStateType {
  notAppUser,
  appUserNoRelationship,
  appUserApplication,
  appUserReceivedApplication,
  appUserFriended,
}

class UserType {
  String? img;
  String name;
  String userId;
  String openId;
  PostListType postList;
  String? toDayMood;
  String phoneNumber;
  String? comment;
  String? birthday;
  List<String> friendList;
  List<String> friendRequestList;
  UserType({
    required this.openId,
    required this.userId,
    required this.name,
    required this.postList,
    required this.friendList,
    required this.friendRequestList,
    required this.phoneNumber,
    this.img,
    this.birthday,
    this.toDayMood,
    this.comment,
  });
  factory UserType.fromJson(
    Map<String, dynamic> json,
    String openId,
  ) {
    final String? img = json["user_img"] as String?;
    final String userId = json["user_id"] as String? ?? "";
    final String phoneNumber = json["phone_number"] as String? ?? "";
    final String userName = json["user_name"] as String? ?? "Unknown";
    final String? toDayMood = json["today_mood"] as String?;
    final String? userComment = json["user_comment"] as String?;
    final List<String> friendList =
        List<String>.from(json["friend"] as List? ?? []);
    final List<String> friendRequestList =
        List<String>.from(json["friend_request"] as List? ?? []);
    return UserType(
      name: userName,
      img: img,
      userId: userId,
      openId: openId,
      phoneNumber: phoneNumber,
      toDayMood: toDayMood,
      comment: userComment,
      postList: PostListType(),
      friendList: friendList,
      friendRequestList: friendRequestList,
    );
  }
}

class PostListType {
  PostType? wakeUp;
  PostType? am7;
  PostType? am10;
  PostType? pm12;
  PostType? pm15;
  PostType? pm18;
  PostType? pm20;
  PostType? pm22;
  PostType? pm24;

  PostListType({
    this.wakeUp,
    this.am7,
    this.am10,
    this.pm12,
    this.pm15,
    this.pm18,
    this.pm20,
    this.pm22,
    this.pm24,
  });
}

class PostType {
  String postImg;
  String dateText;
  String? doing;
  DateTime postDateTime;
  PostType({
    required this.postImg,
    required this.dateText,
    this.doing,
    required this.postDateTime,
  });
}

class NListTileItemType {
  IconData? leftIcon;
  Widget? leftImgIcon;
  String? leftTitle;
  String? dataText;
  VoidCallback? onTap;
  bool isOpacity;
  Color textColor;
  NListTileItemType({
    this.leftIcon,
    this.leftTitle,
    this.dataText,
    this.onTap,
    this.leftImgIcon,
    this.isOpacity = false,
    this.textColor = Colors.white,
  });
}

class OnContactListType {
  Uint8List? contactsImg;
  String? contactsName;
  String phoneNumber;
  UserType? userData;
  OnContactListType({
    required this.phoneNumber,
    this.contactsImg,
    this.contactsName,
    this.userData,
  });
}

class ContactListType {
  List<OnContactListType> appUserList;
  List<OnContactListType> contactUserList;

  ContactListType({
    required this.appUserList,
    required this.contactUserList,
  });
}
