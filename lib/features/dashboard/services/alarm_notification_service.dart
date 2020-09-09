import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future selectNotification(String payload) async {
  if (payload != null) {
    print('notification payload: ' + payload);
  }
}

class AlarmNotificationService {
  FlutterLocalNotificationsPlugin flutterNotificationPlugin;

  Future<AlarmNotificationService> init() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();

    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    flutterNotificationPlugin = flutterLocalNotificationsPlugin;

    return this;
  }

  Future<void> showNotification({String title, String body}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterNotificationPlugin
        .show(0, title, body, platformChannelSpecifics, payload: "item x");
  }

  Future<void> cancelAll() async {
    await flutterNotificationPlugin.cancelAll();
  }
}
