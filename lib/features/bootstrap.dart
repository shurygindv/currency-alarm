import 'package:get_it/get_it.dart';
//=
import 'exporter.dart'
    show
        DataStorageService,
        //=
        CurrencyConverterService,
        CurrencyRateService,
        AlarmStorageService,
        AlarmNotificationService;

typedef FnAsync<T> = Future<T> Function();

void register<T>(T feature) {
  GetIt.I.registerSingleton<T>(feature);
}

// TODO: create own container-wrapper
void setup() {
  register(CurrencyConverterService());
  register(CurrencyRateService());

  GetIt.I.registerSingletonAsync<AlarmNotificationService>(
      () => AlarmNotificationService().init());

  GetIt.I.registerSingletonAsync<DataStorageService>(
      () => DataStorageService().init());

  GetIt.I.registerSingletonAsync<AlarmStorageService>(
      () => AlarmStorageService().init(),
      dependsOn: [AlarmNotificationService, DataStorageService]);
}
