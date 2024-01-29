import 'package:flutter/material.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/constant.dart';

Widget onFriendWidget(BuildContext context) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  return CustomAnimatedOpacityButton(
    onTap: () {},
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        imgWidget(
          size: safeAreaWidth * 0.175,
          networkUrl:
              "https://i.pinimg.com/474x/9f/47/b1/9f47b1b74e2b54063e07b99f430916c5.jpg",
          isCircle: true,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: nText("😃", fontSize: safeAreaWidth / 15),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: safeAreaHeight * 0.01),
          child: Container(
            alignment: Alignment.center,
            width: safeAreaWidth * 0.175,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: nText(
                "sdasdvdsdd",
                fontSize: safeAreaWidth / 45,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
