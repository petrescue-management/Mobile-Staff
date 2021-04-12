// import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prs_staff/repository/repository.dart';
import 'package:prs_staff/view/custom_widget/custom_dialog.dart';
import 'package:prs_staff/view/home/report/report.dart';
import 'package:prs_staff/view/login/login_request.dart';
import 'package:prs_staff/resources/location/app_data.dart';
import 'package:prs_staff/model/push_notification.dart';
// import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => AppData(),
        child: MaterialApp(
          theme: ThemeData(fontFamily: 'Philosopher'),
          initialRoute: '/',
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => MyApp(),
          },
          // home: new MyApp(),
        ),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => new _MyApp();
}

class _MyApp extends State<MyApp> {
  final _repo = Repository();

  FirebaseMessaging _fcm = FirebaseMessaging();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // DatabaseReference _dbReference;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);

    PushNotification _notificationInfo;

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initSetttings =
        InitializationSettings(initializationSettingsAndroid, null);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);

    // Used to get the current FCM token
    _fcm.getToken().then((token) {
      print('Token: $token');
    }).catchError((e) {
      print(e);
    });

    // Retrieve notification
    retrieveNotification(_notificationInfo);
  }

  Future onSelectNotification(String payload) async {}

  showNotification(String title, String body) async {
    var android = AndroidNotificationDetails(
      'id',
      'channel ',
      'description',
      priority: Priority.High,
      importance: Importance.Max,
    );
    var platform = new NotificationDetails(android, null);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platform,
      payload: 'Welcome to the Local Notification demo',
    );
  }

  retrieveNotification(PushNotification _notificationInfo) {
    Future.delayed(Duration(seconds: 1), () {
      _fcm.configure(
        // app in the foreground
        onMessage: (Map<String, dynamic> message) async {
          print('onMessage: $message');

          PushNotification notification = PushNotification.fromJson(message);

          setState(() {
            _notificationInfo = notification;
          });

          showNotification(_notificationInfo.title, _notificationInfo.body);

          // SharedPreferences sharedPreferences =
          //     await SharedPreferences.getInstance();

          // _dbReference = FirebaseDatabase.instance
          //     .reference()
          //     .child('volunteer')
          //     .child('${sharedPreferences.getString('userId')}');

          // saveOrUpdateNotifications(
          //     _notificationInfo.title, _notificationInfo.body, _dbReference);
        },

        // app in the background
        onResume: (Map<String, dynamic> message) async {
          print('onResume: $message');
        },

        // app terminated
        onLaunch: (Map<String, dynamic> message) async {
          print('onLaunch: $message');
        },
      );
    });
  }

  // saveOrUpdateNotifications(String title, String body, DatabaseReference _ref) {
  //   Map<String, dynamic> noti = {
  //     'title': title,
  //     'body': body,
  //     'datetime': DateTime.now().toString(),
  //   };

  //   _ref.child('rescue - $title').set(noti);
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: FutureBuilder<FirebaseUser>(
          future: _repo.getCurrentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.hasError) {
              return loading(context);
            } else if (snapshot.data == null) {
              return LoginRequest();
            } else {
              return HomePage();
            }
          }),
    );
  }

  
}
