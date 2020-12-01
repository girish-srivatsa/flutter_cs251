import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/After-Login/logged_out.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_auth/Screens/Login/components/ResponseR.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as secure;
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import 'message.dart';
import 'messageform.dart';
import 'messagelist.dart';
import '../Home/coursestatus.dart';
import 'messagewrapper.dart';

class StudentAdd extends StatefulWidget {
  final String stat;
  final int id;
  StudentAdd({this.id, this.stat});
  @override
  _StudentAddState createState() => _StudentAddState();
}

class _StudentAddState extends State<StudentAdd> {
  final _formKey = GlobalKey<FormState>();
  final controller = new TextEditingController();

  void addStud() async {
    print('h');
    FocusScope.of(context).unfocus();
    String tok = await prefs.getString('token');
    print('https://back-dashboard.herokuapp.com/api/user/' +
        this.widget.id.toString() +
        '/' +
        controller.text +
        '/');
    final response = await http.post(
      'https://back-dashboard.herokuapp.com/api/user/' +
          this.widget.id.toString() +
          '/' +
          controller.text +
          '/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ' + tok,
      },
      body: jsonEncode(<String, String>{"status": 'student'}),
    );
    print(response.body);
    if (response.statusCode == 201) {
      controller.clear();
    }
  }

  void addTA() async {
    print('h');
    FocusScope.of(context).unfocus();
    String tok = await prefs.getString('token');
    print('https://back-dashboard.herokuapp.com/api/user/' +
        this.widget.id.toString() +
        '/' +
        controller.text +
        '/');
    final response = await http.post(
      'https://back-dashboard.herokuapp.com/api/user/' +
          this.widget.id.toString() +
          '/' +
          controller.text +
          '/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ' + tok,
      },
      body: jsonEncode(<String, String>{"status": 'TA'}),
    );
    print(response.body);
    if (response.statusCode == 201) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Form(
      key: _formKey,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: '  type username',
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    this.widget.stat == 'professor'
                        ? ElevatedButton(
                            child: Text('TA'),
                            onPressed: addTA,
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                    ElevatedButton(
                      onPressed: addStud,
                      child: Text('Student'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TAAdd extends StatefulWidget {
  @override
  _TAAddState createState() => _TAAddState();
}

class _TAAddState extends State<TAAdd> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
