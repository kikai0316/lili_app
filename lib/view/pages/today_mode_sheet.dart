import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/data.dart';
import 'package:lili_app/model/model.dart';

class ToDayModeSheet extends HookConsumerWidget {
  const ToDayModeSheet(
      {super.key, required this.onSuccess, required this.myProfile,});
  final void Function(String) onSuccess;
  final UserType myProfile;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final selectEmoji = useState<String?>(myProfile.toDayMood);
    return bottomSheetScaffold(context,
        backGroundColor: subColor,
        title: "今の気分は？",
        height: safeAreaHeight * 0.9,
        body: SafeArea(
          child: SizedBox(
            height: safeAreaHeight * 0.78,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: safeAreaWidth,
                  height: safeAreaHeight * 0.15,
                  child: nText(
                    selectEmoji.value ?? "未選択",
                    fontSize:
                        safeAreaWidth / (selectEmoji.value == null ? 20 : 4),
                    color:
                        selectEmoji.value == null ? Colors.grey : Colors.white,
                  ),
                ),
                Padding(
                  padding: yPadding(context),
                  child: line(),
                ),
                Padding(
                  padding: xPadding(context),
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
                              height: safeAreaWidth * 0.15,
                              width: safeAreaWidth * 0.15,
                              color: Colors.transparent,
                              child: nText(
                                item,
                                fontSize: safeAreaWidth / 7,
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
                const Spacer(),
                Padding(
                  padding: xPadding(context),
                  child: mainButton(
                    context,
                    text: "完了",
                    onTap: () {
                      Navigator.pop(context);
                      onSuccess(selectEmoji.value ?? "");
                    },
                  ),
                ),
              ],
            ),
          ),
        ),);
  }
}
