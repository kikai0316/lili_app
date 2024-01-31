import 'package:flutter/material.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/img.dart';
import 'package:lili_app/model/model.dart';

Widget onPostWidget(BuildContext context,
    {required PostType? postData,
    UserType? userData,
    required String notPostEmoji,
    required VoidCallback onTap,}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return CustomAnimatedOpacityButton(
    onTap: onTap,
    child: SizedBox(
      width: safeAreaWidth * 0.3,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: imgWidget(
          borderRadius: 15,
          color: subColor,
          networkUrl: postData?.postImg,
          child: Padding(
            padding: EdgeInsets.all(safeAreaWidth * 0.02),
            child: Stack(
              children: [
                if (postData?.postImg == null)
                  Align(
                    child: nText(notPostEmoji, fontSize: safeAreaWidth / 10),
                  ),
                if (userData != null)
                  Align(
                    alignment: Alignment.topCenter,
                    child: accountWidget(context, userData),
                  ),
                if (postData?.doing != null)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: textWidget(context, postData!.doing!),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget accountWidget(BuildContext context, UserType userData) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return SizedBox(
    height: safeAreaWidth * 0.06,
    child: Row(
      children: [
        Padding(
          padding: customPadding(right: safeAreaWidth * 0.015),
          child: imgWidget(
              boxShadow: mainBoxShadow(shadow: 0.8),
              size: safeAreaWidth * 0.06,
              isCircle: true,
              networkUrl: userData.profileImg,
              assetFile: notImg(userData.profileImg),),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            child: nText(
              userData.name,
              shadows: mainBoxShadow(shadow: 1),
              textAlign: TextAlign.left,
              fontSize: safeAreaWidth / 40,
              maxLiune: 2,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget textWidget(
  BuildContext context,
  String doingText,
) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return nContainer(
    padding: xPadding(
      context,
      xSize: safeAreaWidth * 0.02,
      top: safeAreaWidth * 0.01,
      bottom: safeAreaWidth * 0.01,
    ),
    color: Colors.black.withOpacity(0.6),
    radius: 50,
    child: nText(
      doingText,
      fontSize: safeAreaWidth / 50,
      textAlign: TextAlign.right,
      bold: 700,
      maxLiune: 2,
    ),
  );
}
