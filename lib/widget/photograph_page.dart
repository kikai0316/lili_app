import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/component/loading.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:permission_handler/permission_handler.dart';

Widget photographPageSuccessWidget(
  BuildContext context,
  CameraController cameraController,
  ValueNotifier<bool> isFlash,
) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  Widget photographPageIconWidget(
    IconData icon, {
    required VoidCallback onTap,
  }) =>
      CustomAnimatedOpacityButton(
        onTap: onTap,
        child: Icon(
          icon,
          color: Colors.white,
          size: safeAreaWidth / 9,
        ),
      );

  return Column(
    children: [
      AspectRatio(
        aspectRatio: 3 / 4,
        child: nContainer(
          color: subColor,
          radius: 40,
          child: CameraPreview(cameraController),
        ),
      ),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            photographPageIconWidget(
              isFlash.value ? Icons.flash_on : Icons.flash_off,
              onTap: () => isFlash.value = !isFlash.value,
            ),
            CustomAnimatedOpacityButton(
              onTap: () {},
              child: circleWidget(
                padingSize: safeAreaWidth * 0.01,
                size: safeAreaWidth * 0.2,
                color: Colors.white,
                child: circleWidget(
                  color: Colors.white,
                  border: mainBorder(color: Colors.black, width: 2),
                ),
              ),
            ),
            photographPageIconWidget(
              Icons.cached,
              onTap: () {},
            ),
          ],
        ),
      ),
    ],
  );
}

Widget photographPageLoagingWidget(
  BuildContext context,
) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Column(
    children: [
      AspectRatio(
        aspectRatio: 3 / 4,
        child: nContainer(
          alignment: Alignment.center,
          color: subColor,
          radius: 40,
          child: nIndicatorWidget(safeAreaWidth / 30),
        ),
      ),
      Padding(
        padding: customPadding(top: safeAreaWidth * 0.15),
        child: nText(
          "準備中",
          fontSize: safeAreaWidth / 15,
        ),
      ),
    ],
  );
}

Widget photographPageAccessErrorWidget(
  BuildContext context,
) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  return SafeArea(
    child: Column(
      children: [
        Padding(
          padding: yPadding(context, ySize: safeAreaHeight * 0.1),
          child: nText(
            "カメラへのアクセス\n権限がありません",
            height: 1.3,
            fontSize: safeAreaWidth / 14,
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
        Padding(
          padding: customPadding(),
          child: nText(
            """
    アクセス権を許可するには、次の手順で変更してください。

    下記の「設定画面へ」をタップ > 「カメラ」項目を許可 
    最後にアプリを再起動してください。""",
            height: 1.3,
            fontSize: safeAreaWidth / 25,
            isOverflow: false,
            bold: 600,
          ),
        ),
        const Spacer(),
        mainButton(
          context,
          text: "設定画面へ",
          onTap: () => openAppSettings(),
        ),
      ],
    ),
  );
}

Widget photographPageSystemErrorWidget(
  BuildContext context, {
  required VoidCallback onTap,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  return SafeArea(
    child: GestureDetector(
      onTap: onTap,
      child: ColoredBox(
        color: Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: yPadding(context, ySize: safeAreaHeight * 0.1),
              child: nText(
                "不明なエラーが発生しました",
                height: 1.3,
                fontSize: safeAreaWidth / 15,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
            Padding(
              padding: customPadding(top: safeAreaHeight * 0.15),
              child: nText(
                "画面をタップして再試行してください",
                height: 1.3,
                fontSize: safeAreaWidth / 25,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
