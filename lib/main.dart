import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'HomePage.dart';
import 'auth_page.dart';
import 'favorites.dart';
import 'notification.dart';
import 'search bar.dart';
import 'settings.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
  // await Firebase.initializeApp();
  // FirebaseFirestore.instance
  //     .collection('users')
  //     .doc(fullUserId())
  //     .collection("notifications")
  //     .doc("projectId")
  //     .set({
  //   "id": message.notification!.title,
  //   "name": message.notification!.body
  // });
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    // TODO: implement initState
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
          title: message.notification!.title, body: message.notification!.body);
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message.notification!.title);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    FirebaseAuth.instance
        .authStateChanges()
        .where((user) => user?.emailVerified == true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      title: 'e-SRKR',
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
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
                                    .isNotEmpty) {
                              isTheir = true;
                            }
                          } catch (Exception) {
                            isTheir = false;
                          }
                          if (isTheir) {
                            return Nav(
                                branch: mainsnapshot.data!["branch"].toString(),
                                reg: mainsnapshot.data!['reg'].toString());
                          } else {
                            return Scaffold(
                              backgroundColor: Color.fromRGBO(4, 48, 46, 1),
                              body: branchYear(),
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

class branchYear extends StatefulWidget {
  const branchYear({Key? key}) : super(key: key);

  @override
  State<branchYear> createState() => _branchYearState();
}

class _branchYearState extends State<branchYear> {
  bool isReg = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<List<branchesConvertor>>(
          stream: readbranches(),
          builder: (context, snapshot) {
            final Favourites = snapshot.data;
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 0.3,
                  color: Colors.cyan,
                ));
              default:
                if (snapshot.hasError) {
                  return Center(child: Text("Error"));
                } else {
                  if (Favourites!.length > 0)
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 20, bottom: 10),
                          child: Text(
                            "Select Branch",
                            style: TextStyle(
                                color: Colors.lightBlueAccent,
                                fontSize: 25,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: Favourites.length,
                          itemBuilder: (context, int index) {
                            final Favourite = Favourites[index];

                            return Column(
                              children: [
                                InkWell(
                                  child: Text(
                                    Favourite.id,
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  onTap: () {
                                    FirebaseFirestore.instance
                                        .collection("user")
                                        .doc(fullUserId())
                                        .set({"branch": Favourite.id});
                                    setState(() {
                                      isReg = true;
                                    });
                                  },
                                ),
                                if (isReg)
                                  StreamBuilder<List<RegulationConvertor>>(
                                      stream: readRegulation(Favourite.id),
                                      builder: (context, snapshot) {
                                        final user = snapshot.data;
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting:
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator(
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: 2,
                                                        width: 30,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: ListView.builder(
                                                          physics:
                                                              const BouncingScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              user!.length,
                                                          itemBuilder: (context,
                                                              int index) {
                                                            final SubjectsData =
                                                                user[index];
                                                            return Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                InkWell(
                                                                  child: Text(
                                                                    SubjectsData
                                                                        .id,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .lightGreenAccent,
                                                                        fontSize:
                                                                            30),
                                                                  ),
                                                                  onTap: () {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "user")
                                                                        .doc(
                                                                            fullUserId())
                                                                        .update({
                                                                      "reg":
                                                                          SubjectsData
                                                                              .id
                                                                    });
                                                                  },
                                                                )
                                                              ],
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
                                      }),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  else
                    return Text("No Branches Avaliable");
                }
            }
          }),
    );
  }
}

class Nav extends StatefulWidget {
  final String branch;
  final String reg;
  const Nav({Key? key, required this.branch, required this.reg})
      : super(key: key);

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  List<Widget> createWidgetOptions(String branch, String reg) {
    return [
      HomePage(
        branch: branch,
        reg: reg,
      ),
      favorites(),
      MyAppq(
        branch: branch,
      ),
    ];
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                      "https://i.pinimg.com/736x/01/c7/f7/01c7f72511cc6ce7858e65b45d4f8c9c.jpg",
                    ),
                    fit: BoxFit.fill),
              ),
              child: Container(
                  color: Colors.black.withOpacity(0.8),
                  child: createWidgetOptions(
                      widget.branch, widget.reg)[_selectedIndex]),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 25,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 80),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: Column(
                            children: [
                              Icon(
                                _selectedIndex == 0
                                    ? Icons.home
                                    : Icons.home_outlined,
                                size: 30,
                              ),
                              Text("Home")
                            ],
                          ),
                          onTap: () {
                            _onItemTap(0);
                          },
                        ),
                        InkWell(
                          child: Column(
                            children: [
                              Icon(
                                _selectedIndex == 1
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                              ),
                              Text("Favorite")
                            ],
                          ),
                          onTap: () {
                            _onItemTap(1);
                          },
                        ),
                        InkWell(
                          child: Column(
                            children: [
                              Icon(
                                _selectedIndex == 2
                                    ? Icons.manage_search
                                    : Icons.search,
                              ),
                              Text("Search")
                            ],
                          ),
                          onTap: () {
                            _onItemTap(2);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
