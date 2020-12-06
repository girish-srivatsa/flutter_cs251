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
import '../Home/coursestatus.dart';
import '../ReadBy/user.dart';
import '../After-Login/logout.dart';

Future<List<User>> getUsers(int id) async {
  String tok = await prefs.getString('token');
  final response = await http.get(
    'https://back-dashboard.herokuapp.com/api/usercourse/' +
        id.toString() +
        '/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'JWT ' + tok,
    },
  );
  if (response.statusCode == 200) {
    var V = jsonDecode(response.body) as List;
    List<User> cs = V.map((course) => User.fromJson(course)).toList();
    print(cs);
    return cs;
  }
}

class UserCourseList extends StatefulWidget {
  final int id;
  UserCourseList({this.id});
  @override
  _UserCourseListState createState() => _UserCourseListState();
}

class _UserCourseListState extends State<UserCourseList> {
  List<User> users;
  bool done = false;
  @override
  void initState() {
    super.initState();
    getUsers(this.widget.id).then((val) => {
          setState(() {
            this.users = val;
            done = true;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    print(this.users);
    return done
        ? this.users.length != 0
            ? Scaffold(
                appBar: AppBar(
                  title: Text("List of users page"),
                  actions: [
                    LogoutButton(),
                  ],
                ),
                body: ListView.builder(
                  itemCount: this.users.length,
                  itemBuilder: (context, index) {
                    var message = this.users[index];
                    return Card(
                      child: ListTile(
                        title: Text(message.username),
                      ),
                    );
                  },
                ),
              )
            : Container()
        : Container();
  }
}
