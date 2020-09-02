import 'package:currency_alarm/libs/storage.dart' show Storage;
import 'package:currency_alarm/libs/background_task.dart' show BackgroundTask;
import 'package:currency_alarm/application.dart' show resolveDependency;

import './currency_rate_service.dart' show CurrencyRateService;

const ALARM_STORAGE_KEY = '_ALARM_STORAGE_KEY_';

bool isSuccessfulSave(bool v) => v == true;

class AlarmStorageService {
  Storage storage;

  final currencyService = resolveDependency<CurrencyRateService>();

  // only one
  Future<bool> addCurrencyAlarm(double currencyValue) async {
    /*
    final result = await Storage.setDouble(ALARM_STORAGE_KEY, currencyValue);

    if (isSuccessfulSave(result) == true)
      _putAlarmTaskInBackground(currencyValue);

    return result;
    */
    return true;
  }

  Future<double> getCurrencyAlarmValue() =>
      Storage.getDouble(ALARM_STORAGE_KEY);

  Future<void> _fetchRates() async {
    final result = await currencyService.fetchRate();
  }

  _putAlarmTaskInBackground(double currencyValue) async {
    await BackgroundTask.stopAllTasks();

    BackgroundTask.work((String _taskId) async {
      // This is the fetch-event callback.
    });
  }
}
