import 'package:flutter/material.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/constant.dart';

Widget onPastPostdWidget(
  BuildContext context, {
  required double width,
  required String date,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  return CustomAnimatedOpacityButton(
    onTap: () {},
    child: SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: nContainer(
          padding: EdgeInsets.all(
            safeAreaWidth * 0.005,
          ),
          radius: 15,
          // color: Colors.grey.withOpacity(0.5),
          gradient: mainGradation(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              imgWidget(
                borderRadius: 13,
                networkUrl:
                    "https://i.pinimg.com/474x/9f/47/b1/9f47b1b74e2b54063e07b99f430916c5.jpg",
              ),
              nContainer(
                alignment: Alignment.center,
                radius: 15,
                color: Colors.black.withOpacity(0.5),
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
                            date,
                            "Complete!",
                          ][i],
                          fontSize: safeAreaWidth / [22, 35][i],
                          isGradation: i == 1,
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
