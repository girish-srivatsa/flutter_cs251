import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/After-Login/logged_out.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:http/http.dart' as http;

Future<http.Response> logout() async {
  var alpha = await http.get(
    'https://back-dashboard.herokuapp.com/rest-auth/logout/',
  );
  return alpha;
}

class AfterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = ModalRoute.of(context).settings.arguments.toString();
    String eta = "User with id " + name + " is logged in.";

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
