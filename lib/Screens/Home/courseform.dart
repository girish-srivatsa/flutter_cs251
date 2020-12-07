import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseForm extends StatefulWidget {
  final Function(String, String) callback;
  final Function() depressor;
  CourseForm({this.callback, this.depressor});
  @override
  _CourseFormState createState() => _CourseFormState();
}

class _CourseFormState extends State<CourseForm> {
  final _formKey = GlobalKey<FormState>();
  final controller_code = new TextEditingController();
  final controller_name = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller_code.dispose();
    controller_name.dispose();
  }

  void click() {
    FocusScope.of(context).unfocus();
    widget.callback(controller_name.text, controller_code.text);
    controller_code.clear();
    controller_name.clear();
  }

  @override
  Widget build(BuildContext context) {
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
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.arrow_drop_down_sharp),
                  splashColor: Colors.blue,
                  tooltip: "close",
                  onPressed: widget.depressor,
                ),
              ],
            ),
          ),
          new TextFormField(
              controller: controller_name,
              validator: (value) {
                if (value.isEmpty) {
                  return 'CourseName empty';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "  Type in course name",
              )),
          new TextFormField(
              controller: controller_code,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Course Code empty';
                }
                if (value.length > 5) {
                  return 'long course code limit 5';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "  Type in course code",
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  this.click();
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
