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

final store = new secure.FlutterSecureStorage();
final BASE = 'http://127.0.0.1/';
const myTask = "syncWithTheBackEnd";
String token;
bool loggedIn;

Prefs prefs = new Prefs();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(callbackDispatcher);
  Workmanager.registerPeriodicTask(
    "1",
    myTask, //This is the value that will be returned in the callbackDispatcher
    frequency: Duration(minutes: 15),
    constraints: Constraints(
      requiresBatteryNotLow: true,
      networkType: NetworkType.connected,
    ),
    initialDelay: Duration(seconds: 60),
  );
  final fbm = FirebaseMessaging();
  fbm.requestNotificationPermissions();
  runApp(MyApp());
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    switch (task) {
      case myTask:
        /*String t = await store.read(key: 'token');
        print(t);*/
        var z = await prefs.getBool('loggedIn');
        if (z == false) return true;
        token = await prefs.getString('token');
        if (token != null) {
          DateTime curr = new DateTime.now();
          DateTime expiry = DateTime.parse(await prefs.getString('expiry'));
          if (expiry.isAfter(curr)) {
            var url =
                'https://back-dashboard.herokuapp.com/api/auth/refresh-token/';
            final response = await http.post(
              url,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{'token': token}),
            );
            if (response.statusCode == 200) {
              var V = jsonDecode(response.body);
              token = V['token'];
              prefs.addString('token', token);
              expiry = JwtDecoder.getExpirationDate(token);
              prefs.addString('expiry', expiry.toIso8601String());
              loggedIn = true;
              prefs.addBool('loggedIn', true);
              return true;
            } else {
              prefs.addBool('loggedIn', false);
              loggedIn = false;
            }
          } else {
            prefs.addBool('loggedIn', false);
            loggedIn = false;
          }
        } else {
          prefs.addBool('loggedIn', false);
          loggedIn = false;
        }
        break;
      case Workmanager.iOSBackgroundTask:
        print("iOS background fetch delegate ran");
        return true;
        break;
    }

    //Return true when the task executed successfully or not
    return false;
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
