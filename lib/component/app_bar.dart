import 'package:flutter/material.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';

PreferredSizeWidget? nAppBar(
  BuildContext context, {
  String? title,
  Widget? customRightIcon,
  Widget? customLeftIcon,
  Widget? customTitle,
  Color surfaceTintColor = Colors.transparent,
  Color backgroundColor = Colors.transparent,
  bool isCloseIcon = false,
  bool isLeftIcon = true,
  VoidCallback? customLeftOnTap,
  double? leftCustomIconSize,
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
                visible: isLeftIcon,
                child: SizedBox(
                  width: safeAreaWidth * 0.11,
                  child: iconButtonWithCancel(
                    context,
                    size: safeAreaWidth * 0.11,
                    isCloseIcon: isCloseIcon,
                    customIconSize: leftCustomIconSize,
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
                    fontSize: safeAreaWidth / 23,
                    bold: 700,
                  ),
            ),
          ),
          customRightIcon ??
              Container(
                alignment: Alignment.centerRight,
                width: safeAreaWidth * 0.11,
                child: customRightIcon,
              ),
        ],
      ),
    ),
  );
}
