import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  void addInt(String key, int i) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, i);
  }

  Future<int> getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int ans = prefs.getInt(key);
    return ans;
  }

  void addString(String key, String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, val);
  }

  Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  void addBool(String key, bool b) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, b);
  }

  Future<bool> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }
}
