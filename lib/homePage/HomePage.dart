// ignore_for_file: must_be_immutable, unnecessary_import
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:srkr_study_app/SubPages.dart';
import 'package:srkr_study_app/add%20subjects.dart';
import 'package:srkr_study_app/notification.dart';
import 'package:srkr_study_app/search%20bar.dart';
import 'package:srkr_study_app/homePage/settings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../TextField.dart';
import '../functions.dart';

class appBar_HomePage extends StatefulWidget {
  double size;
  String reg, branch, name;


  appBar_HomePage(
      {required this.size,
      required this.branch,
      required this.reg,
      required this.name});

  @override
  State<appBar_HomePage> createState() => _appBar_HomePageState();
}

class _appBar_HomePageState extends State<appBar_HomePage> {
  List searchList = ["Search About", "Subjects", "Lab Subjects"];
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: widget.size * 10.0, vertical: widget.size * 5),
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
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: Size * 10),
                                child: Text(
                                  "eSRKR",
                                  style: TextStyle(
                                      fontSize: widget.size * 25.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: "test"),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: widget.size * 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '$greeting',
                              style: TextStyle(
                                  fontSize: widget.size * 14.0,
                                  color: Colors.white),
                            ),
                            Text(
                              "${widget.name.replaceAll(";", " ").toUpperCase()}",
                              style: TextStyle(
                                fontSize: widget.size * 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              SizedBox(
                width: widget.size * 120,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            MyAppq(
                                branch: widget.branch,
                                reg: widget.reg,
                                size: widget.size),
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
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(Size * 20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: widget.size * 8,
                          vertical: widget.size * 2),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.white70,
                            size: widget.size * 20,
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
                                        fontSize: widget.size * 14.0,
                                        color: Colors.white70,
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
                                height: widget.size * 35,
                                autoPlayAnimationDuration:
                                    const Duration(seconds: 3),
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
              SizedBox(
                width: widget.size * 5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class tabBar extends StatefulWidget {
  final TabController tabController;

  tabBar({required this.tabController});

  @override
  _tabBarState createState() => _tabBarState();
}

class _tabBarState extends State<tabBar> {
  List<String> tabBarIndex = ["Home", "Subjects", "Lab Subjects", "Books"];
  int currentIndex = 0;

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
    double Size = size(context);
    return SizedBox(
      height: Size * 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabBarIndex.asMap().entries.map((entry) {
            final index = entry.key;
            final label = entry.value;

            return InkWell(
              child: Padding(
                padding: EdgeInsets.only(
                    left: index == 0 ? Size * 12.0 : Size * 5,
                    right: index == tabBarIndex.length - 1 ? Size * 20 : 0,
                    bottom: Size * 8),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: currentIndex == index
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.5),
                              Colors.blue.withOpacity(0.2),
                              Colors.deepPurpleAccent.withOpacity(0.5),
                            ],
                          )
                        : LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.03),
                              Colors.white.withOpacity(0.08),
                            ],
                          ),
                    borderRadius: BorderRadius.circular(Size * 20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Size * 12),
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: currentIndex == index
                              ? Colors.white
                              : Colors.white38,
                          fontSize: Size * 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () {
                homePageKey.currentState?.changeTab(index);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

final GlobalKey<_HomePageState> homePageKey = GlobalKey<_HomePageState>();

class HomePage extends StatefulWidget {
  final String branch, name;

  final String reg;
  final double size;

  HomePage({
    required this.branch,
    required this.name,
    required this.reg,
    required this.size,
  }) : super(key: homePageKey);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List searchList = ["Search About", "Subjects", "Lab Subjects"];
  String modelPaper = "";
  String syllabus = "";
  late TabController _tabController;
  String folderPath = "";

  String branch = "";
  List<syllabusConvertor> syllabusModelPaper = [];

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
      branch = widget.branch;
    });
  }

  Future<void> fetchDataAndConvertToString() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection(widget.branch)
          .doc("regulation")
          .collection("regulationWithYears")
          .orderBy("id", descending: true)
          .get();
      syllabusModelPaper = snapshot.docs
          .map((doc) => syllabusConvertor.fromJson(doc.data()))
          .toList();
      setState(() {
        syllabusModelPaper;
      });
    } catch (error) {
      print('Error fetching or converting data: $error');
    }
  }

  @override
  void initState() {
    getPath();
    fetchDataAndConvertToString();
    _tabController = new TabController(vsync: this, length: 4);
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void changeTab(int newIndex) {
    _tabController.animateTo(newIndex);
  }

  final InputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double Size = size(context);

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.size * 20)),
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
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: widget.size * 18),
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
                                  color: Colors.black,
                                  fontSize: widget.size * 20,
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
                                  fontSize: widget.size * 20,
                                  fontWeight: FontWeight.w600),
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
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: widget.size * 50,
            collapsedHeight: widget.size * 50,
            toolbarHeight: widget.size * 50,
            backgroundColor: Colors.transparent,
            flexibleSpace: appBar_HomePage(
              size: Size,
              reg: widget.reg,
              branch: widget.branch,
              name: widget.name,
            ),
            floating: false,
            primary: true,
          ),
        ],
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: widget.size * 15,
            ),
            tabBar(
              tabController: _tabController,
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
                        InkWell(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: widget.size * 10.0,
                                vertical: widget.size * 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Time Tables",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: widget.size * 20),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.white,
                                  size: widget.size * 20,
                                )
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
                                  size: widget.size,
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
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: Size * 8),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.circular(widget.size * 30)),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: Size * 5),
                                child: StreamBuilder<List<TimeTableConvertor>>(
                                    stream: readTimeTable(
                                        branch: widget.branch, reg: widget.reg),
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
                                                style: TextStyle(
                                                    color: Colors.amber
                                                        .withOpacity(0.5)),
                                              ));
                                            } else
                                              return SizedBox(
                                                height: widget.size * 98,
                                                child: ListView.builder(
                                                  itemCount: BranchNews.length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder:
                                                      (context, int index) {
                                                    var BranchNew =
                                                        BranchNews[index];

                                                    return Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: widget
                                                                      .size *
                                                                  5,
                                                              vertical:
                                                                  widget.size *
                                                                      5),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                              padding: EdgeInsets.all(
                                                                  widget.size *
                                                                      2),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          widget.size *
                                                                              22),
                                                                  color: Colors
                                                                      .black,
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .white38,
                                                                      width:
                                                                          0.5,
                                                                      style: BorderStyle
                                                                          .solid)),
                                                              child: SizedBox(
                                                                  height:
                                                                      widget.size *
                                                                          60,
                                                                  width:
                                                                      widget.size *
                                                                          80,
                                                                  child: ClipRRect(
                                                                      borderRadius: BorderRadius.circular(widget.size * 20),
                                                                      child: ImageShowAndDownload(
                                                                        image: BranchNew
                                                                            .photoUrl,
                                                                        isZoom:
                                                                            true,
                                                                      )))),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: widget
                                                                            .size *
                                                                        3.0),
                                                            child: Text(
                                                              BranchNew.heading
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      widget.size *
                                                                          15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontFamily:
                                                                      "test"),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                          }
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: widget.size * 10.0,
                              right: widget.size * 10,
                              bottom: widget.size * 10,
                              top: widget.size * 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Based on Regulation",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.size * 20),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        changeTab(1);
                                      },
                                      child: Text(
                                        "Sub ",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: widget.size * 16,
                                            fontWeight: FontWeight.w600),
                                      )),
                                  InkWell(
                                      onTap: () {
                                        changeTab(2);
                                      },
                                      child: Text(
                                        " Lab",
                                        style: TextStyle(
                                            color: Colors.white60,
                                            fontSize: widget.size * 16,
                                            fontWeight: FontWeight.w600),
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                        StreamBuilder<List<subjectsConvertor>>(
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
                                          .where((item) => item.regulation
                                              .toString()
                                              .startsWith(widget.reg))
                                          .toList();
                                      return Center(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.all(widget.size * 15),
                                          child: filteredItems.isNotEmpty
                                              ? GridView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisSpacing:
                                                        widget.size * 5,
                                                    mainAxisSpacing:
                                                        widget.size * 5,
                                                    childAspectRatio:
                                                        (widget.size * 5) /
                                                            (widget.size * 3.5),
                                                    crossAxisCount: 4,
                                                  ),
                                                  itemCount:
                                                      filteredItems.length,
                                                  itemBuilder:
                                                      (context, int index) {
                                                    final itemData =
                                                        filteredItems[index];
                                                    final isFlashConvertor =
                                                        subData!
                                                            .contains(itemData);

                                                    return InkWell(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(widget
                                                                        .size *
                                                                    25),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        widget.size *
                                                                            15),

                                                            color: isFlashConvertor
                                                                ? Colors.white54
                                                                : Colors
                                                                    .white24, // Change the color here
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              itemData.heading
                                                                  .split(";")
                                                                  .first,
                                                              style: TextStyle(
                                                                color: isFlashConvertor
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white,
                                                                // Change the text color here
                                                                fontSize: widget
                                                                        .size *
                                                                    25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                                const Duration(
                                                                    milliseconds:
                                                                        300),
                                                            pageBuilder: (context,
                                                                    animation,
                                                                    secondaryAnimation) =>
                                                                subjectUnitsData(
                                                              syllabusModelPaper:
                                                                  syllabusModelPaper,
                                                              size: widget.size,
                                                              branch:
                                                                  widget.branch,
                                                              mode:
                                                                  isFlashConvertor
                                                                      ? true
                                                                      : false,
                                                              data: itemData,
                                                              reg: widget.reg,
                                                            ),
                                                            transitionsBuilder:
                                                                (context,
                                                                    animation,
                                                                    secondaryAnimation,
                                                                    child) {
                                                              final fadeTransition =
                                                                  FadeTransition(
                                                                opacity:
                                                                    animation,
                                                                child: child,
                                                              );

                                                              return Container(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        animation
                                                                            .value),
                                                                child:
                                                                    AnimatedOpacity(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          300),
                                                                  opacity: animation
                                                                      .value
                                                                      .clamp(
                                                                          0.3,
                                                                          1.0),
                                                                  child:
                                                                      fadeTransition,
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
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.library_books,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(
                                                      height: Size * 10,
                                                    ),
                                                    Text(
                                                      "No Subjects",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: Size * 20),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      );
                                    }
                                }
                              },
                            );
                          },
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: widget.size * 10,
                                vertical: widget.size * 5),
                            margin: EdgeInsets.symmetric(
                                vertical: widget.size * 2,
                                horizontal: widget.size * 15),
                            decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius:
                                    BorderRadius.circular(widget.size * 10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.favorite_border,
                                      color: Colors.white70,
                                      size: widget.size * 30,
                                    ),
                                    Text(
                                      "   Favorite",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: widget.size * 25,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  size: widget.size * 30,
                                  color: Colors.white54,
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   PageRouteBuilder(
                            //     transitionDuration: const Duration(milliseconds: 300),
                            //     pageBuilder: (context, animation, secondaryAnimation) =>
                            //         favorites(
                            //           size: widget.size,
                            //         ),
                            //     transitionsBuilder:
                            //         (context, animation, secondaryAnimation, child) {
                            //       final fadeTransition = FadeTransition(
                            //         opacity: animation,
                            //         child: child,
                            //       );
                            //
                            //       return Container(
                            //         color: Colors.black.withOpacity(animation.value),
                            //         child: AnimatedOpacity(
                            //             duration: Duration(milliseconds: 300),
                            //             opacity: animation.value.clamp(0.3, 1.0),
                            //             child: fadeTransition),
                            //       );
                            //     },
                            //   ),
                            // );
                          },
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10, top: 30, bottom: 10),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SyllabusAndModelPapers(
                                                data: syllabusModelPaper,
                                                reg: widget.reg,
                                                branch: widget.branch,
                                                size: widget.size,
                                              )));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Syllabus & Model Paper",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            ListView.builder(
                                itemCount: syllabusModelPaper.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final data = syllabusModelPaper[index];
                                  if (data.id.startsWith(
                                      widget.reg.substring(0, 10))) {
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

                                  return data.id.startsWith(
                                              widget.reg.substring(0, 10)) &&
                                          data.modelPaper.isNotEmpty &&
                                          data.syllabus.isNotEmpty
                                      ? Row(
                                          children: [
                                            Flexible(
                                                child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Container(
                                                            height: 80,
                                                            color:
                                                                Colors.white12,
                                                            child: File("${folderPath}/pdfs/${getFileName(data.syllabus)}")
                                                                    .existsSync()
                                                                ? PDFView(
                                                                    filePath:
                                                                        "${folderPath}/pdfs/${getFileName(data.syllabus)}",
                                                                  )
                                                                : Container()),
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => PdfViewerPage(
                                                                        size: widget
                                                                            .size,
                                                                        pdfUrl:
                                                                            "${folderPath}/pdfs/${getFileName(data.syllabus)}")));
                                                          },
                                                          child: Container(
                                                            height: 80,
                                                            width:
                                                                double.infinity,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 5.0),
                                                    child: Text(
                                                      "Syllabus Paper ( ${widget.reg.substring(0, 10)} )",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                            Flexible(
                                                child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Container(
                                                            height: 80,
                                                            color:
                                                                Colors.white12,
                                                            child: File("${folderPath}/pdfs/${getFileName(data.modelPaper)}")
                                                                    .existsSync()
                                                                ? PDFView(
                                                                    filePath:
                                                                        "${folderPath}/pdfs/${getFileName(data.modelPaper)}",
                                                                  )
                                                                : Container()),
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => PdfViewerPage(
                                                                        size: widget
                                                                            .size,
                                                                        pdfUrl:
                                                                            "${folderPath}/pdfs/${getFileName(data.modelPaper)}")));
                                                          },
                                                          child: Container(
                                                            height: 80,
                                                            width:
                                                                double.infinity,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 5.0),
                                                    child: Text(
                                                      "Model Paper ( ${widget.reg.substring(0, 10)} )",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                          ],
                                        )
                                      : Container();
                                }),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(
                            child: InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.09),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 25),
                                  child: Text(
                                    "Exam Notification",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                ),
                              ),
                              onTap: () {
                                ExternalLaunchUrl(
                                    "http://www.srkrexams.in/Login.aspx");
                              },
                            ),
                          ),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    widget.size * 8.0),
                                                child: Text(
                                                  "Flash News",
                                                  style: secondHeadingTextStyle(
                                                      color: Colors.white,
                                                      size: widget.size),
                                                ),
                                              ),
                                              CarouselSlider(
                                                  items: List.generate(
                                                      Favourites.length,
                                                      (int index) {
                                                    final BranchNew =
                                                        Favourites[index];

                                                    return Row(
                                                      children: [
                                                        Expanded(
                                                          child: InkWell(
                                                            child: Padding(
                                                              padding: EdgeInsets.only(
                                                                  left: widget
                                                                          .size *
                                                                      20),
                                                              child: Text(
                                                                BranchNew
                                                                    .heading,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily:
                                                                        "test",
                                                                    fontSize:
                                                                        widget.size *
                                                                            16),
                                                                maxLines: 3,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              if (BranchNew.Url
                                                                  .isNotEmpty) {
                                                                ExternalLaunchUrl(
                                                                    BranchNew
                                                                        .Url);
                                                              } else {
                                                                showToastText(
                                                                    "No Url Found");
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                        if (isGmail())
                                                          PopupMenuButton(
                                                            icon: Icon(
                                                              Icons.more_vert,
                                                              color:
                                                                  Colors.white,
                                                              size:
                                                                  widget.size *
                                                                      25,
                                                            ),
                                                            // Callback that sets the selected popup menu item.
                                                            onSelected: (item) {
                                                              if (item ==
                                                                  "edit") {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            flashNewsCreator(
                                                                              branch: widget.branch,
                                                                              size: widget.size,
                                                                              heading: BranchNew.heading,
                                                                              link: BranchNew.Url,
                                                                              NewsId: BranchNew.id,
                                                                            )));
                                                              } else if (item ==
                                                                  "delete") {
                                                                messageToOwner(
                                                                    "Flash News is Deleted\nBy : '${fullUserId()}' \n   Heading : ${BranchNew.heading}\n   Link : ${BranchNew.Url}");

                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "srkrPage")
                                                                    .doc(
                                                                        "flashNews")
                                                                    .collection(
                                                                        "flashNews")
                                                                    .doc(
                                                                        BranchNew
                                                                            .id)
                                                                    .delete();
                                                              }
                                                            },
                                                            itemBuilder: (BuildContext
                                                                    context) =>
                                                                <PopupMenuEntry>[
                                                              const PopupMenuItem(
                                                                value: "edit",
                                                                child: Text(
                                                                    'Edit'),
                                                              ),
                                                              const PopupMenuItem(
                                                                value: "delete",
                                                                child: Text(
                                                                    'Delete'),
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
                                                    autoPlayAnimationDuration:
                                                        Duration(
                                                            milliseconds: 1800),
                                                    autoPlay:
                                                        Favourites.length > 1
                                                            ? true
                                                            : false,
                                                  )),
                                            ],
                                          )
                                        : Container();
                                  }
                              }
                            }),
                        SizedBox(
                          height: widget.size * 50,
                        )
                      ],
                    ),
                  ),
                  Subjects(
                    syllabusModelPaper: syllabusModelPaper,
                    branch: widget.branch,
                    reg: widget.reg,
                    width: widget.size,
                    height: widget.size,
                    size: widget.size,
                  ),
                  LabSubjects(
                    syllabusModelPaper: syllabusModelPaper,
                    branch: widget.branch,
                    reg: widget.reg,
                    size: widget.size,
                  ),
                  allBooks(
                    size: widget.size,
                    branch: widget.branch,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

Future createRegulationSem(
    {required String name, required String branch}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc("regulation")
      .collection("regulationWithSem")
      .doc(name);
  final flash = RegulationConvertor(id: name);
  final json = flash.toJson();
  await docflash.set(json);
}

Stream<List<syllabusConvertor>> readsyllabus({required String branch}) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("regulation")
        .collection("regulationWithYears")
        .orderBy("id", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => syllabusConvertor.fromJson(doc.data()))
            .toList());

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

