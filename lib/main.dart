import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lili_app/model/model.dart';
import 'package:lili_app/view/home_page.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation("Asia/Tokyo"));
  await Firebase.initializeApp();
  await LineSDK.instance.setup("2003220468");
  await FirebaseMessaging.instance.requestPermission();
  await _requestPermissions();
  await _scheduleDaily8AMNotification();
  FlutterAppBadger.removeBadge();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

Future<void> _scheduleDaily8AMNotification() async {
  final times = {
    PostTimeType.am7: [7, 0],
    PostTimeType.am10: [10, 0],
    PostTimeType.pm12: [12, 0],
    PostTimeType.pm15: [15, 0],
    PostTimeType.pm18: [18, 0],
    PostTimeType.pm20: [20, 0],
    PostTimeType.pm22: [18, 53],
  };
  for (final entry in times.entries) {
    final time = entry.value;
    final notificationId = entry.key.index; // Enumのindexを通知IDとして使用
    final scheduledTime = _nextInstanceOfTime(time[0], time[1]);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      '🚨 LiLiの投稿時間になりました 🚨',
      '10分以内にLiLiで投稿しないと親友の投稿が見れません。',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'ob-1-face-daily',
          'ob-1-face-daily',
          channelDescription: 'Face photo notification',
        ),
        iOS: DarwinNotificationDetails(
          badgeNumber: 1,
          sound: 'eee.caf',
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}

tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
  final tz.Location location = tz.getLocation("Asia/Tokyo");
  final now = tz.TZDateTime.now(location);
  var scheduledDate =
      tz.TZDateTime(location, now.year, now.month, now.day, hour, minute);

  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

Future<void> _requestPermissions() async {
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}
