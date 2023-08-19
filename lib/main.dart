import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';
import 'HomePage.dart';
import 'SubPages.dart';
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

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> backgroundHandler(RemoteMessage message) async {
 await _handleMessageData(message);
}

Future<void> _handleMessageData(RemoteMessage message) async {

  if (message.notification!.title.toString().split(";").first == "Update" ||
      message.notification!.title.toString().split(";").first == "News") {
    NotificationService().showNotification(
        title: message.notification!.title.toString().split(";").first,
        body: message.notification!.body);
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    if (message.notification!.title.toString().split(";").first == "Update") {
      FirebaseFirestore.instance
          .collection("update")
          .doc(message.notification!.title.toString().split(";").last)
          .get()
          .then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          var data = snapshot.data();
          if (data != null && data is Map<String, dynamic>) {
            UpdateConvertor newUpdate = UpdateConvertor(
              id: data["id"],
              heading: data["heading"],
              photoUrl: data["image"],
              description: data["description"],
              link: data["link"],
              branch: data["branch"],
            );
            UpdateConvertorUtil.addUpdateConvertor(newUpdate);
          }
        } else {
          print("Document does not exist.");
        }
      }).catchError((error) {
        print("An error occurred while retrieving data: $error");
      });
    }
    else {
      FirebaseFirestore.instance
          .collection("user")
          .doc(fullUserId())
          .get()
          .then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          var user = snapshot.data();
          if (user != null && user is Map<String, dynamic>) {
            FirebaseFirestore.instance
                .collection(user["branch"]).doc(user["branch"]+"News").collection(user["branch"]+"News")
                .doc(message.notification!.title.toString().split(";").last)
                .get()
                .then((DocumentSnapshot snapshot) {
              if (snapshot.exists) {
                var data = snapshot.data();
                if (data != null && data is Map<String, dynamic>) {
                  BranchNewConvertor newUpdate = BranchNewConvertor(id: data["id"],heading: data["heading"], photoUrl: data["image"], description: data["description"]);

                  BranchNewConvertorUtil.addUpdateConvertor(newUpdate);
                }
              } else {
                print("Document does not exist.");
              }
            });
          }


        } else {
          print("Document does not exist.");
        }
      });
    }

  }
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
                                    .isNotEmpty) {
                              isTheir = true;
                            }
                          } catch (Exception) {
                            isTheir = false;
                          }
                          if (isTheir) {
                            downloadAllImages(
                                context,
                                mainsnapshot.data!["branch"].toString(),
                                mainsnapshot.data!['reg'].toString());
                            return HomePage(
                              branch: mainsnapshot.data!["branch"].toString(),
                              reg: mainsnapshot.data!['reg'].toString(),
                              index: mainsnapshot.data!['index'],
                              size: size(context),
                            );
                          } else {
                            showToastText(
                                mainsnapshot.data!['branch'].toString());
                            return Scaffold(
                              backgroundColor: Color.fromRGBO(4, 48, 46, 1),
                              body: SafeArea(
                                  child: years(
                                branch: mainsnapshot.data!["branch"].toString(),
                              )),
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

  const years({Key? key, required this.branch}) : super(key: key);

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
                  child: Padding(
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
                                SubjectsData.id.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 30),
                              ),
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection("user")
                                    .doc(fullUserId())
                                    .update({"reg": SubjectsData.id});
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
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
