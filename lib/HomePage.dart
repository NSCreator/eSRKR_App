// ignore_for_file: must_be_immutable, unnecessary_import
import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
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

class backGroundImage extends StatefulWidget {
  Widget child;

  backGroundImage({required this.child});

  @override
  State<backGroundImage> createState() => _backGroundImageState();
}

class _backGroundImageState extends State<backGroundImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/home.jpg"), fit: BoxFit.fill)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.85),
          body: SafeArea(
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String branch;
  final String reg;
  final int index;
  final double size;

  const HomePage({
    Key? key,
    required this.branch,
    required this.reg,
    required this.index,
    required this.size,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List searchList = ["Search About", "Subjects", "Lab Subjects"];

  late TabController _tabController;
  String folderPath = "";
  int index = 0;

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
    });
  }

  @override
  void initState() {
    index = widget.index;
    setState(() {
      getPath();
    });
    _tabController = new TabController(
      vsync: this,
      length: 4,
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  void changeTab(int newIndex) {
    // Use _tabController.animateTo to change the selected tab
    _tabController.animateTo(newIndex);
  }

  reg() async {
    List list = [];

    final CollectionReference updates = FirebaseFirestore.instance
        .collection(widget.branch)
        .doc("Subjects")
        .collection("Subjects");

    try {
      final QuerySnapshot querySnapshot = await updates.get();
      if (querySnapshot.docs.isNotEmpty) {
        final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      } else {
        print('No documents found');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  bool visible = false;

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
      child: backGroundImage(
          child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: widget.size * 58,
            collapsedHeight: widget.size * 58,
            toolbarHeight: widget.size *58,
            backgroundColor: Colors.transparent,
            flexibleSpace: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widget.size * 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius:
                                      BorderRadius.circular(widget.size * 25),
                                  border: Border.all(color: Colors.white54),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(widget.size * 3.0),
                                  child: Icon(
                                    Icons.settings,
                                    color: Colors.white70,
                                    size: widget.size * 28,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: widget.size * 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      picText(""),
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: widget.size * 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      widget.branch,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: widget.size * 14,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 300),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        settings(
                                  size: widget.size,
                                  index: widget.index,
                                  reg: widget.reg,
                                  branch: widget.branch,
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
                          }),
                      SizedBox(
                        width: widget.size * 5,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 300),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        MyAppq(
                                            branch: widget.branch,
                                            reg: widget.reg,
                                            size: widget.size),
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
                            padding:  EdgeInsets.symmetric(horizontal: widget.size *10),
                            child: Container(
                              width: widget.size *210,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.white54),
                              ),
                              child: Padding(
                                padding:
                                     EdgeInsets.symmetric(horizontal: widget.size *5),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Colors.white,
                                      size: widget.size *25,
                                    ),
                                    SizedBox(width: widget.size *3),
                                    Flexible(
                                      child: CarouselSlider(
                                        items: List.generate(
                                          searchList.length,
                                          (int index) {
                                            return Center(
                                              child: Text(
                                                searchList[index],
                                                style: TextStyle(
                                                  fontSize: widget.size *19.0,
                                                  color: Color.fromRGBO(
                                                      192, 237, 252, 1),
                                                  fontWeight: FontWeight.w400,
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
                                          height: widget.size *40,
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
                      ),
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius:
                                BorderRadius.circular(widget.size * 25),
                            border: Border.all(color: Colors.white54),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(widget.size * 3.0),
                            child: Icon(
                              Icons.notifications_active,
                              color: Colors.white70,
                              size: widget.size * 28,
                            ),
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
                                      notifications(
                                width: widget.size,
                                size: widget.size,
                                height: widget.size,
                                branch: widget.branch,
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                final fadeTransition = FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );

                                return Container(
                                  color:
                                      Colors.black.withOpacity(animation.value),
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
                        width: widget.size * 5,
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Colors.white12,
                ),
              ],
            ),
            floating: false,
            primary: true,
          ),
        ],
        body: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    ExternalLaunchUrl("https://srkrec.edu.in/");
                    // changeTab(2);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "eSRKR",
                      style: TextStyle(
                          fontSize: widget.size * 30.0,
                          color: Color.fromRGBO(192, 237, 252, 1),
                          fontWeight: FontWeight.w700,
                          fontFamily: "test"),
                    ),
                  ),
                ),
                Expanded(
                    child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  labelPadding: EdgeInsets.symmetric(horizontal: 5.0),
                  // Adjust padding as needed
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.size * 15),
                    color: Color.fromRGBO(50, 50, 50, 1),
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
                        padding: EdgeInsets.symmetric(
                            horizontal: widget.size * 15.0),
                        // Adjust padding as needed
                        child: Text('Home'),
                      ),
                    ),
                    Tab(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: widget.size * 15.0),
                        // Adjust padding as needed

                        child: Text('Books'),
                      ),
                    ),
                    Tab(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: widget.size * 15.0),
                        // Adjust padding as needed

                        child: Text('News'),
                      ),
                    ),
                    Tab(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: widget.size * 15.0),
                        // Adjust padding as needed

                        child: Text('Updates'),
                      ),
                    ),
                  ],
                )),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        StreamBuilder<List<BranchNewConvertor>>(
                          stream: readBranchNew(widget.branch),
                          builder: (context, snapshot) {
                            final BranchNews = snapshot.data;
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 0.3,
                                    color: Colors.cyan,
                                  ),
                                );
                              default:
                                if (snapshot.hasError) {
                                  return const Center(
                                    child: Text(
                                        'Error with TextBooks Data or\n Check Internet Connection'),
                                  );
                                } else {
                                  final filteredNews =
                                      BranchNews?.take(3).toList() ?? [];

                                  if (filteredNews.isNotEmpty) {
                                    return SizedBox(
                                      height: 110,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: filteredNews.map((BranchNew) {
                                          if (BranchNew.photoUrl.isNotEmpty) {
                                            final Uri uri =
                                                Uri.parse(BranchNew.photoUrl);
                                            final String fileName =
                                                uri.pathSegments.last;
                                            var name = fileName.split("/").last;
                                            file = File(
                                                "${folderPath}/news/$name");
                                          }
                                          return InkWell(
                                            child: VisibilityDetector(
                                              key: Key("${widget.branch}News"), // Give a unique key to your widget
                                              onVisibilityChanged: (info) {
                                                if (info.visibleFraction == 1.0) {
                                                  FirebaseFirestore.instance
                                                      .collection(widget.branch)
                                                      .doc("${widget.branch}News")
                                                      .collection("${widget.branch}News")
                                                      .doc(BranchNew.id)
                                                      .update({
                                                    "isViewed": FieldValue.arrayUnion([fullUserId()])
                                                  });

                                              };
                                                },
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Container(
                                                  width: 320,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(15),
                                                      border: Border.all(
                                                          color: Colors.white12)),
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        flex:2,
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(child: BranchNew
                                                                      .heading.isNotEmpty?Text(
                                                                    " ${BranchNew.heading}",
                                                                    style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize:
                                                                      widget.size *
                                                                          16,
                                                                      fontWeight:
                                                                      FontWeight.w600,
                                                                    ),
                                                                  ):Text(
                                                                    " ${widget.branch} (SRKR)",
                                                                    style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize:
                                                                      widget.size *
                                                                          16,
                                                                      fontWeight:
                                                                      FontWeight.w400,
                                                                    ),
                                                                  )),

                                                                  if (isUser())
                                                                    PopupMenuButton(
                                                                      icon: Icon(
                                                                        Icons.more_vert,
                                                                        color: Colors.white,
                                                                        size: widget.size *
                                                                            16,
                                                                      ),
                                                                      // Callback that sets the selected popup menu item.
                                                                      onSelected:
                                                                          (item) async {
                                                                        if (item ==
                                                                            "edit") {
                                                                          Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder:
                                                                                  (context) =>
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
                                                                                    photoUrl:
                                                                                    BranchNew
                                                                                        .photoUrl,
                                                                                  ),
                                                                            ),
                                                                          );
                                                                        } else if (item ==
                                                                            "delete") {
                                                                          if (BranchNew
                                                                              .photoUrl
                                                                              .isNotEmpty) {
                                                                            final Uri uri =
                                                                            Uri.parse(
                                                                                BranchNew
                                                                                    .photoUrl);
                                                                            final String
                                                                            fileName =
                                                                                uri.pathSegments
                                                                                    .last;
                                                                            final Reference
                                                                            ref =
                                                                            FirebaseStorage
                                                                                .instance
                                                                                .ref()
                                                                                .child(
                                                                                "/${fileName}");
                                                                            try {
                                                                              await ref
                                                                                  .delete();
                                                                              showToastText(
                                                                                  'Image deleted successfully');
                                                                            } catch (e) {
                                                                              showToastText(
                                                                                  'Error deleting image: $e');
                                                                            }
                                                                          }
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection(
                                                                              widget
                                                                                  .branch)
                                                                              .doc(
                                                                              "${widget.branch}News")
                                                                              .collection(
                                                                              "${widget.branch}News")
                                                                              .doc(BranchNew
                                                                              .id)
                                                                              .delete();
                                                                          pushNotificationsSpecificPerson(
                                                                            fullUserId(),
                                                                            " ${BranchNew.heading} Deleted from News",
                                                                            "",
                                                                          );
                                                                        }
                                                                      },
                                                                      itemBuilder: (BuildContext
                                                                      context) =>
                                                                      <PopupMenuEntry>[
                                                                        const PopupMenuItem(
                                                                          value: "edit",
                                                                          child:
                                                                          Text('Edit'),
                                                                        ),
                                                                        const PopupMenuItem(
                                                                          value: "delete",
                                                                          child: Text(
                                                                              'Delete'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                ],
                                                              ),
                                                              if (BranchNew.description
                                                                  .isNotEmpty)
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets.symmetric(
                                                                          horizontal:widget.size *
                                                                              8),
                                                                  child:
                                                                      StyledTextWidget(
                                                                    text: BranchNew
                                                                        .description,
                                                                    fontSize:
                                                                        widget.size *
                                                                            12,
                                                                    fontWeight:
                                                                        FontWeight.w600,
                                                                        color: Colors.white.withOpacity(0.8),
                                                                  ),
                                                                ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets.only(
                                                                  left: widget.size * 8,
                                                                  bottom:
                                                                      widget.size * 8,
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      BranchNew.id
                                                                                  .split(
                                                                                      "-")
                                                                                  .first
                                                                                  .length <
                                                                              12
                                                                          ? "~ ${BranchNew.id.split('-').first}"
                                                                          : "No Date",
                                                                      style: TextStyle(
                                                                        color: Colors.white70,
                                                                        fontSize:
                                                                            widget.size *
                                                                                10,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(right: 20),
                                                                      child: Icon(BranchNew.isViewed.contains(fullUserId())?Icons.remove_red_eye:Icons.remove_red_eye_outlined,size: 14,color: Colors.white70,),
                                                                    ),

                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      if(BranchNew
                                                          .photoUrl.isNotEmpty)Flexible(
                                                        child:Image.file(file),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () async {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImageZoom(
                                                    size: widget.size,
                                                    url: "",
                                                    file: file,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  } else {
                                    return Container(); // No data, don't show anything
                                  }
                                }
                            }
                          },
                        ),
                        StreamBuilder<List<UpdateConvertor>>(
                          stream: readUpdate(widget.branch),
                          builder: (context, snapshot) {
                            final BranchNews = snapshot.data;
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 0.3,
                                    color: Colors.cyan,
                                  ),
                                );
                              default:
                                if (snapshot.hasError) {
                                  return const Center(
                                    child: Text(
                                        'Error with TextBooks Data or\n Check Internet Connection'),
                                  );
                                } else {
                                  final filteredNews =
                                      BranchNews?.take(3).toList() ?? [];

                                  if (filteredNews.isNotEmpty) {
                                    return SizedBox(
                                      height: 110,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: filteredNews.map((BranchNew) {
                                          if (BranchNew.photoUrl.isNotEmpty) {
                                            final Uri uri =
                                            Uri.parse(BranchNew.photoUrl);
                                            final String fileName =
                                                uri.pathSegments.last;
                                            var name = fileName.split("/").last;
                                            file = File(
                                                "${folderPath}/updates/$name");
                                          }
                                          return InkWell(
                                            child: VisibilityDetector(
                                              key: Key("update"), // Give a unique key to your widget
                                              onVisibilityChanged: (info) {
                                                if (info.visibleFraction == 1.0) {
                                                  FirebaseFirestore.instance
                                                      .collection("update")
                                                      .doc(BranchNew.id)
                                                      .update({
                                                    "isViewed": FieldValue.arrayUnion([fullUserId()])
                                                  });

                                                };
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Container(
                                                  width: 320,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(15),
                                                      border: Border.all(
                                                          color: Colors.white12)),
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        flex:2,
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(child: BranchNew
                                                                      .heading.isNotEmpty?Text(
                                                                    " ${BranchNew.heading}",
                                                                    style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize:
                                                                      widget.size *
                                                                          16,
                                                                      fontWeight:
                                                                      FontWeight.w600,
                                                                    ),
                                                                  ):Text(
                                                                    " ${widget.branch} (SRKR)",
                                                                    style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize:
                                                                      widget.size *
                                                                          16,
                                                                      fontWeight:
                                                                      FontWeight.w400,
                                                                    ),
                                                                  )),

                                                                  if (isUser())
                                                                    PopupMenuButton(
                                                                      icon: Icon(
                                                                        Icons.more_vert,
                                                                        color: Colors.white,
                                                                        size: widget.size *
                                                                            16,
                                                                      ),
                                                                      // Callback that sets the selected popup menu item.
                                                                      onSelected:
                                                                          (item) async {
                                                                        if (item ==
                                                                            "edit") {
                                                                          Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder:
                                                                                  (context) =>
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
                                                                                    photoUrl:
                                                                                    BranchNew
                                                                                        .photoUrl,
                                                                                  ),
                                                                            ),
                                                                          );
                                                                        } else if (item ==
                                                                            "delete") {
                                                                          if (BranchNew
                                                                              .photoUrl
                                                                              .isNotEmpty) {
                                                                            final Uri uri =
                                                                            Uri.parse(
                                                                                BranchNew
                                                                                    .photoUrl);
                                                                            final String
                                                                            fileName =
                                                                                uri.pathSegments
                                                                                    .last;
                                                                            final Reference
                                                                            ref =
                                                                            FirebaseStorage
                                                                                .instance
                                                                                .ref()
                                                                                .child(
                                                                                "/${fileName}");
                                                                            try {
                                                                              await ref
                                                                                  .delete();
                                                                              showToastText(
                                                                                  'Image deleted successfully');
                                                                            } catch (e) {
                                                                              showToastText(
                                                                                  'Error deleting image: $e');
                                                                            }
                                                                          }
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection(
                                                                              widget
                                                                                  .branch)
                                                                              .doc(
                                                                              "${widget.branch}News")
                                                                              .collection(
                                                                              "${widget.branch}News")
                                                                              .doc(BranchNew
                                                                              .id)
                                                                              .delete();
                                                                          pushNotificationsSpecificPerson(
                                                                            fullUserId(),
                                                                            " ${BranchNew.heading} Deleted from News",
                                                                            "",
                                                                          );
                                                                        }
                                                                      },
                                                                      itemBuilder: (BuildContext
                                                                      context) =>
                                                                      <PopupMenuEntry>[
                                                                        const PopupMenuItem(
                                                                          value: "edit",
                                                                          child:
                                                                          Text('Edit'),
                                                                        ),
                                                                        const PopupMenuItem(
                                                                          value: "delete",
                                                                          child: Text(
                                                                              'Delete'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                ],
                                                              ),
                                                              if (BranchNew.description
                                                                  .isNotEmpty)
                                                                Padding(
                                                                  padding:
                                                                  EdgeInsets.symmetric(
                                                                      horizontal:widget.size *
                                                                          8),
                                                                  child:
                                                                  StyledTextWidget(
                                                                    text: BranchNew
                                                                        .description,
                                                                    fontSize:
                                                                    widget.size *
                                                                        12,
                                                                    fontWeight:
                                                                    FontWeight.w600,
                                                                    color: Colors.white.withOpacity(0.8),
                                                                  ),
                                                                ),
                                                              Padding(
                                                                padding:
                                                                EdgeInsets.only(
                                                                  left: widget.size * 8,
                                                                  bottom:
                                                                  widget.size * 8,
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      BranchNew.id
                                                                          .split(
                                                                          "-")
                                                                          .first
                                                                          .length <
                                                                          12
                                                                          ? "~ ${BranchNew.id.split('-').first}"
                                                                          : "No Date",
                                                                      style: TextStyle(
                                                                        color: Colors.white70,
                                                                        fontSize:
                                                                        widget.size *
                                                                            10,
                                                                        fontWeight:
                                                                        FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(right: 20),
                                                                      child: Icon(BranchNew.isViewed.contains(fullUserId())?Icons.remove_red_eye:Icons.remove_red_eye_outlined,size: 14,color: Colors.white70,),
                                                                    ),

                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      if(BranchNew
                                                          .photoUrl.length>3)Flexible(
                                                        child:Image.file(file),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () async {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImageZoom(
                                                        size: widget.size,
                                                        url: "",
                                                        file: file,
                                                      ),
                                                ),
                                              );
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  } else {
                                    return Container(); // No data, don't show anything
                                  }
                                }
                            }
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
                                    return Favourites!.isNotEmpty?
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.all(widget.size * 8.0),
                                          child: Text(
                                            "Flash News",
                                            style: secondHeadingTextStyle(
                                                color: Colors.grey,
                                                size: widget.size),
                                          ),
                                        ),
                                        CarouselSlider(
                                            items: List.generate(
                                                Favourites!.length,
                                                (int index) {
                                              final BranchNew =
                                                  Favourites[index];

                                              return Row(
                                                children: [
                                                  Expanded(
                                                    child: InkWell(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: widget
                                                                        .size *
                                                                    20),
                                                        child: Text(
                                                          BranchNew.heading,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  "test",
                                                              fontSize:
                                                                  widget.size *
                                                                      16),
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        if (BranchNew
                                                            .Url.isNotEmpty) {
                                                          ExternalLaunchUrl(
                                                              BranchNew.Url);
                                                        } else {
                                                          showToastText(
                                                              "No Url Found");
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  if (isUser())
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
                                                                  builder:
                                                                      (context) =>
                                                                          flashNewsCreator(
                                                                            size:
                                                                                widget.size,
                                                                            heading:
                                                                                BranchNew.heading,
                                                                            link:
                                                                                BranchNew.Url,
                                                                            NewsId:
                                                                                BranchNew.id,
                                                                          )));
                                                        } else if (item ==
                                                            "delete") {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "srkrPage")
                                                              .doc("flashNews")
                                                              .collection(
                                                                  "flashNews")
                                                              .doc(BranchNew.id)
                                                              .delete();
                                                        }
                                                      },
                                                      itemBuilder: (BuildContext
                                                              context) =>
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
                                                ],
                                              );
                                            }),
                                            options: CarouselOptions(
                                              viewportFraction: 1,
                                              enlargeCenterPage: true,
                                              height: widget.size * 60,
                                              autoPlayAnimationDuration:
                                                  Duration(milliseconds: 1800),
                                              autoPlay: Favourites.length > 1
                                                  ? true
                                                  : false,
                                            )),
                                      ],
                                    ):
                                    Container();
                                  }
                              }
                            }),
                        Row(
                          children: [
                            Flexible(
                              flex: 4,
                              child: Padding(
                                padding: EdgeInsets.all(widget.size * 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white24,
                                      borderRadius: BorderRadius.circular(
                                          widget.size * 30)),
                                  child: Padding(
                                    padding: EdgeInsets.all(widget.size * 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        StreamBuilder<List<FlashConvertor>>(
                                          stream: readFlashNews(widget.branch),
                                          builder: (context, flashSnapshot) {
                                            final flashData =
                                                flashSnapshot.data;

                                            return StreamBuilder<
                                                List<LabSubjectsConvertor>>(
                                              stream: readLabSubjects(
                                                  widget.branch),
                                              builder: (context, labSnapshot) {
                                                final labData =
                                                    labSnapshot.data;

                                                final combinedData =
                                                    <dynamic>[];
                                                if (flashData != null) {
                                                  combinedData
                                                      .addAll(flashData);
                                                }
                                                if (labData != null) {
                                                  combinedData.addAll(labData);
                                                }

                                                switch (labSnapshot
                                                    .connectionState) {
                                                  case ConnectionState.waiting:
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 0.3,
                                                        color: Colors.cyan,
                                                      ),
                                                    );
                                                  default:
                                                    if (labSnapshot.hasError) {
                                                      return Center(
                                                          child: Text("Error"));
                                                    } else {
                                                      List<dynamic>
                                                          filteredItems =
                                                          combinedData
                                                              .where((item) => item
                                                                  .regulation
                                                                  .toString()
                                                                  .startsWith(
                                                                      widget.reg ??
                                                                          ""))
                                                              .toList();

                                                      if (filteredItems
                                                          .isNotEmpty) {
                                                        return GridView.builder(
                                                          shrinkWrap: true,
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisSpacing:
                                                                widget.size *
                                                                    15,
                                                            childAspectRatio:
                                                                5 / 4,
                                                            crossAxisCount: 4,
                                                          ),
                                                          itemCount:
                                                              filteredItems
                                                                  .length,
                                                          itemBuilder: (context,
                                                              int index) {
                                                            final itemData =
                                                                filteredItems[
                                                                    index];
                                                            final isFlashConvertor =
                                                                itemData
                                                                    is FlashConvertor;

                                                            return InkWell(
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          widget.size *
                                                                              25),
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .white30),
                                                                  color: isFlashConvertor
                                                                      ? Colors
                                                                          .black
                                                                      : Colors
                                                                          .white, // Change the color here
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                    vertical:
                                                                        widget.size *
                                                                            5,
                                                                    horizontal:
                                                                        widget.size *
                                                                            8,
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      itemData
                                                                          .heading
                                                                          .split(
                                                                              ";")
                                                                          .first,
                                                                      style:
                                                                          TextStyle(
                                                                        color: isFlashConvertor
                                                                            ? Colors.purpleAccent
                                                                            : Colors.purpleAccent,
                                                                        // Change the text color here
                                                                        fontSize:
                                                                            widget.size *
                                                                                18,
                                                                        fontWeight:
                                                                            FontWeight.w500,
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
                                                                      reg: itemData
                                                                          .regulation,
                                                                      size: widget
                                                                          .size,
                                                                      branch: widget
                                                                          .branch,
                                                                      ID: itemData
                                                                          .id,
                                                                      mode: isFlashConvertor
                                                                          ? "Subjects"
                                                                          : "LabSubjects",
                                                                      name: itemData
                                                                          .heading,
                                                                      description:
                                                                          itemData
                                                                              .description,
                                                                    ),
                                                                    transitionsBuilder: (context,
                                                                        animation,
                                                                        secondaryAnimation,
                                                                        child) {
                                                                      final fadeTransition =
                                                                          FadeTransition(
                                                                        opacity:
                                                                            animation,
                                                                        child:
                                                                            child,
                                                                      );

                                                                      return Container(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(animation.value),
                                                                        child:
                                                                            AnimatedOpacity(
                                                                          duration:
                                                                              Duration(milliseconds: 300),
                                                                          opacity: animation.value.clamp(
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
                                                        );
                                                      } else {
                                                        return Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .tealAccent),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        widget.size *
                                                                            20),
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .all(widget
                                                                        .size *
                                                                    8.0),
                                                            child: Text(
                                                              "No Subjects in this Regulation",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        child: Container(
                                          height: widget.size * 55,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                widget.size * 20),
                                            color:
                                                Colors.white.withOpacity(0.2),
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
                                              transitionDuration:
                                                  const Duration(
                                                      milliseconds: 300),
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  Subjects(
                                                branch: widget.branch,
                                                reg: widget.reg,
                                                width: widget.size,
                                                height: widget.size,
                                                size: widget.size,
                                              ),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                final fadeTransition =
                                                    FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                );

                                                return Container(
                                                  color: Colors.black
                                                      .withOpacity(
                                                          animation.value),
                                                  child: AnimatedOpacity(
                                                      duration: Duration(
                                                          milliseconds: 300),
                                                      opacity: animation.value
                                                          .clamp(0.3, 1.0),
                                                      child: fadeTransition),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        child: Container(
                                          height: widget.size * 55,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                widget.size * 20),
                                            color:
                                                Colors.white.withOpacity(0.2),
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
                                              transitionDuration:
                                                  const Duration(
                                                      milliseconds: 300),
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  LabSubjects(
                                                branch: widget.branch,
                                                reg: widget.reg,
                                                width: widget.size,
                                                height: widget.size,
                                                size: widget.size,
                                              ),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                final fadeTransition =
                                                    FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                );

                                                return Container(
                                                  color: Colors.black
                                                      .withOpacity(
                                                          animation.value),
                                                  child: AnimatedOpacity(
                                                      duration: Duration(
                                                          milliseconds: 300),
                                                      opacity: animation.value
                                                          .clamp(0.3, 1.0),
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
                          padding: EdgeInsets.all(widget.size * 8.0),
                          child: Padding(
                            padding: EdgeInsets.only(top: widget.size * 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          widget.size * 15),
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Time\nTable",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: widget.size * 20,
                                              fontWeight: FontWeight.bold),
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
                                InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          widget.size * 15),
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Syllabus",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: widget.size * 20,
                                              fontWeight: FontWeight.bold),
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
                                            syllabusPage(
                                          branch: widget.branch,
                                          reg: widget.reg,
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
                                InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          widget.size * 15),
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Model\nPaper",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: widget.size * 20,
                                              fontWeight: FontWeight.bold),
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
                                            ModalPapersPage(
                                          branch: widget.branch,
                                          reg: widget.reg,
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
                                InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          widget.size * 15),
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Books",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: widget.size * 20,
                                              fontWeight: FontWeight.bold),
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
                                            backGroundImage(
                                          child: Column(
                                            children: [
                                              backButton(
                                                size: widget.size,
                                                text: "Books",
                                                child: SizedBox(
                                                  width: 45,
                                                ),
                                              ),
                                              allBooks(
                                                size: widget.size,
                                                branch: widget.branch,
                                              ),
                                            ],
                                          ),
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
                                )
                              ],
                            ),
                          ),
                        ),
                        StreamBuilder<List<FavouriteSubjectsConvertor>>(
                          stream: readFavouriteSubjects(),
                          builder: (context, snapshot1) {
                            final favourites1 = snapshot1.data;

                            return StreamBuilder<
                                List<FavouriteLabSubjectsConvertor>>(
                              stream: readFavouriteLabSubjects(),
                              builder: (context, snapshot2) {
                                final favourites2 = snapshot2.data;

                                if (snapshot1.connectionState ==
                                        ConnectionState.waiting ||
                                    snapshot2.connectionState ==
                                        ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 0.3,
                                      color: Colors.cyan,
                                    ),
                                  );
                                } else if (snapshot1.hasError ||
                                    snapshot2.hasError) {
                                  return Center(child: Text("Error"));
                                } else if ((favourites1 != null &&
                                        favourites1.isNotEmpty) ||
                                    (favourites2 != null &&
                                        favourites2.isNotEmpty)) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: widget.size * 5,
                                          horizontal: widget.size * 10,
                                        ),
                                        child: Text(
                                          "Short Cut",
                                          style: secondHeadingTextStyle(
                                              size: widget.size),
                                        ),
                                      ),
                                      if (favourites1 != null &&
                                          favourites1.isNotEmpty)
                                        SizedBox(
                                          height: widget.size * 70,
                                          child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: favourites1.length,
                                              itemBuilder:
                                                  (context, int index) {
                                                final Favourite =
                                                    favourites1[index];
                                                return InkWell(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: index == 0
                                                            ? widget.size * 20
                                                            : 0),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 10.0,
                                                                  right: 9),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white12,
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(
                                                                      widget.size *
                                                                          20))),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        25),
                                                            child: Text(
                                                              Favourite.name
                                                                  .split(";")
                                                                  .first,
                                                              style: TextStyle(
                                                                fontSize: widget
                                                                        .size *
                                                                    22.0,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 0,
                                                          right: 0,
                                                          child: InkWell(
                                                            child: Icon(
                                                              Icons
                                                                  .highlight_remove_outlined,
                                                              color:
                                                                  Colors.orange,
                                                              size:
                                                                  widget.size *
                                                                      25,
                                                            ),
                                                            onTap: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return Dialog(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(widget.size *
                                                                                20)),
                                                                    elevation:
                                                                        16,
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border.all(
                                                                            color:
                                                                                Colors.white54),
                                                                        borderRadius:
                                                                            BorderRadius.circular(widget.size *
                                                                                20),
                                                                      ),
                                                                      child:
                                                                          ListView(
                                                                        shrinkWrap:
                                                                            true,
                                                                        children: <Widget>[
                                                                          SizedBox(
                                                                              height: widget.size * 10),
                                                                          SizedBox(
                                                                              height: widget.size * 5),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: widget.size * 15),
                                                                            child:
                                                                                Text(
                                                                              "Do you want Remove from Favourites",
                                                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: widget.size * 20),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                widget.size * 5,
                                                                          ),
                                                                          Center(
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Spacer(),
                                                                                InkWell(
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.white24,
                                                                                      border: Border.all(color: Colors.white10),
                                                                                      borderRadius: BorderRadius.circular(widget.size * 25),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.only(left: widget.size * 15, right: widget.size * 15, top: widget.size * 5, bottom: widget.size * 5),
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
                                                                                      border: Border.all(color: Colors.black),
                                                                                      borderRadius: BorderRadius.circular(widget.size * 25),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.only(left: widget.size * 15, right: widget.size * 15, top: widget.size * 5, bottom: widget.size * 5),
                                                                                      child: Text(
                                                                                        "Delete",
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  onTap: () {
                                                                                    FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.email!).collection("FavouriteSubject").doc(Favourite.id).delete();
                                                                                    Navigator.pop(context);
                                                                                    showToastText("${Favourite.name} as been removed");
                                                                                  },
                                                                                ),
                                                                                SizedBox(
                                                                                  width: widget.size * 20,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                widget.size * 10,
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
                                                            builder: (context) =>
                                                                subjectUnitsData(
                                                                  reg: Favourite
                                                                      .name,
                                                                  size: widget
                                                                      .size,
                                                                  branch:
                                                                      Favourite
                                                                          .branch,
                                                                  ID: Favourite
                                                                      .subjectId,
                                                                  mode:
                                                                      "Subjects",
                                                                  name:
                                                                      Favourite
                                                                          .name,
                                                                  description:
                                                                      Favourite
                                                                          .description,
                                                                )));
                                                  },
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) => SizedBox(
                                                        width: widget.size * 6,
                                                      )),
                                        ),
                                      if (favourites2 != null &&
                                          favourites2.isNotEmpty)
                                        SizedBox(
                                          height: widget.size * 70,
                                          child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: favourites2.length,
                                              itemBuilder:
                                                  (context, int index) {
                                                final Favourite =
                                                    favourites2[index];
                                                return InkWell(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: index == 0
                                                            ? widget.size * 20
                                                            : 0),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 10.0,
                                                                  right: 9),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white12,
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(
                                                                      widget.size *
                                                                          20))),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        25),
                                                            child: Text(
                                                              Favourite.name
                                                                  .split(";")
                                                                  .first,
                                                              style: TextStyle(
                                                                fontSize: widget
                                                                        .size *
                                                                    22.0,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 0,
                                                          right: 0,
                                                          child: InkWell(
                                                            child: Icon(
                                                              Icons
                                                                  .highlight_remove_outlined,
                                                              color:
                                                                  Colors.orange,
                                                              size:
                                                                  widget.size *
                                                                      25,
                                                            ),
                                                            onTap: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return Dialog(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(widget.size *
                                                                                20)),
                                                                    elevation:
                                                                        16,
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border.all(
                                                                            color:
                                                                                Colors.white54),
                                                                        borderRadius:
                                                                            BorderRadius.circular(widget.size *
                                                                                20),
                                                                      ),
                                                                      child:
                                                                          ListView(
                                                                        shrinkWrap:
                                                                            true,
                                                                        children: <Widget>[
                                                                          SizedBox(
                                                                              height: widget.size * 10),
                                                                          SizedBox(
                                                                              height: widget.size * 5),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: widget.size * 15),
                                                                            child:
                                                                                Text(
                                                                              "Do you want Remove from Favourites",
                                                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: widget.size * 20),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                widget.size * 5,
                                                                          ),
                                                                          Center(
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Spacer(),
                                                                                InkWell(
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.white24,
                                                                                      border: Border.all(color: Colors.white10),
                                                                                      borderRadius: BorderRadius.circular(widget.size * 25),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.only(left: widget.size * 15, right: widget.size * 15, top: widget.size * 5, bottom: widget.size * 5),
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
                                                                                      border: Border.all(color: Colors.black),
                                                                                      borderRadius: BorderRadius.circular(widget.size * 25),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.only(left: widget.size * 15, right: widget.size * 15, top: widget.size * 5, bottom: widget.size * 5),
                                                                                      child: Text(
                                                                                        "Delete",
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  onTap: () {
                                                                                    FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.email!).collection("FavouriteLabSubjects").doc(Favourite.id).delete();
                                                                                    Navigator.pop(context);
                                                                                    showToastText("${Favourite.name} as been removed");
                                                                                  },
                                                                                ),
                                                                                SizedBox(
                                                                                  width: widget.size * 20,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                widget.size * 10,
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
                                                            builder: (context) =>
                                                                subjectUnitsData(
                                                                  reg: Favourite
                                                                      .name,
                                                                  size: widget
                                                                      .size,
                                                                  branch:
                                                                      Favourite
                                                                          .branch,
                                                                  ID: Favourite
                                                                      .subjectId,
                                                                  mode:
                                                                      "LabSubjects",
                                                                  name:
                                                                      Favourite
                                                                          .name,
                                                                  description:
                                                                      Favourite
                                                                          .description,
                                                                )));
                                                  },
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) => SizedBox(
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          child: InkWell(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Size * 20))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Text To Speech",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
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
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius:
                                    BorderRadius.circular(widget.size * 40)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: widget.size * 6,
                                  horizontal: widget.size * 20),
                              child: Text(
                                "Exam Notification",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.size * 30),
                              ),
                            ),
                          ),
                          onTap: () {
                            ExternalLaunchUrl(
                                "http://www.srkrexams.in/Login.aspx");
                          },
                        ),
                        SizedBox(
                          height: widget.size * 150,
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
      )),
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
  required link,
  required String branch,
  required String description,
}) async {
  final docflash = FirebaseFirestore.instance.collection("update").doc(id);

  final flash = UpdateConvertor(
      id: id,
      heading: heading,
      branch: branch,
      description: description,
      photoUrl: photoUrl,
      link: link);
  final json = flash.toJson();
  await docflash.set(json);
}

