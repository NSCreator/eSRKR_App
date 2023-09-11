// ignore_for_file: must_be_immutable, unnecessary_import
import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:srkr_study_app/SubPages.dart';
import 'package:srkr_study_app/notification.dart';
import 'package:srkr_study_app/search%20bar.dart';
import 'package:srkr_study_app/settings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'TextField.dart';
import 'favorites.dart';
import 'functins.dart';
import 'main.dart';
import 'net.dart';

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
          backgroundColor: Colors.black.withOpacity(0.75),
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

class _HomePageState extends State<HomePage> {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
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
            child: DefaultTabController(
          initialIndex: index,
          length: 6,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: widget.size * 55,
                // collapsedHeight: widget.size*55,
                backgroundColor: Colors.transparent,
                flexibleSpace: Padding(
                  padding: EdgeInsets.all(widget.size * 8.0),
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
                                    size: widget.size * 30,
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
                                      picText(),
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: widget.size * 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      widget.branch,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: widget.size * 15,
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
                      InkWell(
                        onTap: () {
                          ExternalLaunchUrl("https://srkrec.edu.in/");
                        },
                        child: Text(
                          "eSRKR",
                          style: TextStyle(
                            fontSize: widget.size * 30.0,
                            color: Color.fromRGBO(192, 237, 252, 1),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Row(
                        children: [
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
                                  Icons.search,
                                  color: Colors.white70,
                                  size: widget.size * 30,
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
                                      MyAppq(
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
                          SizedBox(
                            width: widget.size * 10,
                          ),
                          if (isUser())
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
                                    size: widget.size * 30,
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
                                        color: Colors.black
                                            .withOpacity(animation.value),
                                        child: AnimatedOpacity(
                                            duration:
                                                Duration(milliseconds: 300),
                                            opacity:
                                                animation.value.clamp(0.3, 1.0),
                                            child: fadeTransition),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                        ],
                      )
                    ],
                  ),
                ),
                floating: false,
                primary: true,
              ),
              SliverAppBar(
                expandedHeight: widget.size * 20,
                backgroundColor: Colors.black.withOpacity(0.8),
                flexibleSpace: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorColor: Colors.amber,
                  labelColor: Colors.white,
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: widget.size * 20),
                  isScrollable: true,
                  tabs: [
                    Tab(
                      text: 'Home',
                    ),
                    Tab(text: 'Regulation'),
                    Tab(text: 'Favorites'),
                    Tab(text: 'Books'),
                    Tab(text: 'News'),
                    Tab(text: 'Updates'),
                  ],
                ),
                floating: false,
                primary: false,
                snap: false,
                pinned: true,
              ),
            ],
            body: TabBarView(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      FutureBuilder<List<UpdateConvertor>>(
                        future: UpdateConvertorUtil.getUpdateConvertorList(),
                        builder: (context, snapshot) {
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
                                      'Error with updates Data or\n Check Internet Connection'),
                                );
                              } else {
                                final List<UpdateConvertor> updates =
                                    snapshot.data ?? [];

                                if (updates.isEmpty) {
                                  return Container();
                                } else {
                                  final List<UpdateConvertor> updates =
                                      snapshot.data ?? [];
                                  return updates.isEmpty
                                      ? Container()
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: widget.size * 10,
                                                  horizontal: widget.size * 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("New Updates",
                                                      style:
                                                          secondHeadingTextStyle(
                                                              size:
                                                                  widget.size)),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: widget.size * 95,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    min(updates.length, 5),
                                                // Display only top 5 items
                                                itemBuilder:
                                                    (context, int index) {
                                                  final BranchNew =
                                                      updates[index];
                                                  final Uri uri = Uri.parse(
                                                      BranchNew.photoUrl);
                                                  final String fileName =
                                                      uri.pathSegments.last;
                                                  var name =
                                                      fileName.split("/").last;
                                                  final file = File(
                                                      "${folderPath}/updates/$name");

                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        left: widget.size * 10),
                                                    child: InkWell(
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            widget.size * 5),
                                                        width: Width(context) /
                                                            1.35,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(0.8),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      widget.size *
                                                                          15),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white10),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  width: widget
                                                                          .size *
                                                                      35,
                                                                  height: widget
                                                                          .size *
                                                                      35,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(widget.size *
                                                                            17),
                                                                    image:
                                                                        DecorationImage(
                                                                      image: FileImage(
                                                                          file),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            widget.size *
                                                                                5),
                                                                    child: Text(
                                                                      BranchNew
                                                                          .heading,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: widget.size *
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                  left: widget
                                                                          .size *
                                                                      45,
                                                                  right: widget
                                                                          .size *
                                                                      10,
                                                                  bottom: widget
                                                                          .size *
                                                                      5),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    BranchNew
                                                                        .description,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white70,
                                                                        fontSize:
                                                                            widget.size *
                                                                                15),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                  left: widget
                                                                          .size *
                                                                      40,
                                                                  right: widget
                                                                          .size *
                                                                      10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  InkWell(
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(widget.size *
                                                                              8),
                                                                          border:
                                                                              Border.all(color: Colors.white30)),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical: widget.size *
                                                                                3,
                                                                            horizontal:
                                                                                widget.size * 8),
                                                                        child:
                                                                            Text(
                                                                          "Remove",
                                                                          style: TextStyle(
                                                                              color: Colors.red,
                                                                              fontSize: widget.size * 18),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        UpdateConvertorUtil.removeUpdateConvertor(
                                                                            index);
                                                                      });
                                                                    },
                                                                  ),
                                                                  if (BranchNew
                                                                      .link
                                                                      .isNotEmpty)
                                                                    InkWell(
                                                                      child:
                                                                          Text(
                                                                        "Open (Link)",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.lightBlueAccent),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        ExternalLaunchUrl(
                                                                            BranchNew.link);
                                                                      },
                                                                    ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: widget.size *
                                                                            5),
                                                                    child: Text(
                                                                      BranchNew
                                                                          .id,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white38,
                                                                          fontSize:
                                                                              widget.size * 10),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        );
                                }
                              }
                          }
                        },
                      ),
                      FutureBuilder<List<BranchNewConvertor>>(
                        future: BranchNewConvertorUtil.getUpdateConvertorList(),
                        builder: (context, snapshot) {
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
                                      'Error with updates Data or\n Check Internet Connection'),
                                );
                              } else {
                                final List<BranchNewConvertor> updates =
                                    snapshot.data ?? [];

                                if (updates.isEmpty) {
                                  return Container();
                                } else {
                                  final List<BranchNewConvertor> updates =
                                      snapshot.data ?? [];
                                  return updates.isEmpty
                                      ? Container()
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: widget.size * 10,
                                                  horizontal: widget.size * 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${widget.branch} News",
                                                    style:
                                                        secondHeadingTextStyle(
                                                            size: widget.size),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: widget.size * 145,
                                              child: ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    min(updates.length, 5),
                                                // Display only top 5 items
                                                itemBuilder:
                                                    (context, int index) {
                                                  final BranchNew =
                                                      updates[index];
                                                  if (BranchNew
                                                      .photoUrl.isNotEmpty) {
                                                    final Uri uri = Uri.parse(
                                                        BranchNew.photoUrl);
                                                    final String fileName =
                                                        uri.pathSegments.last;
                                                    var name = fileName
                                                        .split("/")
                                                        .last;
                                                    file = File(
                                                        "${folderPath}/${widget.branch.toLowerCase()}_news/$name");
                                                  }
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        left: widget.size * 10),
                                                    child: InkWell(
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            widget.size * 5),
                                                        width: Width(context) /
                                                            1.35,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(0.8),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      widget.size *
                                                                          15),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white10),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  width: widget
                                                                          .size *
                                                                      150,
                                                                  height: widget
                                                                          .size *
                                                                      100,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(widget.size *
                                                                            17),
                                                                    image: BranchNew
                                                                            .photoUrl
                                                                            .isNotEmpty
                                                                        ? DecorationImage(
                                                                            image:
                                                                                FileImage(file),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          )
                                                                        : noImageFound,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    children: [
                                                                      InkWell(
                                                                        child:
                                                                            Container(
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(widget.size * 8),
                                                                              border: Border.all(color: Colors.white30)),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(vertical: widget.size * 3, horizontal: widget.size * 8),
                                                                            child:
                                                                                Text(
                                                                              "Remove",
                                                                              style: TextStyle(color: Colors.red, fontSize: widget.size * 18),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            BranchNewConvertorUtil.removeUpdateConvertor(index);
                                                                          });
                                                                        },
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal: widget.size *
                                                                                5,
                                                                            vertical:
                                                                                widget.size * 5),
                                                                        child:
                                                                            Text(
                                                                          BranchNew
                                                                              .heading,
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: widget.size * 20,
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: widget.size * 5),
                                                                        child:
                                                                            Text(
                                                                          BranchNew
                                                                              .id
                                                                              .split("-")
                                                                              .first,
                                                                          style: TextStyle(
                                                                              color: Colors.white54,
                                                                              fontSize: widget.size * 10,
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          widget.size *
                                                                              5,
                                                                      horizontal:
                                                                          widget.size *
                                                                              5),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    BranchNew
                                                                        .description,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            widget.size *
                                                                                20,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                    maxLines: 1,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        );
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
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                              Favourites!.length, (int index) {
                                            final BranchNew = Favourites[index];

                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left:
                                                              widget.size * 20),
                                                      child: Text(
                                                        BranchNew.heading,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize:
                                                                widget.size *
                                                                    20),
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
                                  );
                                }
                            }
                          }),
                      Padding(
                        padding: EdgeInsets.all(widget.size * 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius:
                                  BorderRadius.circular(widget.size * 40)),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: widget.size * 10, right: widget.size * 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: widget.size * 50,
                                        width: widget.size * 50,
                                        decoration: BoxDecoration(
                                            color: Colors.white30,
                                            borderRadius: BorderRadius.circular(
                                                widget.size * 25),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/timeTableIcon.png"))),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.all(widget.size * 5.0),
                                        child: Text(
                                          "Time Table",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: widget.size * 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
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
                                  child: Column(
                                    children: [
                                      Container(
                                        height: widget.size * 50,
                                        width: widget.size * 50,
                                        decoration: BoxDecoration(
                                            color: Colors.white30,
                                            borderRadius: BorderRadius.circular(
                                                widget.size * 25),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/subjects.png"),
                                                fit: BoxFit.cover)),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.all(widget.size * 5.0),
                                        child: Text(
                                          "Sub",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: widget.size * 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  ),
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
                                          width: widget.size,
                                          height: widget.size,
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
                                  child: Column(
                                    children: [
                                      Container(
                                        height: widget.size * 50,
                                        width: widget.size * 50,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                widget.size * 25),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/lab.png"))),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.all(widget.size * 5.0),
                                        child: Text(
                                          "Lab",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: widget.size * 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(milliseconds: 300),
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            LabSubjects(
                                          branch: widget.branch,
                                          reg: widget.reg,
                                          width: widget.size,
                                          height: widget.size,
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
                                  child: Column(
                                    children: [
                                      Container(
                                        height: widget.size * 50,
                                        width: widget.size * 50,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                widget.size * 25),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/books.png"))),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.all(widget.size * 5.0),
                                        child: Text(
                                          "Books",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: widget.size * 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
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
                      ),
                      Padding(
                        padding: EdgeInsets.all(widget.size * 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius:
                                  BorderRadius.circular(widget.size * 40)),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: widget.size * 10, left: widget.size * 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: widget.size * 50,
                                        width: widget.size * 50,
                                        decoration: BoxDecoration(
                                            color: Colors.white30,
                                            borderRadius: BorderRadius.circular(
                                                widget.size * 25),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/subjects.png"),
                                                fit: BoxFit.cover)),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.all(widget.size * 5.0),
                                        child: Text(
                                          "Syllabus",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: widget.size * 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
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
                                  child: Column(
                                    children: [
                                      Container(
                                        height: widget.size * 50,
                                        width: widget.size * 50,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                widget.size * 25),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/lab.png"))),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.all(widget.size * 5.0),
                                        child: Text(
                                          "Modal Papers",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: widget.size * 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
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
                                )
                              ],
                            ),
                          ),
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
                      )
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: widget.size * 10,
                      ),
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(widget.size * 10),
                              border: Border.all(color: Colors.white38)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: widget.size * 3,
                                horizontal: widget.size * 15),
                            child: Text(
                              "Your Regulation : ${widget.reg}",
                              style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: widget.size * 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Colors.black.withOpacity(0.8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        widget.size * 20)),
                                elevation: 16,
                                child: ListView(
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    StreamBuilder<List<RegulationConvertor>>(
                                        stream: readRegulation(widget.branch),
                                        builder: (context, snapshot) {
                                          final user = snapshot.data;
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                strokeWidth: 0.3,
                                                color: Colors.cyan,
                                              ));
                                            default:
                                              if (snapshot.hasError) {
                                                return const Center(
                                                    child: Text(
                                                        'Error with TextBooks Data or\n Check Internet Connection'));
                                              } else {
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          widget.size * 20),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        widget.size * 8.0),
                                                    child: ListView.builder(
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: user!.length,
                                                      itemBuilder:
                                                          (context, int index) {
                                                        final SubjectsData =
                                                            user[index];
                                                        return Center(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .all(widget
                                                                        .size *
                                                                    3.0),
                                                            child: InkWell(
                                                              child: Text(
                                                                SubjectsData.id
                                                                    .toUpperCase(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .amber,
                                                                    fontSize:
                                                                        widget.size *
                                                                            30),
                                                              ),
                                                              onTap: () {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "user")
                                                                    .doc(
                                                                        fullUserId())
                                                                    .update({
                                                                  "reg":
                                                                      SubjectsData
                                                                          .id
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                );
                                              }
                                          }
                                        })
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: widget.size * 10,),

                      StreamBuilder<List<FlashConvertor>>(
                          stream: readFlashNews(widget.branch),
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
                                  List<FlashConvertor> filteredItems =
                                      Favourites!
                                          .where((item) => item.regulation
                                              .toString()
                                              .startsWith(widget.reg))
                                          .toList();
                                  if (Favourites.length > 0) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: widget.size * 10),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Theory",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: widget.size * 30,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: widget.size * 15,
                                          ),
                                          GridView.builder(
                                            shrinkWrap: true,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisSpacing:
                                                  widget.size * 15,
                                              childAspectRatio: 15 / 11,
                                              crossAxisCount:
                                                  Width(context) > 800 ? 5 : 3,
                                            ),
                                            itemCount: filteredItems.length,
                                            itemBuilder: (context, int index) {
                                              final SubjectsData =
                                                  filteredItems[index];

                                              return InkWell(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                                  widget.size *
                                                                      50),
                                                      border: Border.all(color: Colors.white30),
                                                      color:
                                                          Colors.black),
                                                  child: Padding(
                                                    padding: EdgeInsets
                                                        .symmetric(
                                                            vertical:
                                                                widget.size *
                                                                    5,
                                                            horizontal:
                                                                widget.size *
                                                                    10),
                                                    child: Center(
                                                      child: Text(
                                                        SubjectsData
                                                            .heading,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .tealAccent,
                                                            fontSize:
                                                                widget.size *
                                                                    30,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
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
                                                        reg: SubjectsData
                                                            .regulation,
                                                        size: widget.size,
                                                        branch: widget.branch,
                                                        ID: SubjectsData.id,
                                                        mode: "Subjects",
                                                        name: SubjectsData
                                                            .heading,
                                                        fullName: SubjectsData
                                                            .description,
                                                        photoUrl: SubjectsData
                                                            .PhotoUrl,
                                                      ),
                                                      transitionsBuilder:
                                                          (context,
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
                                                                  animation
                                                                      .value),
                                                          child: AnimatedOpacity(
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      300),
                                                              opacity: animation
                                                                  .value
                                                                  .clamp(
                                                                      0.3, 1.0),
                                                              child:
                                                                  fadeTransition),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  } else
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.tealAccent),
                                        borderRadius: BorderRadius.circular(
                                            widget.size * 20),
                                      ),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(widget.size * 8.0),
                                        child: Text(
                                          "No Subjects in this Regulation",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                }
                            }
                          }),

                      //Lab Subjects

                      StreamBuilder<List<LabSubjectsConvertor>>(
                        stream: readLabSubjects(widget.branch),
                        builder: (context, snapshot) {
                          final Subjects = snapshot.data;
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 0.3,
                                color: Colors.cyan,
                              ));
                            default:
                              if (snapshot.hasError) {
                                return Text("Error with fireBase");
                              } else {
                                List<LabSubjectsConvertor> filteredItems =
                                    Subjects!
                                        .where((item) => item.regulation
                                            .toString()
                                            .startsWith(widget.reg))
                                        .toList();
                                if (Subjects.length > 0)
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: widget.size * 10,
                                        horizontal: widget.size * 10),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.all(widget.size * 8.0),
                                          child: Text(
                                            "Experiments",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: widget.size * 30,
                                                fontWeight:
                                                    FontWeight.w500),
                                          ),
                                        ),
                                        GridView.builder(

                                          shrinkWrap: true,
                                          gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisSpacing:
                                            widget.size * 15,
                                            childAspectRatio: 15 / 11,
                                            crossAxisCount:
                                            Width(context) > 800 ? 5 : 3,
                                          ),
                                          itemCount: filteredItems.length,
                                          itemBuilder: (context, int index) {
                                            final SubjectsData =
                                                filteredItems[index];

                                            return InkWell(
                                              child:  Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        widget.size *
                                                            50),
                                                    border: Border.all(color: Colors.white30),
                                                    color:
                                                    Colors.black),
                                                child: Padding(
                                                  padding: EdgeInsets
                                                      .symmetric(
                                                      vertical:
                                                      widget.size *
                                                          5,
                                                      horizontal:
                                                      widget.size *
                                                          10),
                                                  child: Center(
                                                    child: Text(
                                                      SubjectsData
                                                          .heading,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .tealAccent,
                                                          fontSize:
                                                          widget.size *
                                                              30,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
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
                                                            milliseconds: 300),
                                                    pageBuilder: (context,
                                                            animation,
                                                            secondaryAnimation) =>
                                                        subjectUnitsData(
                                                      reg: SubjectsData
                                                          .regulation,
                                                      size: widget.size,
                                                      branch: widget.branch,
                                                      ID: SubjectsData.id,
                                                      mode: "LabSubjects",
                                                      name:
                                                          SubjectsData.heading,
                                                      fullName: SubjectsData
                                                          .description,
                                                      photoUrl:
                                                          SubjectsData.PhotoUrl,
                                                    ),
                                                    transitionsBuilder:
                                                        (context,
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
                                                                animation
                                                                    .value),
                                                        child: AnimatedOpacity(
                                                            duration: Duration(
                                                                milliseconds:
                                                                    300),
                                                            opacity: animation
                                                                .value
                                                                .clamp(
                                                                    0.3, 1.0),
                                                            child:
                                                                fadeTransition),
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                else
                                  return Text(
                                      "No Lab Subjects For Your Regulation");
                              }
                          }
                        },
                      ),
                      SizedBox(
                        height: widget.size * 150,
                      )
                    ],
                  ),
                ),
                favorites(
                  width: widget.size,
                  height: widget.size,
                  size: widget.size,
                  branch: widget.branch,
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
        )),
      );
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

  UpdateConvertor({
    this.id = "",
    required this.heading,
    required this.photoUrl,
    required this.link,
    required this.branch,
    required this.description,
  });

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

  BranchNewConvertor(
      {this.id = "",
      required this.heading,
      required this.photoUrl,
      required this.description});

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
      PhotoUrl: PhotoUrl,
      description: description,
      regulation: regulation);
  final json = flash.toJson();
  await docflash.set(json);
}

class LabSubjectsConvertor {
  String id;
  final String heading, PhotoUrl, description, regulation;

  LabSubjectsConvertor(
      {this.id = "",
      required this.heading,
      required this.PhotoUrl,
      required this.description,
      required this.regulation});

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "image": PhotoUrl,
        "description": description,
        "regulation": regulation,
      };

  static LabSubjectsConvertor fromJson(Map<String, dynamic> json) =>
      LabSubjectsConvertor(
          regulation: json["regulation"],
          id: json['id'],
          heading: json["heading"],
          PhotoUrl: json["image"],
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
  final double height;
  final double width;

  ImageZoom(
      {Key? key,
      required this.url,
      required this.file,
      required this.width,
      required this.size,
      required this.height})
      : super(key: key);

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
