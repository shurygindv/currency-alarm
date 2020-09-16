# currency alarm

Everything what you need to track current currency rates.

Push a notification when time comes.

## stack

1. flutter (look at `pubspec.yaml` for dependencies), intl - `ru_RU`, `en_US`
2. AWS DynamoDB / AWS Lambda (dev stage) / AWS API Gateway / API Cloudwatch trigger, logs

As you know, for every thing in our world need pay / investigate in deep: to get up-to-date currency rates we aggregate many mixed free APIs: updates once in a week / limited (<1k/2k requests per month) and pull data from available resources

## todo

1. use https://pub.dev/packages/flutter_hooks to manage a Widget lifecycles
2. enhance error handlers
3. use AWS request mapping service
4. maybe scrapper from trading portals
5. refactoring / ux / testing
6. repeat #5

# intl codegen

1. `flutter pub pub run intl_translation:extract_to_arb --output-dir=assets/i18n lib/core/app_locale.dart`

2. `flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/initialize_i18n  --no-use-deferred-loading lib/core/app_locale.dart assets/i18n/intl_*.arb`
