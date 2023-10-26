import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:srkr_study_app/settings.dart';
import 'package:youtube/youtube_thumbnail.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:async';
import 'HomePage.dart';
import 'SubPages.dart';
import 'TextField.dart';
import 'auth_page.dart';
import 'firebase_options.dart';
import 'functions.dart';
import 'net.dart';
import 'notification.dart';

fullUserId() {
  var user = FirebaseAuth.instance.currentUser!.email!;
  return user;
}

bool isGmail() {
  var user = FirebaseAuth.instance.currentUser!.email!;

  String numberString = user.substring(0, 2);

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
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        // scaffoldBackgroundColor: Color.fromRGBO(1, 20, 28,1),
        scaffoldBackgroundColor: Colors.black,
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
                          return bottomBarSelection(
                              branch: mainsnapshot.data!["branch"].toString(),
                              reg: mainsnapshot.data!['reg'].toString(),
                              name: mainsnapshot.data!['name'].toString());
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

class bottomBarSelection extends StatefulWidget {
  String reg, branch, name;

  bottomBarSelection(
      {required this.branch, required this.reg, required this.name});

  @override
  State<bottomBarSelection> createState() => _bottomBarSelectionState();
}

class _bottomBarSelectionState extends State<bottomBarSelection> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orangeAccent.withOpacity(0.1),

            Colors.blue.withOpacity(0.2),
            Colors.deepPurpleAccent.withOpacity(0.12),

          ],
        ),
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: SafeArea(child: _buildPage(_currentIndex)),

        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            // Adjust blur intensity

            child: Container(
              height: 53,
              // margin: const EdgeInsets.only(left: 8, right: 8, bottom: 3),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.black.withOpacity(0.2),
                      Colors.black,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20)),
              child: BottomNavigationBar(
                // elevation:16,
                currentIndex: _currentIndex,
                onTap: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },

                backgroundColor: Colors.transparent,
                type: BottomNavigationBarType.fixed,
                // showSelectedLabels: false,

                showUnselectedLabels: false,
                items:  <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.circle,
                      color: Colors.white,
                      size: 8,
                    ),
                    label: 'Home',
                    backgroundColor: Colors.red,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.shop,
                      color: Colors.white,
                      size: 17,
                    ),
                    label: 'Events',
                    backgroundColor: Colors.red,
                  ),
                  BottomNavigationBarItem(
                    icon:Icon(
                      isGmail()|| isOwner()?Icons.add:Icons.extension,
                      color: Colors.white,
                      size: 22,
                    ),
                    label:isGmail()|| isOwner()? 'Add':'More',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.newspaper,
                      color: Colors.white,
                      size: 17,
                    ),
                    label: 'Updates',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 17,
                    ),
                    label: 'You',
                  ),
                ],
                selectedItemColor: Colors.white,
                // onTap:
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    double Size = size(context);

    switch (_currentIndex) {
      case 0:
        return HomePage(
          name: widget.name,
          branch: widget.branch,
          reg: widget.reg,
          size: Size,
        ); // Replace with your actual HomePage widget
      case 1:
        return eventsPage(
          branch: widget.branch,
          size: Size,
        );
      case 2:
        return CreatePage(
          size: Size,
          branch: widget.branch,
          reg: widget.reg,
        );
      case 3:
        return newsUpadates(
          branch: widget.branch,
          size: Size,
        );
      case 4:
        return settings(
          name: widget.name,
          branch: widget.branch,
          reg: widget.reg,
          size: Size,
        );
      default:
        return Container();
    }
  }
}

class CreatePage extends StatefulWidget {
  double size;
  String branch, reg;

