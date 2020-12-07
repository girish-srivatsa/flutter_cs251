import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'courseform.dart';

class CourseWrapper extends StatefulWidget {
  final Function(String, String) callback;
  CourseWrapper({this.callback});
  @override
  _CourseWrapperState createState() => _CourseWrapperState();
}

class _CourseWrapperState extends State<CourseWrapper> {
  bool active = false;
  @override
  Widget build(BuildContext context) {
    return active
        ? CourseForm(
            callback: widget.callback,
            depressor: this.deactivator,
          )
        : up();
  }

  void activator() {
    setState(() {
      this.active = true;
    });
  }

  void deactivator() {
    setState(() {
      this.active = false;
    });
  }

  Widget up() {
    return Container(
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            alignment: Alignment.center,
            padding: EdgeInsets.all(0),
            icon: Icon(Icons.arrow_drop_up_sharp),
            splashColor: Colors.blue,
            tooltip: "open",
            onPressed: this.activator,
          ),
        ],
      ),
    );
  }
}
