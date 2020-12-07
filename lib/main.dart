import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/Screens/Home/home.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as secure;
import 'function.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'constants.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:oktoast/oktoast.dart';
import 'Screens/Home/home.dart';
import 'Screens/Home/acknowledgement.dart';
import 'Screens/CourseHome/message.dart';
import 'package:flutter_dnd/flutter_dnd.dart';

final store = new secure.FlutterSecureStorage();
final BASE = 'https://back-dashboard.herokuapp.com/';
const myTask = "syncWithTheBackEnd";
String token;
bool loggedIn;
final fbm = FirebaseMessaging();
Prefs prefs = new Prefs();
const MethodChannel _channel = MethodChannel('com.example.flutter_auth/1');
Map<String, String> channelMap = {
  "id": "MESSAGES",
  "name": "MESSAGES",
  "description": "hi"
};

void _createChannel() async {
  try {
    await _channel.invokeMethod('createNotificationChannel', channelMap);
    print("2 work");
  } on PlatformException catch (e) {
    print(e);
  }
}

Future<dynamic> _backgroundMessageHandler(Map<String, dynamic> message) async {
  int filter = await FlutterDnd.getCurrentInterruptionFilter();
  String filterName = FlutterDnd.getFilterName(filter);
  print("filtername = $filterName");
  print("filter = $filter");
  if (filter == 1) {
    print("_backgroundMessageHandler");
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      debugPrint("data here......");
      final dynamic priority = data['priority'];
      bool prior = (priority == "true") ? true : false;
      print(prior);
      if (prior == true) {
        FlutterRingtonePlayer.play(
          android: AndroidSounds.notification,
          ios: IosSounds.glass,
          looping: false, // Android only - API >= 28
          volume: 1.0, // Android only - API >= 28
          asAlarm: prior, // Android only - all APIs
        );
      }
      print("_backgroundMessageHandler data: $data");
    }
  }
}

Future<void> _showMyDialog(context, String bod, bool pr,
    {bool pr1 = true}) async {
  // int filter = await FlutterDnd.getCurrentInterruptionFilter();
  // if (filter != 1) return null;
  print("pr = ");
  print(pr);
  if (pr == true) {
    FlutterRingtonePlayer.play(
      android: AndroidSounds.notification,
      ios: IosSounds.glass,
      looping: false, // Android only - API >= 28
      volume: 1, // Android only - API >= 28
      asAlarm: true, // Android only - all APIs
    );
  } else {
    if (pr1 == true) FlutterRingtonePlayer.playNotification();
    // FlutterRingtonePlayer.stop();
  }
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
  SystemChannels.lifecycle.setMessageHandler((message) async {
    debugPrint('SystemChannel $message');
    if (message == AppLifecycleState.resumed.toString()) {
      print("hi");
      Phoenix.rebirth(Application.navKey.currentContext);
      List<Message> msg = await getUnreadMessage();
      if (msg.length != 0) {
        Navigator.push(
          Application.navKey.currentContext,
          MaterialPageRoute(
            builder: (context) {
              return AcknowledgementPage(messages: msg);
            },
          ),
        );
      }
    }
  });
  fbm.requestNotificationPermissions();
  fbm.getToken().then((val) => {print(val)});
  _createChannel();
  fbm.configure(
      onMessage: (msg) {
        print('msg');
        print(msg);
        print(Application.navKey.currentContext.size.aspectRatio);
        print(Application.navKey.currentWidget);
        var U = msg["data"];
        print("U = ");
        print(U);
        String p = msg["data"]["priority"];
        bool prior;
        if (p == "true") {
          prior = true;
        } else {
          prior = false;
        }
        print("prior = ");
        print(prior);
        _showMyDialog(Application.navKey.currentContext, U["body"], prior);
        print("Finished showMyDialog");
        return;
      },
      onBackgroundMessage: _backgroundMessageHandler,
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
        // _showMyDialog(Application.navKey.currentContext, U["body"], prior);
        return;
      },
      onResume: (msg) async {
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
        // _showMyDialog(Application.navKey.currentContext, U["body"], prior, pr1:prior);
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
    print("appkey = ");
    print(Application.navKey);

//  A non-null String must be provided to a Text widget.
// 'package:flutter/src/widgets/text.dart':
// Failed assertion: line 370 pos 10: 'data != null'
    return MaterialApp(
      navigatorKey: Application.navKey,
      debugShowCheckedModeBanner: false,
      title: "Flutter Auth",
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: new Scaffold(body: LoginScreen()),
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
