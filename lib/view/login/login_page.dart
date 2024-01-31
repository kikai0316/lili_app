import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/widget/login_widget.dart';

final TextEditingController textEditingController = TextEditingController();

class LoginPage extends HookConsumerWidget {
  const LoginPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final count = useState<int>(0);
    return Scaffold(
      backgroundColor: mainBackGroundColor,
      appBar: loginAppBar(context),
      body: Center(
        child: Padding(
          padding: xPadding(context),
          child: Column(
            children: [
              Padding(
                padding: yPadding(context, ySize: safeAreaHeight * 0.06),
                child: nText("電話番号を教えてください。", fontSize: safeAreaWidth / 20),
              ),
              phoneNumberInput(
                context,
                textEditingController: textEditingController,
                count: count,
              ),
              Padding(
                padding: customPadding(top: safeAreaHeight * 0.04),
                child: privacyText(context, onTap1: () {}, onTap2: () {}),
              ),
              const Spacer(),
              Padding(
                padding: yPadding(context),
                child: Opacity(
                    opacity: count.value == 11 ? 1 : 0.5,
                    child:
                        mainButton(context, text: "認証メッセージを送信", onTap: () {}),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
