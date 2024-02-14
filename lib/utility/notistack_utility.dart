import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';

void successSnackbar(BuildContext context, String message) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final padingWidth = safeAreaWidth * 0.03;
  final padingHeight = safeAreaHeight * 0.01;
  HapticFeedback.vibrate();
  Flushbar(
    backgroundColor: greenColor,
    padding: EdgeInsets.only(
      left: padingWidth,
      right: padingWidth,
      top: padingHeight,
      bottom: padingHeight,
    ),
    flushbarPosition: FlushbarPosition.TOP,
    margin: EdgeInsets.only(
      right: padingWidth,
      left: padingWidth,
    ),
    borderRadius: BorderRadius.circular(15),
    messageText: SizedBox(
      width: safeAreaWidth * 1,
      child: Padding(
        padding: EdgeInsets.all(padingHeight),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: safeAreaWidth * 0.03),
              child: Icon(
                Icons.check_circle,
                color: Colors.white,
                size: safeAreaWidth / 12,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: nText(
                  message,
                  fontSize: safeAreaWidth / 28,
                  isOverflow: false,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    duration: const Duration(seconds: 4),
  ).show(context);
}

void errorAlertDialog(
  BuildContext context, {
  required String subTitle,
}) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) => cupertinoAlertDialog(
      context,
      title: "エラー",
      subTitle: subTitle,
    ),
  );
}

void showCustomDialog(BuildContext context, Widget page) => showDialog<void>(
      context: context,
      builder: (
        BuildContext context,
      ) =>
          Dialog(
        elevation: 10,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: page,
      ),
    );
void showAlertDialog(
  BuildContext context, {
  required String title,
  String? subTitle,
  String leftButtonText = "OK",
  String? rightButtonText,
  Color? rightButtonColor,
  void Function()? rightButtonOnTap,
}) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) => cupertinoAlertDialog(
      context,
      title: title,
      subTitle: subTitle,
      leftButtonText: leftButtonText,
      rightButtonOnTap: rightButtonOnTap,
      rightButtonText: rightButtonText,
      rightButtonColor: rightButtonColor,
    ),
  );
}

Widget cupertinoAlertDialog(
  BuildContext context, {
  required String title,
  String? subTitle,
  String leftButtonText = "OK",
  String? rightButtonText,
  VoidCallback? rightButtonOnTap,
  Color? rightButtonColor,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  return CupertinoAlertDialog(
    title: nText(
      title,
      color: Colors.black,
      fontSize: safeAreaWidth / 25,
      isOverflow: false,
      bold: 600,
    ),
    content: subTitle != null
        ? Padding(
            padding: EdgeInsets.only(top: safeAreaHeight * 0.01),
            child: nText(
              subTitle,
              fontSize: safeAreaWidth / 35,
              bold: 600,
              height: 1.2,
              color: Colors.black.withOpacity(0.6),
              isOverflow: false,
            ),
          )
        : null,
    actions: <CupertinoDialogAction>[
      CupertinoDialogAction(
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
        child: nText(
          leftButtonText,
          color: Colors.blue,
          fontSize: safeAreaWidth / 27,
          bold: 600,
        ),
      ),
      if (rightButtonText != null)
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: rightButtonOnTap,
          child: nText(
            rightButtonText,
            color: rightButtonColor ?? Colors.blue,
            fontSize: safeAreaWidth / 28,
            bold: 600,
          ),
        ),
    ],
  );
}
