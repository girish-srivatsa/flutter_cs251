import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

///This Function Logs the user out, redirects backend to remove the token,
/// and directs user to LoginScreen.
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

///The StatefulWidget for LogoutButton
class LogoutButton extends StatefulWidget {
  @override
  _LogoutButtonState createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  ///Widget for Logout Button, uses RaisedButton and invokes logout Function.
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () => {logout(context)},
      child: Text('Logout'),
    );
  }
}
