// ignore_for_file: camel_case_types, non_constant_identifier_names, must_be_immutable
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:srkr_study_app/TextField.dart';
import 'package:srkr_study_app/HomePage.dart';
import 'package:srkr_study_app/settings.dart';
import 'add subjects.dart';
import 'package:flutter/material.dart';
import 'favorites.dart';
import 'functins.dart';
import 'package:http/http.dart' as http;

import 'main.dart';
import 'notification.dart';
class favorites extends StatefulWidget {
  double size;
   favorites({required this.size});

  @override
  State<favorites> createState() => _favoritesState();
}

class _favoritesState extends State<favorites> {
  @override
  Widget build(BuildContext context) {
    double Size = size(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              backButton(size: Size,text: "Favorites", child: SizedBox()),
              StreamBuilder<List<FavouriteSubjectsConvertor>>(
                stream: readFavouriteSubjects(),
                builder: (context, snapshot1) {
                  final favourites1 = snapshot1.data;

                  return StreamBuilder<
                      List<FavouriteSubjectsConvertor>>(
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
                            if (favourites1 != null &&
                                favourites1.isNotEmpty)
                              ListView.separated(
                                  itemCount: favourites1.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (context, int index) {
                                    final Favourite =
                                    favourites1[index];
                                    return InkWell(
                                      child: Container(
                                        child:Column(
                                          children: [
                                            Text(Favourite.name.split(";").first,style: TextStyle(color: Colors.white),)
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    subjectUnitsData(
                                                      creator:
                                                      Favourite
                                                          .creator,
                                                      reg: Favourite
                                                          .regulation,
                                                      size: widget
                                                          .size,
                                                      branch:
                                                      Favourite
                                                          .branch,
                                                      ID: Favourite
                                                          .id,
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
                                    height: widget.size * 6,
                                  )),
                            if (favourites2 != null &&
                                favourites2.isNotEmpty)
                              ListView.separated(
                                  itemCount: favourites2.length,
                                  shrinkWrap: true,
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
                                                  top: Size *
                                                      10.0,
                                                  right:
                                                  Size * 9),
                                              decoration: BoxDecoration(
                                                  color: Colors
                                                      .white12,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(
                                                          widget.size *
                                                              20))),
                                              child: Padding(
                                                padding: EdgeInsets
                                                    .symmetric(
                                                    vertical:
                                                    Size *
                                                        10,
                                                    horizontal:
                                                    Size *
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
                                                          .id,
                                                      mode:
                                                      "LabSubjects",
                                                      name:
                                                      Favourite
                                                          .name,
                                                      description:
                                                      Favourite
                                                          .description,
                                                      creator:
                                                      Favourite
                                                          .creator,
                                                    )));
                                      },
                                    );
                                  },
                                  separatorBuilder:
                                      (context, index) => SizedBox(
                                    width: widget.size * 6,
                                  )),
                          ],
                        );
                      } else {
                        return Container(); // No data, don't show anything
                      }
                    },
                  );
                },
              ),

          ],
          ),
        ),
      ),
    );
  }
}

class TimeTables extends StatefulWidget {
  String branch;
  String reg;
  double size;

  TimeTables({required this.branch, required this.size, required this.reg});

  @override
  State<TimeTables> createState() => _TimeTablesState();
}

class _TimeTablesState extends State<TimeTables> {
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


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            backButton(
                size: widget.size,
                text: "Time Tables",
                child: isGmail()||isOwner()
                    ? InkWell(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: widget.size * 40,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => timeTableSyllabusModalPaperCreator(
                                        size: widget.size,
                                        mode: 'Time Table',
                                        reg: widget.reg,
                                        branch: widget.branch,
                                      )));
                        },
                      )
                    : SizedBox(
                        width: widget.size * 45,
                      )),
            StreamBuilder<List<TimeTableConvertor>>(
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
                        return const Center(child: Text('Error with Time Table Data or\n Check Internet Connection'));
                      } else {
                        if (BranchNews!.length == 0) {
                          return Center(
                              child: Text(
                            "No Time Tables",
                            style: TextStyle(color: Colors.amber),
                          ));
                        } else
                          return Padding(
                            padding: EdgeInsets.all(widget.size * 8.0),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: BranchNews.length,
                              itemBuilder: (context, int index) {
                                var data = BranchNews[index];
                                file = File("");
                                if (data.photoUrl.isNotEmpty) {
                                  final Uri uri = Uri.parse(data.photoUrl);
                                  final String fileName = uri.pathSegments.last;
                                  var name = fileName.split("/").last;
                                  file = File("${folderPath}/timetable/$name");
                                }
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: widget.size * 5, vertical: widget.size * 5),
                                  child: InkWell(
                                    child: AspectRatio(
                                      aspectRatio: (widget.size * 16) / (widget.size * 9),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            image:
                                                DecorationImage(image: FileImage(file), fit: BoxFit.cover),
                                            borderRadius: BorderRadius.circular(widget.size * 20),
                                            border: Border.all(color: Colors.white12)),
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(widget.size * 8.0),
                                                padding: EdgeInsets.all(widget.size * 5.0),
                                                decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.8),
                                                    borderRadius: BorderRadius.circular(widget.size * 20)),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "   ${data.heading.toUpperCase()}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: widget.size * 22,
                                                          fontWeight: FontWeight.w600),
                                                    ),
                                                    if (isGmail())
                                                      PopupMenuButton(
                                                        icon: Icon(
                                                          Icons.more_vert,
                                                          color: Colors.white,
                                                          size: widget.size * 20,
                                                        ),
                                                        // Callback that sets the selected popup menu item.
                                                        onSelected: (item) {
                                                          if (item == "edit") {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        timeTableSyllabusModalPaperCreator(
                                                                          size: widget.size,
                                                                          mode: 'Time Table',
                                                                          reg: widget.reg,
                                                                          branch: widget.branch,
                                                                          id: data.id,
                                                                          heading: data.heading,
                                                                          link: data.photoUrl,
                                                                        )));
                                                          } else if (item == "delete") {
                                                            FirebaseFirestore.instance
                                                                .collection(widget.branch)
                                                                .doc("regulation")
                                                                .collection("regulationWithSem")
                                                                .doc(widget.reg)
                                                                .collection("timeTables")
                                                                .doc(data.id)
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
                                                      )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ImageZoom(
                                                    size: widget.size,
                                                    url: data.photoUrl,
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
          ],
        ),
      ),
    ));
  }
}

class syllabusPage extends StatefulWidget {
  final String branch;
  final String reg;
  final double size;

  syllabusPage({
    Key? key,
    required this.branch,
    required this.reg,
    required this.size,
  }) : super(key: key);

  @override
  State<syllabusPage> createState() => _syllabusPageState();
}

class _syllabusPageState extends State<syllabusPage> {
  bool isLoading = true;
  bool isDownloaded = false;
  String folderPath = "";

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
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
    }
    final file = File('${newDirectory.path}/${name}');
    await file.writeAsBytes(response.bodyBytes);
    setState(() {
      isDownloaded = false;
    });
  }

  String getFileName(String url) {
    var name;
    if (url.startsWith('https://drive.google.com')) {
      name = url.split('/d/')[1].split('/')[0];
    } else {
      final Uri uri = Uri.parse(url);
      final String fileName = uri.pathSegments.last;
      name = fileName.split("/").last;
    }

    return name;
  }

  @override
  void initState() {
    getPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            backButton(
                size: widget.size,
                text: "Syllabus",
                child: SizedBox(
                  width: widget.size * 45,
                )),
            StreamBuilder<List<syllabusConvertor>>(
                stream: readsyllabus(branch: widget.branch),
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
                        return const Center(child: Text('Error with Syllabus Data or\n Check Internet Connection'));
                      } else {
                        if (BranchNews!.length == 0) {
                          return Center(
                              child: Text(
                            "No Syllabus",
                            style: TextStyle(color: Colors.lightBlueAccent),
                          ));
                        } else
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: BranchNews.length,
                            itemBuilder: (context, int index) {
                              var data = BranchNews[index];
                              if (data.syllabus.isNotEmpty)
                                file = File("${folderPath}/pdfs/${getFileName(data.syllabus)}");

                              return Padding(
                                padding: EdgeInsets.only(
                                    left: widget.size * 15.0, right: widget.size * 10, top: widget.size * 4),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.black38,
                                      borderRadius: BorderRadius.all(Radius.circular(widget.size * 20))),
                                  child: SingleChildScrollView(
                                    child: Row(
                                      children: [
                                        if (data.syllabus.length > 3)
                                          file.existsSync() && data.syllabus.isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(widget.size * 25),
                                                  child: SizedBox(
                                                      height: widget.size * 160,
                                                      width: widget.size * 120,
                                                      child: isLoading
                                                          ? PDFView(
                                                              filePath:
                                                                  "${folderPath}/pdfs/${getFileName(data.syllabus)}",
                                                            )
                                                          : Container()),
                                                )
                                              : SizedBox(
                                                  height: widget.size * 98, child: Image.asset("assets/pdf_icon.png")),
                                        SizedBox(
                                          width: widget.size * 15,
                                        ),
                                        Expanded(
                                            child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  data.id.toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: widget.size * 20.0,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                if (data.syllabus.isEmpty)
                                                  Text(
                                                    "No Data",
                                                    style: TextStyle(
                                                      fontSize: widget.size * 20.0,
                                                      color: Colors.amber,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                if (isGmail()||isOwner())
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
                                                                builder: (context) =>
                                                                    timeTableSyllabusModalPaperCreator(
                                                                      size: widget.size,
                                                                      mode: 'syllabus',
                                                                      reg: widget.reg,
                                                                      branch: widget.branch,
                                                                      id: data.id,
                                                                      heading: data.id,
                                                                      link: data.syllabus,
                                                                    )));
                                                      } else if (item == "delete") {
                                                        FirebaseFirestore.instance
                                                            .collection(widget.branch)
                                                            .doc("regulation")
                                                            .collection("regulationWithYears")
                                                            .doc(data.id.substring(0, 10))
                                                            .update({"syllabus": ""});
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
                                            ),
                                            SizedBox(
                                              height: widget.size * 2,
                                            ),
                                            if (data.syllabus.isNotEmpty)
                                              Padding(
                                                padding: EdgeInsets.symmetric(vertical: widget.size * 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(widget.size * 8),
                                                                color: Color.fromRGBO(2, 82, 87, 1),
                                                                border: Border.all(
                                                                    color: file.existsSync()
                                                                        ? Colors.green
                                                                        : Colors.white),
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets.only(
                                                                    left: widget.size * 3, right: widget.size * 3),
                                                                child: Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left: widget.size * 5,
                                                                          right: widget.size * 5,
                                                                          top: widget.size * 3,
                                                                          bottom: widget.size * 3),
                                                                      child: Text(
                                                                        file.existsSync() ? "Read Now" : "Download",
                                                                        style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: widget.size * 20),
                                                                      ),
                                                                    ),
                                                                    Icon(
                                                                      file.existsSync()
                                                                          ? Icons.open_in_new
                                                                          : Icons.download_for_offline_outlined,
                                                                      color: Colors.greenAccent,
                                                                      size: widget.size * 20,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              File isFile = File(
                                                                  "${folderPath}/pdfs/${getFileName(data.syllabus)}");
                                                              if (isFile.existsSync()) {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => PdfViewerPage(
                                                                            size: widget.size,
                                                                            pdfUrl:
                                                                                "${folderPath}/pdfs/${getFileName(data.syllabus)}")));
                                                              } else {
                                                                setState(() {
                                                                  isDownloaded = true;
                                                                });
                                                                await download(data.syllabus, "pdfs");
                                                              }
                                                            }),
                                                        if (file.existsSync())
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                left: widget.size * 5,
                                                                right: widget.size * 5,
                                                                top: widget.size * 1,
                                                                bottom: widget.size * 1),
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
                                                                showToastText("File has been deleted");
                                                              },
                                                              onTap: () {
                                                                showToastText("Long Press To Delete");
                                                              },
                                                            ),
                                                          )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            if (isDownloaded)
                                              LinearProgressIndicator(
                                                color: Colors.amber,
                                              ),
                                            if (data.syllabus.isNotEmpty)
                                              InkWell(
                                                onTap: () {
                                                  ExternalLaunchUrl(data.syllabus);
                                                },
                                                child: Text(
                                                  "Link (open)",
                                                  style: TextStyle(
                                                    fontSize: widget.size * 18.0,
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                      }
                  }
                }),
          ],
        ),
      ),
    ));
  }
}

