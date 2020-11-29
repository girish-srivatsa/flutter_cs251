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
import 'messageform.dart';
import 'messagelist.dart';

import 'messagewrapper.dart';

Future<List<Message>> getMessage(int id) async {
  String tok = await prefs.getString('token');
  final response = await http.get(
    'https://back-dashboard.herokuapp.com/api/messages/' + id.toString() + '/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'JWT ' + tok,
    },
  );
  if (response.statusCode == 200) {
    var V = jsonDecode(response.body) as List;
    List<Message> cs = V.map((course) => Message.fromJson(course)).toList();
    print(cs);
    return cs;
  }
}

final List<Message> a = <Message>[
  new Message(from_username: 'l', message: 'jk')
];

class CourseHomePage extends StatefulWidget {
  String stat;
  final int id;
  CourseHomePage({this.stat, this.id});
  @override
  _CourseHomePageState createState() => _CourseHomePageState();
}

class _CourseHomePageState extends State<CourseHomePage> {
  List<Message> messages;
  bool done = true;

  void newCourse(String message, String to) {
    print('h');
    this.setState(() {
      addMessage(message, to).then((val) => {
            setState(() {
              addm(val);
            })
          });
    });
  }

  Future<Message> addMessage(String message, String to) async {
    String tok = await prefs.getString('token');
    final response = await http.post(
      'https://back-dashboard.herokuapp.com/api/messages/' +
          this.widget.id.toString() +
          '/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ' + tok,
      },
      body: jsonEncode(<String, String>{"to": to, "message": message}),
    );
    if (response.statusCode == 200) {
      var V = jsonDecode(response.body);
      Message j = Message.fromJson(V);
      String s = await prefs.getString('username');
      print(s);
      print(j.from_username);
      print(V);
      return j;
    } else {
      return null;
    }
  }

  void addm(Message m) {
    if (m == null)
      return;
    else {
      this.messages.add(m);
    }
  }

  @override
  void initState() {
    super.initState();
    getMessage(this.widget.id).then((val) => {
          setState(() {
            this.messages = val;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    print('2');
    print(this.done);
    print(this.messages);
    if (messages == null) {
      return Container();
    }
    return new Scaffold(
        appBar: bar(),
        body: Column(
          children: <Widget>[
            Expanded(
              child: MessageList(this.messages, true),
            ),
            this.widget.stat != 'student'
                ? MessageWrapper(
                    callback: newCourse,
                    stat: this.widget.stat,
                  )
                : Container(
                    height: 0,
                  ),
          ],
        ));
  }
}

Widget bar() {
  return AppBar(title: Text("hello world"));
}
