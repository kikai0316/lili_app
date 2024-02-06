import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/component/loading.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/firebase/firebase_firestore_utility.dart';
import 'package:lili_app/utility/notistack_utility.dart';
import 'package:lili_app/utility/type_updata_utility.dart';
import 'package:lili_app/view_model/user_data.dart';

TextEditingController? textEditingController;

class OnEditPage extends HookConsumerWidget {
  const OnEditPage({
    super.key,
    required this.title,
    required this.initData,
    required this.userData,
  });

  final String title;
  final String initData;
  final UserType userData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final isLoading = useState<bool>(false);
    final isComment = title == "ひとこと";
    final isUserId = title == "ユーザー名";
    final isUserName = title == "名前";

    useEffect(
      () {
        textEditingController = TextEditingController(
          text: initData,
        );
        return () => textEditingController?.dispose();
      },
      [],
    );
    return Stack(
      children: [
        Scaffold(
          backgroundColor: mainBackGroundColor,
          appBar: nAppBar(context, title: title),
          body: SafeArea(
            child: Padding(
              padding: xPadding(context, top: safeAreaHeight * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  nContainer(
                    alignment: Alignment.centerLeft,
                    padding: xPadding(
                      context,
                      top: safeAreaWidth * 0.01,
                      bottom: safeAreaWidth * 0.01,
                    ),
                    // height: safeAreaHeight * (isComment ? 0.15 : 0.07),
                    width: safeAreaWidth,
                    color: Colors.white.withOpacity(0.1),
                    radius: 15,
                    child: nTextFormField(
                      context,
                      textController: textEditingController,
                      maxLength: isComment ? 100 : 20,
                      inputFormatters: isUserId
                          ? [
                              FilteringTextInputFormatter.allow(
                                RegExp('[a-zA-Z0-9._]'),
                              ),
                            ]
                          : null,
                      hintText: "$titleを入力...",
                      maxLines: isComment ? 6 : 1,
                      fontSize: safeAreaWidth / 25,
                    ),
                  ),
                  if (isUserId || isComment)
                    Padding(
                      padding: yPadding(
                        context,
                      ),
                      child: nText(
                        isUserId
                            ? "ユーザー名には、半角英数字,ピリオド（.）,アンダーバー（_）のみを使用してください。"
                            : "ひとことの文字数は100文字以内で入力してください。",
                        isOverflow: false,
                        textAlign: TextAlign.left,
                        color: Colors.grey,
                        fontSize: safeAreaWidth / 35,
                      ),
                    ),
                  const Spacer(),
                  Padding(
                    padding: yPadding(context),
                    child: mainButton(
                      context,
                      text: "完了",
                      onTap: () => upDateEvent(
                        context,
                        ref,
                        isLoading,
                        isComment: isComment,
                        isUserId: isUserId,
                        isUserName: isUserName,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        loadinPage(
          context: context,
          isLoading: isLoading.value || textEditingController == null,
        ),
      ],
    );
  }

  Widget errorTextWidget(BuildContext context) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: yPadding(context),
      child: nText(
        "$titleを入力してください",
        fontSize: safeAreaWidth / 35,
        color: Colors.red,
      ),
    );
  }

  Future<void> upDateEvent(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> isLoading, {
    required bool isComment,
    required bool isUserId,
    required bool isUserName,
  }) async {
    final textData = textEditingController?.text;
    if (textData == null) return;
    if (textData.isEmpty && !isComment) {
      errorAlertDialog(context, subTitle: "入力されたデータが空です。");
      return;
    }
    primaryFocus?.unfocus();
    isLoading.value = true;
    final isSearchUserId =
        isUserId ? await dbFirestoreSearchUserId(textData) : false;
    if (!context.mounted) return;
    if (isSearchUserId == null || isSearchUserId == true) {
      errorAlertDialog(
        context,
        subTitle: "このユーザー名は既に他の方が使用中です。別のユーザー名をお試しください。",
      );
      return;
    }
    if (initData == textData) {
      Navigator.pop(context);
      return;
    }
    final fileName = isUserName
        ? "user_name"
        : isUserId
            ? "user_id"
            : "user_comment";
    await dbFirestoreUpDataData(userData.openId, {fileName: textData});
    final userDataNotifier = ref.read(userDataNotifierProvider.notifier);
    await userDataNotifier.userDataUpDate(
      userTypeUpDate(
        userData,
        name: isUserName ? textData : null,
        userId: isUserId ? textData : null,
        comment: isComment ? textData : null,
      ),
    );
    if (!context.mounted) return;
    isLoading.value = false;
    Navigator.pop(context);
  }
}
