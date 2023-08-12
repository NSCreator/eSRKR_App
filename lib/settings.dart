// ignore_for_file: use_build_context_synchronously, camel_case_types, non_constant_identifier_names, must_be_immutable

import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:srkr_study_app/HomePage.dart';
import 'dart:convert';

import 'TextField.dart';
import 'functins.dart';
import 'main.dart';
import 'net.dart';

int currentIndex = 0;
File file = File("");

const TextStyle secondTabBarTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 18,
);

TextStyle secondHeadingTextStyle({Color color = Colors.white}) {
  return TextStyle(color: color, fontSize: 30, fontWeight: FontWeight.w500);
}

class settings extends StatefulWidget {
  final String reg, branch;
  final int index;
  final double size;
  final double height;
  final double width;

  const settings(
      {Key? key,
      required this.reg,
      required this.branch,
      required this.index,
      required this.width,
      required this.size,
      required this.height})
      : super(key: key);

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  final InputController = TextEditingController();

  List<mainSettings> SettingsData = [
    mainSettings(
      'Report',
    ),
    mainSettings(
      'About',
    ),
    mainSettings(
      'Privacy Policy',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return backGroundImage(child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            backButton(),
            Padding(
              padding: EdgeInsets.only(bottom: widget.width * 10),
              child: Text(
                "Settings",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.size * 30,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              width: 45,
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.all(widget.size * 8.0),
          child: Container(
            height: widget.height * 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.size * 18),
              color: Colors.black,
              image: DecorationImage(
                image: NetworkImage(
                  "https://images.pond5.com/blue-burning-eagle-animated-logo-footage-102505417_iconl.jpeg",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(widget.size * 18),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: widget.width * 10,
                        bottom: widget.height * 10),
                    child: Row(
                      children: [
                        Container(
                          height: widget.height * 50,
                          width: widget.width * 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                widget.size * 25),
                            color: Colors.white30,
                          ),
                          child: Center(
                              child: Text(
                                picText(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.size * 25),
                              )),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                            EdgeInsets.all(widget.size * 8.0),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user0Id(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: widget.size * 30),
                                ),
                                Text(
                                    "${widget.branch} - ${widget.reg}",
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
                                        fontSize: widget.size * 20))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                widget.size * 8),
                            color: Colors.white24,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: widget.height * 5,
                                horizontal: widget.width * 10),
                            child: Text(
                              "Change Branch",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: widget.size * 22),
                            ),
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor:
                                Colors.black.withOpacity(0.8),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        widget.size * 20)),
                                elevation: 16,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white38),
                                    borderRadius:
                                    BorderRadius.circular(
                                        widget.size * 20),
                                  ),
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      branchYear(
                                        isUpdate: true,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                widget.size * 8),
                            color: Colors.white24,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: widget.height * 5,
                                horizontal: widget.width * 10),
                            child: Text(
                              "Log Out",
                              style: TextStyle(
                                  color:
                                  Color.fromRGBO(5, 252, 223, 1),
                                  fontSize: widget.size * 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        onTap: () {
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
                                    border: Border.all(
                                        color: Colors.tealAccent),
                                    borderRadius:
                                    BorderRadius.circular(
                                        widget.size * 20),
                                  ),
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      SizedBox(
                                          height: widget.height * 15),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: widget.width * 15),
                                        child: Text(
                                          "Do you want Log Out",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight:
                                              FontWeight.w600,
                                              fontSize:
                                              widget.size * 18),
                                        ),
                                      ),
                                      SizedBox(
                                        height: widget.height * 5,
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
                                                  padding: EdgeInsets.only(
                                                      left: widget
                                                          .width *
                                                          15,
                                                      right: widget
                                                          .width *
                                                          15,
                                                      top: widget
                                                          .height *
                                                          5,
                                                      bottom: widget
                                                          .height *
                                                          5),
                                                  child: Text(
                                                    "Back",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white),
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
                                              widget.width * 10,
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
                                                  padding: EdgeInsets.only(
                                                      left: widget
                                                          .width *
                                                          15,
                                                      right: widget
                                                          .width *
                                                          15,
                                                      top: widget
                                                          .height *
                                                          5,
                                                      bottom: widget
                                                          .height *
                                                          5),
                                                  child: Text(
                                                    "Log Out",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                FirebaseAuth.instance
                                                    .signOut();
                                                Navigator.pop(
                                                    context);
                                                Navigator.pop(
                                                    context);
                                              },
                                            ),
                                            SizedBox(
                                              width:
                                              widget.width * 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: widget.height * 10,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomBar(
          index: widget.index,
        ),
        ImageScreen(branch: widget.branch,),
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isUser())
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: widget.height * 20,
                        horizontal: widget.width * 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(31, 48, 48, 1),
                          borderRadius: BorderRadius.circular(
                              widget.size * 15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                            EdgeInsets.all(widget.size * 8.0),
                            child: Text(
                              "Create Here",
                              style: TextStyle(
                                  fontSize: widget.size * 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: widget.width * 20),
                            child: InkWell(
                              child: Row(
                                children: [
                                  Text(
                                    "Create Home Page Update",
                                    style: TextStyle(
                                        fontSize: widget.size * 22,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: widget.width * 10),
                                    child:
                                    Icon(Icons.arrow_forward_ios),
                                  )
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            updateCreator(
                                              branch: widget.branch,
                                              width: widget.width,
                                              height: widget.height,
                                              size: widget.size,
                                            )));
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: widget.width * 20,
                                vertical: widget.height * 5),
                            child: InkWell(
                              child: Row(
                                children: [
                                  Text(
                                    "Create ${widget.branch} News",
                                    style: TextStyle(
                                        fontSize: widget.size * 22,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: widget.width * 10),
                                    child:
                                    Icon(Icons.arrow_forward_ios),
                                  )
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NewsCreator(
                                              branch: widget.branch,
                                            )));
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: widget.width * 20),
                            child: InkWell(
                              child: Row(
                                children: [
                                  Text(
                                    "Create Subject or Lab Subject",
                                    style: TextStyle(
                                        fontSize: widget.size * 22,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: widget.width * 10),
                                    child:
                                    Icon(Icons.arrow_forward_ios),
                                  )
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SubjectsCreator(
                                              branch: widget.branch,
                                            )));
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: widget.width * 20,
                                vertical: widget.height * 5),
                            child: InkWell(
                              child: Row(
                                children: [
                                  Text(
                                    "Create Books",
                                    style: TextStyle(
                                        fontSize: widget.size * 22,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: widget.size * 10),
                                    child:
                                    Icon(Icons.arrow_forward_ios),
                                  )
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BooksCreator(
                                              branch: widget.branch,
                                            )));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Center(
                //   child: InkWell(
                //     child: Container(
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(15),
                //         color: Colors.white.withOpacity(0.1),
                //         border: Border.all(
                //             color: Colors.white.withOpacity(0.3)),
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.all(5.0),
                //         child: Text(
                //           "Saved Images and PDFs ( In App )",
                //           style: TextStyle(
                //               fontSize: 22,
                //               color: Colors.white,
                //               fontWeight: FontWeight.w500),
                //         ),
                //       ),
                //     ),
                //     onTap: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => unseenImages(
                //                     branch: widget.branch,
                //                   )));
                //     },
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(top: widget.height * 20),
                  child: Center(
                      child: Text('Settings',
                          style: TextStyle(
                              fontSize: widget.size * 20,
                              color: Colors.white70))),
                ),
                SizedBox(height: widget.height * 5.0),
                Padding(
                  padding: EdgeInsets.all(widget.size * 8.0),
                  child: Container(
                    margin: EdgeInsets.all(widget.size * 3),
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(widget.size * 22),
                      color: Colors.white.withOpacity(0.3),
                    ),
                    child: Column(
                      children: [
                        GridView.count(
                          physics:
                          const NeverScrollableScrollPhysics(),
                          childAspectRatio: 4,
                          shrinkWrap: true,
                          padding: EdgeInsets.all(widget.size * 3),
                          mainAxisSpacing: 3,
                          crossAxisCount: 2,
                          children: List.generate(
                            SettingsData.length,
                                (int index) {
                              return InkWell(
                                child: Container(
                                  margin: EdgeInsets.all(
                                      widget.size * 2.0),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(
                                        widget.size * 15),
                                    color:
                                    Colors.black.withOpacity(0.7),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        widget.size * 5.0),
                                    child: Center(
                                        child: Text(
                                          SettingsData[index].title,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: widget.size * 13,
                                              fontWeight:
                                              FontWeight.w500),
                                        )),
                                  ),
                                ),
                                onTap: () {
                                  if (SettingsData[index].title ==
                                      "Report") {
                                    sendingMails(
                                        "sujithnimmala03@gmail.com");
                                  } else if (SettingsData[index]
                                      .title ==
                                      "About") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const about()));
                                  } else {
                                    ExternalLaunchUrl(
                                        "https://github.com/NSCreator/PRIVACY_POLACY/blob/main/Privacy-policy");
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                StreamBuilder<List<followUsConvertor>>(
                    stream: readfollowUs(),
                    builder: (context, snapshot) {
                      final Books = snapshot.data;
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
                                    'Error with TextBooks Data or\n Check Internet Connection'));
                          } else {
                            if (Books!.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      widget.size * 8.0),
                                  child: Text(
                                    "Nothing To Follow",
                                    style: TextStyle(
                                      color: Color.fromRGBO(
                                          195, 228, 250, 1),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: widget.width * 10,
                                        top: widget.height * 20,
                                        bottom: widget.height * 8),
                                    child: Text(
                                      "Follow Us",
                                      style: TextStyle(
                                        fontSize: widget.size * 20,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(
                                            195, 228, 250, 1),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: widget.height * 40,
                                    child: ListView.separated(
                                      physics:
                                      BouncingScrollPhysics(),
                                      scrollDirection:
                                      Axis.horizontal,
                                      itemCount: Books.length,
                                      itemBuilder:
                                          (BuildContext context,
                                          int index) =>
                                          InkWell(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: widget.width * 5,
                                                  bottom:
                                                  widget.height * 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: const Color
                                                        .fromRGBO(174,
                                                        228, 242, 0.15),
                                                  ),
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(widget
                                                      .size *
                                                      15),
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  // border: Border.all(color: Colors.white),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration:
                                                      BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            widget.size *
                                                                15),
                                                        color: Colors
                                                            .black
                                                            .withOpacity(
                                                            0.4),
                                                        image:
                                                        DecorationImage(
                                                          image:
                                                          NetworkImage(
                                                            Books[index]
                                                                .photoUrl,
                                                          ),
                                                          fit: BoxFit
                                                              .cover,
                                                        ),
                                                      ),
                                                      height:
                                                      widget.height *
                                                          35,
                                                      width:
                                                      widget.width *
                                                          50,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets
                                                          .all(widget
                                                          .size *
                                                          5.0),
                                                      child: Text(
                                                        Books[index].name,
                                                        style: TextStyle(
                                                            fontSize:
                                                            widget.size *
                                                                16,
                                                            color: Colors
                                                                .white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              if (Books[index].name ==
                                                  "Gmail") {
                                                sendingMails(
                                                    Books[index].link);
                                              } else {
                                                if (Books[index]
                                                    .link
                                                    .isNotEmpty)
                                                  ExternalLaunchUrl(
                                                      Books[index].link);
                                                else
                                                  showToastText(
                                                      "No ${Books[index].name} Link");
                                              }
                                            },
                                          ),
                                      shrinkWrap: true,
                                      separatorBuilder:
                                          (context, index) =>
                                          SizedBox(
                                            width: widget.width * 9,
                                          ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                      }
                    }),
                Center(
                  child: InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(widget.size * 15),
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(widget.size * 5.0),
                        child: Text(
                          "APP DEVELOPMENT TEAM",
                          style: TextStyle(
                              fontSize: widget.size * 22,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const appDevelopmentTeam()));
                    },
                  ),
                ),
                SizedBox(
                  height: widget.height * 30,
                ),
                Center(
                    child: Text(
                      ".....eSRKR.....",
                      style: TextStyle(color: Colors.white),
                    )),
                Center(
                  child: Text(
                    "v3.0.10",
                    style: TextStyle(
                      fontSize: widget.size * 9.0,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: widget.height * 30,
                ),
              ],
            ),
          ),
        ),
      ],
    ),);
  }
}

