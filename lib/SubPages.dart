// ignore_for_file: camel_case_types, non_constant_identifier_names
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:srkr_study_app/TextField.dart';
import 'package:srkr_study_app/HomePage.dart';
import 'add subjects.dart';
import 'package:flutter/material.dart';
import 'favorites.dart';
import 'functins.dart';
import 'package:http/http.dart' as http;

import 'notification.dart';

class NewsPage extends StatefulWidget {
  final String branch;
  final double size;
  final double height;
  final double width;

  const NewsPage(
      {Key? key,
      required this.branch,
      required this.width,
      required this.size,
      required this.height})
      : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  String folderPath = "";

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(children: [
        Padding(
          padding: EdgeInsets.only(top: widget.height * 5),
          child: StreamBuilder<List<BranchNewConvertor>>(
              stream: readBranchNew(widget.branch),
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
                              'Error with TextBooks Data or\n Check Internet Connection'));
                    } else {
                      return ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: BranchNews!.length,
                          itemBuilder: (context, int index) {
                            final BranchNew = BranchNews[index];
                            final Uri uri =
                            Uri.parse(BranchNew.photoUrl);
                            final String fileName =
                                uri.pathSegments.last;
                            var name = fileName.split("/").last;
                            final file = File(
                                "${folderPath}/${widget.branch.toLowerCase()}_news/$name");
                            return InkWell(
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.all(
                                        widget.size * 4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius:
                                      BorderRadius.circular(
                                          widget.size * 15),
                                      border: Border.all(
                                          color: Colors.white
                                              .withOpacity(0.1)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: widget.height * 8,
                                              left: widget.width * 8,
                                              bottom:
                                              widget.height * 2),
                                          child: Row(
                                            children: [
                                              Container(
                                                height:
                                                widget.height * 25,
                                                width:
                                                widget.width * 25,
                                                decoration:
                                                BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      widget.size *
                                                          15),
                                                  image:
                                                  DecorationImage(
                                                    image: AssetImage(
                                                        "assets/ece image 64x64.png"),
                                                  ),
                                                ),
                                              ),
                                              if (BranchNew
                                                  .heading.isNotEmpty)
                                                Text(
                                                    " ${BranchNew.heading}",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .orangeAccent,
                                                        fontSize: widget
                                                            .size *
                                                            20,
                                                        fontWeight:
                                                        FontWeight
                                                            .w400))
                                              else
                                                Text(
                                                    " ${widget.branch} (SRKR)",
                                                    style: TextStyle(
                                                        color:
                                                        Colors
                                                            .white,
                                                        fontSize: widget
                                                            .size *
                                                            20,
                                                        fontWeight:
                                                        FontWeight
                                                            .w400)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.all(
                                                widget.size * 5.0),
                                            child: Image.file(file)),
                                        Row(
                                          children: [
                                            Spacer(),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top:
                                                  widget.height * 5,
                                                  bottom:
                                                  widget.height * 3,
                                                  right: widget.width *
                                                      20),
                                              child: Text(
                                                BranchNew.Date,
                                                style: TextStyle(
                                                    color:
                                                    Colors.white54,
                                                    fontSize:
                                                    widget.size *
                                                        10,
                                                    fontWeight:
                                                    FontWeight
                                                        .w300),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (BranchNew
                                            .description.isNotEmpty)
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: widget.width * 25,
                                                top: widget.height * 5,
                                                bottom:
                                                widget.height * 5),
                                            child: Text(
                                                BranchNew.description,
                                                style: TextStyle(
                                                    color: Colors
                                                        .lightBlueAccent,
                                                    fontSize:
                                                    widget.size *
                                                        14,
                                                    fontWeight:
                                                    FontWeight
                                                        .w300)),
                                          ),
                                        if (isUser())
                                          Row(
                                            children: [
                                              Spacer(),
                                              InkWell(
                                                child: Container(
                                                  decoration:
                                                  BoxDecoration(
                                                    color: Colors
                                                        .grey[500],
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        widget.size *
                                                            15),
                                                    border: Border.all(
                                                        color: Colors
                                                            .white),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: widget
                                                            .width *
                                                            10,
                                                        right: widget
                                                            .width *
                                                            10,
                                                        top: widget
                                                            .height *
                                                            5,
                                                        bottom: widget
                                                            .height *
                                                            5),
                                                    child: Text("Edit"),
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => NewsCreator(
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
                                                                  .photoUrl)));
                                                },
                                              ),
                                              SizedBox(
                                                width:
                                                widget.width * 20,
                                              ),
                                              InkWell(
                                                child: Container(
                                                  decoration:
                                                  BoxDecoration(
                                                    color: Colors
                                                        .grey[500],
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        widget.size *
                                                            15),
                                                    border: Border.all(
                                                        color: Colors
                                                            .white),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: widget
                                                            .width *
                                                            10,
                                                        right: widget
                                                            .width *
                                                            10,
                                                        top: widget
                                                            .height *
                                                            5,
                                                        bottom: widget
                                                            .height *
                                                            5),
                                                    child:
                                                    Text("Delete"),
                                                  ),
                                                ),
                                                onTap: () async {
                                                  final Uri uri = Uri
                                                      .parse(BranchNew
                                                      .photoUrl);
                                                  final String
                                                  fileName = uri
                                                      .pathSegments
                                                      .last;
                                                  final Reference ref =
                                                  storage.ref().child(
                                                      "/${fileName}");
                                                  try {
                                                    await ref.delete();
                                                    showToastText(
                                                        'Image deleted successfully');
                                                  } catch (e) {
                                                    showToastText(
                                                        'Error deleting image: $e');
                                                  }
                                                  FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                      widget.branch)
                                                      .doc(
                                                      "${widget.branch}News")
                                                      .collection(
                                                      "${widget.branch}News")
                                                      .doc(BranchNew.id)
                                                      .delete();
                                                  pushNotificationsSpecificPerson(
                                                      fullUserId(),
                                                      " ${BranchNew.heading} Deleted from News",
                                                      "");
                                                },
                                              ),
                                              SizedBox(
                                                width:
                                                widget.width * 20,
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageZoom(
                                          size: widget.size,
                                          width: widget.width,
                                          height: widget.height,
                                          url: "",
                                          file: file,
                                        )));
                              },
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                            height: widget.height * 9,
                            color: Colors.white,
                          ));
                    }
                }
              }),
        ),

      ]),
    );
  }
}

// ignore: must_be_immutable
class Subjects extends StatefulWidget {
  final String branch;
  final String reg;
  final double size;
  final double height;
  final double width;

  Subjects(
      {Key? key,
      required this.branch,
      required this.reg,
      required this.width,
      required this.size,
      required this.height})
      : super(key: key);

