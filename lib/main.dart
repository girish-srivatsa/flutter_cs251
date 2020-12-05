import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Home/home.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/constants.dart';
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
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:oktoast/oktoast.dart';

final store = new secure.FlutterSecureStorage();
final BASE = 'https://back-dashboard.herokuapp.com/';
const myTask = "syncWithTheBackEnd";
String token;
bool loggedIn;
final fbm = FirebaseMessaging();
Prefs prefs = new Prefs();

Future<dynamic> _backgroundMessageHandler(Map<String, dynamic> message) {
  print("_backgroundMessageHandler");
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("_backgroundMessageHandler data: ${data}");
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print("_backgroundMessageHandler notification: ${notification}");
  }
}

Future<void> _showMyDialog(context, String bod, bool pr) async {
  FlutterRingtonePlayer.play(
    android: AndroidSounds.notification,
    ios: IosSounds.glass,
    looping: pr, // Android only - API >= 28
    volume: 0.1, // Android only - API >= 28
    asAlarm: pr, // Android only - all APIs
  );
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
              if (pr) {
                FlutterRingtonePlayer.stop();
              }
              Navigator.of(context).pop();
              Phoenix.rebirth(context);
            },
          ),
        ],
      );
    },
  );
}

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  fbm.requestNotificationPermissions();
  fbm.getToken().then((val) => {print(val)});
  fbm.configure(onMessage: (msg) {
    print('msg');
    print(msg);
    print(Application.navKey.currentContext.size.aspectRatio);
    print(Application.navKey.currentWidget);
    var U = msg["notification"];
    print(U);
    bool prior = msg["data"]["priority"];
    _showMyDialog(Application.navKey.currentContext, U["body"], prior);
    return;
  },
      //onBackgroundMessage: _backgroundMessageHandler,
      onLaunch: (msg) async {
    print('lnch');
    print(msg);
    var U = msg["data"];
    print(U);
    String p = msg["data"]["priority"];
    bool prior;
    if (p == "true") {
      prior = true;
    } else {
      prior = false;
    }

    await Future.delayed(Duration(seconds: 10));
    _showMyDialog(Application.navKey.currentContext, U["body"], prior);

    return;
  }, onResume: (msg) async {
    print('rs');
    print(msg);
    var U = msg["data"];
    print(U);
    String p = msg["data"]["priority"];
    bool prior;
    if (p == "true") {
      prior = true;
    } else {
      prior = false;
    }
    _showMyDialog(Application.navKey.currentContext, U["body"], prior);
  });
  prefs.addBool('change', false);
  bool z = await checkLogin();
  bool p = await prefs.getBool('professor');
  if (z) {
    runApp(Phoenix(
      child: MyHomeApp(
        prof: p,
      ),
    ));
  } else {
    runApp(
      Phoenix(child: MyApp()),
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        navigatorKey: Application.navKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Auth',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: new Scaffold(body: LoginScreen()),
      ),
    );
  }
}

class MyHomeApp extends StatelessWidget {
  // This widget is the root of your application.
  final prof;
  MyHomeApp({this.prof});
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        navigatorKey: Application.navKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Auth',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: new Scaffold(body: HomePage(prof: prof)),
      ),
    );
  }
}

bool z = true;
