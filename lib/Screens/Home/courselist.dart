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
import 'coursestatus.dart';
import '../CourseHome/coursehome.dart';
import '../UserCourse/usercourse.dart';

Future<Status> getStat(int id) async {
  String tok = await prefs.getString('token');
  final response = await http.get(
    'https://back-dashboard.herokuapp.com/api/user/' + id.toString() + '/abc/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'JWT ' + tok,
    },
  );
  if (response.statusCode == 200) {
    var V = jsonDecode(response.body);
    Status j = Status.fromJson(V);
    return j;
  } else {
    return null;
  }
}

class CourseList extends StatefulWidget {
  final bool prof;
  final List<Course> courses;
  final bool done;
  CourseList({this.courses, this.done, this.prof});
  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  void doa(int id) {
    getStat(id).then((val) => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return CourseHomePage(
                  stat: val.status,
                  id: id,
                );
              },
            ),
          )
        });
  }

  @override
  Widget build(BuildContext context) {
    return widget.done
        ? ListView.builder(
            itemCount: this.widget.courses.length,
            itemBuilder: (context, index) {
              var course = this.widget.courses[index];
              return InkWell(
                  onTap: () => {
                        getStat(course.id).then(
                          (val) => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return CourseHomePage(
                                    stat: val.status,
                                    id: course.id,
                                  );
                                },
                              ),
                            ),
                          },
                        )
                      },
                  child: Card(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: Text(course.name),
                            subtitle: Text(course.code),
                            trailing: RaisedButton(
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return UserCourseList(
                                        prof:this.widget.prof,
                                        id: course.id,
                                      );
                                    },
                                  ),
                                )
                              },
                              color: Colors.blue,
                              child: Text('members'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
            },
          )
        : Container();
  }
}