  @override
  State<Subjects> createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  String folderPath = "";

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
    });
  }

  @override
  void initState() {
    // TODO: implement initState

   getPath() ;


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://i.pinimg.com/736x/01/c7/f7/01c7f72511cc6ce7858e65b45d4f8c9c.jpg"),
                fit: BoxFit.fill)),
        child: Container(
          height: double.infinity,
          color: Colors.black.withOpacity(0.8),
          child: SafeArea(
            child: Stack(children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: widget.height * 50, bottom: widget.height * 100),
                  child: StreamBuilder<List<FlashConvertor>>(
                      stream: readFlashNews(widget.branch),
                      builder: (context, snapshot) {
                        final user = snapshot.data;
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
                              return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: user!.length,
                                itemBuilder: (context, int index) {
                                  final SubjectsData = user[index];
                                  final Uri uri =
                                      Uri.parse(SubjectsData.PhotoUrl);
                                  final String fileName = uri.pathSegments.last;
                                  var name = fileName.split("/").last;
                                  final file = File(
                                      "${folderPath}/${widget.branch.toLowerCase()}_subjects/$name");

                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: widget.width * 15,
                                        vertical: widget.height * 2),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: Colors.black38,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        widget.size * 10))),
                                            child: SingleChildScrollView(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: widget.width * 95.0,
                                                    height:
                                                        widget.height * 55.0,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  widget.size *
                                                                      8.0)),
                                                      color: Colors.black,
                                                      image: DecorationImage(
                                                        image: FileImage(file),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: widget.width * 10,
                                                  ),
                                                  Expanded(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            SubjectsData
                                                                .heading,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  widget.size *
                                                                      20.0,
                                                              color: Colors
                                                                  .orangeAccent,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          SizedBox(
                                                            width:
                                                                widget.width *
                                                                    5,
                                                          ),
                                                          InkWell(
                                                            child: StreamBuilder<
                                                                DocumentSnapshot>(
                                                              stream: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'user')
                                                                  .doc(
                                                                      fullUserId())
                                                                  .collection(
                                                                      "FavouriteSubject")
                                                                  .doc(
                                                                      SubjectsData
                                                                          .id)
                                                                  .snapshots(),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  if (snapshot
                                                                      .data!
                                                                      .exists) {
                                                                    return Icon(
                                                                        Icons
                                                                            .library_add_check,
                                                                        size: widget.size *
                                                                            26,
                                                                        color: Colors
                                                                            .cyanAccent);
                                                                  } else {
                                                                    return Icon(
                                                                      Icons
                                                                          .library_add_outlined,
                                                                      size: widget
                                                                              .size *
                                                                          26,
                                                                      color: Colors
                                                                          .cyanAccent,
                                                                    );
                                                                  }
                                                                } else {
                                                                  return Container();
                                                                }
                                                              },
                                                            ),
                                                            onTap: () async {
                                                              try {
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'user')
                                                                    .doc(
                                                                        fullUserId())
                                                                    .collection(
                                                                        "FavouriteSubject")
                                                                    .doc(
                                                                        SubjectsData
                                                                            .id)
                                                                    .get()
                                                                    .then(
                                                                        (docSnapshot) {
                                                                  if (docSnapshot
                                                                      .exists) {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'user')
                                                                        .doc(
                                                                            fullUserId())
                                                                        .collection(
                                                                            "FavouriteSubject")
                                                                        .doc(SubjectsData
                                                                            .id)
                                                                        .delete();
                                                                    showToastText(
                                                                        "Removed from saved list");
                                                                  } else {
                                                                    FavouriteSubjects(
                                                                        branch: widget
                                                                            .branch,
                                                                        SubjectId:
                                                                            SubjectsData
                                                                                .id,
                                                                        name: SubjectsData
                                                                            .heading,
                                                                        description:
                                                                            SubjectsData
                                                                                .description,
                                                                        photoUrl:
                                                                            SubjectsData.PhotoUrl);
                                                                    showToastText(
                                                                        "${SubjectsData.heading} in favorites");
                                                                  }
                                                                });
                                                              } catch (e) {
                                                                print(e);
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            widget.height * 2,
                                                      ),
                                                      Text(
                                                        SubjectsData
                                                            .description,
                                                        style: TextStyle(
                                                          fontSize:
                                                              widget.size *
                                                                  13.0,
                                                          color: Colors
                                                              .lightBlueAccent,
                                                        ),
                                                      ),
                                                      if (isUser())
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: widget
                                                                          .width *
                                                                      10),
                                                          child: Container(
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
                                                                      0.3),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.5)),
                                                            ),
                                                            width:
                                                                widget.width *
                                                                    70,
                                                            child: InkWell(
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: widget
                                                                            .width *
                                                                        5,
                                                                  ),
                                                                  Icon(
                                                                    Icons.edit,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: widget.width *
                                                                            3,
                                                                        right: widget.width *
                                                                            3),
                                                                    child: Text(
                                                                      "Edit",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          fontSize:
                                                                              widget.size * 18),
                                                                    ),
                                                                  ),
                                                                ],
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
                                                                        SubjectsCreator(
                                                                      branch: widget
                                                                          .branch,
                                                                      Id: SubjectsData
                                                                          .id,
                                                                      heading:
                                                                          SubjectsData
                                                                              .heading,
                                                                      description:
                                                                          SubjectsData
                                                                              .description,
                                                                      photoUrl:
                                                                          SubjectsData
                                                                              .PhotoUrl,
                                                                      mode:
                                                                          "Subjects",
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
                                                                        child: AnimatedOpacity(
                                                                            duration:
                                                                                Duration(milliseconds: 300),
                                                                            opacity: animation.value.clamp(0.3, 1.0),
                                                                            child: fadeTransition),
                                                                      );
                                                                    },
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ))
                                                ],
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
                                                      date: SubjectsData.Date.split("-").last,
                                                      req: SubjectsData.regulation,
                                                      pdfs: 0,
                                                  width: widget.width,
                                                  height: widget.height,
                                                  size: widget.size,
                                                  branch: widget.branch,
                                                  ID: SubjectsData.id,
                                                  mode: "Subjects",
                                                  name: SubjectsData.heading,
                                                  fullName:
                                                      SubjectsData.description,
                                                  photoUrl:
                                                      SubjectsData.PhotoUrl,
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
                                        // if ((index + 1) % 1 == 0)
                                        //   CustomBannerAd01(),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                        }
                      }),
                ),
              ),
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      backButton(),
                      Padding(
                        padding: EdgeInsets.only(bottom: widget.width * 10),
                        child: Text(
                          "${widget.branch} Subjects",
                          style: TextStyle(
                              color: Colors.white, fontSize: widget.size * 30,fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(width: 45,)
                    ],
                  ),

              )
            ]),
          ),
        ),
      ),
    );
  }
}

class LabSubjects extends StatefulWidget {
  final String branch;
  final String reg;
  final double size;
  final double height;
  final double width;

  LabSubjects(
      {Key? key,
      required this.branch,
      required this.reg,
      required this.width,
      required this.size,
      required this.height})
      : super(key: key);

  @override
  State<LabSubjects> createState() => _LabSubjectsState();
}

