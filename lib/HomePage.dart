// ignore_for_file: must_be_immutable, unnecessary_import
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srkr_study_app/SubPages.dart';
import 'package:srkr_study_app/notification.dart';
import 'package:srkr_study_app/search%20bar.dart';
import 'package:srkr_study_app/settings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'TextField.dart';
import 'favorites.dart';
import 'functins.dart';
import 'main.dart';
import 'net.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomePage extends StatefulWidget {
  final String branch,name;
  final String reg;
  final double size;

  const HomePage({
    Key? key,
    required this.branch,
    required this.name,
    required this.reg,
    required this.size,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  List searchList = ["Search About", "Subjects", "Lab Subjects"];
  String modelPaper = "";
  String syllabus = "";
  late TabController _tabController;
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
    _tabController = new TabController(
      vsync: this,
      length: 4,
    );
    // changeTab(3);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void changeTab(int newIndex) {
    _tabController.animateTo(newIndex);
  }

  // reg() async {
  //   List list = [];
  //
  //   final CollectionReference updates =
  //       FirebaseFirestore.instance.collection(widget.branch).doc("Subjects").collection("Subjects");
  //
  //   try {
  //     final QuerySnapshot querySnapshot = await updates.get();
  //     if (querySnapshot.docs.isNotEmpty) {
  //       final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
  //     } else {
  //       print('No documents found');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  // Function to save settings
  // Future<void> saveSettings() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   prefs.setString('selectedLanguage', selectedLanguage);
  //   prefs.setString('textToSpeak', textEditingController.text);
  // }

  // // Function to load saved settings
  // Future<void> loadSavedSettings() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     modelPaper = prefs.getString('modelPaper') ?? '';
  //     syllabus = prefs.getString('syllabus') ?? '';
  //   });
  // }
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  final InputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    DateTime now = DateTime.now();
    int currentHour = now.hour;

    String greeting = 'Hello'; // Default greeting

    // Check the time and set the greeting accordingly
    if (currentHour >= 18) {
      greeting = 'Good Evening';
    } else if (currentHour >= 12) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Morning';
    }
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.size * 20)),
              elevation: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white38,
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(widget.size * 20),
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(height: widget.size * 15),
                    Padding(
                      padding: EdgeInsets.only(left: widget.size * 15),
                      child: Text(
                        "Press Yes to Exit",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: widget.size * 18),
                      ),
                    ),
                    SizedBox(
                      height: widget.size * 5,
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
                                  color: Colors.black, fontSize: widget.size * 20, fontWeight: FontWeight.w600),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context, true);
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                  color: Colors.black, fontSize: widget.size * 20, fontWeight: FontWeight.w600),
                            ),
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
        return shouldPop;
      },
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: widget.size * 125,
                collapsedHeight: widget.size * 125,
                toolbarHeight: widget.size * 125,
                backgroundColor: Colors.transparent,
                flexibleSpace: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal:  widget.size* 10.0,vertical: widget.size*  5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(

                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: const Duration(milliseconds: 300),
                                    pageBuilder: (context, animation, secondaryAnimation) =>
                                        MyAppq(branch: widget.branch, reg: widget.reg, size: widget.size),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(Size*20),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: widget.size * 15,vertical:  widget.size *2),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.search,
                                        color: Colors.white70,
                                        size: widget.size * 25,
                                      ),
                                      SizedBox(width: widget.size * 3),
                                      Flexible(
                                        child: CarouselSlider(
                                          items: List.generate(
                                            searchList.length,
                                                (int index) {
                                              return Center(
                                                child: Text(
                                                  searchList[index],
                                                  style: TextStyle(
                                                    fontSize: widget.size * 20.0,
                                                    color: Colors.white70,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
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
                                            height: widget.size * 40,
                                            autoPlayAnimationDuration: const Duration(seconds: 3),
                                            autoPlay: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(width: 10,),
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
                                pageBuilder: (context, animation, secondaryAnimation) => notifications(

                                  size: widget.size,
                                  branch: widget.branch,
                                ),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                        SizedBox(
                          width: widget.size * 10,
                        ),
                        InkWell(
                            child: Icon(
                              Icons.settings,
                              color: Colors.white70,
                              size: widget.size * 30,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 300),
                                  pageBuilder: (context, animation, secondaryAnimation) => settings(
                                    size: widget.size,
                                    reg: widget.reg,
                                    branch: widget.branch, name: widget.name,
                                  ),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                            }),
                        SizedBox(
                          width: widget.size * 10,
                        ),
                      ],),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: widget.size * 8.0,vertical: widget.size * 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$greeting',
                            style: TextStyle(
                              fontSize:  widget.size* 16.0,
                              color: Colors.white
                            ),
                          ),
                          Text(
                            "${widget.name.replaceAll(";", " ").toUpperCase()}",
                            style: TextStyle(
                              fontSize:  widget.size* 22.0,
                                color: Colors.white,
                              fontWeight: FontWeight.bold,

                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
                floating: false,
                primary: true,
              ),
            ],
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        ExternalLaunchUrl("https://srkrec.edu.in/");
                        // changeTab(2);
                      },
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal:Size*20 ),
                        child: Text(
                          "eSRKR",
                          style: TextStyle(
                              fontSize: widget.size * 28.0,
                              color: Color.fromRGBO(192, 237, 252, 1),
                              fontWeight: FontWeight.w800,
                              fontFamily: "test"),
                        ),
                      ),
                    ),

                    Expanded(
                        child: SizedBox(
                      height: Size*30,
                      child: TabBar(
                        controller: _tabController,

                        dividerColor: Colors.transparent,
                        labelPadding: EdgeInsets.symmetric(horizontal: 5.0),
                        // Adjust padding as needed
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(widget.size * 15),
                          gradient:
                          LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                            Color(0xFF0e1c26),
                            Color(0xFF2a454b),
                            Color(0xFF243748),
                            Color(0xFF0e1c26),

                          ]),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white24,
                        isScrollable: true,

                        tabs: [
                          Tab(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(widget.size * 15),
                                // color:  _tabController. == 0?Color.fromRGBO(4, 11, 23, 1):Colors.white,
                              ),
                              padding: EdgeInsets.symmetric(horizontal: widget.size * 15.0),
                              // Adjust padding as needed
                              child: Text('Home'),
                            ),
                          ),
                          Tab(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: widget.size * 15.0),
                              // Adjust padding as needed

                              child: Text('Books'),
                            ),
                          ),
                          Tab(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: widget.size * 15.0),
                              // Adjust padding as needed

                              child: Text('News'),
                            ),
                          ),
                          Tab(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: widget.size * 15.0),
                              // Adjust padding as needed

                              child: Text('Updates'),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: widget.size * 10.0, top: widget.size * 20.0),
                              child: Text(
                                "Time Table",
                                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800,fontFamily: "test"),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: Size * 10, vertical: Size * 5),
                              child: StreamBuilder<List<TimeTableConvertor>>(
                                  stream: readTimeTable(branch: widget.branch, reg: widget.reg),
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
                                              child: Text('Error with Time Table Data or\n Check Internet Connection'));
                                        } else {
                                          if (BranchNews!.length == 0) {
                                            return Center(
                                                child: Text(
                                              "No Time Tables",
                                              style: TextStyle(color: Colors.amber.withOpacity(0.5)),
                                            ));
                                          } else
                                            return SizedBox(
                                              height: widget.size * 95,
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
                                                  return Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: widget.size * 5, vertical: widget.size * 5),
                                                    child: InkWell(
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height: widget.size * 60,
                                                            width: widget.size * 60,
                                                            decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: FileImage(file),
                                                                    fit: BoxFit.cover),
                                                                borderRadius: BorderRadius.circular(widget.size * 35),
                                                                border: Border.all(color: Colors.white12)),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.all(widget.size * 3.0),
                                                            child: Text(
                                                              BranchNew.heading.toUpperCase(),
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: widget.size * 15,
                                                                  fontWeight: FontWeight.w600,
                                                              fontFamily: "test"),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => ImageZoom(
                                                                      size: widget.size,
                                                                      url: "",
                                                                      file: file,
                                                                    )));
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                        }
                                    }
                                  }),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  flex: 4,
                                  child: Padding(
                                    padding: EdgeInsets.all(widget.size * 8.0),
                                    child: StreamBuilder<List<subjectsConvertor>>(
                                      stream: readFlashNews(widget.branch),
                                      builder: (context, flashSnapshot) {
                                        final subData = flashSnapshot.data;

                                        return StreamBuilder<List<subjectsConvertor>>(
                                          stream: readLabSubjects(widget.branch),
                                          builder: (context, labSnapshot) {
                                            final labData = labSnapshot.data;

                                            final combinedData = <dynamic>[];
                                            if (subData != null) {
                                              combinedData.addAll(subData);
                                            }
                                            if (labData != null) {
                                              combinedData.addAll(labData);
                                            }

                                            switch (labSnapshot.connectionState) {
                                              case ConnectionState.waiting:
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 0.3,
                                                    color: Colors.cyan,
                                                  ),
                                                );
                                              default:
                                                if (labSnapshot.hasError) {
                                                  return Center(child: Text("Error"));
                                                } else {
                                                  List<dynamic> filteredItems = combinedData
                                                      .where((item) =>
                                                          item.regulation.toString().startsWith(widget.reg))
                                                      .toList();
                                                  return Container(
                                                    height: filteredItems.length > 8
                                                        ? widget.size * 180
                                                        : widget.size * 125,
                                                    decoration: BoxDecoration(
                                                        // color: filteredItems.isNotEmpty
                                                        //     ? Color(0xFF363A3F)
                                                        //     : Color(0xFF15161E),


                                                          gradient:
                                                          LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                                                            Color(0xFF0e1c26).withOpacity(0.5),
                                                            Color(0xFF2a454b).withOpacity(0.3),
                                                            Color(0xFF243748).withOpacity(0.1),

                                                          ]),

                                                        borderRadius: BorderRadius.circular(widget.size * 30)),
                                                    child: Center(
                                                      child: Padding(
                                                        padding: EdgeInsets.all(widget.size * 5),
                                                        child: filteredItems.isNotEmpty
                                                            ? GridView.builder(
                                                                physics: NeverScrollableScrollPhysics(),
                                                                shrinkWrap: true,
                                                                gridDelegate:
                                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                                  crossAxisSpacing: widget.size * 5,
                                                                  mainAxisSpacing: widget.size * 5,
                                                                  childAspectRatio:
                                                                      (widget.size * 5) / (widget.size * 4),
                                                                  crossAxisCount: 4,
                                                                ),
                                                                itemCount: filteredItems.length,
                                                                itemBuilder: (context, int index) {
                                                                  final itemData = filteredItems[index];
                                                                  final isFlashConvertor = subData!.contains(itemData);

                                                                  return InkWell(
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(
                                                                            widget.size * 25),

                                                                        color: isFlashConvertor
                                                                            ? Colors.white54
                                                                            : Colors
                                                                                .white24, // Change the color here
                                                                      ),
                                                                      child: Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                          vertical: widget.size * 5,
                                                                          horizontal: widget.size * 8,
                                                                        ),
                                                                        child: Center(
                                                                          child: Text(
                                                                            itemData.heading.split(";").first,
                                                                            style: TextStyle(
                                                                              color: Colors.white,
                                                                              // Change the text color here
                                                                              fontSize: widget.size * 16,
                                                                              fontWeight: FontWeight.w700,
                                                                            ),
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
                                                                              subjectUnitsData(
                                                                                creator: itemData.creator,
                                                                            reg: itemData.regulation,
                                                                            size: widget.size,
                                                                            branch: widget.branch,
                                                                            ID: itemData.id,
                                                                            mode: isFlashConvertor
                                                                                ? "Subjects"
                                                                                : "LabSubjects",
                                                                            name: itemData.heading,
                                                                            description: itemData.description,
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
                                                                                child: fadeTransition,
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              )
                                                            : Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Icon(
                                                                    Icons.library_books,
                                                                    color: Colors.white,
                                                                  ),
                                                                  SizedBox(
                                                                    height: Size*10,
                                                                  ),
                                                                  Text(
                                                                    "No Subjects",
                                                                    style: TextStyle(
                                                                        color: Colors.white, fontSize: Size*20),
                                                                  ),
                                                                ],
                                                              ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Flexible(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: widget.size * 8.0),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            child: Container(
                                              height: widget.size * 50,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(widget.size * 20),
                                                color: Colors.white.withOpacity(0.2),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "SUB",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: widget.size * 25,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: "test"),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  transitionDuration: const Duration(milliseconds: 300),
                                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                                      Subjects(
                                                    branch: widget.branch,
                                                    reg: widget.reg,
                                                    width: widget.size,
                                                    height: widget.size,
                                                    size: widget.size,
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
                                          SizedBox(
                                            height: Size*10,
                                          ),
                                          InkWell(
                                            child: Container(
                                              height: widget.size * 50,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(widget.size * 20),
                                                color: Colors.white.withOpacity(0.2),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "LAB",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: widget.size * 25,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: "test"),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  transitionDuration: const Duration(milliseconds: 300),
                                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                                      LabSubjects(
                                                    branch: widget.branch,
                                                    reg: widget.reg,

                                                    size: widget.size,
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
                                    ))
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: widget.size * 8, vertical: 20),
                              child: SizedBox(
                                height: widget.size * 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                      child: InkWell(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: widget.size * 3),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(widget.size * 15),
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Time\nTable",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: widget.size * 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              transitionDuration: const Duration(milliseconds: 300),
                                              pageBuilder: (context, animation, secondaryAnimation) => TimeTables(
                                                reg: widget.reg,
                                                branch: widget.branch,
                                                size: widget.size,
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
                                    ),
                                    Flexible(
                                      child: InkWell(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: widget.size * 3),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(widget.size * 15),
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Syllabus",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: widget.size * 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              transitionDuration: const Duration(milliseconds: 300),
                                              pageBuilder: (context, animation, secondaryAnimation) =>
                                                  syllabusPage(
                                                branch: widget.branch,
                                                reg: widget.reg,
                                                size: widget.size,
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
                                    ),
                                    Flexible(
                                      child: InkWell(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: widget.size * 3),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(widget.size * 15),
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Model\nPaper",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: widget.size * 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              transitionDuration: const Duration(milliseconds: 300),
                                              pageBuilder: (context, animation, secondaryAnimation) =>
                                                  ModalPapersPage(
                                                branch: widget.branch,
                                                reg: widget.reg,
                                                size: widget.size,
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
                                    ),
                                    Flexible(
                                      child: InkWell(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: widget.size * 3),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(widget.size * 15),
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Books",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: widget.size * 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          changeTab(1);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: Size * 10, vertical: Size * 10),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: InkWell(
                                      child: Padding(
                                        padding:  EdgeInsets.only(right:Size* 10.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.05),
                                              border: Border.all(color: Colors.white10),
                                              borderRadius: BorderRadius.all(Radius.circular(Size * 15))),
                                          child: Padding(
                                            padding:  EdgeInsets.all(Size*8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "Text To Speech",
                                                  style: TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: Size*25,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                                Container(
                                                  height: Size*25,
                                                  width: Size*25,
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      image: DecorationImage(image: AssetImage("assets/img.png")),
                                                      borderRadius: BorderRadius.all(Radius.circular(Size * 20))),
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
                                            transitionDuration: const Duration(milliseconds: 300),
                                            pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(),
                                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                                  ),
                                  Flexible(
                                      child: InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.01),
                                          border: Border.all(color: Colors.white10),
                                          borderRadius: BorderRadius.all(Radius.circular(Size * 15))),
                                      child: Padding(
                                        padding:  EdgeInsets.all(Size*5.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Ask",
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: Size*25,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Container(
                                              height: Size*30,
                                              width: Size*30,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(color: Colors.white24),
                                                  borderRadius: BorderRadius.all(Radius.circular(Size * 15))),
                                              child: Padding(
                                                padding:  EdgeInsets.all(Size*3.0),
                                                child: Text(
                                                  "AI",
                                                  style: TextStyle(fontSize: Size*22, fontWeight: FontWeight.bold),
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

                            // if (modelPaper.isNotEmpty && syllabus.isNotEmpty)
                            //   Row(
                            //     children: [
                            //       if (syllabus.isNotEmpty)
                            //         Flexible(child: Container()),
                            //       if (modelPaper.isNotEmpty)
                            //         Flexible(child: Container())
                            //     ],
                            //   ),

                            StreamBuilder<List<FavouriteSubjectsConvertor>>(
                              stream: readFavouriteSubjects(),
                              builder: (context, snapshot1) {
                                final favourites1 = snapshot1.data;

                                return StreamBuilder<List<FavouriteSubjectsConvertor>>(
                                  stream: readFavouriteLabSubjects(),
                                  builder: (context, snapshot2) {
                                    final favourites2 = snapshot2.data;

                                    if (snapshot1.connectionState == ConnectionState.waiting ||
                                        snapshot2.connectionState == ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 0.3,
                                          color: Colors.cyan,
                                        ),
                                      );
                                    } else if (snapshot1.hasError || snapshot2.hasError) {
                                      return Center(child: Text("Error"));
                                    } else if ((favourites1 != null && favourites1.isNotEmpty) ||
                                        (favourites2 != null && favourites2.isNotEmpty)) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: widget.size * 10.0, top: widget.size * 20.0),
                                            child: Text(
                                              "Saved",
                                              style: TextStyle(
                                                  color: Colors.white, fontSize: Size*20, fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          if (favourites1 != null && favourites1.isNotEmpty)
                                            SizedBox(
                                              height: widget.size * 70,
                                              child: ListView.separated(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: favourites1.length,
                                                  itemBuilder: (context, int index) {
                                                    final Favourite = favourites1[index];
                                                    return InkWell(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(left: index == 0 ? widget.size * 20 : 0),
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets.only(top: Size*10.0, right: Size*9),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.white24,
                                                                  borderRadius: BorderRadius.all(
                                                                      Radius.circular(widget.size * 20))),
                                                              child: Padding(
                                                                padding:  EdgeInsets.symmetric(
                                                                    vertical: Size*10, horizontal: Size*25),
                                                                child: Text(
                                                                  Favourite.name.split(";").first,
                                                                  style: TextStyle(
                                                                    fontSize: widget.size * 22.0,
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: 0,
                                                              right: 0,
                                                              child: InkWell(
                                                                child: Icon(
                                                                  Icons.highlight_remove_outlined,
                                                                  color: Colors.orange,
                                                                  size: widget.size * 25,
                                                                ),
                                                                onTap: () {
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (context) {
                                                                      return Dialog(
                                                                        backgroundColor: Colors.transparent,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(
                                                                                widget.size * 20)),
                                                                        elevation: 16,
                                                                        child: Container(
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(color: Colors.white54),
                                                                            borderRadius: BorderRadius.circular(
                                                                                widget.size * 20),
                                                                          ),
                                                                          child: ListView(
                                                                            shrinkWrap: true,
                                                                            children: <Widget>[
                                                                              SizedBox(height: widget.size * 10),
                                                                              SizedBox(height: widget.size * 5),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(
                                                                                    left: widget.size * 15),
                                                                                child: Text(
                                                                                  "Do you want Remove from Favourites",
                                                                                  style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: widget.size * 20),
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
                                                                                          color: Colors.white24,
                                                                                          border: Border.all(
                                                                                              color: Colors.white10),
                                                                                          borderRadius:
                                                                                              BorderRadius.circular(
                                                                                                  widget.size * 25),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.only(
                                                                                              left: widget.size * 15,
                                                                                              right: widget.size * 15,
                                                                                              top: widget.size * 5,
                                                                                              bottom:
                                                                                                  widget.size * 5),
                                                                                          child: Text(
                                                                                            "Back",
                                                                                            style: TextStyle(
                                                                                              color: Colors.white,
                                                                                            ),
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
                                                                                          padding: EdgeInsets.only(
                                                                                              left: widget.size * 15,
                                                                                              right: widget.size * 15,
                                                                                              top: widget.size * 5,
                                                                                              bottom:
                                                                                                  widget.size * 5),
                                                                                          child: Text(
                                                                                            "Delete",
                                                                                            style: TextStyle(
                                                                                                color: Colors.white),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      onTap: () {
                                                                                        FirebaseFirestore.instance
                                                                                            .collection('user')
                                                                                            .doc(FirebaseAuth.instance
                                                                                                .currentUser!.email!)
                                                                                            .collection(
                                                                                                "FavouriteSubject")
                                                                                            .doc(Favourite.id)
                                                                                            .delete();
                                                                                        Navigator.pop(context);
                                                                                        showToastText(
                                                                                            "${Favourite.name} as been removed");
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
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => subjectUnitsData(
                                                                  creator: Favourite.creator,

                                                                  reg: Favourite.regulation,
                                                                      size: widget.size,
                                                                      branch: Favourite.branch,
                                                                      ID: Favourite.id,
                                                                      mode: "Subjects",
                                                                      name: Favourite.name,
                                                                      description: Favourite.description,
                                                                    )));
                                                      },
                                                    );
                                                  },
                                                  separatorBuilder: (context, index) => SizedBox(
                                                        width: widget.size * 6,
                                                      )),
                                            ),
                                          if (favourites2 != null && favourites2.isNotEmpty)
                                            SizedBox(
                                              height: widget.size * 70,
                                              child: ListView.separated(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: favourites2.length,
                                                  itemBuilder: (context, int index) {
                                                    final Favourite = favourites2[index];
                                                    return InkWell(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(left: index == 0 ? widget.size * 20 : 0),
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets.only(top: Size*10.0, right: Size*9),
                                                              decoration: BoxDecoration(
                                                                  color: Colors.white12,
                                                                  borderRadius: BorderRadius.all(
                                                                      Radius.circular(widget.size * 20))),
                                                              child: Padding(
                                                                padding:  EdgeInsets.symmetric(
                                                                    vertical: Size*10, horizontal: Size*25),
                                                                child: Text(
                                                                  Favourite.name.split(";").first,
                                                                  style: TextStyle(
                                                                    fontSize: widget.size * 22.0,
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.w700,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: 0,
                                                              right: 0,
                                                              child: InkWell(
                                                                child: Icon(
                                                                  Icons.highlight_remove_outlined,
                                                                  color: Colors.orange,
                                                                  size: widget.size * 25,
                                                                ),
                                                                onTap: () {
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (context) {
                                                                      return Dialog(
                                                                        backgroundColor: Colors.transparent,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(
                                                                                widget.size * 20)),
                                                                        elevation: 16,
                                                                        child: Container(
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(color: Colors.white54),
                                                                            borderRadius: BorderRadius.circular(
                                                                                widget.size * 20),
                                                                          ),
                                                                          child: ListView(
                                                                            shrinkWrap: true,
                                                                            children: <Widget>[
                                                                              SizedBox(height: widget.size * 10),
                                                                              SizedBox(height: widget.size * 5),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(
                                                                                    left: widget.size * 15),
                                                                                child: Text(
                                                                                  "Do you want Remove from Favourites",
                                                                                  style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: widget.size * 20),
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
                                                                                          color: Colors.white24,
                                                                                          border: Border.all(
                                                                                              color: Colors.white10),
                                                                                          borderRadius:
                                                                                              BorderRadius.circular(
                                                                                                  widget.size * 25),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.only(
                                                                                              left: widget.size * 15,
                                                                                              right: widget.size * 15,
                                                                                              top: widget.size * 5,
                                                                                              bottom:
                                                                                                  widget.size * 5),
                                                                                          child: Text(
                                                                                            "Back",
                                                                                            style: TextStyle(
                                                                                              color: Colors.white,
                                                                                            ),
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
                                                                                          padding: EdgeInsets.only(
                                                                                              left: widget.size * 15,
                                                                                              right: widget.size * 15,
                                                                                              top: widget.size * 5,
                                                                                              bottom:
                                                                                                  widget.size * 5),
                                                                                          child: Text(
                                                                                            "Delete",
                                                                                            style: TextStyle(
                                                                                                color: Colors.white),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      onTap: () {
                                                                                        FirebaseFirestore.instance
                                                                                            .collection('user')
                                                                                            .doc(FirebaseAuth.instance
                                                                                                .currentUser!.email!)
                                                                                            .collection(
                                                                                                "FavouriteLabSubjects")
                                                                                            .doc(Favourite.id)
                                                                                            .delete();
                                                                                        Navigator.pop(context);
                                                                                        showToastText(
                                                                                            "${Favourite.name} as been removed");
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
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => subjectUnitsData(
                                                                      reg: Favourite.name,
                                                                      size: widget.size,
                                                                      branch: Favourite.branch,
                                                                      ID: Favourite.id,
                                                                      mode: "LabSubjects",
                                                                      name: Favourite.name,
                                                                      description: Favourite.description, creator: Favourite.creator,
                                                                    )));
                                                      },
                                                    );
                                                  },
                                                  separatorBuilder: (context, index) => SizedBox(
                                                        width: widget.size * 6,
                                                      )),
                                            ),
                                        ],
                                      );
                                    } else {
                                      return Container(); // No data, don't show anything
                                    }
                                  },
                                );
                              },
                            ),
                            StreamBuilder<List<FlashNewsConvertor>>(
                                stream: readSRKRFlashNews(),
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
                                        return Favourites!.isNotEmpty
                                            ? Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(widget.size * 8.0),
                                                    child: Text(
                                                      "Flash News",
                                                      style:
                                                          secondHeadingTextStyle(color: Colors.white, size: widget.size),
                                                    ),
                                                  ),
                                                  CarouselSlider(
                                                      items: List.generate(Favourites!.length, (int index) {
                                                        final BranchNew = Favourites[index];

                                                        return Row(
                                                          children: [
                                                            Expanded(
                                                              child: InkWell(
                                                                child: Padding(
                                                                  padding: EdgeInsets.only(left: widget.size * 20),
                                                                  child: Text(
                                                                    BranchNew.heading,
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.w500,
                                                                        fontFamily: "test",
                                                                        fontSize: widget.size * 16),
                                                                    maxLines: 3,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  if (BranchNew.Url.isNotEmpty) {
                                                                    ExternalLaunchUrl(BranchNew.Url);
                                                                  } else {
                                                                    showToastText("No Url Found");
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                            if (isGmail())
                                                              PopupMenuButton(
                                                                icon: Icon(
                                                                  Icons.more_vert,
                                                                  color: Colors.white,
                                                                  size: widget.size * 25,
                                                                ),
                                                                // Callback that sets the selected popup menu item.
                                                                onSelected: (item) {
                                                                  if (item == "edit") {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => flashNewsCreator(
                                                                              branch: widget.branch,
                                                                                  size: widget.size,
                                                                                  heading: BranchNew.heading,
                                                                                  link: BranchNew.Url,
                                                                                  NewsId: BranchNew.id,
                                                                                )));
                                                                  } else if (item == "delete") {
                                                                    messageToOwner("Flash News is Deleted\nBy : '${fullUserId()}' \n   Heading : ${BranchNew.heading}\n   Link : ${BranchNew.Url}");

                                                                    FirebaseFirestore.instance
                                                                        .collection("srkrPage")
                                                                        .doc("flashNews")
                                                                        .collection("flashNews")
                                                                        .doc(BranchNew.id)
                                                                        .delete();
                                                                  }
                                                                },
                                                                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
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
                                                          ],
                                                        );
                                                      }),
                                                      options: CarouselOptions(
                                                        viewportFraction: 1,
                                                        enlargeCenterPage: true,
                                                        height: widget.size * 60,
                                                        autoPlayAnimationDuration: Duration(milliseconds: 1800),
                                                        autoPlay: Favourites.length > 1 ? true : false,
                                                      )),
                                                ],
                                              )
                                            : Container();
                                      }
                                  }
                                }),



                            Padding(
                              padding:  EdgeInsets.symmetric(vertical:Size* 10.0),
                              child: Center(
                                child: InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white24, borderRadius: BorderRadius.circular(widget.size * 40)),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: widget.size * 6, horizontal: widget.size * 20),
                                      child: Text(
                                        "Exam Notification",
                                        style: TextStyle(color: Colors.white, fontSize: widget.size * 30),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    ExternalLaunchUrl("http://www.srkrexams.in/Login.aspx");
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: widget.size * 50,
                            )
                          ],
                        ),
                      ),
                      allBooks(
                        size: widget.size,
                        branch: widget.branch,
                      ),
                      NewsPage(
                        size: widget.size,
                        branch: widget.branch,
                      ),
                      updatesPage(
                        size: widget.size,
                        branch: widget.branch,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: SizedBox(
          height: Size*40,
          width: Size*40,
          child: Visibility(
              visible: isGmail()||isOwner(),
              child:SpeedDial(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                animatedIconTheme: IconThemeData(size: 50.0),

                animatedIcon: AnimatedIcons.add_event,
            openCloseDial: isDialOpen,
            backgroundColor: Color.fromRGBO(101, 150, 161, 1),
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            spacing:Size* 2,
            spaceBetweenChildren: Size* 2,
            // closeManually: true,
            children: [
              SpeedDialChild(
                  child: Text("Book",style: TextStyle(fontSize: Size* 18),),
                  label: 'Books',
                  onTap: () {
                     Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BooksCreator(
                                  branch: widget.branch,
                                )));
                  }
              ),
              SpeedDialChild(
                  child: Text("Sub",style: TextStyle(fontSize: Size* 18),),
                  label: 'Subject',
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SubjectsCreator(
                                  size: widget.size,

                                  branch: widget.branch,
                                )));
                  }
              ),
              SpeedDialChild(
                  child: Text("News",style: TextStyle(fontSize: Size* 18),),
                  label: 'Branch News',
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NewsCreator(
                                  branch: widget.branch,
                                )));
                  }
              ),
              SpeedDialChild(
                  child: Text("Updates",style: TextStyle(fontSize: Size* 12),),
                  label: 'Updates',
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            updateCreator(
                              branch: widget.branch,

                              size: widget.size,
                            )));
                  }
              ),
              SpeedDialChild(
                  child: Text("A.R",style: TextStyle(fontSize: Size* 18),),
                  label: 'Add Regulation',
                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          backgroundColor:
                          Colors.black.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                  widget.size * 20)),
                          elevation: 16,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(
                                  color: Colors.white24),
                              borderRadius:
                              BorderRadius.circular(
                                  widget.size * 20),
                            ),
                            child: ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                SizedBox(
                                    height: widget.size * 15),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: widget.size * 15),
                                  child: Text(
                                    "Add Regulation by Entering r20",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight:
                                        FontWeight.w600,
                                        fontSize:
                                        widget.size * 18),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: widget.size * 10),
                                  child: TextFieldContainer(
                                    child: TextField(
                                      controller: InputController,
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(color: Colors.white,fontSize: widget.size * 20),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'r2_ <= Enter Regulation Number',
                                          hintStyle: TextStyle(
                                              color: Colors.white70, fontSize: widget.size * 20)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: widget.size * 5,
                                ),
                                Center(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .center,
                                    children: [
                                      Spacer(),
                                      InkWell(
                                        child: Container(
                                          decoration:
                                          BoxDecoration(
                                            color:
                                            Colors.black26,
                                            border: Border.all(
                                                color: Colors
                                                    .white
                                                    .withOpacity(
                                                    0.3)),
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                widget.size *
                                                    25),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: widget
                                                    .size *
                                                    15,

                                                vertical: widget
                                                    .size *
                                                    5),
                                            child: Text(
                                              "Back",
                                              style: TextStyle(
                                                  color: Colors
                                                      .white,fontSize: widget.size *14),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pop(
                                              context);
                                        },
                                      ),
                                      SizedBox(
                                        width:
                                        widget.size * 10,
                                      ),
                                      InkWell(
                                        child: Container(
                                          decoration:
                                          BoxDecoration(
                                            color: Colors.red,
                                            border: Border.all(
                                                color: Colors
                                                    .black),
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                widget.size *
                                                    25),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: widget
                                                    .size *
                                                    15,

                                                vertical: widget
                                                    .size *
                                                    5),
                                            child: Text(
                                              "ADD + ",
                                              style: TextStyle(
                                                  color: Colors
                                                      .white,fontSize: widget.size *14),
                                            ),
                                          ),
                                        ),
                                        onTap: () async {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false, // Prevents dismissing the dialog by tapping outside
                                            builder: (context) {
                                              return AlertDialog(
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    CircularProgressIndicator(),
                                                    SizedBox(height: 16),
                                                    Text('Creating...'),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                          String reg = InputController.text;
                                          for (int year = 1; year <= 4; year++) {
                                            for (int sem = 1; sem <= 2; sem++) {

                                              print("${reg.toLowerCase()} $year year $sem sem");
                                              await FirebaseFirestore.instance
                                                  .collection(widget.branch)
                                                  .doc("regulation")
                                                  .collection("regulationWithYears").doc("${reg.toLowerCase()} $year year $sem sem".substring(0, 10)).set(
                                                  {
                                                    "id":"${reg.toLowerCase()} $year year $sem sem".substring(0, 10),
                                                    "syllabus":"",
                                                    "modelPaper":"",
                                                  }
                                              );
                                              await createRegulationSem(name: "${reg.toLowerCase()} $year year $sem sem", branch: widget.branch);
                                            }
                                          }
                                          messageToOwner("Regulation is Created.\nBy '${fullUserId()}'\n   Regulation : $reg\n **${widget.branch}");
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      SizedBox(
                                        width:
                                        widget.size * 20,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: widget.size* 10,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
              ),
              SpeedDialChild(
                  child: Text("M.P",style: TextStyle(fontSize: Size* 14),),
                  label: 'Model Paper',
                  onTap: (){
                    if(widget.reg.isNotEmpty&&widget.reg !="None")Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                timeTableSyllabusModalPaperCreator(
                                  heading: widget.reg,
                                  size: widget.size, mode: 'modalPaper', reg: widget.reg, branch: widget.branch,id: widget.reg,
                                )));
                    else{
                      showToastText("Select Your Regulation");

                    }
                  }
              ),
              SpeedDialChild(
                  child: Text("Sylla",style: TextStyle(fontSize: Size* 14),),
                  label: 'Syllabus ',
                  onTap: (){
                    if(widget.reg.isNotEmpty&&widget.reg !="None")Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                timeTableSyllabusModalPaperCreator(
                                  heading: widget.reg,

                                  size: widget.size, mode: 'Syllabus', reg: widget.reg, branch: widget.branch,id: widget.reg,
                                )));
                    else{
                      showToastText("Select Your Regulation");
                    }
                  }
              ),
              SpeedDialChild(
                  child: Text("T.T",style: TextStyle(fontSize: Size* 18),),
                  label: 'Time Table',
                  onTap: (){
                    if(widget.reg.isNotEmpty&&widget.reg !="None")Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                timeTableSyllabusModalPaperCreator(
                                  size: widget.size, mode: 'Time Table', reg: widget.reg, branch: widget.branch,
                                )));
                    else{
                    showToastText("Select Your Regulation");
                    }
                  }
              ),SpeedDialChild(
                  child: Text("F.N",style: TextStyle(fontSize: Size* 18),),
                  label: 'Flash News',
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                flashNewsCreator(
                                  branch: widget.branch,
                                  size: widget.size,
                                )));
                  }
              ),
            ],
          )),
        ),
      ),
    );
  }
}