class ModalPapersPage extends StatefulWidget {
  final String branch;
  final String reg;
  final double size;

  ModalPapersPage({
    Key? key,
    required this.branch,
    required this.reg,
    required this.size,
  }) : super(key: key);

  @override
  State<ModalPapersPage> createState() => _ModalPapersPageState();
}

class _ModalPapersPageState extends State<ModalPapersPage> {
  bool isLoading = true;
  bool isDownloaded = false;
  String folderPath = "";

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
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
    }
    final file = File('${newDirectory.path}/${name}');
    await file.writeAsBytes(response.bodyBytes);
    setState(() {
      isDownloaded = false;
    });
  }

  String getFileName(String url) {
    var name;
    if (url.startsWith('https://drive.google.com')) {
      name = url.split('/d/')[1].split('/')[0];
    } else {
      final Uri uri = Uri.parse(url);
      final String fileName = uri.pathSegments.last;
      name = fileName.split("/").last;
    }

    return name;
  }

  @override
  void initState() {
    getPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            backButton(
                size: widget.size,
                text: "Model Papers",
                child: SizedBox(
                  width: widget.size * 45,
                )),
            StreamBuilder<List<modelPaperConvertor>>(
                stream: readmodelPaper(branch: widget.branch),
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
                        return const Center(child: Text('Error with Model Papers Data or\n Check Internet Connection'));
                      } else {
                        if (BranchNews!.length == 0) {
                          return Center(
                              child: Text(
                            "No Model Papers",
                            style: TextStyle(color: Colors.lightBlueAccent),
                          ));
                        } else
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: BranchNews.length,
                            itemBuilder: (context, int index) {
                              var data = BranchNews[index];
                              if (data.modelPaper.isNotEmpty)
                                file = File("${folderPath}/pdfs/${getFileName(data.modelPaper)}");

                              return Padding(
                                padding: EdgeInsets.only(
                                    left: widget.size * 15.0, right: widget.size * 10, top: widget.size * 4),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.black38,
                                      borderRadius: BorderRadius.all(Radius.circular(widget.size * 20))),
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Row(
                                      children: [
                                        if (data.modelPaper.length > 3)
                                          file.existsSync() && data.modelPaper.isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(widget.size * 25),
                                                  child: SizedBox(
                                                      height: widget.size * 160,
                                                      width: widget.size * 120,
                                                      child: isLoading
                                                          ? PDFView(
                                                              filePath:
                                                                  "${folderPath}/pdfs/${getFileName(data.modelPaper)}",
                                                            )
                                                          : Container()),
                                                )
                                              : SizedBox(
                                                  height: widget.size * 98, child: Image.asset("assets/pdf_icon.png")),
                                        SizedBox(
                                          width: widget.size * 15,
                                        ),
                                        Expanded(
                                            child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  data.id.toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: widget.size * 20.0,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                if (data.modelPaper.isEmpty)
                                                  Text(
                                                    "No Data",
                                                    style: TextStyle(
                                                      fontSize: widget.size * 20.0,
                                                      color: Colors.amber,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                if (isGmail()||isOwner())
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
                                                                builder: (context) =>
                                                                    timeTableSyllabusModalPaperCreator(
                                                                      size: widget.size,
                                                                      mode: 'modalPaper',
                                                                      reg: widget.reg,
                                                                      branch: widget.branch,
                                                                      id: data.id,
                                                                      heading: data.id,
                                                                      link1: data.modelPaper,
                                                                    )));
                                                      } else if (item == "delete") {
                                                        FirebaseFirestore.instance
                                                            .collection(widget.branch)
                                                            .doc("regulation")
                                                            .collection("regulationWithYears")
                                                            .doc(data.id.substring(0, 10))
                                                            .update({"modelPaper": ""});
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
                                            ),
                                            SizedBox(
                                              height: widget.size * 2,
                                            ),
                                            if (data.modelPaper.isNotEmpty)
                                              Padding(
                                                padding: EdgeInsets.symmetric(vertical: widget.size * 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(widget.size * 8),
                                                                color: Color.fromRGBO(2, 82, 87, 1),
                                                                border: Border.all(
                                                                    color: file.existsSync()
                                                                        ? Colors.green
                                                                        : Colors.white),
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets.only(
                                                                    left: widget.size * 3, right: widget.size * 3),
                                                                child: Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left: widget.size * 5,
                                                                          right: widget.size * 5,
                                                                          top: widget.size * 3,
                                                                          bottom: widget.size * 3),
                                                                      child: Text(
                                                                        file.existsSync() ? "Read Now" : "Download",
                                                                        style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: widget.size * 20),
                                                                      ),
                                                                    ),
                                                                    Icon(
                                                                      file.existsSync()
                                                                          ? Icons.open_in_new
                                                                          : Icons.download_for_offline_outlined,
                                                                      color: Colors.greenAccent,
                                                                      size: widget.size * 20,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              File isFile = File(
                                                                  "${folderPath}/pdfs/${getFileName(data.modelPaper)}");
                                                              if (isFile.existsSync()) {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => PdfViewerPage(
                                                                            size: widget.size,
                                                                            pdfUrl:
                                                                                "${folderPath}/pdfs/${getFileName(data.modelPaper)}")));
                                                              } else {
                                                                setState(() {
                                                                  isDownloaded = true;
                                                                });
                                                                await download(data.modelPaper, "pdfs");
                                                              }
                                                            }),
                                                        if (file.existsSync())
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                left: widget.size * 5,
                                                                right: widget.size * 5,
                                                                top: widget.size * 1,
                                                                bottom: widget.size * 1),
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
                                                                showToastText("File has been deleted");
                                                              },
                                                              onTap: () {
                                                                showToastText("Long Press To Delete");
                                                              },
                                                            ),
                                                          )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            if (isDownloaded)
                                              LinearProgressIndicator(
                                                color: Colors.amber,
                                              ),
                                            if (data.modelPaper.isNotEmpty)
                                              InkWell(
                                                onTap: () {
                                                  ExternalLaunchUrl(data.modelPaper);
                                                },
                                                child: Text(
                                                  "Link (open)",
                                                  style: TextStyle(
                                                    fontSize: widget.size * 18.0,
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                      }
                  }
                }),
          ],
        ),
      ),
    ));
  }
}


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
  String subjectFilter = "None";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // backButton(
            //     size: widget.size,
            //     text: "Subjects",
            //     child: isOwner()||isGmail()
            //         ? Row(
            //             children: [
            //               PopupMenuButton(
            //                 icon: Icon(
            //                   Icons.filter_list,
            //                   color: Colors.white,
            //                   size: widget.size * 30,
            //                 ),
            //                 // Callback that sets the selected popup menu item.
            //                 onSelected: (item) {
            //                   setState(() {
            //                     subjectFilter = item as String;
            //                   });
            //                 },
            //                 itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            //                   PopupMenuItem(
            //                     value: "None",
            //                     child: Text('None'),
            //                   ),
            //                   PopupMenuItem(
            //                     value: "Regulation",
            //                     child: Text('Regulation'),
            //                   ),
            //                 ],
            //               ),
            //               InkWell(
            //                 child: Icon(
            //                   Icons.add,
            //                   color: Colors.white,
            //                   size: widget.size * 40,
            //                 ),
            //                 onTap: () {
            //                   Navigator.push(
            //                       context,
            //                       MaterialPageRoute(
            //                           builder: (context) => SubjectsCreator(
            //                                 size: widget.size,
            //                                 branch: widget.branch,
            //                               )));
            //                 },
            //               ),
            //             ],
            //           )
            //         : SizedBox(
            //             width: 45,
            //           )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: Colors.white,
                    size: widget.size * 30,
                  ),
                  // Callback that sets the selected popup menu item.
                  onSelected: (item) {
                    setState(() {
                      subjectFilter = item as String;
                    });
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      value: "None",
                      child: Text('None'),
                    ),
                    PopupMenuItem(
                      value: "Regulation",
                      child: Text('Regulation'),
                    ),
                  ],
                ),
              ],
            ),
            StreamBuilder<List<subjectsConvertor>>(
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
                        return const Center(child: Text('Error with TextBooks Data or\n Check Internet Connection'));
                      } else {
                        List<subjectsConvertor> filteredItems = user!
                            .where((item) =>
                                item.regulation.toString().toLowerCase().startsWith(widget.reg.substring(0, 2)))
                            .toList();
                        return Column(
                          children: [
                            if (filteredItems.isNotEmpty && subjectFilter == "Regulation")
                              Padding(
                                padding: EdgeInsets.all(widget.size * 8.0),
                                child: Text(
                                  "Based On Your Regulation",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: widget.size * 25, fontWeight: FontWeight.w500),
                                ),
                              ),
                            if (filteredItems.isNotEmpty && subjectFilter == "Regulation")
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: filteredItems.length,
                                itemBuilder: (context, int index) {
                                  final SubjectsData = filteredItems[index];

                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: widget.width * 10, vertical: widget.height * 1),
                                    child: InkWell(
                                      child: subjectsContainer(
                                        data: SubjectsData,
                                        branch: widget.branch,
                                        isSub: true,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: const Duration(milliseconds: 300),
                                            pageBuilder: (context, animation, secondaryAnimation) => subjectUnitsData(
                                                reg: SubjectsData.regulation,
                                                size: widget.size,
                                                branch: widget.branch,
                                                ID: SubjectsData.id,
                                                mode: "Subjects",
                                                name: SubjectsData.heading,
                                                description: SubjectsData.description,
                                                creator: SubjectsData.creator),
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
                                  );
                                },
                              ),
                            if (filteredItems.isNotEmpty && subjectFilter == "Regulation")
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: widget.size * 10),
                                child: Text(
                                  "All Subjects",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: widget.size * 25, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: user.length,
                              itemBuilder: (context, int index) {
                                final SubjectsData = user[index];
                                return Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: widget.width * 5, vertical: widget.height * 2),
                                  child: InkWell(
                                    child: subjectsContainer(
                                      data: SubjectsData,
                                      branch: widget.branch,
                                      isSub: true,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration: const Duration(milliseconds: 300),
                                          pageBuilder: (context, animation, secondaryAnimation) => subjectUnitsData(
                                              reg: SubjectsData.regulation,
                                              size: widget.size,
                                              branch: widget.branch,
                                              ID: SubjectsData.id,
                                              mode: "Subjects",
                                              name: SubjectsData.heading,
                                              description: SubjectsData.description,
                                              creator: SubjectsData.creator),
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
                                );
                              },
                            ),
                          ],
                        );
                      }
                  }
                }),
            SizedBox(
              height: widget.size * 50,
            )
          ],
        ),
      ),
    ));
  }
}

class subjectsContainer extends StatefulWidget {
  subjectsConvertor data;
  String branch;
  bool isSub;

  subjectsContainer({required this.data, required this.branch, required this.isSub});

  @override
  State<subjectsContainer> createState() => _subjectsContainerState();
}

