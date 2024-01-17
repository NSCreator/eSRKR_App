import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srkr_study_app/test.dart';
import 'dart:async';
import 'homePage/HomePage.dart';
import 'auth_page.dart';
import 'functions.dart';
import 'notification.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  await _handleMessageData(message);
}

Future<void> _handleMessageData(RemoteMessage message) async {
  NotificationService().showNotification(
      title: message.notification!.title, body: message.notification!.body);
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await NotificationService().initNotification();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  MobileAds.instance.initialize(

  );
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
  @override
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

  Future<void> get(BuildContext context) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("user")
          .doc(fullUserId())
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
        _databaseReference.child(data["branch"]).onValue.listen((event) async {
          String lastUpdatedFirebase = event.snapshot.value.toString();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String lastUpdatedLocal = prefs.getString("lastUpdated") ?? "";

          if (lastUpdatedLocal != lastUpdatedFirebase) {
            await getBranchStudyMaterials(data["branch"] ?? "", true);
            await prefs.setString("lastUpdated", lastUpdatedFirebase);
            showToastText("Updated");
          }
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(
            branch: data["branch"] ?? "",
            reg: data["reg"] ?? "",
            name: data["name"] ?? "",
          )));

        });
      } else {
        print("Document does not exist");
      }
    } catch (e) {
      print("Error getting data: $e");
    }
  }


  @override
  void dispose() {
    super.dispose();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null && user.emailVerified) {
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eSRKR',
      theme: ThemeData(
        useMaterial3: true,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              get(context);
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage("assets/app_logo.png")),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        height: 150,
                        width: 150,
                        margin: EdgeInsets.symmetric(vertical: 100),
                      ),
                      Container(
                          width: 200.0,
                          child: LinearProgressIndicator()),
                    ],
                  ),
                ),
              );
            } else {
              return Scaffold(body: LoginPage());
            }
          }),
      debugShowCheckedModeBanner: false,
    );
  }
}





