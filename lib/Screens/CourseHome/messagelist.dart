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
import './message.dart';

class MessageList extends StatefulWidget {
  final List<Message> messages;
  final bool done;
  MessageList(this.messages, this.done);
  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    print(this.widget.messages);
    return widget.done
        ? ListView.builder(
            itemCount: this.widget.messages.length,
            itemBuilder: (context, index) {
              var message = this.widget.messages[index];
              return Card(
                child: ListTile(
                  title: Text(message.message),
                  subtitle: Text(message.from_username),
                ),
              );
            },
          )
        : Container();
  }
}
