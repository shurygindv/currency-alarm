import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  get manager async => await SharedPreferences.getInstance();

  static void setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(key, value);
  }

  static Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(key);
  }
}
