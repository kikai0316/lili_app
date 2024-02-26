import 'package:flutter/material.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/component/loading.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/data.dart';
import 'package:lili_app/constant/img.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/data_format_utility.dart';
import 'package:lili_app/utility/screen_transition_utility.dart';
import 'package:lili_app/view/pages/past_records_page.dart';
import 'package:lili_app/view/profile_pages/edit_profile_page.dart';
import 'package:lili_app/widget/on_item/on_past_post_widget.dart';
import 'package:lili_app/widget/on_item/on_post_widget.dart';
import 'package:lili_app/widget/on_item/on_profile_widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

Widget myProfileMainWidget(
  BuildContext context,
  UserType myProfile, {
  required VoidCallback onRefresh,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Padding(
    padding: xPadding(context, bottom: safeAreaHeight * 0.03),
    child: nContainer(
      padding: EdgeInsets.all(safeAreaWidth * 0.03),
      width: safeAreaWidth,
      radius: 25,
      color: Colors.white.withOpacity(0.1),
      child: Column(
        children: [
          SizedBox(
            height: safeAreaWidth * 0.22,
            width: double.infinity,
            child: Stack(
              children: [
                Align(
                  child: onProfileWidget(
                    context,
                    userData: myProfile,
                    size: safeAreaWidth * 0.2,
                    myProfile: myProfile,
                    backgroundColor: subColor,
                    isName: false,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: CustomAnimatedOpacityButton(
                    onTap: onRefresh,
                    child: Icon(
                      Icons.sync,
                      color: Colors.white,
                      size: safeAreaWidth / 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          for (int i = 0; i < 2; i++)
            Padding(
              padding: customPadding(
                top: [safeAreaHeight * 0.01, 0.0][i],
                bottom: safeAreaHeight * [0.005, 0.015][i],
              ),
              child: nText(
                [myProfile.name, myProfile.userId][i],
                fontSize: safeAreaWidth / [20, 30][i],
                color: [Colors.white, Colors.grey][i],
                bold: 700,
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              mainButton(
                context,
                height: safeAreaHeight * 0.05,
                width: safeAreaWidth * 0.38,
                radius: 13,
                borderColor: Colors.white.withOpacity(0.3),
                backGroundColor: subColor,
                text: "プロフィール編集",
                fontSize: safeAreaWidth / 32,
                textColor: Colors.white,
                onTap: () =>
                    ScreenTransition(context, const EditProfilePage()).normal(),
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
  return [
    myProfilePageTitleWidget(context, "今日の記録", top: 0),
    Align(
      child: nContainer(
        padding: EdgeInsets.all(safeAreaWidth * 0.01),
        width: safeAreaWidth * 0.7,
        radius: 20,
        color: Colors.white.withOpacity(0.1),
        // border: mainBorder(
        //     color: Colors.white.withOpacity(0.1), width: safeAreaWidth * 0.01),
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.spaceBetween,
            children: [
              for (final item in postTimeData.values) ...{
                SizedBox(
                  width: safeAreaWidth * 0.22,
                  child: onPostWidget(
                    context,
                    postData: dataFormatUserDataToPostData(item, userData),
                    isView: true,
                    isWakeUp: item == "起床",
                    borderRadius: 50,
                    onTap: () {},
                  ),
                ),
              },
              SizedBox(
                height: safeAreaWidth * 0.22,
                width: safeAreaWidth * 0.22,
                child: logoWidget(context),
              ),
            ],
          ),
        ),
      ),
    ),
    // SingleChildScrollView(
    //   scrollDirection: Axis.horizontal,
    //   child: Row(
    //     children: [
    //       SizedBox(
    //         width: safeAreaWidth * 0.01,
    //       ),
    //       for (final item in postTimeData.values) ...{
    //         Padding(
    //           padding: xPadding(context, xSize: safeAreaWidth * 0.02),
    //           child: Column(
    //             children: [
    //               Padding(
    //                 padding: customPadding(bottom: safeAreaHeight * 0.01),
    //                 child: nText(
    //                   item,
    //                   fontSize: safeAreaWidth / 28,
    //                   color: Colors.grey,
    //                 ),
    //               ),
    //               if (isTime(item))
    //                 SizedBox(
    //                   height: safeAreaHeight * 0.2,
    //                   child: onPostWidget(
    //                     context,
    //                     postData: dataFormatUserDataToPostData(item, userData),
    //                     isView: true,
    //                     isWakeUp: item == "起床",
    //                     onTap: () {},
    //                   ),
    //                 ),
    //               if (!isTime(item)) myProfilePageRockWidget(context),
    //             ],
    //           ),
    //         ),
    //       },
    //     ],
    //   ),
    // ),
  ];
}

List<Widget> pastPostWidget(
  BuildContext context,
  AsyncValue<Map<String, PastPostListType>?> allPastPost,
) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final allPastPostWidet = allPastPost.when(
    data: (value) {
      final dateStrings = pastPostDateStrings(value!.keys);
      return [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: safeAreaWidth * 0.03,
              ),
              for (final item in dateStrings)
                Padding(
                  padding: customPadding(right: safeAreaWidth * 0.02),
                  child: onPastPostdWidget(
                    context,
                    width: safeAreaWidth * 0.22,
                    date: item,
                    postListData: value[item],
                    isMini: false,
                  ),
                ),
            ],
          ),
        ),
        if (dateStrings.isNotEmpty)
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
              onTap: () => ScreenTransition(
                context,
                PastRecordsPage(
                  allPastPost: value,
                ),
              ).top(),
            ),
          ),
        if (dateStrings.isEmpty)
          Align(
            child: Padding(
              padding: yPadding(context),
              child: nText(
                "まだ過去に投稿した日がありません。",
                fontSize: safeAreaWidth / 25,
                color: Colors.grey,
              ),
            ),
          ),
      ];
    },
    error: (e, s) => [const SizedBox()],
    loading: () => [
      Align(
        child: Padding(
          padding: yPadding(context, ySize: safeAreaHeight * 0.05),
          child: nIndicatorWidget(safeAreaWidth / 30),
        ),
      ),
    ],
  );
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
    ...allPastPostWidet,
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
        nText(text, fontSize: safeAreaWidth / 25),
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
