import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/model/model.dart';

PreferredSizeWidget? loginAppBar(
  BuildContext context, {
  bool? isLeftIcon,
  bool? isRightIcon,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return nAppBar(
    context,
    leftIconType:
        isLeftIcon == true ? BackIconStyleType.arrowBackLeftIcon : null,
    customTitle: nText(
      "RoyalHay",
      fontSize: safeAreaWidth / 15,
    ),
    customRightIcon: isRightIcon == true
        ? CustomAnimatedOpacityButton(
            onTap: () {},
            child: nText(
              "ヘルプ",
              fontSize: safeAreaWidth / 25,
              isFit: true,
            ),
          )
        : null,
  );
}

Widget privacyText(
  BuildContext context, {
  required void Function()? onTap1,
  required void Function()? onTap2,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  InlineSpan textWidget(
    String text, {
    bool? isUnderline,
    GestureRecognizer? onTap,
  }) {
    return TextSpan(
      text: text,
      recognizer: onTap,
      style: TextStyle(
        fontFamily: "Normal",
        fontVariations: const [FontVariation("wght", 600)],
        color: Colors.grey,
        fontSize: safeAreaWidth / 35,
        decoration: isUnderline == true ? TextDecoration.underline : null,
      ),
    );
  }

  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      children: [
        textWidget(
          'この操作を行うと、私たちの ',
        ),
        textWidget(
          '利用規約',
          isUnderline: true,
          onTap: TapGestureRecognizer()..onTap = onTap1,
        ),
        textWidget(
          ' と ',
        ),
        textWidget(
          'プライバシーポリシー',
          isUnderline: true,
          onTap: TapGestureRecognizer()..onTap = onTap2,
        ),
        textWidget(
          ' に同意したことになります。',
        ),
      ],
    ),
  );
}

Widget phoneNumberInput(
  BuildContext context, {
  required TextEditingController? textEditingController,
  required ValueNotifier<int> count,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;

  return Row(
    children: [
      Padding(
        padding: customPadding(right: safeAreaWidth * 0.02),
        child: nContainer(
          radius: 10,
          padding: xPadding(
            context,
            xSize: safeAreaWidth * 0.025,
            top: safeAreaWidth * 0.03,
            bottom: safeAreaWidth * 0.03,
          ),
          border: mainBorder(
            color: Colors.grey.withOpacity(0.5),
            width: 2,
          ),
          child: nText("🇯🇵 +81", fontSize: safeAreaWidth / 20),
        ),
      ),
      Expanded(
        child: nTextFormField(
          context,
          textController: textEditingController,
          fontSize: safeAreaWidth / 13,
          keyboardType: TextInputType.phone,
          hintText: "",
          maxLength: 11,
          onChanged: (value) => count.value = value.length,
        ),
      ),
    ],
  );
}

Widget lineLogInWidget(BuildContext context, {required VoidCallback onTap}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  return CustomAnimatedOpacityButton(
    onTap: onTap,
    child: nContainer(
      alignment: Alignment.center,
      height: safeAreaHeight * 0.07,
      width: safeAreaWidth * 0.85,
      color: const Color.fromARGB(255, 6, 199, 85),
      radius: 15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imgWidget(size: safeAreaHeight * 0.045, assetFile: "line_icon.png"),
          nText(
            "LINEアカウントで ログイン/新規登録",
            fontSize: safeAreaWidth / 28,
          ),
        ],
      ),
    ),
  );
}