class _LabSubjectsState extends State<LabSubjects> {
  String folderPath = "";
  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
    });
  }
  @override
  void initState() {
    // TODO: implement initState

       getPath();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://i.pinimg.com/736x/01/c7/f7/01c7f72511cc6ce7858e65b45d4f8c9c.jpg"),
                fit: BoxFit.fill)),
        child: Container(
          height: double.infinity,
          color: Colors.black.withOpacity(0.8),
          child: SafeArea(
            child: Stack(children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: widget.height * 50, bottom: widget.height * 100),
                  child: StreamBuilder<List<LabSubjectsConvertor>>(
                      stream: readLabSubjects(widget.branch),
                      builder: (context, snapshot) {
                        final LabSubjects = snapshot.data;
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
                              return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: LabSubjects!.length,
                                itemBuilder: (context, int index) {
                                  final LabSubjectsData = LabSubjects[index];

                                  final Uri uri =
                                      Uri.parse(LabSubjectsData.PhotoUrl);
                                  final String fileName = uri.pathSegments.last;
                                  var name = fileName.split("/").last;
                                  final file = File(
                                      "${folderPath}/${widget.branch.toLowerCase()}_labsubjects/$name");

                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: widget.height * 2,
                                        horizontal: widget.width * 15),
                                    child: InkWell(
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.black38,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    widget.size * 10))),
                                        child: SingleChildScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: widget.width * 95.0,
                                                height: widget.height * 55.0,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(
                                                          widget.size * 8.0)),
                                                  color: Colors.redAccent,
                                                  image: DecorationImage(
                                                    image: FileImage(file),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: widget.width * 10,
                                              ),
                                              Expanded(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        LabSubjectsData.heading,
                                                        style: TextStyle(
                                                          fontSize:
                                                              widget.size *
                                                                  20.0,
                                                          color: Colors
                                                              .orangeAccent,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      SizedBox(
                                                        width: widget.width * 5,
                                                      ),
                                                      InkWell(
                                                        child: StreamBuilder<
                                                            DocumentSnapshot>(
                                                          stream: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'user')
                                                              .doc(fullUserId())
                                                              .collection(
                                                                  "FavouriteLabSubjects")
                                                              .doc(
                                                                  LabSubjectsData
                                                                      .id)
                                                              .snapshots(),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                .hasData) {
                                                              if (snapshot.data!
                                                                  .exists) {
                                                                return Icon(
                                                                    Icons
                                                                        .library_add_check,
                                                                    size: widget
                                                                            .size *
                                                                        26,
                                                                    color: Colors
                                                                        .cyanAccent);
                                                              } else {
                                                                return Icon(
                                                                  Icons
                                                                      .library_add_outlined,
                                                                  size: widget
                                                                          .size *
                                                                      26,
                                                                  color: Colors
                                                                      .cyanAccent,
                                                                );
                                                              }
                                                            } else {
                                                              return Container();
                                                            }
                                                          },
                                                        ),
                                                        onTap: () async {
                                                          try {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'user')
                                                                .doc(
                                                                    fullUserId())
                                                                .collection(
                                                                    "FavouriteLabSubjects")
                                                                .doc(
                                                                    LabSubjectsData
                                                                        .id)
                                                                .get()
                                                                .then(
                                                                    (docSnapshot) {
                                                              if (docSnapshot
                                                                  .exists) {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'user')
                                                                    .doc(
                                                                        fullUserId())
                                                                    .collection(
                                                                        "FavouriteLabSubjects")
                                                                    .doc(
                                                                        LabSubjectsData
                                                                            .id)
                                                                    .delete();
                                                                showToastText(
                                                                    "Removed from saved list");
                                                              } else {
                                                                FavouriteLabSubjectsSubjects(
                                                                    branch: widget
                                                                        .branch,
                                                                    SubjectId:
                                                                        LabSubjectsData
                                                                            .id,
                                                                    name: LabSubjectsData
                                                                        .heading,
                                                                    description:
                                                                        LabSubjectsData
                                                                            .description,
                                                                    photoUrl:
                                                                        LabSubjectsData
                                                                            .PhotoUrl);
                                                                showToastText(
                                                                    "${LabSubjectsData.heading} in favorites");
                                                              }
                                                            });
                                                          } catch (e) {
                                                            print(e);
                                                          }
                                                        },
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            widget.width * 10,
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: widget.height * 2,
                                                  ),
                                                  Text(
                                                    LabSubjectsData.description,
                                                    style: TextStyle(
                                                      fontSize:
                                                          widget.size * 13.0,
                                                      color: Colors
                                                          .lightBlueAccent,
                                                    ),
                                                  ),
                                                  if (isUser())
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: widget.width *
                                                              10),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      widget.size *
                                                                          15),
                                                          color: Colors.white
                                                              .withOpacity(0.5),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        child: InkWell(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(
                                                                left: widget
                                                                        .width *
                                                                    10,
                                                                right: widget
                                                                        .width *
                                                                    10,
                                                                top: widget
                                                                        .height *
                                                                    5,
                                                                bottom: widget
                                                                        .height *
                                                                    5),
                                                            child: Text("+Add"),
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
                                                                    SubjectsCreator(
                                                                  branch: widget
                                                                      .branch,
                                                                  Id: LabSubjectsData
                                                                      .id,
                                                                  heading:
                                                                      LabSubjectsData
                                                                          .heading,
                                                                  description:
                                                                      LabSubjectsData
                                                                          .description,
                                                                  photoUrl:
                                                                      LabSubjectsData
                                                                          .PhotoUrl,
                                                                  mode:
                                                                      "LabSubjects",
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
                                                                    child:
                                                                        child,
                                                                  );

                                                                  return Container(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            animation.value),
                                                                    child: AnimatedOpacity(
                                                                        duration: Duration(
                                                                            milliseconds:
                                                                                300),
                                                                        opacity: animation.value.clamp(
                                                                            0.3,
                                                                            1.0),
                                                                        child:
                                                                            fadeTransition),
                                                                  );
                                                                },
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ))
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: const Duration(
                                                milliseconds: 300),
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                subjectUnitsData(
                                                  date: LabSubjectsData.Date.split("-").last,
                                                  req: LabSubjectsData.regulation,
                                                  pdfs: 0,
                                              width: widget.width,
                                              height: widget.height,
                                              size: widget.size,
                                              branch: widget.branch,
                                              ID: LabSubjectsData.id,
                                              mode: "LabSubjects",
                                              name: LabSubjectsData.heading,
                                              fullName:
                                                  LabSubjectsData.description,
                                              photoUrl:
                                                  LabSubjectsData.PhotoUrl,
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
                                                color: Colors.black.withOpacity(
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
                                      onLongPress: () {
                                        FavouriteLabSubjectsSubjects(
                                            branch: widget.branch,
                                            SubjectId: LabSubjectsData.id,
                                            name: LabSubjectsData.heading,
                                            description:
                                                LabSubjectsData.description,
                                            photoUrl: LabSubjectsData.PhotoUrl);
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                        }
                      }),
                ),
              ),
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      backButton(),
                      Padding(
                        padding: EdgeInsets.only(bottom: widget.width * 10),
                        child: Text(
                          "${widget.branch} Lab Subjects",
                          style: TextStyle(
                              color: Colors.white, fontSize: widget.size * 30,fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(width: 45,)
                    ],
                  ),)
            ]),
          ),
        ),
      ),
    );
  }
}

