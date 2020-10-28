import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/After-Login/after.dart';
import 'package:flutter_auth/Screens/Login/components/ResponseR.dart';
import 'package:flutter_auth/Screens/Login/components/background.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  Future<ResponseR> login(
      String username, String password, String uniqueId) async {
    final response = await http.post(
      'https://back-dashboard.herokuapp.com/api/auth/login/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "password": password,
        "uuid": uniqueId,
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 CREATED response,
      // then parse the JSON.
      print("4\n");
      var V = jsonDecode(response.body);
      print(V);
      return ResponseR.fromJson(V);
    } else {
      print("\n\n");
      print(response.statusCode);
      //print(response.body);
      return ResponseR(tokenForm: "");
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
                var uuid = Uuid();
                var d = uuid.v4();
                var beta = login(username, password, d);
                String eta = 'eta';
                print("\n\n");
                print(eta);
                beta.then((val) {
                  username = "";
                  password = "";
                  print("login");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AfterScreen(),
                          settings: RouteSettings(
                            arguments: val,
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
