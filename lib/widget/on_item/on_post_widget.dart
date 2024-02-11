import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/img.dart';
import 'package:lili_app/model/model.dart';

Widget onPostWidget(
  BuildContext context, {
  required PostType? postData,
  UserType? userData,
  required String notPostEmoji,
  required VoidCallback onTap,
  required bool isView,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return CustomAnimatedOpacityButton(
    onTap: postData != null && isView ? onTap : null,
    child: AspectRatio(
      aspectRatio: 3 / 4,
      child: imgWidget(
        borderRadius: 15,
        color: mainBackGroundColor,
        networkUrl: postData?.postImg,
        border: postData?.postImg == null
            ? mainBorder(color: subColor, width: 4)
            : null,
        child: Stack(
          children: [
            if (postData?.postImg == null)
              Align(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.no_photography,
                      color: subColor,
                      size: safeAreaWidth / 12,
                    ),
                    nText(
                      "投稿していません",
                      fontSize: safeAreaWidth / 40,
                      height: 1.5,
                      color: subColor,
                    ),
                  ],
                ),
              ),
            if (postData?.doing != null && (postData?.doing ?? "").isNotEmpty)
              Align(
                alignment: Alignment.bottomRight,
                child: textWidget(context, postData!.doing!),
              ),
            if (!isView) notViewWidget(),
            if (userData != null)
              Align(
                alignment: Alignment.topCenter,
                child: accountWidget(context, userData),
              ),
          ],
        ),
      ),
    ),
  );
}

Widget accountWidget(BuildContext context, UserType userData) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Padding(
    padding: EdgeInsets.all(safeAreaWidth * 0.02),
    child: SizedBox(
      height: safeAreaWidth * 0.06,
      child: Row(
        children: [
          Padding(
            padding: customPadding(right: safeAreaWidth * 0.015),
            child: imgWidget(
              boxShadow: mainBoxShadow(shadow: 0.1),
              size: safeAreaWidth * 0.05,
              isCircle: true,
              networkUrl: userData.img,
              assetFile: notImg(),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: nText(
                userData.userId,
                shadows: mainBoxShadow(shadow: 1),
                textAlign: TextAlign.left,
                fontSize: safeAreaWidth / 45,
                maxLiune: 2,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget textWidget(
  BuildContext context,
  String doingText,
) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Padding(
    padding: EdgeInsets.all(safeAreaWidth * 0.02),
    child: nContainer(
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
    ),
  );
}

Widget notViewWidget() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(15),
    child: BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 50.0,
        sigmaY: 50.0,
      ),
      child: nContainer(
        height: double.infinity,
        width: double.infinity,
        child: const Icon(
          Icons.visibility_off,
          color: Colors.white,
        ),
      ),
    ),
  );
}