class allBooks extends StatefulWidget {
  final String branch;
  final String reg;
  final double size;
  final double height;
  final double width;

  const allBooks(
      {Key? key,
      required this.branch,
      required this.reg,
      required this.width,
      required this.size,
      required this.height})
      : super(key: key);

  @override
  State<allBooks> createState() => _allBooksState();
}

class _allBooksState extends State<allBooks> {
  String folderPath = "";

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(
            top: widget.height * 10, bottom: widget.height * 100),
        child: StreamBuilder<List<BooksConvertor>>(
            stream: ReadBook(widget.branch),
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
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: Books!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Uri uri =
                        Uri.parse(Books[index].photoUrl);
                        final String fileName = uri.pathSegments.last;
                        var name = fileName.split("/").last;
                        final file = File(
                            "${folderPath}/${widget.branch.toLowerCase()}_books/$name");
                        return InkWell(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: widget.width * 15,
                                bottom: widget.height * 10,
                                right: widget.width * 10),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.end,
                              children: [
                                Container(
                                  height: 140,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(
                                        widget.size * 8),
                                    color:
                                    Colors.black.withOpacity(0.4),
                                    image: DecorationImage(
                                      image: FileImage(file),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  width: widget.width * 95,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.horizontal(
                                          right: Radius.circular(
                                              widget.size * 10)),
                                      color: Colors.black
                                          .withOpacity(0.6),
                                      // border: Border.all(color: Colors.white),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          widget.size * 8.0),
                                      child: SingleChildScrollView(
                                        physics:
                                        BouncingScrollPhysics(),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            Text(
                                              Books[index].heading,
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.w500,
                                                  fontSize:
                                                  widget.size *
                                                      20,
                                                  color:
                                                  Colors.orange),
                                            ),
                                            Text(
                                              Books[index].Author,
                                              maxLines: 1,
                                              overflow: TextOverflow
                                                  .ellipsis,
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.w400,
                                                  fontSize:
                                                  widget.size *
                                                      13,
                                                  color:
                                                  Colors.white),
                                            ),
                                            Text(
                                              Books[index].edition,
                                              maxLines: 1,
                                              overflow: TextOverflow
                                                  .ellipsis,
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.w400,
                                                  fontSize:
                                                  widget.size *
                                                      13,
                                                  color:
                                                  Colors.white70),
                                            ),
                                            SizedBox(
                                              height:
                                              widget.height * 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceEvenly,
                                              children: [
                                                booksDownloadButton(
                                                  branch:
                                                  widget.branch,
                                                  width: widget.width,
                                                  height:
                                                  widget.height,
                                                  size: widget.size,
                                                  path: folderPath,
                                                  pdfLink:
                                                  Books[index]
                                                      .link,
                                                ),
                                                InkWell(
                                                  child: StreamBuilder<
                                                      DocumentSnapshot>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                        'user')
                                                        .doc(
                                                        fullUserId())
                                                        .collection(
                                                        "FavouriteBooks")
                                                        .doc(Books[
                                                    index]
                                                        .id)
                                                        .snapshots(),
                                                    builder: (context,
                                                        snapshot) {
                                                      if (snapshot
                                                          .hasData) {
                                                        if (snapshot
                                                            .data!
                                                            .exists) {
                                                          return Row(
                                                            children: [
                                                              Icon(
                                                                  Icons
                                                                      .library_add_check,
                                                                  size: widget.size *
                                                                      26,
                                                                  color:
                                                                  Colors.green),
                                                              Text(
                                                                "Saved",
                                                                style: TextStyle(
                                                                    color: Colors.greenAccent,
                                                                    fontSize: widget.size * 20),
                                                              )
                                                            ],
                                                          );
                                                        } else {
                                                          return Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .library_add_outlined,
                                                                size: widget.size *
                                                                    26,
                                                                color:
                                                                Colors.cyan,
                                                              ),
                                                              Text(
                                                                "Save",
                                                                style: TextStyle(
                                                                    color: Colors.cyanAccent,
                                                                    fontSize: widget.size * 20),
                                                              )
                                                            ],
                                                          );
                                                        }
                                                      } else {
                                                        return Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .library_add_outlined,
                                                              size: widget.size *
                                                                  26,
                                                              color: Colors
                                                                  .cyan,
                                                            ),
                                                            Text(
                                                              "Save",
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.cyanAccent,
                                                                  fontSize: widget.size * 20),
                                                            )
                                                          ],
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  onTap: () async {
                                                    try {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                          'user')
                                                          .doc(
                                                          fullUserId())
                                                          .collection(
                                                          "FavouriteBooks")
                                                          .doc(Books[
                                                      index]
                                                          .id)
                                                          .get()
                                                          .then(
                                                              (docSnapshot) {
                                                            if (docSnapshot
                                                                .exists) {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                  'user')
                                                                  .doc(
                                                                  fullUserId())
                                                                  .collection(
                                                                  "FavouriteBooks")
                                                                  .doc(Books[index]
                                                                  .id)
                                                                  .delete();
                                                              showToastText(
                                                                  "Removed from saved list");
                                                            } else {
                                                              FavouriteBooksSubjects(
                                                                  description: Books[index]
                                                                      .description,
                                                                  heading:
                                                                  Books[index]
                                                                      .heading,
                                                                  link: Books[index]
                                                                      .link,
                                                                  photoUrl:
                                                                  Books[index]
                                                                      .photoUrl,
                                                                  Author: Books[index]
                                                                      .Author,
                                                                  edition:
                                                                  Books[index]
                                                                      .edition,
                                                                  branch: widget
                                                                      .branch,
                                                                  id: Books[index]
                                                                      .id);
                                                              showToastText(
                                                                  "${Books[index].heading} in favorites");
                                                            }
                                                          });
                                                    } catch (e) {
                                                      print(e);
                                                    }
                                                  },
                                                )
                                              ],
                                            ),
                                            if (isUser())
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  InkWell(
                                                    child: Chip(
                                                      elevation: 20,
                                                      backgroundColor:
                                                      Colors
                                                          .black,
                                                      avatar:
                                                      CircleAvatar(
                                                          backgroundColor:
                                                          Colors
                                                              .black45,
                                                          child:
                                                          Icon(
                                                            Icons
                                                                .edit_outlined,
                                                          )),
                                                      label: Text(
                                                        "Edit",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  BooksCreator(
                                                                    branch: widget.branch,
                                                                    id: Books[index].id,
                                                                    heading: Books[index].heading,
                                                                    description: Books[index].description,
                                                                    Edition: Books[index].edition,
                                                                    Link: Books[index].link,
                                                                    Author: Books[index].Author,
                                                                    photoUrl: Books[index].photoUrl,
                                                                  )));
                                                    },
                                                  ),
                                                  InkWell(
                                                    child: Chip(
                                                      elevation: 20,
                                                      backgroundColor:
                                                      Colors
                                                          .black,
                                                      avatar:
                                                      CircleAvatar(
                                                          backgroundColor:
                                                          Colors
                                                              .black45,
                                                          child:
                                                          Icon(
                                                            Icons
                                                                .delete_rounded,
                                                          )),
                                                      label: Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                          widget
                                                              .branch)
                                                          .doc(
                                                          "Books")
                                                          .collection(
                                                          "CoreBooks")
                                                          .doc(Books[
                                                      index]
                                                          .id)
                                                          .delete();
                                                      pushNotificationsSpecificPerson(
                                                          fullUserId(),
                                                          "${Books[index].heading} Deleted from Books",
                                                          "");
                                                    },
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {},
                        );
                      },
                    );
                  }
              }
            }),
      ),
    );
  }
}