  CreatePage({required this.size, required this.reg, required this.branch});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  @override
  Widget build(BuildContext context) {
    double Size=size(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                createevents(
                  heading: "event Testing",
                  description: "Working good",
                  videoUrl: "https://youtu.be/tJyxm9GCpLE?si=sDXGQlDwL_OdIp6M",
                  photoUrl: "",
                  created: fullUserId(),
                  branch: "ECE",
                  id: getID(),
                );
              },
              child: Text("add")),
          if (isGmail() || isOwner())
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          margin: EdgeInsets.only(bottom: 5, left: 2, top: 10),
                          decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.add_box_outlined,
                                    color: Colors.white70,
                                    size: widget.size * 25,
                                  ),
                                  Text(
                                    " Create Regulation by R2_",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 25,
                                color: Colors.white54,
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              var InputController;
                              return Dialog(
                                backgroundColor: Colors.black.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        widget.size * 20)),
                                elevation: 16,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    border: Border.all(color: Colors.white24),
                                    borderRadius:
                                        BorderRadius.circular(widget.size * 20),
                                  ),
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      SizedBox(height: widget.size * 15),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: widget.size * 15),
                                        child: Text(
                                          "Add Regulation by Entering r20",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: widget.size * 18),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: widget.size * 10),
                                        child: TextFieldContainer(
                                          child: TextField(
                                            controller: InputController,
                                            textInputAction:
                                                TextInputAction.next,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: widget.size * 20),
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    'r2_ <= Enter Regulation Number',
                                                hintStyle: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize:
                                                        widget.size * 20)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: widget.size * 5,
                                      ),
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Spacer(),
                                            InkWell(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black26,
                                                  border: Border.all(
                                                      color: Colors.white
                                                          .withOpacity(0.3)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          widget.size * 25),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          widget.size * 15,
                                                      vertical:
                                                          widget.size * 5),
                                                  child: Text(
                                                    "Back",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            widget.size * 14),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            SizedBox(
                                              width: widget.size * 10,
                                            ),
                                            InkWell(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  border: Border.all(
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          widget.size * 25),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          widget.size * 15,
                                                      vertical:
                                                          widget.size * 5),
                                                  child: Text(
                                                    "ADD + ",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            widget.size * 14),
                                                  ),
                                                ),
                                              ),
                                              onTap: () async {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  // Prevents dismissing the dialog by tapping outside
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          CircularProgressIndicator(),
                                                          SizedBox(height: 16),
                                                          Text('Creating...'),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                                String reg =
                                                    InputController.text;
                                                for (int year = 1;
                                                    year <= 4;
                                                    year++) {
                                                  for (int sem = 1;
                                                      sem <= 2;
                                                      sem++) {
                                                    print(
                                                        "${reg.toLowerCase()} $year year $sem sem");
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            widget.branch)
                                                        .doc("regulation")
                                                        .collection(
                                                            "regulationWithYears")
                                                        .doc(
                                                            "${reg.toLowerCase()} $year year $sem sem"
                                                                .substring(
                                                                    0, 10))
                                                        .set({
                                                      "id":
                                                          "${reg.toLowerCase()} $year year $sem sem"
                                                              .substring(0, 10),
                                                      "syllabus": "",
                                                      "modelPaper": "",
                                                    });
                                                    await createRegulationSem(
                                                        name:
                                                            "${reg.toLowerCase()} $year year $sem sem",
                                                        branch: widget.branch);
                                                  }
                                                }
                                                messageToOwner(
                                                    "Regulation is Created.\nBy '${fullUserId()}'\n   Regulation : $reg\n **${widget.branch}");
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            SizedBox(
                                              width: widget.size * 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: widget.size * 10,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      Text(
                        "Create New",
                        style: TextStyle(
                            color: Colors.orangeAccent.withOpacity(0.8),
                            fontSize: 22),
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                margin: EdgeInsets.only(
                                    bottom: 5, right: 2, top: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child:                                    Row(
                                        children: [
                                          Icon(
                                            Icons.add_box_outlined,
                                            color: Colors.white70,
                                            size: widget.size * 25,
                                          ),
                                          Expanded(
                                            child: Text(
                                              " Flash News",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25),maxLines:1
                                            ),
                                          ),

                                        ],
                                      ),

                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 25,
                                      color: Colors.white54,
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => flashNewsCreator(
                                              branch: widget.branch,
                                              size: widget.size,
                                            )));
                              },
                            ),
                          ),
                          Flexible(
                            child: InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                margin: EdgeInsets.only(
                                    bottom: 5, left: 2, top: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.add_box_outlined,
                                          color: Colors.white70,
                                          size: widget.size * 25,
                                        ),
                                        Text(
                                          " News",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 25,
                                      color: Colors.white54,
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => updateCreator(
                                              branch: widget.branch,
                                              size: widget.size,
                                            )));
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create Materials",
                        style: TextStyle(
                            color: Colors.orangeAccent.withOpacity(0.8),
                            fontSize: 22),
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                margin: EdgeInsets.only(
                                    bottom: 5, right: 2, top: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.add_box_outlined,
                                          color: Colors.white70,
                                          size: widget.size * 25,
                                        ),
                                        Text(
                                          " Subject",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 25,
                                      color: Colors.white54,
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SubjectsCreator(
                                              size: widget.size,
                                              branch: widget.branch,
                                            )));
                              },
                            ),
                          ),
                          Flexible(
                            child: InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                margin: EdgeInsets.only(
                                    bottom: 5, left: 2, top: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.add_box_outlined,
                                          color: Colors.white70,
                                          size: widget.size * 25,
                                        ),
                                        Text(
                                          " Lab Subject",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 25,
                                      color: Colors.white54,
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SubjectsCreator(
                                              size: widget.size,
                                              branch: widget.branch,
                                            )));
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                margin: EdgeInsets.only(bottom: 5, right: 2),
                                decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.add_box_outlined,
                                          color: Colors.white70,
                                          size: widget.size * 25,
                                        ),
                                        Text(
                                          " Books",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 25,
                                      color: Colors.white54,
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BooksCreator(
                                              branch: widget.branch,
                                            )));
                              },
                            ),
                          ),
                          Flexible(
                            child: Container(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            margin:
                                EdgeInsets.only(bottom: 5, right: 2, top: 10),
                            decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.add_box_outlined,
                                      color: Colors.white54,
                                      size: widget.size * 25,
                                    ),
                                    Text(
                                      " Time Table",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  size: 25,
                                  color: Colors.white54,
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        timeTableSyllabusModalPaperCreator(
                                          size: widget.size,
                                          mode: 'Time Table',
                                          reg: widget.reg,
                                          branch: widget.branch,
                                        )));
                          },
                        ),
                      ),
                      Flexible(
                        child: Container(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            margin:
                                EdgeInsets.only(bottom: 5, right: 2, top: 10),
                            decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.add_box_outlined,
                                      color: Colors.white54,
                                      size: widget.size * 25,
                                    ),
                                    Text(
                                      " Syllabus",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  size: 25,
                                  color: Colors.white54,
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            if (widget.reg.isNotEmpty && widget.reg != "None")
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          timeTableSyllabusModalPaperCreator(
                                            heading: widget.reg,
                                            size: widget.size,
                                            mode: 'Syllabus',
                                            reg: widget.reg,
                                            branch: widget.branch,
                                            id: widget.reg,
                                          )));
                            else {
                              showToastText("Select Your Regulation");
                            }
                          },
                        ),
                      ),
                      Flexible(
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            margin:
                                EdgeInsets.only(bottom: 5, left: 2, top: 10),
                            decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.add_box_outlined,
                                      color: Colors.white54,
                                      size: widget.size * 25,
                                    ),
                                    Text(
                                      " Model Paper",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: widget.size * 22),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  size: 25,
                                  color: Colors.white54,
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            if (widget.reg.isNotEmpty && widget.reg != "None")
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          timeTableSyllabusModalPaperCreator(
                                            heading: widget.reg,
                                            size: widget.size,
                                            mode: 'modalPaper',
                                            reg: widget.reg,
                                            branch: widget.branch,
                                            id: widget.reg,
                                          )));
                            else {
                              showToastText("Select Your Regulation");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Size * 10, vertical: Size * 10),
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: InkWell(
                    child: Padding(
                      padding:
                      EdgeInsets.only(right: Size * 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            border:
                            Border.all(color: Colors.white10),
                            borderRadius: BorderRadius.all(
                                Radius.circular(Size * 15))),
                        child: Padding(
                          padding: EdgeInsets.all(Size * 8.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Text To Speech",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: Size * 25,
                                    fontWeight: FontWeight.w600),
                              ),
                              Container(
                                height: Size * 25,
                                width: Size * 25,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/img.png")),
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(
                                            Size * 20))),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration:
                          const Duration(milliseconds: 300),
                          pageBuilder: (context, animation,
                              secondaryAnimation) =>
                              MyHomePage(),
                          transitionsBuilder: (context, animation,
                              secondaryAnimation, child) {
                            final fadeTransition = FadeTransition(
                              opacity: animation,
                              child: child,
                            );

                            return Container(
                              color: Colors.black
                                  .withOpacity(animation.value),
                              child: AnimatedOpacity(
                                  duration:
                                  Duration(milliseconds: 300),
                                  opacity: animation.value
                                      .clamp(0.3, 1.0),
                                  child: fadeTransition),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Flexible(
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.01),
                            border: Border.all(color: Colors.white10),
                            borderRadius: BorderRadius.all(
                                Radius.circular(Size * 15))),
                        child: Padding(
                          padding: EdgeInsets.all(Size * 5.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Ask",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: Size * 25,
                                    fontWeight: FontWeight.w600),
                              ),
                              Container(
                                height: Size * 30,
                                width: Size * 30,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.white24),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Size * 15))),
                                child: Padding(
                                  padding: EdgeInsets.all(Size * 3.0),
                                  child: Text(
                                    "AI",
                                    style: TextStyle(
                                        fontSize: Size * 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        showToastText("Coming Soon");
                      },
                    ))
              ],
            ),
          ),

        ],
      ),
    );
  }
}

