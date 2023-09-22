// ignore_for_file: camel_case_types, non_constant_identifier_names, must_be_immutable
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
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

class TimeTables extends StatefulWidget {
  String branch;
  String reg;
  double size;

  TimeTables({required this.branch, required this.size, required this.reg});

  @override
  State<TimeTables> createState() => _TimeTablesState();
}

class _TimeTablesState extends State<TimeTables> {
  @override
  Widget build(BuildContext context) {
    return backGroundImage(
        child: SingleChildScrollView(
      child: Column(
        children: [
          backButton(
              size: widget.size,
              text: "Time Tables",
              child: isUser()
                  ? InkWell(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 40,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    timeTableSyllabusModalPaperCreator(
                                      size: widget.size,
                                      mode: 'Time Table',
                                      reg: widget.reg,
                                      branch: widget.branch,
                                    )));
                      },
                    )
                  : SizedBox(
                      width: 45,
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
                      return const Center(
                          child: Text(
                              'Error with Time Table Data or\n Check Internet Connection'));
                    } else {
                      if (BranchNews!.length == 0) {
                        return Center(
                            child: Text(
                          "No Time Tables",
                          style: TextStyle(color: Colors.amber),
                        ));
                      } else
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: BranchNews.length,
                          itemBuilder: (context, int index) {
                            var data = BranchNews[index];

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: widget.size * 5,
                                  vertical: widget.size * 5),
                              child: InkWell(
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(data.photoUrl),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(
                                            widget.size * 20),
                                        border:
                                            Border.all(color: Colors.white12)),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(widget.size * 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              data.heading.toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.amber,
                                                  fontSize: widget.size * 30),
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
                                                            builder: (context) =>
                                                                timeTableSyllabusModalPaperCreator(
                                                                  size: widget
                                                                      .size,
                                                                  mode:
                                                                      'Time Table',
                                                                  reg: widget
                                                                      .reg,
                                                                  branch: widget
                                                                      .branch,
                                                                  id: data.id,
                                                                  heading: data
                                                                      .heading,
                                                                  link: data
                                                                      .photoUrl,
                                                                )));
                                                  } else if (item == "delete") {
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            widget.branch)
                                                        .doc("regulation")
                                                        .collection(
                                                            "regulationWithSem")
                                                        .doc(widget.reg)
                                                        .collection(
                                                            "timeTables")
                                                        .doc(data.id)
                                                        .delete();
                                                  }
                                                },
                                                itemBuilder:
                                                    (BuildContext context) =>
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
                                              )
                                          ],
                                        ),
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
                        );
                    }
                }
              }),
        ],
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
    return backGroundImage(
        child: SingleChildScrollView(
      child: Column(
        children: [
          backButton(
              size: widget.size,
              text: "Syllabus",
              child: SizedBox(
                width: 45,
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
                      return const Center(
                          child: Text(
                              'Error with Syllabus Data or\n Check Internet Connection'));
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
                              file = File(
                                  "${folderPath}/pdfs/${getFileName(data.syllabus)}");

                            return Padding(
                              padding: EdgeInsets.only(
                                  left: widget.size * 15.0,
                                  right: widget.size * 10,
                                  top: widget.size * 4),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(widget.size * 20))),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Row(
                                    children: [
                                      if (data.syllabus.length > 3)
                                        file.existsSync() &&
                                                data.syllabus.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        widget.size * 25),
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
                                                height: widget.size * 98,
                                                child: Image.asset(
                                                    "assets/pdf_icon.png")),
                                      SizedBox(
                                        width: widget.size * 15,
                                      ),
                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                    fontSize:
                                                        widget.size * 20.0,
                                                    color: Colors.amber,
                                                    fontWeight: FontWeight.w600,
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
                                                              builder: (context) =>
                                                                  timeTableSyllabusModalPaperCreator(
                                                                    size: widget
                                                                        .size,
                                                                    mode:
                                                                        'syllabus',
                                                                    reg: widget
                                                                        .reg,
                                                                    branch: widget
                                                                        .branch,
                                                                    id: data.id,
                                                                    heading:
                                                                        data.id,
                                                                    link: data
                                                                        .syllabus,
                                                                  )));
                                                    } else if (item ==
                                                        "delete") {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              widget.branch)
                                                          .doc("regulation")
                                                          .collection(
                                                              "regulationWithYears")
                                                          .doc(data.id
                                                              .substring(0, 10))
                                                          .update(
                                                              {"syllabus": ""});
                                                    }
                                                  },
                                                  itemBuilder:
                                                      (BuildContext context) =>
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
                                          ),
                                          SizedBox(
                                            height: widget.size * 2,
                                          ),
                                          if (data.syllabus.isNotEmpty)
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: widget.size * 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          widget.size *
                                                                              8),
                                                              color: Color
                                                                  .fromRGBO(
                                                                      2,
                                                                      82,
                                                                      87,
                                                                      1),
                                                              border: Border.all(
                                                                  color: file
                                                                          .existsSync()
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .white),
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets.only(
                                                                  left: widget
                                                                          .size *
                                                                      3,
                                                                  right: widget
                                                                          .size *
                                                                      3),
                                                              child: Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: widget.size *
                                                                            5,
                                                                        right:
                                                                            widget.size *
                                                                                5,
                                                                        top: widget.size *
                                                                            3,
                                                                        bottom:
                                                                            widget.size *
                                                                                3),
                                                                    child: Text(
                                                                      file.existsSync()
                                                                          ? "Read Now"
                                                                          : "Download",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              widget.size * 20),
                                                                    ),
                                                                  ),
                                                                  Icon(
                                                                    file.existsSync()
                                                                        ? Icons
                                                                            .open_in_new
                                                                        : Icons
                                                                            .download_for_offline_outlined,
                                                                    color: Colors
                                                                        .greenAccent,
                                                                    size: widget
                                                                            .size *
                                                                        20,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          onTap: () async {
                                                            File isFile = File(
                                                                "${folderPath}/pdfs/${getFileName(data.syllabus)}");
                                                            if (isFile
                                                                .existsSync()) {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => PdfViewerPage(
                                                                          size: widget
                                                                              .size,
                                                                          pdfUrl:
                                                                              "${folderPath}/pdfs/${getFileName(data.syllabus)}")));
                                                            } else {
                                                              setState(() {
                                                                isDownloaded =
                                                                    true;
                                                              });
                                                              await download(
                                                                  data.syllabus,
                                                                  "pdfs");
                                                            }
                                                          }),
                                                      if (file.existsSync())
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              left:
                                                                  widget.size *
                                                                      5,
                                                              right:
                                                                  widget.size *
                                                                      5,
                                                              top: widget.size *
                                                                  1,
                                                              bottom:
                                                                  widget.size *
                                                                      1),
                                                          child: InkWell(
                                                            child: Icon(
                                                              Icons.delete,
                                                              color: Colors
                                                                  .redAccent,
                                                              size:
                                                                  widget.size *
                                                                      25,
                                                            ),
                                                            onLongPress:
                                                                () async {
                                                              if (file
                                                                  .existsSync()) {
                                                                await file
                                                                    .delete();
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
                                                ExternalLaunchUrl(
                                                    data.syllabus);
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
    return backGroundImage(
        child: SingleChildScrollView(
      child: Column(
        children: [
          backButton(
              size: widget.size,
              text: "Model Papers",
              child: SizedBox(
                width: 45,
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
                      return const Center(
                          child: Text(
                              'Error with Model Papers Data or\n Check Internet Connection'));
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
                              file = File(
                                  "${folderPath}/pdfs/${getFileName(data.modelPaper)}");

                            return Padding(
                              padding: EdgeInsets.only(
                                  left: widget.size * 15.0,
                                  right: widget.size * 10,
                                  top: widget.size * 4),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(widget.size * 20))),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Row(
                                    children: [
                                      if (data.modelPaper.length > 3)
                                        file.existsSync() &&
                                                data.modelPaper.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        widget.size * 25),
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
                                                height: widget.size * 98,
                                                child: Image.asset(
                                                    "assets/pdf_icon.png")),
                                      SizedBox(
                                        width: widget.size * 15,
                                      ),
                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                    fontSize:
                                                        widget.size * 20.0,
                                                    color: Colors.amber,
                                                    fontWeight: FontWeight.w600,
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
                                                              builder: (context) =>
                                                                  timeTableSyllabusModalPaperCreator(
                                                                    size: widget
                                                                        .size,
                                                                    mode:
                                                                        'modalPaper',
                                                                    reg: widget
                                                                        .reg,
                                                                    branch: widget
                                                                        .branch,
                                                                    id: data.id,
                                                                    heading:
                                                                        data.id,
                                                                    link1: data
                                                                        .modelPaper,
                                                                  )));
                                                    } else if (item ==
                                                        "delete") {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              widget.branch)
                                                          .doc("regulation")
                                                          .collection(
                                                              "regulationWithYears")
                                                          .doc(data.id
                                                              .substring(0, 10))
                                                          .update({
                                                        "modelPaper": ""
                                                      });
                                                    }
                                                  },
                                                  itemBuilder:
                                                      (BuildContext context) =>
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
                                          ),
                                          SizedBox(
                                            height: widget.size * 2,
                                          ),
                                          if (data.modelPaper.isNotEmpty)
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: widget.size * 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          widget.size *
                                                                              8),
                                                              color: Color
                                                                  .fromRGBO(
                                                                      2,
                                                                      82,
                                                                      87,
                                                                      1),
                                                              border: Border.all(
                                                                  color: file
                                                                          .existsSync()
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .white),
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets.only(
                                                                  left: widget
                                                                          .size *
                                                                      3,
                                                                  right: widget
                                                                          .size *
                                                                      3),
                                                              child: Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: widget.size *
                                                                            5,
                                                                        right:
                                                                            widget.size *
                                                                                5,
                                                                        top: widget.size *
                                                                            3,
                                                                        bottom:
                                                                            widget.size *
                                                                                3),
                                                                    child: Text(
                                                                      file.existsSync()
                                                                          ? "Read Now"
                                                                          : "Download",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              widget.size * 20),
                                                                    ),
                                                                  ),
                                                                  Icon(
                                                                    file.existsSync()
                                                                        ? Icons
                                                                            .open_in_new
                                                                        : Icons
                                                                            .download_for_offline_outlined,
                                                                    color: Colors
                                                                        .greenAccent,
                                                                    size: widget
                                                                            .size *
                                                                        20,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          onTap: () async {
                                                            File isFile = File(
                                                                "${folderPath}/pdfs/${getFileName(data.modelPaper)}");
                                                            if (isFile
                                                                .existsSync()) {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => PdfViewerPage(
                                                                          size: widget
                                                                              .size,
                                                                          pdfUrl:
                                                                              "${folderPath}/pdfs/${getFileName(data.modelPaper)}")));
                                                            } else {
                                                              setState(() {
                                                                isDownloaded =
                                                                    true;
                                                              });
                                                              await download(
                                                                  data.modelPaper,
                                                                  "pdfs");
                                                            }
                                                          }),
                                                      if (file.existsSync())
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              left:
                                                                  widget.size *
                                                                      5,
                                                              right:
                                                                  widget.size *
                                                                      5,
                                                              top: widget.size *
                                                                  1,
                                                              bottom:
                                                                  widget.size *
                                                                      1),
                                                          child: InkWell(
                                                            child: Icon(
                                                              Icons.delete,
                                                              color: Colors
                                                                  .redAccent,
                                                              size:
                                                                  widget.size *
                                                                      25,
                                                            ),
                                                            onLongPress:
                                                                () async {
                                                              if (file
                                                                  .existsSync()) {
                                                                await file
                                                                    .delete();
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
                                                ExternalLaunchUrl(
                                                    data.modelPaper);
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
    ));
  }
}