// ignore: must_be_immutable
class subjectUnitsData extends StatefulWidget {
  String ID, mode;
  String name;
  String fullName;
  String photoUrl;
  String branch;
  String req;
  String date;
  final double size;
  final double height;
  final double width;
  final int pdfs;

  subjectUnitsData(
      {required this.ID,
      required this.mode,
      required this.photoUrl,
      required this.branch,
      required this.req,
      required this.date,
      required this.pdfs,
      this.name = "Subjects",
      required this.fullName,
      required this.width,
      required this.size,
      required this.height});

  @override
  State<subjectUnitsData> createState() => _subjectUnitsDataState();
}

class _subjectUnitsDataState extends State<subjectUnitsData> {
  bool isReadMore = false;
  bool isDownloaded = false;
  String folderPath = "";
  File file = File("");

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final Uri uri = Uri.parse(widget.photoUrl);
    final String fileName = uri.pathSegments.last;
    var name = fileName.split("/").last;
    setState(() {
      folderPath = '${directory.path}';
      if (widget.mode == "Subjects") {
        file =
            File("${folderPath}/${widget.branch.toLowerCase()}_subjects/$name");
      } else {
        file = File(
            "${folderPath}/${widget.branch.toLowerCase()}_labsubjects/$name");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://i.pinimg.com/736x/01/c7/f7/01c7f72511cc6ce7858e65b45d4f8c9c.jpg"),
                  fit: BoxFit.fill)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: widget.height * 185,
                            bottom: widget.height * 100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: widget.width * 10,
                                  bottom: widget.height * 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Units",
                                    style: TextStyle(
                                        fontSize: widget.size * 40,
                                        color: Colors.deepOrangeAccent),
                                  ),
                                  if (isUser())
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: widget.width * 10),
                                      child: InkWell(
                                        child: Chip(
                                          elevation: 20,
                                          backgroundColor: Colors.white38,
                                          avatar: CircleAvatar(
                                              backgroundColor: Colors.black,
                                              child: Icon(
                                                Icons.add,
                                              )),
                                          label: Text(
                                            "Edit",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UnitsCreator(
                                                        branch: widget.branch,
                                                        id: widget.ID,
                                                        mode: widget.mode,
                                                      )));
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            StreamBuilder<List<UnitsConvertor>>(
                                stream: readUnits(widget.ID, widget.branch),
                                builder: (context, snapshot) {
                                  final Units = snapshot.data;
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
                                        return Padding(
                                            padding:
                                                EdgeInsets.all(widget.size * 5.0),
                                            child: ListView.separated(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: Units!.length,
                                                itemBuilder:
                                                    (context, int index) {
                                                  final unit = Units[index];

                                                  return subUnit(
                                                    width: widget.width,
                                                    height: widget.height,
                                                    size: widget.size,
                                                    ID: widget.ID,
                                                    branch: widget.branch,
                                                    unit: unit,
                                                    mode: widget.mode,
                                                    photoUrl: widget.photoUrl,
                                                  );
                                                },
                                                separatorBuilder: (context,
                                                        index) =>
                                                    SizedBox(
                                                      height: widget.height * 5,
                                                    )));
                                      }
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.all(widget.size * 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              backButton(),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: AspectRatio(
                                      aspectRatio: 16/9,
                                      child: Container(

                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Colors.black),
                                            image: DecorationImage(
                                                image: FileImage(file),
                                                fit: BoxFit.fill)),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 3,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(color: Colors.white30)
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 8),
                                                  child: Text(widget.req,style: TextStyle(color: Colors.white),),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.circle,size: 8,color: Colors.white,),
                                                  Text(" ${widget.pdfs} PDFS",style: TextStyle(color: Colors.white),),
                                                ],
                                              ),

                                              Row(
                                                children: [
                                                  Icon(Icons.circle,size: 8,color: Colors.white,),
                                                  Text(widget.date,style: TextStyle(color: Colors.white),)
                                                ],
                                              ),

                                            ],
                                          ),
                                          Text(
                                            widget.name,
                                            style: TextStyle(
                                                fontSize: widget.size * 25,
                                                color: Colors.deepOrange,
                                                fontWeight:
                                                    FontWeight.w500),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    border: Border.all(
                                                        color:
                                                            Colors.white38),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            widget.size * 15)),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 3,horizontal: 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      if (widget.mode ==
                                                          "Subjects")
                                                        InkWell(
                                                          child: StreamBuilder<
                                                              DocumentSnapshot>(
                                                            stream: FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'user')
                                                                .doc(
                                                                    fullUserId())
                                                                .collection(
                                                                    "FavouriteSubject")
                                                                .doc(
                                                                    widget.ID)
                                                                .snapshots(),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                  .hasData) {
                                                                if (snapshot
                                                                    .data!
                                                                    .exists) {
                                                                  return Row(
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .library_add_check,
                                                                          size: widget.size *
                                                                              23,
                                                                          color:
                                                                              Colors.cyanAccent),
                                                                      Text(
                                                                        " Saved",
                                                                        style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: widget.size * 20),
                                                                      )
                                                                    ],
                                                                  );
                                                                } else {
                                                                  return Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .library_add_outlined,
                                                                        size: widget.size *
                                                                            23,
                                                                        color:
                                                                            Colors.cyanAccent,
                                                                      ),
                                                                      Text(
                                                                        " Save",
                                                                        style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: widget.size * 20),
                                                                      )
                                                                    ],
                                                                  );
                                                                }
                                                              } else {
                                                                return Container();
                                                              }
                                                            },
                                                          ),
                                                          onTap: () async {
                                                            try {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'user')
                                                                  .doc(
                                                                      fullUserId())
                                                                  .collection(
                                                                      "FavouriteSubject")
                                                                  .doc(widget
                                                                      .ID)
                                                                  .get()
                                                                  .then(
                                                                      (docSnapshot) {
                                                                if (docSnapshot
                                                                    .exists) {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'user')
                                                                      .doc(
                                                                          fullUserId())
                                                                      .collection(
                                                                          "FavouriteSubject")
                                                                      .doc(widget
                                                                          .ID)
                                                                      .delete();
                                                                  showToastText(
                                                                      "Removed from saved list");
                                                                } else {
                                                                  FavouriteSubjects(
                                                                      branch: widget
                                                                          .branch,
                                                                      SubjectId:
                                                                          widget
                                                                              .ID,
                                                                      name: widget
                                                                          .name,
                                                                      description:
                                                                          widget
                                                                              .fullName,
                                                                      photoUrl:
                                                                          widget.photoUrl);
                                                                  showToastText(
                                                                      "${widget.name} in favorites");
                                                                }
                                                              });
                                                            } catch (e) {
                                                              print(e);
                                                            }
                                                          },
                                                        )

                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10,),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: <Widget>[
                                                  CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    value: 0.1,
                                                  ),
                                                  Icon(Icons.download_for_offline_outlined, size: 40.0),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                ],
                              ),

                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  widget.fullName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.size * 25,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Stream<List<UnitsConvertor>> readUnits(String subjectsID, String branch) =>
      FirebaseFirestore.instance
          .collection(branch)
          .doc(widget.mode)
          .collection(widget.mode)
          .doc(subjectsID)
          .collection("Units")
          .orderBy("Heading", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => UnitsConvertor.fromJson(doc.data()))
              .toList());
}

