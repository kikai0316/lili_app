import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/message.dart';
import 'package:lili_app/constant/url.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/notistack_utility.dart';
import 'package:lili_app/utility/screen_transition_utility.dart';
import 'package:lili_app/utility/utility.dart';
import 'package:lili_app/view/login/line_login_page.dart';

class OtherSettingSheet extends HookConsumerWidget {
  const OtherSettingSheet({
    super.key,
    required this.isLoading,
  });
  final ValueNotifier<bool> isLoading;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    void errorDialog() => errorAlertDialog(context, subTitle: eMessageSystem);
    return bottomSheetScaffold(
      context,
      backGroundColor: subColor,
      title: "その他設定",
      height: safeAreaHeight / 1.8,
      body: nListTile(
        context,
        [
          for (int i = 0; i < 5; i++)
            NListTileItemType(
              leftTitle: ["バージョン", "利用規約", "プライバシーポリシー", "ログアウト", "退会"][i],
              onTap: [
                () => showAlertDialog(
                      context,
                      title: "バージョン",
                      subTitle: "12311",
                    ),
                () => openURL(url: termsURL, onError: errorDialog),
                () => openURL(url: privacyURL, onError: errorDialog),
                () => showAlertDialog(
                      context,
                      title: "ログアウト",
                      subTitle:
                          "ログアウト後も、アカウントのデータはシステム上に残り、完全には削除されません。ログアウトを続行しますか？",
                      rightButtonText: "ログアウト",
                      leftButtonText: "キャンセル",
                      rightButtonColor: Colors.red,
                      rightButtonOnTap: () async {
                        Navigator.pop(context);
                        isLoading.value = true;
                        await LineSDK.instance.logout();
                        if (!context.mounted) return;
                        isLoading.value = false;
                        ScreenTransition(context, const LineLoginPage()).top();
                      },
                    ),
                () => showAlertDialog(
                      context,
                      title: "アカウント削除しますか？",
                      subTitle: "アカウントを削除すると、アカウントのデータは完全に失われます。本当に削除しますか？",
                      rightButtonText: "アカウント削除",
                      leftButtonText: "キャンセル",
                      rightButtonOnTap: () async {
                        Navigator.pop(context);
                      },
                    ),
              ][i],
              textColor: i >= 3 ? Colors.red : Colors.white,
            ),
        ],
      ),
    );
  }
}

// Future<void> deleteAccount() async {
//   await LineSDK.instance.logout();
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   final User? user = auth.currentUser;
//   if (user != null) {
//     try {
//       await user.delete();
//       // アカウント削除に成功した場合の処理
//       print('アカウントが正常に削除されました。');
//     } on FirebaseAuthException catch (e) {
//       // アカウント削除に失敗した場合の処理
//       if (e.code == 'requires-recent-login') {
//         print('最近のログインが必要です。もう一度ログインしてから試してください。');
//         // ユーザーに再認証を求める処理をここに実装
//       } else {
//         print('アカウント削除中にエラーが発生しました: ${e.message}');
//       }
//     } catch (e) {
//       // その他のエラー処理
//       print('アカウント削除中に未知のエラーが発生しました: $e');
//     }
//   } else {
//     print('ログインしているユーザーがいません。');
//   }
// }
