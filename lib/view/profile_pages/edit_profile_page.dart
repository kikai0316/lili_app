import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/widget/profile_widgets/edit_profile_widget.dart';

class EditProfilePage extends HookConsumerWidget {
  const EditProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editImg = useState<File?>(null);

    return Scaffold(
      backgroundColor: mainBackGroundColor,
      extendBodyBehindAppBar: true,
      appBar: nAppBar(
        context,
        title: "プロフィール編集",
      ),
      body: SafeArea(
        child: Padding(
          padding: xPadding(context),
          child: Center(
            child: Column(
              children: [
                editImgWidget(
                  context,
                  editImg: editImg.value,
                  defaultImg:
                      "https://i.pinimg.com/474x/9f/47/b1/9f47b1b74e2b54063e07b99f430916c5.jpg",
                  onTap: () {},
                ),
                editTodayMoodWidget(context, "😃"),
                editBasicWidget(context, ["dsafaasdc", "sdsdcac"]),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: xPadding(context),
          child: Opacity(
            opacity: 0.5,
            child: mainButton(context, text: "保存", onTap: () {}),
          ),
        ),
      ),
    );
  }
}
