import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/components/ResponseR.dart';

class LoggedOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ResponseR name = ModalRoute.of(context).settings.arguments;
    String eta = "The User is logged out.";
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        appBar: AppBar(
          title: Text("Notify Me"),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(eta),
        ),
      ),
    );
  }
}