class _subjectsContainerState extends State<subjectsContainer> {
  bool isExp = false;

  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return AnimatedContainer(
      width: double.infinity,
      decoration: BoxDecoration(color: Color(0xFF1F2323), borderRadius: BorderRadius.all(Radius.circular(Size * 20))),
      duration: Duration(milliseconds: 300),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Size * 10, vertical: Size * 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: Size * 20,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data.heading.split(";").first,
                        style: TextStyle(
                          fontSize: Size * 22.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.data.heading.split(";").last,
                        style: TextStyle(
                          fontSize: Size * 15.0,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  child: Container(
                    height: Size * 35,
                    width: Size * 35,
                    decoration: BoxDecoration(color: Color(0xFF7F8F90), borderRadius: BorderRadius.circular(Size * 18)),
                    child: Icon(
                      isExp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      isExp = !isExp;
                    });
                  },
                ),
              ],
            ),
            if (isExp)
              Row(
                mainAxisAlignment:
                    widget.data.regulation.isNotEmpty ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                children: [
                  if (widget.data.regulation.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Size * 5), border: Border.all(color: Colors.white30)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: Size * 3, horizontal: Size * 8),
                        child: Text(
                          widget.data.regulation,
                          style: TextStyle(color: Colors.white, fontSize: Size * 10),
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      Container(
                        decoration:
                            BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(Size * 20)),
                        child: Padding(
                          padding: EdgeInsets.all(Size * 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (widget.isSub)
                                InkWell(
                                  child: StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('user')
                                        .doc(fullUserId())
                                        .collection("FavouriteSubject")
                                        .doc(widget.data.id)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data!.exists) {
                                          return Icon(Icons.bookmark_added_rounded,
                                              size: Size * 20, color: Colors.cyanAccent);
                                        } else {
                                          return Icon(
                                            Icons.bookmark_border,
                                            size: Size * 20,
                                            color: Colors.cyanAccent,
                                          );
                                        }
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                  onTap: () async {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('user')
                                          .doc(fullUserId())
                                          .collection("FavouriteSubject")
                                          .doc(widget.data.id)
                                          .get()
                                          .then((docSnapshot) {
                                        if (docSnapshot.exists) {
                                          FirebaseFirestore.instance
                                              .collection('user')
                                              .doc(fullUserId())
                                              .collection("FavouriteSubject")
                                              .doc(widget.data.id)
                                              .delete();
                                          showToastText("Removed from saved list");
                                        } else {
                                          FavouriteSubjects(
                                            id: widget.data.id,
                                            branch: widget.branch,
                                            regulation: widget.data.regulation,
                                            name: widget.data.heading,
                                            description: widget.data.description,
                                            creator: widget.data.creator,
                                          );
                                          showToastText("${widget.data.heading} in favorites");
                                        }
                                      });
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                )
                              else
                                InkWell(
                                  child: StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('user')
                                        .doc(fullUserId())
                                        .collection("FavouriteLabSubjects")
                                        .doc(widget.data.id)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data!.exists) {
                                          return Row(
                                            children: [
                                              Icon(Icons.library_add_check, size: Size * 23, color: Colors.cyanAccent),
                                              Text(
                                                " Saved",
                                                style: TextStyle(color: Colors.white, fontSize: Size * 20),
                                              )
                                            ],
                                          );
                                        } else {
                                          return Row(
                                            children: [
                                              Icon(
                                                Icons.library_add_outlined,
                                                size: Size * 23,
                                                color: Colors.cyanAccent,
                                              ),
                                              Text(
                                                " Save",
                                                style: TextStyle(color: Colors.white, fontSize: Size * 20),
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
                                      await FirebaseFirestore.instance
                                          .collection('user')
                                          .doc(fullUserId())
                                          .collection("FavouriteLabSubjects")
                                          .doc(widget.data.id)
                                          .get()
                                          .then((docSnapshot) {
                                        if (docSnapshot.exists) {
                                          FirebaseFirestore.instance
                                              .collection('user')
                                              .doc(fullUserId())
                                              .collection("FavouriteLabSubjects")
                                              .doc(widget.data.id)
                                              .delete();
                                          showToastText("Removed from saved list");
                                        } else {
                                          FavouriteLabSubjectsSubjects(
                                            id: widget.data.id,
                                            regulation: widget.data.regulation,
                                            branch: widget.branch,
                                            name: widget.data.heading,
                                            description: widget.data.description,
                                            creator: widget.data.creator,
                                          );
                                          showToastText("${widget.data.heading} in favorites");
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
                      SizedBox(
                        width: Size * 10,
                      ),
                      downloadAllPdfs(
                        branch: widget.branch,
                        SubjectID: widget.data.id,
                        mode: "LabSubjects",
                        size: Size * 0.65,
                      ),
                      if (widget.isSub && (widget.data.creator == fullUserId() || isOwner()))
                        PopupMenuButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: Size * 25,
                          ),
                          // Callback that sets the selected popup menu item.
                          onSelected: (item) {
                            if (item == "edit") {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 300),
                                  pageBuilder: (context, animation, secondaryAnimation) => SubjectsCreator(
                                    size: Size,
                                    reg: widget.data.regulation,
                                    branch: widget.branch,
                                    Id: widget.data.id,
                                    heading: widget.data.heading,
                                    description: widget.data.description,
                                    mode: "Subjects",
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
                            } else if (item == "delete") {
                              FirebaseFirestore.instance
                                  .collection(widget.branch)
                                  .doc("Subjects")
                                  .collection("Subjects")
                                  .doc(widget.data.id)
                                  .delete();
                              messageToOwner(
                                  "Subject Deleted.\nBy : '${fullUserId()}' \n    Heading : ${widget.data.heading}\n    Description : ${widget.data.description}\n    regulation : ${widget.data.regulation}\n **${widget.branch}");
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
                      if (!widget.isSub && (widget.data.creator == fullUserId() || isOwner()))
                        PopupMenuButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: Size * 25,
                          ),
                          // Callback that sets the selected popup menu item.
                          onSelected: (item) {
                            if (item == "edit") {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 300),
                                  pageBuilder: (context, animation, secondaryAnimation) => SubjectsCreator(
                                    size: Size,
                                    reg: widget.data.regulation,
                                    branch: widget.branch,
                                    Id: widget.data.id,
                                    heading: widget.data.heading,
                                    description: widget.data.description,
                                    mode: "LabSubjects",
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
                            } else if (item == "delete") {
                              FirebaseFirestore.instance
                                  .collection(widget.branch)
                                  .doc("LabSubjects")
                                  .collection("LabSubjects")
                                  .doc(widget.data.id)
                                  .delete();
                              messageToOwner(
                                  "Lab Subject Deleted.\nBy : '${fullUserId()}' \n    Heading : ${widget.data.heading}\n    Description : ${widget.data.description}\n    regulation : ${widget.data.regulation}\n**${widget.branch}");
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
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class LabSubjects extends StatefulWidget {
  final String branch;
  final String reg;
  final double size;

  LabSubjects({
    Key? key,
    required this.branch,
    required this.reg,
    required this.size,
  }) : super(key: key);

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
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [

            StreamBuilder<List<subjectsConvertor>>(
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
                        return const Center(child: Text('Error with TextBooks Data or\n Check Internet Connection'));
                      } else {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: LabSubjects!.length,
                          itemBuilder: (context, int index) {
                            final LabSubjectsData = LabSubjects[index];

                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: widget.size * 2, horizontal: widget.size * 10),
                              child: InkWell(
                                child: subjectsContainer(
                                  data: LabSubjectsData,
                                  branch: widget.branch,
                                  isSub: false,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(milliseconds: 300),
                                      pageBuilder: (context, animation, secondaryAnimation) => subjectUnitsData(
                                        reg: widget.reg,
                                        size: widget.size,
                                        branch: widget.branch,
                                        ID: LabSubjectsData.id,
                                        mode: "LabSubjects",
                                        name: LabSubjectsData.heading,
                                        description: LabSubjectsData.description,
                                        creator: LabSubjectsData.creator,
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
                            );
                          },
                        );
                      }
                  }
                }),
          ],
        ),
      ),
    ));
  }
}

class allBooks extends StatefulWidget {
  final String branch;

  final double size;

  const allBooks({
    Key? key,
    required this.branch,
    required this.size,
  }) : super(key: key);

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
    getPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(widget.size * 10.0),
        child: Column(
          children: [
            StreamBuilder<List<BooksConvertor>>(
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
                        return const Center(child: Text('Error with TextBooks Data or\n Check Internet Connection'));
                      } else {
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: (widget.size * 16) / (widget.size * 36),
                          ),
                          itemCount: Books!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return textBookSub(
                              size: widget.size,
                              data: Books[index],
                              branch: widget.branch,
                            );
                          },
                        );
                      }
                  }
                }),
            SizedBox(
              height: widget.size * 50,
            )
          ],
        ),
      ),
    );
  }
}

class textBookSub extends StatefulWidget {
  String branch;
  String id;
  BooksConvertor data;

  double size;
  bool isUnit;

  textBookSub({required this.size, this.id = "", required this.data, this.isUnit = false, required this.branch});

  @override
  State<textBookSub> createState() => _textBookSubState();
}

