import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
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
import 'package:lili_app/view_model/post_timer.dart';
import 'package:lili_app/widget/on_item/on_post_widget.dart';
import 'package:lili_app/widget/on_item/on_profile_widget.dart';

Widget postWidget(
  BuildContext context,
  String timeDate,
  List<UserType> postDataList,
  UserType myProfile,
) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  final isTime = timeDate == "起床" || isTimePassed(timeDate);
  final isView = myProfile.postList.isPostTimeNotNull(timeDate);
  return Column(
    children: [
      titleWidget(
        context,
        timeDate,
        isView: isView,
        postDataList: postDataList
            .map((e) => dataFormatUserDataToPostData(timeDate, e))
            .toList(),
      ),
      if (isTime && isView) ...{
        SizedBox(
          height: safeAreaHeight * 0.2,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: postDataList.length + 2,
            itemBuilder: (context, index) {
              if (index == 0 || index == postDataList.length + 1) {
                return SizedBox(
                  width: safeAreaWidth * 0.03,
                );
              }
              return Padding(
                padding: customPadding(right: safeAreaWidth * 0.05),
                child: onPostWidget(
                  context,
                  userData: postDataList[index - 1],
                  isView: isView,
                  notPostEmoji: notPostEmoji(
                    postDataList[index - 1].postList.wakeUp,
                    timeDate,
                  ),
                  postData: dataFormatUserDataToPostData(
                    timeDate,
                    postDataList[index - 1],
                  ),
                  onTap: () => ScreenTransition(
                    context,
                    FullScreenPostPage(
                      userData: postDataList[index - 1],
                      postData: dataFormatUserDataToPostData(
                        timeDate,
                        postDataList[index - 1],
                      ),
                    ),
                  ).top(),
                ),
              );
            },
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
  return Column(
    children: [
      titleWidget(
        context,
        "私の親友たち",
      ),
      if (allFriends.isNotEmpty)
        SizedBox(
          height: safeAreaWidth * 0.25,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: allFriends.length + 2,
            itemBuilder: (context, index) {
              if (index == 0 || index == allFriends.length + 1) {
                return SizedBox(
                  width: safeAreaWidth * 0.03,
                );
              }
              return Padding(
                padding: customPadding(right: safeAreaWidth * 0.03),
                child: onProfileWidget(
                  context,
                  size: safeAreaWidth * 0.2,
                  userData: allFriends[index - 1],
                  myProfile: myProfile,
                ),
              );
            },
          ),
        ),
      if (allFriends.isEmpty)
        Align(
          child: Padding(
            padding: yPadding(context),
            child: nText(
              "まだ友達がいません。親友を招待しよう！",
              fontSize: safeAreaWidth / 30,
              color: Colors.grey,
            ),
          ),
        ),
      Padding(
        padding: yPadding(context),
        child: line(),
      ),
    ],
  );
}

Widget titleWidget(
  BuildContext context,
  String title, {
  List<PostType?>? postDataList,
  bool? isView,
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
        if (!isTime || isView == false)
          Padding(
            padding: customPadding(right: safeAreaWidth * 0.01),
            child: Icon(
              isTime && isView == false ? Icons.visibility_off : Icons.lock,
              size: safeAreaWidth / 20,
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
        Padding(
          padding: customPadding(right: safeAreaWidth * 0.02),
          child: nText(
            title,
            fontSize: safeAreaWidth / 23,
            color: !isTime || isView == false
                ? Colors.grey.withOpacity(0.5)
                : Colors.white,
          ),
        ),
        if (isTimeDataTitle && isTime && isView == true)
          nText(
            total == postCount ? "Complete!" : "投稿率 ( $postCount/$total )",
            isGradation: total == postCount,
            fontSize: safeAreaWidth / 35,
          ),
        const Spacer(),
        if (!isTime || isView == false)
          nText(
            isTime && isView == false ? "投稿できなかったため、閲覧できません" : "投稿時間以降に解放されます",
            isGradation: total == postCount,
            color: Colors.grey.withOpacity(0.5),
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
    backgroundColor: mainBackGroundColor,
    customLeftIcon: CustomAnimatedOpacityButton(
      onTap: () => ScreenTransition(
        context,
        FriendPage(
          myProfile: myProfile,
        ),
      ).left(),
      child: Badge.count(
        count: myProfile.friendRequestList.length,
        isLabelVisible: myProfile.friendRequestList.isNotEmpty,
        child: nContainer(
          padding: EdgeInsets.all(safeAreaWidth * 0.013),
          height: safeAreaWidth * 0.11,
          width: safeAreaWidth * 0.11,
          child: imgWidget(assetFile: "friend_icon.png"),
        ),
      ),
    ),
    customTitle: nContainer(
      color: mainBackGroundColor,
      child: nText(
        "RoyalHy",
        fontSize: safeAreaWidth / 14,
      ),
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

class PostTinerWidget extends HookConsumerWidget {
  const PostTinerWidget({super.key, required this.myProfile});
  final UserType myProfile;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final postTimerNotifierState = ref.watch(postTimerNotifierProvider);
    final List<Widget> postTimerWidegt = postTimerNotifierState.when(
      data: (value) {
        if (myProfile.postList.wakeUp == null) return [const SizedBox()];
        if (isPostTimeAvailable(myProfile)) {
          return [
            Padding(
              padding: yPadding(context),
              child: nText("投稿の時間になりました！", fontSize: safeAreaWidth / 30),
            ),
            postButtonWidget(context, myProfile),
          ];
        }
        if (isEndPostTime()) {
          return [
            nText(
              "今日の投稿は終了しました。\n次は午前3時以降から起床の投稿ができます",
              fontSize: safeAreaWidth / 30,
              height: 1.5,
            ),
          ];
        }
        return List.generate(
          2,
          (i) => nText(
            ["次の投稿時間まで", if (value != null) formatDuration(value) else ""][i],
            shadows: mainBoxShadow(shadow: 1),
            fontSize: [safeAreaWidth / 30, safeAreaWidth / 9][i],
          ),
        );
      },
      error: (e, s) => [],
      loading: () => [],
    );
    return SizedBox(
      height: safeAreaHeight * 0.25,
      width: safeAreaWidth,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: postTimerWidegt,
        ),
      ),
    );
  }

  bool isPostTimeAvailable(UserType myProfile) {
    final DateTime now = DateTime.now();
    for (final entry in postTimeData.entries) {
      if (entry.key == PostTimeType.wakeUp) {
        continue;
      }
      final List<String> timeParts = entry.value.split(':');
      final int hour = int.parse(timeParts[0]);
      final int minute = int.parse(timeParts[1]);
      final DateTime postTime =
          DateTime(now.year, now.month, now.day, hour, minute);
      final DateTime postTimeEnd = postTime.add(const Duration(minutes: 10));
      if (now.isAfter(postTime) && now.isBefore(postTimeEnd)) {
        if (!myProfile.postList.isPostTimeNotNull(entry.value)) return true;
      }
    }
    return false;
  }

  bool isEndPostTime() {
    final DateTime now = DateTime.now();
    final int hours = now.hour;
    final int minutes = now.minute;
    if (hours == 22 && minutes >= 11) return true;
    if (hours == 23) return true;
    if (hours >= 0 && hours <= 2) return true;
    return false;
  }
}

Widget wakeUpPostBackgroundPage(
  BuildContext context,
  UserType myProfile,
) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Column(
    children: [
      AspectRatio(
        aspectRatio: 16 / 9,
        child: Padding(
          padding: EdgeInsets.all(safeAreaWidth * 0.03),
          child: imgWidget(assetFile: "wakeup.png", borderRadius: 20),
        ),
      ),
      Padding(
        padding: customPadding(top: safeAreaHeight * 0.1),
        child: nText(
          "おはようございます！\n今日の始まりの一枚を投稿してみましょう！",
          height: 1.5,
          isOverflow: false,
          fontSize: safeAreaWidth / 20,
        ),
      ),
      Padding(
        padding: customPadding(top: safeAreaHeight * 0.1),
        child: mainButton(
          context,
          height: safeAreaHeight * 0.05,
          width: safeAreaWidth * 0.55,
          radius: 10,
          text: "起床の投稿をする",
          fontSize: safeAreaWidth / 30,
          onTap: () => ScreenTransition(
            context,
            PhotographPage(
              myProfile: myProfile,
            ),
          ).top(),
        ),
      ),
      const Spacer(),
      Padding(
        padding: customPadding(bottom: safeAreaHeight * 0.05),
        child: postButtonWidget(context, myProfile),
      ),
    ],
  );
}

Widget postButtonWidget(
  BuildContext context,
  UserType myProfile,
) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return CustomAnimatedOpacityButton(
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
  );
}