class syllabusConvertor {
  String id;
  String syllabus;
  String modelPaper;

  syllabusConvertor(
      {this.id = "", required this.syllabus, required this.modelPaper});

  Map<String, dynamic> toJson() => {
        "id": id,
        "syllabus": syllabus,
        "modelPaper": modelPaper,
      };

  static syllabusConvertor fromJson(Map<String, dynamic> json) =>
      syllabusConvertor(
        id: json['id'],
        syllabus: json['syllabus'],
        modelPaper: json['modelPaper'],
      );
}

Stream<List<TimeTableConvertor>> readTimeTable(
        {required String reg, required String branch}) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("regulation")
        .collection("regulationWithSem")
        .doc(reg)
        .collection("timeTables")
        .orderBy("heading", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TimeTableConvertor.fromJson(doc.data()))
            .toList());

Future createTimeTable(
    {required String branch,
    required String heading,
    required String photoUrl,
    required String reg}) async {
  String id = getID();
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc("regulation")
      .collection("regulationWithSem")
      .doc(reg)
      .collection("timeTables")
      .doc(id);
  final flash =
      TimeTableConvertor(id: id, heading: heading, photoUrl: photoUrl);
  final json = flash.toJson();
  await docflash.set(json);
}

class TimeTableConvertor {
  String id;
  final String heading, photoUrl;

