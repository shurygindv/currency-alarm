// =
import 'exporter.dart'
    show CurrencyConverterService, CurrencyRateService, AlarmStorageService;

typedef Deeper = void Function<T>(T s);

void setup(Deeper register) {
  register(CurrencyConverterService());
  register(CurrencyRateService());
  register(AlarmStorageService());
}
