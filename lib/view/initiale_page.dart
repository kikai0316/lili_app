import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/component/loading.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/screen_transition_utility.dart';
import 'package:lili_app/view/home_page2.dart';
import 'package:lili_app/view/login/line_login_page.dart';
import 'package:lili_app/view/my_profile_page.dart';
import 'package:lili_app/view/pages/photograph_page.dart';
import 'package:lili_app/view_model/all_friends.dart';
import 'package:lili_app/view_model/user_data.dart';

class InitialePage extends HookConsumerWidget {
  const InitialePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final isLoading = useState<bool>(false);
    final pageIndex = useState<int>(0);
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
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          extendBody: true,
          body: [
            const HomePage2(),
            null,
            MyProfilePage(
              userData: userData,
              isLoading: isLoading,
            ),
          ][pageIndex.value],
          bottomNavigationBar: nContainer(
            alignment: Alignment.topCenter,
            padding: customPadding(top: safeAreaHeight * 0.01),
            height: safeAreaHeight * 0.1,
            color: Colors.black,
            width: safeAreaWidth,
            radius: 50,
            border: mainBorder(isOnlyTop: true),
            boxShadow: mainBoxShadow(shadow: 0.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                3,
                (i) => CustomAnimatedOpacityButton(
                  onTap: i == 1
                      ? () => ScreenTransition(
                            context,
                            PhotographPage(
                              myProfile: userData,
                            ),
                          ).top()
                      : () => pageIndex.value = i,
                  child: Opacity(
                    opacity: i == pageIndex.value || i == 1 ? 1 : 0.3,
                    child: nContainer(
                      padding: EdgeInsets.all(safeAreaHeight * 0.012),
                      height: safeAreaHeight * 0.06,
                      width: safeAreaHeight * 0.06,
                      color: Colors.transparent,
                      radius: 15,
                      border: i == 1
                          ? mainBorder(color: Colors.white, width: 2)
                          : null,
                      child: imgWidget(
                        size: safeAreaWidth * 0.1,
                        assetFile: [
                          "home_icon.png",
                          "add_icon.png",
                          "user_icon.png",
                        ][i],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        loadinPage(context: context, isLoading: isLoading.value),
      ],
    );
  }
}
