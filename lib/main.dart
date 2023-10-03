
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';
import 'HomePage.dart';
import 'TextField.dart';
import 'auth_page.dart';
import 'firebase_options.dart';
import 'functins.dart';
import 'net.dart';
import 'notification.dart';

fullUserId() {
  var user = FirebaseAuth.instance.currentUser!.email!;
  return user;
}
isGmail() {
  var user = FirebaseAuth.instance.currentUser!.email!;

    String numberString = user.substring(0,2);

    int? number = int.tryParse(numberString);

    if (number == null && user.split("@").last == "srkrec.ac.in") {
      return true;
    } else {
      return false;
    }
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> backgroundHandler(RemoteMessage message) async {
 await _handleMessageData(message);
}

Future<void> _handleMessageData(RemoteMessage message) async {
  NotificationService().showNotification(
      title: message.notification!.title, body: message.notification!.body);
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().initNotification();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });

}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleMessageData(message);
      }
    });

    FirebaseMessaging.onMessage.listen((message) async {
      if (message.notification != null) {
        _handleMessageData(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessageData(message);
    });
  }

  @override
  void dispose() {
    super.dispose();
    FirebaseAuth.instance
        .authStateChanges()
        .where((user) => user?.emailVerified == true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'eSRKR',
      theme: ThemeData(
        useMaterial3: true,
        highlightColor: Colors.transparent,
        splashColor: Colors
            .transparent,
        splashFactory: NoSplash.splashFactory,
        scaffoldBackgroundColor: Color(0xFF060D0E),
      ),

      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 0.85,
            ),
            child: child!);
      },
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("user")
                      .doc(fullUserId())
                      .snapshots(),
                  builder: (context, mainsnapshot) {
                    switch (mainsnapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(
                            child: CircularProgressIndicator(
                          strokeWidth: 0.3,
                          color: Colors.cyan,
                        ));
                      default:
                        {
                          downloadAllImages(
                              context,
                              mainsnapshot.data!["branch"].toString(),
                              mainsnapshot.data!['reg'].toString());
                          return HomePage(name: mainsnapshot.data!['name']??"None",
                            branch: mainsnapshot.data!["branch"].toString(),
                            reg: mainsnapshot.data!['reg'].toString(),
                            size: size(context),
                          );
                        }
                    }
                  });
            } else {
              return Scaffold(body: LoginPage());
            }
          }),
      debugShowCheckedModeBanner: false,
    );
  }
}




