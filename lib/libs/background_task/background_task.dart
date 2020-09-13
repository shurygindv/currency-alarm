import 'package:android_alarm_manager/android_alarm_manager.dart';

import 'isolation.dart' show checkInterval;

class BackgroundTask {
  static Future<void> setup() async {
    await AndroidAlarmManager.initialize(); // todo
    await AndroidAlarmManager.periodic(
        const Duration(hours: 2), 1, checkInterval);
  }

  static Future<void> stopAllTasks() async {
    await AndroidAlarmManager.cancel(1);
  }
}
