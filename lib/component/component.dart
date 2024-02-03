import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/img.dart';
import 'package:lili_app/model/model.dart';

Widget line({Color? color}) {
  return Container(
    height: 1,
    width: double.infinity,
    color: color ?? Colors.grey.withOpacity(0.3),
  );
}

Widget nText(
  String text, {
  required double fontSize,
  Color color = Colors.white,
  double bold = 900,
  double height = 1,
  int? maxLiune,
  TextAlign textAlign = TextAlign.center,
  List<Shadow>? shadows,
  bool isOverflow = true,
  bool isFit = false,
  bool? isGradation,
  TextDecoration decoration = TextDecoration.none,
}) {
  final textWidget = Text(
    text,
    textAlign: textAlign,
    overflow: isOverflow ? TextOverflow.ellipsis : null,
    maxLines: maxLiune,
    style: TextStyle(
      height: height,
      decoration: decoration,
      decorationColor: color,
      fontFamily: "Normal",
      fontVariations: [FontVariation("wght", bold)],
      color: color,
      shadows: shadows,
      fontSize: fontSize,
    ),
  );
  final gradationTextWidget = isGradation == true
      ? ShaderMask(
          child: textWidget,
          shaderCallback: (Rect rect) => mainGradation().createShader(rect),
        )
      : textWidget;
  if (isFit) {
    return FittedBox(fit: BoxFit.fitWidth, child: gradationTextWidget);
  }
  return gradationTextWidget;
}

Widget nContainer({
  double? height,
  double? width,
  Color? color,
  double radius = 0,
  EdgeInsetsGeometry? padding,
  Gradient? gradient,
  AlignmentGeometry? alignment,
  BoxBorder? border,
  Widget? child,
  List<BoxShadow>? boxShadow,
  bool? isCircle,
  double? maxWidth,
}) {
  return Container(
    padding: padding,
    alignment: alignment,
    height: height,
    width: width,
    constraints: maxWidth != null
        ? BoxConstraints(
            maxWidth: maxWidth,
          )
        : null,
    decoration: BoxDecoration(
      color: color,
      borderRadius: isCircle != true ? BorderRadius.circular(radius) : null,
      border: border,
      gradient: gradient,
      boxShadow: boxShadow,
      shape: isCircle == true ? BoxShape.circle : BoxShape.rectangle,
    ),
    child: child,
  );
}

Widget imgWidget({
  String? assetFile,
  String? networkUrl,
  File? fileData,
  Uint8List? memoryData,
  double? size,
  BoxBorder? border,
  bool? isCircle,
  double borderRadius = 10,
  Color? color,
  Widget? child,
  List<BoxShadow>? boxShadow,
}) {
  return Container(
    alignment: Alignment.bottomRight,
    height: size,
    width: size,
    decoration: BoxDecoration(
      color: color,
      border: border,
      image: assetFile != null
          ? assetImg(assetFile)
          : fileData != null
              ? fileImg(fileData)
              : networkUrl != null
                  ? networkImg(networkUrl)
                  : memoryData != null
                      ? memorImg(memoryData)
                      : null,
      borderRadius:
          isCircle != true ? BorderRadius.circular(borderRadius) : null,
      boxShadow: boxShadow,
      shape: isCircle == true ? BoxShape.circle : BoxShape.rectangle,
    ),
    child: child,
  );
}

Widget circleWidget({
  Widget? child,
  double? size,
  Color? color,
  BoxBorder? border,
  List<BoxShadow>? boxShadow,
  double padingSize = 0,
}) {
  return Container(
    alignment: Alignment.center,
    height: size,
    width: size,
    padding: EdgeInsets.all(padingSize),
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: border,
      boxShadow: boxShadow,
    ),
    child: child,
  );
}

