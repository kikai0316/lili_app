import 'package:flutter/material.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/data.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/data_format_utility.dart';
import 'package:lili_app/utility/screen_transition_utility.dart';
import 'package:lili_app/view/profile_pages/edit_profile_page.dart';
import 'package:lili_app/view/profile_pages/past_records_page.dart';
import 'package:lili_app/widget/on_item/on_past_post_widget.dart';
import 'package:lili_app/widget/on_item/on_post_widget.dart';

Widget myProfileMainWidget(
  BuildContext context,
) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Padding(
    padding: xPadding(context, bottom: safeAreaHeight * 0.03),
    child: nContainer(
      padding: EdgeInsets.all(safeAreaWidth * 0.05),
      width: safeAreaWidth,
      radius: 25,
      color: subColor,
      child: Column(
        children: [
          imgWidget(
            size: safeAreaWidth * 0.25,
            isCircle: true,
            networkUrl:
                "https://i.pinimg.com/474x/9f/47/b1/9f47b1b74e2b54063e07b99f430916c5.jpg",
            child: Align(
              alignment: const Alignment(1.1, 1.1),
              child: nContainer(
                padding: EdgeInsets.all(
                  safeAreaWidth * 0.005,
                ),
                border: mainBorder(color: subColor, width: 3),
                radius: 50,
                color: Colors.white,
                child: nText("😀", fontSize: safeAreaWidth / 13),
              ),
            ),
          ),
          Padding(
            padding: yPadding(context),
            child: nText("edafwdsac", fontSize: safeAreaWidth / 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < 2; i++)
                mainButton(
                  context,
                  height: safeAreaHeight * 0.05,
                  width: safeAreaWidth * 0.38,
                  radius: 13,
                  borderColor: Colors.white.withOpacity(0.3),
                  backGroundColor: subColor,
                  text: [
                    "今日の気分変更",
                    "プロフィール編集",
                  ][i],
                  fontSize: safeAreaWidth / 32,
                  textColor: Colors.white,
                  onTap: () =>
                      ScreenTransition(context, const EditProfilePage())
                          .normal(),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}

List<Widget> todayPostWidget(BuildContext context, UserType userData) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  bool isTime(String timeDate) => timeDate == "起床" || isTimePassed(timeDate);
  return [
    myProfilePageTitleWidget(context, "今日の記録", top: 0),
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: safeAreaWidth * 0.01,
          ),
          for (final item in postTimeDataList) ...{
            Padding(
              padding: xPadding(context, xSize: safeAreaWidth * 0.02),
              child: Column(
                children: [
                  Padding(
                    padding: customPadding(bottom: safeAreaHeight * 0.01),
                    child: nText(
                      item,
                      fontSize: safeAreaWidth / 28,
                      color: Colors.grey,
                    ),
                  ),
                  if (isTime(item))
                    onPostWidget(
                      context,
                      postData: dataFormatUserDataToPostData(item, userData),
                      notPostEmoji:
                          notPostEmoji(userData.postList.wakeUp, item),
                      onTap: () {},
                    ),
                  if (!isTime(item)) myProfilePageRockWidget(context),
                ],
              ),
            ),
          },
        ],
      ),
    ),
  ];
}

List<Widget> pastPostWidget(BuildContext context) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return [
    myProfilePageTitleWidget(
      context,
      "過去の記録",
      top: safeAreaHeight * 0.04,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: xPadding(context, xSize: safeAreaWidth * 0.005),
            child: Icon(
              Icons.lock,
              color: Colors.grey,
              size: safeAreaWidth / 25,
            ),
          ),
          nText(
            "あなたにのみ表示されます",
            fontSize: safeAreaWidth / 35,
            color: Colors.grey,
          ),
        ],
      ),
    ),
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: safeAreaWidth * 0.03,
          ),
          for (int i = 0; i < 10; i++)
            Padding(
              padding: customPadding(right: safeAreaWidth * 0.02),
              child: onPastPostdWidget(
                context,
                width: safeAreaWidth * 0.22,
                date: "3/16",
              ),
            ),
        ],
      ),
    ),
    Padding(
      padding: xPadding(
        context,
        top: safeAreaHeight * 0.02,
        xSize: safeAreaWidth * 0.2,
      ),
      child: mainButton(
        context,
        height: safeAreaHeight * 0.055,
        width: safeAreaWidth,
        text: "過去の記録全て表示",
        backGroundColor: subColor,
        radius: 13,
        textColor: Colors.white,
        borderColor: Colors.white.withOpacity(0.3),
        fontSize: safeAreaWidth / 30,
        onTap: () => ScreenTransition(context, const PastRecordsPage()).top(),
      ),
    ),
  ];
}

Widget myProfilePageTitleWidget(
  BuildContext context,
  String text, {
  required double top,
  Widget child = const SizedBox(),
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Padding(
    padding: xPadding(
      context,
      top: top,
      bottom: safeAreaHeight * 0.02,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        nText(text, fontSize: safeAreaWidth / 22),
        child,
      ],
    ),
  );
}

Widget myProfilePageRockWidget(
  BuildContext context,
) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return SizedBox(
    width: safeAreaWidth * 0.3,
    child: AspectRatio(
      aspectRatio: 3 / 4,
      child: nContainer(
        radius: 15,
        border: mainBorder(color: subColor, width: 4),
        child: Icon(
          Icons.lock,
          color: subColor,
          size: safeAreaWidth / 12,
        ),
      ),
    ),
  );
}
