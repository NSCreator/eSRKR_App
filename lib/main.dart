import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';

import 'HomePage.dart';
import 'auth_page.dart';
import 'favorites.dart';
import 'notification.dart';
import 'notifications.dart';
import 'search bar.dart';
import 'settings.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
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
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    favorites(),
    MyAppq(),
    notifications(),
    settings()
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
              "https://i.pinimg.com/736x/01/c7/f7/01c7f72511cc6ce7858e65b45d4f8c9c.jpg",
            ),
            fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.8),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: SizedBox(
          height: 50,
          child: BottomNavigationBar(
            backgroundColor: Colors.black,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                    color: _selectedIndex == 0
                        ? Colors.lightBlueAccent
                        : Colors.grey,
                  ),
                  label: 'Home',
                  backgroundColor: Colors.transparent),
              BottomNavigationBarItem(
                  icon: Icon(
                    _selectedIndex == 1
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: _selectedIndex == 1
                        ? Colors.lightBlueAccent
                        : Colors.grey,
                  ),
                  label: 'favorites',
                  backgroundColor: Colors.transparent),
              BottomNavigationBarItem(
                  icon: Icon(
                    _selectedIndex == 2 ? Icons.manage_search : Icons.search,
                    color: _selectedIndex == 2
                        ? Colors.lightBlueAccent
                        : Colors.grey,
                  ),
                  label: 'Search',
                  backgroundColor: Colors.transparent),
              BottomNavigationBarItem(
                  icon: Icon(
                    _selectedIndex == 3
                        ? Icons.message
                        : Icons.messenger_outline,
                    color: _selectedIndex == 3
                        ? Colors.lightBlueAccent
                        : Colors.grey,
                  ),
                  label: 'Messages',
                  backgroundColor: Colors.transparent),
              BottomNavigationBarItem(
                  icon: Icon(
                    _selectedIndex == 4 ? Icons.person : Icons.person_outline,
                    color: _selectedIndex == 4
                        ? Colors.lightBlueAccent
                        : Colors.grey,
                  ),
                  label: 'Profile',
                  backgroundColor: Colors.transparent),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTap,
            selectedFontSize: 13.0,
            unselectedFontSize: 10.0,
          ),
        ),
      ),
    );
  }
}
