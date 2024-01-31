import 'package:flutter/material.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';

PreferredSizeWidget? addFriendAppBar(BuildContext context) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return nAppBar(
    context,
    title: "友達を探す",
    leftIconType: null,
    customRightIcon: nContainer(
      alignment: Alignment.centerRight,
      width: safeAreaWidth * 0.11,
      child: CustomAnimatedOpacityButton(
        onTap: () => Navigator.pop(context),
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
          size: safeAreaWidth / 11,
        ),
      ),
    ),
  );
}
