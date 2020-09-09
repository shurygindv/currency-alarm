import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// stub
Future selectNotification(String payload) async {
  if (payload != null) {
    print('notification payload: ' + payload);
  }
}

class AlarmNotificationService {
  FlutterLocalNotificationsPlugin flutterNotificationPlugin;

  _initAndroidSettings() {
    return AndroidInitializationSettings('app_icon');
  }

  _initiOSSettings() {
    return IOSInitializationSettings();
  }

  FlutterLocalNotificationsPlugin _createFlutterNotificationPlugin() {
    return FlutterLocalNotificationsPlugin();
  }

  Future<AlarmNotificationService> init() async {
    var plugin = _createFlutterNotificationPlugin();

    var androidSettings = _initAndroidSettings();
    var iOSSettings = _initiOSSettings();

    var settings = InitializationSettings(androidSettings, iOSSettings);

    await plugin.initialize(settings, onSelectNotification: selectNotification);

    flutterNotificationPlugin = plugin;

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