  TimeTableConvertor(
      {this.id = "", required this.heading, required this.photoUrl});

  Map<String, dynamic> toJson() =>
      {"id": id, "heading": heading, "image": photoUrl};

  static TimeTableConvertor fromJson(Map<String, dynamic> json) =>
      TimeTableConvertor(
          id: json['id'], heading: json["heading"], photoUrl: json['image']);
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

Future createSubjects(
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
  final flash = subjectsConvertor(
      id: getID(),
      heading: heading,
      description: description,
      regulation: regulation,
      creator: creator);
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

Stream<List<subjectsConvertor>> readFlashNews(String branch) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("Subjects")
        .collection("Subjects")
        .orderBy("heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => subjectsConvertor.fromJson(doc.data()))
            .toList());

class subjectsConvertor {
  String id;
  final String heading, description, regulation, creator;

  subjectsConvertor(
      {this.id = "",
      required this.regulation,
      required this.heading,
      required this.description,
      required this.creator});

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "description": description,
        "regulation": regulation,
        "creator": creator
      };

  static subjectsConvertor fromJson(Map<String, dynamic> json) =>
      subjectsConvertor(
          id: json['id'],
          regulation: json["regulation"] ?? "",
          heading: json["heading"] ?? "",
          description: json["description"] ?? "",
          creator: json["creator"] ?? "");
}

Stream<List<subjectsConvertor>> readLabSubjects(String branch) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("LabSubjects")
        .collection("LabSubjects")
        .orderBy("heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => subjectsConvertor.fromJson(doc.data()))
            .toList());

Future createLabSubjects(
    {required String branch,
    required String heading,
    required String description,
    required String creator,
    required String regulation}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc("LabSubjects")
      .collection("LabSubjects")
      .doc(getID());
  final flash = subjectsConvertor(
      id: getID(),
      heading: heading,
      description: description,
      regulation: regulation,
      creator: creator);
  final json = flash.toJson();
  await docflash.set(json);
}

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
    "id":id,
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
  Color active = Colors.blueGrey.withOpacity(0.3);
  Color inActive = Colors.black54;

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
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.white12),
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
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                            child: Text(
                          "${widget.units}",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )),
                      ),
                      Expanded(
                          child: Text(
                        widget.isSub ? tabBarIndex[0] : "Records & Manuals",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
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
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                              child: Text(
                            "${widget.oldPapers}",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )),
                        ),
                        Expanded(
                            child: Text(
                          tabBarIndex[1],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
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
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                            child: Text(
                          "${widget.question}",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )),
                      ),
                      Expanded(
                          child: Text(
                        widget.isSub ? tabBarIndex[2] : "Description",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.isSub ? 13 : 20,
                            fontWeight: FontWeight.w500),
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
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                            child: Text(
                          "${widget.moreInfo}",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )),
                      ),
                      Expanded(
                          child: Text(
                        tabBarIndex[3],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
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
