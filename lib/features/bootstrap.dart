// =
import 'exporter.dart' show CurrencyConverterService, CurrencyRateService;

typedef Deeper = void Function<T>(T s);

void setup(Deeper register) {
  register(CurrencyConverterService());
  register(CurrencyRateService());
}