class NewsPage extends StatefulWidget {
  final String branch;
  final double size;

  const NewsPage({
    Key? key,
    required this.branch,
    required this.size,
  }) : super(key: key);

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
    getPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                    ));
                  default:
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text(
                              'Error with TextBooks Data or\n Check Internet Connection'));
                    } else {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: BranchNews!.length,
                        itemBuilder: (context, int index) {
                          final BranchNew = BranchNews[index];
                          if (BranchNew.photoUrl.isNotEmpty) {
                            final Uri uri = Uri.parse(BranchNew.photoUrl);
                            final String fileName = uri.pathSegments.last;
                            var name = fileName.split("/").last;
                            file = File("${folderPath}/news/$name");
                          }
                          return InkWell(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: widget.size * 8,
                                      vertical: widget.size * 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: widget.size * 25,
                                        width: widget.size * 25,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              widget.size * 15),
                                          image: DecorationImage(
                                              image: FileImage(file),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      if (BranchNew.heading.isNotEmpty)
                                        Text(" ${BranchNew.heading}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: widget.size * 20,
                                                fontWeight: FontWeight.w600))
                                      else
                                        Text(" ${widget.branch} (SRKR)",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: widget.size * 20,
                                                fontWeight: FontWeight.w400)),
                                      Spacer(),
                                      if (isUser())
                                        PopupMenuButton(
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: Colors.white,
                                            size: widget.size * 22,
                                          ),
                                          // Callback that sets the selected popup menu item.
                                          onSelected: (item) async {
                                            if (item == "edit") {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          NewsCreator(
                                                              branch:
                                                                  widget.branch,
                                                              NewsId:
                                                                  BranchNew.id,
                                                              heading: BranchNew
                                                                  .heading,
                                                              description:
                                                                  BranchNew
                                                                      .description,
                                                              photoUrl: BranchNew
                                                                  .photoUrl)));
                                            } else if (item == "delete") {
                                              if (BranchNew
                                                  .photoUrl.isNotEmpty) {
                                                final Uri uri = Uri.parse(
                                                    BranchNew.photoUrl);
                                                final String fileName =
                                                    uri.pathSegments.last;
                                                final Reference ref = storage
                                                    .ref()
                                                    .child("/${fileName}");
                                                try {
                                                  await ref.delete();
                                                  showToastText(
                                                      'Image deleted successfully');
                                                } catch (e) {
                                                  showToastText(
                                                      'Error deleting image: $e');
                                                }
                                              }
                                              FirebaseFirestore.instance
                                                  .collection(widget.branch)
                                                  .doc("${widget.branch}News")
                                                  .collection(
                                                      "${widget.branch}News")
                                                  .doc(BranchNew.id)
                                                  .delete();
                                              pushNotificationsSpecificPerson(
                                                  fullUserId(),
                                                  " ${BranchNew.heading} Deleted from News",
                                                  "");
                                            }
                                          },
                                          itemBuilder: (BuildContext context) =>
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
                                  ),
                                ),
                                if (BranchNew.photoUrl.isNotEmpty)
                                  Image.file(file),
                                if (BranchNew.description.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.all(
                                      widget.size * 8,
                                    ),
                                    child: StyledTextWidget(
                                      text: BranchNew.description,
                                      fontSize: widget.size * 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: widget.size * 8,
                                    bottom: widget.size * 8,
                                  ),
                                  child: Text(
                                    BranchNew.id.split("-").first.length < 12
                                        ? "~ ${BranchNew.id.split('-').first}"
                                        : "No Date",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: widget.size * 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  height: widget.size * 25,
                                )
                              ],
                            ),
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImageZoom(
                                            size: widget.size,
                                            url: "",
                                            file: file,
                                          )));
                            },
                          );
                        },
                      );
                    }
                }
              }),
          SizedBox(
            height: widget.size * 150,
          )
        ],
      ),
    );
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
  String folderPath = "";