class newsUpadates extends StatefulWidget {
  String branch;
  double size;

  newsUpadates({required this.branch, required this.size});

  @override
  State<newsUpadates> createState() => _newsUpadatesState();
}

class _newsUpadatesState extends State<newsUpadates> {
  final FirebaseStorage storage = FirebaseStorage.instance;

  bool isBranch = false;
  String folderPath = '';
  String branch = '';

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
    });
  }

  @override
  void initState() {
    setState(() {
      getPath();
      branch = widget.branch;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Notification",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                InkWell(
                  child: Icon(
                    Icons.notifications_none,
                    color: Colors.white60,
                    size: widget.size * 30,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            notifications(
                          size: widget.size,
                          branch: widget.branch,
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          final fadeTransition = FadeTransition(
                            opacity: animation,
                            child: child,
                          );

                          return Container(
                            color: Colors.black.withOpacity(animation.value),
                            child: AnimatedOpacity(
                                duration: Duration(milliseconds: 300),
                                opacity: animation.value.clamp(0.3, 1.0),
                                child: fadeTransition),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Other Branches",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          StreamBuilder<List<branchSharingConvertor>>(
              stream: readbranchSharing(),
              builder: (context, snapshot) {
                final BranchNews = snapshot.data;
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
                              'Error with Time Table Data or\n Check Internet Connection'));
                    } else {
                      if (BranchNews!.length == 0) {
                        return Center(
                            child: Text(
                              "No Time Tables",
                              style:
                              TextStyle(color: Colors.amber.withOpacity(0.5)),
                            ));
                      } else
                        return SizedBox(
                          height: widget.size * 58,
                          child: ListView.builder(
                            itemCount: BranchNews.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, int index) {
                              var BranchNew = BranchNews[index];
                              file = File("");
                              if (BranchNew.photoUrl.isNotEmpty) {
                                final Uri uri = Uri.parse(BranchNew.photoUrl);
                                final String fileName = uri.pathSegments.last;
                                var name = fileName.split("/").last;
                                file = File("${folderPath}/timetable/$name");
                              }
                              return (widget.branch!=BranchNew.id)||(widget.branch!=branch)?Padding(
                                padding: EdgeInsets.only(
                                    left: index==0?widget.size * 14:widget.size * 5),
                                child: InkWell(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(3),
                                        margin:  EdgeInsets.only(
                                            bottom: widget.size * 2.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(
                                                widget.size * 27),
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.white,
                                                Colors.blueGrey,
                                                Colors.deepPurpleAccent,

                                              ],
                                            ),
                                            border: Border.all(
                                                width: 2,

                                                style: BorderStyle.solid)),
                                        child: Container(
                                          height: widget.size * 45,
                                          width: widget.size * 60,
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.6),
                                            image: DecorationImage(
                                                image: FileImage(file),
                                                fit: BoxFit.cover),
                                            borderRadius:
                                            BorderRadius.circular(
                                                widget.size * 23),
                                          ),
                                          child: Center(
                                            child: Text(
                                              BranchNew.id.toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: widget.size * 18,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "test"),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                  onTap: () {
setState(() {
  branch=BranchNew.id;
});
                                  },
                                ),
                              ):Container();
                            },
                          ),
                        );
                    }
                }
              }),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "College Updates",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                InkWell(
                  child: Text(
                    "more",
                    style: TextStyle(color: Colors.orangeAccent, fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => updatesPage(
                                  branch: branch,
                                  size: widget.size,
                                )));
                  },
                ),
              ],
            ),
          ),
          StreamBuilder<List<UpdateConvertor>>(
              stream: readUpdate(branch),
              builder: (context, snapshot) {
                final BranchNews = snapshot.data;
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
                      if (BranchNews!.length == 0) {
                        return Center(
                            child: Text(
                          "No Updates",
                          style: TextStyle(color: Colors.lightBlueAccent),
                        ));
                      } else
                        return ListView.builder(
                          padding: EdgeInsets.only(
                              left: 10, top: 10, bottom: 20, right: 8),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: min(2, BranchNews.length),
                          itemBuilder: (context, int index) {
                            file = File("");
                            final BranchNew = BranchNews[index];
                            if (BranchNew.photoUrl.isNotEmpty) {
                              final Uri uri = Uri.parse(BranchNew.photoUrl);
                              final String fileName = uri.pathSegments.last;
                              var name = fileName.split("/").last;
                              file = File("${folderPath}/updates/$name");
                            }
                            String timeDate = "";

                            List<String> parts = BranchNew.id.split('-');

                            String datePart = parts[0];
                            String timePart = parts[1];

                            List<String> dateParts = datePart.split('.');
                            List<String> timeParts = timePart.split(':');
                            if (dateParts.length == 3 &&
                                timeParts.length == 3) {
                              int day = int.parse(dateParts[0]);
                              int month = int.parse(dateParts[1]);
                              int year = int.parse(dateParts[2]);

                              int hour = int.parse(timeParts[0]);
                              int minute = int.parse(timeParts[1]);
                              int second = int.parse(timeParts[2]);
                              timeDate = formatTimeDifference(DateTime(
                                  year, month, day, hour, minute, second));
                            }

                            return InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  // color: Colors.yellowAccent.withOpacity(0.13),
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white10
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (BranchNew.link.isEmpty &&
                                        BranchNew.photoUrl.isNotEmpty)
                                      InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.file(file)),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImageZoom(
                                                        size: widget.size,
                                                        url: BranchNew.photoUrl,
                                                        file: file,
                                                      )));
                                        },
                                      ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 3),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (BranchNew
                                                    .heading.isNotEmpty)
                                                  Text(
                                                    BranchNew.heading,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            widget.size * 20,),
                                                  ),
                                                if (BranchNew
                                                    .description.isNotEmpty)
                                                  Text(
                                                    " ${BranchNew.description}",
                                                    style: TextStyle(
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                        fontSize:
                                                            widget.size * 14,),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (BranchNew.link.isNotEmpty &&
                                            BranchNew.photoUrl.isNotEmpty)
                                          InkWell(
                                            child: SizedBox(
                                              height: 100,
                                              width: 140,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: Image.file(
                                                      file,
                                                      fit: BoxFit.cover,
                                                    )),
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ImageZoom(
                                                            size: widget.size,
                                                            url: BranchNew
                                                                .photoUrl,
                                                            file: file,
                                                          )));
                                            },
                                          ),
                                      ],
                                    ),
                                    SizedBox(
                                        height: 2,
                                        child: Divider(
                                          color: Colors.white10,
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 2),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${timeDate}  ",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                              Icon(
                                                Icons.circle,
                                                color: Colors.white,
                                                size: 3,
                                              ),
                                              Text(
                                                "  ${BranchNew.creator.split("@").first}",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          if (isGmail() || isOwner())
                                            SizedBox(
                                              height: 18,
                                              child: PopupMenuButton(
                                                padding: EdgeInsets.all(0),
                                                icon: Icon(
                                                  Icons.more_horiz,
                                                  color: Colors.white,
                                                  size: widget.size * 18,
                                                ),
                                                // Callback that sets the selected popup menu item.
                                                onSelected: (item) async {
                                                  if (item == "edit") {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                updateCreator(
                                                                  NewsId:
                                                                      BranchNew
                                                                          .id,
                                                                  link:
                                                                      BranchNew
                                                                          .link,
                                                                  heading:
                                                                      BranchNew
                                                                          .heading,
                                                                  photoUrl:
                                                                      BranchNew
                                                                          .photoUrl,
                                                                  subMessage:
                                                                      BranchNew
                                                                          .description,
                                                                  branch: widget
                                                                      .branch,
                                                                  size: widget
                                                                      .size,
                                                                )));
                                                  } else if (item == "delete") {
                                                    FirebaseFirestore.instance
                                                        .collection("update")
                                                        .doc(BranchNew.id)
                                                        .delete();
                                                    messageToOwner(
                                                        "Update is Deleted\nBy '${fullUserId()}\n    Heading : ${BranchNew.heading}\n    Description : ${BranchNew.description}    \nImage : ${BranchNew.photoUrl}    \nLink : ${BranchNew.link}\n **${widget.branch}");
                                                  }
                                                },
                                                itemBuilder:
                                                    (BuildContext context) =>
                                                        <PopupMenuEntry>[
                                                  const PopupMenuItem(
                                                    value: "edit",
                                                    child: Text('Edit'),
                                                  ),
                                                  const PopupMenuItem(
                                                    value: "delete",
                                                    child: Text('Delete'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                ExternalLaunchUrl(BranchNew.link);
                              },
                            );
                          },
                        );
                    }
                }
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Our Updates",
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 20),
            ),
          ),
          StreamBuilder<List<BranchNewConvertor>>(
              stream: readBranchNew(branch),
              builder: (context, snapshot) {
                final BranchNews = snapshot.data;
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
                      return BranchNews!.isNotEmpty?ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: BranchNews.length,
                        itemBuilder: (context, int index) {
                          final BranchNew = BranchNews[index];
                          if (BranchNew.photoUrl.isNotEmpty) {
                            final Uri uri = Uri.parse(BranchNew.photoUrl);
                            final String fileName = uri.pathSegments.last;
                            var name = fileName.split("/").last;
                            file = File("${folderPath}/news/$name");
                          }
                          return InkWell(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (BranchNew.photoUrl.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: widget.size * 5.0),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            widget.size * 15),
                                        child: Image.file(file)),
                                  ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: widget.size * 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: widget.size * 25,
                                        width: widget.size * 25,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              widget.size * 15),
                                          image: DecorationImage(
                                              image: FileImage(file),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Text(
                                          BranchNew.heading.isNotEmpty
                                              ? " ${BranchNew.heading}"
                                              : " ${widget.branch} (SRKR)",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: widget.size * 16,
                                              fontWeight: FontWeight.w600)),
                                      Spacer(),
                                      if (isGmail() || isOwner())
                                        SizedBox(
                                          height: 35,
                                          child: PopupMenuButton(
                                            icon: Icon(
                                              Icons.more_vert,
                                              color: Colors.white,
                                              size: widget.size * 16,
                                            ),
                                            // Callback that sets the selected popup menu item.
                                            onSelected: (item) async {
                                              if (item == "edit") {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            NewsCreator(
                                                                branch: widget
                                                                    .branch,
                                                                NewsId:
                                                                    BranchNew
                                                                        .id,
                                                                heading:
                                                                    BranchNew
                                                                        .heading,
                                                                description:
                                                                    BranchNew
                                                                        .description,
                                                                photoUrl: BranchNew
                                                                    .photoUrl)));
                                              } else if (item == "delete") {
                                                if (BranchNew
                                                    .photoUrl.isNotEmpty) {
                                                  final Uri uri = Uri.parse(
                                                      BranchNew.photoUrl);
                                                  final String fileName =
                                                      uri.pathSegments.last;
                                                  final Reference ref = storage
                                                      .ref()
                                                      .child("/${fileName}");
                                                  try {
                                                    await ref.delete();
                                                    showToastText(
                                                        'Image deleted successfully');
                                                  } catch (e) {
                                                    showToastText(
                                                        'Error deleting image: $e');
                                                  }
                                                }
                                                messageToOwner(
                                                    "Branch News Updated.\nBy : '${fullUserId()}' \n    Heading : ${BranchNew.heading}\n    Description : ${BranchNew.description}\n    Image : ${BranchNew.photoUrl}\n **${widget.branch}");

                                                FirebaseFirestore.instance
                                                    .collection(widget.branch)
                                                    .doc("${widget.branch}News")
                                                    .collection(
                                                        "${widget.branch}News")
                                                    .doc(BranchNew.id)
                                                    .delete();
                                              }
                                            },
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry>[
                                              const PopupMenuItem(
                                                value: "edit",
                                                child: Text('Edit'),
                                              ),
                                              const PopupMenuItem(
                                                value: "delete",
                                                child: Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (BranchNew.description.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: widget.size * 10,
                                    ),
                                    child: StyledTextWidget(
                                      text: BranchNew.description,
                                      fontSize: widget.size * 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: widget.size * 8,
                                    bottom: widget.size * 8,
                                  ),
                                  child: Text(
                                    BranchNew.id.split("-").first.length < 12
                                        ? "~ ${BranchNew.id.split('-').first}"
                                        : "No Date",
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: widget.size * 10),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImageZoom(
                                            size: widget.size,
                                            url: "",
                                            file: file,
                                          )));
                            },
                          );
                        },
                      ):
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20,),
                              Icon(Icons.newspaper,color: Colors.white30,size: 70,),
                              Text("No ${branch} Updates",style: TextStyle(color: Colors.white54,fontSize: 16),)
                            ],
                          ),
                        ],
                      );
                    }
                }
              }),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}

