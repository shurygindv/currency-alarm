import 'package:currency_alarm/features/dashboard/data/models.dart';
import 'package:currency_alarm/libs/storage.dart' show Storage;
import 'package:currency_alarm/libs/background_task.dart' show BackgroundTask;
import 'package:currency_alarm/application.dart' show resolveDependency;

import './../exporter.dart'
    show CurrencyRateService, AlarmNotificationService, ActivatedAlarmOptions;
import './../../common/exporter.dart' show CurrencyType;

const ALARM_STORAGE_KEY = '_ALARM_STORAGE_KEY_';

bool isSuccessfulSave(bool v) => v == true;

int i = 0;

class AlarmStorageService {
  Storage storage;

  final currencyService = resolveDependency<CurrencyRateService>();
  final notificationService = resolveDependency<AlarmNotificationService>();

  // only one
  Future<int> activateCurrencyAlarm({
    double currency,
    CurrencyType fromCurrency,
    CurrencyType toCurrency,
  }) async {
    Map<String, dynamic> activationOptions = {
      "to": toCurrency,
      "from": fromCurrency,
      "currency": currency
    };

    final result = await Storage.setMap(ALARM_STORAGE_KEY, activationOptions);

    if (isSuccessfulSave(result) == true)
      _putAlarmTaskInBackground(
        currency: currency,
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
      );

    return 1;
  }

  Future<ActivatedAlarmOptions> getActiveAlarmValue() async {
    final result = await Storage.getMap(ALARM_STORAGE_KEY);

    if (result == null) {
      return null;
    }

    return ActivatedAlarmOptions.fromJson(result);
  }

  Future<bool> isAlarmActive() async {
    final result = await getActiveAlarmValue();

    return result != null;
  }

  Future<CurrencyRateResult> _fetchRates() async {
    return currencyService.fetchRate();
  }

  Future<void> _showAlarmNotification() async {
    await notificationService.showNotification(
        title: 'Warning! Time comes',
        body: 'currency has reached specified value');
  }

  _resetAlarm() async {
    await BackgroundTask.stopAllTasks();
    await Storage.removeByKey(ALARM_STORAGE_KEY);
  }

  _putAlarmTaskInBackground({
    double currency,
    CurrencyType fromCurrency,
    CurrencyType toCurrency,
  }) async {
    await _resetAlarm();

    BackgroundTask.work((String _taskId) async {
      final rate = await _fetchRates();
      String updated;

      print("DA");
      switch (fromCurrency) {
        case CurrencyType.USD:
          updated = rate.getUSDRateIn(toCurrency);
          break;
        case CurrencyType.EUR:
          updated = rate.getEURRateIn(toCurrency);
          break;
        case CurrencyType.RUB:
          updated = rate.getRUBRateIn(toCurrency);
          break;
        default:
          throw new Exception('currency_broadcast: unknown _fromCurrencyValue');
      }

      var v = double.parse(updated);
      print(v);
      print(currency);
      print(v <= currency);
      if (v <= currency) {
        await _showAlarmNotification();
        await _resetAlarm();
      }
      print(i++);
    });
  }
}