class bottomBar extends StatefulWidget {
  int index;

  bottomBar({Key? key, required this.index}) : super(key: key);

  @override
  State<bottomBar> createState() => _bottomBarState();
}

class _bottomBarState extends State<bottomBar> {
  late int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedIndex = widget.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "Set Default Index : ",
          style: TextStyle(color: Colors.white, fontSize: 23),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11), color: Colors.white12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                    FirebaseFirestore.instance
                        .collection("user")
                        .doc(fullUserId())
                        .update({"index": 0});
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(11)),
                    color: selectedIndex == 0
                        ? Color.fromRGBO(38, 153, 148, 1)
                        : Colors.transparent,
                  ),
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Home',
                    style: TextStyle(
                      color: selectedIndex == 0 ? Colors.white : Colors.white54,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                    FirebaseFirestore.instance
                        .collection("user")
                        .doc(fullUserId())
                        .update({"index": 1});
                  });
                },
                child: Container(
                  color: selectedIndex == 1
                      ? Color.fromRGBO(38, 153, 148, 1)
                      : Colors.transparent,
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Regulation',
                    style: TextStyle(
                      color: selectedIndex == 1 ? Colors.white : Colors.white54,
                        fontWeight: FontWeight.w600

                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = 2;
                    FirebaseFirestore.instance
                        .collection("user")
                        .doc(fullUserId())
                        .update({"index": 2});
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: selectedIndex == 2
                        ? Color.fromRGBO(38, 153, 148, 1)
                        : Colors.transparent,
                    borderRadius:
                        BorderRadius.horizontal(right: Radius.circular(11)),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Favorites',
                    style: TextStyle(
                      color: selectedIndex == 2 ? Colors.white : Colors.white54,
                        fontWeight: FontWeight.w600

                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class mainSettings {
  String title;

  mainSettings(
    this.title,
  );
}

class about extends StatelessWidget {
  const about({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          //brightness: Brightness.light,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: Color.fromRGBO(7, 7, 23, 1.0),
            ),
          ),

          title: const Text('About'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: FutureBuilder<List<aboutData>>(
        future: aboutDataApi.getUsers(),
        builder: (context, snapshot) {
          final abouts = snapshot.data;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return const Center(child: Text('Some error occurred!'));
              } else {
                return aboutbuild(abouts!);
              }
          }
        },
      ),
    );
  }

  Widget aboutbuild(List<aboutData> abouts) => SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: abouts.length,
            itemBuilder: (context, int index) {
              final about = abouts[index];

              return InkWell(
                child: Container(
                  margin: const EdgeInsets.all(6.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromRGBO(38, 39, 43, 0.6),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 15, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          about.heading,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white70),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 3, bottom: 3),
                          child: Text(
                            about.description,
                            style: TextStyle(color: Colors.white38),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  ExternalLaunchUrl(about.url);
                },
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
              height: 1,
            ),
          ),
        ),
      );
}

