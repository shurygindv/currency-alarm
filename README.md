# currency alarm

Everything what you need to track current currency rates.

Push a notification when time comes.

## demo

![preview](https://lh3.googleusercontent.com/jPyMzjyW6kSrSSbQ_itVtu3OcISmgI6O7z2HosaLhxonyjtzXQpF6d8mznUbjXME96vSigxf-bXkm_Rx1F_WVvgxnWt9EWfc6lLOWl8M2y3-Fqb8szYslQuXq_pEFTtvH_cAGh1DFOAj0qyhAxklWsHmsNsJEIEaKQfrnr3mLpLtYQwd2XRaM7aeQVE6IMWbgafp-8JEf8tVTvDQNfqbYRxmZn5dkTZ7prRmdfFRIyt08sHfgY3anz7TIEquR7M0mNb_Oyw1lLaYxI6wJkWquO487mNYuEEdOmoUI-_vsG8Ca7s4WU5YQRETLrn844WeEHt-RCIzUjLPuXztKSMaAIzeWikevYMGldHitnFzoS8ANwIKriCTuMKNhzlmdvUvIGBeq7-91cKwh44e61hcT3k8NtDmIzwS6FewGQyCBwauBSxEak4NuKnLZ2yCvhHriJYxF0urip319M-Yfi7omZPq8e5slxfeO9wiOWVMx8xkb-yveUAuH0_YWCMsOwb-rmsAOWT7f3xiZ1cShzkhZeLZs2Tc3L8nUcBeFi0BrvI3UrCpHrsLozsobV44V0b6QhDoH-Sdz4BoaUlrQbDR7jMmbw9c56lTpa4W0Q8c-bVSjxS3CDo5SmGiK-U9CWunLvdOcs1HpDiIWayOHqtLw34vpepXo6gc1TKZbwJfmD2Wwy0B5qtFBHlSxw=w249-h512-no?authuser=0)


## stack

1. flutter (look at `pubspec.yaml` for dependencies), intl - `ru_RU`, `en_US`
2. AWS DynamoDB / AWS Lambda (dev stage) / AWS API Gateway / API Cloudwatch trigger, logs

As you know, for every thing in our world need pay / wiggle: to get up-to-date currency rates we aggregate many mixed free APIs: updates once in a week / limited (<1k/2k requests per month) and pull data from available resources

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
