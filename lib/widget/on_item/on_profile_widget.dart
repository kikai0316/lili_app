import 'package:flutter/material.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/img.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/screen_transition_utility.dart';
import 'package:lili_app/view/pages/fullscreen_friend_page.dart';

Widget onProfileWidget(
  BuildContext context, {
  required UserType userData,
  required UserType myProfile,
  required double size,
  required Color backgroundColor,
  bool isName = true,
}) {
  return CustomAnimatedOpacityButton(
    onTap: () => ScreenTransition(
      context,
      FullScreenFriendPage(
        userData: userData,
        myProfile: myProfile,
        friendsStateType: FriendsStateType.appUserFriended,
      ),
    ).top(),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        imgWidget(
          size: size,
          isCircle: true,
          networkUrl:
              "https://i.pinimg.com/474x/8f/9b/1a/8f9b1aac68c19c782a8e22a60a52007f.jpg",
          // userData.img,
          assetFile: notImg(),
        ),
        if (isName)
          Padding(
            padding: EdgeInsets.only(
              top: size / 10,
            ),
            child: Container(
              alignment: Alignment.center,
              width: size,
              child: nText(
                userData.userId,
                fontSize: size / 8,
                bold: 700,
              ),
            ),
          ),
      ],
    ),
  );
}
