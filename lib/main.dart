import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'HomePage.dart';
import 'auth_page.dart';
import 'favorites.dart';
import 'firebase_options.dart';
import 'functins.dart';
import 'notification.dart';
import 'search bar.dart';
import 'package:flutter/cupertino.dart';
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFicdrebaseOptions.currentPlatform,
  );

  // final emulatorHost =
  // (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
  //     ? '10.0.2.2'
  //     : 'localhost';
  //
  // await FirebaseStorage.instance.useStorageEmulator(emulatorHost, 9199);
  // if (true) {
  //   await Firebase.initializeApp();
  //   await MobileAds.instance.initialize();
  //   await NotificationService().initNotification();
  //   FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  // } else {
  //   await Firebase.initializeApp(
  //       options: FirebaseOptions(
  //     apiKey: "AIzaSyDP9ZNvcadcgO_cNmwOYEOxxW_Z_JPwoZ4",
  //     projectId: "e-srkr",
  //     messagingSenderId: "1048591941251",
  //     appId: "1:1048591941251:web:40640c157719e08ca665b6",
  //   ));
  // }
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
    // TODO: implement dispose
    super.dispose();
    FirebaseAuth.instance
        .authStateChanges()
        .where((user) => user?.emailVerified == true);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontFamily: DefaultTextStyle.of(context).style.fontFamily,
      ),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'e-SRKR',
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
                                      .isNotEmpty &&
                                  mainsnapshot.data!['width']
                                      .toString()
                                      .isNotEmpty &&
                                  mainsnapshot.data!['height']
                                      .toString()
                                      .isNotEmpty) {
                                isTheir = true;
                              }
                            } catch (Exception) {
                              isTheir = false;
                            }
                            if (isTheir) {
                              return Nav(
                                height: double.parse(mainsnapshot
                                        .data!['height']
                                        .toString()) /
                                    850,
                                width: double.parse(mainsnapshot.data!['width']
                                        .toString()) /
                                    400,
                                branch: mainsnapshot.data!["branch"].toString(),
                                reg: mainsnapshot.data!['reg'].toString(),
                                index: mainsnapshot.data!['index'],
                                size: (double.parse(mainsnapshot.data!['width']
                                                .toString()) /
                                            400 +
                                        double.parse(mainsnapshot
                                                .data!['height']
                                                .toString()) /
                                            850) /
                                    2,
                              );
                            } else {
                              return Scaffold(
                                backgroundColor: Color.fromRGBO(4, 48, 46, 1),
                                body: SafeArea(child: branchYear()),
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
      ),
    );
  }
}

class branchYear extends StatefulWidget {
  final bool isUpdate;
  const branchYear({Key? key, this.isUpdate = false}) : super(key: key);

  @override
  State<branchYear> createState() => _branchYearState();
}

class _branchYearState extends State<branchYear> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<branchesConvertor>>(
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

                          return years(
                            id: Favourite.id,
                            isUpdate: widget.isUpdate,
                          );
                        },
                      ),
                    ],
                  );
                else
                  return Text("No Branches Avaliable");
              }
          }
        });
  }
}

class years extends StatefulWidget {
  final String id;
  final bool isUpdate;
  const years({Key? key, required this.id, required this.isUpdate})
      : super(key: key);

  @override
  State<years> createState() => _yearsState();
}

class _yearsState extends State<years> {
  bool isReg = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          child: Text(
            widget.id,
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          onTap: () async {
            if (!widget.isUpdate) {
              FirebaseFirestore.instance
                  .collection("user")
                  .doc(fullUserId())
                  .set({
                "branch": widget.id,
                "index": 0,
                "width": screenWidth(context),
                "height": screenHeight(context)
              });
            } else {
              FirebaseFirestore.instance
                  .collection("user")
                  .doc(fullUserId())
                  .update({"branch": widget.id});
            }
            await FirebaseFirestore.instance
                .collection("tokens")
                .doc(fullUserId())
                .update({"branch": widget.id});
            setState(() {
              isReg = !isReg;
            });
          },
        ),
        if (isReg)
          StreamBuilder<List<RegulationConvertor>>(
              stream: readRegulation(widget.id),
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
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
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
                                            if (widget.isUpdate) {
                                              Navigator.pop(context);
                                            }
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
  }
}

class Nav extends StatefulWidget {
  final String branch;
  final double height;
  final double width;
  final double size;
  final String reg;
  final int index;
  const Nav(
      {Key? key,
      required this.branch,
      required this.reg,
      this.index = 0,
      required this.height,
      required this.width,
      required this.size})
      : super(key: key);

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  List<Widget> createWidgetOptions(String branch, String reg, double width,
      double height, double size, int index) {
    return [
      HomePage(
        height: height,
        width: width,
        size: size,
        branch: branch,
        reg: reg,
        index: index,
      ),
      favorites(
        branch: branch,
        size: size,
        width: width,
        height: height,
      ),
      MyAppq(
          branch: branch, height: height, width: width, size: size, reg: reg),
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    downloadAllImages(
        widget.branch, widget.reg, widget.height, widget.width, widget.size);
    _selectedIndex = widget.index;
    _onItemTap(_selectedIndex);
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
                      widget.branch,
                      widget.reg,
                      widget.width,
                      widget.height,
                      widget.size,
                      widget.index)[_selectedIndex]),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.width * 95),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(8, 37, 38, 0.91),
                      borderRadius: BorderRadius.circular(widget.size * 15),
                      border: Border.all(color: Colors.white.withOpacity(0.5))),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: widget.height * 3, bottom: widget.width * 2),
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
                                size: widget.width * 30,
                                color: _selectedIndex == 0
                                    ? Color.fromRGBO(98, 240, 245, 1)
                                    : Color.fromRGBO(63, 155, 158, 1),
                              ),
                              Text(
                                "Home",
                                style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: widget.width * 15),
                              )
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
                                size: widget.width * 30,
                                color: _selectedIndex == 1
                                    ? Color.fromRGBO(98, 240, 245, 1)
                                    : Color.fromRGBO(63, 155, 158, 1),
                              ),
                              Text(
                                "Favorite",
                                style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: widget.width * 15),
                              )
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
                                size: widget.width * 30,
                                color: _selectedIndex == 2
                                    ? Color.fromRGBO(98, 240, 245, 1)
                                    : Color.fromRGBO(63, 155, 158, 1),
                              ),
                              Text(
                                "Search",
                                style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: widget.width * 15),
                              )
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
