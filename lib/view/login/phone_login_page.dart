import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/component/loading.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/message.dart';
import 'package:lili_app/utility/notistack_utility.dart';
import 'package:lili_app/utility/screen_transition_utility.dart';
import 'package:lili_app/view/login/phone_verification_sheet.dart';
import 'package:lili_app/widget/login_widget.dart';

TextEditingController? textEditingController;

class PhoneLoginPage extends HookConsumerWidget {
  const PhoneLoginPage({super.key, required this.userProfile});
  final UserProfile userProfile;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final count = useState<int>(0);
    final isLoading = useState<bool>(false);

    useEffect(
      () {
        textEditingController = TextEditingController();
        return () => textEditingController?.dispose();
      },
      [],
    );

    return Stack(
      children: [
        Scaffold(
          backgroundColor: mainBackGroundColor,
          appBar: loginAppBar(context, isRightIcon: true),
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: xPadding(context),
                child: Column(
                  children: [
                    Padding(
                      padding: yPadding(context, ySize: safeAreaHeight * 0.06),
                      child:
                          nText("電話番号を教えてください。", fontSize: safeAreaWidth / 20),
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
                        child: mainButton(
                          context,
                          text: "認証メッセージを送信",
                          onTap: () {
                            if (count.value == 11) {
                              if (textEditingController == null) {
                                errorAlertDialog(
                                  context,
                                  subTitle: eMessageSystem,
                                );
                                return;
                              }
                              verifyPhone(
                                context,
                                isLoading,
                                userProfile,
                                textEditingController!.text,
                              );
                            }
                            // daisuke_0316@icloud.com
                            // ikutadaisuke4D
                          },
                        ),
                      ),
                    ),
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
}

Future<void> verifyPhone(
  BuildContext context,
  ValueNotifier<bool> isLoading,
  UserProfile userProfile,
  String phoneNumber,
) async {
  try {
    primaryFocus?.unfocus();
    isLoading.value = true;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+81$phoneNumber',
      verificationCompleted: (_) {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          errorAlertDialog(context, subTitle: "電話番号が正しくありません。");
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        isLoading.value = false;
        ScreenTransition(
          context,
          PhoneVerificationPage(
            phoneNumber: textEditingController!.text,
            verificationId: verificationId,
            resendToken: resendToken,
            userProfile: userProfile,
          ),
        ).normal();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  } catch (e) {
    if (!context.mounted) return;
    errorAlertDialog(context, subTitle: eMessageSystem);
  }
}
