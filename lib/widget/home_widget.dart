import 'package:flutter/material.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/data.dart';
import 'package:lili_app/utility/data_format_utility.dart';
import 'package:lili_app/widget/on_item/on_post_widget.dart';
import 'package:lili_app/widget/on_item/on_profile_widget.dart';

Widget postWidget(BuildContext context, String timeDate) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  final isTime = timeDate == "起床" || isTimePassed(timeDate);

  if (!isTime) return const SizedBox();
  return Column(
    children: [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(
              width: safeAreaWidth * 0.03,
            ),
            for (int i = 0; i < 6; i++)
              Padding(
                padding: customPadding(right: safeAreaWidth * 0.05),
                child: onPostWidget(
                  context,
                  imgUrl: timeDate == "起床"
                      ? null
                      : "https://i.pinimg.com/474x/9f/47/b1/9f47b1b74e2b54063e07b99f430916c5.jpg",
                ),
              ),
          ],
        ),
      ),
      Padding(
        padding: xPadding(context, top: safeAreaHeight * 0.02),
        child: line(),
      ),
    ],
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
            child: onProfileWidget(
              context,
              size: safeAreaWidth * 0.175,
            ),
          ),
      ],
    ),
  );
}

Widget titleWidget(BuildContext context, String title) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final isTimeDataTitle = postTimeDataList.contains(title);
  final isTime = title == "起床" || !isTimeDataTitle || isTimePassed(title);
  return Padding(
    padding: xPadding(
      context,
      top: title == "起床" ? 0 : safeAreaHeight * 0.03,
      bottom: safeAreaHeight * 0.02,
    ),
    child: Row(
      children: [
        if (!isTime)
          Padding(
            padding: customPadding(right: safeAreaWidth * 0.01),
            child: Icon(
              Icons.lock,
              size: safeAreaWidth / 20,
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
        Padding(
          padding: customPadding(right: safeAreaWidth * 0.02),
          child: nText(
            title + (isTime ? "" : "に投稿できるようになります"),
            fontSize: safeAreaWidth / 23,
            color: isTime ? Colors.white : Colors.grey.withOpacity(0.5),
          ),
        ),
        if (isTimeDataTitle && isTime)
          nText(
            // "1/20",
            "Complete!",
            isGradation: true,
            fontSize: safeAreaWidth / 35,
            // color: Colors.white.withOpacity(0.4),
          ),
      ],
    ),
  );
}
