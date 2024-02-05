import 'package:flutter/material.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/data.dart';
import 'package:lili_app/constant/img.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/data_format_utility.dart';
import 'package:lili_app/utility/screen_transition_utility.dart';
import 'package:lili_app/view/pages/friend_page.dart';
import 'package:lili_app/view/pages/fullscreen_post_page.dart';
import 'package:lili_app/view/pages/photograph_page.dart';
import 'package:lili_app/view/profile_pages/my_profile_page.dart';
import 'package:lili_app/widget/on_item/on_post_widget.dart';
import 'package:lili_app/widget/on_item/on_profile_widget.dart';

Widget postWidget(
  BuildContext context,
  String timeDate,
  List<UserType> postDataList,
) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  final isTime = timeDate == "起床" || isTimePassed(timeDate);

  return Column(
    children: [
      titleWidget(
        context,
        timeDate,
        postDataList: postDataList
            .map((e) => dataFormatUserDataToPostData(timeDate, e))
            .toList(),
      ),
      if (isTime) ...{
        SizedBox(
          width: safeAreaWidth,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: safeAreaWidth * 0.03,
                ),
                for (final item in postDataList)
                  Padding(
                    padding: customPadding(right: safeAreaWidth * 0.05),
                    child: onPostWidget(
                      context,
                      userData: item,
                      notPostEmoji:
                          notPostEmoji(item.postList.wakeUp, timeDate),
                      postData: dataFormatUserDataToPostData(timeDate, item),
                      onTap: () => ScreenTransition(
                        context,
                        FullScreenPostPage(
                          userData: item,
                          postData:
                              dataFormatUserDataToPostData(timeDate, item),
                        ),
                      ).top(),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: xPadding(context, top: safeAreaHeight * 0.02),
          child: line(),
        ),
      },
    ],
  );
}

Widget myFriendWidget(
  BuildContext context,
  List<UserType> allFriends,
  UserType myProfile,
) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  if (allFriends.isEmpty) {
    return Align(
      child: Padding(
        padding: yPadding(context),
        child: nText(
          "まだ友達がいません。親友を招待しよう！",
          fontSize: safeAreaWidth / 30,
          color: Colors.grey,
        ),
      ),
    );
  }
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        SizedBox(
          width: safeAreaWidth * 0.03,
        ),
        for (final userData in allFriends)
          Padding(
            padding: customPadding(right: safeAreaWidth * 0.03),
            child: onProfileWidget(
              context,
              size: safeAreaWidth * 0.2,
              userData: userData,
              myProfile: myProfile,
            ),
          ),
      ],
    ),
  );
}

Widget titleWidget(
  BuildContext context,
  String title, {
  List<PostType?>? postDataList,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final isTimeDataTitle = postTimeData.values.contains(title);
  final isTime = title == "起床" || !isTimeDataTitle || isTimePassed(title);
  final total = (postDataList ?? []).length;
  final postCount = postDataList?.where((item) => item != null).length ?? 0;
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
            fontSize: safeAreaWidth / (isTime ? 23 : 30),
            color: isTime ? Colors.white : Colors.grey.withOpacity(0.5),
          ),
        ),
        if (isTimeDataTitle && isTime)
          nText(
            total == postCount ? "Complete!" : "投稿率 ( $postCount/$total )",
            isGradation: total == postCount,
            fontSize: safeAreaWidth / 35,
          ),
      ],
    ),
  );
}

PreferredSizeWidget? homePageAppBar(
  BuildContext context, {
  required UserType myProfile,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return nAppBar(
    context,
    customLeftIcon: CustomAnimatedOpacityButton(
      onTap: () => ScreenTransition(
        context,
        FriendPage(
          myProfile: myProfile,
        ),
      ).left(),
      child: nContainer(
        padding: EdgeInsets.all(safeAreaWidth * 0.013),
        height: safeAreaWidth * 0.11,
        width: safeAreaWidth * 0.11,
        child: imgWidget(assetFile: "friend_icon.png"),
      ),
    ),
    customTitle: nText(
      "RoyalHy",
      fontSize: safeAreaWidth / 14,
    ),
    customRightIcon: CustomAnimatedOpacityButton(
      onTap: () => ScreenTransition(context, const MyProfilePage()).normal(),
      child: imgWidget(
        size: safeAreaWidth * 0.11,
        border: mainBorder(),
        networkUrl: myProfile.img,
        assetFile: notImg(),
        isCircle: true,
      ),
    ),
  );
}

Widget bottomNavigationWidget(BuildContext context, UserType myProfile) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  return nContainer(
    width: safeAreaWidth,
    height: safeAreaHeight * 0.2,
    // color: Colors.white,
    child: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // nText(
          //   "次の投稿まで",
          //   fontSize: safeAreaWidth / 35,
          //   shadows: mainBoxShadow(
          //     shadow: 1,
          //   ),
          // ),
          // nText(
          //   "50:01",
          //   fontSize: safeAreaWidth / 8,
          //   shadows: mainBoxShadow(
          //     shadow: 1,
          //   ),
          // ),

          CustomAnimatedOpacityButton(
            onTap: () => ScreenTransition(
              context,
              PhotographPage(
                myProfile: myProfile,
              ),
            ).top(),
            child: nContainer(
              padding: EdgeInsets.all(safeAreaWidth * 0.05),
              alignment: Alignment.center,
              boxShadow: mainBoxShadow(shadow: 0.1),
              height: safeAreaWidth * 0.21,
              width: safeAreaWidth * 0.21,
              isCircle: true,
              border: mainBorder(
                color: Colors.white,
                width: 6,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
