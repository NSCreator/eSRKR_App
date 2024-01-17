// ignore_for_file: must_be_immutable, unnecessary_import
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srkr_study_app/SubPages.dart';
import 'package:srkr_study_app/add%20subjects.dart';
import 'package:srkr_study_app/search%20bar.dart';
import 'package:srkr_study_app/homePage/settings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../favorites.dart';
import '../functions.dart';
import '../net.dart';
import '../subjects.dart';
import '../test.dart';
import 'UpdatesAndNotification.dart';

class appBar_HomePage extends StatefulWidget {
  String reg, branch, name;

  appBar_HomePage(
      {required this.branch, required this.reg, required this.name});

  @override
  State<appBar_HomePage> createState() => _appBar_HomePageState();
}

class _appBar_HomePageState extends State<appBar_HomePage> {
  List searchList = ["Search About", "Subjects", "Lab Subjects"];
  List notificationsList = [
    "Notifications",
    "Messages",
    "Branch Updates",
    "College Updated"
  ];
  bool _isVisible = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(Duration(seconds: 3), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int currentHour = now.hour;

    String greeting = 'Hello';
    if (currentHour >= 18) {
      greeting = 'Good Evening';
    } else if (currentHour >= 12) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Morning';
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: _isVisible
                    ? TweenAnimationBuilder(
                        tween: Tween<double>(
                            begin: 0.0, end: _isVisible ? 1.0 : 0.0),
                        duration: Duration(seconds: 2),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value as double,
                            child: InkWell(
                              onTap: () {
                                ExternalLaunchUrl("https://srkrec.edu.in/");
                                // changeTab(2);
                              },
                              child: Text(
                                "eSRKR",
                                style: TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: "test"),
                              ),
                            ),
                          );
                        },
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$greeting',
                            style:
                                TextStyle(fontSize: 12.0, color: Colors.black),
                          ),
                          Text(
                            "${widget.name.replaceAll(";", " ").toUpperCase()}",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => favoritesSubjects(
                            branch: widget.branch,
                            reg: widget.reg,
                          ),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.favorite_border,
                      size: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => settings(
                              name: widget.name,
                              branch: widget.branch,
                              reg: widget.reg,
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.perm_identity,
                        size: 32,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        InkWell(
          onTap: () async {
            BranchStudyMaterialsConvertor? data =
                await getBranchStudyMaterials(widget.branch, false);
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (context, animation, secondaryAnimation) => MyAppq(
                  branch: widget.branch,
                  reg: widget.reg,
                  data: data!,
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
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                        child: Icon(
                          Icons.search,
                          color: Colors.black54,
                          size: 30,
                        ),
                      ),
                      Expanded(
                        child: CarouselSlider(
                          items: List.generate(
                            searchList.length,
                            (int index) {
                              return Row(
                                children: [
                                  Text(
                                    searchList[index],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          //Slider Container properties
                          options: CarouselOptions(
                            scrollDirection: Axis.vertical,
                            // Set the axis to vertical
                            viewportFraction: 0.95,
                            disableCenter: true,
                            enlargeCenterPage: true,
                            height: 40,
                            autoPlayAnimationDuration:
                                const Duration(seconds: 3),
                            autoPlay: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  newsUpadates(branch: widget.branch),
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
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      padding: EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(5, 19, 31, 1),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: CarouselSlider(
                        items: List.generate(
                          notificationsList.length,
                          (int index) {
                            return Center(
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      notificationsList[index],
                                      style: TextStyle(
                                          fontSize: 12.0, color: Colors.white),
                                    ),
                                  ]),
                            );
                          },
                        ),
                        //Slider Container properties
                        options: CarouselOptions(
                          scrollDirection: Axis.horizontal,
                          viewportFraction: 0.95,
                          disableCenter: true,
                          enlargeCenterPage: true,
                          height: 25,
                          autoPlayAnimationDuration: const Duration(seconds: 3),
                          autoPlay: true,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AdVideo {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7097300908994281/6151625166';
    } else {
      return 'ca-app-pub-7097300908994281/3170238605';
    }
  }
}

class HomePage extends StatefulWidget {
  final String branch, name;

  final String reg;

  HomePage({
    required this.branch,
    required this.name,
    required this.reg,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String folderPath = "";

  List<subjectConvertor> subjects = [];
  List<subjectConvertor> labSubjects = [];
  List<RegSylMPConvertor> regSM = [];
  List<RegTimeTableConvertor> RegTimeTable = [];

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
    });
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return allBooks(
          branch: widget.branch,
        );
      default:
        return Container();
    }
  }

  Future<void> getData(bool isReload) async {
    try {
      BranchStudyMaterialsConvertor? data =
          await getBranchStudyMaterials(widget.branch, isReload);
      if (data != null) {
        setState(() {
          subjects = data.subjects;
          labSubjects = data.labSubjects;
          regSM = data.regSylMP;
          RegTimeTable = data.regulationAndTimeTable;
        });
      } else {
        print("No data found for the specified branch.");
      }
    } catch (e) {
      print("Error getting subjects: $e");
    }
  }

  // late final RewardedAd rewardedAd;
  // bool isAdLoaded = false;
  //
  // void _loadRewardedAd() {
  //   RewardedAd.load(
  //     adUnitId: AdVideo.bannerAdUnitId,
  //     request: const AdRequest(),
  //     rewardedAdLoadCallback: RewardedAdLoadCallback(
  //       onAdFailedToLoad: (LoadAdError error) {
  //         print("Failed to load rewarded ad, Error: $error");
  //       },
  //       onAdLoaded: (RewardedAd ad) async {
  //         print("$ad loaded");
  //         showToastText("Ad loaded");
  //         rewardedAd = ad;
  //         _setFullScreenContentCallback();
  //         await _showRewardedAd();
  //         SharedPreferences prefs = await SharedPreferences.getInstance();
  //         prefs.setInt('lastOpenAdTime', DateTime.now().millisecondsSinceEpoch);
  //       },
  //     ),
  //   );
  // }
  // //method to set show content call back
  // void _setFullScreenContentCallback() {
  //   rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
  //     //when ad  shows fullscreen
  //     onAdShowedFullScreenContent: (RewardedAd ad) =>
  //         print("$ad onAdShowedFullScreenContent"),
  //     //when ad dismissed by user
  //     onAdDismissedFullScreenContent: (RewardedAd ad) {
  //       print("$ad onAdDismissedFullScreenContent");
  //
  //       //dispose the dismissed ad
  //       ad.dispose();
  //     },
  //     //when ad fails to show
  //     onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
  //       print("$ad  onAdFailedToShowFullScreenContent: $error ");
  //       //dispose the failed ad
  //       ad.dispose();
  //     },
  //
  //     //when impression is detected
  //     onAdImpression: (RewardedAd ad) => print("$ad Impression occured"),
  //   );
  // }
  //
  // Future<void> _showRewardedAd() async {
  //   rewardedAd.show(
  //       onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
  //         num amount = rewardItem.amount;
  //         showToastText("You earned: $amount");
  //
  //       });
  //   final imageRef = _firestore.collection("user").doc(fullUserId());
  //
  //   final documentSnapshot = await imageRef.get();
  //   if (documentSnapshot.exists) {
  //     final data = documentSnapshot.data() as Map<String, dynamic>;
  //     if (data['adSeenCount']==null) {
  //       _firestore.collection("user").doc(fullUserId()).update({"adSeenCount":0});
  //     } else {
  //       _firestore.collection("user").doc(fullUserId()).update({"adSeenCount":data['adSeenCount']+1});
  //
  //     }
  //   }
  // }
  //
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //
  // double remainingTime = 0;
  //
  //
  // Future<void> _checkImageOpenStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   int? lastOpenTime = prefs.getInt('lastOpenAdTime');
  //
  //   if (lastOpenTime == null) {
  //     _loadRewardedAd();
  //   } else {
  //     final currentTime = DateTime.now().millisecondsSinceEpoch;
  //     final difference = (currentTime - lastOpenTime) ~/ 1000;
  //
  //     if (difference >= 172800) {
  //       _loadRewardedAd();
  //     } else {
  //       remainingTime = ((172800 - difference) / 60)/60;
  //       showToastText("Ad with in ${remainingTime.toInt()} Hours");
  //     }
  //   }
  // }
  @override
  void initState() {
    // if ((!isGmail())&&(!isOwner()))_checkImageOpenStatus();
    getPath();
    getData(false);

    super.initState();
  }

  download(String pdfUrl) async {
    final Uri uri = Uri.parse(pdfUrl);
    final String fileName = uri.pathSegments.last;
    var name = fileName.split("/").last;
    if (pdfUrl.startsWith('https://drive.google.com')) {
      name = pdfUrl.split('/d/')[1].split('/')[0];

      pdfUrl = "https://drive.google.com/uc?export=download&id=$name";
    }
    final response = await http.get(Uri.parse(pdfUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory('${documentDirectory.path}/pdfs');
    if (!await newDirectory.exists()) {
      await newDirectory.create(recursive: true);
    }
    final file = File('${newDirectory.path}/${name}');
    await file.writeAsBytes(response.bodyBytes);
    setState(() {});
  }

  Future<void> refreshData() async {
    getData(true);
  }

  final InputController = TextEditingController();
  List<String> tabBarIndex = ["Books"];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final shouldPop = await showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          "Press Yes to Exit",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context, false);
                              },
                              child: Text(
                                'No',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context, true);
                              },
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          return shouldPop;
        },
        child: Scaffold(
          backgroundColor: Color.fromRGBO(232, 233, 235,1),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appBar_HomePage(
                    reg: widget.reg,
                    branch: widget.branch,
                    name: widget.name,
                  ),
                  StreamBuilder<List<HomePageImagesConvertor>>(
                    stream: readHomePageImagesConvertor(),
                    builder: (context, snapshot) {
                      final subjects = snapshot.data;
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 0.3,
                              color: Colors.cyan,
                            ),
                          );
                        default:
                          if (snapshot.hasError) {
                            return Text("Error with server");
                          } else {
                            return subjects != null && subjects.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: scrollingImages(
                                        images: subjects
                                            .map((subject) => subject.image)
                                            .toList(),
                                        id: "HomePageImages",
                                        isZoom: true,
                                        ar: AspectRatio(
                                          aspectRatio: 16 / 5,
                                        )),
                                  )
                                : Container();
                          }
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Study Materials",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 300),
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          Subjects(
                                        branch: widget.branch,
                                        reg: widget.reg,
                                        syllabusModelPaper: regSM,
                                        subjects: subjects,
                                      ),
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
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.05),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      )
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Subjects",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "test"),
                                      ),
                                      Text(
                                        "Total ${subjects.length} Subjects available",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black38,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "test"),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 300),
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          LabSubjects(
                                        labSubjects: labSubjects,
                                        branch: widget.branch,
                                        syllabusModelPaper: regSM,
                                        reg: widget.reg,
                                      ),
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
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.05),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      )
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Laboratory Subjects",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "test"),
                                      ),
                                      Text(
                                        "Total ${labSubjects.length} Laboratory Subjects available",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black38,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "test"),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "More Materials",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 45,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  tabBarIndex.asMap().entries.map((entry) {
                                final index = entry.key;
                                final label = entry.value;
                                return InkWell(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: index == 0 ? 12.0 : 5,
                                      right: index == tabBarIndex.length - 1
                                          ? 20
                                          : 0,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: Center(
                                              child: Text(
                                                label,
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: "test"),
                                              ),
                                            ),
                                          ),
                                        ],
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
                                            _buildPage(index),
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
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.08),
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 15),
                            child: Text(
                              "Q/Ans",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "test"),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "from ChatGPT",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  "${subjects.where((element) => element.QAFromChatGPT.isNotEmpty).length} Subjects Available",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  QuestionsAnswersFromChatGPT(
                            subjects: subjects,
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
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(35)),
                    child: InkWell(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "   Time Tables",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20,fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: RegTimeTable.length,
                                  itemBuilder: (context, int index) {
                                    final data = RegTimeTable[index];
                                    return data.regulation ==
                                        widget.reg.toUpperCase()
                                        ? Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                            constraints:
                                            BoxConstraints(maxHeight: 35),
                                            child: data.timeTable.isNotEmpty
                                                ? ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: data.timeTable.length,
                                              scrollDirection:
                                              Axis.horizontal,
                                              itemBuilder: (context, int index) {
                                                var BranchNew = data.timeTable[index];
                                                return Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    SizedBox(
                                                        height: 35,
                                                        width: 35,
                                                        child: ClipRRect(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                20),
                                                            child:
                                                            ImageShowAndDownload(
                                                              image:
                                                              BranchNew
                                                                  .link,
                                                              isZoom: true,
                                                            ))),

                                                  ],
                                                );
                                              },
                                            )
                                                : Row(
                                              children: [
                                                Icon(
                                                  Icons.table_view,
                                                  color: Colors.white,
                                                  size: 50,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                      "No Time Tables from ${data.regulation}",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 18),
                                                      maxLines: 2,
                                                    ))
                                              ],
                                            )),
                                          ],
                                        )
                                        : Container();
                                  }),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 300),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    TimeTables(
                              reg: widget.reg,
                              branch: widget.branch,
                              data: RegTimeTable,
                            ),
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
                                    duration: Duration(milliseconds: 300),
                                    opacity:
                                        animation.value.clamp(0.3, 1.0),
                                    child: fadeTransition),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.05),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    )
                                  ],
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "TTS",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "test"),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: 40,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    child: Image.asset("assets/img.png"),
                                  ),
                                ],
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
                                          duration: Duration(milliseconds: 300),
                                          opacity:
                                              animation.value.clamp(0.3, 1.0),
                                          child: fadeTransition),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.05),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    )
                                  ],
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        border:
                                            Border.all(color: Colors.black26),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    child: Center(
                                      child: Text(
                                        "AI",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "WebSites",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: "test"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              showToastText("Coming Soon");
                              // Navigator.push(
                              //   context,
                              //   PageRouteBuilder(
                              //     transitionDuration:
                              //         const Duration(milliseconds: 300),
                              //     pageBuilder: (context, animation,
                              //             secondaryAnimation) =>
                              //         AskAi(),
                              //     transitionsBuilder: (context, animation,
                              //         secondaryAnimation, child) {
                              //       final fadeTransition = FadeTransition(
                              //         opacity: animation,
                              //         child: child,
                              //       );
                              //
                              //       return Container(
                              //         color: Colors.black
                              //             .withOpacity(animation.value),
                              //         child: AnimatedOpacity(
                              //             duration:
                              //                 Duration(milliseconds: 300),
                              //             opacity: animation.value
                              //                 .clamp(0.3, 1.0),
                              //             child: fadeTransition),
                              //       );
                              //     },
                              //   ),
                              // );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15, top: 30, bottom: 10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SyllabusAndModelPapers(
                                          data: regSM,
                                          reg: widget.reg,
                                          branch: widget.branch,
                                        )));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Syllabus & Model Paper",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600),
                                maxLines: 1,
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.black,
                                size: 25,
                              )
                            ],
                          ),
                        ),
                      ),
                      if (widget.reg != "None")
                        ListView.builder(
                            itemCount: regSM.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final data = regSM[index];
                              if (data.reg.startsWith(widget.reg
                                      .substring(0, 10)
                                      .toUpperCase()) &&
                                  data.modelPaper.isNotEmpty &&
                                  data.syllabus.isNotEmpty) {
                                if (!File("${folderPath}/pdfs/${getFileName(data.syllabus)}")
                                        .existsSync() &&
                                    data.syllabus.isNotEmpty) {
                                  download(data.syllabus);
                                }
                                if (!File("${folderPath}/pdfs/${getFileName(data.modelPaper)}")
                                        .existsSync() &&
                                    data.modelPaper.isNotEmpty) {
                                  download(data.modelPaper);
                                }
                              }

                              return data.reg.startsWith(widget.reg
                                          .substring(0, 10)
                                          .toUpperCase()) &&
                                      data.modelPaper.isNotEmpty &&
                                      data.syllabus.isNotEmpty
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      padding: const EdgeInsets.all(3.0),
                                      margin: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PdfViewerPage(
                                                                pdfUrl:
                                                                    "${folderPath}/pdfs/${getFileName(data.syllabus)}")));
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(28),
                                                child: AspectRatio(
                                                  aspectRatio: 16 / 8,
                                                  child: Stack(
                                                    children: [
                                                      File("${folderPath}/pdfs/${getFileName(data.syllabus)}")
                                                              .existsSync()
                                                          ? PDFView(
                                                              filePath:
                                                                  "${folderPath}/pdfs/${getFileName(data.syllabus)}",
                                                            )
                                                          : Container(),
                                                      BackdropFilter(
                                                        filter:
                                                            ImageFilter.blur(
                                                                sigmaX: 2.0,
                                                                sigmaY: 3.0),
                                                        // Adjust the sigma values for more or less blur
                                                        child: Center(
                                                          child: Text(
                                                            "Syllabus Paper \n( ${widget.reg.substring(0, 10)} )",
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.black,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 20),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PdfViewerPage(
                                                                pdfUrl:
                                                                    "${folderPath}/pdfs/${getFileName(data.modelPaper)}")));
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(28),
                                                child: AspectRatio(
                                                  aspectRatio: 16 / 8,
                                                  child: Stack(
                                                    children: [
                                                      File("${folderPath}/pdfs/${getFileName(data.modelPaper)}")
                                                          .existsSync()
                                                          ? PDFView(
                                                        filePath:
                                                        "${folderPath}/pdfs/${getFileName(data.modelPaper)}",
                                                      )
                                                          : Container(),
                                                      BackdropFilter(
                                                        filter:
                                                        ImageFilter.blur(
                                                            sigmaX: 2.0,
                                                            sigmaY: 3.0),
                                                        // Adjust the sigma values for more or less blur
                                                        child: Center(
                                                          child: Text(
                                                            "Model Paper \n( ${widget.reg.substring(0, 10)} )",
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                color:
                                                                Colors.black,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 20),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container();
                            }),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

Stream<List<UpdateConvertor>> readUpdate(String branch) =>
    FirebaseFirestore.instance
        .collection("update")
        .orderBy("id", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UpdateConvertor.fromJson(doc.data()))
            .toList());

Future createHomeUpdate({
  required String id,
  required String heading,
  required String photoUrl,
  required String creator,
  required link,
  required String description,
}) async {
  final docflash = FirebaseFirestore.instance.collection("update").doc(id);

  final flash = UpdateConvertor(
      id: id,
      heading: heading,
      description: description,
      photoUrl: photoUrl,
      link: link,
      creator: creator);
  final json = flash.toJson();
  await docflash.set(json);
}

class UpdateConvertor {
  String id;
  final String heading, photoUrl, link, description, creator;
  List<String> likedBy, isViewed;

  UpdateConvertor({
    this.id = "",
    required this.heading,
    required this.photoUrl,
    required this.link,
    required this.creator,
    required this.description,
    List<String>? likedBy,
    List<String>? isViewed,
  })  : likedBy = likedBy ?? [],
        isViewed = isViewed ?? [];

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "image": photoUrl,
        "link": link,
        "description": description,
        "creator": creator,
      };

  static UpdateConvertor fromJson(Map<String, dynamic> json) => UpdateConvertor(
        id: json['id'],
        heading: json["heading"] ?? "",
        creator: json["creator"] ?? "",
        photoUrl: json["image"] ?? "",
        link: json["link"] ?? "",
        description: json["description"] ?? "",
        likedBy:
            json["likedBy"] != null ? List<String>.from(json["likedBy"]) : [],
        isViewed:
            json["isViewed"] != null ? List<String>.from(json["isViewed"]) : [],
      );
}

class RegulationWithYearConvertor {
  String id;
  String modelPaper;
  String syllabus;

  RegulationWithYearConvertor(
      {this.id = "", required this.modelPaper, required this.syllabus});

  Map<String, dynamic> toJson() => {
        "id": id,
        "modelPaper": modelPaper,
        "syllabus": syllabus,
      };

  static RegulationWithYearConvertor fromJson(Map<String, dynamic> json) =>
      RegulationWithYearConvertor(
        id: json['id'],
        modelPaper: json['modelPaper'],
        syllabus: json['syllabus'],
      );
}

class RegulationConvertor {
  String id;

  RegulationConvertor({this.id = ""});

  Map<String, dynamic> toJson() => {"id": id};

  static RegulationConvertor fromJson(Map<String, dynamic> json) =>
      RegulationConvertor(id: json['id']);
}

Stream<List<branchSharingConvertor>> readbranchSharing() =>
    FirebaseFirestore.instance
        .collection("branchSharing")
        .orderBy("id", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => branchSharingConvertor.fromJson(doc.data()))
            .toList());

Future createbranchSharing(
    {required String branch,
    required String heading,
    required String photoUrl,
    required String reg}) async {
  String id = getID();
  final docflash =
      FirebaseFirestore.instance.collection("branchSharing").doc(id);
  final flash = branchSharingConvertor(id: id, photoUrl: photoUrl);
  final json = flash.toJson();
  await docflash.set(json);
}

class branchSharingConvertor {
  String id;
  final String photoUrl;

  branchSharingConvertor({this.id = "", required this.photoUrl});

  Map<String, dynamic> toJson() => {"id": id, "image": photoUrl};

  static branchSharingConvertor fromJson(Map<String, dynamic> json) =>
      branchSharingConvertor(id: json['id'], photoUrl: json['image']);
}

Stream<List<UpdateConvertor>> readBranchNew(String branch) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("${branch}News")
        .collection("${branch}News")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UpdateConvertor.fromJson(doc.data()))
            .toList());

Future createBranchNew(
    {required String id,
    required String heading,
    required String description,
    required String branch,
    required String photoUrl,
    required String link,
    required String creator}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc("${branch}News")
      .collection("${branch}News")
      .doc(id);
  final flash = UpdateConvertor(
    id: id,
    heading: heading,
    photoUrl: photoUrl,
    description: description,
    link: link,
    creator: creator,
  );
  final json = flash.toJson();
  await docflash.set(json);
}

Stream<List<FlashNewsConvertor>> readSRKRFlashNews() =>
    FirebaseFirestore.instance
        .collection("srkrPage")
        .doc("flashNews")
        .collection("flashNews")
        .orderBy("heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FlashNewsConvertor.fromJson(doc.data()))
            .toList());

Future createQuestionsFromChatGPT(
    {required String heading,
    required String branch,
    required String description,
    required String creator,
    required String regulation}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc("Subjects")
      .collection("Subjects")
      .doc(getID());
  final flash = questionsFromChatGPTConvertor(
      question: heading,
      easy: description,
      medium: regulation,
      normal: creator,
      note: '');
  final json = flash.toJson();
  await docflash.set(json);
}

class FlashNewsConvertor {
  String id;
  final String heading, Url;

  FlashNewsConvertor({
    this.id = "",
    required this.heading,
    required this.Url,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "link": Url,
      };

  static FlashNewsConvertor fromJson(Map<String, dynamic> json) =>
      FlashNewsConvertor(
        id: json['id'],
        heading: json["heading"],
        Url: json["link"],
      );
}

class QuestionsAnswersFromChatGPT extends StatefulWidget {
  List<subjectConvertor> subjects;

  QuestionsAnswersFromChatGPT({required this.subjects});

  @override
  State<QuestionsAnswersFromChatGPT> createState() =>
      _QuestionsAnswersFromChatGPTState();
}

class _QuestionsAnswersFromChatGPTState
    extends State<QuestionsAnswersFromChatGPT> {
  @override
  Widget build(BuildContext context) {
    List<subjectConvertor> filteredItems = widget.subjects;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.arrow_back),
                    Text(
                      "Back",
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    Text(
                      "Questions/Answers ",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      " from ChatGPT",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Questions available only for these subjects.",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: filteredItems.length,
                itemBuilder: (context, int index) {
                  final SubjectsData = filteredItems[index];
                  return SubjectsData.QAFromChatGPT.isNotEmpty
                      ? QuestionsExpandContainer(
                          data: SubjectsData,
                        )
                      : Container();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionsExpandContainer extends StatefulWidget {
  subjectConvertor data;

  QuestionsExpandContainer({required this.data});

  @override
  State<QuestionsExpandContainer> createState() =>
      _QuestionsExpandContainerState();
}

class _QuestionsExpandContainerState extends State<QuestionsExpandContainer> {
  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isExpand = !isExpand;
              });
            },
            child: Row(
              children: [
                Expanded(
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text(
                        widget.data.heading.short,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      ))),
                ),
                Expanded(
                    flex: 3,
                    child: Text(
                      widget.data.heading.full,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ))
              ],
            ),
          ),
          if (isExpand)
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.data.QAFromChatGPT.length,
                      itemBuilder: (context, int index) {
                        final data = widget.data.QAFromChatGPT[index];
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration:
                                      Duration(milliseconds: 300),
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      Answers(
                                    data: data,
                                  ),
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
                                          duration: Duration(milliseconds: 300),
                                          opacity:
                                              animation.value.clamp(0.3, 1.0),
                                          child: fadeTransition),
                                    );
                                  },
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                "${data.question}",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ));
                      })
                ],
              ),
            )
        ],
      ),
    );
  }
}

