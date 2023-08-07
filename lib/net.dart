// ignore_for_file: must_be_immutable, unnecessary_import
import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:srkr_study_app/SubPages.dart';
import 'package:srkr_study_app/notification.dart';
import 'package:srkr_study_app/settings.dart';
import 'package:srkr_study_app/srkr_page.dart';
import 'add subjects.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'functins.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  final String branch;
  final String reg;
  final int index;
  final double size;
  final double height;
  final double width;

  const HomePage(
      {Key? key,
        required this.branch,
        required this.reg,
        required this.index,
        required this.width,
        required this.size,
        required this.height})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  Widget build(BuildContext context) => SafeArea(
      child: Stack(
        children: [

          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.width * 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(50, 76, 82, 1),
                    borderRadius: BorderRadius.circular(widget.size * 15)),
                child: Padding(
                  padding: EdgeInsets.all(widget.size * 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          child: Padding(
                            padding: EdgeInsets.only(left: widget.size * 5),
                            child: Container(
                              height: widget.height * 35,
                              width: widget.width * 80,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(widget.size * 5),
                                  color: Colors.white.withOpacity(0.7),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "https://firebasestorage.googleapis.com/v0/b/e-srkr.appspot.com/o/logo.png?alt=media&token=f008662e-2638-4990-a010-2081c2f4631b"),
                                      fit: BoxFit.fill)),
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
                                    SRKRPage(),
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
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: widget.width * 30,
                              right: widget.width * 20),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(widget.size * 18),
                                color: Colors.black.withOpacity(0.7)),
                            child: Padding(
                              padding: EdgeInsets.all(widget.size * 7.0),
                              child: ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return RadialGradient(
                                    center: Alignment.topLeft,
                                    radius: 1.0,
                                    colors: <Color>[
                                      Colors.yellow,
                                      Colors.deepOrange.shade900
                                    ],
                                    tileMode: TileMode.mirror,
                                  ).createShader(bounds);
                                },
                                child: Text(
                                  "${widget.branch}",
                                  style: TextStyle(
                                      fontSize: widget.size * 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white38),
                                    borderRadius:
                                    BorderRadius.circular(widget.size * 20),
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
                      Row(
                        children: [
                          InkWell(
                              child: Padding(
                                padding:
                                EdgeInsets.only(right: widget.width * 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          widget.size * 13),
                                      color: Colors.white10),
                                  child: Padding(
                                    padding: EdgeInsets.all(widget.size * 4.0),
                                    child: Icon(
                                      Icons.notifications_active_outlined,
                                      color: Colors.white,
                                      size: widget.size * 30,
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
                                        notifications(
                                          width: widget.width,
                                          size: widget.size,
                                          height: widget.height,
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
                              }),
                          InkWell(
                              child: Padding(
                                padding:
                                EdgeInsets.only(right: widget.width * 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          widget.size * 13),
                                      color: Colors.white10),
                                  child: Padding(
                                    padding: EdgeInsets.all(widget.size * 4.0),
                                    child: Icon(
                                      Icons.person_outline,
                                      color: Colors.white,
                                      size: widget.size * 30,
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
                                        settings(
                                          width: widget.width,
                                          height: widget.height,
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
                                            duration:
                                            Duration(milliseconds: 300),
                                            opacity:
                                            animation.value.clamp(0.3, 1.0),
                                            child: fadeTransition),
                                      );
                                    },
                                  ),
                                );
                              }),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ));
}

class booksDownloadButton extends StatefulWidget {
  final String branch;
  final double size;
  final String pdfLink;
  final String path;

  final double height;
  final double width;
  const booksDownloadButton(
      {Key? key,
        required this.branch,
        required this.width,
        required this.size,
        required this.height,
        required this.pdfLink,
        required this.path})
      : super(key: key);

  @override
  State<booksDownloadButton> createState() => _booksDownloadButtonState();
}

