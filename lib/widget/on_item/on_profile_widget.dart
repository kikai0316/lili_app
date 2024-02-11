import 'package:flutter/material.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/img.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/screen_transition_utility.dart';
import 'package:lili_app/view/pages/fullscreen_friend_page.dart';

Widget onProfileWidget(
  BuildContext context, {
  required UserType userData,
  required UserType myProfile,
  required double size,
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
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        imgWidget(
          size: size,
          isCircle: true,
          networkUrl: userData.img,
          assetFile: notImg(),
          child: userData.toDayMood != null
              ? Align(
                  alignment: const Alignment(1.1, 1.1),
                  child: nContainer(
                    padding: EdgeInsets.all(size / 30),
                    border: mainBorder(color: subColor, width: 3),
                    isCircle: true,
                    color: Colors.white,
                    child: nText(userData.toDayMood!, fontSize: size / 3),
                  ),
                )
              : null,
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