class _textBookSubState extends State<textBookSub> {
  int index = 0;
  bool isLoading = true;
  bool isDownloaded = false;
  String folderPath = "";
  bool fullDescription = false;
  int pages = 0;

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
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
    }
    final file = File('${newDirectory.path}/${name}');
    await file.writeAsBytes(response.bodyBytes);
    setState(() {
      isDownloaded = false;
    });
  }

  String getFileName(String url) {
    var name;
    if (url.startsWith('https://drive.google.com')) {
      name = url.split('/d/')[1].split('/')[0];
    } else {
      final Uri uri = Uri.parse(url);
      final String fileName = uri.pathSegments.last;
      name = fileName.split("/").last;
    }

    return name;
  }

  @override
  void initState() {
    // TODO: implement initState
    getPath();
    super.initState();
  }

  void _reloadPage() {
    setState(() {
      isLoading = false;
    });

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        isLoading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.link.isNotEmpty) file = File("${folderPath}/pdfs/${getFileName(widget.data.link)}");

    return Padding(
      padding: EdgeInsets.all(widget.size * 2.0),
      child: InkWell(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.size * 15),
                color: Colors.white.withOpacity(0.06),
                boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black12, offset: Offset(1, 3))]),
            child: Padding(
              padding: EdgeInsets.all(widget.size * 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AspectRatio(
                    aspectRatio: (widget.size * 16) / (widget.size * 20),
                    child: file.existsSync() && widget.data.link.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(widget.size * 15),
                            child: Stack(
                              children: [
                                isLoading
                                    ? PDFView(
                                        defaultPage: index,
                                        filePath: "${folderPath}/pdfs/${getFileName(widget.data.link)}",
                                        onRender: (_pages) {
                                          setState(() {
                                            pages = _pages!;
                                          });
                                        },
                                      )
                                    : Container(),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: widget.size * 15, top: widget.size * 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(widget.size * 25),
                                        color: Colors.black.withOpacity(0.8),
                                        border: Border.all(color: Colors.white.withOpacity(0.5)),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(widget.size * 4.0),
                                        child: Text(
                                          "P: $pages",
                                          style: TextStyle(
                                              fontSize: widget.size * 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: EdgeInsets.all(widget.size * 8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(widget.size * 25),
                                                color: Colors.black.withOpacity(0.8),
                                                border: Border.all(color: Colors.white.withOpacity(0.5)),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: widget.size * 3, horizontal: widget.size * 10),
                                                child: Text(
                                                  "-",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: widget.size * 25,
                                                      fontWeight: FontWeight.w800),
                                                ),
                                              )),
                                          onTap: () {
                                            setState(() {
                                              if (index > 0) index--;
                                            });
                                            _reloadPage();
                                            // _reloadPage
                                          },
                                        ),
                                        SizedBox(
                                          width: widget.size * 5,
                                        ),
                                        InkWell(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(widget.size * 25),
                                                color: Colors.black.withOpacity(0.8),
                                                border: Border.all(color: Colors.white.withOpacity(0.5)),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: widget.size * 3, horizontal: widget.size * 8),
                                                child: Text(
                                                  "+",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: widget.size * 25,
                                                      fontWeight: FontWeight.w800),
                                                ),
                                              )),
                                          onTap: () {
                                            setState(() {
                                              index++;
                                            });
                                            _reloadPage();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(widget.size * 15),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: widget.data.photoUrl.isNotEmpty &&
                                          File("${folderPath}/books/${getFileName(widget.data.photoUrl)}").existsSync()
                                      ? DecorationImage(
                                          image: FileImage(
                                            File("${folderPath}/books/${getFileName(widget.data.photoUrl)}"),
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : ImageNotFoundForTextBooks),
                            ),
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: widget.size * 2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.data.heading.split(";").last,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: widget.size * 15, color: Colors.white),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isGmail()||isOwner())
                              PopupMenuButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                  size: widget.size * 20,
                                ),
                                // Callback that sets the selected popup menu item.
                                onSelected: (item) async {
                                  if (item == "edit") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BooksCreator(
                                                  branch: widget.branch,
                                                  id: widget.data.id,
                                                  heading: widget.data.heading,
                                                  description: widget.data.description,
                                                  Edition: widget.data.edition,
                                                  Link: widget.data.link,
                                                  Author: widget.data.Author,
                                                  photoUrl: widget.data.photoUrl,
                                                )));
                                  } else if (item == "delete") {
                                    FirebaseFirestore.instance
                                        .collection(widget.branch)
                                        .doc("Books")
                                        .collection("CoreBooks")
                                        .doc(widget.data.id)
                                        .delete();
                                    messageToOwner(
                                        "Book Deleted.\nBy : '${fullUserId()}' \n    Heading : ${widget.data.heading}\n    Description : ${widget.data.description}\n    Image : ${widget.data.photoUrl}\n    Author : ${widget.data.Author}\n    Edition : ${widget.data.edition}\n    PDF Link : ${widget.data.link}\n **${widget.branch}");
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
                        ),
                        Text(
                          widget.data.Author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(fontWeight: FontWeight.w600, fontSize: widget.size * 10, color: Colors.white70),
                        ),
                        Text(
                          widget.data.edition,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(fontWeight: FontWeight.w600, fontSize: widget.size * 10, color: Colors.white70),
                        ),
                        if (widget.data.link.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                  child: Padding(
                                    padding: EdgeInsets.all(widget.size * 3),
                                    child: Row(
                                      children: [
                                        if (!file.existsSync())
                                          Text(
                                            "Download ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: widget.size * 15,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        Icon(
                                          file.existsSync() ? Icons.open_in_new : Icons.download_for_offline_outlined,
                                          color: Colors.greenAccent,
                                          size: widget.size * 25,
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () async {
                                    File isFile = File("${folderPath}/pdfs/${getFileName(widget.data.link)}");
                                    if (isFile.existsSync()) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => PdfViewerPage(
                                                  size: widget.size,
                                                  pdfUrl: "${folderPath}/pdfs/${getFileName(widget.data.link)}")));
                                    } else {
                                      setState(() {
                                        isDownloaded = true;
                                      });
                                      await download(widget.data.link, "pdfs");
                                    }
                                  }),
                              if (file.existsSync())
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: widget.size * 5,
                                      right: widget.size * 5,
                                      top: widget.size * 1,
                                      bottom: widget.size * 1),
                                  child: InkWell(
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                      size: widget.size * 35,
                                    ),
                                    onLongPress: () async {
                                      if (file.existsSync()) {
                                        await file.delete();
                                      }
                                      setState(() {});
                                      showToastText("File has been deleted");
                                    },
                                    onTap: () {
                                      showToastText("Long Press To Delete");
                                    },
                                  ),
                                )
                            ],
                          ),
                        if (isDownloaded)
                          LinearProgressIndicator(
                            color: Colors.amber,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () async {
            File isFile = File("${folderPath}/pdfs/${getFileName(widget.data.link)}");
            if (isFile.existsSync()) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PdfViewerPage(
                          size: widget.size, pdfUrl: "${folderPath}/pdfs/${getFileName(widget.data.link)}")));
            } else {
              showToastText("Download Book");
            }
          }),
    );
  }
}

class textBookUnit extends StatefulWidget {
  String branch;
  String subjectName;
  String id;
  String creator;
  BooksConvertor data;

  double size;
  bool isUnit;

  textBookUnit(
      {required this.size,
      this.subjectName = "",
      this.id = "",
      required this.creator,
      required this.data,
      this.isUnit = false,
      required this.branch});

  @override
  State<textBookUnit> createState() => _textBookUnitState();
}

class _textBookUnitState extends State<textBookUnit> {
  int index = 0;
  bool isLoading = true;
  bool isDownloaded = false;
  String folderPath = "";
  bool fullDescription = false;
  int pages = 0;

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
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
    }
    final file = File('${newDirectory.path}/${name}');
    await file.writeAsBytes(response.bodyBytes);
    setState(() {
      isDownloaded = false;
    });
  }

  String getFileName(String url) {
    var name;
    if (url.startsWith('https://drive.google.com')) {
      name = url.split('/d/')[1].split('/')[0];
    } else {
      final Uri uri = Uri.parse(url);
      final String fileName = uri.pathSegments.last;
      name = fileName.split("/").last;
    }

    return name;
  }

  @override
  void initState() {
    // TODO: implement initState
    getPath();
    super.initState();
  }

  bool isExp = false;

  @override
  Widget build(BuildContext context) {
    if (widget.data.link.isNotEmpty) file = File("${folderPath}/pdfs/${getFileName(widget.data.link)}");

    return Column(
      children: [
        InkWell(
            child: AnimatedContainer(
              decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(widget.size * 25), bottom: Radius.circular(widget.size * 15))),
              width: isExp ? widget.size * 280 : widget.size * 120,
              height: isExp ? widget.size * 200 : widget.size * 180,
              duration: Duration(milliseconds: 300),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: isExp ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      file.existsSync() && widget.data.link.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(top: widget.size * 3),
                              child: SizedBox(
                                height: widget.size * 140,
                                width: widget.size * 118,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(widget.size * 20),
                                  child: Stack(
                                    children: [
                                      isLoading
                                          ? PDFView(
                                              defaultPage: index,
                                              filePath: "${folderPath}/pdfs/${getFileName(widget.data.link)}",
                                              onRender: (_pages) {
                                                setState(() {
                                                  pages = _pages!;
                                                });
                                              },
                                            )
                                          : Container(),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(right: widget.size * 15, top: widget.size * 8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(widget.size * 25),
                                              color: Colors.black.withOpacity(0.8),
                                              border: Border.all(color: Colors.white.withOpacity(0.5)),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(widget.size * 4.0),
                                              child: Text(
                                                "P: $pages",
                                                style: TextStyle(
                                                    fontSize: widget.size * 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(widget.size * 15),
                              child: Container(
                                height: widget.size * 140,
                                width: widget.size * 118,
                                decoration: BoxDecoration(
                                    image: widget.data.photoUrl.isNotEmpty &&
                                            File("${folderPath}/books/${getFileName(widget.data.photoUrl)}")
                                                .existsSync()
                                        ? DecorationImage(
                                            image: FileImage(
                                              File("${folderPath}/books/${getFileName(widget.data.photoUrl)}"),
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : ImageNotFoundForTextBooks),
                              ),
                            ),
                      Visibility(
                        visible: isExp, // Control the visibility based on isExp
                        child: FutureBuilder(
                          future: Future.delayed(Duration(milliseconds: 300)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      if (widget.data.Author.isNotEmpty)
                                        Text(
                                          widget.data.Author,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: widget.size * 16,
                                              color: Colors.white70),
                                        ),
                                      if (widget.data.edition.isNotEmpty)
                                        Text(
                                          widget.data.edition,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: widget.size * 16,
                                              color: Colors.white70),
                                        ),
                                      if (widget.data.link.isNotEmpty)
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if (file.existsSync())
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      right: widget.size * 5,
                                                    ),
                                                    child: InkWell(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(widget.size * 15),
                                                          color: Colors.white.withOpacity(0.8),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              vertical: widget.size * 3, horizontal: widget.size * 5),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.delete,
                                                                color: Colors.deepOrange,
                                                                size: widget.size * 25,
                                                              ),
                                                              Text(
                                                                "Delete ",
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: widget.size * 20,
                                                                    fontWeight: FontWeight.w600),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      onLongPress: () async {
                                                        if (file.existsSync()) {
                                                          await file.delete();
                                                        }
                                                        setState(() {});
                                                        showToastText("File has been deleted");
                                                      },
                                                      onTap: () {
                                                        showToastText("Long Press To Delete");
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: widget.size * 3,
                                                  ),
                                                  InkWell(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: widget.size * 10, bottom: widget.size * 5),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(widget.size * 15),
                                                          color: Colors.white.withOpacity(0.8),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              vertical: widget.size * 3, horizontal: widget.size * 5),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "Read Now",
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: widget.size * 20,
                                                                    fontWeight: FontWeight.w600),
                                                              ),
                                                              Icon(
                                                                Icons.open_in_new,
                                                                color: Colors.purpleAccent,
                                                                size: widget.size * 25,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      File isFile =
                                                          File("${folderPath}/pdfs/${getFileName(widget.data.link)}");
                                                      if (isFile.existsSync()) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => PdfViewerPage(
                                                                    size: widget.size,
                                                                    pdfUrl:
                                                                        "${folderPath}/pdfs/${getFileName(widget.data.link)}")));
                                                      } else {
                                                        showToastText("Download Book");
                                                      }
                                                    },
                                                  ),
                                                ],
                                              )
                                            else
                                              InkWell(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: widget.size * 10, bottom: widget.size * 5),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(widget.size * 15),
                                                        color: Colors.white.withOpacity(0.8),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical: widget.size * 3, horizontal: widget.size * 5),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "Download",
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: widget.size * 20,
                                                                  fontWeight: FontWeight.w600),
                                                            ),
                                                            Icon(
                                                              Icons.file_download_outlined,
                                                              color: Colors.purpleAccent,
                                                              size: widget.size * 25,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    setState(() {
                                                      isDownloaded = true;
                                                    });
                                                    await download(widget.data.link, "pdfs");
                                                    setState(() {});
                                                  }),
                                          ],
                                        ),
                                      if (widget.data.description.isNotEmpty)
                                        Text(
                                          widget.data.description,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: widget.size * 16,
                                              color: Colors.white70),
                                        ),
                                      if (isDownloaded)
                                        LinearProgressIndicator(
                                          color: Colors.amber,
                                        ),
                                      if (widget.data.size.isNotEmpty)
                                        Text(
                                          widget.data.size,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: widget.size * 16,
                                              color: Colors.white70),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Container(); // Show a loading indicator during the delay
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: widget.size * 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.data.heading.split(";").last,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: widget.size * 18, color: Colors.white),
                              maxLines: isExp ? 2 : 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (widget.creator.split(";").contains(fullUserId()) || isOwner())
                            PopupMenuButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.white,
                                size: widget.size * 20,
                              ),
                              // Callback that sets the selected popup menu item.
                              onSelected: (item) async {
                                if (item == "edit") {
                                  if (widget.isUnit)
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BooksCreator(
                                                  branch: widget.branch,
                                                  id: widget.data.id,
                                                  heading: widget.data.heading,
                                                  description: widget.data.description,
                                                  Edition: widget.data.edition,
                                                  Link: widget.data.link,
                                                  Author: widget.data.Author,
                                                  photoUrl: widget.data.photoUrl,
                                                )));
                                  else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UnitsCreator(
                                                  type: "textbook",
                                                  branch: widget.branch,
                                                  mode: "Subjects",
                                                  UnitId: widget.id,
                                                  Description: widget.data.description,
                                                  id: widget.data.id,
                                                  photoUrl: widget.data.photoUrl,
                                                  edition: widget.data.edition,
                                                  Heading: widget.data.heading,
                                                  author: widget.data.Author,
                                                  PDFUrl: widget.data.link,
                                                  subjectName: widget.subjectName,
                                                )));
                                  }
                                  ;
                                } else if (item == "delete") {
                                  if (widget.isUnit) {
                                    FirebaseFirestore.instance
                                        .collection(widget.branch)
                                        .doc("Books")
                                        .collection("CoreBooks")
                                        .doc(widget.data.id)
                                        .delete();
                                    messageToOwner(
                                        "${widget.data.heading} textBook is deleted from { books } by ${fullUserId()}");
                                  } else {
                                    final deleteFlashNews = FirebaseFirestore.instance
                                        .collection(widget.branch)
                                        .doc("Subjects")
                                        .collection("Subjects")
                                        .doc(widget.id)
                                        .collection("TextBooks")
                                        .doc(widget.data.id);
                                    deleteFlashNews.delete();

                                    messageToOwner(
                                        "Text Book Deleted from ${widget.subjectName.split(";").last}\n By '${fullUserId()}' \n    Heading : ${widget.data.heading}\n    PDF Url : ${widget.data.link}\n    Description : ${widget.data.description}\n    Photo Url : ${widget.data.photoUrl}\n    Author : ${widget.data.Author}\n    Edition : ${widget.data.edition}\n **${widget.branch}");
                                  }
                                  ;
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                isExp = !isExp;
              });
            },
            onLongPress: () async {
              File isFile = File("${folderPath}/pdfs/${getFileName(widget.data.link)}");
              if (isFile.existsSync()) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PdfViewerPage(
                            size: widget.size, pdfUrl: "${folderPath}/pdfs/${getFileName(widget.data.link)}")));
              } else {
                showToastText("Download Book");
              }
            }),
      ],
    );
  }
}

