# currency Alarm

Everything what you need to track current currency rates.

## global todo

1. use https://pub.dev/packages/flutter_hooks to manage a Widget lifecycles

# T codegen

1. `flutter pub pub run intl_translation:extract_to_arb --output-dir=assets/i18n lib/core/app_locale.dart`

2. `flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/initialize_i18n  --no-use-deferred-loading lib/core/app_locale.dart assets/i18n/intl_*.arb`