class UpdateConvertor {
  String id;
  final String heading, photoUrl, link, description, branch;
  List<String> likedBy,isViewed;
  UpdateConvertor({
    this.id = "",
    required this.heading,
    required this.photoUrl,
    required this.link,
    required this.branch,
    required this.description,
    List<String>? likedBy,
    List<String>? isViewed,
  }): likedBy = likedBy ?? [], isViewed = isViewed ?? [];

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "image": photoUrl,
        "link": link,
        "description": description,
        "branch": branch,
      };

  static UpdateConvertor fromJson(Map<String, dynamic> json) => UpdateConvertor(
        id: json['id'],
        heading: json["heading"],
        photoUrl: json["image"],
        link: json["link"],
        description: json["description"],
        branch: json["branch"],
    likedBy:
    json["likedBy"] != null ? List<String>.from(json["likedBy"]) : [],
    isViewed:
    json["isViewed"] != null ? List<String>.from(json["isViewed"]) : [],
      );
}

Future createRegulationYear(
    {required String name, required String branch}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc("regulation")
      .collection("regulationWithYears")
      .doc(name);
  final flash = RegulationConvertor(id: name);
  final json = flash.toJson();
  await docflash.set(json);
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

Stream<List<modelPaperConvertor>> readmodelPaper({required String branch}) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("regulation")
        .collection("regulationWithYears")
        .orderBy("id", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => modelPaperConvertor.fromJson(doc.data()))
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

  syllabusConvertor({this.id = "", required this.syllabus});

  Map<String, dynamic> toJson() => {
        "id": id,
        "syllabus": syllabus,
      };

  static syllabusConvertor fromJson(Map<String, dynamic> json) =>
      syllabusConvertor(
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

  static modelPaperConvertor fromJson(Map<String, dynamic> json) =>
      modelPaperConvertor(
        id: json['id'],
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
      {"id": id, "heading": heading, "photoUrl": photoUrl};

  static TimeTableConvertor fromJson(Map<String, dynamic> json) =>
      TimeTableConvertor(
          id: json['id'], heading: json["heading"], photoUrl: json['photoUrl']);
}

Stream<List<BranchNewConvertor>> readBranchNew(String branch) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("${branch}News")
        .collection("${branch}News")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BranchNewConvertor.fromJson(doc.data()))
            .toList());

