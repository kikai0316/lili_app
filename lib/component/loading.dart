import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/constant.dart';

Widget nIndicatorWidget(double radius) {
  return CupertinoActivityIndicator(color: Colors.white, radius: radius);
}

Widget nIndicator2Widget(double radius, {double strokeWidth = 2}) {
  return SizedBox(
    height: radius,
    width: radius,
    child: CircularProgressIndicator(
      strokeWidth: strokeWidth,
      backgroundColor: Colors.white,
      color: Colors.black,
    ),
  );
}

Widget loadinPage({
  required BuildContext context,
  bool? isLoading,
  String? text,
  bool isDefaultIndicator = true,
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
          if (isDefaultIndicator)
            nIndicatorWidget(
              safeAreaHeight * 0.018,
            ),
          if (!isDefaultIndicator)
            nIndicator2Widget(
              safeAreaHeight * 0.08,
              strokeWidth: 4,
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