Stream<List<UpdateConvertor>> readUpdate(String branch) => FirebaseFirestore.instance
    .collection("update")
    .orderBy("id", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => UpdateConvertor.fromJson(doc.data())).toList());

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
      id: id, heading: heading, description: description, photoUrl: photoUrl, link: link, creator: creator);
  final json = flash.toJson();
  await docflash.set(json);
}

class UpdateConvertor {
  String id;
  final String heading, photoUrl, link, description,creator;
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
        heading: json["heading"],
    creator: json["creator"]??"",
        photoUrl: json["image"],
        link: json["link"],
        description: json["description"],
        likedBy: json["likedBy"] != null ? List<String>.from(json["likedBy"]) : [],
        isViewed: json["isViewed"] != null ? List<String>.from(json["isViewed"]) : [],
      );
}

Future createRegulationSem({required String name, required String branch}) async {
  final docflash =
      FirebaseFirestore.instance.collection(branch).doc("regulation").collection("regulationWithSem").doc(name);
  final flash = RegulationConvertor(id: name);
  final json = flash.toJson();
  await docflash.set(json);
}

Stream<List<syllabusConvertor>> readsyllabus({required String branch}) => FirebaseFirestore.instance
    .collection(branch)
    .doc("regulation")
    .collection("regulationWithYears")
    .orderBy("id", descending: true)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => syllabusConvertor.fromJson(doc.data())).toList());

