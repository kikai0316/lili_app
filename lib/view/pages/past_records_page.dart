import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lili_app/component/app_bar.dart';
import 'package:lili_app/component/component.dart';
import 'package:lili_app/constant/color.dart';
import 'package:lili_app/constant/constant.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/data_format_utility.dart';
import 'package:lili_app/widget/on_item/on_past_post_widget.dart';

class PastRecordsPage extends HookConsumerWidget {
  const PastRecordsPage({
    super.key,
    required this.allPastPost,
  });
  final Map<String, PastPostListType> allPastPost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final dataMap = groupAndSortMapByYearMonth(allPastPost);
    final yearMonthDates = sortKeys(dataMap.keys);
    return Scaffold(
      backgroundColor: mainBackGroundColor,
      appBar: nAppBar(
        context,
        title: "過去の記録",
        leftIconType: BackIconStyleType.arrowBackBottomIcon,
      ),
      body: Padding(
        padding: xPadding(context),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final items in yearMonthDates) ...{
                Padding(
                  padding: yPadding(context),
                  child: nText(
                    items,
                    fontSize: safeAreaWidth / 20,
                  ),
                ),
                SizedBox(
                  width: safeAreaWidth,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    runSpacing: safeAreaHeight * 0.008,
                    children: [
                      for (final item
                          in pastPostDateStrings(dataMap[items]!.keys))
                        onPastPostdWidget(
                          context,
                          width: safeAreaWidth * 0.18,
                          date: item,
                          postListData: allPastPost[item],
                          isMini: true,
                        ),
                    ],
                  ),
                ),
              },
            ],
          ),
        ),
      ),
    );
  }

  Map<String, Map<String, PastPostListType>> groupAndSortMapByYearMonth(
    Map<String, PastPostListType> originalMap,
  ) {
    final Map<String, Map<String, PastPostListType>> groupedMap = {};
    for (final key in originalMap.keys) {
      final String yearMonth = key.substring(0, key.lastIndexOf("/"));
      groupedMap[yearMonth] = {key: originalMap[key]!};
    }
    return groupedMap;
  }

  List<String> sortKeys(Iterable<String> ids) {
    final DateTime today = DateTime.now();
    final List<DateTime> yearMonthDates = ids.map((ym) {
      return DateFormat("yyyy/MM").parse(ym);
    }).toList();
    yearMonthDates.sort((a, b) {
      final diffA = a.difference(today).inDays.abs();
      final diffB = b.difference(today).inDays.abs();
      return diffA.compareTo(diffB);
    });
    return yearMonthDates.map((date) {
      return DateFormat("yyyy/MM").format(date);
    }).toList();
  }
}
