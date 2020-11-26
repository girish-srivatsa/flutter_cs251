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
import './course.dart';

class CourseList extends StatefulWidget {
  final List<Course> courses;
  final bool done;
  CourseList(this.courses, this.done);
  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  @override
  Widget build(BuildContext context) {
    return widget.done
        ? ListView.builder(
            itemCount: this.widget.courses.length,
            itemBuilder: (context, index) {
              var course = this.widget.courses[index];
              return Card(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: ListTile(
                      title: Text(course.name),
                      subtitle: Text(course.code),
                    )),
                  ],
                ),
              );
            },
          )
        : Container();
  }
}
