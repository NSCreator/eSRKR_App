import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prokoni/searchBar.dart';
import 'package:rive/rive.dart';

import 'arduino.dart';
import 'authPage.dart';
import 'homepage.dart';
import 'saveCartList.dart';
import 'settings.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  Scaffold(
          body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Nav();
                } else {
                  return LoginPage();
                }
              }),
      ),
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
    saveCartList(),
    searchBar(),
    HomePage(),
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
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // bottomNavigationBar: SafeArea(
      //   child: Container(
      //     padding: EdgeInsets.all(12),
      //     margin: EdgeInsets.symmetric(horizontal: 24),
      //     decoration: BoxDecoration(
      //       color: Colors.black,
      //       borderRadius: BorderRadius.all(Radius.circular(24))
      //     ),
      //     child: Row(
      //       children: [
      //         SizedBox(
      //             height: 36,
      //             width: 36,
      //             child: RiveAnimation.asset("assets/RiveAssets/icons.riv",
      //             artboard: "Home",onInit: (),))
      //       ],
      //     ),
      //   ),
      // ),
      bottomNavigationBar: SizedBox(
        height: 51,
        child: BottomNavigationBar(
          items:  [
            BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex==1?Icons.home_outlined:Icons.home,

                ),
                label:
                'Home',
                backgroundColor: Colors.black

            ),
            BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 2 ?Icons.favorite_border:Icons.favorite,

                ),
                label:
                'favorites',
                backgroundColor: Colors.black

            ),
            BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 3 ?Icons.search:Icons.search_outlined,

                ),
                label:
                'Search',
                backgroundColor: Colors.black
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.message,

                ),
                label:
                'Messages',
                backgroundColor: Colors.black54
            ),

            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label:
                'Profile',
                backgroundColor: Colors.black
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
