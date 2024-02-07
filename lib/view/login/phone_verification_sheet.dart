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
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/data_format_utility.dart';
import 'package:lili_app/utility/firebase/firebase_firestore_utility.dart';
import 'package:lili_app/utility/notistack_utility.dart';
import 'package:lili_app/utility/screen_transition_utility.dart';
import 'package:lili_app/view/login/phone_login_page.dart';
import 'package:lili_app/view/login/search_friend.dart';
import 'package:lili_app/view_model/user_data.dart';
import 'package:lili_app/widget/login_widget.dart';

TextEditingController? textEditingController;

class PhoneVerificationPage extends HookConsumerWidget {
  const PhoneVerificationPage({
    super.key,
    required this.verificationId,
    required this.resendToken,
    required this.phoneNumber,
    required this.userProfile,
  });
  final String phoneNumber;
  final String verificationId;
  final int? resendToken;
  final UserProfile userProfile;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final count = useState<int>(0);
    final isLoading = useState<bool>(false);
    final messageText = useState<Widget?>(
      nText(
        "+81$phoneNumberに送信されました",
        fontSize: safeAreaWidth / 35,
        bold: 700,
        color: Colors.grey,
      ),
    );
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
          appBar: loginAppBar(context, isLeftIcon: true),
          body: SafeArea(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: customPadding(
                      top: safeAreaHeight * 0.08,
                      bottom: safeAreaHeight * 0.02,
                    ),
                    child: nText(
                      "認証コードを入力してください。",
                      fontSize: safeAreaWidth / 20,
                    ),
                  ),
                  Padding(
                    padding: customPadding(bottom: safeAreaHeight * 0.05),
                    child: messageText.value,
                  ),
                  nTextFormField(
                    context,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    maxLength: 6,
                    textController: textEditingController,
                    keyboardType: TextInputType.phone,
                    hintText: "＊＊＊＊",
                    fontSize: safeAreaWidth / 11,
                    letterSpacing: safeAreaWidth * 0.03,
                    onChanged: (value) async {
                      count.value = value.length;
                      if (count.value >= 6) {
                        await certification(
                          context,
                          ref,
                          isLoading,
                          messageText,
                        );
                      }
                    },
                  ),
                  Padding(
                    padding: xPadding(
                      context,
                      xSize: safeAreaWidth * 0.1,
                      bottom: safeAreaHeight * 0.02,
                    ),
                    child: line(),
                  ),
                  Opacity(
                    opacity: count.value == 0 ? 1 : 0.3,
                    child: CustomAnimatedOpacityButton(
                      onTap: count.value == 0
                          ? () => verifyPhone(
                                context,
                                isLoading,
                                userProfile,
                                phoneNumber,
                              )
                          : null,
                      child: nText(
                        "新しい認証コードを送信",
                        fontSize: safeAreaWidth / 30,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
        loadinPage(
          context: context,
          isLoading: isLoading.value,
        ),
      ],
    );
  }

  Future<void> certification(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> isLoading,
    ValueNotifier<Widget?> messageText,
  ) async {
    if (textEditingController == null) {
      errorAlertDialog(context, subTitle: eMessageSystem);
      return;
    }
    final safeAreaWidth = MediaQuery.of(context).size.width;
    try {
      primaryFocus?.unfocus();
      isLoading.value = true;
      messageText.value = null;
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: textEditingController!.text,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (!context.mounted) return;
      final dbUpData = await dbFirestoreLogin(
        UserType(
          openId: userProfile.userId,
          userId: generateRandomString(),
          name: userProfile.displayName,
          postList: PostListType(),
          friendList: [],
          friendRequestList: [],
          phoneNumber: phoneNumber,
          comment: "",
        ),
      );
      if (!context.mounted) return;
      if (dbUpData == null) {
        errorAlertDialog(context, subTitle: eMessageSystem);
        return;
      }
      final userDataNotifier = ref.read(userDataNotifierProvider.notifier);
      await userDataNotifier.userDataUpDate(dbUpData);
      if (!context.mounted) return;
      ScreenTransition(
        context,
        SearchFriendPage(
          myProfile: dbUpData,
        ),
      ).normal();
      successSnackbar(context, "ようそこ！${dbUpData.name}さん！");
    } catch (_) {
      isLoading.value = false;
      messageText.value = nText(
        "コードが正しくありません。もう一度お試しください。",
        fontSize: safeAreaWidth / 35,
        bold: 700,
        color: Colors.red,
      );
    }
  }
}