String subjectFilter="None";
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
    return backGroundImage(
        child: SingleChildScrollView(
      child: Column(
        children: [
          backButton(
              size: widget.size,
              text: "Subjects",
              child: isUser()
                  ? Row(
                    children: [
                      PopupMenuButton(
                        icon: Icon(
                          Icons.filter_list,
                          color: Colors.white,
                          size: 30,
                        ),
                        // Callback that sets the selected popup menu item.
                        onSelected: (item) {
                          setState(() {
                            subjectFilter = item as String;
                          });
                        },
                        itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry>[
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
                      InkWell(
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 40,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SubjectsCreator(
                                          branch: widget.branch,
                                        )));
                          },
                        ),
                    ],
                  )
                  : SizedBox(
                      width: 45,
                    )),

          StreamBuilder<List<FlashConvertor>>(
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
                      List<FlashConvertor> filteredItems = user!
                          .where((item) => item.regulation
                              .toString()
                              .toLowerCase()
                              .startsWith(widget.reg.substring(0, 2)))
                          .toList();
                      return Column(
                        children: [
                          if (filteredItems.isNotEmpty &&subjectFilter=="Regulation")
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Based On Your Regulation",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 25,fontWeight: FontWeight.w500),
                              ),
                            ),
                          if (filteredItems.isNotEmpty&&subjectFilter=="Regulation")
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: filteredItems.length,
                              itemBuilder: (context, int index) {
                                final SubjectsData = filteredItems[index];

                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: widget.width * 10,
                                      vertical: widget.height * 1),
                                  child: InkWell(
                                    child:subjectsContainer(data: SubjectsData,branch: widget.branch,),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration:
                                              const Duration(milliseconds: 300),
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              subjectUnitsData(
                                            reg: SubjectsData.regulation,
                                            size: widget.size,
                                            branch: widget.branch,
                                            ID: SubjectsData.id,
                                            mode: "Subjects",
                                            name: SubjectsData.heading,
                                                description: SubjectsData.description,
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
                                                  .withOpacity(animation.value),
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
                                );
                              },
                            ),
                          if (filteredItems.isNotEmpty&&subjectFilter=="Regulation")
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "All Subjects",
                                style: TextStyle(
                                    color: Colors.white,fontSize: 25,fontWeight: FontWeight.w500),
                              ),
                            ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: user.length,
                            itemBuilder: (context, int index) {
                              final SubjectsData = user[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: widget.width * 5,
                                    vertical: widget.height * 2),
                                child: InkWell(
                                  child: subjectsContainer(data: SubjectsData,branch: widget.branch,),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(milliseconds: 300),
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            subjectUnitsData(
                                          reg: SubjectsData.regulation,
                                          size: widget.size,
                                          branch: widget.branch,
                                          ID: SubjectsData.id,
                                          mode: "Subjects",
                                          name: SubjectsData.heading,
                                              description: SubjectsData.description,
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
                              );
                            },
                          ),
                        ],
                      );
                    }
                }
              }),
          SizedBox(height: 150,)
        ],
      ),
    ));
  }
}
class subjectsContainer extends StatefulWidget {
  FlashConvertor data;
  String branch;
   subjectsContainer({required this.data,required this.branch});


  @override
  State<subjectsContainer> createState() => _subjectsContainerState();
}

class _subjectsContainerState extends State<subjectsContainer> {
  bool isExp=false;
  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return AnimatedContainer(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.all(
              Radius.circular(
                  Size * 20))),
      duration: Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 15, vertical: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data.heading.split(";").first,
                        style: TextStyle(
                          fontSize:
                          Size *
                              22.0,
                          color: Colors.white,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),