class aboutData {
  String heading;
  String description;
  String url;

  aboutData(
      {required this.heading, required this.description, required this.url});

  static aboutData fromJson(json) => aboutData(
      heading: json['heading'],
      description: json['description'],
      url: json['link']);
}

mixin aboutDataApi {
  static Future<List<aboutData>> getUsers() async {
    var url = Uri.parse("https://nscreator.github.io/srkr/settings.json");
    var response = await http.get(url);
    final body = jsonDecode(response.body)["about"];
    return body.map<aboutData>(aboutData.fromJson).toList();
  }
}

class appDevelopmentTeam extends StatelessWidget {
  const appDevelopmentTeam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                "https://i.pinimg.com/736x/01/c7/f7/home.jpg",
              ),
              fit: BoxFit.fill),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.8),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color.fromRGBO(38, 39, 43, 0.4),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 8, 8, 1),
                              child: Text('APP Development Team',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white54)),
                            ),
                            Spacer()
                          ],
                        ),
                        InkWell(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromRGBO(0, 2, 10, 0.5),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 3,
                                ),
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "https://drive.google.com/uc?export=view&id=1g0pUY2mr2EU8M-fb9ZEsyioyLRKXtsuR"))),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "NIMMALA SUJITH",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 13),
                                      child: Text(
                                        "R20-ECE-20B91A04H1",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 13),
                                      child: Text(
                                        "App Developer",
                                        style: const TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            sendingMails("sujithnimmala03@gmail.com");
                          },
                        ),
                        StreamBuilder<List<studentConvertor>>(
                            stream: Readstudent(),
                            builder: (context, snapshot) {
                              final students = snapshot.data;
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
                                            'Error with TextBooks Data or\n Check Internet Connection'));
                                  } else {
                                    return ListView.separated(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: students!.length,
                                      itemBuilder: (context, int index) {
                                        final studentData = students[index];
                                        return InkWell(
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 3, horizontal: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: const Color.fromRGBO(
                                                  0, 2, 10, 0.5),
                                            ),
                                            child: Row(
                                              children: [
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Container(
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              studentData
                                                                  .PhotoUrl))),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Text(
                                                        studentData.name,
                                                        style: const TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 13),
                                                      child: Text(
                                                        studentData.description,
                                                        style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 13),
                                                      child: Text(
                                                        studentData.Role,
                                                        style: const TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            sendingMails(studentData.email);
                                          },
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        height: 1,
                                      ),
                                    );
                                  }
                              }
                            }),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.1)),
                                color: const Color.fromRGBO(38, 39, 43, 0.4),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: const [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 8, 8, 1),
                                        child: Text('Faculty Team',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white54)),
                                      ),
                                      Spacer()
                                    ],
                                  ),
                                  StreamBuilder<List<FacultyConvertor>>(
                                      stream: ReadFaculty(),
                                      builder: (context, snapshot) {
                                        final students = snapshot.data;
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
                                              return buildFaculty(students!);
                                            }
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFaculty(List<FacultyConvertor> facultyDatas) =>
      ListView.separated(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: facultyDatas.length,
          itemBuilder: (context, int index) {
            final facultyData = facultyDatas[index];
            return InkWell(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromRGBO(0, 2, 10, 0.5),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 3,
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: NetworkImage(facultyData.PhotoUrl))),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            facultyData.name,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 13),
                          child: Text(
                            facultyData.description,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 13),
                          child: Text(
                            facultyData.Role,
                            style: const TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () {
                sendingMails(facultyData.email);
              },
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
                height: 1,
              ));
}

