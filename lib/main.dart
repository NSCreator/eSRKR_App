import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';
import 'package:srkr_study_app/auth_page.dart';
import 'package:srkr_study_app/HomePage.dart';
import 'package:srkr_study_app/search%20bar.dart';
import 'package:srkr_study_app/settings.dart';
import '../intro_pages.dart';
import '../HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'auth_page.dart';
import 'favorites.dart';
import 'notification.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  final showHome = prefs.getBool('showHome') ?? false;
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MyApp(showHome: showHome));
  });
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final bool showHome;


   MyApp({
    Key? key,
    required this.showHome,
  }) : super(key: key);

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
      home: mainPage(showHome: showHome),
      debugShowCheckedModeBanner: false,
    );
  }
}

class mainPage extends StatelessWidget {
  final bool showHome;

//  final bool isAuth;

   mainPage({
    Key? key,
    required this.showHome,

//    required this.isAuth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return showHome ?  Nav() : initial_branch();
          } else {
            return LoginPage();
          }
        });
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          items:  [
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex==1?Icons.home_outlined:Icons.home,

              ),
              label:
                'Home',
                backgroundColor: Colors.transparent

            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 2 ?Icons.favorite_border:Icons.favorite,

              ),
              label:
              'favorites',
                backgroundColor: Colors.transparent

            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 3 ?Icons.search:Icons.search_outlined,

              ),
              label:
              'Search',
                backgroundColor: Colors.transparent
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.message,

              ),
              label:
                'Messages',
                backgroundColor: Colors.transparent
            ),

            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label:
                'Profile',
                backgroundColor: Colors.transparent
            ),

          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTap,
          selectedFontSize: 13.0,
          unselectedFontSize: 10.0,
        ),
      ),
    );
  }
}
