import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/screen_transition_utility.dart';
import 'package:lili_app/view/pages/fullscreen_past_post_page.dart';

Widget onPastPostdWidget(
  BuildContext context, {
  required double width,
  required String date,
  required PastPostListType? postListData,
  required bool isMini,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  final split = date.split("/");
  if (postListData == null || postListData.wakeUp == null) {
    return const SizedBox();
  }
  return CustomAnimatedOpacityButton(
    onTap: () => ScreenTransition(
      context,
      FullScreenPastPostPage(
        postListData: postListData,
      ),
    ).top(),
    child: SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: nContainer(
          padding: EdgeInsets.all(
            safeAreaWidth * 0.005,
          ),
          radius: 15,
          gradient: mainGradation(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              imgWidget(
                color: subColor,
                borderRadius: 13,
                fileData: File(
                  postListData.wakeUp!.postImgPath,
                ),
              ),
              nContainer(
                padding: xPadding(context, xSize: safeAreaWidth * 0.02),
                alignment: Alignment.center,
                radius: 15,
                color: Colors.black.withOpacity(0.7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 2; i++)
                      Padding(
                        padding: customPadding(
                          bottom: safeAreaHeight * 0.01,
                        ),
                        child: nText(
                          [
                            if (!isMini)
                              "${split[1]}/${split[2]}"
                            else
                              "${split[2]}日",
                            if (postListData.countNulls() == 8)
                              "Complete!"
                            else
                              "( ${postListData.countNulls()}/8 )",
                          ][i],
                          fontSize: safeAreaWidth / [22, 35][i],
                          isGradation: i == 1 && postListData.countNulls() == 8,
                          isFit: true,
                          bold: 700,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
