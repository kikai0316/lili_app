import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/component/button.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/constant/data.dart';

TextEditingController? textEditingController;

class NowStateSheet extends HookConsumerWidget {
  const NowStateSheet({super.key, required this.onSuccess});
  final void Function(String) onSuccess;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final count = useState<int>(0);
    useEffect(
      () {
        textEditingController = TextEditingController();
        return () => textEditingController?.dispose();
      },
      [],
    );
    return bottomSheetScaffold(context,
        backGroundColor: subColor,
        title: "今何していますか？",
        height: safeAreaHeight * 0.9,
        body: SafeArea(
            child: Padding(
          padding: xPadding(context, top: safeAreaHeight * 0.05),
          child: Column(children: [
            nTextFormField(
              context,
              textController: textEditingController,
              fontSize: safeAreaWidth / 15,
              textAlign: TextAlign.center,
              maxLines: 1,
              maxLength: 10,
              hintText: "",
              onChanged: (value) => count.value = value.length,
            ),
            Padding(
              padding: customPadding(bottom: safeAreaHeight * 0.03),
              child: line(),
            ),
            SizedBox(
              width: safeAreaWidth,
              child: Wrap(
                runSpacing: safeAreaHeight * 0.01,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  for (final item in nowStateDataList)
                    CustomAnimatedOpacityButton(
                      onTap: () {
                        textEditingController?.text = item;
                        count.value = item.length;
                      },
                      child: nContainer(
                        padding: xPadding(
                          context,
                          xSize: safeAreaWidth * 0.04,
                          top: safeAreaWidth * 0.03,
                          bottom: safeAreaWidth * 0.03,
                        ),
                        radius: 50,
                        border: mainBorder(),
                        child: nText(item, fontSize: safeAreaWidth / 43),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: customPadding(top: safeAreaHeight * 0.04),
              child: mainButton(
                context,
                text: count.value == 0 ? "設定しない" : "完了",
                onTap: () {
                  Navigator.pop(context);
                  onSuccess(textEditingController?.text ?? "");
                },
              ),
            ),
          ],),
        ),),);
  }
}
