import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srkr_study_app/poll/create_poll.dart';
import 'package:srkr_study_app/poll/polling_page.dart';
import 'package:srkr_study_app/sendMeFiles.dart';
import 'package:srkr_study_app/settings/settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'firebase_options.dart';
import 'get_all_data.dart';
import 'homePage/HomePage.dart';
import 'auth_page.dart';
import 'functions.dart';
import 'notification.dart';

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

  @override
  void dispose() {
    super.dispose();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null && user.emailVerified) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    return MediaQuery(
      data: data.copyWith(
          textScaleFactor:
              data.textScaleFactor > 1.1 ? 1.1 : data.textScaleFactor),
      child: MaterialApp(
        title: 'eSRKR',
        theme: ThemeData(
            textTheme: GoogleFonts.muktaTextTheme(),
            useMaterial3: true,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,

            scaffoldBackgroundColor: Color.fromARGB(255, 27, 32, 35)
        ),

        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return bottomPageNavigator();
            } else {
              return Scaffold(
                body: LoginPage(),
              );
            }
          },
        ),
        //   routes: {
        //     '/': (context) =>StreamBuilder<User?>(
        //         stream: FirebaseAuth.instance.authStateChanges(),
        //         builder: (context, snapshot) {
        //           if (snapshot.hasData) {
        //             get(context);
        //             return Scaffold(
        //               body: Center(
        //                 child: Column(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   crossAxisAlignment: CrossAxisAlignment.center,
        //                   children: [
        //                     Container(
        //                       decoration: BoxDecoration(
        //                           image: DecorationImage(
        //                               image: AssetImage("assets/app_logo.png")),
        //                           borderRadius: BorderRadius.circular(20)),
        //                       height: 150,
        //                       width: 150,
        //                       margin: EdgeInsets.symmetric(vertical: 100),
        //                     ),
        //                     Container(width: 200.0, child: LinearProgressIndicator()),
        //                   ],
        //                 ),
        //               ),
        //             );
        //           } else {
        //             return Scaffold(body: LoginPage());
        //           }
        //         }),
        //     '/pdfPage': (context) {
        // String pdfUrl = ModalRoute.of(context)!.settings.arguments as String;
        //       return PdfViewerPage(pdfUrl: pdfUrl,);
        // }
        //     },

        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

Future<void> backgroundHandler(RemoteMessage message) async {
  await _handleMessageData(message);
}

Future<void> _handleMessageData(RemoteMessage message) async {
  NotificationService().showNotification(
      title: message.notification!.title, body: message.notification!.body);
}

class bottomPageNavigator extends StatefulWidget {
  // const bottomPageNavigator({super.key});

  @override
  State<bottomPageNavigator> createState() => _bottomPageNavigatorState();
}

class _bottomPageNavigatorState extends State<bottomPageNavigator> {
  BranchStudyMaterialsConverter? data;

  Future<void> getData(bool isBool) async {
     data = await getBranchStudyMaterials(isBool);
     setState(() {
       data;
     });
  }
  @override
  void initState() {
    super.initState();
    isUpdated();
  }
  void showUpdateDialog(BuildContext context) {
    showDialog(

      context: context,
      builder: (BuildContext context) {
        // return dialog
        return AlertDialog(
          backgroundColor: Colors.blueGrey.shade900,
          title: Text('Update Available',style: TextStyle(color: Colors.white,)),
          content: Text(
            'A new update for this app is available on the Play Store. Please update to enjoy the latest features and improvements.',
          style: TextStyle(color: Colors.white70,)),
          actions: [
            TextButton(
              onPressed: () {
                launch('https://play.google.com/store/apps/details?id=com.nimmalasujith.esrkr');
              },
              child: Text('Open Play Store',style: TextStyle(color: Colors.greenAccent,fontSize: 20)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',style: TextStyle(color: Colors.white70,fontSize: 15)),
            ),
          ],
        );
      },
    );
  }
  Future<bool> isUpdated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localUpdatedAt = prefs.getString('Updated');
      Future<DataSnapshot> fetchData() async {
        final databaseReference = await FirebaseDatabase.instance.ref("Updated").once();
        return databaseReference.snapshot;
      }
      final data = await fetchData();

      List<String> value = data.value.toString().split(",");
      if(value.first!=version){
        showUpdateDialog(context);
      }
      if (localUpdatedAt != value.last) {
        showToastText("Data Updating");
        await getData(true);
        await prefs.setString('Updated', value.last);
        return true; // Data has been updated
      } else {
        getData(false);
        return false;
      }
    } on PlatformException catch (error) {
      print('PlatformException: $error');
      showToastText('Error checking for updates: $error');
      return false; // Indicate error
    } catch (error) {
      await getData(true);
      print('Error: $error');
      showToastText('An error occurred: $error');
      return false; // Indicate error
    }
  }

  bool _isBackPressedOnce = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isBackPressedOnce) {
          return Future.value(true);
        } else {

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Press back again to exit'),
                duration: Duration(seconds: 2),
              ),
            );
            _isBackPressedOnce = true;
            Timer(Duration(seconds: 2), () {
              _isBackPressedOnce = false;
            });
            return Future.value(false);

        }
      },
      child: data!=null?HomePage(
        data: data,
      ):Center(child: CircularProgressIndicator(color: Colors.white54,),),
    );

  }
}

