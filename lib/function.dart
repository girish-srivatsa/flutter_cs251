import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter/material.dart';
import './Screens/Login/login_screen.dart';

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

Future<bool> checkLogin() async {
  var z = await prefs.getBool('loggedIn');
  SharedPreferences p = await SharedPreferences.getInstance();
  if (z != null) {
    if (z) {
      String tok = await prefs.getString('token');
      DateTime d = JwtDecoder.getExpirationDate(tok);
      if (d.isAfter(DateTime.now())) {
        return true;
      } else {
        p.clear();
        return false;
      }
    } else {
      p.clear();
      return false;
    }
  } else {
    p.clear();
    return false;
  }
}
