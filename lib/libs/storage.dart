import 'package:shared_preferences/shared_preferences.dart';

// todo: inst
class Storage {
  get manager async => await SharedPreferences.getInstance();

  static Future<bool> setDouble(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setDouble(key, value);
  }

  static Future<double> getDouble(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getDouble(key);
  }
}