class _booksDownloadButtonState extends State<booksDownloadButton> {
  bool isDownloaded = false;
  late File file1;
  String name1 = "";
  void getFile() {
    final Uri uri1 = Uri.parse(widget.pdfLink);
    String fileName1 = uri1.pathSegments.last;
    name1 = fileName1.split("/").last;
    file1 = File("${widget.path}/pdfs/$name1");

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFile();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.size * 8),
        color: Colors.white.withOpacity(0.07),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.size * 8),
                  color: Colors.black.withOpacity(0.5),
                  border: Border.all(
                      color: file1.existsSync() ? Colors.green : Colors.white),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: widget.width * 3),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: widget.height * 3,
                            horizontal: widget.width * 5),
                        child: Text(
                          file1.existsSync() ? "Open" : "Download",
                          style: TextStyle(
                              color: Colors.white, fontSize: widget.size * 20),
                        ),
                      ),
                      !isDownloaded
                          ? Icon(
                        file1.existsSync()
                            ? Icons.open_in_new
                            : Icons.download_for_offline_outlined,
                        color: Colors.greenAccent,
                      )
                          : SizedBox(
                          height: widget.height * 20,
                          width: widget.width * 20,
                          child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ),
              onTap: () async {
                if (file1.existsSync()) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PdfViewerPage(
                              pdfUrl: "${widget.path}/pdfs/${name1}")));
                } else {
                  setState(() {
                    isDownloaded = true;
                  });
                  showToastText("Downloading...");
                  await download(widget.pdfLink, "pdfs");
                  setState(() {
                    isDownloaded = false;
                    showToastText("Downloaded");
                  });
                }
              }),
          if (file1.existsSync())
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: widget.width * 5, vertical: widget.height * 1),
              child: InkWell(
                child: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                  size: widget.size * 25,
                ),
                onTap: () async {
                  if (file1.existsSync()) {
                    await file1.delete();
                  }
                  setState(() {});
                  showToastText("File has been deleted");
                },
              ),
            )
        ],
      ),
    );
  }
}

class homePageUpdate extends StatefulWidget {
  final String branch;
  final String path;
  final double size;
  final double height;
  final double width;

  const homePageUpdate(
      {Key? key,
        required this.branch,
        required this.width,
        required this.size,
        required this.height,
        required this.path})
      : super(key: key);

  @override
  State<homePageUpdate> createState() => _homePageUpdateState();
}

class _homePageUpdateState extends State<homePageUpdate> {
  bool isBranch = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height * 149,
      child: StreamBuilder<List<UpdateConvertor>>(
          stream: readUpdate(widget.branch),
          builder: (context, snapshot) {
            final Updates = snapshot.data;
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
                          'Error with updates Data or\n Check Internet Connection'));
                } else {
                  if (Updates!.length == 0) {
                    return Container();
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: widget.height * 10,
                              horizontal: widget.width * 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Updates",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.size * 30,
                                    fontWeight: FontWeight.w500),
                              ),
                              InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius:
                                    BorderRadius.circular(widget.size * 8),
                                    border: isBranch
                                        ? Border.all(
                                        color:
                                        Colors.green.withOpacity(0.8))
                                        : Border.all(
                                        color:
                                        Colors.white.withOpacity(0.3)),
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
                              InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(widget.size * 8),
                                    color: Colors.black.withOpacity(0.7),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.3)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: widget.width * 10,
                                        right: widget.width * 10,
                                        top: widget.height * 5,
                                        bottom: widget.height * 5),
                                    child: Text(
                                      "See More",
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
                                      transitionDuration:
                                      const Duration(milliseconds: 300),
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                          updatesPage(
                                            width: widget.width,
                                            height: widget.height,
                                            size: widget.size,
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
                        ),
                        Container(
                          height: widget.height * 95,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: min(
                                Updates.length, 5), // Display only top 5 items
                            itemBuilder: (context, int index) {
                              final filteredUpdates = Updates.where((update) {
                                if (isBranch) {
                                  return update.branch == widget.branch;
                                } else {
                                  return update.heading != "all";
                                }
                              }).toList();

                              if (filteredUpdates.length <= index) {
                                return SizedBox.shrink();
                              }

                              final BranchNew = filteredUpdates[index];
                              final Uri uri = Uri.parse(BranchNew.photoUrl);
                              final String fileName = uri.pathSegments.last;
                              var name = fileName.split("/").last;
                              final file = File("${widget.path}/updates/$name");

                              return Padding(
                                padding:
                                EdgeInsets.only(left: widget.width * 10),
                                child: InkWell(
                                  child: Container(
                                    padding: EdgeInsets.all(widget.size * 5),
                                    width: screenWidth(context) / 1.35,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(
                                          widget.size * 15),
                                      border: Border.all(color: Colors.white10),
                                    ),
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
                                  onLongPress: () {
                                    if (isUser()) {
                                      final deleteFlashNews = FirebaseFirestore
                                          .instance
                                          .collection("update")
                                          .doc(BranchNew.id);
                                      deleteFlashNews.delete();
                                    }
                                  },
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
          }),
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
  required String heading,
  required String photoUrl,
  required link,
  required String branch,
  required String description,
}) async {
  final docflash = FirebaseFirestore.instance.collection("update").doc(getID());

  final flash = UpdateConvertor(
      id: getID(),
      heading: heading,
      branch: branch,
      description: description,
      date: getDate(),
      photoUrl: photoUrl,
      link: link);
  final json = flash.toJson();
  await docflash.set(json);
}

class UpdateConvertor {
  String id;
  final String heading, photoUrl, date, link, description, branch;
  List<String> likedBy;

  UpdateConvertor({
    this.id = "",
    required this.heading,
    required this.date,
    required this.photoUrl,
    required this.link,
    required this.branch,
    required this.description,
    List<String>? likedBy,
  }) : likedBy = likedBy ?? [];

  Map<String, dynamic> toJson() => {
    "id": id,
    "heading": heading,
    "date": date,
    "photoUrl": photoUrl,
    "link": link,
    "likedBy": likedBy,
    "description": description,
    "branch": branch,
  };

  static UpdateConvertor fromJson(Map<String, dynamic> json) => UpdateConvertor(
    id: json['id'],
    heading: json["heading"],
    date: json["date"],
    photoUrl: json["photoUrl"],
    link: json["link"],
    description: json["description"],
    branch: json["branch"],
    likedBy:
    json["likedBy"] != null ? List<String>.from(json["likedBy"]) : [],
  );
}

Stream<List<RegulationConvertor>> readRegulation(String branch) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("regulation")
        .collection("regulation")
        .orderBy("id", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => RegulationConvertor.fromJson(doc.data()))
        .toList());