                      Text(
                        widget.data.heading.split(";").last,
                        style: TextStyle(
                          fontSize:
                          Size * 15.0,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(18)
                    ),
                    child: Icon(isExp?Icons.arrow_drop_up:Icons.arrow_drop_down,color: Colors.white,),
                  ),
                  onTap: (){
                    setState(() {
                      isExp=!isExp;

                    });
                  },
                ),
              ],
            ),

            if(isExp)Row(
              mainAxisAlignment:widget.data
                  .regulation
                  .isNotEmpty? MainAxisAlignment.spaceBetween:MainAxisAlignment.end,

              children: [
                if (widget.data
                    .regulation
                    .isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(
                            Size *
                                5),
                        border: Border.all(
                            color: Colors
                                .white30)),
                    child: Padding(
                      padding: const EdgeInsets
                          .symmetric(
                          vertical: 3,
                          horizontal:
                          8),
                      child: Text(
                        widget.data
                            .regulation,
                        style: TextStyle(
                            color: Colors
                                .white,
                            fontSize:
                            Size *
                                10),
                      ),
                    ),
                  ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius:
                    BorderRadius.circular(Size * 20)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (true)
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
                                  return Icon(
                                      Icons.bookmark_added_rounded,
                                      size: Size * 20,
                                      color: Colors.cyanAccent);
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
                                  showToastText(
                                      "Removed from saved list");
                                } else {
                                  FavouriteSubjects(
                                    branch: widget.branch,
                                    SubjectId: widget.data.id,
                                    name: widget.data.heading,
                                    description: widget.data.description,
                                  );
                                  showToastText(
                                      "${widget.data.heading} in favorites");
                                }
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                        )
                      // else
                      //   InkWell(
                      //     child: StreamBuilder<DocumentSnapshot>(
                      //       stream: FirebaseFirestore.instance
                      //           .collection('user')
                      //           .doc(fullUserId())
                      //           .collection("FavouriteLabSubjects")
                      //           .doc(widget.ID)
                      //           .snapshots(),
                      //       builder: (context, snapshot) {
                      //         if (snapshot.hasData) {
                      //           if (snapshot.data!.exists) {
                      //             return Row(
                      //               children: [
                      //                 Icon(Icons.library_add_check,
                      //                     size: widget.size * 23,
                      //                     color: Colors.cyanAccent),
                      //                 Text(
                      //                   " Saved",
                      //                   style: TextStyle(
                      //                       color: Colors.white,
                      //                       fontSize: widget.size * 20),
                      //                 )
                      //               ],
                      //             );
                      //           } else {
                      //             return Row(
                      //               children: [
                      //                 Icon(
                      //                   Icons.library_add_outlined,
                      //                   size: widget.size * 23,
                      //                   color: Colors.cyanAccent,
                      //                 ),
                      //                 Text(
                      //                   " Save",
                      //                   style: TextStyle(
                      //                       color: Colors.white,
                      //                       fontSize: widget.size * 20),
                      //                 )
                      //               ],
                      //             );
                      //           }
                      //         } else {
                      //           return Container();
                      //         }
                      //       },
                      //     ),
                      //     onTap: () async {
                      //       try {
                      //         await FirebaseFirestore.instance
                      //             .collection('user')
                      //             .doc(fullUserId())
                      //             .collection("FavouriteLabSubjects")
                      //             .doc(widget.ID)
                      //             .get()
                      //             .then((docSnapshot) {
                      //           if (docSnapshot.exists) {
                      //             FirebaseFirestore.instance
                      //                 .collection('user')
                      //                 .doc(fullUserId())
                      //                 .collection(
                      //                 "FavouriteLabSubjects")
                      //                 .doc(widget.ID)
                      //                 .delete();
                      //             showToastText(
                      //                 "Removed from saved list");
                      //           } else {
                      //             FavouriteLabSubjectsSubjects(
                      //               branch: widget.branch,
                      //               SubjectId: widget.ID,
                      //               name: widget.name,
                      //               description: widget.description,
                      //             );
                      //             showToastText(
                      //                 "${widget.name} in favorites");
                      //           }
                      //         });
                      //       } catch (e) {
                      //         print(e);
                      //       }
                      //     },
                      //   )
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
                mode: "Subjects",
                size: Size*0.65,
              ),
              if (isUser())
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
                          transitionDuration:
                          const Duration(
                              milliseconds:
                              300),
                          pageBuilder: (context,
                              animation,
                              secondaryAnimation) =>
                              SubjectsCreator(
                                reg: widget.data.regulation,
                                branch: widget.branch,
                                Id: widget.data.id,
                                heading: widget.data
                                    .heading,
                                description:
                                widget.data
                                    .description,
                                photoUrl: widget.data
                                    .PhotoUrl,
                                mode: "Subjects",
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
                                  opacity:
                                  animation
                                      .value
                                      .clamp(
                                      0.3,
                                      1.0),
                                  child:
                                  fadeTransition),
                            );
                          },
                        ),
                      );
                    } else if (item == "delete") {
                      FirebaseFirestore.instance
                          .collection(
                          widget.branch)
                          .doc("Subjects")
                          .collection("Subjects")
                          .doc(widget.data.id)
                          .delete();
                    }
                  },
                  itemBuilder:
                      (BuildContext context) =>
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
                )
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
    return backGroundImage(
        child: SingleChildScrollView(
      child: Column(
        children: [
          backButton(
              size: widget.size,
              text: "${widget.branch} Lab Subjects",
              child: isUser()
                  ? InkWell(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 40,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubjectsCreator(
                                      branch: widget.branch,
                                    )));
                      },
                    )
                  : SizedBox(
                      width: 45,
                    )),
          StreamBuilder<List<LabSubjectsConvertor>>(
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
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: LabSubjects!.length,
                        itemBuilder: (context, int index) {
                          final LabSubjectsData = LabSubjects[index];

                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: widget.height * 1,
                                horizontal: widget.width * 10),
                            child: InkWell(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(widget.size * 20))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  LabSubjectsData.heading,
                                                  style: TextStyle(
                                                    fontSize:
                                                        widget.size * 22.0,
                                                    color: Colors.amber,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                InkWell(
                                                  child: StreamBuilder<
                                                      DocumentSnapshot>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('user')
                                                        .doc(fullUserId())
                                                        .collection(
                                                            "FavouriteLabSubjects")
                                                        .doc(LabSubjectsData.id)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        if (snapshot
                                                            .data!.exists) {
                                                          return Icon(
                                                              Icons
                                                                  .library_add_check,
                                                              size:
                                                                  widget.size *
                                                                      26,
                                                              color: Colors
                                                                  .cyanAccent);
                                                        } else {
                                                          return Icon(
                                                            Icons
                                                                .library_add_outlined,
                                                            size: widget.size *
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
                                                          .collection('user')
                                                          .doc(fullUserId())
                                                          .collection(
                                                              "FavouriteLabSubjects")
                                                          .doc(LabSubjectsData
                                                              .id)
                                                          .get()
                                                          .then((docSnapshot) {
                                                        if (docSnapshot
                                                            .exists) {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'user')
                                                              .doc(fullUserId())
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
                                                            branch:
                                                                widget.branch,
                                                            SubjectId:
                                                                LabSubjectsData
                                                                    .id,
                                                            name:
                                                                LabSubjectsData
                                                                    .heading,
                                                            description:
                                                                LabSubjectsData
                                                                    .description,
                                                          );
                                                          showToastText(
                                                              "${LabSubjectsData.heading} in favorites");
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
                                              height: widget.height * 2,
                                            ),
                                            Text(
                                              LabSubjectsData.description,
                                              style: TextStyle(
                                                fontSize: widget.size * 13.0,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
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
                                                PageRouteBuilder(
                                                  transitionDuration:
                                                      const Duration(
                                                          milliseconds: 300),
                                                  pageBuilder: (context,
                                                          animation,
                                                          secondaryAnimation) =>
                                                      SubjectsCreator(
                                                    reg: widget.reg,
                                                    branch: widget.branch,
                                                    Id: LabSubjectsData.id,
                                                    heading:
                                                        LabSubjectsData.heading,
                                                    description: LabSubjectsData
                                                        .description,
                                                    mode: "LabSubjects",
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
                                                              milliseconds:
                                                                  300),
                                                          opacity: animation
                                                              .value
                                                              .clamp(0.3, 1.0),
                                                          child:
                                                              fadeTransition),
                                                    );
                                                  },
                                                ),
                                              );
                                            } else if (item == "delete") {
                                              FirebaseFirestore.instance
                                                  .collection(widget.branch)
                                                  .doc("LabSubjects")
                                                  .collection("LabSubjects")
                                                  .doc(LabSubjectsData.id)
                                                  .delete();
                                            }
                                          },
                                          itemBuilder: (BuildContext context) =>
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
                                      reg: LabSubjectsData.regulation,
                                      size: widget.size,
                                      branch: widget.branch,
                                      ID: LabSubjectsData.id,
                                      mode: "LabSubjects",
                                      name: LabSubjectsData.heading,
                                          description: LabSubjectsData.description,
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
                              onLongPress: () {
                                FavouriteLabSubjectsSubjects(
                                  branch: widget.branch,
                                  SubjectId: LabSubjectsData.id,
                                  name: LabSubjectsData.heading,
                                  description: LabSubjectsData.description,
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
                      return const Center(
                          child: Text(
                              'Error with TextBooks Data or\n Check Internet Connection'));
                    } else {
                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 16 / 36,
                        ),
                        itemCount: Books!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return textBookSub(
                            height: widget.size,
                            width: widget.size,
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
            height: 150,
          )
        ],
      ),
    );
  }
}

class textBookSub extends StatefulWidget {
  String branch;
  String id;
  BooksConvertor data;
  double width;
  double height;
  double size;
  bool isUnit;

  textBookSub(
      {required this.height,
      required this.size,
      this.id = "",
      required this.width,
      required this.data,
      this.isUnit = false,
      required this.branch});

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
    if (widget.data.link.isNotEmpty)
      file = File("${folderPath}/pdfs/${getFileName(widget.data.link)}");