class Answers extends StatefulWidget {
  questionsFromChatGPTConvertor data;

  Answers({required this.data});

  @override
  State<Answers> createState() => _AnswersState();
}

class _AnswersState extends State<Answers> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(
      vsync: this,
      length: 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(Icons.arrow_back),
                      Text(
                        "Back",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "${widget.data.question}",
                    style: TextStyle(color: Colors.orange, fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Answer",
                    style:
                        TextStyle(color: Colors.lightBlueAccent, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TabBarView(
                        physics: BouncingScrollPhysics(),
                        controller: _tabController,
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                  "${widget.data.normal}",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                  "${widget.data.medium}",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                  "${widget.data.easy}",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blueGrey.shade100),
                        child: TabBar(
                          tabAlignment: TabAlignment.start,
                          labelPadding:
                              EdgeInsets.symmetric(horizontal: 3, vertical: 0),
                          dividerColor: Colors.transparent,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blueGrey.shade900,
                          ),
                          controller: _tabController,
                          isScrollable: true,
                          tabs: [
                            Tab(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                // Use EdgeInsets.zero to remove padding
                                child: Text(
                                  "Normal",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                // Use EdgeInsets.zero to remove padding
                                child: Text(
                                  "Medium",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                // Use EdgeInsets.zero to remove padding
                                child: Text(
                                  "Easy",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

Stream<List<questionsFromChatGPTConvertor>> readFlashNews(String branch) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("Subjects")
        .collection("Subjects")
        .orderBy("heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => questionsFromChatGPTConvertor.fromJson(doc.data()))
            .toList());

class questionsFromChatGPTConvertor {
  final String question, easy, medium, normal, note;

  questionsFromChatGPTConvertor(
      {required this.medium,
      required this.question,
      required this.easy,
      required this.note,
      required this.normal});

  Map<String, dynamic> toJson() => {
        "question": question,
        "easy": easy,
        "medium": medium,
        "note": note,
        "normal": normal
      };

  static questionsFromChatGPTConvertor fromJson(Map<String, dynamic> json) =>
      questionsFromChatGPTConvertor(
          medium: json["medium"] ?? "",
          question: json["question"] ?? "",
          easy: json["easy"] ?? "",
          note: json["note"] ?? "",
          normal: json["normal"] ?? "");

  static List<questionsFromChatGPTConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

Stream<List<questionsFromChatGPTConvertor>> readLabSubjects(
        String branch, bool isSub) =>
    FirebaseFirestore.instance
        .collection("StudyMaterials")
        .doc(branch)
        .collection(isSub ? "Subjects" : "LabSubjects")
        // .orderBy("heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => questionsFromChatGPTConvertor.fromJson(doc.data()))
            .toList());

Stream<List<BooksConvertor>> ReadBook(String branch) =>
    FirebaseFirestore.instance
        .collection("StudyMaterials")
        .doc(branch)
        .collection("Books")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BooksConvertor.fromJson(doc.data()))
            .toList());

Future createBook(
    {required bool isUpdate,
    required String id,
    required String heading,
    required String description,
    required String link,
    required String branch,
    required String edition,
    required String Author}) async {
  final docBook = FirebaseFirestore.instance
      .collection("StudyMaterials")
      .doc(branch)
      .collection("Books")
      .doc(id);

  final Book = BooksConvertor(
    id: id,
    heading: heading,
    link: link,
    description: description,
    Author: Author,
    edition: edition,
  );
  final json = Book.toJson();
  if (isUpdate) {
    await docBook.update(json);
  } else {
    await docBook.set(json);
  }
}

class BooksConvertor {
  String id;
  final String heading, link, description, edition, Author;

  BooksConvertor(
      {this.id = "",
      required this.heading,
      required this.link,
      required this.description,
      required this.edition,
      required this.Author});

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "link": link,
        "description": description,
        "author": Author,
        "edition": edition,
      };

  static BooksConvertor fromJson(Map<String, dynamic> json) => BooksConvertor(
        id: json['id'] ?? "",
        heading: json["heading"] ?? "",
        link: json["link"] ?? "",
        description: json["description"] ?? "",
        Author: json["author"] ?? "",
        edition: json["edition"] ?? "",
      );
}

class tabBarForUnit extends StatefulWidget {
  int units, textBooks, moreInfo, question, oldPapers;
  bool isSub;
  final TabController tabController;

  tabBarForUnit(
      {this.isSub = true,
      required this.tabController,
      required this.oldPapers,
      required this.units,
      required this.textBooks,
      required this.moreInfo,
      required this.question});

  @override
  _tabBarForUnitState createState() => _tabBarForUnitState();
}

class _tabBarForUnitState extends State<tabBarForUnit> {
  List<String> tabBarIndex = [
    "Unit",
    "Model Papers & Previous Paper",
    "Description & Questions",
    "Other Links"
  ];
  int currentIndex = 0;
  Color inActive = Colors.blueGrey.withOpacity(0.3);
  Color active = Colors.white;

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    setState(() {
      currentIndex = widget.tabController.index;
    });
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.black12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: InkWell(
                onTap: () {
                  UnitKey.currentState?.changeTab(0);
                },
                child: Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: currentIndex == 0 ? active : inActive,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 3, bottom: 3, left: 6, right: 12),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                            child: Text(
                          "${widget.units}",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontFamily: "test"),
                        )),
                      ),
                      Expanded(
                          child: Text(
                        widget.isSub ? tabBarIndex[0] : "Records & Manuals",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "test"),
                      )),
                    ],
                  ),
                ),
              )),
              if (widget.isSub)
                Expanded(
                    child: InkWell(
                  onTap: () {
                    UnitKey.currentState?.changeTab(1);
                  },
                  child: Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: currentIndex == 1 ? active : inActive,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: 3, bottom: 3, left: 6, right: 12),
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                              child: Text(
                            "${widget.oldPapers}",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                          )),
                        ),
                        Expanded(
                            child: Text(
                          tabBarIndex[1],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                        )),
                      ],
                    ),
                  ),
                )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: InkWell(
                onTap: () {
                  UnitKey.currentState?.changeTab((widget.isSub ? 2 : 1));
                },
                child: Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: currentIndex == (widget.isSub ? 2 : 1)
                          ? active
                          : inActive,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 3, bottom: 3, left: 6, right: 12),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                            child: Text(
                          "${widget.question}",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        )),
                      ),
                      Expanded(
                          child: Text(
                        widget.isSub ? tabBarIndex[2] : "Description",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: widget.isSub ? 13 : 20,
                            fontWeight: FontWeight.w500),
                        maxLines: 2,
                      )),
                    ],
                  ),
                ),
              )),
              Expanded(
                  child: InkWell(
                onTap: () {
                  UnitKey.currentState?.changeTab((widget.isSub ? 3 : 2));
                },
                child: Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: currentIndex == (widget.isSub ? 3 : 2)
                          ? active
                          : inActive,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 3, bottom: 3, left: 6, right: 12),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                            child: Text(
                          "${widget.moreInfo}",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        )),
                      ),
                      Expanded(
                          child: Text(
                        tabBarIndex[3],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            fontFamily: "test"),
                        maxLines: 1,
                      )),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }
}
