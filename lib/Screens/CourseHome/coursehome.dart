import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import '../../main.dart';
import 'message.dart';
import 'messagelist.dart';
import 'addStud.dart';

import 'messagewrapper.dart';
import '../After-Login/logout.dart';

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

  void newCourse(String message, String to, bool z) {
    print('h');
    this.setState(() {
      addMessage(message, to, z).then((val) => {
            setState(() {
              print(val.from_username);
              addm(val, messages);
            })
          });
    });
  }

  Future<Message> addMessage(String message, String to, bool z) async {
    String t;
    if (z) {
      t = "true";
    } else {
      t = "false";
    }
    String tok = await prefs.getString('token');
    // print("url ======== " + 'https://back-dashboard.herokuapp.com' + this.widget.id.toString() + '/');
    final response = await http.post(
      'https://back-dashboard.herokuapp.com/api/messages/' +
          this.widget.id.toString() +
          '/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ' + tok,
      },
      body: jsonEncode(
          <String, String>{"to": to, "message": message, "prior": t}),
    );
    if (response.statusCode == 200) {
      var V = jsonDecode(response.body);
      Message j = Message.fromJson(V);
      String s = await prefs.getString('username');
      j.from_username = s;
      print(s);
      print(j.from_username);
      print(V);
      return j;
    } else {
      return null;
    }
  }

  void addm(Message m, List<Message> msg) {
    if (m == null)
      return;
    else {
      msg.insert(0, m);
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

  void t() async {
    print('in');
    bool ch = await prefs.getBool('change');
    print(ch);
    if (ch) {
      print('hi');
      getMessage(this.widget.id).then((val) => {
            setState(() {
              this.messages = val;
            })
          });
      ch = false;
    }
    prefs.addBool('change', false);
    ch = await prefs.getBool('change');
    print(ch);
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
            this.widget.stat != 'student'
                ? StudentAdd(
                    stat: this.widget.stat,
                    id: this.widget.id,
                  )
                : Container(
                    height: 0,
                    width: 0,
                  ),
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
  return AppBar(
    title: Text("hello world"),
    actions: [
      LogoutButton(),
    ],
  );
}