Stream<List<eventsConvertor>> readevents(String branch) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("events")
        .collection("events")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => eventsConvertor.fromJson(doc.data()))
            .toList());

Future createevents(
    {required String id,
    required String heading,
    required String description,
    required String videoUrl,
    required String created,
    required String branch,
    required String photoUrl}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc("events")
      .collection("events")
      .doc(id);
  final flash = eventsConvertor(
    id: id,
    heading: heading,
    photoUrl: photoUrl,
    description: description,
    created: created,
    videoUrl: videoUrl,
  );
  final json = flash.toJson();
  await docflash.set(json);
}

class eventsConvertor {
  String id;
  final String heading, photoUrl, description, videoUrl, created;

  eventsConvertor({
    this.id = "",
    required this.heading,
    required this.photoUrl,
    required this.description,
    required this.videoUrl,
    required this.created,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "image": photoUrl,
        "videoUrl": videoUrl,
        "description": description,
        "created": created,
      };

  static eventsConvertor fromJson(Map<String, dynamic> json) => eventsConvertor(
        id: json['id'],
        heading: json["heading"],
        photoUrl: json["image"],
        videoUrl: json["videoUrl"],
        created: json["created"],
        description: json["description"],
      );
}

class eventsPage extends StatefulWidget {
  final String branch;
  final double size;