Stream<List<modelPaperConvertor>> readmodelPaper({required String branch}) => FirebaseFirestore.instance
    .collection(branch)
    .doc("regulation")
    .collection("regulationWithYears")
    .orderBy("id", descending: true)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => modelPaperConvertor.fromJson(doc.data())).toList());

class RegulationWithYearConvertor {
  String id;
  String modelPaper;
  String syllabus;

  RegulationWithYearConvertor({this.id = "", required this.modelPaper, required this.syllabus});

  Map<String, dynamic> toJson() => {
        "id": id,
        "modelPaper": modelPaper,
        "syllabus": syllabus,
      };

  static RegulationWithYearConvertor fromJson(Map<String, dynamic> json) => RegulationWithYearConvertor(
        id: json['id'],
        modelPaper: json['modelPaper'],
        syllabus: json['syllabus'],
      );
}

class RegulationConvertor {
  String id;

  RegulationConvertor({this.id = ""});

  Map<String, dynamic> toJson() => {"id": id};

  static RegulationConvertor fromJson(Map<String, dynamic> json) => RegulationConvertor(id: json['id']);
}

class syllabusConvertor {
  String id;
  String syllabus;

  syllabusConvertor({this.id = "", required this.syllabus});

  Map<String, dynamic> toJson() => {
        "id": id,
        "syllabus": syllabus,
      };

