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
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  NotificationService().initNotification();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
        print(message.notification);
      }
    });

    ///forground work
    FirebaseMessaging.onMessage.listen((message) async {
      if (message.notification != null) {}
      NotificationService().showNotification(
          title: message.notification!.title, body: message.notification!.body);
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];

      Navigator.of(context).pushNamed(routeFromMessage);
    });
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
              return Nav();
            } else {
              return LoginPage();
            }
          }),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Nav extends StatefulWidget {
  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    favorites(),
    MyAppq(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
                  child: _widgetOptions.elementAt(_selectedIndex)),
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
