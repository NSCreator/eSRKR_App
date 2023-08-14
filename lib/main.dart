import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';
import 'HomePage.dart';
import 'auth_page.dart';
import 'functins.dart';
import 'notification.dart';
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        print(message.notification!.title);
      }
    });

    ///forground work
    FirebaseMessaging.onMessage.listen((message) async {
      if (message.notification != null) {}
      print(message.notification!.title);
      NotificationService().showNotification(
        title: message.notification!.title,
        body: message.notification!.body,
      );
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message.notification!.title);
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
                          bool isTheir = false;
                          try {
                            if (mainsnapshot.data!.exists &&
                                mainsnapshot.data!['reg']
                                    .toString()
                                    .isNotEmpty &&
                                mainsnapshot.data!['branch']
                                    .toString()
                                    .isNotEmpty &&
                                mainsnapshot.data!['index']
                                    .toString()
                                    .isNotEmpty ) {
                              isTheir = true;
                            }
                          } catch (Exception) {
                            isTheir = false;
                          }
                          if (isTheir) {
                            downloadAllImages(context,
                                mainsnapshot.data!["branch"].toString(),mainsnapshot.data!['reg'].toString());
                            return HomePage(
                              branch: mainsnapshot.data!["branch"].toString(),
                              reg: mainsnapshot.data!['reg'].toString(),
                              index: mainsnapshot.data!['index'],
                              size: size(context),
                            );
                          } else {
                            return Scaffold(
                              backgroundColor: Color.fromRGBO(4, 48, 46, 1),
                              body: SafeArea(child: years(branch: mainsnapshot.data!["branch"].toString(),)),
                            );
                          }
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


class years extends StatefulWidget {
  final String branch;
 
  const years({Key? key, required this.branch})
      : super(key: key);

  @override
  State<years> createState() => _yearsState();
}

class _yearsState extends State<years> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RegulationConvertor>>(
        stream: readRegulation(widget.branch),
        builder: (context, snapshot) {
          final user = snapshot.data;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 0.3,
                    color: Colors.cyan,
                  ));
            default:
              if (snapshot.hasError) {
                return const Center(
                    child: Text(
                        'Error with TextBooks Data or\n Check Internet Connection'));
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 2,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: user!.length,
                            itemBuilder: (context, int index) {
                              final SubjectsData = user[index];
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: InkWell(
                                    child: Text(
                                      SubjectsData.id,
                                      style: TextStyle(
                                          color: Colors.lightGreenAccent,
                                          fontSize: 30),
                                    ),
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection("user")
                                          .doc(fullUserId())
                                          .update(
                                          {"reg": SubjectsData.id});

                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
          }
        });
  }
}

Stream<List<branchesConvertor>> readbranches() => FirebaseFirestore.instance
    .collection('branches')
    .orderBy("id", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => branchesConvertor.fromJson(doc.data()))
        .toList());

class branchesConvertor {
  String id;

  branchesConvertor({
    this.id = "",
  });

  Map<String, dynamic> toJson() => {
        "id": id,
      };

  static branchesConvertor fromJson(Map<String, dynamic> json) =>
      branchesConvertor(
        id: json['id'],
      );
}