  static syllabusConvertor fromJson(Map<String, dynamic> json) => syllabusConvertor(
        id: json['id'],
        syllabus: json['syllabus'],
      );
}

class modelPaperConvertor {
  String id;
  String modelPaper;

  modelPaperConvertor({this.id = "", required this.modelPaper});

  Map<String, dynamic> toJson() => {
        "id": id,
        "modelPaper": modelPaper,
      };

  static modelPaperConvertor fromJson(Map<String, dynamic> json) => modelPaperConvertor(
        id: json['id'],
        modelPaper: json['modelPaper'],
      );
}

Stream<List<TimeTableConvertor>> readTimeTable({required String reg, required String branch}) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("regulation")
        .collection("regulationWithSem")
        .doc(reg)
        .collection("timeTables")
        .orderBy("heading", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => TimeTableConvertor.fromJson(doc.data())).toList());

Future createTimeTable(
    {required String branch, required String heading, required String photoUrl, required String reg}) async {
  String id = getID();
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc("regulation")
      .collection("regulationWithSem")
      .doc(reg)
      .collection("timeTables")
      .doc(id);
  final flash = TimeTableConvertor(id: id, heading: heading, photoUrl: photoUrl);
  final json = flash.toJson();
  await docflash.set(json);
}

class TimeTableConvertor {
  String id;
  final String heading, photoUrl;

