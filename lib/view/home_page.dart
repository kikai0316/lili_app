import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/component/loading.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/data.dart';
import 'package:lili_app/widget/home_widget.dart';

PageController? bodyController;
SwiperController? appBarController;

class HomePage extends HookConsumerWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    useEffect(
      () {
        bodyController = PageController();
        appBarController = SwiperController();
        return null;
      },
      [],
    );
    if (bodyController == null && appBarController == null) {
      return loadinPage(context: context, isLoading: true);
    }
    return Scaffold(
      backgroundColor: mainBackGroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: xPadding(
                context,
                top: safeAreaHeight * 0.03,
                bottom: safeAreaHeight * 0.02,
              ),
              child: nText("私の親友", fontSize: safeAreaWidth / 25),
            ),
            myFriendWidget(
              context,
            ),
            Padding(
              padding: yPadding(context),
              child: line(),
            ),
            postWidget(context, "起床"),
            for (final item in postTimeDataList) postWidget(context, item),
          ],
        ),
      ),
    );
  }
}