Stream<List<studentConvertor>> Readstudent() => FirebaseFirestore.instance
    .collection('App Dev')
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => studentConvertor.fromJson(doc.data()))
        .toList());

class studentConvertor {
  String email;
  String name;
  String description;
  String Role;
  String PhotoUrl, id;

  studentConvertor({
    required this.id,
    required this.email,
    required this.name,
    required this.description,
    required this.Role,
    required this.PhotoUrl,
  });

  static studentConvertor fromJson(json) => studentConvertor(
        id: json['id'],
        email: json['Email'],
        name: json['Name'],
        description: json['Description'],
        Role: json['Role'],
        PhotoUrl: json['PhotoUrl'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Name": name,
        "Email": email,
        "Description": description,
        "PhotoUrl": PhotoUrl,
        "Role": Role,
      };
}

Stream<List<FacultyConvertor>> ReadFaculty() => FirebaseFirestore.instance
    .collection('Faculty')
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => FacultyConvertor.fromJson(doc.data()))
        .toList());

class FacultyConvertor {
  String email;
  String name;
  String description;
  String Role;
  String PhotoUrl, id;

  FacultyConvertor({
    required this.id,
    required this.email,
    required this.name,
    required this.description,
    required this.Role,
    required this.PhotoUrl,
  });

  static FacultyConvertor fromJson(json) => FacultyConvertor(
        id: json['id'],
        email: json['Email'],
        name: json['Name'],
        description: json['Description'],
        Role: json['Role'],
        PhotoUrl: json['PhotoUrl'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Name": name,
        "Email": email,
        "Description": description,
        "PhotoUrl": PhotoUrl,
        "Role": Role,
      };
}

Stream<List<followUsConvertor>> readfollowUs() => FirebaseFirestore.instance
    .collection('FollowUs')
    .orderBy("name", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => followUsConvertor.fromJson(doc.data()))
        .toList());

class followUsConvertor {
  String id;
  final String name, link, photoUrl;

  followUsConvertor(
      {this.id = "",
      required this.name,
      required this.link,
      required this.photoUrl});

  static followUsConvertor fromJson(Map<String, dynamic> json) =>
      followUsConvertor(
          id: json['id'],
          name: json["name"],
          link: json["link"],
          photoUrl: json["photoUrl"]);
}
