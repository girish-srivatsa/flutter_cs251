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
import '../CourseHome/message.dart';
import '../../constants.dart';
import '../ReadBy/readby.dart';

class AcknowledgementPage extends StatefulWidget {
  final List<Message> messages;
  AcknowledgementPage({this.messages});
  @override
  _AcknowledgementPageState createState() => _AcknowledgementPageState();
}

class _AcknowledgementPageState extends State<AcknowledgementPage> {
  void acknowledge() async {
    String tok = await prefs.getString('token');
    print(tok);
    String username = await prefs.getString('username');
    print("len = ");
    print(this.widget.messages.length);
    for (var i = 0; i < this.widget.messages.length; ++i) {
      print("i = :");
      print(i);
      final response = await http.post(
        'https://back-dashboard.herokuapp.com/api/readby/' +
            this.widget.messages[i].id.toString() +
            '/',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT ' + tok,
        },
        body: jsonEncode(
          <String, String>{"username": username},
        ),
      );
    }
    Navigator.pop(Application.navKey.currentContext);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MessageList(this.widget.messages),
        RaisedButton(
          child: Text('Acknowledge'),
          onPressed: () => acknowledge(),
        )
      ],
    );
  }
}

class MessageList extends StatefulWidget {
  final List<Message> messages;
  MessageList(this.messages);
  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    print(this.widget.messages);
    return Expanded(
        child: ListView.builder(
      itemCount: this.widget.messages.length,
      itemBuilder: (context, index) {
        var message = this.widget.messages[index];
        print('message null???:--------------------');
        print(message.message == null);
        print(message.message);
        print('message:--------------------');

        return Card(
          child: ListTile(
            title: Text(message.message == null ? "" : message.message),
            subtitle: Text(message.from_username),
          ),
        );
      },
    ));
  }
}