class subjectUnitsData extends StatefulWidget {
  String ID, mode;
  String name;
  String creator;

  String description;
  String branch;
  String reg;
  final double size;

  subjectUnitsData({
    required this.ID,
    required this.mode,
    required this.creator,
    required this.branch,
    required this.description,
    required this.reg,
    this.name = "Subjects",
    required this.size,
  });

  @override
  State<subjectUnitsData> createState() => _subjectUnitsDataState();
}

class _subjectUnitsDataState extends State<subjectUnitsData> with TickerProviderStateMixin {
  bool isReadMore = false;
  bool isDownloaded = false;
  String folderPath = "";
  File file = File("");
  bool isUnits = true;
  bool isTextbooks = true;
  String unitFilter = "all";
  String moreFilter = "all";

  final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.transparent,
                    Colors.transparent,
                    Colors.blueGrey.withOpacity(0.1),
                    Colors.white12
                  ]),
                ),
                child: Column(
                  children: [
                    backButton(
                        size: widget.size * 0.9,
                        text: widget.name.split(";").first,
                        child: SizedBox(
                                width: 45,
                              )),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: widget.size * 10, vertical: widget.size * 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.name.split(";").last.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: widget.size * 5, left: widget.size * 8, right: widget.size * 8),
                              child: Text(
                                widget.name.split(";").last,
                                style: TextStyle(
                                    color: Colors.white, fontSize: widget.size * 25, fontWeight: FontWeight.w600),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: widget.size * 10),
                            child: Row(
                              children: [
                                Text(
                                  "${months[int.tryParse(widget.ID.split('-').first.split('.')[1]) ?? 0]} ${widget.ID.split('-').first.split('.').last}  ",
                                  style: TextStyle(color: Colors.white60, fontSize: widget.size * 14),
                                ),
                                if (widget.reg.isNotEmpty)
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(widget.size * 5),
                                        border: Border.all(color: Colors.white30)),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: widget.size * 3, horizontal: widget.size * 8),
                                      child: Text(
                                        widget.reg,
                                        style: TextStyle(color: Colors.white, fontSize: widget.size * 12),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (widget.creator.isNotEmpty)
                            Padding(
                              padding:
                                  EdgeInsets.only(top: widget.size * 5, left: widget.size * 8, right: widget.size * 8),
                              child: Text(
                                "@${widget.creator.replaceAll(";", " - @")}",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: widget.size * 14, fontWeight: FontWeight.w400),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          if (widget.description.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: widget.size * 5, left: widget.size * 8, right: widget.size * 8),
                              child: Text(
                                widget.description,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: widget.size * 18,
                                    fontWeight: FontWeight.w500),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white12, borderRadius: BorderRadius.circular(widget.size * 20)),
                                child: Padding(
                                  padding: EdgeInsets.all(widget.size * 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      if (widget.mode == "Subjects")
                                        InkWell(
                                          child: StreamBuilder<DocumentSnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('user')
                                                .doc(fullUserId())
                                                .collection("FavouriteSubject")
                                                .doc(widget.ID)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                if (snapshot.data!.exists) {
                                                  return Icon(Icons.bookmark_added_rounded,
                                                      size: widget.size * 30, color: Colors.cyanAccent);
                                                } else {
                                                  return Icon(
                                                    Icons.bookmark_border,
                                                    size: widget.size * 30,
                                                    color: Colors.cyanAccent,
                                                  );
                                                }
                                              } else {
                                                return Container();
                                              }
                                            },
                                          ),
                                          onTap: () async {
                                            try {
                                              await FirebaseFirestore.instance
                                                  .collection('user')
                                                  .doc(fullUserId())
                                                  .collection("FavouriteSubject")
                                                  .doc(widget.ID)
                                                  .get()
                                                  .then((docSnapshot) {
                                                if (docSnapshot.exists) {
                                                  FirebaseFirestore.instance
                                                      .collection('user')
                                                      .doc(fullUserId())
                                                      .collection("FavouriteSubject")
                                                      .doc(widget.ID)
                                                      .delete();
                                                  showToastText("Removed from saved list");
                                                } else {
                                                  FavouriteSubjects(
                                                    branch: widget.branch,
                                                    id: widget.ID,
                                                    regulation: widget.reg,
                                                    name: widget.name,
                                                    description: widget.description,
                                                    creator: widget.creator,
                                                  );
                                                  showToastText("${widget.name} in favorites");
                                                }
                                              });
                                            } catch (e) {
                                              print(e);
                                            }
                                          },
                                        )
                                      else
                                        InkWell(
                                          child: StreamBuilder<DocumentSnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('user')
                                                .doc(fullUserId())
                                                .collection("FavouriteLabSubjects")
                                                .doc(widget.ID)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                if (snapshot.data!.exists) {
                                                  return Row(
                                                    children: [
                                                      Icon(Icons.library_add_check,
                                                          size: widget.size * 23, color: Colors.cyanAccent),
                                                      Text(
                                                        " Saved",
                                                        style:
                                                            TextStyle(color: Colors.white, fontSize: widget.size * 20),
                                                      )
                                                    ],
                                                  );
                                                } else {
                                                  return Row(
                                                    children: [
                                                      Icon(
                                                        Icons.library_add_outlined,
                                                        size: widget.size * 23,
                                                        color: Colors.cyanAccent,
                                                      ),
                                                      Text(
                                                        " Save",
                                                        style:
                                                            TextStyle(color: Colors.white, fontSize: widget.size * 20),
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
                                              await FirebaseFirestore.instance
                                                  .collection('user')
                                                  .doc(fullUserId())
                                                  .collection("FavouriteLabSubjects")
                                                  .doc(widget.ID)
                                                  .get()
                                                  .then((docSnapshot) {
                                                if (docSnapshot.exists) {
                                                  FirebaseFirestore.instance
                                                      .collection('user')
                                                      .doc(fullUserId())
                                                      .collection("FavouriteLabSubjects")
                                                      .doc(widget.ID)
                                                      .delete();
                                                  showToastText("Removed from saved list");
                                                } else {
                                                  FavouriteLabSubjectsSubjects(
                                                    branch: widget.branch,
                                                    id: widget.ID,
                                                    regulation: widget.reg,
                                                    name: widget.name,
                                                    description: widget.description,
                                                    creator: widget.creator,
                                                  );
                                                  showToastText("${widget.name} in favorites");
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
                              SizedBox(
                                width: widget.size * 10,
                              ),
                              downloadAllPdfs(
                                branch: widget.branch,
                                SubjectID: widget.ID,
                                mode: widget.mode,
                                size: widget.size,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<List<UnitsConvertor>>(
                stream: readUnits(widget.ID, widget.branch),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        color: Colors.white,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Check Internet Connection'),
                    );
                  } else {
                    final units = snapshot.data;

                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: widget.size * 10, vertical: widget.size * 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.mode == "Subjects" ? "Units" : "Records & Manuals",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),
                              ),
                              Row(
                                children: [
                                  if (widget.mode == "Subjects")
                                    PopupMenuButton(
                                      icon: Icon(
                                        Icons.filter_list,
                                        color: Colors.white,
                                        size: widget.size * 25,
                                      ),
                                      // Callback that sets the selected popup menu item.
                                      onSelected: (item) {
                                        setState(() {
                                          unitFilter = item as String;
                                        });
                                      },
                                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                        PopupMenuItem(
                                          value: "all",
                                          child: Text('All'),
                                        ),
                                        PopupMenuItem(
                                          value: "Unit 1",
                                          child: Text('Unit 1'),
                                        ),
                                        PopupMenuItem(
                                          value: "Unit 2",
                                          child: Text('Unit 2'),
                                        ),
                                        PopupMenuItem(
                                          value: "Unit 3",
                                          child: Text('Unit 3'),
                                        ),
                                        PopupMenuItem(
                                          value: "Unit 4",
                                          child: Text('Unit 4'),
                                        ),
                                        PopupMenuItem(
                                          value: "Unit 5",
                                          child: Text('Unit 5'),
                                        ),
                                      ],
                                    ),
                                  SizedBox(
                                    width: widget.size * 10,
                                  ),
                                  InkWell(
                                    child: Text(
                                      isUnits ? "Hide" : "View",
                                      style: TextStyle(
                                          color: Colors.purpleAccent,
                                          fontSize: widget.size * 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        isUnits = !isUnits;
                                      });
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        if (isUnits)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: widget.size * 10.0),
                            child: unitFilter == "all"
                                ? ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: units!.length,
                                    itemBuilder: (context, int index) {
                                      final unit = units[index];
                                      return subUnit(
                                        subjectName: widget.name.split(";").last,
                                        size: widget.size,
                                        ID: widget.ID,
                                        branch: widget.branch,
                                        unit: unit,
                                        mode: widget.mode,
                                        creator: widget.creator,
                                      );
                                    },
                                    separatorBuilder: (context, index) => SizedBox(
                                      height: widget.size * 5,
                                    ),
                                  )
                                : ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: units!
                                        .where((unit) => unit.heading.split(";").first.contains(unitFilter))
                                        .toList()
                                        .length,
                                    itemBuilder: (context, int index) {
                                      final filteredUnits = units
                                          .where((unit) => unit.heading.split(";").first.contains(unitFilter))
                                          .toList();
                                      final unit = filteredUnits[index];
                                      return subUnit(
                                        subjectName: widget.name.split(";").last,
                                        creator: widget.creator,
                                        size: widget.size,
                                        ID: widget.ID,
                                        branch: widget.branch,
                                        unit: unit,
                                        mode: widget.mode,
                                      );
                                    },
                                    separatorBuilder: (context, index) => SizedBox(
                                      height: widget.size * 5,
                                    ),
                                  ),
                          ),
                      ],
                    );
                  }
                },
              ),
              if (widget.mode == "Subjects")
                StreamBuilder<List<BooksConvertor>>(
                  stream: readTextBooks(widget.ID, widget.branch),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 0.3,
                          color: Colors.cyan,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error with TextBooks Data or\n Check Internet Connection'),
                      );
                    } else {
                      final units = snapshot.data;

                      return Column(
                        children: [
                          if (units!.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: widget.size * 10, vertical: widget.size * 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Text Books",
                                    style: TextStyle(
                                        color: Colors.white, fontWeight: FontWeight.w500, fontSize: widget.size * 25),
                                  ),
                                  InkWell(
                                    child: Text(
                                      isTextbooks ? "Hide" : "View",
                                      style: TextStyle(
                                          color: Colors.purpleAccent,
                                          fontSize: widget.size * 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        isTextbooks = !isTextbooks;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          if (isTextbooks && units!.isNotEmpty)
                            SizedBox(
                              height: widget.size * 200,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: units!.length,
                                itemBuilder: (context, int index) {
                                  final unit = units[index];

                                  return textBookUnit(
                                    subjectName: widget.name.split(";").last,
                                    creator: widget.creator,
                                    id: widget.ID,
                                    size: widget.size,
                                    data: unit,
                                    branch: widget.branch,
                                  );
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                  height: widget.size * 5,
                                ),
                              ),
                            ),
                        ],
                      );
                    }
                  },
                ),
              StreamBuilder<List<UnitsMoreConvertor>>(
                stream: readMore(widget.ID, widget.branch),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 0.3,
                        color: Colors.cyan,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error with TextBooks Data or\n Check Internet Connection'),
                    );
                  } else {
                    final units = snapshot.data;

                    return Column(
                      children: [
                        if (units!.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: widget.size * 10, vertical: widget.size * 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "More",
                                  style: TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.w500, fontSize: widget.size * 25),
                                ),
                                PopupMenuButton(
                                  icon: Icon(
                                    Icons.filter_list,
                                    color: Colors.white,
                                    size: widget.size * 25,
                                  ),
                                  // Callback that sets the selected popup menu item.
                                  onSelected: (item) {
                                    setState(() {
                                      moreFilter = item as String;
                                    });
                                  },
                                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                    PopupMenuItem(
                                      value: "all",
                                      child: Text('All'),
                                    ),
                                    PopupMenuItem(
                                      value: "PDF",
                                      child: Text('.pdf'),
                                    ),
                                    PopupMenuItem(
                                      value: "Image",
                                      child: Text('Image'),
                                    ),
                                    PopupMenuItem(
                                      value: "WebSite",
                                      child: Text('WebSite'),
                                    ),
                                    PopupMenuItem(
                                      value: "YouTube",
                                      child: Text('YouTube'),
                                    ),
                                    PopupMenuItem(
                                      value: "More",
                                      child: Text('More'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        moreFilter == "all"
                            ? ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: units!.length,
                                itemBuilder: (context, int index) {
                                  final unit = units[index];

                                  return subMore(
                                    subjectName: widget.name.split(";").last,
                                    creator: widget.creator,
                                    size: widget.size,
                                    ID: widget.ID,
                                    branch: widget.branch,
                                    unit: unit,
                                    mode: widget.mode,
                                  );
                                },
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: units!
                                    .where((unit) => unit.link.split(";").first.startsWith(moreFilter))
                                    .toList()
                                    .length,
                                itemBuilder: (context, int index) {
                                  final filteredUnits =
                                      units.where((unit) => unit.link.split(";").first.startsWith(moreFilter)).toList();
                                  final unit = filteredUnits[index];
                                  return subMore(
                                    creator: widget.creator,
                                    subjectName: widget.name.split(";").last,
                                    size: widget.size,
                                    ID: widget.ID,
                                    branch: widget.branch,
                                    unit: unit,
                                    mode: widget.mode,
                                  );
                                },
                              ),
                      ],
                    );
                  }
                },
              ),
              SizedBox(
                height: widget.size * 50,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        height: Size * 40,
        width: Size * 40,
        child: Visibility(
            visible: widget.creator.split(";").contains(fullUserId()) || isOwner(),
            child: SpeedDial(
              icon: Icons.add,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              iconTheme: IconThemeData(size: 50.0),
              openCloseDial: isDialOpen,
              backgroundColor: Color.fromRGBO(101, 150, 161, 1),
              overlayColor: Colors.black,
              overlayOpacity: 0.5,
              spacing: Size * 2,
              spaceBetweenChildren: Size * 2,

              // closeManually: true,
              children: [
                SpeedDialChild(
                    child: Text(
                      widget.mode == "Subjects" ? "U" : "R & M",
                      style: TextStyle(fontSize: Size * 18),
                    ),
                    label: widget.mode == "Subjects" ? "Unit" : "Records & Manuals",
                    labelStyle: TextStyle(fontSize: 20),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UnitsCreator(
                                    subjectName: widget.name,
                                    type: "unit",
                                    branch: widget.branch,
                                    id: widget.ID,
                                    mode: widget.mode,
                                  )));
                    }),
                if (widget.mode == "Subjects")
                  SpeedDialChild(
                      child: Text(
                        "TB",
                        style: TextStyle(fontSize: Size * 18),
                      ),
                      labelStyle: TextStyle(fontSize: 20),
                      label: 'Text Book',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UnitsCreator(
                                      subjectName: widget.name,
                                      type: "textbook",
                                      branch: widget.branch,
                                      id: widget.ID,
                                      mode: widget.mode,
                                    )));
                      }),
                SpeedDialChild(
                    child: Text(
                      "M",
                      style: TextStyle(fontSize: Size * 18),
                    ),
                    label: 'More',
                    labelStyle: TextStyle(fontSize: 20),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UnitsCreator(
                                    subjectName: widget.name,
                                    type: "more",
                                    branch: widget.branch,
                                    id: widget.ID,
                                    mode: widget.mode,
                                  )));
                    }),
              ],
            )),
      ),
    );
  }

  Stream<List<UnitsConvertor>> readUnits(String subjectsID, String branch) => FirebaseFirestore.instance
      .collection(branch)
      .doc(widget.mode)
      .collection(widget.mode)
      .doc(subjectsID)
      .collection("Units")
      .orderBy("heading", descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => UnitsConvertor.fromJson(doc.data())).toList());

  Stream<List<BooksConvertor>> readTextBooks(String subjectsID, String branch) => FirebaseFirestore.instance
      .collection(branch)
      .doc(widget.mode)
      .collection(widget.mode)
      .doc(subjectsID)
      .collection("TextBooks")
      .orderBy("heading", descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => BooksConvertor.fromJson(doc.data())).toList());

  Stream<List<UnitsMoreConvertor>> readMore(String subjectsID, String branch) => FirebaseFirestore.instance
      .collection(branch)
      .doc(widget.mode)
      .collection(widget.mode)
      .doc(subjectsID)
      .collection("More")
      .orderBy("heading", descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => UnitsMoreConvertor.fromJson(doc.data())).toList());
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
      .doc(getID());
  final flash = UnitsConvertor(
      id: getID(), heading: heading, questions: questions, description: description, size: PDFSize, link: PDFLink);
  final json = flash.toJson();
  await docflash.set(json);
}

