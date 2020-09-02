import 'package:background_fetch/background_fetch.dart';

typedef TaskFn = Future<void> Function(String taskId);

class BackgroundTask {
  static Future<int> work(TaskFn fn) {
    // default cfg
    final config = BackgroundFetchConfig(
        minimumFetchInterval: 360,
        stopOnTerminate: true,
        requiresBatteryNotLow: false,
        forceAlarmManager: false,
        requiresDeviceIdle: true);

    return BackgroundFetch.configure(config, (String taskId) async {
      await fn(taskId);

      BackgroundFetch.finish(taskId);
    });
  }

  static Future<int> stopAllTasks() {
    return BackgroundFetch.stop();
  }
}