Future createBranchNew(
    {required String id,
    required String heading,
    required String description,
    required String branch,
    required String photoUrl}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc("${branch}News")
      .collection("${branch}News")
      .doc(id);
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
  List<String> likedBy,isViewed;
  BranchNewConvertor(
      {this.id = "",
      required this.heading,
      required this.photoUrl,
      required this.description,
        List<String>? likedBy,
        List<String>? isViewed,

      }): likedBy = likedBy ?? [], isViewed = isViewed ?? [];

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "image": photoUrl,
        "description": description,
      };

  static BranchNewConvertor fromJson(Map<String, dynamic> json) =>
      BranchNewConvertor(
        id: json['id'],
        heading: json["heading"],
        photoUrl: json["image"],
        description: json["description"],
        likedBy:
        json["likedBy"] != null ? List<String>.from(json["likedBy"]) : [],
        isViewed:
        json["isViewed"] != null ? List<String>.from(json["isViewed"]) : [],
      );
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
    required String PhotoUrl,
    required String regulation}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc("Subjects")
      .collection("Subjects")
      .doc(getID());
  final flash = FlashConvertor(
      id: getID(),
      heading: heading,
      PhotoUrl: PhotoUrl,
      description: description,
      regulation: regulation);
  final json = flash.toJson();
  await docflash.set(json);
}

