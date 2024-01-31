import 'package:flutter/material.dart';

enum CamControllerState { success, systemError, accessError, unInitialize }

enum BackIconStyleType { cancelIcon, arrowBackLeftIcon, arrowBackBottomIcon }

class UserType {
  String? profileImg;
  String name;
  String id;
  PostListType postList;
  String? toDayMood;
  UserType(
      {required this.name,
      required this.id,
      required this.profileImg,
      required this.postList,
      this.toDayMood,});
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
