import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/widget/profile_widgets/my_profile_widget.dart';

class MyProfilePage extends HookConsumerWidget {
  const MyProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: mainBackGroundColor,
      extendBodyBehindAppBar: true,
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myProfileMainWidget(
              context,
            ),
            ...todayPostWidget(context),
            ...pastPostWidget(context),
          ],
        ),
      ),
    );
  }
}