Future createFlashNews({
  required String heading,
  required String link,
}) async {
  final docflash = FirebaseFirestore.instance
      .collection("srkrPage")
      .doc("flashNews")
      .collection("flashNews")
      .doc(getID());
  final flash = FlashNewsConvertor(
    id: getID(),
    heading: heading,
    Url: link,
  );
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

Stream<List<FlashConvertor>> readFlashNews(String branch) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("Subjects")
        .collection("Subjects")
        .orderBy("heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FlashConvertor.fromJson(doc.data()))
            .toList());

class FlashConvertor {
  String id;
  final String heading, PhotoUrl, description, regulation;

  FlashConvertor(
      {this.id = "",
      required this.regulation,
      required this.heading,
      required this.PhotoUrl,
      required this.description});

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "description": description,
        "image": PhotoUrl,
        "regulation": regulation
      };

  static FlashConvertor fromJson(Map<String, dynamic> json) => FlashConvertor(
      id: json['id'],
      regulation: json["regulation"],
      heading: json["heading"],
      PhotoUrl: json["image"],
      description: json["description"]);
}

Stream<List<LabSubjectsConvertor>> readLabSubjects(String branch) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("LabSubjects")
        .collection("LabSubjects")
        .orderBy("heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LabSubjectsConvertor.fromJson(doc.data()))
            .toList());