Future createUnits(
    {required String mode,
    required String branch,
    required String heading,
    required String description,
    required String PDFSize,
    required String questions,
    required String PDFLink,
    required String subjectsID}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc(mode)
      .collection(mode)
      .doc(subjectsID)
      .collection("Units")
      .doc();
  final flash = UnitsConvertor(
      id: docflash.id,
      heading: heading,
      questions: questions,
      description: description,
      PDFSize: PDFSize,
      PDFLink: PDFLink,
      Date: getDate());
  final json = flash.toJson();
  await docflash.set(json);
}

class UnitsConvertor {
  String id;
  final String heading, questions, description, PDFSize, PDFLink, Date;
  List<String> likedBy;
  UnitsConvertor({
    this.id = "",
    required this.heading,
    required this.questions,
    required this.description,
    required this.PDFSize,
    required this.PDFLink,
    required this.Date,
    List<String>? likedBy,
  }) : likedBy = likedBy ?? [];

  Map<String, dynamic> toJson() => {
        "id": id,
        "Heading": heading,
        "questions": questions,
        "Description": description,
        "PDFSize": PDFSize,
        "PDFLink": PDFLink,
        "Date": Date,
        "likedBy": likedBy,
      };

  static UnitsConvertor fromJson(Map<String, dynamic> json) => UnitsConvertor(
        PDFLink: json["PDFLink"],
        id: json['id'],
        heading: json["Heading"],
        questions: json["questions"],
        description: json["Description"],
        PDFSize: json["PDFSize"],
        Date: json["Date"],
        likedBy:
            json["likedBy"] != null ? List<String>.from(json["likedBy"]) : [],
      );
}

class subUnit extends StatefulWidget {
  final UnitsConvertor unit;
  final String mode;
  final String photoUrl;
  final String branch;
  final String ID;
  final double size;
  final double height;
  final double width;

  const subUnit(
      {Key? key,
      required this.unit,
      required this.mode,
      required this.photoUrl,
      required this.branch,
      required this.ID,
      required this.width,
      required this.size,
      required this.height})
      : super(key: key);

  @override
  State<subUnit> createState() => _subUnitState();
}

