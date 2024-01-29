import 'package:flutter/material.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/utility/data_format_utility.dart';
import 'package:lili_app/widget/on_item/on_myfriend_widget.dart';
import 'package:lili_app/widget/on_item/on_post_widget.dart';

Widget postWidget(BuildContext context, String timeDate) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  final isTime = timeDate == "起床" || isTimePassed(timeDate);
  return Padding(
    padding: yPadding(context, ySize: safeAreaHeight * 0.01),
    child: Stack(
      alignment: Alignment.centerLeft,
      children: [
        if (isTime)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: safeAreaWidth * 0.15,
                ),
                for (int i = 0; i < 6; i++)
                  onPostWidget(
                    context,
                    imgUrl: timeDate == "起床"
                        ? null
                        : "https://i.pinimg.com/474x/9f/47/b1/9f47b1b74e2b54063e07b99f430916c5.jpg",
                  ),
              ],
            ),
          ),
        if (!isTime) ...[
          Padding(
            padding: customPadding(left: safeAreaWidth * 0.2),
            child: Row(children: lockWidget(context, timeDate)),
          ),
        ],
        tagWidget(context, timeDate),
      ],
    ),
  );
}

Widget myFriendWidget(BuildContext context) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        SizedBox(
          width: safeAreaWidth * 0.03,
        ),
        for (int i = 0; i < 7; i++)
          Padding(
            padding: customPadding(right: safeAreaWidth * 0.03),
            child: onFriendWidget(context),
          ),
      ],
    ),
  );
}

Widget tagWidget(BuildContext context, String text) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Padding(
    padding: xPadding(context, xSize: safeAreaWidth * 0.01),
    child: nContainer(
      padding: EdgeInsets.all(safeAreaWidth * 0.02),
      radius: 50,
      color: mainBackGroundColor,
      child: nText(
        text,
        fontSize: safeAreaWidth / 30,
      ),
    ),
  );
}

List<Widget> lockWidget(BuildContext context, String timeDate) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return [
    Padding(
      padding: customPadding(right: safeAreaWidth * 0.03),
      child: Icon(
        Icons.lock,
        size: safeAreaWidth / 20,
        color: Colors.white.withOpacity(0.2),
      ),
    ),
    nText(
      "$timeDateに投稿できるようになります",
      shadows: mainBoxShadow(shadow: 0.2),
      color: Colors.white.withOpacity(0.2),
      fontSize: safeAreaWidth / 35,
    ),
  ];
}