    return Padding(
      padding: EdgeInsets.all(widget.size * 2.0),
      child: InkWell(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.size * 15),
                color: Colors.white.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 2,
                      color: Colors.black12,
                      offset: Offset(1, 3))
                ]),
            child: Padding(
              padding: EdgeInsets.all(widget.size * 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 22,
                    child: file.existsSync() && widget.data.link.isNotEmpty
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.circular(widget.size * 15),
                            child: Stack(
                              children: [
                                isLoading
                                    ? PDFView(
                                        defaultPage: index,
                                        filePath:
                                            "${folderPath}/pdfs/${getFileName(widget.data.link)}",
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
                                    padding: EdgeInsets.only(
                                        right: widget.size * 15,
                                        top: widget.size * 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            widget.size * 25),
                                        color: Colors.black.withOpacity(0.8),
                                        border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.5)),
                                      ),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(widget.size * 4.0),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        widget.size * 25),
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                                border: Border.all(
                                                    color: Colors.white
                                                        .withOpacity(0.5)),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: widget.size * 3,
                                                    horizontal:
                                                        widget.size * 10),
                                                child: Text(
                                                  "-",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          widget.size * 25,
                                                      fontWeight:
                                                          FontWeight.w800),
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        widget.size * 25),
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                                border: Border.all(
                                                    color: Colors.white
                                                        .withOpacity(0.5)),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: widget.size * 3,
                                                    horizontal:
                                                        widget.size * 8),
                                                child: Text(
                                                  "+",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          widget.size * 25,
                                                      fontWeight:
                                                          FontWeight.w800),
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
                            borderRadius:
                                BorderRadius.circular(widget.size * 15),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: widget.data.photoUrl.isNotEmpty &&
                                          File("${folderPath}/books/${getFileName(widget.data.photoUrl)}")
                                              .existsSync()
                                      ? DecorationImage(
                                          image: FileImage(
                                            File(
                                                "${folderPath}/books/${getFileName(widget.data.photoUrl)}"),
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
                                    fontWeight: FontWeight.w600,
                                    fontSize: widget.size * 15,
                                    color: Colors.white),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
                                onSelected: (item) async {
                                  if (item == "edit") {
                                    if (widget.isUnit)
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BooksCreator(
                                                    branch: widget.branch,
                                                    id: widget.data.id,
                                                    heading:
                                                        widget.data.heading,
                                                    description:
                                                        widget.data.description,
                                                    Edition:
                                                        widget.data.edition,
                                                    Link: widget.data.link,
                                                    Author: widget.data.Author,
                                                    photoUrl:
                                                        widget.data.photoUrl,
                                                  )));
                                    else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UnitsCreator(
                                                    type: "textbook",
                                                    branch: widget.branch,
                                                    mode: "Subjects",
                                                    UnitId: widget.id,
                                                    Description:
                                                        widget.data.description,
                                                    id: widget.data.id,
                                                    photoUrl:
                                                        widget.data.photoUrl,
                                                    edition:
                                                        widget.data.edition,
                                                    Heading:
                                                        widget.data.heading,
                                                    author: widget.data.Author,
                                                    PDFUrl: widget.data.link,
                                                  )));
                                    }
                                    ;
                                  } else if (item == "delete") {
                                    if (widget.isUnit)
                                      FirebaseFirestore.instance
                                          .collection(widget.branch)
                                          .doc("Books")
                                          .collection("CoreBooks")
                                          .doc(widget.data.id)
                                          .delete();
                                    else {
                                      final deleteFlashNews = FirebaseFirestore
                                          .instance
                                          .collection(widget.branch)
                                          .doc("Subjects")
                                          .collection("Subjects")
                                          .doc(widget.id)
                                          .collection("TextBooks")
                                          .doc(widget.data.id);
                                      deleteFlashNews.delete();
                                      pushNotificationsSpecificPerson(
                                          "sujithnimmala03@gmail.com",
                                          "${widget.data.id} Unit is deleted from Subjects}",
                                          "");
                                    }
                                    ;
                                    pushNotificationsSpecificPerson(
                                        fullUserId(),
                                        "${widget.data.heading} Deleted from Books",
                                        "");
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
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
                        ),
                        Text(
                          widget.data.Author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: widget.size * 10,
                              color: Colors.white70),
                        ),
                        Text(
                          widget.data.edition,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: widget.size * 10,
                              color: Colors.white70),
                        ),
                        if (widget.data.link.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                  child: Padding(
                                    padding: EdgeInsets.all(widget.width * 3),
                                    child: Row(
                                      children: [
                                        if (!file.existsSync())
                                          Text(
                                            "Download ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: widget.size * 16,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        Icon(
                                          file.existsSync()
                                              ? Icons.open_in_new
                                              : Icons
                                                  .download_for_offline_outlined,
                                          color: Colors.greenAccent,
                                          size: widget.size * 35,
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () async {
                                    File isFile = File(
                                        "${folderPath}/pdfs/${getFileName(widget.data.link)}");
                                    if (isFile.existsSync()) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => PdfViewerPage(
                                                  size: widget.size,
                                                  pdfUrl:
                                                      "${folderPath}/pdfs/${getFileName(widget.data.link)}")));
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
                                      left: widget.width * 5,
                                      right: widget.width * 5,
                                      top: widget.height * 1,
                                      bottom: widget.height * 1),
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
          }),
    );
  }
}

class textBookUnit extends StatefulWidget {
  String branch;
  String id;
  BooksConvertor data;
  double width;
  double height;
  double size;
  bool isUnit;

  textBookUnit(
      {required this.height,
      required this.size,
      this.id = "",
      required this.width,
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
    if (widget.data.link.isNotEmpty)
      file = File("${folderPath}/pdfs/${getFileName(widget.data.link)}");

    return Column(
      children: [
        InkWell(
            child: AnimatedContainer(
              decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25), bottom: Radius.circular(15))),
              width: isExp ? 280 : 120,
              height: isExp ? 200 : 180,
              duration: Duration(milliseconds: 300),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: isExp
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      file.existsSync() && widget.data.link.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: SizedBox(
                                height: 140,
                                width: 118,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(widget.size * 20),
                                  child: Stack(
                                    children: [
                                      isLoading
                                          ? PDFView(
                                              defaultPage: index,
                                              filePath:
                                                  "${folderPath}/pdfs/${getFileName(widget.data.link)}",
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
                                          padding: EdgeInsets.only(
                                              right: widget.size * 15,
                                              top: widget.size * 8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      widget.size * 25),
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.5)),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  widget.size * 4.0),
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
                              borderRadius:
                                  BorderRadius.circular(widget.size * 15),
                              child: Container(
                                height: 140,
                                width: 118,
                                decoration: BoxDecoration(
                                    image: widget.data.photoUrl.isNotEmpty &&
                                            File("${folderPath}/books/${getFileName(widget.data.photoUrl)}")
                                                .existsSync()
                                        ? DecorationImage(
                                            image: FileImage(
                                              File(
                                                  "${folderPath}/books/${getFileName(widget.data.photoUrl)}"),
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
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: Colors.white
                                                              .withOpacity(0.8),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 3,
                                                                  horizontal:
                                                                      5),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.delete,
                                                                color: Colors
                                                                    .deepOrange,
                                                                size: widget
                                                                        .size *
                                                                    25,
                                                              ),
                                                              Text(
                                                                "Delete ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
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
                                                        showToastText(
                                                            "File has been deleted");
                                                      },
                                                      onTap: () {
                                                        showToastText(
                                                            "Long Press To Delete");
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  InkWell(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10, bottom: 5),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: Colors.white
                                                              .withOpacity(0.8),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 3,
                                                                  horizontal:
                                                                      5),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "Read Now",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .open_in_new,
                                                                color: Colors
                                                                    .purpleAccent,
                                                                size: widget
                                                                        .size *
                                                                    25,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      File isFile = File(
                                                          "${folderPath}/pdfs/${getFileName(widget.data.link)}");
                                                      if (isFile.existsSync()) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    PdfViewerPage(
                                                                        size: widget
                                                                            .size,
                                                                        pdfUrl:
                                                                            "${folderPath}/pdfs/${getFileName(widget.data.link)}")));
                                                      } else {
                                                        showToastText(
                                                            "Download Book");
                                                      }
                                                    },
                                                  ),
                                                ],
                                              )
                                            else
                                              InkWell(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10, bottom: 5),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 3,
                                                                horizontal: 5),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "Download",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .file_download_outlined,
                                                              color: Colors
                                                                  .purpleAccent,
                                                              size:
                                                                  widget.size *
                                                                      25,
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
                                                    await download(
                                                        widget.data.link,
                                                        "pdfs");
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
                                  fontWeight: FontWeight.w600,
                                  fontSize: widget.size * 18,
                                  color: Colors.white),
                              maxLines: isExp ? 2 : 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isUser())
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
                                                  description:
                                                      widget.data.description,
                                                  Edition: widget.data.edition,
                                                  Link: widget.data.link,
                                                  Author: widget.data.Author,
                                                  photoUrl:
                                                      widget.data.photoUrl,
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
                                                  Description:
                                                      widget.data.description,
                                                  id: widget.data.id,
                                                  photoUrl:
                                                      widget.data.photoUrl,
                                                  edition: widget.data.edition,
                                                  Heading: widget.data.heading,
                                                  author: widget.data.Author,
                                                  PDFUrl: widget.data.link,
                                                )));
                                  }
                                  ;
                                } else if (item == "delete") {
                                  if (widget.isUnit)
                                    FirebaseFirestore.instance
                                        .collection(widget.branch)
                                        .doc("Books")
                                        .collection("CoreBooks")
                                        .doc(widget.data.id)
                                        .delete();
                                  else {
                                    final deleteFlashNews = FirebaseFirestore
                                        .instance
                                        .collection(widget.branch)
                                        .doc("Subjects")
                                        .collection("Subjects")
                                        .doc(widget.id)
                                        .collection("TextBooks")
                                        .doc(widget.data.id);
                                    deleteFlashNews.delete();
                                    pushNotificationsSpecificPerson(
                                        "sujithnimmala03@gmail.com",
                                        "${widget.data.id} Unit is deleted from Subjects}",
                                        "");
                                  }
                                  ;
                                  pushNotificationsSpecificPerson(
                                      fullUserId(),
                                      "${widget.data.heading} Deleted from Books",
                                      "");
                                }
                              },
                              itemBuilder: (BuildContext context) =>
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
            }),
      ],
    );
  }
}