class UnitsConvertor {
  String id;
  final String heading, questions, description, size, link;

  UnitsConvertor({
    this.id = "",
    required this.heading,
    required this.questions,
    required this.description,
    this.size = "",
    required this.link,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "questions": questions,
        "description": description,
        "size": size,
        "link": link,
      };

  static UnitsConvertor fromJson(Map<String, dynamic> json) => UnitsConvertor(
        link: json["link"],
        id: json['id'],
        heading: json["heading"],
        questions: json["questions"],
        description: json["description"],
        size: json["size"],
      );
}

Future createUnitsTextbooks({
  required String mode,
  required String branch,
  required String subjectsID,
  required String heading,
  required String photoUrl,
  required String PDFLink,
  required String author,
  required String edition,
  required String description,
}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc(mode)
      .collection(mode)
      .doc(subjectsID)
      .collection("TextBooks")
      .doc(getID());
  final flash = BooksConvertor(
    id: getID(),
    heading: heading,
    description: description,
    link: PDFLink,
    photoUrl: photoUrl,
    Author: author,
    edition: edition,
  );
  final json = flash.toJson();
  await docflash.set(json);
}

Future createUnitsMore({
  required String mode,
  required String branch,
  required String subjectsID,
  required String heading,
  required String description,
  required String link,
}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc(mode)
      .collection(mode)
      .doc(subjectsID)
      .collection("More")
      .doc(getID());
  final flash = UnitsMoreConvertor(id: getID(), heading: heading, description: description, link: link);
  final json = flash.toJson();
  await docflash.set(json);
}

class UnitsMoreConvertor {
  String id;
  final String heading, description, link;

  UnitsMoreConvertor({
    this.id = "",
    required this.heading,
    required this.description,
    required this.link,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "description": description,
        "link": link,
      };

  static UnitsMoreConvertor fromJson(Map<String, dynamic> json) => UnitsMoreConvertor(
        id: json['id'],
        heading: json["heading"],
        description: json["description"],
        link: json["link"],
      );
}

class subUnit extends StatefulWidget {
  final UnitsConvertor unit;
  final String mode, subjectName;
  final String creator;
  final String branch;
  final String ID;
  final double size;

  const subUnit({
    Key? key,
    required this.unit,
    required this.mode,
    required this.subjectName,
    required this.creator,
    required this.branch,
    required this.ID,
    required this.size,
  }) : super(key: key);

