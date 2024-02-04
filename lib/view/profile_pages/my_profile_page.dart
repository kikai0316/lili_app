import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/component/loading.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/view_model/user_data.dart';
import 'package:lili_app/widget/profile_widgets/my_profile_widget.dart';

class MyProfilePage extends HookConsumerWidget {
  const MyProfilePage({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final userDataState = ref.watch(userDataNotifierProvider);
    final isDataReady = userDataState is AsyncData<UserType?>;
    final UserType? userData = userDataState.value;
    if (userData == null) {
      return nText("エラー", fontSize: safeAreaWidth / 20);
    }

    return Scaffold(
      backgroundColor: mainBackGroundColor,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: nAppBar(
        context,
        title: "プロフィール",
        customRightIcon: CustomAnimatedOpacityButton(
          onTap: () {},
          child: Icon(
            Icons.more_horiz,
            color: Colors.white,
            size: safeAreaWidth / 15,
          ),
        ),
      ),
      body: isDataReady
          ? SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  myProfileMainWidget(context, userData),
                  ...todayPostWidget(context, userData),
                  ...pastPostWidget(context),
                ],
              ),
            )
          : loadinPage(
              context: context,
            ),
    );
  }
}
