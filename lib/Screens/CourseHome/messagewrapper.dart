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
import 'messageform.dart';
import '../../components/rounded_button.dart';
import 'messageAllform.dart';
import 'messageTAform.dart';

class MessageWrapper extends StatefulWidget {
  final Function(String, String) callback;
  final String stat;
  MessageWrapper({this.stat, this.callback});
  @override
  _MessageWrapperState createState() => _MessageWrapperState();
}

class _MessageWrapperState extends State<MessageWrapper> {
  bool activeTA = false;
  bool activeAll = false;

  void activatorTA() {
    setState(() {
      activeTA = true;
      activeAll = false;
    });
  }

  void activatorAll() {
    setState(() {
      activeAll = true;
      activeTA = false;
    });
  }

  void t(String s, String w) {
    print('hi');
  }

  void dp() {
    setState(() {
      activeAll = false;
      activeTA = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return activeTA
        ? MessageTAform(
            callback: this.widget.callback,
            depressor: dp,
          )
        : activeAll
            ? MessageAllform(
                callback: this.widget.callback,
                depressor: dp,
              )
            : up();
  }

  Widget up() {
    return Container(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            this.widget.stat == 'professor'
                ? Column(children: <Widget>[
                    IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.arrow_drop_up_sharp),
                      splashColor: Colors.blue,
                      tooltip: "open TA",
                      onPressed: this.activatorTA,
                    ),
                    Text('TA')
                  ])
                : Container(
                    height: 0,
                    width: 0,
                  ),
            Column(children: <Widget>[
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(Icons.arrow_drop_up_sharp),
                splashColor: Colors.blue,
                tooltip: "open All",
                onPressed: this.activatorAll,
              ),
              Text('All')
            ]),
          ],
        ));
  }
}
