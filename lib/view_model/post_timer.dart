import 'dart:async';
import 'package:lili_app/constant/data.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/utility/data_format_utility.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'post_timer.g.dart';

Timer? timer;

@Riverpod(keepAlive: true)
class PostTimerNotifier extends _$PostTimerNotifier {
  @override
  Future<Duration?> build() async {
    // timerPeriodic();
    return null;
  }

  Future<void> timerPeriodic() async {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      final postTimeType = getNextPostTime();
      if (postTimeType == null) {
        state = await AsyncValue.guard(() async => null);
      } else {
        final now = DateTime.now();
        final DateTime baseDate =
            now.hour < 3 ? DateTime(now.year, now.month, now.day - 1) : now;
        final time = convertTimeStringToDateTime(
          postTimeData[postTimeType]!,
          baseDate,
        );
        state = await AsyncValue.guard(() async => time.difference(now));
      }
    });
  }
}

PostTimeType? getNextPostTime() {
  for (final postTime in postTimeData.entries) {
    if (postTime.key == PostTimeType.wakeUp) continue;

    final isTime = isTimePassed(postTime.value);
    if (!isTime) {
      return postTime.key;
    }
  }
  return null;
}