Widget bottomSheetScaffold(
  BuildContext context, {
  required double height,
  required Widget body,
  Color backGroundColor = mainBackGroundColor,
  String? title,
  VoidCallback? onComplete,
  Widget? bottomButton,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Container(
    padding: customPadding(top: safeAreaHeight * 0.01),
    height: height,
    width: safeAreaWidth,
    decoration: BoxDecoration(
      color: backGroundColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: nAppBar(
        context,
        title: title,
        leftIconType: BackIconStyleType.arrowBackBottomIcon,
        customRightIcon: onComplete != null
            ? CustomAnimatedOpacityButton(
                onTap: onComplete,
                child: Container(
                  alignment: Alignment.center,
                  width: safeAreaWidth * 0.1,
                  child: nText(
                    "完了",
                    fontSize: safeAreaWidth / 25,
                    color: Colors.blue,
                  ),
                ),
              )
            : null,
      ),
      body: Column(
        children: [body, const Spacer(), bottomButton ?? const SizedBox()],
      ),
    ),
  );
}

Widget nTextFormField(
  BuildContext context, {
  required TextEditingController? textController,
  required String hintText,
  double? fontSize,
  void Function(String)? onChanged,
  void Function(String)? onFieldSubmitted,
  TextAlign textAlign = TextAlign.start,
  int? maxLines,
  int? maxLength,
  TextInputType? keyboardType,
  double? letterSpacing,
  bool autofocus = true,
  List<TextInputFormatter>? inputFormatters,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return TextFormField(
    controller: textController,
    maxLines: maxLines,
    maxLength: maxLength,
    textAlign: textAlign,
    autofocus: autofocus,
    keyboardType: keyboardType,
    onChanged: onChanged,
    inputFormatters: inputFormatters,
    onFieldSubmitted: onFieldSubmitted,
    cursorColor: Colors.white,
    style: TextStyle(
      fontFamily: "Normal",
      fontVariations: const [FontVariation("wght", 700)],
      color: Colors.white,
      letterSpacing: letterSpacing,
      fontSize: fontSize ?? safeAreaWidth / 30,
      height: 1,
    ),
    decoration: InputDecoration(
      counterText: '',
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      hintText: hintText,
      hintStyle: TextStyle(
        fontFamily: "Normal",
        color: Colors.grey,
        letterSpacing: letterSpacing,
        fontVariations: const [FontVariation("wght", 700)],
        fontSize: fontSize ?? safeAreaWidth / 30,
        height: 1,
      ),
    ),
  );
}

Widget nListTile(
  BuildContext context,
  List<NListTileItemType> dataList, {
  Widget? child,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final paddingWidget = SizedBox(
    width: safeAreaWidth * 0.03,
  );
  Widget textWidget(String text, Color textColor) => nText(
        text,
        fontSize: safeAreaWidth / 27,
        color: textColor,
      );

  return nContainer(
    width: safeAreaWidth,
    color: subColor,
    radius: 15,
    child: Column(
      children: [
        for (int i = 0; i < dataList.length; i++) ...{
          CustomAnimatedOpacityButton(
            opacity: 0.5,
            onTap: dataList[i].onTap,
            child: Opacity(
              opacity: dataList[i].isOpacity ? 0.5 : 1,
              child: nContainer(
                padding: xPadding(context),
                height: safeAreaHeight * 0.08,
                child: Row(
                  children: [
                    if (dataList[i].leftImgIcon != null)
                      Padding(
                        padding: EdgeInsets.only(right: safeAreaWidth * 0.02),
                        child: dataList[i].leftImgIcon,
                      ),
                    if (dataList[i].leftIcon != null)
                      Padding(
                        padding: EdgeInsets.only(right: safeAreaWidth * 0.02),
                        child: Icon(
                          dataList[i].leftIcon,
                          color: Colors.white,
                          size: safeAreaWidth / 17,
                        ),
                      ),
                    if (dataList[i].leftTitle != null)
                      textWidget(dataList[i].leftTitle!, dataList[i].textColor),
                    paddingWidget,
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: dataList[i].dataText != null
                            ? textWidget(
                                dataList[i].dataText!,
                                dataList[i].textColor,
                              )
                            : null,
                      ),
                    ),
                    paddingWidget,
                    if (dataList[i].onTap != null)
                      Icon(
                        Icons.arrow_forward_ios,
                        color: dataList[i].textColor,
                        size: safeAreaWidth / 25,
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (i != (child == null ? dataList.length - 1 : dataList.length))
            Padding(
              padding: xPadding(context),
              child: line(color: Colors.grey.withOpacity(0.2)),
            ),
        },
        if (child != null)
          Padding(
            padding: xPadding(context, top: safeAreaHeight * 0.03),
            child: SizedBox(width: safeAreaWidth, child: child),
          ),
      ],
    ),
  );
}
