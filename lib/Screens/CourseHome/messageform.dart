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
/*
class MessageTA extends StatefulWidget {
  final Function(String, String) callback;
  final Function() depressor;
  MessageTA({this.callback, this.depressor});
  @override
  _MessageTAState createState() => _MessageTAState();
}

class _MessageTAState extends State<MessageTA> {
  final _formKey = GlobalKey<FormState>();
  final controller = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void click() {
    FocusScope.of(context).unfocus();
    widget.callback(controller.text, 'TA');
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return new Form(
      key: _formKey,
      child: new Scaffold(
          body: Column(
        children: <Widget>[
          Container(
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.arrow_drop_down_sharp),
                  splashColor: Colors.blue,
                  tooltip: "close",
                  onPressed: widget.depressor,
                ),
              ],
            ),
          ),
          new TextFormField(
              controller: controller,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Message empty';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "  Type in message",
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  this.click();
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      )),
    );
  }
}

class MessageAll extends StatefulWidget {
  final Function(String, String) callback;
  final Function() depressor;
  MessageAll({this.callback, this.depressor});
  @override
  _MessageAllState createState() => _MessageAllState();
}

class _MessageAllState extends State<MessageAll> {
  final _formKey = GlobalKey<FormState>();
  final controller = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void click() {
    FocusScope.of(context).unfocus();
    widget.callback(controller.text, 'student');
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return new Form(
      key: _formKey,
      child: new Scaffold(
          body: Column(
        children: <Widget>[
          Container(
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.arrow_drop_down_sharp),
                  splashColor: Colors.blue,
                  tooltip: "close",
                  onPressed: widget.depressor,
                ),
              ],
            ),
          ),
          new TextFormField(
              controller: controller,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Message empty';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "  Type in message",
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  this.click();
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      )),
    );
  }
}
*/
