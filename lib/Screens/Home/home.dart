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
import 'course.dart';
import 'courseform.dart';
import 'courselist.dart';

import 'coursewrapper.dart';

Future<List<Course>> getCourse() async {
  String tok = await prefs.getString('token');
  final response = await http.get(
    'https://back-dashboard.herokuapp.com/api/courses/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'JWT ' + tok,
    },
  );
  if (response.statusCode == 200) {
    var V = jsonDecode(response.body) as List;
    List<Course> cs = V.map((course) => Course.fromJson(course)).toList();
    return cs;
  }
}

class HomePage extends StatefulWidget {
  bool prof;
  HomePage({this.prof});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Course> courses;
  bool done = false;

  void newCourse(String name, String code) {
    this.setState(() {
      addCourse(name, code).then((val) => {addc(courses, val)});
    });
  }

  void addc(List<Course> l, Course c) {
    if (c == null) {
      return;
    }
    if (c.name == '1' && c.code == '1') {
      return;
    } else {
      l.add(c);
    }
  }

  Future<Course> addCourse(String name, String code) async {
    String tok = await prefs.getString('token');
    final response = await http.post(
      'https://back-dashboard.herokuapp.com/api/courses/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ' + tok,
      },
      body: jsonEncode(<String, String>{"name": name, "code": code}),
    );
    print(name);
    print(code);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 201) {
      var V = jsonDecode(response.body);
      Course j = Course.fromJson(V);
      return j;
    } else {}
  }

  @override
  void initState() {
    super.initState();
    getCourse().then((val) {
      setState(() {
        this.courses = val;
        se(val);
      });
    });
  }

  void se(List<Course> l) {
    setState(() {
      this.courses = l;
      done = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    //getCourse().then((value) => {se(value)});
    print("1");
    print(this.courses);
    if (courses == null) {
      return Container();
    } else {
      print('2');
      if (!this.done) print('3');
      print(this.done);
      return Scaffold(
          appBar: bar(),
          body: Column(children: <Widget>[
            Expanded(child: CourseList(this.courses, this.done)),
            widget.prof
                ? CourseWrapper(
                    callback: newCourse,
                  )
                : Container(height: 0),
          ]));
    }
  }

  Widget bar() {
    return AppBar(title: Text("hello world"));
  }
}
