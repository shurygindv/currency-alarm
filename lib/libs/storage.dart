import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// todo: inst, error handler
class Storage {
  get manager async => await SharedPreferences.getInstance();

  static Future<bool> setMap(String key, Map<String, dynamic> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var encoded = json.encode(value);

    return prefs.setString(key, encoded);
  }

  static Future<Map<String, dynamic>> getMap(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result;

    try {
      result = prefs.getString(key);
    } catch (e) {}

    if (result == null) {
      return null;
    }

    return json.decode(result) as Map<String, dynamic>;
  }

  static Future<bool> removeByKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.remove(key);
  }
}
