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

enum PostTimeType {
  wakeUp,
  am7,
  am10,
  pm12,
  pm15,
  pm18,
  pm20,
  pm22,
  pm24,
}

class UserType {
  String? img;
  String name;
  String userId;
  String openId;
  PostListType postList;
  String? toDayMood;
  String phoneNumber;
  String comment;
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
    required this.comment,
    this.img,
    this.birthday,
    this.toDayMood,
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
    final String userComment = json["user_comment"] as String? ?? "";
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
  Map<String, dynamic> toMap() {
    return {
      'wakeUp': wakeUp?.toMap(),
      'am7': am7?.toMap(),
      'am10': am10?.toMap(),
      'pm12': pm12?.toMap(),
      'pm15': pm15?.toMap(),
      'pm18': pm18?.toMap(),
      'pm20': pm20?.toMap(),
      'pm22': pm22?.toMap(),
      'pm24': pm24?.toMap(),
    };
  }

  factory PostListType.fromMap(Map<String, dynamic> map) {
    return PostListType(
      wakeUp: map['wakeUp'] != null
          ? PostType.fromMap(map['wakeUp'] as Map<String, dynamic>)
          : null,
      am7: map['am7'] != null
          ? PostType.fromMap(map['am7'] as Map<String, dynamic>)
          : null,
      am10: map['am10'] != null
          ? PostType.fromMap(map['am10'] as Map<String, dynamic>)
          : null,
      pm12: map['pm12'] != null
          ? PostType.fromMap(map['pm12'] as Map<String, dynamic>)
          : null,
      pm15: map['pm15'] != null
          ? PostType.fromMap(map['pm15'] as Map<String, dynamic>)
          : null,
      pm18: map['pm18'] != null
          ? PostType.fromMap(map['pm18'] as Map<String, dynamic>)
          : null,
      pm20: map['pm20'] != null
          ? PostType.fromMap(map['pm20'] as Map<String, dynamic>)
          : null,
      pm22: map['pm22'] != null
          ? PostType.fromMap(map['pm22'] as Map<String, dynamic>)
          : null,
      pm24: map['pm24'] != null
          ? PostType.fromMap(map['pm24'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PostType {
  String postImg;
  String? doing;
  DateTime postDateTime;
  PostType({
    required this.postImg,
    required this.doing,
    required this.postDateTime,
  });
  Map<String, dynamic> toMap() {
    return {
      'postImg': postImg,
      'doing': doing,
      'postDateTime': postDateTime.toString(),
    };
  }

  factory PostType.fromMap(Map<String, dynamic> map) {
    return PostType(
      postImg: map['postImg'] as String,
      doing: map['doing'] as String?,
      postDateTime: DateTime.parse(map['postDateTime'] as String),
    );
  }
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

class BottomMenuItemType {
  String text;
  Color? color;
  void Function() onTap;
  BottomMenuItemType({
    required this.text,
    this.color,
    required this.onTap,
  });
}