  TimeTableConvertor({this.id = "", required this.heading, required this.photoUrl});

  Map<String, dynamic> toJson() => {"id": id, "heading": heading, "image": photoUrl};

  static TimeTableConvertor fromJson(Map<String, dynamic> json) =>
      TimeTableConvertor(id: json['id'], heading: json["heading"], photoUrl: json['image']);
}

Stream<List<BranchNewConvertor>> readBranchNew(String branch) => FirebaseFirestore.instance
    .collection(branch)
    .doc("${branch}News")
    .collection("${branch}News")
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => BranchNewConvertor.fromJson(doc.data())).toList());

Future createBranchNew(
    {required String id,
    required String heading,
    required String description,
    required String branch,
    required String photoUrl}) async {
  final docflash =
      FirebaseFirestore.instance.collection(branch).doc("${branch}News").collection("${branch}News").doc(id);
  final flash = BranchNewConvertor(
    id: id,
    heading: heading,
    photoUrl: photoUrl,
    description: description,
  );
  final json = flash.toJson();
  await docflash.set(json);
}

class BranchNewConvertor {
  String id;
  final String heading, photoUrl, description;
  List<String> likedBy, isViewed;

  BranchNewConvertor({
    this.id = "",
    required this.heading,
    required this.photoUrl,
    required this.description,
    List<String>? likedBy,
    List<String>? isViewed,
  })  : likedBy = likedBy ?? [],
        isViewed = isViewed ?? [];

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "image": photoUrl,
        "description": description,
      };

  static BranchNewConvertor fromJson(Map<String, dynamic> json) => BranchNewConvertor(
        id: json['id'],
        heading: json["heading"],
        photoUrl: json["image"],
        description: json["description"],
        likedBy: json["likedBy"] != null ? List<String>.from(json["likedBy"]) : [],
        isViewed: json["isViewed"] != null ? List<String>.from(json["isViewed"]) : [],
      );
}