class subjectUnitsData extends StatefulWidget {
  String ID, mode;
  String name;

  String description;
  String branch;
  String reg;
  final double size;

  subjectUnitsData({
    required this.ID,
    required this.mode,
    required this.branch,
    required this.description,
    required this.reg,
    this.name = "Subjects",
    required this.size,
  });

  @override
  State<subjectUnitsData> createState() => _subjectUnitsDataState();
}

class _subjectUnitsDataState extends State<subjectUnitsData>
    with TickerProviderStateMixin {
  bool isReadMore = false;
  bool isDownloaded = false;
  String folderPath = "";
  File file = File("");
  bool isUnits = true;
  bool isTextbooks = false;
  String unitFilter = "all";
  String moreFilter = "all";

  final List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];


  @override
  Widget build(BuildContext context) => backGroundImage(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backButton(
                size: widget.size,
                text: widget.name,
                child: isUser()
                    ? PopupMenuButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: widget.size * 25,
                        ),
                        // Callback that sets the selected popup menu item.
                        onSelected: (item) {
                          if (item == "addUnit") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UnitsCreator(
                                          type: "unit",
                                          branch: widget.branch,
                                          id: widget.ID,
                                          mode: widget.mode,
                                        )));
                          } else if (item == "addTextBook") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UnitsCreator(
                                          type: "textbook",
                                          branch: widget.branch,
                                          id: widget.ID,
                                          mode: widget.mode,
                                        )));
                          } else if (item == "addMore") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UnitsCreator(
                                          type: "more",
                                          branch: widget.branch,
                                          id: widget.ID,
                                          mode: widget.mode,
                                        )));
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                          const PopupMenuItem(
                            value: "addUnit",
                            child: Text('Add Unit'),
                          ),
                          if (widget.mode == "Subjects")
                            PopupMenuItem(
                              value: "addTextBook",
                              child: Text('Add TextBook'),
                            ),
                          const PopupMenuItem(
                            value: "addMore",
                            child: Text('Add More'),
                          ),
                        ],
                      )
                    : SizedBox(
                        width: 45,
                      )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.name.split(";").last.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: widget.size * 5,
                          left: widget.size * 8,
                          right: widget.size * 8),
                      child: Text(
                        widget.name.split(";").last,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.size * 25,
                            fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: widget.size * 10),
                    child: Row(
                      children: [
                        Text(
                          "${months[int.tryParse(widget.ID.split('-').first.split('.')[1]) ?? 0]} ${widget.ID.split('-').first.split('.').last}",
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: widget.size * 18),
                        ),
                        if (widget.reg.isNotEmpty)
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(widget.size * 5),
                                border: Border.all(color: Colors.white30)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 8),
                              child: Text(
                                widget.reg,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.size * 14),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: widget.size * 5,
                        left: widget.size * 8,
                        right: widget.size * 8),
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
                            color: Colors.white12,
                            borderRadius:
                                BorderRadius.circular(widget.size * 20)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                          return Icon(
                                              Icons.bookmark_added_rounded,
                                              size: widget.size * 30,
                                              color: Colors.cyanAccent);
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
                                          showToastText(
                                              "Removed from saved list");
                                        } else {
                                          FavouriteSubjects(
                                            branch: widget.branch,
                                            SubjectId: widget.ID,
                                            name: widget.name,
                                            description: widget.description,
                                          );
                                          showToastText(
                                              "${widget.name} in favorites");
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
                                                  size: widget.size * 23,
                                                  color: Colors.cyanAccent),
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
                                                Icons.library_add_outlined,
                                                size: widget.size * 23,
                                                color: Colors.cyanAccent,
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
                                              .collection(
                                                  "FavouriteLabSubjects")
                                              .doc(widget.ID)
                                              .delete();
                                          showToastText(
                                              "Removed from saved list");
                                        } else {
                                          FavouriteLabSubjectsSubjects(
                                            branch: widget.branch,
                                            SubjectId: widget.ID,
                                            name: widget.name,
                                            description: widget.description,
                                          );
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(color: Colors.white12,),
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
                    child: Text(
                        'Error with TextBooks Data or\n Check Internet Connection'),
                  );
                } else {
                  final units = snapshot.data;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.mode == "Subjects"
                                  ? "Units"
                                  : "Records & Manuals",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 35),
                            ),
                            Row(
                              children: [
                                if (widget.mode == "Subjects")
                                  PopupMenuButton(
                                    icon: Icon(
                                      Icons.filter_list,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    // Callback that sets the selected popup menu item.
                                    onSelected: (item) {
                                      setState(() {
                                        unitFilter = item as String;
                                      });
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry>[
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
                                  width: 10,
                                ),
                                InkWell(
                                  child: Text(
                                    isUnits ? "Hide" : "View",
                                    style: TextStyle(
                                        color: Colors.purpleAccent,
                                        fontSize: 20,
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
                          padding: EdgeInsets.all(widget.size * 5.0),
                          child: unitFilter == "all"
                              ? ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: units!.length,
                                  itemBuilder: (context, int index) {
                                    final unit = units[index];
                                    return subUnit(
                                      size: widget.size,
                                      ID: widget.ID,
                                      branch: widget.branch,
                                      unit: unit,
                                      mode: widget.mode,
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: widget.size * 5,
                                  ),
                                )
                              : ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: units!
                                      .where((unit) => unit.heading
                                          .split(";")
                                          .first
                                          .contains(unitFilter))
                                      .toList()
                                      .length,
                                  itemBuilder: (context, int index) {
                                    final filteredUnits = units
                                        .where((unit) => unit.heading
                                            .split(";")
                                            .first
                                            .contains(unitFilter))
                                        .toList();
                                    final unit = filteredUnits[index];
                                    return subUnit(
                                      size: widget.size,
                                      ID: widget.ID,
                                      branch: widget.branch,
                                      unit: unit,
                                      mode: widget.mode,
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
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
                      child: Text(
                          'Error with TextBooks Data or\n Check Internet Connection'),
                    );
                  } else {
                    final units = snapshot.data;

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Text Books",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 35),
                              ),
                              InkWell(
                                child: Text(
                                  isTextbooks ? "Hide" : "View",
                                  style: TextStyle(
                                      color: Colors.purpleAccent,
                                      fontSize: 20,
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
                        if (isTextbooks)
                          SizedBox(
                            height: 200,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: units!.length,
                              itemBuilder: (context, int index) {
                                final unit = units[index];

                                return textBookUnit(
                                  id: widget.ID,
                                  height: widget.size,
                                  width: widget.size,
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
                    child: Text(
                        'Error with TextBooks Data or\n Check Internet Connection'),
                  );
                } else {
                  final units = snapshot.data;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "More",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 35),
                            ),
                            Row(
                              children: [
                                if (widget.mode == "Subjects")
                                  PopupMenuButton(
                                    icon: Icon(
                                      Icons.filter_list,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    // Callback that sets the selected popup menu item.
                                    onSelected: (item) {
                                      setState(() {
                                        moreFilter = item as String;
                                      });
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry>[
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
                                  width: widget.size,
                                  height: widget.size,
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
                                  .where((unit) => unit.link
                                      .split(";")
                                      .first
                                      .startsWith(moreFilter))
                                  .toList()
                                  .length,
                              itemBuilder: (context, int index) {
                                final filteredUnits = units
                                    .where((unit) => unit.link
                                        .split(";")
                                        .first
                                        .startsWith(moreFilter))
                                    .toList();
                                final unit = filteredUnits[index];
                                return subMore(
                                  width: widget.size,
                                  height: widget.size,
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
            SizedBox(height: 150,)
          ],
        ),
      ));

  Stream<List<UnitsConvertor>> readUnits(String subjectsID, String branch) =>
      FirebaseFirestore.instance
          .collection(branch)
          .doc(widget.mode)
          .collection(widget.mode)
          .doc(subjectsID)
          .collection("Units")
          .orderBy("heading", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => UnitsConvertor.fromJson(doc.data()))
              .toList());

  Stream<List<BooksConvertor>> readTextBooks(
          String subjectsID, String branch) =>
      FirebaseFirestore.instance
          .collection(branch)
          .doc(widget.mode)
          .collection(widget.mode)
          .doc(subjectsID)
          .collection("TextBooks")
          .orderBy("heading", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => BooksConvertor.fromJson(doc.data()))
              .toList());

  Stream<List<UnitsMoreConvertor>> readMore(String subjectsID, String branch) =>
      FirebaseFirestore.instance
          .collection(branch)
          .doc(widget.mode)
          .collection(widget.mode)
          .doc(subjectsID)
          .collection("More")
          .orderBy("heading", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => UnitsMoreConvertor.fromJson(doc.data()))
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
      .doc(getID());
  final flash = UnitsConvertor(
      id: getID(),
      heading: heading,
      questions: questions,
      description: description,
      size: PDFSize,
      link: PDFLink);
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
  final flash = UnitsMoreConvertor(
      id: getID(), heading: heading, description: description, link: link);
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

  static UnitsMoreConvertor fromJson(Map<String, dynamic> json) =>
      UnitsMoreConvertor(
        id: json['id'],
        heading: json["heading"],
        description: json["description"],
        link: json["link"],
      );
}

class subUnit extends StatefulWidget {
  final UnitsConvertor unit;
  final String mode;
  final String branch;
  final String ID;
  final double size;

  const subUnit({
    Key? key,
    required this.unit,
    required this.mode,
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
    if (isUser()) {
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
    if (widget.unit.link.isNotEmpty)
      pdfFile = File("${folderPath}/pdfs/${getFileName(widget.unit.link)}");
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              pdfFile.existsSync() ? widget.size * 40 : widget.size * 30),
          color: Colors.white.withOpacity(0.1),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pdfFile.existsSync())
                  SizedBox(
                    width: widget.size * 100,
                    height: widget.size * 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Stack(
                        children: [
                          isLoading
                              ? PDFView(
                                  defaultPage: 0,
                                  filePath:
                                      "${folderPath}/pdfs/${getFileName(widget.unit.link)}",
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
                              padding: EdgeInsets.only(
                                  right: widget.size * 2,
                                  bottom: widget.size * 2),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(widget.size * 25),
                                  color: Colors.black.withOpacity(0.8),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.5)),
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
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: widget.size * 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${widget.unit.heading.split(";").last}",
                                style: TextStyle(
                                  fontSize: widget.size * 18.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: isExp ? 6 : 1,
                              ),
                            ),
                            if (isUser())
                              PopupMenuButton(
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
                                                  type: "unit",
                                                  branch: widget.branch,
                                                  mode: widget.mode,
                                                  UnitId: widget.ID,
                                                  id: widget.unit.id,
                                                  Heading: widget.unit.heading,
                                                  Description:
                                                      widget.unit.description,
                                                  questions:
                                                      widget.unit.questions,
                                                  PDFUrl: widget.unit.link,
                                                )));
                                  } else if (item == "delete") {
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
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
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
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3,
                                                        horizontal: 5),
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
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600),
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
                                              showToastText(
                                                  "File has been deleted");
                                            },
                                            onTap: () {
                                              showToastText(
                                                  "Long Press To Delete");
                                            },
                                          ),
                                        )
                                      else
                                        InkWell(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, bottom: 5),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 3,
                                                      horizontal: 5),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "Download",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .file_download_outlined,
                                                        color:
                                                            Colors.purpleAccent,
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
                                    borderRadius:
                                        BorderRadius.circular(widget.size * 10),
                                    border: Border.all(color: Colors.white24)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: widget.size * 1,
                                      horizontal: widget.size * 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.unit.heading.split(";").first,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: widget.size * 15),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "  ~ ${widget.unit.size}",
                                        style: TextStyle(
                                            color: Colors.lightBlueAccent,
                                            fontSize: widget.size * 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                )),
                            !widget.unit.description.isNotEmpty
                                ? InkWell(
                                    child: Icon(
                                      isExp
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        isExp = !isExp;
                                      });
                                    },
                                  )
                                : Container(),
                          ],
                        ),
                        if (isDownloaded)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: widget.size * 25),
                            child: LinearProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (isExp)
              Padding(
                padding: EdgeInsets.all(widget.size * 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Description",
                      style: TextStyle(
                          color: Colors.purpleAccent,
                          fontSize: widget.size * 22,
                          fontWeight: FontWeight.w500),
                    ),
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
                                        isUser()
                                            ? newList[index]
                                            : newList[index].split("@").first,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: widget.size * 18),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  int indexNumber = 0;
                                  try {
                                    indexNumber = int.parse(
                                        newList[index].split('@').last.trim());
                                  } catch (e) {
                                    indexNumber = 0;
                                  }
                                  if (file.existsSync()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PdfViewerPage(
                                                  size: widget.size,
                                                  pdfUrl:
                                                      "${folderPath}/pdfs/${getFileName(widget.unit.link)}",
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
                                  style: TextStyle(
                                      color: Colors.amberAccent,
                                      fontSize: widget.size * 18),
                                ),
                              ),
                            );
                          }
                        }),
                    Text(
                      "Questions",
                      style: TextStyle(
                          color: Colors.purpleAccent,
                          fontSize: widget.size * 22,
                          fontWeight: FontWeight.w500),
                    ),
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
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: widget.size * 18)),
                                    Flexible(
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
                                            builder: (context) => PdfViewerPage(
                                                  size: widget.size,
                                                  pdfUrl:
                                                      "${folderPath}/pdfs/${getFileName(widget.unit.link)}",
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
                                    borderRadius:
                                        BorderRadius.circular(widget.size * 8)),
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
          ],
        ),
      ),
      onTap: () {
        if (pdfFile.existsSync()) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PdfViewerPage(
                      size: widget.size,
                      pdfUrl:
                          "${folderPath}/pdfs/${getFileName(widget.unit.link)}")));
        }
      },
    );
  }
}

