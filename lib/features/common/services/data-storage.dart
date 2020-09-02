import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// todo: inst, error handler
class DataStorageService {
  SharedPreferences _dataManager;

  Future<DataStorageService> init() async {
    _dataManager = await SharedPreferences.getInstance();

    return this;
  }

  Future<bool> setMap(String key, Map<String, dynamic> value) async {
    return await _dataManager.setString(key, json.encode(value));
  }

  Future<Map<String, dynamic>> getMap(String key) async {
    var result = _dataManager.getString(key);

    if (result == null) {
      return null;
    }

    return json.decode(result) as Map<String, dynamic>;
  }

  Future<bool> removeByKey(String key) async {
    return _dataManager.remove(key);
  }
}