Stream<List<FlashNewsConvertor>> readSRKRFlashNews() => FirebaseFirestore.instance
    .collection("srkrPage")
    .doc("flashNews")
    .collection("flashNews")
    .orderBy("heading", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => FlashNewsConvertor.fromJson(doc.data())).toList());

Future createSubjects(
    {required String heading,
    required String branch,
    required String description,
    required String creator,
    required String regulation}) async {
  final docflash = FirebaseFirestore.instance.collection(branch).doc("Subjects").collection("Subjects").doc(getID());
  final flash = subjectsConvertor(id: getID(), heading: heading, description: description, regulation: regulation, creator: creator);
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

  static FlashNewsConvertor fromJson(Map<String, dynamic> json) => FlashNewsConvertor(
        id: json['id'],
        heading: json["heading"],
        Url: json["link"],
      );
}

Stream<List<subjectsConvertor>> readFlashNews(String branch) => FirebaseFirestore.instance
    .collection(branch)
    .doc("Subjects")
    .collection("Subjects")
    .orderBy("heading", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => subjectsConvertor.fromJson(doc.data())).toList());

class subjectsConvertor {
  String id;
  final String heading, description, regulation,creator;

  subjectsConvertor({this.id = "", required this.regulation, required this.heading, required this.description,required this.creator});

