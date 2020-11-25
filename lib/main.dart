import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/constants.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as secure;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

final store = new secure.FlutterSecureStorage();
final BASE = 'http://127.0.0.1/';
const myTask = "syncWithTheBackEnd";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager.registerPeriodicTask("1",
      myTask, //This is the value that will be returned in the callbackDispatcher
      frequency: Duration(minutes: 15),
      constraints: Constraints(
        requiresBatteryNotLow: true,
        networkType: NetworkType.connected,
      ),
      backoffPolicy: BackoffPolicy.exponential,
      backoffPolicyDelay: Duration(seconds: 10));
  runApp(MyApp());
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    print('start');
    switch (task) {
      case myTask:
        print('in');
        String t = await store.read(key: 'token');
        print(t);
        if (t != null) {
          print('token found');
          DateTime exp = JwtDecoder.getExpirationDate(t);
          print(exp);
          String w = await store.read(key: 'expiry');
          print(w);
          DateTime expiry = DateTime.parse(w);
          print('hi');
          DateTime curr = new DateTime.now();
          print('bye');
          print(expiry);
          print(curr);
          if (expiry.isAfter(curr)) {
            print('still valid');
            var url =
                'https://back-dashboard.herokuapp.com/api/auth/refresh-token/';
            print(t);
            final response = await http.post(
              url,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{'token': t}),
            );
            print(response.body);
            print('done');
            if (response.statusCode == 200) {
              print('success');
              var V = jsonDecode(response.body);
              String tok = V['token'];
              Map<String, dynamic> decodedToken = JwtDecoder.decode(tok);
              await store.write(key: 'token', value: tok);
              DateTime expirationDate = JwtDecoder.getExpirationDate(tok);
              await store.write(
                  key: 'expiry', value: expirationDate.toIso8601String());
              await store.write(key: 'loggedIn', value: 'true');
              print('refresh background ok');
              return true;
            } else {
              print('fail');
              await store.write(key: 'loggedIn', value: 'false');
            }
          } else {
            await store.write(key: 'loggedIn', value: 'false');
          }
        } else {
          await store.write(key: 'loggedIn', value: 'false');
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
      home: WelcomeScreen(),
    );
  }
}
