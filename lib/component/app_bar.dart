import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/model/model.dart';

PreferredSizeWidget? nAppBar(
  BuildContext context, {
  String? title,
  Widget? customRightIcon,
  Widget? customLeftIcon,
  Widget? customTitle,
  Color backgroundColor = mainBackGroundColor,
  Color surfaceTintColor = mainBackGroundColor,
  BackIconStyleType? leftIconType = BackIconStyleType.arrowBackLeftIcon,
  VoidCallback? customLeftOnTap,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;

  return AppBar(
    backgroundColor: backgroundColor,
    surfaceTintColor: surfaceTintColor,
    elevation: 10,
    automaticallyImplyLeading: false,
    title: SizedBox(
      width: safeAreaWidth,
      child: Row(
        children: [
          customLeftIcon ??
              Visibility(
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                visible: leftIconType != null,
                child: nContainer(
                  alignment: Alignment.centerLeft,
                  width: safeAreaWidth * 0.11,
                  child: iconButtonWithCancel(
                    context,
                    size: safeAreaWidth /
                        (leftIconType == BackIconStyleType.arrowBackLeftIcon
                            ? 14
                            : 11),
                    iconType:
                        leftIconType ?? BackIconStyleType.arrowBackLeftIcon,
                    customOnTap: customLeftOnTap,
                  ),
                ),
              ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: customTitle ??
                  nText(
                    title ?? "",
                    fontSize: safeAreaWidth / 20,
                  ),
            ),
          ),
          customRightIcon ??
              SizedBox(
                width: safeAreaWidth * 0.11,
              ),
        ],
      ),
    ),
  );
}

Widget nTabBar(
  BuildContext context, {
  required TabController tabController,
  required List<String> titleList,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return TabBar(
    controller: tabController,
    unselectedLabelColor: Colors.white.withOpacity(0.4),
    labelStyle: TextStyle(
      decoration: TextDecoration.none,
      fontFamily: "Normal",
      fontVariations: const [FontVariation("wght", 900)],
      height: 1.5,
      color: Colors.white,
      fontSize: safeAreaWidth / 30,
    ),
    indicatorSize: TabBarIndicatorSize.tab,
    dividerColor: Colors.grey.withOpacity(0.2),
    indicatorColor: Colors.white,
    labelColor: Colors.white,
    overlayColor: MaterialStateProperty.all<Color>(subColor.withOpacity(0.3)),
    tabs: List.generate(
      titleList.length,
      (i) => Tab(
        text: titleList[i],
      ),
    ),
  );
}
