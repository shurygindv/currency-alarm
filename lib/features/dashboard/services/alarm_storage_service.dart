import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:currency_alarm/libs/background_task.dart' show BackgroundTask;
import 'package:currency_alarm/application.dart' show injectDependency;
import 'package:currency_alarm/libs/l10n/exporter.dart' show t;

import './../exporter.dart'
    show CurrencyRateService, AlarmNotificationService, ActivatedAlarmOptions;

import './../data/models.dart' show CurrencyRateResult;
import './../../common/exporter.dart' show CurrencyType, DataStorageService;

const String ALARM_STORAGE_KEY = 'alarmstorage';

bool isSuccessfulSave(bool v) => v == true;

class AlarmStorageService {
  final notificationService = injectDependency<AlarmNotificationService>();
  final currencyService = injectDependency<CurrencyRateService>();
  final storageService = injectDependency<DataStorageService>();

  final _alarmController = BehaviorSubject<ActivatedAlarmOptions>();
  Stream get getActiveAlarm => _alarmController.stream;

  void _setActiveAlarm(ActivatedAlarmOptions result) {
    _alarmController.sink.add(result);
  }

  void _resetActiveAlarm() {
    _alarmController.sink.add(null);
  }

  Future<AlarmStorageService> init() async {
    final result = await _getActiveAlarmOptions();

    _setActiveAlarm(result);

    return this;
  }

  void dispose() {}

  Future<ActivatedAlarmOptions> _getActiveAlarmOptions() async {
    final result = await storageService.getMap(ALARM_STORAGE_KEY);

    if (result == null) {
      return null;
    }

    return ActivatedAlarmOptions.fromJson(result);
  }

  _saveInStorage({
    double currency,
    CurrencyType fromCurrency,
    CurrencyType toCurrency,
  }) async {
    final serialized =
        ActivatedAlarmOptions.toMap(fromCurrency, toCurrency, currency);

    return await storageService.setMap(ALARM_STORAGE_KEY, serialized);
  }

  // only one
  Future<bool> activateCurrencyAlarm({
    double currency,
    CurrencyType fromCurrency,
    CurrencyType toCurrency,
  }) async {
    await _resetExistingAlarms();

    final result = await _saveInStorage(
      currency: currency,
      toCurrency: toCurrency,
      fromCurrency: fromCurrency,
    );

    if (isSuccessfulSave(result)) {
      _syncAlarmTaskInBackground();

      await _notifyUi();
    }
    return result;
  }

  Future<void> _notifyUi() async {
    final active = await _getActiveAlarmOptions();

    _setActiveAlarm(active);
  }

  Future<void> deactivateAlarm() async {
    await _resetExistingAlarms();
  }

  Future<CurrencyRateResult> _fetchRates() async {
    return currencyService.fetchRate();
  }

  Future<void> _showAlarmNotification() async {
    final title = t('pushMsg.needAttention');
    final body = t('pushMsg.timeComes');

    await notificationService.showNotification(title: title, body: body);
  }

  Future<void> _resetExistingAlarms() async {
    await BackgroundTask.stopAllTasks();
    await storageService.removeByKey(ALARM_STORAGE_KEY);

    _resetActiveAlarm();
  }

  // todo: refactor this
  _syncAlarmTaskInBackground() async {
    BackgroundTask.work((String _taskId) async {
      final rate = await _fetchRates();
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

      if (v <= saved.currency) {
        await _showAlarmNotification();
        await deactivateAlarm();
      }
    });
  }
}
