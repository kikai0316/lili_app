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
import 'package:lili_app/constant/data.dart';
import 'package:lili_app/constant/message.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/firebase/firebase_firestore_utility.dart';
import 'package:lili_app/utility/notistack_utility.dart';
import 'package:lili_app/utility/type_updata_utility.dart';
import 'package:lili_app/view_model/user_data.dart';

class ToDayModePage extends HookConsumerWidget {
  const ToDayModePage({super.key, required this.myProfile});
  final UserType myProfile;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final selectEmoji = useState<String?>(myProfile.toDayMood);
    final isLoading = useState<bool>(false);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: mainBackGroundColor,
          appBar: nAppBar(
            context,
            title: "今日の気分は？",
            leftIconType: BackIconStyleType.arrowBackBottomIcon,
          ),
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: xPadding(context),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: safeAreaWidth,
                      height: safeAreaHeight * 0.15,
                      child: nText(
                        selectEmoji.value ?? "現在、未選択です...",
                        fontSize: safeAreaWidth /
                            (selectEmoji.value == null ? 20 : 4),
                        color: selectEmoji.value == null
                            ? Colors.grey
                            : Colors.white,
                      ),
                    ),
                    Padding(
                      padding: yPadding(context),
                      child: line(),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: safeAreaWidth,
                        child: Wrap(
                          runSpacing: safeAreaHeight * 0.01,
                          spacing: safeAreaWidth * 0.01,
                          alignment: WrapAlignment.spaceAround,
                          children: [
                            for (final item in emojiList)
                              CustomAnimatedOpacityButton(
                                onTap: () {
                                  HapticFeedback.vibrate();
                                  selectEmoji.value = item;
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: safeAreaWidth * 0.18,
                                  width: safeAreaWidth * 0.18,
                                  color: Colors.transparent,
                                  child: nText(
                                    item,
                                    fontSize: safeAreaWidth / 6,
                                  ),
                                ),
                              ),
                            if (emojiList.length.isOdd)
                              SizedBox(
                                width: safeAreaWidth * 0.2,
                              ),
                          ],
                        ),
                      ),
                    ),
                    Opacity(
                      opacity:
                          myProfile.toDayMood == selectEmoji.value ? 0.3 : 1,
                      child: mainButton(
                        context,
                        text: "完了",
                        onTap: myProfile.toDayMood != selectEmoji.value
                            ? () => upData(
                                  context,
                                  ref,
                                  selectEmoji.value ?? "",
                                  isLoading,
                                )
                            : null,
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

  Future<void> upData(
    BuildContext context,
    WidgetRef ref,
    String emoji,
    ValueNotifier<bool> isLoading,
  ) async {
    isLoading.value = true;
    final isUpData =
        await dbFirestoreUpDataData(myProfile.openId, {"today_mood": emoji});
    if (!context.mounted) return;
    if (!isUpData) {
      isLoading.value = false;
      errorAlertDialog(context, subTitle: eMessageSystem);
      return;
    }

    final userData = userTypeUpDate(myProfile, toDayMood: emoji);
    final userDataNotifier = ref.read(userDataNotifierProvider.notifier);
    await userDataNotifier.userDataUpDate(userData);
    if (!context.mounted) return;
    isLoading.value = false;
    Navigator.pop(context);
    successSnackbar(context, "データ更新に成功しました！");
  }
}