  const eventsPage({
    Key? key,
    required this.branch,
    required this.size,
  }) : super(key: key);

  @override
  State<eventsPage> createState() => _eventsPageState();
}

class _eventsPageState extends State<eventsPage> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  String folderPath = "";

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
    });
  }

  @override
  void initState() {
    getPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          StreamBuilder<List<eventsConvertor>>(
              stream: readevents(widget.branch),
              builder: (context, snapshot) {
                final BranchNews = snapshot.data;
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
                      return ListView.builder(
                       padding: EdgeInsets.symmetric(horizontal: 3) ,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: BranchNews!.length,
                        itemBuilder: (context, int index) {
                          final BranchNew = BranchNews[index];

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (BranchNew.videoUrl.isNotEmpty ||
                                  BranchNew.photoUrl.isNotEmpty)
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        if (BranchNew.videoUrl.isNotEmpty)
                                          InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            youtube(
                                                                url: BranchNew
                                                                    .videoUrl)));
                                              },
                                              child: AspectRatio(
                                                aspectRatio: 16 / 9,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white12,
                                                      image: DecorationImage(
                                                    image: NetworkImage(
                                                        YoutubeThumbnail(
                                                                youtubeId:
                                                                    extractVideoId(
                                                                        BranchNew
                                                                            .videoUrl))
                                                            .hq()),
                                                    fit: BoxFit.cover,
                                                  )),
                                                  child: Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: InkWell(
                                                        child: Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 3,
                                                                    horizontal:
                                                                        8),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 3,
                                                                    horizontal:
                                                                        8),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.black,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .white),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: Text(
                                                              "YouTube",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20),
                                                            )),
                                                        onTap: () {
                                                          ExternalLaunchUrl(
                                                              BranchNew
                                                                  .videoUrl);
                                                        },
                                                      )),
                                                ),
                                              )),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: BranchNew.photoUrl
                                              .split(";")
                                              .length,
                                          itemBuilder: (context, int index) {
                                            file = File("");

                                            if (BranchNew.photoUrl.isNotEmpty) {
                                              final Uri uri =
                                                  Uri.parse(BranchNew.photoUrl);
                                              final String fileName =
                                                  uri.pathSegments.last;
                                              var name =
                                                  fileName.split("/").last;
                                              file = File(
                                                  "${folderPath}/news/$name");
                                            }
                                            return InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ImageZoom(
                                                                size:
                                                                    widget.size,
                                                                url: "",
                                                                file: file,
                                                              )));
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8),
                                                  child: AspectRatio(
                                                    aspectRatio: 16 / 9,
                                                    child: Image.network(
                                                        BranchNew.photoUrl
                                                            .split(";")[index]),
                                                  ),
                                                ));
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: EdgeInsets.only( top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: widget.size * 30,
                                      width: widget.size * 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            widget.size * 25),
                                        color: Colors.white24,
                                      ),
                                      child: Center(
                                          child: Text(
                                        getInitials(BranchNew.heading),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: widget.size * 20,
                                            fontFamily: "test"),
                                      )),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              BranchNew.heading.isNotEmpty
                                                  ? " ${BranchNew.heading}"
                                                  : " ${widget.branch} (SRKR)",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: widget.size * 18,
                                                  fontWeight: FontWeight.w400)),
                                          if (BranchNew.created.isNotEmpty)
                                            Row(
                                              children: [
                                                Text(
                                                    " @${BranchNew.created.split("@").first}",
                                                    style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize:
                                                            widget.size * 10)),
                                                Spacer(),
                                                Text(
                                                  BranchNew.id
                                                              .split("-")
                                                              .first
                                                              .length <
                                                          12
                                                      ? "~ ${BranchNew.id.split('-').first}"
                                                      : "No Date",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          widget.size * 10,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (isGmail() || isOwner())
                                      SizedBox(
                                        height: 40,
                                        child: PopupMenuButton(
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: Colors.white,
                                            size: widget.size * 16,
                                          ),
                                          // Callback that sets the selected popup menu item.
                                          onSelected: (item) async {
                                            if (item == "edit") {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          NewsCreator(
                                                              branch:
                                                                  widget.branch,
                                                              NewsId:
                                                                  BranchNew.id,
                                                              heading: BranchNew
                                                                  .heading,
                                                              description:
                                                                  BranchNew
                                                                      .description,
                                                              photoUrl: BranchNew
                                                                  .photoUrl)));
                                            } else if (item == "delete") {
                                              if (BranchNew
                                                  .photoUrl.isNotEmpty) {
                                                final Uri uri = Uri.parse(
                                                    BranchNew.photoUrl);
                                                final String fileName =
                                                    uri.pathSegments.last;
                                                final Reference ref = storage
                                                    .ref()
                                                    .child("/${fileName}");
                                                try {
                                                  await ref.delete();
                                                  showToastText(
                                                      'Image deleted successfully');
                                                } catch (e) {
                                                  showToastText(
                                                      'Error deleting image: $e');
                                                }
                                              }
                                              messageToOwner(
                                                  "Branch News Updated.\nBy : '${fullUserId()}' \n    Heading : ${BranchNew.heading}\n    Description : ${BranchNew.description}\n    Image : ${BranchNew.photoUrl}\n **${widget.branch}");

                                              FirebaseFirestore.instance
                                                  .collection(widget.branch)
                                                  .doc("events")
                                                  .collection("events")
                                                  .doc(BranchNew.id)
                                                  .delete();
                                            }
                                          },
                                          itemBuilder: (BuildContext context) =>
                                              <PopupMenuEntry>[
                                            const PopupMenuItem(
                                              value: "edit",
                                              child: Text('Edit'),
                                            ),
                                            const PopupMenuItem(
                                              value: "delete",
                                              child: Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (BranchNew.description.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: widget.size * 2, right: 5),
                                  child: StyledTextWidget(
                                    text: BranchNew.description,
                                    fontSize: widget.size * 12,
                                  ),
                                ),
                              SizedBox(
                                height: widget.size * 20,
                              )
                            ],
                          );
                        },
                      );
                    }
                }
              }),
          SizedBox(
            height: widget.size * 100,
          )
        ],
      ),
    );
  }

  String getInitials(String fullName) {
    List<String> words = fullName.split(" ");
    String initials = "";

    for (var word in words) {
      if (word.isNotEmpty) {
        initials += word[0].toLowerCase();
      }
    }

    return initials.toUpperCase();
  }
}

