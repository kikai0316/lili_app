import 'package:flutter/material.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';

Widget onPostWidget(
  BuildContext context, {
  required String? imgUrl,
  bool? isAccountData,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return SizedBox(
    width: safeAreaWidth * 0.3,
    child: AspectRatio(
      aspectRatio: 3 / 4,
      child: imgWidget(
        borderRadius: 15,
        color: subColor,
        networkUrl: imgUrl,
        child: Padding(
          padding: EdgeInsets.all(safeAreaWidth * 0.02),
          child: Stack(
            children: [
              if (imgUrl == null)
                Align(
                  child: nText("😴", fontSize: safeAreaWidth / 10),
                ),
              if (isAccountData != false)
                Align(
                  alignment: Alignment.topCenter,
                  child: accountWidget(context),
                ),
              if (imgUrl != null)
                Align(
                  alignment: Alignment.bottomRight,
                  child: textWidget(context),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget accountWidget(
  BuildContext context,
) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return SizedBox(
    height: safeAreaWidth * 0.06,
    child: Row(
      children: [
        Padding(
          padding: customPadding(right: safeAreaWidth * 0.015),
          child: imgWidget(
            boxShadow: mainBoxShadow(shadow: 0.2),
            size: safeAreaWidth * 0.06,
            isCircle: true,
            networkUrl:
                "https://i.pinimg.com/474x/c3/43/2b/c3432b9ca4f20b5dc85a634df3f07274.jpg",
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            child: nText(
              "Loddsvccssc",
              shadows: mainBoxShadow(shadow: 0.2),
              textAlign: TextAlign.left,
              bold: 500,
              fontSize: safeAreaWidth / 45,
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
) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return nContainer(
    padding: xPadding(
      context,
      xSize: safeAreaWidth * 0.02,
      top: safeAreaWidth * 0.01,
      bottom: safeAreaWidth * 0.01,
    ),
    color: Colors.white.withOpacity(0.5),
    radius: 50,
    child: nText(
      "あああああああああ",
      fontSize: safeAreaWidth / 50,
      textAlign: TextAlign.right,
      bold: 700,
      maxLiune: 2,
      color: Colors.black,
    ),
  );
}
