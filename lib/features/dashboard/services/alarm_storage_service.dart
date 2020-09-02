import 'package:currency_alarm/features/dashboard/data/models.dart';
import 'package:currency_alarm/libs/storage.dart' show Storage;
import 'package:currency_alarm/libs/background_task.dart' show BackgroundTask;
import 'package:currency_alarm/application.dart' show resolveDependency;

import './../exporter.dart' show CurrencyRateService, AlarmNotificationService;
import './../../common/exporter.dart' show CurrencyType;

const ALARM_STORAGE_KEY = '_ALARM_STORAGE_KEY_';

bool isSuccessfulSave(bool v) => v == true;

class AlarmStorageService {
  Storage storage;

  final currencyService = resolveDependency<CurrencyRateService>();
  final notificationService = resolveDependency<AlarmNotificationService>();

  // only one
  Future<int> addCurrencyAlarm({
    double currency,
    CurrencyType fromCurrency,
    CurrencyType toCurrency,
  }) async {
    final result = await Storage.setDouble(ALARM_STORAGE_KEY, currency);

    if (isSuccessfulSave(result) == true)
      _putAlarmTaskInBackground(
        currency: currency,
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
      );

    return 1;
  }

  Future<double> getCurrencyAlarmValue() =>
      Storage.getDouble(ALARM_STORAGE_KEY);

  Future<CurrencyRateResult> _fetchRates() async {
    return currencyService.fetchRate();
  }

  Future<void> _showAlarmNotification() async {
    await notificationService.showNotification(
        title: 'Warning! Time comes',
        body: 'currency has reached specified value');
  }

  _putAlarmTaskInBackground({
    double currency,
    CurrencyType fromCurrency,
    CurrencyType toCurrency,
  }) async {
    await BackgroundTask.stopAllTasks();

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
        await BackgroundTask.stopAllTasks();
      }

      print('alarm');
    });
  }
}
