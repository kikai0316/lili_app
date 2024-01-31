import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/widget/on_item/on_past_post_widget.dart';

class PastRecordsPage extends HookConsumerWidget {
  const PastRecordsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: mainBackGroundColor,
      appBar: nAppBar(
        context,
        backgroundColor: mainBackGroundColor,
        title: "過去の記録",
        leftIconType: BackIconStyleType.arrowBackBottomIcon,
      ),
      body: Padding(
        padding: xPadding(context),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: yPadding(context),
                child: nText(
                  "2023/03月",
                  fontSize: safeAreaWidth / 20,
                ),
              ),
              SizedBox(
                width: safeAreaWidth,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runSpacing: safeAreaHeight * 0.008,
                  children: [
                    for (int i = 0; i < 31; i++)
                      onPastPostdWidget(
                        context,
                        width: safeAreaWidth * 0.18,
                        date: "16日",
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