class youtube extends StatefulWidget {
  final url;

  const youtube({Key? key, required this.url}) : super(key: key);

  @override
  State<youtube> createState() => _youtubeState();
}

class _youtubeState extends State<youtube> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    final videoID = YoutubePlayer.convertUrlToId(widget.url);
    _controller = YoutubePlayerController(
        initialVideoId: videoID!,
        flags: const YoutubePlayerFlags(autoPlay: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: () => debugPrint("Ready"),
          bottomActions: [
            CurrentPosition(),
            ProgressBar(
              isExpanded: true,
              colors: const ProgressBarColors(
                  playedColor: Colors.amber, handleColor: Colors.amberAccent),
            ),
            const PlaybackSpeedButton(),
            FullScreenButton()
          ],
        ),
      ),
    );
  }
}

String? extractVideoId(String url) {
  // Regular expression pattern to match YouTube video URLs
  RegExp regExp = RegExp(
      r"(?:youtu\.be/|youtube\.com/watch\?v=|youtube\.com/embed/|youtube\.com/v/|youtube\.com/user/[^#]*#p/|youtube\.com/s/|youtube\.com/playlist\?list=)([a-zA-Z0-9_-]+)");

  // Match the URL with the regular expression pattern
  Match match = regExp.firstMatch(url) as Match;

  // If a match is found, extract the video ID from the first capturing group
  if (match != null) {
    return match.group(1);
  } else {
    return null; // Return null if no match is found
  }
}
