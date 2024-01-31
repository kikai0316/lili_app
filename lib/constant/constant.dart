import 'package:flutter/material.dart';
import 'package:lili_app/constant/color.dart';

double safeHeight(BuildContext context) {
  return MediaQuery.of(context).size.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom;
}

Gradient mainGradation() {
  return const LinearGradient(
    begin: FractionalOffset.topRight,
    end: FractionalOffset.bottomLeft,
    colors: [
      Color.fromARGB(255, 245, 213, 94),
      Color.fromARGB(255, 242, 168, 245),
      Color.fromARGB(255, 135, 237, 255),
    ],
  );
}

BoxBorder mainBorder({Color? color, double width = 1}) {
  return Border.all(
    color: color ?? Colors.grey.withOpacity(0.3),
    width: width,
  );
}

List<BoxShadow> mainBoxShadow({double shadow = 0.5, Color? color}) {
  return [
    BoxShadow(
      color: color ?? Colors.black.withOpacity(shadow),
      blurRadius: 20,
      spreadRadius: 10.0,
    ),
  ];
}

Gradient mainGradationWithBlackOpacity({
  Color color = mainBackGroundColor,
  double? startOpacity,
  List<double>? stops,
  AlignmentGeometry begin = FractionalOffset.topCenter,
  AlignmentGeometry end = FractionalOffset.bottomCenter,
}) {
  return LinearGradient(
    begin: begin,
    end: end,
    colors: [
      color.withOpacity(startOpacity ?? 1),
      color.withOpacity(0),
    ],
    stops: stops ??
        const [
          0.0,
          1.0,
        ],
  );
}

EdgeInsetsGeometry xPadding(
  BuildContext context, {
  double? xSize,
  double top = 0,
  double bottom = 0,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return EdgeInsets.only(
    left: xSize ?? safeAreaWidth * 0.03,
    right: xSize ?? safeAreaWidth * 0.03,
    top: top,
    bottom: bottom,
  );
}

EdgeInsetsGeometry yPadding(
  BuildContext context, {
  double? ySize,
  double left = 0,
  double right = 0,
}) {
  final safeAreaHeight = safeHeight(context);
  return EdgeInsets.only(
    left: left,
    right: right,
    top: ySize ?? safeAreaHeight * 0.02,
    bottom: ySize ?? safeAreaHeight * 0.02,
  );
}

EdgeInsetsGeometry customPadding({
  double top = 0,
  double bottom = 0,
  double left = 0,
  double right = 0,
}) {
  return EdgeInsets.only(
    left: left,
    right: right,
    top: top,
    bottom: bottom,
  );
}