  Map<String, dynamic> toJson() => {"id": id, "heading": heading, "description": description, "regulation": regulation,"creator":creator};

  static subjectsConvertor fromJson(Map<String, dynamic> json) => subjectsConvertor(
      id: json['id'], regulation: json["regulation"]??"", heading: json["heading"]??"", description: json["description"]??"", creator: json["creator"]??"");
}

Stream<List<subjectsConvertor>> readLabSubjects(String branch) => FirebaseFirestore.instance
    .collection(branch)
    .doc("LabSubjects")
    .collection("LabSubjects")
    .orderBy("heading", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => subjectsConvertor.fromJson(doc.data())).toList());

Future createLabSubjects(
    {required String branch,
    required String heading,
    required String description,
    required String creator,
    required String regulation}) async {
  final docflash =
      FirebaseFirestore.instance.collection(branch).doc("LabSubjects").collection("LabSubjects").doc(getID());
  final flash = subjectsConvertor(id: getID(), heading: heading, description: description, regulation: regulation, creator: creator);
  final json = flash.toJson();
  await docflash.set(json);
}

Stream<List<BooksConvertor>> ReadBook(String branch) => FirebaseFirestore.instance
    .collection(branch)
    .doc("Books")
    .collection("CoreBooks")
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => BooksConvertor.fromJson(doc.data())).toList());