class subMore extends StatefulWidget {
  final UnitsMoreConvertor unit;
  final String mode;
  final String branch;
  final String ID;
  final double size;
  final double height;
  final double width;

  const subMore(
      {Key? key,
      required this.unit,
      required this.mode,
      required this.branch,
      required this.ID,
      required this.width,
      required this.size,
      required this.height})
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


  @override
  Widget build(BuildContext context) {
    if (widget.unit.link.split(";").last.isNotEmpty &&
        widget.unit.link.split(";").first == "PDF")
      file = File(
          "${folderPath}/pdfs/${getFileName(widget.unit.link.split(";").last)}");

    return InkWell(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.size * 25),
          color: Colors.white12,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              if (file.existsSync() && widget.unit.link.split(";").last.isNotEmpty&&widget.unit.link.split(";").first == "PDF")
                SizedBox(
                  width: widget.size * 100,
                  height: widget.size * 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Stack(
                      children: [
                        isLoading
                            ? PDFView(
                          defaultPage: 0,
                          filePath:
                          "${folderPath}/pdfs/${getFileName(widget.unit.link.split(";").last)}",
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
                            padding: EdgeInsets.only(
                                right: widget.size * 2,
                                bottom: widget.size * 2),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    widget.size * 25),
                                color: Colors.black.withOpacity(0.8),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.5)),
                              ),
                              child: Padding(
                                padding:
                                EdgeInsets.all(widget.size * 4.0),
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
                ),
              if (widget.unit.link.split(";").first == "Image")
                ClipRRect(
                  borderRadius: BorderRadius.circular(widget.size * 25),
                  child: SizedBox(
                    height: widget.height * 100,
                    width: widget.size * 100,
                    child: Image.network(
                      widget.unit.link.split(";").last,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (widget.unit.link.split(";").first == "YouTube" ||
                  widget.unit.link.split(";").first == "WebSite")
                Padding(
                  padding: EdgeInsets.all(widget.size * 8.0),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white30),
                          borderRadius:
                          BorderRadius.circular(widget.size * 10),
                          image: DecorationImage(
                              image: AssetImage(
                                  widget.unit.link.split(";").first ==
                                      "YouTube"
                                      ? "assets/YouTubeIcon.png"
                                      : "assets/googleIcon.png"),
                              fit: BoxFit.cover)),
                      height: widget.size * 35,
                      width: widget.size * 40),
                ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.unit.heading.split(";").first,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: widget.size * 20),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isUser())
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
                                final deleteFlashNews = FirebaseFirestore.instance
                                    .collection(widget.branch)
                                    .doc(widget.mode)
                                    .collection(widget.mode)
                                    .doc(widget.ID)
                                    .collection("More")
                                    .doc(widget.unit.id);
                                deleteFlashNews.delete();
                                pushNotificationsSpecificPerson(
                                    "sujithnimmala03@gmail.com",
                                    "${widget.unit.heading} Unit is deleted from ${widget.mode}",
                                    "");
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
                   widget.unit.link.split(";").last.isNotEmpty&&widget.unit.link.split(";").first == "PDF"

