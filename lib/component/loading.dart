import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/constant.dart';

Widget nIndicatorWidget(double radius) {
  return CupertinoActivityIndicator(color: Colors.white, radius: radius);
}

Widget loadinPage({
  required BuildContext context,
  bool? isLoading,
  String? text,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Visibility(
    visible: isLoading != false,
    child: Container(
      alignment: Alignment.center,
      color: Colors.black.withOpacity(0.7),
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          nIndicatorWidget(
            safeAreaHeight * 0.018,
          ),
          if (text != null) ...{
            Padding(
              padding: EdgeInsets.only(top: safeAreaHeight * 0.01),
              child: nText(
                text,
                fontSize: safeAreaWidth / 30,
              ),
            ),
          },
        ],
      ),
    ),
  );
}
