import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import '../../main.dart';
import '../ReadBy/user.dart';
import '../After-Login/logout.dart';
import '../../constants.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

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
  final bool prof;
  final int id;
  UserCourseList({this.prof, this.id});
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

  void del(String username) async {
    String tok = await prefs.getString('token');
    print(username);
    final response = await http.post(
      'https://back-dashboard.herokuapp.com/api/usercourse/' +
          this.widget.id.toString() +
          '/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ' + tok,
      },
      body: jsonEncode(
        <String, String>{"username": username},
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      Phoenix.rebirth(Application.navKey.currentContext);
    }
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
                        title: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(message.username),
                            ),
                            this.widget.prof
                                ? RaisedButton(
                                    child: Text("delete"),
                                    onPressed: () => {del(message.username)},
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            : Container()
        : Container();
  }
}
