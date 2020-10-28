import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AfterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = ModalRoute.of(context).settings.arguments.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text("Notify Me"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(name),
      ),
    );
  }
}
