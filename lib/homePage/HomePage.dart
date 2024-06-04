// ignore_for_file: must_be_immutable, unnecessary_import
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:srkr_study_app/SubPages.dart';
import 'package:srkr_study_app/auth_page.dart';
import 'package:srkr_study_app/settings/settings.dart';
import 'package:srkr_study_app/search%20bar.dart';
import '../events.dart';
import '../favorites.dart';
import '../feedback form.dart';
import '../functions.dart';
import '../net.dart';
import '../poll/create_poll.dart';
import '../poll/polling_page.dart';
import '../sendMeFiles.dart';
import '../subjects/subjects.dart';
import '../get_all_data.dart';
import '../syllabus_model_papers/syllabusModelPaper.dart';
import '../uploader.dart';
import '../Notifications_and_messages/UpdatesAndNotification.dart';

class HomePage extends StatefulWidget {
  BranchStudyMaterialsConverter? data;

  HomePage({required this.data});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Widget icon(IconData? data) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(data,color: Colors.white70,));
  }


  List tabBar0List = ["Events","Uploader","Polling","TTS"];



  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.only(
                  left: 5.0, right: 5, top: 8, bottom: 2),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => settings(),
                          ),
                        );
                      },
                      child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          padding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.white30)),
                          child: Icon(
                            Icons.person,
                            size: 35,
                            color: Colors.white70,
                          ))),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        ExternalLaunchUrl("https://srkrec.edu.in/");
                        // changeTab(2);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome ${auth.currentUser!.displayName != null ? auth.currentUser!.displayName!.split(";").first : fullUserId().toString().split("@").first},",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white54,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "eSRKR",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                " - eBooks",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsUpdates(
                                branch: getBranch(fullUserId())),
                          ),
                        );
                      },
                      child: icon(Icons.notifications))
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              BranchStudyMaterialsConverter? data =
                                  await getBranchStudyMaterials(false);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchPage(
                                      data: data!,
                                    ),
                                  ));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color:
                                          Colors.black.withOpacity(0.2))),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.white54,
                                      size: 30,
                                    ),
                                  ),
                                  Text(
                                    "Search Here...",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      favoritesSubjects(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Icon(
                                Icons.favorite,
                                size: 25,
                                color: Colors.white54,
                              ),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 35,
                      child: ListView.builder(
                          itemCount: tabBar0List.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, int index) {
                            return InkWell(
                              onTap: () {
                                if (index == 0)
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => eventsPage(branch: getBranch(fullUserId()),)));

                                if (index == 1)
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Scaffold(
                                              body: SingleChildScrollView(
                                                child: SafeArea(
                                                  child: Column(

                                                    children: [
                                                      backButton(),
                                                      SendMeFiles(),
                                                    ],
                                                  ),
                                                ),
                                              ))));
                                if (index == 2)
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Scaffold(
                                              body: SingleChildScrollView(
                                                child:  SafeArea(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      backButton(),
                                                      Heading(heading: "Polling"),
                                                      if(isGmail()||isOwner()) Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Expanded(child: Text("Create Poll( testing )",style: TextStyle(color: Colors.white),)),
                                                            ElevatedButton(
                                                              onPressed: () {

                                                                Navigator.push(context,
                                                                    MaterialPageRoute(builder: (context) => CreatePollPage()));
                                                              },
                                                              child: const Text("Create",style: TextStyle(color: Colors.white),),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      StreamBuilder<QuerySnapshot>(
                                                        stream: FirebaseFirestore.instance.collection('polls').snapshots(),
                                                        builder: (context, snapshot) {
                                                          if (!snapshot.hasData) {
                                                            return const Center(
                                                              child: CircularProgressIndicator(),
                                                            );
                                                          }

                                                          return ListView.builder(
                                                            shrinkWrap: true,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            itemCount: snapshot.data!.docs.length,
                                                            itemBuilder: (BuildContext context, int index) {
                                                              final DocumentSnapshot pollSnapshot = snapshot.data!.docs[index];

                                                              return PollContainer(pollSnapshot: pollSnapshot);
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ))));
                                if (index == 3)
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TTS()));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 0),
                                margin: EdgeInsets.only(
                                    left: index == 0 ? 15 : 5,top: 3),
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    color: Colors.grey.withOpacity(0.2),
                                    border: Border.all(
                                        color: Colors.black26)),
                                alignment: Alignment.center,
                                child: Text(
                                  tabBar0List[index],
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            );
                          }),
                    ),

                    if (widget.data!.homePageImages.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: scrollingImages(
                          images: widget.data!.homePageImages
                              .map((subject) => subject.url)
                              .toList(),
                          id: "HomePageImages",
                          isZoom: true,
                          ar: AspectRatio(
                            aspectRatio: 16 / 5,
                          ),
                          token: sub_esrkr,
                        ),
                      ),
                    Heading(
                      heading: "Study Materials",
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 8, top: 20,bottom: 5),
                    ),

                    SizedBox(height: 10,),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SyllabusAndModelPaper(
                                      data: widget
                                          .data!.syllabusModelPapers,
                                    )));
                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white10,borderRadius: BorderRadius.circular(15),border: Border.all(color: Colors.white12)),
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Heading(heading: "Syllabus & Model Paper"),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                "see more",
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Heading(
                            heading: "Subjects",
                            padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15,
                                top: 10,
                                bottom: 5)),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Subjects(
                                          subjects: widget.data!.subjects,
                                          mode: true,
                                        )));
                          },
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "see more",
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.data!.subjects.isNotEmpty)
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                min(3, widget.data!.subjects.length),
                            itemBuilder: (context, int index) {
                              final data = widget.data!.subjects[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              subjectUnitsData(
                                                mode: true,
                                                data: data,
                                              )));
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: index == 0 ? 12.0 : 8),
                                  child: subjectContainer(data),
                                ),
                              );
                            }),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Heading(heading: "Lab Subjects"),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Subjects(
                                          subjects:
                                              widget.data!.labSubjects,
                                          mode: false,
                                        )));
                          },
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "see more",
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.data!.labSubjects.isNotEmpty)
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                min(3, widget.data!.labSubjects.length),
                            itemBuilder: (context, int index) {
                              final data =
                                  widget.data!.labSubjects[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              subjectUnitsData(
                                                mode: false,
                                                data: data,
                                              )));
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: index == 0 ? 12.0 : 8),
                                  child: subjectContainer(data),
                                ),
                              );
                            }),
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Heading(heading: "Books"),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => allBooks(
                                              books: widget.data!.books,
                                            )));
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                  "see more",
                                  style: TextStyle(color: Colors.orange),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (widget.data!.books.isNotEmpty)
                          SizedBox(
                            height: 240,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    min(3, widget.data!.books.length),
                                itemBuilder: (context, int index) {
                                  final data = widget.data!.books[index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: index == 0 ? 10.0 : 0),
                                    child: pdfContainer(data: data),
                                  );
                                }),
                          ),
                      ],
                    ),
                    StreamBuilder<List<FileUploader>>(
                        stream: readSoftwareRouteMap(),
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
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Heading(
                                            heading:
                                                "Software Route Maps"),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AskAi(
                                                          data: Books!,
                                                        )));
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Text(
                                              "see more",
                                              style: TextStyle(
                                                  color: Colors.orange),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (Books!.isNotEmpty)
                                      SizedBox(
                                        height: 240,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection:
                                                Axis.horizontal,
                                            itemCount:
                                                min(3, Books.length),
                                            itemBuilder:
                                                (context, int index) {
                                              final data = Books[index];
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    left: index == 0
                                                        ? 10.0
                                                        : 0),
                                                child: pdfContainer(
                                                    data: data),
                                              );
                                            }),
                                      ),
                                  ],
                                );
                              }
                          }
                        }),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: Column(
                          children: [
                            Text(
                              "Feedback Form",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              "If you encounter any issues or have additional feedback, please feel free to share.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              " Thank You. ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
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
                            pageBuilder: (context, animation,
                                    secondaryAnimation) =>
                                MyApp000(),
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
                      height: 100,
                    )
                  ],
                ),
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

Stream<List<FileUploader>> readSoftwareRouteMap() => FirebaseFirestore.instance
    .collection("softwareRouteMap")
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => FileUploader.fromJson(doc.data())).toList());
