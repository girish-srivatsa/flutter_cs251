import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/After-Login/logged_out.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_auth/Screens/Login/components/ResponseR.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as secure;
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import 'courseform.dart';
import '../../components/rounded_button.dart';

class CourseWrapper extends StatefulWidget {
  final Function(String, String) callback;
  CourseWrapper({this.callback});
  @override
  _CourseWrapperState createState() => _CourseWrapperState();
}

class _CourseWrapperState extends State<CourseWrapper> {
  bool active = false;
  @override
  Widget build(BuildContext context) {
    return active
        ? CourseForm(
            callback: widget.callback,
            depressor: this.deactivator,
          )
        : up();
  }

  void activator() {
    setState(() {
      this.active = true;
    });
  }

  void deactivator() {
    setState(() {
      this.active = false;
    });
  }

  Widget up() {
    return Container(
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            alignment: Alignment.center,
            padding: EdgeInsets.all(0),
            icon: Icon(Icons.arrow_drop_up_sharp),
            splashColor: Colors.blue,
            tooltip: "open",
            onPressed: this.activator,
          ),
        ],
      ),
    );
  }
}
