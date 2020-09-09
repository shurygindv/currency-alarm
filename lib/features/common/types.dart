// domain

enum CurrencyType { from, USD, RUB, EUR }

extension CurrencyTypeIndex on CurrencyType {
  operator [](String key) => (name) {
        switch (name) {
          case 'USD':
            return CurrencyType.USD;
          case 'RUB':
            return CurrencyType.RUB;
          case 'EUR':
            return CurrencyType.EUR;
          default:
            throw RangeError("enum CurrencyType doesnt contain '$name'");
        }
      }(key);
}

CurrencyType transformToCurrencyEnum(String v) {
  return CurrencyType.from[v];
}
