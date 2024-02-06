import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
                      isView: isView,
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
  required bool isView,
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
        const Spacer(),
        if (!isView && isTime) ...{
          Padding(
            padding: customPadding(right: safeAreaWidth * 0.01),
            child: Icon(
              Icons.lock,
              size: safeAreaWidth / 30,
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          nText(
            "閲覧できません。",
            isGradation: total == postCount,
            color: Colors.grey.withOpacity(0.5),
            fontSize: safeAreaWidth / 40,
          ),
        },
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
    final timeText = useState<String?>("");
    Timer? timer;
    void timeMessageUpData(
      DateTime targetTime,
    ) {
      timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        final now = DateTime.now();
        final difference = targetTime.difference(now);
        if (difference.isNegative) {
          timeText.value = null;
        } else {
          timeText.value = formatDuration(difference);
        }
      });
    }

    useEffect(
      () {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          final postTimeType = getNextPostTime();
          if (postTimeType != null) {
            final now = DateTime.now();
            final DateTime baseDate =
                now.hour < 3 ? DateTime(now.year, now.month, now.day - 1) : now;
            final time = convertTimeStringToDateTime(
              postTimeData[postTimeType]!,
              baseDate,
            );
            timeMessageUpData(time);
          } else {
            timeText.value = null;
          }
        });
        return () => timer?.cancel();
      },
      [],
    );

    return SizedBox(
      width: safeAreaWidth,
      height: safeAreaHeight * 0.25,
      // color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: isPostTimeAvailable() || myProfile.postList.wakeUp == null
              ? [
                  if (myProfile.postList.wakeUp == null)
                    Padding(
                      padding: customPadding(bottom: safeAreaHeight * 0.01),
                      child: nContainer(
                        padding: xPadding(
                          context,
                          top: safeAreaWidth * 0.025,
                          bottom: safeAreaWidth * 0.025,
                        ),
                        radius: 20,
                        color: Colors.white,
                        child: nText(
                          "起きましたか？\n起きたら投稿しましょう！！",
                          fontSize: safeAreaWidth / 30,
                          height: 1.5,
                          color: Colors.black,
                        ),
                      ),
                    ),
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
                ]
              : timeText.value != null
                  ? [
                      nText(
                        "次の投稿時間まで",
                        fontSize: safeAreaWidth / 30,
                        shadows: mainBoxShadow(
                          shadow: 1,
                        ),
                      ),
                      nText(
                        timeText.value ?? "",
                        fontSize: safeAreaWidth / 9,
                        shadows: mainBoxShadow(
                          shadow: 1,
                        ),
                      ),
                    ]
                  : [
                      nContainer(
                        padding: xPadding(
                          context,
                          top: safeAreaWidth * 0.025,
                          bottom: safeAreaWidth * 0.025,
                        ),
                        radius: 20,
                        color: Colors.white,
                        child: nText(
                          "今日の投稿は終了しました\n午前3時に起床の投稿ができます",
                          fontSize: safeAreaWidth / 25,
                          height: 1.5,
                          color: Colors.black,
                        ),
                      ),
                    ],
        ),
      ),
    );
  }

  bool isPostTimeAvailable() {
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
        return true;
      }
    }
    return false;
  }

  PostTimeType? getNextPostTime() {
    final now = DateTime.now();
    final todayOrYesterday =
        now.hour < 3 ? now.subtract(const Duration(days: 1)) : now;
    final resetTime = DateTime(
      todayOrYesterday.year,
      todayOrYesterday.month,
      todayOrYesterday.day,
      3,
    );
    final List<PostTimeType> postTimes = postTimeData.keys.toList();
    postTimes.removeAt(0);
    final baseTime = now.isBefore(resetTime) ? resetTime : now;
    for (final postTime in postTimes) {
      final time = convertTimeStringToDateTime(postTimeData[postTime]!, null);
      if (baseTime.isBefore(time) || baseTime.isBefore(resetTime)) {
        return postTime;
      }
    }
    if (now.hour >= 3) {
      return postTimes.first;
    }

    return null;
  }
}
