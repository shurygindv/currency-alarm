import 'package:get_it/get_it.dart';
//=
import 'exporter.dart'
    show
        CurrencyConverterService,
        CurrencyRateService,
        AlarmStorageService,
        AlarmNotificationService;

typedef FnAsync<T> = Future<T> Function();

void registerAsync<T>(FnAsync feature) async {
  GetIt.I.registerSingletonAsync<T>(feature);
}

void register<T>(T feature) {
  GetIt.I.registerSingleton<T>(feature);
}

void setup() {
  register(CurrencyConverterService());
  register(CurrencyRateService());

  GetIt.I.registerSingletonAsync<AlarmNotificationService>(
      () => AlarmNotificationService().init());

  GetIt.I.registerSingletonWithDependencies<AlarmStorageService>(
      () => AlarmStorageService(),
      dependsOn: [AlarmNotificationService]);
}
