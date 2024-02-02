import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/component/loading.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/utility/screen_transition_utility.dart';
import 'package:lili_app/view/login/phone_login_page.dart';
import 'package:lili_app/widget/login_widget.dart';

class LineLoginPage extends HookConsumerWidget {
  const LineLoginPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final isLoading = useState<bool>(false);
    return Stack(
      children: [
        imgWidget(size: double.infinity, assetFile: "login_background.png"),
        Scaffold(
          backgroundColor: mainBackGroundColor.withOpacity(0.95),
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: xPadding(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                yPadding(context, ySize: safeAreaHeight * 0.04),
                            child: nText(
                              "RoyalHay",
                              fontSize: safeAreaWidth / 12,
                            ),
                          ),
                          nText(
                            "私たちの日常の一コマを共有する体験",
                            fontSize: safeAreaWidth / 25,
                            color: Colors.grey,
                            bold: 700,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: yPadding(context, ySize: safeAreaHeight * 0.05),
                      child: lineLogInWidget(
                        context,
                        onTap: () => userLineRegister(context, isLoading),
                      ),
                    ),
                    privacyText(context, onTap1: () {}, onTap2: () {}),
                  ],
                ),
              ),
            ),
          ),
        ),
        loadinPage(context: context, isLoading: isLoading.value),
      ],
    );
  }

  Future<void> userLineRegister(
    BuildContext context,
    ValueNotifier<bool> isLoading,
  ) async {
    try {
      isLoading.value = true;
      final result = await LineSDK.instance.login();
      if (!context.mounted || result.userProfile?.userId == null) return;
      ScreenTransition(
        context,
        PhoneLoginPage(
          userProfile: result.userProfile!,
        ),
      ).normal();
    } catch (e) {
      isLoading.value = false;
      return;
    }
  }
}
