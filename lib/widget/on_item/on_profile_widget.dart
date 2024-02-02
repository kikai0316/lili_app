import 'package:flutter/material.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/model/model.dart';

Widget onProfileWidget(
  BuildContext context, {
  required UserType userData,
  required double size,
  VoidCallback? onTap,
}) {
  return CustomAnimatedOpacityButton(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        imgWidget(
          size: size,
          isCircle: true,
          networkUrl: userData.img,
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
        Padding(
          padding: EdgeInsets.only(
            top: size / 10,
          ),
          child: Container(
            alignment: Alignment.center,
            width: size,
            child: nText(
              "user-ReaxQdp",
              fontSize: size / 8,
              bold: 700,
            ),
          ),
        ),
      ],
    ),
  );
}
