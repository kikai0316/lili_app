import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/component/loading.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:permission_handler/permission_handler.dart';

Widget photographShootingButtonWidget(
  BuildContext context, {
  required bool isAccess,
  required ValueNotifier<bool> isFlash,
  required void Function(bool) flashTapEvent,
  required VoidCallback returnTapEvent,
  required VoidCallback shootingTapEvent,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  Widget photographPageIconWidget(
    IconData icon, {
    required VoidCallback? onTap,
  }) =>
      CustomAnimatedOpacityButton(
        onTap: onTap,
        child: Icon(
          icon,
          color: Colors.white,
          size: safeAreaWidth / 9,
        ),
      );
  return Expanded(
    child: Opacity(
      opacity: isAccess ? 1 : 0.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          photographPageIconWidget(
            isFlash.value ? Icons.flash_on : Icons.flash_off,
            onTap: isAccess
                ? () {
                    isFlash.value = !isFlash.value;
                    flashTapEvent(isFlash.value);
                  }
                : null,
          ),
          CustomAnimatedOpacityButton(
            onTap: shootingTapEvent,
            // isAccess ? shootingTapEvent : null,
            child: nContainer(
              alignment: Alignment.center,
              height: safeAreaWidth * 0.22,
              width: safeAreaWidth * 0.22,
              isCircle: true,
              border: mainBorder(
                color: Colors.white,
                width: 6,
              ),
            ),
          ),
          photographPageIconWidget(
            Icons.cached,
            onTap: isAccess ? returnTapEvent : null,
          ),
        ],
      ),
    ),
  );
}

Widget photographPostButtonWidget(
  BuildContext context, {
  required ValueNotifier<Uint8List?> picture,
  required VoidCallback postTapEvent,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;

  return Expanded(
    child: Container(
      alignment: Alignment.center,
      child: CustomAnimatedOpacityButton(
        onTap: postTapEvent,
        child: Container(
          width: safeAreaWidth * 0.33,
          padding: EdgeInsets.all(safeAreaWidth * 0.01),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              nText(
                "投稿",
                fontSize: safeAreaWidth / 10,
              ),
              Padding(
                padding: customPadding(top: safeAreaWidth * 0.01),
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: safeAreaWidth / 12,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget photographPageLoagingWidget(
  BuildContext context,
) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return imgWidget(
    size: double.infinity,
    assetFile: "photograph.png",
    borderRadius: 40,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 50.0,
          sigmaY: 50.0,
        ),
        child: nContainer(
          alignment: Alignment.center,
          radius: 40,
          child: nIndicatorWidget(safeAreaWidth / 30),
        ),
      ),
    ),
  );
}

Widget photographPageAccessErrorWidget(
  BuildContext context,
) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  return imgWidget(
    size: double.infinity,
    assetFile: "photograph.png",
    borderRadius: 40,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 50.0,
          sigmaY: 50.0,
        ),
        child: nContainer(
          alignment: Alignment.center,
          radius: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              nText(
                "カメラへのアクセス権限がありません",
                fontSize: safeAreaWidth / 20,
              ),
              Padding(
                padding: xPadding(context, top: safeAreaHeight * 0.03),
                child: nText(
                  "カメラへのアクセスを許可するためには\n設定を開いてください。",
                  isOverflow: false,
                  fontSize: safeAreaWidth / 25,
                  height: 1.5,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              Padding(
                padding: customPadding(top: safeAreaHeight * 0.03),
                child: nContainer(
                  width: safeAreaWidth * 0.45,
                  height: safeAreaHeight * 0.06,
                  child: mainButton(
                    context,
                    text: "設定画面へ",
                    radius: 10,
                    onTap: () => openAppSettings(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget photographPageSystemErrorWidget(
  BuildContext context, {
  required VoidCallback onTap,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  return imgWidget(
    size: double.infinity,
    assetFile: "photograph.png",
    borderRadius: 40,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 50.0,
          sigmaY: 50.0,
        ),
        child: nContainer(
          alignment: Alignment.center,
          radius: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              nText(
                "不明なエラーが発生しました",
                fontSize: safeAreaWidth / 18,
              ),
              Padding(
                padding: customPadding(top: safeAreaHeight * 0.03),
                child: SizedBox(
                  width: safeAreaWidth * 0.45,
                  height: safeAreaHeight * 0.06,
                  child: mainButton(
                    context,
                    text: "再試行",
                    radius: 10,
                    onTap: onTap,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget afterTakingPhoto(
  BuildContext context,
  Uint8List picture, {
  required VoidCallback cancelOnTap,
  required VoidCallback saveOnTap,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return imgWidget(
    size: double.infinity,
    borderRadius: 40,
    memoryData: picture,
    child: Padding(
      padding: EdgeInsets.all(safeAreaWidth * 0.04),
      child: Stack(
        children: [
          for (int i = 0; i < 2; i++)
            Align(
              alignment: [
                Alignment.topRight,
                Alignment.bottomRight,
              ][i],
              child: GestureDetector(
                onTap: [cancelOnTap, saveOnTap][i],
                child: circleWidget(
                  size: safeAreaWidth * 0.09,
                  color: subColor.withOpacity(0.5),
                  child: Icon(
                    [
                      Icons.close,
                      Icons.save_alt,
                    ][i],
                    color: Colors.white,
                    size: safeAreaWidth / 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