  @override
  State<subUnit> createState() => _subUnitState();
}

class _subUnitState extends State<subUnit> with TickerProviderStateMixin {
  int index = 0;
  bool isLoading = true;
  bool isReadMore = false;
  bool isQuestions = false;
  bool isDownloaded = false;
  String folderPath = "";
  File pdfFile = File("");
  bool isExp = false;
  List<String> newList = [];
  List<String> newQuestionsList = [];
  bool fullDescription = false;
  int pages = 0;

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
    });
  }

  download(String photoUrl) async {
    var name;
    if (photoUrl.startsWith('https://drive.google.com')) {
      name = photoUrl.split('/d/')[1].split('/')[0];
      photoUrl = "https://drive.google.com/uc?export=download&id=$name";
    } else {
      final Uri uri = Uri.parse(photoUrl);
      final String fileName = uri.pathSegments.last;
      name = fileName.split("/").last;
    }
    final response = await http.get(Uri.parse(photoUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory('${documentDirectory.path}/pdfs');
    if (!await newDirectory.exists()) {
      await newDirectory.create(recursive: true);
    }
    final file = File('${newDirectory.path}/${name}');
    await file.writeAsBytes(response.bodyBytes);
    if (isOwner()) {
      String data = "";
      int byteLength = response.body.length;
      double kbSize = byteLength / 1024; // Convert to KB
      double mbSize = kbSize / 1024; // Convert to MB

      if (mbSize >= 1.0) {
        data = '${mbSize.toStringAsFixed(0)} MB';
      } else {
        data = '${kbSize.toStringAsFixed(0)} KB';
      }
      FirebaseFirestore.instance
          .collection(widget.branch)
          .doc(widget.mode)
          .collection(widget.mode)
          .doc(widget.ID)
          .collection("Units")
          .doc(widget.unit.id)
          .update({"size": data});
    }
    setState(() {
      isDownloaded = false;
    });
  }

  String getFileName(String url) {
    var name;
    if (url.startsWith('https://drive.google.com')) {
      name = url.split('/d/')[1].split('/')[0];
    } else {
      final Uri uri = Uri.parse(url);
      final String fileName = uri.pathSegments.last;
      name = fileName.split("/").last;
    }
    return name;
  }

  @override
  void initState() {
    getPath();
    set();

    super.initState();
  }

  set() {
    newQuestionsList = widget.unit.questions.split(";");
    newList = widget.unit.description.split(";");
  }

  @override
  Widget build(BuildContext context) {
    if (widget.unit.link.isNotEmpty) pdfFile = File("${folderPath}/pdfs/${getFileName(widget.unit.link)}");
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.size * 20),
          color: Colors.white.withOpacity(0.08),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (pdfFile.existsSync())
                  SizedBox(
                    width: widget.size * 100,
                    height: widget.size * 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(widget.size * 20),
                      child: Stack(
                        children: [
                          isLoading
                              ? PDFView(
                                  defaultPage: 0,
                                  filePath: "${folderPath}/pdfs/${getFileName(widget.unit.link)}",
                                  onRender: (_pages) {
                                    setState(() {
                                      pages = _pages!;
                                    });
                                  },
                                )
                              : Container(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: widget.size * 2, bottom: widget.size * 2),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(widget.size * 25),
                                  color: Colors.black.withOpacity(0.8),
                                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(widget.size * 4.0),
                                  child: Text(
                                    "$pages",
                                    style: TextStyle(
                                        fontSize: widget.size * 15, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: widget.size * 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.unit.heading.split(";").last}",
                          style: TextStyle(
                            fontSize: widget.size * 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: isExp ? 6 : 1,
                        ),
                        if (widget.unit.heading.split(";").first != "Unknown")
                          Container(
                            padding: EdgeInsets.symmetric(vertical: widget.size * 1, horizontal: widget.size * 2),
                            decoration: BoxDecoration(
                                color: Color(0xFF081214), borderRadius: BorderRadius.circular(widget.size * 3)),
                            child: Text(
                              widget.unit.heading.split(";").first,
                              style: TextStyle(
                                  color: Colors.white60, fontWeight: FontWeight.w400, fontSize: widget.size * 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        if (isDownloaded)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: widget.size * 25),
                            child: LinearProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(widget.size * 17), color: Colors.white70),
                    margin: EdgeInsets.all(widget.size * 8),
                    child: Icon(
                      isExp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: Colors.black,
                      size: widget.size * 35,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      isExp = !isExp;
                    });
                  },
                )
              ],
            ),
            if (isExp)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.size * 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              widget.unit.link.isNotEmpty
                                  ? Row(
                                      children: [
                                        if (pdfFile.existsSync())
                                          Padding(
                                            padding: EdgeInsets.only(
                                              right: widget.size * 5,
                                            ),
                                            child: InkWell(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(widget.size * 15),
                                                  color: Colors.white.withOpacity(0.8),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: widget.size * 3, horizontal: widget.size * 5),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.delete,
                                                        color: Colors.deepOrange,
                                                        size: widget.size * 25,
                                                      ),
                                                      Text(
                                                        "Delete ",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: widget.size * 20,
                                                            fontWeight: FontWeight.w600),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              onLongPress: () async {
                                                if (pdfFile.existsSync()) {
                                                  await pdfFile.delete();
                                                }
                                                setState(() {});
                                                showToastText("File has been deleted");
                                              },
                                              onTap: () {
                                                showToastText("Long Press To Delete");
                                              },
                                            ),
                                          )
                                        else
                                          InkWell(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: widget.size * 10, bottom: widget.size * 5),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(widget.size * 15),
                                                    color: Colors.white.withOpacity(0.8),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: widget.size * 3, horizontal: widget.size * 5),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Download",
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: widget.size * 20,
                                                              fontWeight: FontWeight.w600),
                                                        ),
                                                        Icon(
                                                          Icons.file_download_outlined,
                                                          color: Colors.purpleAccent,
                                                          size: widget.size * 25,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () async {
                                                setState(() {
                                                  isDownloaded = true;
                                                });
                                                await download(widget.unit.link);
                                                setState(() {});
                                              }),
                                      ],
                                    )
                                  : Container(),
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.circular(widget.size * 6),
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: widget.size * 2, horizontal: widget.size * 5),
                                    child: Text(
                                      "~ ${widget.unit.size}",
                                      style: TextStyle(color: Colors.black, fontSize: widget.size * 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )),
                            ],
                          ),
                          if (newList.length.isNaN)
                            Text(
                              "Description",
                              style: TextStyle(
                                  color: Colors.purpleAccent, fontSize: widget.size * 22, fontWeight: FontWeight.w500),
                            ),
                          if (newList.length.isNaN)
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: newList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (newList.length > 1) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: widget.size * 8),
                                      child: InkWell(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              size: widget.size * 8,
                                              color: Colors.lightBlueAccent,
                                            ),
                                            Flexible(
                                              child: Text(
                                                isOwner() ? newList[index] : newList[index].split("@").first,
                                                style: TextStyle(color: Colors.white, fontSize: widget.size * 18),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          int indexNumber = 0;
                                          try {
                                            indexNumber = int.parse(newList[index].split('@').last.trim());
                                          } catch (e) {
                                            indexNumber = 0;
                                          }
                                          if (file.existsSync()) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => PdfViewerPage(
                                                          size: widget.size,
                                                          pdfUrl: "${folderPath}/pdfs/${getFileName(widget.unit.link)}",
                                                          defaultPage: indexNumber - 1,
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
                                        padding: EdgeInsets.all(widget.size * 8.0),
                                        child: Text(
                                          newList[0],
                                          style: TextStyle(color: Colors.amberAccent, fontSize: widget.size * 18),
                                        ),
                                      ),
                                    );
                                  }
                                }),
                          if (newQuestionsList.length.isNaN)
                            Text(
                              "Questions",
                              style: TextStyle(
                                  color: Colors.purpleAccent, fontSize: widget.size * 22, fontWeight: FontWeight.w500),
                            ),
                          if (newQuestionsList.length.isNaN)
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: newQuestionsList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (newQuestionsList.length > 1) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: widget.size * 8),
                                      child: InkWell(
                                        child: Row(
                                          children: [
                                            Text("${index + 1}. ",
                                                style: TextStyle(color: Colors.white, fontSize: widget.size * 18)),
                                            Flexible(
                                              child: Text(
                                                isOwner()
                                                    ? newQuestionsList[index]
                                                    : newQuestionsList[index].split("@").first,
                                                style: TextStyle(color: Colors.white70, fontSize: widget.size * 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          int indexNumber = 0;
                                          try {
                                            indexNumber = int.parse(newQuestionsList[index].split('@').last.trim());
                                          } catch (e) {
                                            indexNumber = 0;
                                          }
                                          if (file.existsSync()) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => PdfViewerPage(
                                                          size: widget.size,
                                                          pdfUrl: "${folderPath}/pdfs/${getFileName(widget.unit.link)}",
                                                          defaultPage: indexNumber - 1,
                                                        )));
                                          } else {
                                            showToastText("Download PDF");
                                          }
                                        },
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(widget.size * 8)),
                                        child: Padding(
                                          padding: EdgeInsets.all(widget.size * 8.0),
                                          child: Text(
                                            "No Question",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: widget.size * 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }),
                        ],
                      ),
                    ),
                    if (widget.creator.split(";").contains(fullUserId()) || isOwner())
                      PopupMenuButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: widget.size * 18,
                        ),
                        // Callback that sets the selected popup menu item.
                        onSelected: (item) {
                          if (item == "edit") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UnitsCreator(
                                          subjectName: widget.subjectName,
                                          type: "unit",
                                          branch: widget.branch,
                                          mode: widget.mode,
                                          UnitId: widget.ID,
                                          id: widget.unit.id,
                                          Heading: widget.unit.heading,
                                          Description: widget.unit.description,
                                          questions: widget.unit.questions,
                                          PDFUrl: widget.unit.link,
                                        )));
                          } else if (item == "delete") {
                            messageToOwner(
                                "Unit Deleted from ${widget.subjectName.split(";").last} (${widget.mode})\n By '${fullUserId()}' \n    Heading : ${widget.unit.heading}\n    PDF Url : ${widget.unit.link}\n    Description : ${widget.unit.description}\n    Questions : ${widget.unit.questions}\n **${widget.branch}");

                            final deleteFlashNews = FirebaseFirestore.instance
                                .collection(widget.branch)
                                .doc(widget.mode)
                                .collection(widget.mode)
                                .doc(widget.ID)
                                .collection("Units")
                                .doc(widget.unit.id);
                            deleteFlashNews.delete();
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
                ),
              ),
          ],
        ),
      ),
      onTap: () {
        if (pdfFile.existsSync()) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PdfViewerPage(size: widget.size, pdfUrl: "${folderPath}/pdfs/${getFileName(widget.unit.link)}")));
        } else {
          setState(() {
            isExp = !isExp;
          });
        }
      },
    );
  }
}

class subMore extends StatefulWidget {
  final UnitsMoreConvertor unit;
  final String mode, subjectName;
  final String creator;
  final String branch;
  final String ID;
  final double size;

  const subMore(
      {Key? key,
      required this.unit,
      required this.mode,
      required this.subjectName,
      required this.creator,
      required this.branch,
      required this.ID,
      required this.size})
      : super(key: key);

  @override
  State<subMore> createState() => _subMoreState();
}

class _subMoreState extends State<subMore> with TickerProviderStateMixin {
  int index = 0;
  bool isLoading = true;
  bool isDownloaded = false;

  String folderPath = "";
  File file = File("");

  int pages = 0;

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();

