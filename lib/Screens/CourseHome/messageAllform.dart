import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageAllform extends StatefulWidget {
  final Function(String, String, bool) callback;
  final Function() depressor;
  MessageAllform({this.callback, this.depressor});
  @override
  _MessageAllformState createState() => _MessageAllformState();
}

class _MessageAllformState extends State<MessageAllform> {
  bool z = false;
  final _formKey = GlobalKey<FormState>();
  final controller = new TextEditingController();
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void t() {
    FocusScope.of(context).unfocus();
    widget.callback(controller.text, 'student', this.z);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    print(controller.text);
    return new Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    padding: EdgeInsets.all(0),
                    color: Colors.black,
                    icon: Icon(Icons.arrow_downward_sharp),
                    onPressed: this.widget.depressor,
                  ),
                ],
              )),
          TextFormField(
            controller: this.controller,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.message),
              labelText: "Give ur message to All",
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.send),
                    splashColor: Colors.blue,
                    tooltip: "post message",
                    onPressed: this.t,
                  ),
                  Switch(
                    value: z,
                    onChanged: (value) => {
                      setState(() {
                        this.z = value;
                      })
                    },
                    activeColor: Colors.red,
                    activeTrackColor: Colors.redAccent,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