Future createRegulation({required String name, required String branch}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc("regulation")
      .collection("regulation")
      .doc(name);
  final flash = RegulationConvertor(id: name);
  final json = flash.toJson();
  await docflash.set(json);
}

class RegulationConvertor {
  String id;

  RegulationConvertor({this.id = ""});

  Map<String, dynamic> toJson() => {"id": id};

  static RegulationConvertor fromJson(Map<String, dynamic> json) =>
      RegulationConvertor(id: json['id']);
}

Stream<List<TimeTableConvertor>> readTimeTable(
    {required String reg, required String branch}) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("regulation")
        .collection("regulation")
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
      required String reg,
      required String id1}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc("regulation")
      .collection("regulation")
      .doc(reg)
      .collection("timeTables")
      .doc();
  final flash =
  TimeTableConvertor(id: docflash.id, heading: heading, photoUrl: photoUrl);
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
    {required String heading,
      required String description,
      required String branch,
      required String Date,
      required String photoUrl}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc("${branch}News")
      .collection("${branch}News")
      .doc();
  final flash = BranchNewConvertor(
      id: docflash.id,
      heading: heading,
      photoUrl: photoUrl,
      description: description,
      Date: Date,
      link: "");
  final json = flash.toJson();
  await docflash.set(json);
}

class BranchNewConvertor {
  String id;
  final String heading, photoUrl, description, Date, link;

  BranchNewConvertor(
      {this.id = "",
        required this.heading,
        required this.photoUrl,
        required this.description,
        required this.Date,
        required this.link});

  Map<String, dynamic> toJson() => {
    "id": id,
    "Heading": heading,
    "Photo Url": photoUrl,
    "Description": description,
    "Date": Date,
    "link": link
  };

  static BranchNewConvertor fromJson(Map<String, dynamic> json) =>
      BranchNewConvertor(
          id: json['id'],
          heading: json["Heading"],
          photoUrl: json["Photo Url"],
          description: json["Description"],
          Date: json["Date"],
          link: json['link']);
}

Stream<List<FlashConvertor>> readFlashNews(String branch) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("Subjects")
        .collection("Subjects")
        .orderBy("Heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => FlashConvertor.fromJson(doc.data()))
        .toList());