    setState(() {
      folderPath = '${directory.path}';
    });
  }

  download(String photoUrl, String path) async {
    var name;
    if (photoUrl.startsWith('https://drive.google.com')) {
      name = photoUrl.split('/d/')[1].split('/')[0];

      photoUrl = "https://drive.google.com/uc?export=download&id=$name";
    } else {
      final Uri uri = Uri.parse(photoUrl);
      final String fileName = uri.pathSegments.last;
      name = fileName.split("/").last;
    }

    final response = await http.get(Uri.parse(photoUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory('${documentDirectory.path}/$path');
    if (!await newDirectory.exists()) {
      await newDirectory.create(recursive: true);
    }
    final file = File('${newDirectory.path}/${name}');
    await file.writeAsBytes(response.bodyBytes);
    setState(() {
      isDownloaded = false;
    });
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
    getPath();
    super.initState();
  }

  bool isExp = false;

  @override
  Widget build(BuildContext context) {
    if (widget.unit.link.split(";").last.isNotEmpty && widget.unit.link.split(";").first == "PDF")
      file = File("${folderPath}/pdfs/${getFileName(widget.unit.link.split(";").last)}");

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.size * 8.0),
      child: InkWell(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.size * 20),
            color: Colors.white.withOpacity(0.08),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.size * 8),
            child: Column(
              children: [
                Row(
                  children: [
                    if (file.existsSync() &&
                        widget.unit.link.split(";").last.isNotEmpty &&
                        widget.unit.link.split(";").first == "PDF")
                      SizedBox(
                        width: widget.size * 100,
                        height: widget.size * 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(widget.size * 20),
                          child: Stack(
                            children: [
                              isLoading
                                  ? PDFView(
                                      defaultPage: 0,
                                      filePath: "${folderPath}/pdfs/${getFileName(widget.unit.link.split(";").last)}",
                                      onRender: (_pages) {
                                        setState(() {
                                          pages = _pages!;
                                        });
                                      },
                                    )
                                  : Container(),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: widget.size * 2, bottom: widget.size * 2),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(widget.size * 25),
                                      color: Colors.black.withOpacity(0.8),
                                      border: Border.all(color: Colors.white.withOpacity(0.5)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(widget.size * 4.0),
                                      child: Text(
                                        "$pages",
                                        style: TextStyle(
                                            fontSize: widget.size * 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (widget.unit.link.split(";").first == "Image")
                      ClipRRect(
                        borderRadius: BorderRadius.circular(widget.size * 25),
                        child: SizedBox(
                          width: widget.size * 100,
                          height: widget.size * 60,
                          child: Image.network(
                            widget.unit.link.split(";").last,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else if (widget.unit.link.split(";").first == "YouTube" ||
                        widget.unit.link.split(";").first == "WebSite")
                      Padding(
                        padding: EdgeInsets.all(widget.size * 8.0),
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white30),
                                borderRadius: BorderRadius.circular(widget.size * 10),
                                image: DecorationImage(
                                    image: AssetImage(widget.unit.link.split(";").first == "YouTube"
                                        ? "assets/YouTubeIcon.png"
                                        : "assets/googleIcon.png"),
                                    fit: BoxFit.cover)),
                            height: widget.size * 35,
                            width: widget.size * 40),
                      )
                    else
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: widget.size * 5, vertical: widget.size * 1),
                        decoration:
                            BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(widget.size * 5)),
                        child: Text(
                          widget.unit.link.split(";").first,
                          style: TextStyle(fontSize: widget.size * 12, fontWeight: FontWeight.w800),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        "  ${widget.unit.heading.split(";").first}",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: widget.size * 20),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      child: Container(
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(widget.size * 17), color: Colors.white70),
                        margin: EdgeInsets.all(widget.size * 8),
                        child: Icon(
                          isExp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          color: Colors.black,
                          size: widget.size * 35,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          isExp = !isExp;
                        });
                      },
                    )
                  ],
                ),
                if (isExp)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          widget.unit.link.split(";").last.isNotEmpty && widget.unit.link.split(";").first == "PDF"
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (file.existsSync())
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: widget.size * 5,
                                        ),
                                        child: InkWell(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(widget.size * 15),
                                              color: Colors.white.withOpacity(0.8),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: widget.size * 3, horizontal: widget.size * 5),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    color: Colors.deepOrange,
                                                    size: widget.size * 25,
                                                  ),
                                                  Text(
                                                    "Delete ",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: widget.size * 20,
                                                        fontWeight: FontWeight.w600),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          onLongPress: () async {
                                            if (file.existsSync()) {
                                              await file.delete();
                                            }
                                            setState(() {});
                                            showToastText("File has been deleted");
                                          },
                                          onTap: () {
                                            showToastText("Long Press To Delete");
                                          },
                                        ),
                                      )
                                    else
                                      InkWell(
                                          child: Padding(
                                            padding: EdgeInsets.only(left: widget.size * 10, bottom: widget.size * 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(widget.size * 15),
                                                color: Colors.white.withOpacity(0.8),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: widget.size * 3, horizontal: widget.size * 5),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Download",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: widget.size * 20,
                                                          fontWeight: FontWeight.w600),
                                                    ),
                                                    Icon(
                                                      Icons.file_download_outlined,
                                                      color: Colors.purpleAccent,
                                                      size: widget.size * 25,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            setState(() {
                                              isDownloaded = true;
                                            });
                                            await download(widget.unit.link.split(";").last, "pdfs");
                                            setState(() {
                                              isDownloaded = false;
                                            });
                                          }),
                                  ],
                                )
                              : Container(),
                          if (widget.creator.split(";").contains(fullUserId()) || isOwner())
                            PopupMenuButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.white,
                                size: widget.size * 20,
                              ),
                              // Callback that sets the selected popup menu item.
                              onSelected: (item) {
                                if (item == "edit") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UnitsCreator(
                                                subjectName: widget.subjectName,
                                                type: "more",
                                                branch: widget.branch,
                                                mode: widget.mode,
                                                UnitId: widget.ID,
                                                id: widget.unit.id,
                                                Heading: widget.unit.heading,
                                                Description: widget.unit.description,
                                                PDFUrl: widget.unit.link,
                                              )));
                                } else if (item == "delete") {
                                  messageToOwner(
                                      "More Deleted from ${widget.subjectName.split(";").last} (${widget.mode})\n By '${fullUserId()}' \n    Heading : ${widget.unit.heading}\n    Url : ${widget.unit.link.split(";").first}=>${widget.unit.link.split(";").last}\n    Description : ${widget.unit.description}\n **${widget.branch}");

                                  final deleteFlashNews = FirebaseFirestore.instance
                                      .collection(widget.branch)
                                      .doc(widget.mode)
                                      .collection(widget.mode)
                                      .doc(widget.ID)
                                      .collection("More")
                                      .doc(widget.unit.id);
                                  deleteFlashNews.delete();
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
                      ),
                      if (isDownloaded)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: widget.size * 20.0),
                          child: LinearProgressIndicator(),
                        ),
                      if (widget.unit.description.isNotEmpty)
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.unit.description.split(";").length,
                            itemBuilder: (BuildContext context, int index) {
                              if (widget.unit.description.split(";").length > 0) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: widget.size * 3, left: widget.size * 10),
                                  child: Flexible(
                                    child: Text(
                                      widget.unit.description.split(";")[index],
                                      style:
                                          TextStyle(color: Colors.white.withOpacity(0.8), fontSize: widget.size * 15),
                                    ),
                                  ),
                                );
                              } else {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(widget.size * 8.0),
                                    child: Text(
                                      "No Question",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: widget.size * 18, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                );
                              }
                            }),
                    ],
                  )
              ],
            ),
          ),
        ),
        onTap: () {
          if (file.existsSync()) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PdfViewerPage(
                        size: widget.size, pdfUrl: "${folderPath}/pdfs/${getFileName(widget.unit.link)}")));
          } else if (widget.unit.link.split(";").first == "Image") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImageZoom(
                          size: widget.size,
                          url: widget.unit.link.split(";").last,
                          file: File(""),
                        )));
          } else if (widget.unit.link.split(";").first == "YouTube" || widget.unit.link.split(";").first == "WebSite")
            ExternalLaunchUrl(widget.unit.link.split(";").last);
        },
      ),
    );
  }
}

class updatesPage extends StatefulWidget {
  final String branch;
  final double size;

  const updatesPage({
    Key? key,
    required this.branch,
    required this.size,
  }) : super(key: key);

  @override
  State<updatesPage> createState() => _updatesPageState();
}

class _updatesPageState extends State<updatesPage> {
  bool isBranch = false;
  String folderPath = '';

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
    });
  }

  @override
  void initState() {
    setState(() {
      getPath();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10,
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
                    ));
                  default:
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error with TextBooks Data or\n Check Internet Connection'));
                    } else {
                      if (BranchNews!.length == 0) {
                        return Center(
                            child: Text(
                          "No Updates",
                          style: TextStyle(color: Colors.lightBlueAccent),
                        ));
                      } else
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: BranchNews.length,
                          itemBuilder: (context, int index) {
                            file = File("");
                            final BranchNew = BranchNews[index];
                            if (BranchNew.photoUrl.isNotEmpty) {
                              final Uri uri = Uri.parse(BranchNew.photoUrl);
                              final String fileName = uri.pathSegments.last;
                              var name = fileName.split("/").last;
                              file = File("${folderPath}/updates/$name");
                            }
                            String timeDate ="";

                            List<String> parts = BranchNew.id.split('-');

                              String datePart = parts[0];
                              String timePart = parts[1];

                              List<String> dateParts = datePart.split('.');
                              List<String> timeParts = timePart.split(':');
                              if (dateParts.length == 3 && timeParts.length == 3) {
                                int day = int.parse(dateParts[0]);
                                int month = int.parse(dateParts[1]);
                                int year = int.parse(dateParts[2]);

                                int hour = int.parse(timeParts[0]);
                                int minute = int.parse(timeParts[1]);
                                int second = int.parse(timeParts[2]);
                                timeDate =formatTimeDifference(DateTime(year, month, day, hour, minute, second));
                              }


                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
                              child: Material(
                                color: Colors.white.withOpacity(0.05),
                                elevation: 8.0, // Adjust the elevation value as needed
                                borderRadius: BorderRadius.circular(18),
                                child: InkWell(
                                  child: Container(
                                    decoration: BoxDecoration( borderRadius: BorderRadius.circular(15),
                                   ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if(BranchNew.link.isEmpty &&BranchNew.photoUrl.isNotEmpty)InkWell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(15),
                                                child: Image.file(file)),
                                          ),
                                          onTap: (){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ImageZoom(
                                                      size: widget.size,
                                                      url: BranchNew.photoUrl,
                                                      file: file,
                                                    )));
                                          },
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 3),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    if(BranchNew.heading.isNotEmpty)Text(
                                                      BranchNew.heading,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: widget.size * 18,
                                                          fontWeight: FontWeight.w600),
                                                    ),
                                                    if(BranchNew.description.isNotEmpty)Text(
                                                      "  ${BranchNew.description}",
                                                      style: TextStyle(
                                                          color: Colors.white.withOpacity(0.8),
                                                          fontSize: widget.size * 14,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if(BranchNew.link.isNotEmpty&&BranchNew.photoUrl.isNotEmpty)InkWell(
                                              child: SizedBox(
                                                height: 100,
                                                width: 140,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(3.0),
                                                  child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(15),
                                                      child: Image.file(file,fit: BoxFit.cover,)),
                                                ),
                                              ),
                                              onTap: (){
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => ImageZoom(
                                                          size: widget.size,
                                                          url: BranchNew.photoUrl,
                                                          file: file,
                                                        )));
                                              },
                                            ),
                                          ],
                                        ),


                                        SizedBox(
                                            height: 2,
                                            child: Divider(color: Colors.white10,)),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 2),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${timeDate}  ",
                                                    style: TextStyle(fontSize: 12,color: Colors.white),
                                                  ),
                                                  Icon(Icons.circle,color: Colors.white,size: 3,),
                                                  Text(
                                                    "  ${BranchNew.creator.split("@").first}",
                                                    style: TextStyle(fontSize: 12,color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              if (isGmail()||isOwner())
                                                SizedBox(
                                                  height: 18,
                                                  child: PopupMenuButton(
                                                    padding: EdgeInsets.all(0),
                                                    icon: Icon(
                                                      Icons.more_horiz,
                                                      color: Colors.white,
                                                      size: widget.size * 18,
                                                    ),
                                                    // Callback that sets the selected popup menu item.
                                                    onSelected: (item) async {
                                                      if (item == "edit") {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => updateCreator(
                                                                  NewsId: BranchNew.id,
                                                                  link: BranchNew.link,
                                                                  heading: BranchNew.heading,
                                                                  photoUrl: BranchNew.photoUrl,
                                                                  subMessage: BranchNew.description,
                                                                  branch: widget.branch,
                                                                  size: widget.size,
                                                                )));
                                                      } else if (item == "delete") {
                                                        FirebaseFirestore.instance
                                                            .collection("update")
                                                            .doc(BranchNew.id)
                                                            .delete();
                                                        messageToOwner(
                                                            "Update is Deleted\nBy '${fullUserId()}\n    Heading : ${BranchNew.heading}\n    Description : ${BranchNew.description}    \nImage : ${BranchNew.photoUrl}    \nLink : ${BranchNew.link}\n **${widget.branch}");
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
                                                ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () {

                                    ExternalLaunchUrl(BranchNew.link);
                                  },
                                ),
                              ),
                            );
                          },
                        );
                    }
                }
              }),
          SizedBox(
            height: widget.size * 50,
          )
        ],
      ),
    );
  }


}
String formatTimeDifference(DateTime postedTime) {
  DateTime currentTime = DateTime.now();
  Duration difference = currentTime.difference(postedTime);

  int minutesDifference = difference.inMinutes;
  int hoursDifference = difference.inHours;
  int daysDifference = difference.inDays;
  int monthsDifference = currentTime.month - postedTime.month + (currentTime.year - postedTime.year) * 12;

  if (monthsDifference > 12) {
    int yearsDifference = monthsDifference ~/ 12;
    return '$yearsDifference years ago';
  } else if (monthsDifference > 0) {
    return '$monthsDifference months ago';
  } else if (daysDifference > 0) {
    return '$daysDifference days ago';
  } else if (hoursDifference > 0) {
    return '$hoursDifference hours ago';
  } else {
    return '$minutesDifference mins ago';
  }
}
