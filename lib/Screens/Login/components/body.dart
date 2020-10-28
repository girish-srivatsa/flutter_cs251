import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/After-Login/after.dart';
import 'package:flutter_auth/Screens/Login/components/background.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResponseR {
  final int id;
  final String firstName;
  final String lastName;

  ResponseR({this.id, this.firstName, this.lastName});

  factory ResponseR.fromJson(Map<int, dynamic> json) {
    return ResponseR(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"]);
  }
}

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  Future<ResponseR> login(String username, String password) async {
    final response = await http.post(
      'https://back-dashboard.herokuapp.com/api/auth/login/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "password": password,
      }),
    );
    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return ResponseR.fromJson(jsonDecode(response.body));
    } else {
      return ResponseR(
          id: 1000000, firstName: "Hello There", lastName: "Bye Bye");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String username;
    String password;
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
              onChanged: (value) {
                username = value;
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                password = value;
              },
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                var beta = login(username, password);
                String eta = 'eta';
                beta.then((val) {
                  eta = val.firstName + " " + val.lastName;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AfterScreen(),
                          settings: RouteSettings(
                            arguments: eta,
                          )));
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
