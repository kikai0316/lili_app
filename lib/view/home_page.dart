import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/component/loading.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/data.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/sort_utility.dart';
import 'package:lili_app/view/login/line_login_page.dart';
import 'package:lili_app/view_model/all_friends.dart';
import 'package:lili_app/view_model/user_data.dart';
import 'package:lili_app/widget/home_widget.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final allFriendsState = ref.watch(allFriendsNotifierProvider);
    final userDataState = ref.watch(userDataNotifierProvider);
    final isDataReady = allFriendsState is AsyncData<List<UserType>?> &&
        userDataState is AsyncData<UserType?>;
    if (!isDataReady) {
      return loadinPage(
        context: context,
      );
    }
    final UserType? userData = userDataState.value;
    final List<UserType>? allFriends = allFriendsState.value;

    if (userData == null) {
      return const LineLoginPage();
    }
    if (allFriends == null) {
      return nText("エラー", fontSize: safeAreaHeight / 10);
    }
    return Scaffold(
      backgroundColor: mainBackGroundColor,
      extendBody: true,
      appBar: homePageAppBar(context, myProfile: userData),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleWidget(context, "私の親友たち", isView: true),
            myFriendWidget(context, allFriends, userData),
            Padding(
              padding: yPadding(context),
              child: line(),
            ),
            for (final item in postTimeData.values) ...{
              postWidget(
                  context,
                  item,
                  sortPostDataList(
                    item,
                    [...allFriends, userData],
                  ),
                  userData,),
            },
            SizedBox(
              height: safeAreaHeight * 0.25,
            ),
          ],
        ),
      ),
      bottomNavigationBar: PostTinerWidget(
        myProfile: userData,
      ),
    );
  }
}
