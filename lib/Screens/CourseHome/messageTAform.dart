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
import 'message.dart';
import 'messagelist.dart';
import 'messagewrapper.dart';

class MessageTAform extends StatefulWidget {
  final Function(String, String, bool) callback;
  final Function() depressor;
  MessageTAform({this.callback, this.depressor});
  @override
  _MessageTAformState createState() => _MessageTAformState();
}

class _MessageTAformState extends State<MessageTAform> {
  bool z = false;
  final _formKey = GlobalKey<FormState>();
  final controller = new TextEditingController();
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void t() {
    FocusScope.of(context).unfocus();
    widget.callback(controller.text, 'TA', this.z);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return new Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    padding: EdgeInsets.all(0),
                    color: Colors.black,
                    icon: Icon(Icons.arrow_downward_sharp),
                    onPressed: this.widget.depressor,
                  ),
                ],
              )),
          TextFormField(
            controller: this.controller,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.message),
              labelText: "Give ur message to TA",
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.send),
                    splashColor: Colors.blue,
                    tooltip: "post message",
                    onPressed: this.t,
                  ),
                  Switch(
                    value: z,
                    onChanged: (value) => {
                      setState(() {
                        this.z = value;
                      })
                    },
                    activeColor: Colors.red,
                    activeTrackColor: Colors.redAccent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