Future createBook(
    {required String heading,
    required String description,
    required String link,
    required String branch,
    required String photoUrl,
    required String edition,
    required String Author}) async {
  final docBook = FirebaseFirestore.instance.collection(branch).doc("Books").collection("CoreBooks").doc(getID());
  final Book = BooksConvertor(
    id: getID(),
    heading: heading,
    link: link,
    description: description,
    photoUrl: photoUrl,
    Author: Author,
    edition: edition,
  );
  final json = Book.toJson();
  await docBook.set(json);
}

class BooksConvertor {
  String id;
  final String heading, link, description, photoUrl, edition, Author, size;

  BooksConvertor(
      {this.id = "",
      required this.heading,
      required this.link,
      required this.description,
      required this.photoUrl,
      required this.edition,
      required this.Author,
      this.size = ""});

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "link": link,
        "description": description,
        "image": photoUrl,
        "author": Author,
        "size": Author,
        "edition": edition,
      };

  static BooksConvertor fromJson(Map<String, dynamic> json) => BooksConvertor(
        id: json['id'],
        heading: json["heading"],
        link: json["link"],
        description: json["description"],
        photoUrl: json["image"],
        Author: json["author"],
        edition: json["edition"],
        size: json["size"],
      );
}

class ImageZoom extends StatefulWidget {
  String url;
  File file;
  final double size;

  ImageZoom({
    Key? key,
    required this.url,
    required this.file,
    required this.size,
  }) : super(key: key);

  @override
  State<ImageZoom> createState() => _ImageZoomState();
}

class _ImageZoomState extends State<ImageZoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              widget.url.isEmpty
                  ? PhotoView(
                      imageProvider: FileImage(widget.file),
                    )
                  : PhotoView(imageProvider: NetworkImage(widget.url)),
              Align(
                alignment: Alignment.topLeft,
                child: backButton(
                    size: widget.size,
                    child: SizedBox(
                      width: widget.size*45,
                    )),
              )
            ],
          ),
        ));
  }
}