    ? Row(
                      children: [
                        if (file.existsSync())
                          Padding(
                            padding: EdgeInsets.only(
                              right: widget.size * 5,
                            ),
                            child: InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(15),
                                  color: Colors.white
                                      .withOpacity(0.8),
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal: 5),
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
                                            fontSize: 20,
                                            fontWeight:
                                            FontWeight.w600),
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
                                showToastText(
                                    "File has been deleted");
                              },
                              onTap: () {
                                showToastText(
                                    "Long Press To Delete");
                              },
                            ),
                          )
                        else
                          InkWell(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 10, bottom: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(15),
                                    color: Colors.white
                                        .withOpacity(0.8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets
                                        .symmetric(
                                        vertical: 3,
                                        horizontal: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Download",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight:
                                              FontWeight
                                                  .w600),
                                        ),
                                        Icon(
                                          Icons
                                              .file_download_outlined,
                                          color:
                                          Colors.purpleAccent,
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
                                await download(widget.unit.link.split(";").last,"pdfs");
                                setState(() {
                                  isDownloaded = false;

                                });
                              }),

                      ],
                    )
                        : Container(),
                    if(isDownloaded)Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: LinearProgressIndicator(),
                    ),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.unit.description.split(";").length,
                        itemBuilder: (BuildContext context, int index) {
                          if (widget.unit.description.split(";").length > 1) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: widget.size * 3,left: 10),
                              child: Flexible(
                                child: Text(
                                  widget.unit.description.split(";")[index],
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: widget.size * 15),
                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius:
                                    BorderRadius.circular(widget.size * 8)),
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
                        size: widget.size,
                        pdfUrl:
                        "${folderPath}/pdfs/${getFileName(widget.unit.link)}")));
          }

        else if(widget.unit.link.split(";").first == "Image" ){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ImageZoom(
                    size: widget.size,
                    url: widget.unit.link.split(";").last,
                    file: File(""),
                  )));
        }
        else if (widget.unit.link.split(";").first == "YouTube" ||
            widget.unit.link.split(";").first == "WebSite")
          ExternalLaunchUrl(widget.unit.link.split(";").last);
      },
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
                            final BranchNew = BranchNews[index];
                            if (BranchNew.photoUrl.isNotEmpty) {
                              final Uri uri = Uri.parse(BranchNew.photoUrl);
                              final String fileName = uri.pathSegments.last;
                              var name = fileName.split("/").last;
                              file = File("${folderPath}/updates/$name");
                            }

                            return InkWell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: widget.size * 10,
                                    vertical: widget.size * 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: widget.size * 30,
                                          height: widget.size * 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                widget.size * 15),
                                            image:
                                                BranchNew.photoUrl.isNotEmpty &&
                                                        file.existsSync()
                                                    ? DecorationImage(
                                                        image: FileImage(file),
                                                        fit: BoxFit.cover,
                                                      )
                                                    : noImageFound,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: widget.size * 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  BranchNew.heading,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          widget.size * 20,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    if (BranchNew
                                                        .branch.isNotEmpty)
                                                      Text(
                                                        "from ${BranchNew.branch}",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white70,
                                                            fontSize:
                                                                widget.size *
                                                                    15),
                                                      ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: widget.size *
                                                              10.0),
                                                      child: Text(
                                                        "~ ${BranchNew.id.split("-").first}",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                widget.size *
                                                                    10),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (isUser())
                                          PopupMenuButton(
                                            icon: Icon(
                                              Icons.more_vert,
                                              color: Colors.white,
                                              size: widget.size * 22,
                                            ),
                                            // Callback that sets the selected popup menu item.
                                            onSelected: (item) async {
                                              if (item == "edit") {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            updateCreator(
                                                              NewsId:
                                                                  BranchNew.id,
                                                              link: BranchNew
                                                                  .link,
                                                              heading: BranchNew
                                                                  .heading,
                                                              photoUrl:
                                                                  BranchNew
                                                                      .photoUrl,
                                                              subMessage: BranchNew
                                                                  .description,
                                                              branch:
                                                                  widget.branch,
                                                              width:
                                                                  widget.size,
                                                              height:
                                                                  widget.size,
                                                              size: widget.size,
                                                            )));
                                              } else if (item == "delete") {
                                                FirebaseFirestore.instance
                                                    .collection("update")
                                                    .doc(BranchNew.id)
                                                    .delete();
                                                pushNotificationsSpecificPerson(
                                                    fullUserId(),
                                                    " ${BranchNew.heading} Deleted from Updates",
                                                    "");
                                              }
                                            },
                                            itemBuilder:
                                                (BuildContext context) =>
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
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: widget.size * 10.0,
                                          vertical: widget.size * 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            BranchNew.description,
                                            style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.9),
                                                fontSize: widget.size * 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          if (BranchNew.link.isNotEmpty)
                                            InkWell(
                                              child: Text(
                                                "Open (Link)",
                                                style: TextStyle(
                                                    color:
                                                        Colors.lightBlueAccent,
                                                    fontSize: widget.size * 18),
                                              ),
                                              onTap: () {
                                                ExternalLaunchUrl(
                                                    BranchNew.link);
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: widget.size * 25)
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageZoom(
                                              size: widget.size,
                                              url: BranchNew.photoUrl,
                                              file: file,
                                            )));
                              },
                            );
                          },
                        );
                    }
                }
              }),
          SizedBox(
            height: 150,
          )
        ],
      ),
    );
  }
}
