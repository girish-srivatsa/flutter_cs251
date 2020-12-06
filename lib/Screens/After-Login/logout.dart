import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/After-Login/after.dart';
import 'package:flutter_auth/Screens/Home/home.dart';
import 'package:flutter_auth/Screens/Login/components/ResponseR.dart';
import 'package:flutter_auth/Screens/Login/components/background.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as secure;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../main.dart';
import '../../function.dart';
import '../CourseHome/coursehome.dart';

void logout(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String tok = await prefs.getString('token');
  String reg = await fbm.getToken();
  print(reg);
  print(tok);
  final response = await http.post(
    'https://back-dashboard.herokuapp.com/api/regremove/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'JWT ' + tok,
    },
    body: jsonEncode(<String, String>{"reg_id": reg}),
  );
  print(response.body);
  prefs.clear();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LoginScreen(),
    ),
  );
}

class LogoutButton extends StatefulWidget {
  @override
  _LogoutButtonState createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () => {logout(context)},
      child: Text('Logout'),
    );
  }
}
