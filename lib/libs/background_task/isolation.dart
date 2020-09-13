// by itself (without abstractions), application independent
import 'dart:convert';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:currency_alarm/features/common/types.dart';
import 'package:currency_alarm/features/dashboard/exporter.dart'
    show ActivatedAlarmOptions, CurrencyRateService;

AndroidInitializationSettings _initAndroidSettings() {
  return AndroidInitializationSettings('app_icon');
}

IOSInitializationSettings _initiOSSettings() {
  return IOSInitializationSettings();
}

const String ALARM_STORAGE_KEY = 'alarmstorage';

FlutterLocalNotificationsPlugin _createFlutterNotificationPlugin() {
  return FlutterLocalNotificationsPlugin();
}

Future<FlutterLocalNotificationsPlugin> init() async {
  var plugin = _createFlutterNotificationPlugin();

  var androidSettings = _initAndroidSettings();
  var iOSSettings = _initiOSSettings();

  var settings = InitializationSettings(androidSettings, iOSSettings);

  await plugin.initialize(settings);

  return plugin;
}

Future<void> showNotification({String title, String body}) async {
  final instance = await init();
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id', 'channel name', 'channel description',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');

  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  await instance.show(0, title, body, platformChannelSpecifics,
      payload: "item x");
}

Future<ActivatedAlarmOptions> _getActiveAlarmOptions() async {
  final instance = await SharedPreferences.getInstance();
  var result = instance.getString(ALARM_STORAGE_KEY);

  if (result == null) {
    return null;
  }

  var ss = json.decode(result) as Map<String, dynamic>;
  return ActivatedAlarmOptions.fromJson(ss);
}

Future<void> deactivateAlarm() async {
  final instance = await SharedPreferences.getInstance();
  await instance.remove(ALARM_STORAGE_KEY);

  AndroidAlarmManager.cancel(1);
}

Future<void> checkInterval() async {
  print("task is starting");

  final rate = await CurrencyRateService().fetchRate();
  final saved = await _getActiveAlarmOptions();

  if (saved == null) {
    await deactivateAlarm();
    return;
  }

  String updated;

  switch (saved.from) {
    case CurrencyType.USD:
      updated = rate.getUSDRateIn(saved.to);
      break;
    case CurrencyType.EUR:
      updated = rate.getEURRateIn(saved.to);
      break;
    case CurrencyType.RUB:
      updated = rate.getRUBRateIn(saved.to);
      break;
    default:
      throw new Exception('currency_broadcast: unknown _fromCurrencyValue');
  }

  var v = double.parse(updated);

  const String title = 'Currency has reached the upper limit.';
  const String body = 'Warning! Time comes.';

  if (v <= saved.currency) {
    await showNotification(title: title, body: body);
    await deactivateAlarm();
  }
}
