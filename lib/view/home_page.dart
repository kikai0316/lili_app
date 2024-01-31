import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/data.dart';
import 'package:lili_app/widget/home_widget.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);

    return Scaffold(
      backgroundColor: mainBackGroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleWidget(context, "私の親友たち"),
            myFriendWidget(
              context,
            ),
            Padding(
              padding: yPadding(context),
              child: line(),
            ),
            for (final item in postTimeDataList) ...{
              titleWidget(context, item),
              postWidget(context, item),
            },
            SizedBox(
              height: safeAreaHeight * 0.25,
            ),
          ],
        ),
      ),
    );
  }
}
