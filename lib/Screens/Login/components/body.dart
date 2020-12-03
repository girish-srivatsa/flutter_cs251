import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/After-Login/after.dart';
import 'package:flutter_auth/Screens/Home/home.dart';
import 'package:flutter_auth/Screens/Login/components/ResponseR.dart';
import 'package:flutter_auth/Screens/Login/components/background.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
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
import '../../../main.dart';
import '../../../function.dart';
import '../../CourseHome/coursehome.dart';

bool prof = false;

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      'https://back-dashboard.herokuapp.com/api/auth/get-token/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{"username": username, "password": password}),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 CREATED response,
      // then parse the JSON.
      print("4\n");
      print(response.body);
      var V = jsonDecode(response.body);
      String tok = V['token'];
      token = tok;
      prefs.addString('token', tok);
      print(tok);
      prefs.addString('username', username);
      DateTime expirationDate = JwtDecoder.getExpirationDate(tok);
      print(expirationDate);
      prefs.addString('expiry', expirationDate.toIso8601String());
      final resp = await http.get(
        'https://back-dashboard.herokuapp.com/api/usermy/',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT ' + tok,
        },
      );
      String z = await fbm.getToken();
      print('tok');
      print(z);
      final rs = await http.post(
        'https://back-dashboard.herokuapp.com/api/regadd/',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT ' + tok,
        },
        body: jsonEncode(<String, String>{"reg_id": z}),
      );
      print(rs.body);
      var U = jsonDecode(resp.body);
      if (U['is_professor']) {
        print("Professor Here\n");
        prof = true;
        prefs.addBool('professor', true);
      } else {
        print("No professor Here\n");
        prof = false;
        prefs.addBool('professor', false);
      }
      prefs.addBool('loggedIn', true);
      loggedIn = true;
      return Future.value(true);
    } else {
      //print(response.body);
      prefs.addBool('loggedIn', false);
      loggedIn = false;
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String username = "";
    String password = "";
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Username",
              onChanged: (String value) {
                username = value;
              },
            ),
            RoundedPasswordField(
              onChanged: (String value) {
                password = value;
              },
            ),
            RoundedButton(
              text: "LOGIN ",
              press: () {
                var beta = login(username, password);
                String eta = 'eta';
                print("\n\n");
                print(eta);
                beta.then((val) {
                  print("Reached Here\n");
                  username = "";
                  password = "";
                  if (val) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => loggedIn
                                ? HomePage(
                                    prof: prof,
                                  )
                                : LoginScreen(),
                            settings: RouteSettings(
                              arguments: val,
                            )));
                  } else {}
                });
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
