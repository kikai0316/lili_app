import 'package:flutter/material.dart';

enum CamControllerState { success, systemError, accessError, unInitialize }

enum BackIconStyleType { cancelIcon, arrowBackLeftIcon, arrowBackBottomIcon }

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
