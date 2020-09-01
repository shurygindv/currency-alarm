import 'package:currency_alarm/libs/storage.dart' show Storage;

const ALARM_STORAGE_KEY = 'ALARM_STORAGE_KEY';

class AlarmStorageService {
  Storage storage;

  // only one
  Future<bool> addCurrencyAlarm(double currencyValue) =>
      Storage.setDouble(ALARM_STORAGE_KEY, currencyValue);

  Future<double> getCurrencyAlarmValue() =>
      Storage.getDouble(ALARM_STORAGE_KEY);
}
