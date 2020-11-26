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
  final response = await http.get(
    'https://back-dashboard.herokuapp.com/api/courses/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'JWT ' + token,
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
      courses.add(new Course(name, code));
    });
  }

  @override
  void initState() {
    super.initState();
    getCourse().then((val) {
      setState(() {
        this.courses = val;
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
    getCourse().then((value) => {se(value)});
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

  Widget bar() {
    return AppBar(title: Text("hello world"));
  }
}
