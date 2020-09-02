// domain

enum CurrencyType { from, USD, RUB, EUR }

extension CurrencyTypeIndex on CurrencyType {
  // Overload the [] getter to get the name of the fruit.
  operator [](String key) => (name) {
        switch (name) {
          case 'USD':
            return CurrencyType.USD;
          case 'RUB':
            return CurrencyType.RUB;
          case 'EUR':
            return CurrencyType.EUR;
          default:
            throw RangeError("enum CurrencyType contains no value '$name'");
        }
      }(key);
}
