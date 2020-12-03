import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/constants.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as secure;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'Screens/Home/courseform.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'function.dart';
import 'Screens/CourseHome/messagewrapper.dart';
import 'Screens/CourseHome/messageform.dart';
import 'Screens/CourseHome/coursehome.dart';
import 'Screens/CourseHome/messageTAform.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'constants.dart';

final store = new secure.FlutterSecureStorage();
final BASE = 'https://back-dashboard.herokuapp.com/';
const myTask = "syncWithTheBackEnd";
String token;
bool loggedIn;
final fbm = FirebaseMessaging();
Prefs prefs = new Prefs();
final application = new Application();

Future<void> _showMyDialog(context, String bod) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('hi'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(bod),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  /*Workmanager.initialize(callbackDispatcher);
  Workmanager.registerPeriodicTask(
    "1",
    myTask, //This is the value that will be returned in the callbackDispatcher
    frequency: Duration(minutes: 15),
    constraints: Constraints(
      requiresBatteryNotLow: true,
      networkType: NetworkType.connected,
    ),
    initialDelay: Duration(seconds: 60),
  );*/
  fbm.requestNotificationPermissions();
  fbm.getToken().then((val) => {print(val)});
  fbm.configure(onMessage: (msg) {
    print('msg');
    print(msg);
    print(Application.navKey.currentContext.size.aspectRatio);
    print(Application.navKey.currentWidget);
    var U = msg["notification"];
    print(U);
    _showMyDialog(Application.navKey.currentContext, U["body"]);
    return;
  }, onLaunch: (msg) {
    print('lnch');
    print(msg);
    return;
  }, onResume: (msg) {
    print('rs');
    print(msg);
    return;
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("appkey = ");
    print(Application.navKey);

//  A non-null String must be provided to a Text widget.
// 'package:flutter/src/widgets/text.dart':
// Failed assertion: line 370 pos 10: 'data != null'
    return MaterialApp(
      navigatorKey: Application.navKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: new Scaffold(body: LoginScreen()),
    );
  }
}

bool z = true;
