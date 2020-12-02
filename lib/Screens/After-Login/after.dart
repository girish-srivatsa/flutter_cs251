import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/After-Login/logged_out.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_auth/Screens/Login/components/ResponseR.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

Future<http.Response> logout() async {
  final prefs = await SharedPreferences.getInstance();
  String t = await store.read(key: 'token');
  print("token got");
  print(t);
  String w = await store.read(key: 'expiry');
  DateTime expiry = DateTime.parse(w);
  DateTime curr = new DateTime.now();
  var url = 'http://127.0.0.1:8000/api/auth/refresh-token/';
  print(t);
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'token': t}),
  );
  if (response.statusCode == 200) {
    print('success');
    var V = jsonDecode(response.body);
    String tok = V['token'];
    Map<String, dynamic> decodedToken = JwtDecoder.decode(tok);
    await store.write(key: 'token', value: tok);
    DateTime expirationDate = JwtDecoder.getExpirationDate(tok);
    await store.write(key: 'expiry', value: expirationDate.toIso8601String());
    await store.write(key: 'loggedIn', value: 'true');
    print('refresh background ok');
  } else {
    print('fail');
    await store.write(key: 'loggedIn', value: 'false');
  }
  //var url = 'http://127.0.0.1:8000/api/auth/logout/' + tok + '/';
  //var alpha = await http.get(url);
  return response;
}

Future<String> test() async {
  final prefs = await SharedPreferences.getInstance();
  String tok = prefs.getString('token');
  return tok;
}

class AfterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ResponseR name = ModalRoute.of(context).settings.arguments;
    print("\n\n");
    String X = name.token;
    print("\n\n");
    String eta = "User is logged in.";

    return Scaffold(
      appBar: AppBar(
        title: Text("Notify Me"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(eta),
      ),
      floatingActionButton: RoundedButton(
          text: "Log Out",
          press: () async {
            final noUse = logout();
            noUse.then((value) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoggedOut(),
                      settings: RouteSettings(
                        arguments: name,
                      )));
            });
          }),
    );
  }
}