class _subUnitState extends State<subUnit> {
  bool isReadMore = false;
  bool isQuestions = false;
  bool isDownloaded = false;
  String folderPath = "";
  File file = File("");
  bool isExp = false;
  List<String> newList = [];
  List<String> newQuestionsList = [];
  bool fullDescription = false;
  int pages = 0;
  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final Uri uri = Uri.parse(widget.photoUrl);
    final String fileName = uri.pathSegments.last;
    var name = fileName.split("/").last;
    setState(() {
      folderPath = '${directory.path}';
      if (widget.mode == "Subjects") {
        file =
            File("${folderPath}/${widget.branch.toLowerCase()}_subjects/$name");
      } else {
        file = File(
            "${folderPath}/${widget.branch.toLowerCase()}_labsubjects/$name");
      }
    });
  }

  download(String photoUrl, String path) async {
    final Uri uri = Uri.parse(photoUrl);
    final String fileName = uri.pathSegments.last;
    var name = fileName.split("/").last;
    if (photoUrl.startsWith('https://drive.google.com')) {
      name = photoUrl.split('/d/')[1].split('/')[0];

      photoUrl = "https://drive.google.com/uc?export=download&id=$name";
    }
    final response = await http.get(Uri.parse(photoUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory('${documentDirectory.path}/$path');
    if (!await newDirectory.exists()) {
      await newDirectory.create(recursive: true);
      final file = File('${newDirectory.path}/${name}');
      await file.writeAsBytes(response.bodyBytes);
      setState(() {
        isDownloaded = false;
      });
    } else {
      final file = File('${newDirectory.path}/${name}');
      await file.writeAsBytes(response.bodyBytes);
      setState(() {
        isDownloaded = false;
      });
    }
  }

  String getFileName(String url) {
    final Uri uri = Uri.parse(url);
    final String fileName = uri.pathSegments.last;
    var name = fileName.split("/").last;

    if (url.startsWith('https://drive.google.com')) {
      name = url.split('/d/')[1].split('/')[0];
    }

    return name;
  }

  @override
  void initState() {
    // TODO: implement initState
    getPath();
    newQuestionsList = widget.unit.questions.split(";");
    newList = widget.unit.description.split(";");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final file = File("${folderPath}/pdfs/${getFileName(widget.unit.PDFLink)}");

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: widget.height * 10),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.size * 25),
              color: file.existsSync() & isExp
                  ? Colors.black.withOpacity(0.5)
                  : Colors.black.withOpacity(0.07),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: file.existsSync()
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(widget.size * 25),
                              child: SizedBox(
                                height: widget.height * 140,
                                width: double.infinity,
                                child: PDFView(
                                  filePath:
                                      "${folderPath}/pdfs/${getFileName(widget.unit.PDFLink)}",
                                  onRender: (_pages) {
                                    setState(() {
                                      pages = _pages!;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(widget.size * 25),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.black
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 15, top: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(widget.size * 25),
                                    color: Colors.black.withOpacity(0.8),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.5)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Pages : $pages",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      : Container(),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: widget.width * 15,
                      top: file.existsSync()
                          ? widget.height * 115
                          : widget.height * 3,
                      bottom: widget.height * 2,
                      right: widget.width * 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              widget.unit.heading,
                              style: TextStyle(
                                fontSize: widget.size * 20.0,
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: isExp ? 5 : 1,
                            ),
                          ),
                          if (widget.unit.description.isNotEmpty)
                            InkWell(
                              child: Text(
                                isExp ? "Read Less " : "Read More ",
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                setState(() {
                                  isExp = !isExp;
                                });
                              },
                            )
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: widget.height * 5),
                        child: Row(
                          children: [
                            if (!fullDescription || !isExp)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(widget.size * 8),
                                  color: Colors.white.withOpacity(0.07),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                widget.size * 8),
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            border: Border.all(
                                                color: file.existsSync()
                                                    ? Colors.green
                                                    : Colors.white),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: widget.width * 3,
                                                right: widget.width * 3),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: widget.width * 5,
                                                      right: widget.width * 5,
                                                      top: widget.height * 3,
                                                      bottom:
                                                          widget.height * 3),
                                                  child: Text(
                                                    file.existsSync()
                                                        ? "Open"
                                                        : "Download",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            widget.size * 20),
                                                  ),
                                                ),
                                                Icon(
                                                  file.existsSync()
                                                      ? Icons.open_in_new
                                                      : Icons
                                                          .download_for_offline_outlined,
                                                  color: Colors.greenAccent,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: () async {
                                          if (file.existsSync()) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PdfViewerPage(
                                                            pdfUrl:
                                                                "${folderPath}/pdfs/${getFileName(widget.unit.PDFLink)}")));
                                          } else {
                                            setState(() {
                                              isDownloaded = true;
                                            });
                                            await download(
                                                widget.unit.PDFLink, "pdfs");
                                          }
                                        }),
                                    if (file.existsSync())
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: widget.width * 5,
                                            right: widget.width * 5,
                                            top: widget.height * 1,
                                            bottom: widget.height * 1),
                                        child: InkWell(
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.redAccent,
                                            size: widget.size * 25,
                                          ),
                                          onLongPress: () async {
                                            if (file.existsSync()) {
                                              await file.delete();
                                            }
                                            setState(() {});
                                            showToastText(
                                                "File has been deleted");
                                          },
                                          onTap: () {
                                            showToastText(
                                                "Long Press To Delete");
                                          },
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            if (isExp)
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: widget.width * 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          widget.height * 5),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              widget.size * 20),
                                                      color: Colors.white
                                                          .withOpacity(0.09),
                                                      border: Border.all(
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.5)),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          widget.size * 5.0),
                                                      child: Text(
                                                        fullDescription
                                                            ? "collapse"
                                                            : "Expand",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .lightBlueAccent,
                                                            fontSize:
                                                                widget.size *
                                                                    20),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    fullDescription =
                                                        !fullDescription;
                                                  });
                                                },
                                              ),
                                              if (widget
                                                  .unit.questions.isNotEmpty)
                                                InkWell(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom:
                                                            widget.height * 5),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(widget
                                                                        .size *
                                                                    20),
                                                        color: Colors.white
                                                            .withOpacity(0.09),
                                                        border: Border.all(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.5)),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            widget.size * 5.0),
                                                        child: Text(
                                                          isQuestions
                                                              ? "Hide"
                                                              : "Questions",
                                                          style: TextStyle(
                                                              color: isQuestions
                                                                  ? Colors
                                                                      .redAccent
                                                                  : Colors
                                                                      .lightGreenAccent,
                                                              fontSize:
                                                                  widget.size *
                                                                      20),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      isQuestions =
                                                          !isQuestions;
                                                    });
                                                  },
                                                ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: widget.width * 11,
                                                top: widget.height * 5,
                                                bottom: widget.height * 5),
                                            child: Text(
                                              "File Description...",
                                              style: TextStyle(
                                                  color: Colors.orangeAccent,
                                                  fontSize: widget.size * 25),
                                            ),
                                          ),
                                          ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: newList.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                if (newList.length > 1) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom:
                                                            widget.height * 8),
                                                    child: InkWell(
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.circle,
                                                            size:
                                                                widget.size * 8,
                                                            color: Colors
                                                                .lightBlueAccent,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              isUser()
                                                                  ? newList[
                                                                      index]
                                                                  : newList[
                                                                          index]
                                                                      .split(
                                                                          "@")
                                                                      .first,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white70,
                                                                  fontSize:
                                                                      widget.size *
                                                                          18),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      onTap: () {
                                                        int indexNumber = 0;
                                                        try {
                                                          indexNumber =
                                                              int.parse(
                                                                  newList[index]
                                                                      .split(
                                                                          '@')
                                                                      .last
                                                                      .trim());
                                                        } catch (e) {
                                                          indexNumber = 0;
                                                        }
                                                        if (file.existsSync()) {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          PdfViewerPage(
                                                                            pdfUrl:
                                                                                "${folderPath}/pdfs/${getFileName(widget.unit.PDFLink)}",
                                                                            defaultPage:
                                                                                indexNumber - 1,
                                                                          )));
                                                        } else {
                                                          showToastText(
                                                              "Download PDF");
                                                        }
                                                      },
                                                    ),
                                                  );
                                                } else {
                                                  return Center(
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          widget.size * 8.0),
                                                      child: Text(
                                                        newList[0],
                                                        style: TextStyle(
                                                            color: Colors
                                                                .amberAccent,
                                                            fontSize:
                                                                widget.size *
                                                                    18),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              })
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (isQuestions)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: widget.width * 15,
                                  bottom: widget.height * 10),
                              child: Text(
                                "Questions...",
                                style: TextStyle(
                                    color: Colors.orangeAccent,
                                    fontSize: widget.size * 25),
                              ),
                            ),
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: newQuestionsList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (newQuestionsList.length > 1) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: widget.height * 8),
                                      child: InkWell(
                                        child: Row(
                                          children: [
                                            Text("${index + 1}. ",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        widget.size * 18)),
                                            Expanded(
                                              child: Text(
                                                isUser()
                                                    ? newQuestionsList[index]
                                                    : newQuestionsList[index]
                                                        .split("@")
                                                        .first,
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: widget.size * 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          int indexNumber = 0;
                                          try {
                                            indexNumber = int.parse(
                                                newQuestionsList[index]
                                                    .split('@')
                                                    .last
                                                    .trim());
                                          } catch (e) {
                                            indexNumber = 0;
                                          }
                                          if (file.existsSync()) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PdfViewerPage(
                                                          pdfUrl:
                                                              "${folderPath}/pdfs/${getFileName(widget.unit.PDFLink)}",
                                                          defaultPage:
                                                              indexNumber - 1,
                                                        )));
                                          } else {
                                            showToastText("Download PDF");
                                          }
                                        },
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(widget.size * 8.0),
                                        child: Text(
                                          newQuestionsList[0],
                                          style: TextStyle(
                                              color: Colors.amberAccent,
                                              fontSize: widget.size * 18),
                                        ),
                                      ),
                                    );
                                  }
                                }),
                          ],
                        ),
                      if (isUser())
                        Row(
                          children: [
                            InkWell(
                              child: Chip(
                                elevation: 20,
                                backgroundColor: Colors.black,
                                avatar: CircleAvatar(
                                    backgroundColor: Colors.black45,
                                    child: Icon(
                                      Icons.edit_outlined,
                                    )),
                                label: Text(
                                  "Edit",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UnitsCreator(
                                              branch: widget.branch,
                                              mode: widget.mode,
                                              UnitId: widget.ID,
                                              id: widget.unit.id,
                                              Heading: widget.unit.heading,
                                              Description:
                                                  widget.unit.description,
                                              questions: widget.unit.questions,
                                              PDFSize: widget.unit.PDFSize,
                                              PDFUrl: widget.unit.PDFLink,
                                            )));
                              },
                            ),
                            InkWell(
                              child: Chip(
                                elevation: 20,
                                backgroundColor: Colors.black,
                                avatar: CircleAvatar(
                                    backgroundColor: Colors.black45,
                                    child: Icon(
                                      Icons.delete_rounded,
                                    )),
                                label: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              onLongPress: () {
                                final deleteFlashNews = FirebaseFirestore
                                    .instance
                                    .collection(widget.branch)
                                    .doc(widget.mode)
                                    .collection(widget.mode)
                                    .doc(widget.ID)
                                    .collection("Units")
                                    .doc(widget.unit.id);
                                deleteFlashNews.delete();
                                pushNotificationsSpecificPerson(
                                    fullUserId(),
                                    "${widget.unit.heading} Unit is deleted from ${widget.mode}",
                                    "");
                              },
                              onTap: () {
                                showToastText("Long Press to Delete");
                              },
                            ),
                          ],
                        ),
                      if (isDownloaded) LinearProgressIndicator()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            bottom: widget.height * -20,
            right: widget.width * 40,
            child: Transform.translate(
              offset: Offset(20, -20),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(widget.size * 13)),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(widget.size * 13),
                      border: Border.all(color: Colors.white.withOpacity(0.3))),
                  padding: EdgeInsets.all(widget.size * 3),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: widget.unit.likedBy.contains(user0Id())
                                  ? Colors.redAccent
                                  : Colors.white,
                              size: widget.size * 18,
                            ),
                            Text(
                              widget.unit.likedBy.length > 0
                                  ? " ${widget.unit.likedBy.length}+ "
                                  : " ${widget.unit.likedBy.length} ",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        onTap: () {
                          like();
                        },
                      ),
                      Text(
                        " ~ ${widget.unit.PDFSize} ",
                        style: TextStyle(color: Colors.lightBlueAccent),
                      ),
                      Text(
                        " ${widget.unit.Date}",
                        style: TextStyle(color: Colors.white60),
                      ),
                    ],
                  ),
                ),
              ),
            ))
      ],
    );
  }

  void like() {
    FirebaseFirestore.instance
        .collection(widget.branch)
        .doc(widget.mode)
        .collection(widget.mode)
        .doc(widget.ID)
        .collection("Units")
        .doc(widget.unit.id)
        .update({
      "likedBy": !widget.unit.likedBy.contains(user0Id())
          ? FieldValue.arrayUnion([user0Id()])
          : FieldValue.arrayRemove([user0Id()]),
    });
  }
}

