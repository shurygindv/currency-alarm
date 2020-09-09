import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DataStorageService {
  SharedPreferences _store;

  Future<DataStorageService> init() async {
    _store = await SharedPreferences.getInstance();

    return this;
  }

  Future<bool> setMap(String key, Map<String, dynamic> value) async {
    final serialized = json.encode(value);

    return await _store.setString(key, serialized);
  }

  Future<Map<String, dynamic>> getMap(String key) async {
    var result = _store.getString(key);

    if (result == null) {
      return null;
    }

    return json.decode(result) as Map<String, dynamic>;
  }

  Future<bool> removeByKey(String key) async {
    return _store.remove(key);
  }
}