Future createLabSubjects(
    {required String branch,
    required String heading,
    required String description,
    required String PhotoUrl,
    required String regulation}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc("LabSubjects")
      .collection("LabSubjects")
      .doc(getID());
  final flash = LabSubjectsConvertor(
      id: getID(),
      heading: heading,
      description: description,
      regulation: regulation);
  final json = flash.toJson();
  await docflash.set(json);
}

class LabSubjectsConvertor {
  String id;
  final String heading, description, regulation;

  LabSubjectsConvertor(
      {this.id = "",
      required this.heading,
      required this.description,
      required this.regulation});

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "description": description,
        "regulation": regulation,
      };

  static LabSubjectsConvertor fromJson(Map<String, dynamic> json) =>
      LabSubjectsConvertor(
          regulation: json["regulation"],
          id: json['id'],
          heading: json["heading"],
          description: json["description"]);
}

Stream<List<BooksConvertor>> ReadBook(String branch) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("Books")
        .collection("CoreBooks")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BooksConvertor.fromJson(doc.data()))
            .toList());

Future createBook(
    {required String heading,
    required String description,
    required String link,
    required String branch,
    required String photoUrl,
    required String edition,
    required String Author}) async {
  final docBook = FirebaseFirestore.instance
      .collection(branch)
      .doc("Books")
      .collection("CoreBooks")
      .doc(getID());
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
                      width: 45,
                    )),
              )
            ],
          ),
        ));
  }
}
