import 'package:flutter/material.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/model/model.dart';

PreferredSizeWidget? nAppBar(
  BuildContext context, {
  String? title,
  Widget? customRightIcon,
  Widget? customLeftIcon,
  Widget? customTitle,
  Color backgroundColor = const Color.fromRGBO(0, 0, 0, 0),
  BackIconStyleType? leftIconType = BackIconStyleType.arrowBackLeftIcon,
  VoidCallback? customLeftOnTap,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;

  return AppBar(
    backgroundColor: backgroundColor,
    surfaceTintColor: backgroundColor,
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
                    size: safeAreaWidth / 11,
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
