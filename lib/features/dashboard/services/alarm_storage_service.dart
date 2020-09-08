import 'package:currency_alarm/features/dashboard/data/models.dart';
import 'package:currency_alarm/libs/background_task.dart' show BackgroundTask;
import 'package:currency_alarm/application.dart' show injectDependency;
import 'package:currency_alarm/libs/l10n/exporter.dart' show t;

import './../exporter.dart'
    show CurrencyRateService, AlarmNotificationService, ActivatedAlarmOptions;

import './../../common/exporter.dart' show CurrencyType, DataStorageService;

const String ALARM_STORAGE_KEY = 'alarmstorage';

bool isSuccessfulSave(bool v) => v == true;

class AlarmStorageService {
  final notificationService = injectDependency<AlarmNotificationService>();
  final currencyService = injectDependency<CurrencyRateService>();
  final storageService = injectDependency<DataStorageService>();

  // only one
  Future<bool> activateCurrencyAlarm({
    double currency,
    CurrencyType fromCurrency,
    CurrencyType toCurrency,
  }) async {
    await _resetExistingAlarms();

    final activationOptions =
        ActivatedAlarmOptions.toMap(fromCurrency, toCurrency, currency);

    final result =
        await storageService.setMap(ALARM_STORAGE_KEY, activationOptions);

    if (isSuccessfulSave(result) == true)
      _putAlarmTaskInBackground(
        currency: currency,
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
      );

    return result;
  }

  Future<void> deactivateAlarm() async {
    await _resetExistingAlarms();
  }

  Future<ActivatedAlarmOptions> getActiveAlarmOptions() async {
    final result = await storageService.getMap(ALARM_STORAGE_KEY);

    if (result == null) {
      return null;
    }

    return ActivatedAlarmOptions.fromJson(result);
  }

  Future<bool> isAlarmActive() async {
    final result = await getActiveAlarmOptions();

    return result != null;
  }

  Future<CurrencyRateResult> _fetchRates() async {
    return currencyService.fetchRate();
  }

  Future<void> _showAlarmNotification() async {
    await notificationService.showNotification(
        title: t('pushMsg.needAttention'), body: t('pushMsg.timeComes'));
  }

  _resetExistingAlarms() async {
    await BackgroundTask.stopAllTasks();
    await storageService.removeByKey(ALARM_STORAGE_KEY);
  }

  _putAlarmTaskInBackground({
    double currency,
    CurrencyType fromCurrency,
    CurrencyType toCurrency,
  }) async {
    BackgroundTask.work((String _taskId) async {
      final rate = await _fetchRates();
      String updated;

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

      if (v <= currency) {
        await _showAlarmNotification();
        await _resetExistingAlarms();
        // TODO: reset ui
      }
    });
  }
}
