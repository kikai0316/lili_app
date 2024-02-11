import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/component/loading.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/data.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/firebase/firebase_firestore_utility.dart';
import 'package:lili_app/utility/firebase/firebase_storage_utility.dart';
import 'package:lili_app/utility/sort_utility.dart';
import 'package:lili_app/utility/type_updata_utility.dart';
import 'package:lili_app/view/login/line_login_page.dart';
import 'package:lili_app/view_model/all_friends.dart';
import 'package:lili_app/view_model/post_timer.dart';
import 'package:lili_app/view_model/user_data.dart';
import 'package:lili_app/widget/home_widget.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final allFriendsState = ref.watch(allFriendsNotifierProvider);
    final userDataState = ref.watch(userDataNotifierProvider);
    final isRefres = useState<bool>(false);
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
      body: userData.postList.wakeUp != null
          ? CustomMaterialIndicator(
              indicatorBuilder: (context, controller) {
                return nIndicatorWidget(safeAreaWidth / 30);
              },
              backgroundColor: Colors.transparent,
              withRotation: false,
              onRefresh: () => reFetch(ref, userData),
              onStateChanged: (change) {
                if (change.didChange(to: IndicatorState.dragging)) {
                  isRefres.value = true;
                } else if (change.didChange(to: IndicatorState.idle)) {
                  isRefres.value = false;
                }
              },
              child: ListView.builder(
                itemCount: postTimeData.entries.length + 1, // 縦方向のアイテム数
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return myFriendWidget(context, allFriends, userData);
                  }
                  return postWidget(
                    context,
                    postTimeData.values.elementAt(index - 1),
                    sortPostDataList(
                      postTimeData.values.elementAt(index - 1),
                      [...allFriends, userData],
                    ),
                    userData,
                  );
                },
              ),
            )
          : wakeUpPostBackgroundPage(context, userData),
      bottomNavigationBar: PostTinerWidget(
        myProfile: userData,
      ),
    );
  }

  Future<void> reFetch(WidgetRef ref, UserType myProfile) async {
    final userData = ref.read(userDataNotifierProvider.notifier);
    final allFriendsNotifier = ref.read(allFriendsNotifierProvider.notifier);
    final postTimerNotifier = ref.read(postTimerNotifierProvider.notifier);
    final profileData = await dbFirestoreReadUser(myProfile.openId);
    if (profileData == null) return;
    final postData =
        await dbStoragePostDownload(id: profileData.openId) ?? PostListType();
    await allFriendsNotifier.reFetch(profileData.friendList);
    final setUserData = userTypeUpDate(profileData, postListType: postData);
    await userData.userDataUpDate(setUserData);
    postTimerNotifier.timerPeriodic();
  }
}
