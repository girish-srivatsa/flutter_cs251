import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/After-Login/logged_out.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_auth/Screens/Login/components/ResponseR.dart';

Future<http.Response> logout(token) async {
  var url =
      'https://back-dashboard.herokuapp.com/api/auth/logout/' + token + '/';
  var alpha = await http.get(url);
  return alpha;
}

class AfterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ResponseR name = ModalRoute.of(context).settings.arguments;
    print("\n\n");
    String X = name.tokenForm;
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
            final noUse = logout(name.tokenForm);
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