Future createSubjects(
    {required String heading,
      required String branch,
      required String description,
      required String date,
      required String PhotoUrl,
      required String regulation}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc("Subjects")
      .collection("Subjects")
      .doc();
  final flash = FlashConvertor(
      id: docflash.id,
      heading: heading,
      PhotoUrl: PhotoUrl,
      description: description,
      Date: date,
      regulation: regulation);
  final json = flash.toJson();
  await docflash.set(json);
}

class FlashConvertor {
  String id;
  final String heading, PhotoUrl, description, Date, regulation;

  FlashConvertor(
      {this.id = "",
        required this.regulation,
        required this.heading,
        required this.PhotoUrl,
        required this.description,
        required this.Date});

  Map<String, dynamic> toJson() => {
    "id": id,
    "Heading": heading,
    "Date": Date,
    "Description": description,
    "Photo Url": PhotoUrl,
    "regulation": regulation
  };

  static FlashConvertor fromJson(Map<String, dynamic> json) => FlashConvertor(
      id: json['id'],
      regulation: json["regulation"],
      heading: json["Heading"],
      PhotoUrl: json["Photo Url"],
      description: json["Description"],
      Date: json["Date"]);
}

Stream<List<LabSubjectsConvertor>> readLabSubjects(String branch) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("LabSubjects")
        .collection("LabSubjects")
        .orderBy("Heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => LabSubjectsConvertor.fromJson(doc.data()))
        .toList());

Future createLabSubjects(
    {required String branch,
      required String heading,
      required String description,
      required String Date,
      required String PhotoUrl,
      required String regulation}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc("LabSubjects")
      .collection("LabSubjects")
      .doc();
  final flash = LabSubjectsConvertor(
      id: docflash.id,
      heading: heading,
      PhotoUrl: PhotoUrl,
      description: description,
      Date: Date,
      regulation: regulation);
  final json = flash.toJson();
  await docflash.set(json);
}

class LabSubjectsConvertor {
  String id;
  final String heading, PhotoUrl, description, Date, regulation;

  LabSubjectsConvertor(
      {this.id = "",
        required this.heading,
        required this.PhotoUrl,
        required this.description,
        required this.Date,
        required this.regulation});

  Map<String, dynamic> toJson() => {
    "id": id,
    "Heading": heading,
    "Photo Url": PhotoUrl,
    "Description": description,
    "Date": Date,
    "regulation": regulation,
  };

  static LabSubjectsConvertor fromJson(Map<String, dynamic> json) =>
      LabSubjectsConvertor(
          regulation: json["regulation"],
          id: json['id'],
          heading: json["Heading"],
          PhotoUrl: json["Photo Url"],
          description: json["Description"],
          Date: json["Date"]);
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
      required String Author,
      required String date}) async {
  final docBook = FirebaseFirestore.instance
      .collection(branch)
      .doc("Books")
      .collection("CoreBooks")
      .doc();
  final Book = BooksConvertor(
      id: docBook.id,
      heading: heading,
      link: link,
      description: description,
      photoUrl: photoUrl,
      Author: Author,
      edition: edition,
      date: date);
  final json = Book.toJson();
  await docBook.set(json);
}

class BooksConvertor {
  String id;
  final String heading, link, description, photoUrl, edition, Author, date;

  BooksConvertor(
      {this.id = "",
        required this.heading,
        required this.link,
        required this.description,
        required this.photoUrl,
        required this.edition,
        required this.Author,
        required this.date});

  Map<String, dynamic> toJson() => {
    "id": id,
    "Heading": heading,
    "Link": link,
    "Description": description,
    "Photo Url": photoUrl,
    "Author": Author,
    "Edition": edition,
    "Date": date
  };

  static BooksConvertor fromJson(Map<String, dynamic> json) => BooksConvertor(
    id: json['id'],
    heading: json["Heading"],
    link: json["Link"],
    description: json["Description"],
    photoUrl: json["Photo Url"],
    Author: json["Author"],
    date: json["Date"],
    edition: json["Edition"],
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
        body: Column(
          children: [
            Flexible(
              flex: 10,
              child: PhotoView(
                imageProvider: FileImage(widget.file),
              ),
            ),
          ],
        ));
  }
}