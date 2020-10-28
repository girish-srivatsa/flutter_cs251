import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoggedOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = ModalRoute.of(context).settings.arguments.toString();
    String eta = "The User with id " + name + " is logged out.";
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        appBar: AppBar(
            title: Text("Notify Me"),
            leading: new IconButton(
              icon: new Icon(Icons.ac_unit),
              onPressed: () => Navigator.of(context).pop(),
            )),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(eta),
        ),
      ),
    );
  }
}