class updatesPage extends StatefulWidget {
  final String branch;
  final double size;
  final double height;
  final double width;


  const updatesPage(
      {Key? key,
      required this.branch,
      required this.width,
      required this.size,
      required this.height})
      : super(key: key);

  @override
  State<updatesPage> createState() => _updatesPageState();
}

class _updatesPageState extends State<updatesPage> {
  bool isBranch = false;
String folderPath='';
  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      getPath();
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: widget.height * 40),
            child: StreamBuilder<List<UpdateConvertor>>(
                stream: readUpdate(widget.branch),
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
                                'Error with TextBooks Data or\n Check Internet Connection'));
                      } else {
                        if (BranchNews!.length == 0) {
                          return Center(
                              child: Text(
                                "No Updates",
                                style: TextStyle(color: Colors.lightBlueAccent),
                              ));
                        } else
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: BranchNews.length,
                            itemBuilder: (context, int index) {
                              final filteredUpdates =
                              BranchNews.where((update) {
                                if (isBranch) {
                                  return update.branch == widget.branch;
                                } else {
                                  return update.heading != "all";
                                }
                              }).toList();

                              if (filteredUpdates.length <= index) {
                                return SizedBox.shrink();
                              }
                              final BranchNew = BranchNews[index];
                              final Uri uri = Uri.parse(BranchNew.photoUrl);
                              final String fileName = uri.pathSegments.last;
                              var name = fileName.split("/").last;
                              final file =
                              File("${folderPath}/updates/$name");
                              if (!file.existsSync()) {
                                download(BranchNew.photoUrl, folderPath);
                              }

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: widget.height * 2,
                                    horizontal: widget.width * 8),
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(1, 56, 69, 1),
                                      borderRadius: BorderRadius.circular(
                                          widget.size * 15),
                                      border:
                                      Border.all(color: Colors.white10)),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: widget.width * 35,
                                            height: widget.height * 35,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  widget.size * 17),
                                              image: DecorationImage(
                                                image: FileImage(file),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                  widget.width * 5),
                                              child: Text(
                                                BranchNew.heading,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                    widget.size * 20,
                                                    fontWeight:
                                                    FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: widget.width * 45,
                                            right: widget.width * 10,
                                            bottom: widget.height * 5),
                                        child: Row(
                                          children: [
                                            Text(
                                              BranchNew.description,
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: widget.size * 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: widget.width * 40,
                                            right: widget.width * 10),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.favorite,
                                                    color: BranchNew.likedBy
                                                        .contains(
                                                        user0Id())
                                                        ? Colors.redAccent
                                                        : Colors.white,
                                                    size: widget.size * 20,
                                                  ),
                                                  Text(
                                                    BranchNew.likedBy.length >
                                                        0
                                                        ? " ${BranchNew.likedBy.length} Likes"
                                                        : " ${BranchNew.likedBy.length} Like",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                        widget.size * 18),
                                                  )
                                                ],
                                              ),
                                              onTap: () {
                                                like(
                                                    !BranchNew.likedBy
                                                        .contains(user0Id()),
                                                    BranchNew.id);
                                              },
                                            ),
                                            if (BranchNew.link.isNotEmpty)
                                              InkWell(
                                                child: Text(
                                                  "Open (Link)",
                                                  style: TextStyle(
                                                      color: Colors
                                                          .lightBlueAccent),
                                                ),
                                                onTap: () {
                                                  ExternalLaunchUrl(
                                                      BranchNew.link);
                                                },
                                              ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: widget.height * 5),
                                              child: Text(
                                                BranchNew.date,
                                                style: TextStyle(
                                                    color: Colors.white38,
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
                              );
                            },
                          );
                      }
                  }
                }),
          ),
          Positioned(
              top: widget.height * 8,
              right: 0,
              left: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius:
                        BorderRadius.circular(widget.size * 8),
                        border: isBranch
                            ? Border.all(
                            color: Colors.green.withOpacity(0.8))
                            : Border.all(
                            color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: widget.width * 10,
                            right: widget.width * 10,
                            top: widget.height * 3,
                            bottom: widget.height * 3),
                        child: Text(
                          "Branch",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: widget.size * 18),
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        isBranch = !isBranch;
                      });
                    },
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
