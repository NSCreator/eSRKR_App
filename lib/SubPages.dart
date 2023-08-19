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
            text: "TimeTables",
          ),
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
                              'Error with TextBooks Data or\n Check Internet Connection'));
                    } else {
                      if (BranchNews!.length == 0) {
                        return Center(
                            child: Text(
                          "No Time Tables",
                          style: TextStyle(color: Colors.amber),
                        ));
                      } else
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: BranchNews.length,
                          itemBuilder: (context, int index) {
                            var data = BranchNews[index];

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                              child: InkWell(
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(data.photoUrl),fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white12)
                                    ),

                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          data.heading.toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.amber, fontSize: 30),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ImageZoom(
                                            size: widget.size,
                                            width: widget.size,
                                            height: widget.size,
                                            url:data.photoUrl,
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
  final double size;

  syllabusPage({
    Key? key,
    required this.branch,
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
            text: widget.branch,
          ),
          StreamBuilder<List<syllabusConvertor>>(
              stream: readsyllabus(branch: "ECE"),
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
                            var data = BranchNews[index];
                            if (data.syllabus.isNotEmpty)
                              file = File(
                                  "${folderPath}/pdfs/${getFileName(data.syllabus)}");

                            return Padding(
                              padding: EdgeInsets.only(
                                  left: widget.size * 15.0,
                                  right: widget.size * 10,
                                  top: widget.size * 4),
                              child: InkWell(
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
                                                height: 98,
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
                                            Text(
                                              data.id.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: widget.size * 20.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
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
                                                                          right: widget.size *
                                                                              5,
                                                                          top: widget.size *
                                                                              3,
                                                                          bottom:
                                                                              widget.size * 3),
                                                                      child:
                                                                          Text(
                                                                        file.existsSync()
                                                                            ? "Read Now"
                                                                            : "Download",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: widget.size * 20),
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
                                                                            size:
                                                                                widget.size,
                                                                            pdfUrl: "${folderPath}/pdfs/${getFileName(data.syllabus)}")));
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
                                                                left: widget
                                                                        .size *
                                                                    5,
                                                                right: widget
                                                                        .size *
                                                                    5,
                                                                top: widget
                                                                        .size *
                                                                    1,
                                                                bottom: widget
                                                                        .size *
                                                                    1),
                                                            child: InkWell(
                                                              child: Icon(
                                                                Icons.delete,
                                                                color: Colors
                                                                    .redAccent,
                                                                size: widget
                                                                        .size *
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
                                                    fontSize:
                                                        widget.size * 18.0,
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
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             subjectUnitsData(
                                  //               reg: data[
                                  //               'regulation'],
                                  //
                                  //               size: widget
                                  //                   .size,
                                  //               branch: widget
                                  //                   .branch,
                                  //               ID: data[
                                  //               'id'],
                                  //               mode:
                                  //               "LabSubjects",
                                  //               name: data[
                                  //               "heading"],
                                  //               fullName: data[
                                  //               'description'],
                                  //               photoUrl: data[
                                  //               'image'],
                                  //             )));
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

class ModalPapersPage extends StatefulWidget {
  final String branch;
  final double size;

  ModalPapersPage({
    Key? key,
    required this.branch,
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
          ),
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
                              'Error with TextBooks Data or\n Check Internet Connection'));
                    } else {
                      if (BranchNews!.length == 0) {
                        return Center(
                            child: Text(
                          "No Model Papers",
                          style: TextStyle(color: Colors.lightBlueAccent),
                        ));
                      } else
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
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
                              child: InkWell(
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
                                                height: 98,
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
                                            Text(
                                              data.id.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: widget.size * 20.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
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
                                                                          right: widget.size *
                                                                              5,
                                                                          top: widget.size *
                                                                              3,
                                                                          bottom:
                                                                              widget.size * 3),
                                                                      child:
                                                                          Text(
                                                                        file.existsSync()
                                                                            ? "Read Now"
                                                                            : "Download",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: widget.size * 20),
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
                                                                            size:
                                                                                widget.size,
                                                                            pdfUrl: "${folderPath}/pdfs/${getFileName(data.modelPaper)}")));
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
                                                                left: widget
                                                                        .size *
                                                                    5,
                                                                right: widget
                                                                        .size *
                                                                    5,
                                                                top: widget
                                                                        .size *
                                                                    1,
                                                                bottom: widget
                                                                        .size *
                                                                    1),
                                                            child: InkWell(
                                                              child: Icon(
                                                                Icons.delete,
                                                                color: Colors
                                                                    .redAccent,
                                                                size: widget
                                                                        .size *
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
                                                    fontSize:
                                                        widget.size * 18.0,
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
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             subjectUnitsData(
                                  //               reg: data[
                                  //               'regulation'],
                                  //
                                  //               size: widget
                                  //                   .size,
                                  //               branch: widget
                                  //                   .branch,
                                  //               ID: data[
                                  //               'id'],
                                  //               mode:
                                  //               "LabSubjects",
                                  //               name: data[
                                  //               "heading"],
                                  //               fullName: data[
                                  //               'description'],
                                  //               photoUrl: data[
                                  //               'image'],
                                  //             )));
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

// class timeTablePage extends StatefulWidget {
//   // const timeTablePage({super.key});
//
//   @override
//   State<timeTablePage> createState() => _timeTablePageState();
// }
//
// class _timeTablePageState extends State<timeTablePage> {
//   @override
//   Widget build(BuildContext context) {
//     return backGroundImage(
//         child: SingleChildScrollView(
//       child: Column(
//         children: [
//           // StreamBuilder<List<RegulationConvertor>>(
//           //     stream: readRegulation(branch: widget),
//           //     builder: (context, snapshot) {
//           //       final Notifications = snapshot.data;
//           //       switch (snapshot.connectionState) {
//           //         case ConnectionState.waiting:
//           //           return const Center(
//           //               child: CircularProgressIndicator(
//           //                 strokeWidth: 0.3,
//           //                 color: Colors.cyan,
//           //               ));
//           //         default:
//           //           if (snapshot.hasError) {
//           //             return const Center(
//           //                 child: Text(
//           //                     'Error with TextBooks Data or\n Check Internet Connection'));
//           //           } else {
//           //             return ListView.separated(
//           //                 physics: const BouncingScrollPhysics(),
//           //                 shrinkWrap: true,
//           //                 reverse: true,
//           //                 itemCount: Notifications!.length,
//           //                 itemBuilder: (context, int index) {
//           //                   final Notification = Notifications[index];
//           //
//           //                   return InkWell(
//           //                     child: Padding(
//           //                       padding: Notification.Name == fullUserId()
//           //                           ? EdgeInsets.only(
//           //                           left: widget.width * 45,
//           //                           right: widget.width * 5,
//           //                           top: widget.height * 5)
//           //                           : EdgeInsets.only(
//           //                           right: widget.width * 45,
//           //                           left: widget.width * 5,
//           //                           top: widget.height * 5),
//           //                       child: Container(
//           //                         width: double.infinity,
//           //                         alignment: Alignment.center,
//           //                         decoration: Notification.Name ==
//           //                             fullUserId()
//           //                             ? BoxDecoration(
//           //                           borderRadius: BorderRadius.only(
//           //                             topLeft: Radius.circular(
//           //                                 widget.size * 25),
//           //                             bottomLeft: Radius.circular(
//           //                                 widget.size * 25),
//           //                             topRight: Radius.circular(
//           //                                 widget.size * 25),
//           //                             bottomRight: Radius.circular(
//           //                                 widget.size * 5),
//           //                           ),
//           //                           color:
//           //                           Colors.black.withOpacity(0.8),
//           //                           border: Border.all(
//           //                               color: Colors
//           //                                   .blueAccent.shade100),
//           //                         )
//           //                             : BoxDecoration(
//           //                           borderRadius: BorderRadius.only(
//           //                             topLeft: Radius.circular(
//           //                                 widget.size * 25),
//           //                             bottomLeft: Radius.circular(
//           //                                 widget.size * 5),
//           //                             topRight: Radius.circular(
//           //                                 widget.size * 25),
//           //                             bottomRight: Radius.circular(
//           //                                 widget.size * 25),
//           //                           ),
//           //                           color:
//           //                           Colors.black.withOpacity(0.5),
//           //                           border: Border.all(
//           //                               color: Colors.white
//           //                                   .withOpacity(0.5)),
//           //                         ),
//           //                         child: Row(
//           //                           mainAxisAlignment:
//           //                           MainAxisAlignment.start,
//           //                           crossAxisAlignment:
//           //                           CrossAxisAlignment.start,
//           //                           children: [
//           //                             SizedBox(
//           //                               width: widget.width * 2,
//           //                             ),
//           //                             Expanded(
//           //                                 child: Column(
//           //                                   mainAxisAlignment:
//           //                                   MainAxisAlignment.start,
//           //                                   crossAxisAlignment:
//           //                                   CrossAxisAlignment.start,
//           //                                   children: [
//           //                                     Row(
//           //                                       children: [
//           //                                         Text(
//           //                                           "       @${Notification.Name}",
//           //                                           style: TextStyle(
//           //                                             fontSize:
//           //                                             widget.size * 12.0,
//           //                                             color: Colors.white54,
//           //                                             fontWeight:
//           //                                             FontWeight.w600,
//           //                                           ),
//           //                                         ),
//           //                                         Spacer(),
//           //                                         Padding(
//           //                                           padding:
//           //                                           EdgeInsets.fromLTRB(
//           //                                               widget.size * 8,
//           //                                               widget.size * 1,
//           //                                               widget.size * 25,
//           //                                               widget.size * 1),
//           //                                           child: Column(
//           //                                             children: [
//           //                                               Text(
//           //                                                 '${Notification.id}',
//           //                                                 style: TextStyle(
//           //                                                   fontSize:
//           //                                                   widget.size *
//           //                                                       9.0,
//           //                                                   color:
//           //                                                   Colors.white70,
//           //                                                   //   fontWeight: FontWeight.bold,
//           //                                                 ),
//           //                                               ),
//           //                                             ],
//           //                                           ),
//           //                                         ),
//           //                                       ],
//           //                                     ),
//           //                                     Padding(
//           //                                       padding: EdgeInsets.only(
//           //                                           left: widget.size * 8,
//           //                                           bottom: widget.size * 6,
//           //                                           right: widget.size * 3,
//           //                                           top: widget.size * 3),
//           //                                       child: NotificationText(
//           //                                           Notification.description),
//           //                                     ),
//           //                                     if (Notification.Url.length > 3)
//           //                                       Padding(
//           //                                         padding: EdgeInsets.all(
//           //                                             widget.size * 3.0),
//           //                                         child: Image.network(
//           //                                             Notification.Url),
//           //                                       )
//           //                                   ],
//           //                                 ))
//           //                           ],
//           //                         ),
//           //                       ),
//           //                     ),
//           //                     onLongPress: () {
//           //                       if (Notification.Name == fullUserId() ||
//           //                           isUser()) {
//           //                         final deleteFlashNews = FirebaseFirestore
//           //                             .instance
//           //                             .collection(widget.branch)
//           //                             .doc("Notification")
//           //                             .collection("AllNotification")
//           //                             .doc(Notification.id);
//           //                         deleteFlashNews.delete();
//           //                         showToastText(
//           //                             "Your Message has been Deleted");
//           //                       } else {
//           //                         showToastText(
//           //                             "You are not message user to delete");
//           //                       }
//           //                     },
//           //                   );
//           //                 },
//           //                 separatorBuilder: (context, index) => SizedBox(
//           //                   height: widget.height * 1,
//           //                 ));
//           //           }
//           //       }
//           //     }),
//         ],
//       ),
//     ));
//   }
// }

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
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(top: widget.size * 5),
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
                          physics: const BouncingScrollPhysics(),
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
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.all(widget.size * 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius:
                                      BorderRadius.circular(widget.size * 20),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.1)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: widget.size * 8,
                                          left: widget.size * 8,
                                          bottom: widget.size * 2),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: widget.size * 25,
                                            width: widget.size * 25,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      widget.size * 15),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/app_logo.png"),
                                              ),
                                            ),
                                          ),
                                          if (BranchNew.heading.isNotEmpty)
                                            Text(" ${BranchNew.heading}",
                                                style: TextStyle(
                                                    color: Colors.orangeAccent,
                                                    fontSize: widget.size * 20,
                                                    fontWeight:
                                                        FontWeight.w400))
                                          else
                                            Text(" ${widget.branch} (SRKR)",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: widget.size * 20,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                        ],
                                      ),
                                    ),
                                    if (BranchNew.photoUrl.isNotEmpty)
                                      Padding(
                                          padding:
                                              EdgeInsets.all(widget.size * 5.0),
                                          child: Image.file(file)),
                                    Row(
                                      children: [
                                        Spacer(),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: widget.size * 5,
                                              bottom: widget.size * 3,
                                              right: widget.size * 20),
                                          child: Text(
                                            BranchNew.id
                                                        .split("-")
                                                        .first
                                                        .length <
                                                    12
                                                ? BranchNew.id.split("-").first
                                                : "No Date",
                                            style: TextStyle(
                                                color: Colors.white54,
                                                fontSize: widget.size * 10,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (BranchNew.description.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: widget.size * 25,
                                            top: widget.size * 5,
                                            bottom: widget.size * 5),
                                        child: StyledTextWidget(
                                          text: BranchNew.description,
                                          fontSize: widget.size * 20,
                                        ),
                                      ),
                                    if (isUser())
                                      Row(
                                        children: [
                                          Spacer(),
                                          InkWell(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey[500],
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        widget.size * 15),
                                                border: Border.all(
                                                    color: Colors.white),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: widget.size * 10,
                                                    right: widget.size * 10,
                                                    top: widget.size * 5,
                                                    bottom: widget.size * 5),
                                                child: Text("Edit"),
                                              ),
                                            ),
                                            onTap: () {
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
                                            },
                                          ),
                                          SizedBox(
                                            width: widget.size * 20,
                                          ),
                                          InkWell(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey[500],
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        widget.size * 15),
                                                border: Border.all(
                                                    color: Colors.white),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: widget.size * 10,
                                                    right: widget.size * 10,
                                                    top: widget.size * 5,
                                                    bottom: widget.size * 5),
                                                child: Text("Delete"),
                                              ),
                                            ),
                                            onTap: () async {
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
                                            },
                                          ),
                                          SizedBox(
                                            width: widget.size * 20,
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageZoom(
                                              size: widget.size,
                                              width: widget.size,
                                              height: widget.size,
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
              height: 150,
            )
          ],
        ),
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
                          if (SubjectsData.PhotoUrl.isNotEmpty) {
                            final Uri uri = Uri.parse(SubjectsData.PhotoUrl);
                            final String fileName = uri.pathSegments.last;
                            var name = fileName.split("/").last;
                            file = File("${folderPath}/subjects/$name");
                          }
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
                                            Radius.circular(widget.size * 20))),
                                    child: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: widget.width * 95.0,
                                            height: widget.height * 55.0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      widget.size * 20)),
                                              color: Colors.black,
                                              image: SubjectsData
                                                      .PhotoUrl.isNotEmpty
                                                  ? DecorationImage(
                                                      image: FileImage(file),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : noImageFound,
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
                                                    SubjectsData.heading,
                                                    style: TextStyle(
                                                      fontSize:
                                                          widget.size * 20.0,
                                                      color: Colors.amber,
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
                                                          .collection('user')
                                                          .doc(fullUserId())
                                                          .collection(
                                                              "FavouriteSubject")
                                                          .doc(SubjectsData.id)
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          if (snapshot
                                                              .data!.exists) {
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
                                                              size:
                                                                  widget.size *
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
                                                                "FavouriteSubject")
                                                            .doc(
                                                                SubjectsData.id)
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
                                                                .doc(
                                                                    SubjectsData
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
                                                                name:
                                                                    SubjectsData
                                                                        .heading,
                                                                description:
                                                                    SubjectsData
                                                                        .description,
                                                                photoUrl:
                                                                    SubjectsData
                                                                        .PhotoUrl);
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
                                                height: widget.height * 2,
                                              ),
                                              Text(
                                                SubjectsData.description,
                                                style: TextStyle(
                                                  fontSize: widget.size * 13.0,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                              if (isUser())
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: widget.width * 10),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              widget.size * 15),
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      border: Border.all(
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.5)),
                                                    ),
                                                    width: widget.width * 70,
                                                    child: InkWell(
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width:
                                                                widget.width *
                                                                    5,
                                                          ),
                                                          Icon(
                                                            Icons.edit,
                                                            color: Colors.white,
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                left: widget
                                                                        .width *
                                                                    3,
                                                                right: widget
                                                                        .width *
                                                                    3),
                                                            child: Text(
                                                              "Edit",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      widget.size *
                                                                          18),
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
                                                              reg: widget.reg,
                                                              branch:
                                                                  widget.branch,
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
                                                              mode: "Subjects",
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
                                                                child: AnimatedOpacity(
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            300),
                                                                    opacity: animation
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
                                          fullName: SubjectsData.description,
                                          photoUrl: SubjectsData.PhotoUrl,
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
        child: backButton(
          size: widget.size,
          text: "${widget.branch} Subjects",
        ),
      )
    ]));
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
                          if (LabSubjectsData.PhotoUrl.isNotEmpty) {
                            final Uri uri = Uri.parse(LabSubjectsData.PhotoUrl);
                            final String fileName = uri.pathSegments.last;
                            var name = fileName.split("/").last;
                            file = File("${folderPath}/labsubjects/$name");
                          }

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
                                        Radius.circular(widget.size * 20))),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: widget.width * 95.0,
                                        height: widget.height * 55.0,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  widget.size * 20)),
                                          color: Colors.redAccent,
                                          image: LabSubjectsData
                                                  .PhotoUrl.isNotEmpty
                                              ? DecorationImage(
                                                  image: FileImage(file),
                                                  fit: BoxFit.cover,
                                                )
                                              : noImageFound,
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
                                                  fontSize: widget.size * 20.0,
                                                  color: Colors.amber,
                                                  fontWeight: FontWeight.w600,
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
                                                      .collection('user')
                                                      .doc(fullUserId())
                                                      .collection(
                                                          "FavouriteLabSubjects")
                                                      .doc(LabSubjectsData.id)
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      if (snapshot
                                                          .data!.exists) {
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
                                                          size:
                                                              widget.size * 26,
                                                          color:
                                                              Colors.cyanAccent,
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
                                                        .doc(LabSubjectsData.id)
                                                        .get()
                                                        .then((docSnapshot) {
                                                      if (docSnapshot.exists) {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('user')
                                                            .doc(fullUserId())
                                                            .collection(
                                                                "FavouriteLabSubjects")
                                                            .doc(LabSubjectsData
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
                                                width: widget.width * 10,
                                              )
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
                                          if (isUser())
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: widget.width * 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          widget.size * 15),
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                  border: Border.all(
                                                      color: Colors.white),
                                                ),
                                                child: InkWell(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: widget.width * 10,
                                                        right:
                                                            widget.width * 10,
                                                        top: widget.height * 5,
                                                        bottom:
                                                            widget.height * 5),
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
                                                          reg: widget.reg,
                                                          branch: widget.branch,
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
                                                          mode: "LabSubjects",
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
                                      fullName: LabSubjectsData.description,
                                      photoUrl: LabSubjectsData.PhotoUrl,
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
        child: backButton(
          size: widget.size,
          text: "${widget.branch} Lab Subjects",
        ),
      )
    ]));
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
      physics: BouncingScrollPhysics(),
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
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: Books!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              textBookSub(
                                height: widget.size,
                                width: widget.size,
                                size: widget.size,
                                data: Books[index],
                                branch: widget.branch,
                              ),
                              if (isUser())
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                                builder: (context) =>
                                                    BooksCreator(
                                                      branch: widget.branch,
                                                      id: Books[index].id,
                                                      heading:
                                                          Books[index].heading,
                                                      description: Books[index]
                                                          .description,
                                                      Edition:
                                                          Books[index].edition,
                                                      Link: Books[index].link,
                                                      Author:
                                                          Books[index].Author,
                                                      photoUrl:
                                                          Books[index].photoUrl,
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
                                      onTap: () {
                                        FirebaseFirestore.instance
                                            .collection(widget.branch)
                                            .doc("Books")
                                            .collection("CoreBooks")
                                            .doc(Books[index].id)
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
  BooksConvertor data;
  double width;
  double height;
  double size;

  textBookSub(
      {required this.height,
      required this.size,
      required this.width,
      required this.data,
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
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.size * 30),
            color: Colors.black.withOpacity(0.8),
            boxShadow: [
              BoxShadow(
                  blurRadius: 5, color: Colors.white24, offset: Offset(1, 3))
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              File("${folderPath}/pdfs/${getFileName(widget.data.link)}")
                          .existsSync() &&
                      widget.data.link.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(widget.size * 25),
                      child: SizedBox(
                        height: widget.size * 160,
                        width: widget.size * 120,
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
                                        BorderRadius.circular(widget.size * 25),
                                    color: Colors.black.withOpacity(0.8),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.5)),
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
                                            borderRadius: BorderRadius.circular(
                                                widget.size * 25),
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.5)),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: widget.size * 3,
                                                horizontal: widget.size * 10),
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
                                            borderRadius: BorderRadius.circular(
                                                widget.size * 25),
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.5)),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: widget.size * 3,
                                                horizontal: widget.size * 8),
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
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(widget.size * 25),
                      child: Container(
                        height: widget.height * 160,
                        width: widget.size * 120,
                        decoration: BoxDecoration(
                            image: widget.data.photoUrl.isNotEmpty
                                ? DecorationImage(
                                    image: FileImage(
                                      File("${folderPath}/books/${getFileName(widget.data.photoUrl)}"),
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : ImageNotFoundForTextBooks),
                      ),
                    ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(widget.size * 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data.heading.split(";").last,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: widget.size * 25,
                            color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.data.Author,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: widget.size * 16,
                            color: Colors.white54),
                      ),
                      Text(
                        widget.data.edition,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: widget.size * 16,
                            color: Colors.white54),
                      ),
                      if (widget.data.link.isNotEmpty)
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: widget.size * 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              widget.size * 8),
                                          color: Color.fromRGBO(2, 82, 87, 1),
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
                                                    bottom: widget.height * 3),
                                                child: Text(
                                                  file.existsSync()
                                                      ? "Read Now"
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
                                                size: widget.size * 20,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        File isFile = File(
                                            "${folderPath}/pdfs/${getFileName(widget.data.link)}");
                                        if (isFile.existsSync()) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PdfViewerPage(
                                                          size: widget.size,
                                                          pdfUrl:
                                                              "${folderPath}/pdfs/${getFileName(widget.data.link)}")));
                                        } else {
                                          setState(() {
                                            isDownloaded = true;
                                          });
                                          await download(
                                              widget.data.link, "pdfs");
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class subjectUnitsData extends StatefulWidget {
  String ID, mode;
  String name;
  String fullName;
  String photoUrl;
  String branch;
  String reg;
  final double size;

  subjectUnitsData({
    required this.ID,
    required this.mode,
    required this.photoUrl,
    required this.branch,
    required this.reg,
    this.name = "Subjects",
    required this.fullName,
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

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final Uri uri = Uri.parse(widget.photoUrl);
    final String fileName = uri.pathSegments.last;
    var name = fileName.split("/").last;
    setState(() {
      folderPath = '${directory.path}';
      if (widget.mode == "Subjects") {
        file = File("${folderPath}/subjects/$name");
      } else {
        file = File("${folderPath}/labsubjects/$name");
      }
    });
  }

  late TabController _tabController;
  late TabController _unitsTabController;

  @override
  void initState() {
    // TODO: implement initState
    getPath();
    _tabController = new TabController(
      vsync: this,
      length: 3,
    );
    _unitsTabController = new TabController(
      vsync: this,
      length: 6,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => backGroundImage(
          child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: widget.size * 200.0,
            collapsedHeight: widget.size * 200,
            backgroundColor: Colors.transparent,
            flexibleSpace: Padding(
              padding: EdgeInsets.all(widget.size * 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  backButton(
                    size: widget.size,
                    text: widget.name,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(widget.size * 10),
                                border: Border.all(color: Colors.black),
                                image: DecorationImage(
                                    image: FileImage(file), fit: BoxFit.fill)),
                          ),
                        ),
                      ),
                      Flexible(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            widget.size * 5),
                                        border:
                                            Border.all(color: Colors.white30)),
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
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: widget.size * 8,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        widget.ID.split("-").first,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: widget.size * 14),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                widget.name,
                                style: TextStyle(
                                    fontSize: widget.size * 25,
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.w500),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        border:
                                            Border.all(color: Colors.white38),
                                        borderRadius: BorderRadius.circular(
                                            widget.size * 15)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: widget.size * 3,
                                          horizontal: widget.size * 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          if (widget.mode == "Subjects")
                                            InkWell(
                                              child: StreamBuilder<
                                                  DocumentSnapshot>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('user')
                                                    .doc(fullUserId())
                                                    .collection(
                                                        "FavouriteSubject")
                                                    .doc(widget.ID)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    if (snapshot.data!.exists) {
                                                      return Row(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .library_add_check,
                                                              size:
                                                                  widget.size *
                                                                      23,
                                                              color: Colors
                                                                  .cyanAccent),
                                                          Text(
                                                            " Saved",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: widget
                                                                        .size *
                                                                    20),
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
                                                            color: Colors
                                                                .cyanAccent,
                                                          ),
                                                          Text(
                                                            " Save",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: widget
                                                                        .size *
                                                                    20),
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
                                                      .collection('user')
                                                      .doc(fullUserId())
                                                      .collection(
                                                          "FavouriteSubject")
                                                      .doc(widget.ID)
                                                      .get()
                                                      .then((docSnapshot) {
                                                    if (docSnapshot.exists) {
                                                      FirebaseFirestore.instance
                                                          .collection('user')
                                                          .doc(fullUserId())
                                                          .collection(
                                                              "FavouriteSubject")
                                                          .doc(widget.ID)
                                                          .delete();
                                                      showToastText(
                                                          "Removed from saved list");
                                                    } else {
                                                      FavouriteSubjects(
                                                          branch: widget.branch,
                                                          SubjectId: widget.ID,
                                                          name: widget.name,
                                                          description:
                                                              widget.fullName,
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
                                  SizedBox(
                                    width: widget.size * 10,
                                  ),
                                  downloadAllPdfs(
                                    branch: widget.branch,
                                    SubjectID: widget.ID,
                                    pdfs: [],
                                    size: widget.size,
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: widget.size * 5),
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
            ),
            floating: false,
            primary: true,
          ),
        ],
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.black,
              height: widget.size * 45,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(widget.size * 5.0),
                  child: TabBar(
                    physics: BouncingScrollPhysics(),
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: Colors.white,
                    labelPadding: EdgeInsets.symmetric(
                        horizontal: widget.size * 25,
                        vertical: widget.size * 3),
                    labelStyle: TextStyle(
                        color: Colors.white12,
                        fontWeight: FontWeight.w400,
                        fontSize: widget.size * 25),
                    tabs: [
                      Tab(
                        child: Text(
                          widget.mode == "Subjects" ? "Units" : "Records",
                        ),
                      ),
                      Tab(
                        child: Text(
                          widget.mode == "Subjects" ? "TextBooks" : "Manuals",
                        ),
                      ),
                      Tab(
                        child: Text(
                          "More",
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  controller: _tabController,
                  children: [
                    widget.mode == "Subjects"
                        ? Column(
                            children: [
                              if (isUser())
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: widget.size * 10),
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
                                        "Add",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: widget.size * 14),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UnitsCreator(
                                                    type: "unit",
                                                    branch: widget.branch,
                                                    id: widget.ID,
                                                    mode: widget.mode,
                                                  )));
                                    },
                                  ),
                                ),
                              Container(
                                color: Colors.black.withOpacity(0.2),
                                width: double.infinity,
                                height: widget.size * 45,
                                child: TabBar(
                                  physics: NeverScrollableScrollPhysics(),
                                  controller: _unitsTabController,
                                  isScrollable: true,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicator: UnderlineTabIndicator(
                                      borderSide: BorderSide(
                                          width: 3.0, color: Colors.white),
                                      insets: EdgeInsets.symmetric(
                                          horizontal: 22.0, vertical: 5),
                                      borderRadius: BorderRadius.circular(8)),
                                  labelStyle: TextStyle(
                                      fontSize: widget.size * 18,
                                      fontWeight: FontWeight.w500),
                                  labelPadding: EdgeInsets.symmetric(
                                      horizontal: widget.size * 10),
                                  tabs: [
                                    Tab(
                                      child: Text(" All "),
                                    ),
                                    Tab(
                                      child: Text(
                                        "Unit 1",
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        "Unit 2",
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        "Unit 3",
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        "Unit 4",
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        "Unit 5",
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: TabBarView(
                                      controller: _unitsTabController,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: [
                                    SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          StreamBuilder<List<UnitsConvertor>>(
                                            stream:
                                                readUnits(widget.ID, widget.branch),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
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

                                                return Padding(
                                                  padding: EdgeInsets.all(
                                                      widget.size * 5.0),
                                                  child: ListView.separated(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: units!.length,
                                                    itemBuilder:
                                                        (context, int index) {
                                                      final unit = units[index];

                                                      return Column(
                                                        children: [
                                                          subUnit(
                                                            width: widget.size,
                                                            height: widget.size,
                                                            size: widget.size,
                                                            ID: widget.ID,
                                                            branch: widget.branch,
                                                            unit: unit,
                                                            mode: widget.mode,
                                                            photoUrl: widget.photoUrl,
                                                          ),
                                                          if (isUser())
                                                            Row(
                                                              children: [
                                                                InkWell(
                                                                  child: Chip(
                                                                    elevation: 20,
                                                                    backgroundColor:
                                                                        Colors.black,
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
                                                                              .white,
                                                                          fontSize:
                                                                              widget.size *
                                                                                  14),
                                                                    ),
                                                                  ),
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                UnitsCreator(
                                                                                  type:
                                                                                      "unit",
                                                                                  branch:
                                                                                      widget.branch,
                                                                                  mode:
                                                                                      widget.mode,
                                                                                  UnitId:
                                                                                      widget.ID,
                                                                                  id: unit.id,
                                                                                  Heading:
                                                                                      unit.heading,
                                                                                  Description:
                                                                                      unit.description,
                                                                                  questions:
                                                                                      unit.questions,
                                                                                  PDFUrl:
                                                                                      unit.link,
                                                                                )));
                                                                  },
                                                                ),
                                                                InkWell(
                                                                  child: Chip(
                                                                    elevation: 20,
                                                                    backgroundColor:
                                                                        Colors.black,
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
                                                                              .white,
                                                                          fontSize:
                                                                              widget.size *
                                                                                  14),
                                                                    ),
                                                                  ),
                                                                  onLongPress: () {
                                                                    final deleteFlashNews = FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            widget
                                                                                .branch)
                                                                        .doc(widget
                                                                            .mode)
                                                                        .collection(
                                                                            widget
                                                                                .mode)
                                                                        .doc(
                                                                            widget.ID)
                                                                        .collection(
                                                                            "Units")
                                                                        .doc(unit.id);
                                                                    deleteFlashNews
                                                                        .delete();
                                                                    pushNotificationsSpecificPerson(
                                                                        fullUserId(),
                                                                        "${unit.heading} Unit is deleted from ${widget.mode}",
                                                                        "");
                                                                  },
                                                                  onTap: () {
                                                                    showToastText(
                                                                        "Long Press to Delete");
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                        ],
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (context, index) => SizedBox(
                                                      height: widget.size * 5,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          SizedBox(height: 150,)
                                        ],
                                      ),
                                    ),
                                    StreamBuilder<List<UnitsConvertor>>(
                                      stream:
                                          readUnits(widget.ID, widget.branch),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
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
                                          // Filter units based on the desired condition
                                          final filteredUnits = units!
                                              .where((unit) => unit.heading
                                                  .split(";")
                                                  .first
                                                  .contains("Unit 1"))
                                              .toList();

                                          return Padding(
                                            padding: EdgeInsets.all(
                                                widget.size * 5.0),
                                            child: ListView.separated(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: filteredUnits.length,
                                              itemBuilder:
                                                  (context, int index) {
                                                final unit =
                                                    filteredUnits[index];

                                                return subUnit(
                                                  width: widget.size,
                                                  height: widget.size,
                                                  size: widget.size,
                                                  ID: widget.ID,
                                                  branch: widget.branch,
                                                  unit: unit,
                                                  mode: widget.mode,
                                                  photoUrl: widget.photoUrl,
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) => SizedBox(
                                                height: widget.size * 5,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    StreamBuilder<List<UnitsConvertor>>(
                                      stream:
                                          readUnits(widget.ID, widget.branch),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
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
                                          // Filter units based on the desired condition
                                          final filteredUnits = units!
                                              .where((unit) => unit.heading
                                                  .split(";")
                                                  .first
                                                  .contains("Unit 2"))
                                              .toList();

                                          return Padding(
                                            padding: EdgeInsets.all(
                                                widget.size * 5.0),
                                            child: ListView.separated(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: filteredUnits.length,
                                              itemBuilder:
                                                  (context, int index) {
                                                final unit =
                                                    filteredUnits[index];

                                                return subUnit(
                                                  width: widget.size,
                                                  height: widget.size,
                                                  size: widget.size,
                                                  ID: widget.ID,
                                                  branch: widget.branch,
                                                  unit: unit,
                                                  mode: widget.mode,
                                                  photoUrl: widget.photoUrl,
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) => SizedBox(
                                                height: widget.size * 5,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    StreamBuilder<List<UnitsConvertor>>(
                                      stream:
                                          readUnits(widget.ID, widget.branch),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
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
                                          // Filter units based on the desired condition
                                          final filteredUnits = units!
                                              .where((unit) => unit.heading
                                                  .split(";")
                                                  .first
                                                  .contains("Unit 3"))
                                              .toList();

                                          return Padding(
                                            padding: EdgeInsets.all(
                                                widget.size * 5.0),
                                            child: ListView.separated(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: filteredUnits.length,
                                              itemBuilder:
                                                  (context, int index) {
                                                final unit =
                                                    filteredUnits[index];

                                                return subUnit(
                                                  width: widget.size,
                                                  height: widget.size,
                                                  size: widget.size,
                                                  ID: widget.ID,
                                                  branch: widget.branch,
                                                  unit: unit,
                                                  mode: widget.mode,
                                                  photoUrl: widget.photoUrl,
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) => SizedBox(
                                                height: widget.size * 5,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    StreamBuilder<List<UnitsConvertor>>(
                                      stream:
                                          readUnits(widget.ID, widget.branch),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
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
                                          // Filter units based on the desired condition
                                          final filteredUnits = units!
                                              .where((unit) => unit.heading
                                                  .split(";")
                                                  .first
                                                  .contains("Unit 4"))
                                              .toList();

                                          return Padding(
                                            padding: EdgeInsets.all(
                                                widget.size * 5.0),
                                            child: ListView.separated(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: filteredUnits.length,
                                              itemBuilder:
                                                  (context, int index) {
                                                final unit =
                                                    filteredUnits[index];

                                                return subUnit(
                                                  width: widget.size,
                                                  height: widget.size,
                                                  size: widget.size,
                                                  ID: widget.ID,
                                                  branch: widget.branch,
                                                  unit: unit,
                                                  mode: widget.mode,
                                                  photoUrl: widget.photoUrl,
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) => SizedBox(
                                                height: widget.size * 5,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    StreamBuilder<List<UnitsConvertor>>(
                                      stream:
                                          readUnits(widget.ID, widget.branch),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
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
                                          // Filter units based on the desired condition
                                          final filteredUnits = units!
                                              .where((unit) => unit.heading
                                                  .split(";")
                                                  .first
                                                  .contains("Unit 5"))
                                              .toList();

                                          return Padding(
                                            padding: EdgeInsets.all(
                                                widget.size * 5.0),
                                            child: ListView.separated(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: filteredUnits.length,
                                              itemBuilder:
                                                  (context, int index) {
                                                final unit =
                                                    filteredUnits[index];

                                                return subUnit(
                                                  width: widget.size,
                                                  height: widget.size,
                                                  size: widget.size,
                                                  ID: widget.ID,
                                                  branch: widget.branch,
                                                  unit: unit,
                                                  mode: widget.mode,
                                                  photoUrl: widget.photoUrl,
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) => SizedBox(
                                                height: widget.size * 5,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ]))
                            ],
                          )
                        : SingleChildScrollView(
                      physics: BouncingScrollPhysics(),

                      child: Column(
                              children: [
                                if (isUser())
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: widget.size * 10),
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
                                          "Add",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: widget.size * 14),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UnitsCreator(
                                                      type: "unit",
                                                      branch: widget.branch,
                                                      id: widget.ID,
                                                      mode: widget.mode,
                                                    )));
                                      },
                                    ),
                                  ),
                                StreamBuilder<List<UnitsConvertor>>(
                                  stream: readUnits(widget.ID, widget.branch),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
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

                                      return Padding(
                                        padding:
                                            EdgeInsets.all(widget.size * 5.0),
                                        child: ListView.separated(
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: units!.length,
                                          itemBuilder: (context, int index) {
                                            final unit = units[index];

                                            return Column(
                                              children: [
                                                subUnit(
                                                  width: widget.size,
                                                  height: widget.size,
                                                  size: widget.size,
                                                  ID: widget.ID,
                                                  branch: widget.branch,
                                                  unit: unit,
                                                  mode: widget.mode,
                                                  photoUrl: widget.photoUrl,
                                                ),
                                                if (isUser())
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        child: Chip(
                                                          elevation: 20,
                                                          backgroundColor:
                                                          Colors.black,
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
                                                                    .white,
                                                                fontSize:
                                                                widget.size *
                                                                    14),
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      UnitsCreator(
                                                                        type:
                                                                        "unit",
                                                                        branch:
                                                                        widget.branch,
                                                                        mode:
                                                                        widget.mode,
                                                                        UnitId:
                                                                        widget.ID,
                                                                        id: unit.id,
                                                                        Heading:
                                                                        unit.heading,
                                                                        Description:
                                                                        unit.description,
                                                                        questions:
                                                                        unit.questions,
                                                                        PDFUrl:
                                                                        unit.link,
                                                                      )));
                                                        },
                                                      ),
                                                      InkWell(
                                                        child: Chip(
                                                          elevation: 20,
                                                          backgroundColor:
                                                          Colors.black,
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
                                                                    .white,
                                                                fontSize:
                                                                widget.size *
                                                                    14),
                                                          ),
                                                        ),
                                                        onLongPress: () {
                                                          final deleteFlashNews = FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                              widget
                                                                  .branch)
                                                              .doc(widget
                                                              .mode)
                                                              .collection(
                                                              widget
                                                                  .mode)
                                                              .doc(
                                                              widget.ID)
                                                              .collection(
                                                              "Units")
                                                              .doc(unit.id);
                                                          deleteFlashNews
                                                              .delete();
                                                          pushNotificationsSpecificPerson(
                                                              fullUserId(),
                                                              "${unit.heading} Unit is deleted from ${widget.mode}",
                                                              "");
                                                        },
                                                        onTap: () {
                                                          showToastText(
                                                              "Long Press to Delete");
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              SizedBox(
                                            height: widget.size * 5,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                        ),
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          if (isUser())
                            Padding(
                              padding: EdgeInsets.only(right: widget.size * 10),
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
                                          builder: (context) => UnitsCreator(
                                                type: "textbook",
                                                branch: widget.branch,
                                                id: widget.ID,
                                                mode: widget.mode,
                                              )));
                                },
                              ),
                            ),
                          StreamBuilder<List<BooksConvertor>>(
                            stream: readTextBooks(widget.ID, widget.branch),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
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

                                return Padding(
                                  padding: EdgeInsets.all(widget.size * 5.0),
                                  child: ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: units!.length,
                                    itemBuilder: (context, int index) {
                                      final unit = units[index];

                                      return Column(
                                        children: [
                                          textBookSub(
                                            height: widget.size,
                                            width: widget.size,
                                            size: widget.size,
                                            data: unit,
                                            branch: widget.branch,
                                          ),
                                          if (isUser())
                                            Row(
                                              children: [
                                                InkWell(
                                                  child: Chip(
                                                    elevation: 20,
                                                    backgroundColor:
                                                        Colors.black,
                                                    avatar: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.black45,
                                                        child: Icon(
                                                          Icons.edit_outlined,
                                                        )),
                                                    label: Text(
                                                      "Edit",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              widget.size * 14),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                UnitsCreator(
                                                                  type:
                                                                      "textbook",
                                                                  branch: widget
                                                                      .branch,
                                                                  mode: widget
                                                                      .mode,
                                                                  UnitId:
                                                                      widget.ID,
                                                                  Description: unit
                                                                      .description,
                                                                  id: unit.id,
                                                                  photoUrl: unit
                                                                      .photoUrl,
                                                                  edition: unit
                                                                      .edition,
                                                                  Heading: unit
                                                                      .heading,
                                                                  author: unit
                                                                      .Author,
                                                                  PDFUrl:
                                                                      unit.link,
                                                                )));
                                                  },
                                                ),
                                                InkWell(
                                                  child: Chip(
                                                    elevation: 20,
                                                    backgroundColor:
                                                        Colors.black,
                                                    avatar: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.black45,
                                                        child: Icon(
                                                          Icons.delete_rounded,
                                                        )),
                                                    label: Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              widget.size * 14),
                                                    ),
                                                  ),
                                                  onLongPress: () {
                                                    final deleteFlashNews =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                widget.branch)
                                                            .doc(widget.mode)
                                                            .collection(
                                                                widget.mode)
                                                            .doc(widget.ID)
                                                            .collection(
                                                                "TextBooks")
                                                            .doc(unit.id);
                                                    deleteFlashNews.delete();
                                                    pushNotificationsSpecificPerson(
                                                        "sujithnimmala03@gmail.com",
                                                        "${unit.heading} Unit is deleted from ${widget.mode}",
                                                        "");
                                                  },
                                                  onTap: () {
                                                    showToastText(
                                                        "Long Press to Delete");
                                                  },
                                                ),
                                              ],
                                            ),
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                      height: widget.size * 5,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),

                      child: Column(
                        children: [
                          if (isUser())
                            Padding(
                              padding: EdgeInsets.only(right: widget.size * 10),
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
                                          builder: (context) => UnitsCreator(
                                                type: "more",
                                                branch: widget.branch,
                                                id: widget.ID,
                                                mode: widget.mode,
                                              )));
                                },
                              ),
                            ),
                          StreamBuilder<List<UnitsMoreConvertor>>(
                            stream: readMore(widget.ID, widget.branch),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
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

                                return Padding(
                                  padding: EdgeInsets.all(widget.size * 5.0),
                                  child: ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: units!.length,
                                    itemBuilder: (context, int index) {
                                      final unit = units[index];

                                      return Column(
                                        children: [
                                          subMore(
                                            width: widget.size,
                                            height: widget.size,
                                            size: widget.size,
                                            ID: widget.ID,
                                            branch: widget.branch,
                                            unit: unit,
                                            mode: widget.mode,
                                            photoUrl: widget.photoUrl,
                                          ),
                                          if (isUser())
                                            Row(
                                              children: [
                                                InkWell(
                                                  child: Chip(
                                                    elevation: 20,
                                                    backgroundColor:
                                                        Colors.black,
                                                    avatar: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.black45,
                                                        child: Icon(
                                                          Icons.edit_outlined,
                                                        )),
                                                    label: Text(
                                                      "Edit",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              widget.size * 14),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                UnitsCreator(
                                                                  type: "more",
                                                                  branch: widget
                                                                      .branch,
                                                                  mode: widget
                                                                      .mode,
                                                                  UnitId:
                                                                      widget.ID,
                                                                  id: unit.id,
                                                                  Heading: unit
                                                                      .heading,
                                                                  Description: unit
                                                                      .description,
                                                                  PDFUrl:
                                                                      unit.link,
                                                                )));
                                                  },
                                                ),
                                                InkWell(
                                                  child: Chip(
                                                    elevation: 20,
                                                    backgroundColor:
                                                        Colors.black,
                                                    avatar: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.black45,
                                                        child: Icon(
                                                          Icons.delete_rounded,
                                                        )),
                                                    label: Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              widget.size * 14),
                                                    ),
                                                  ),
                                                  onLongPress: () {
                                                    final deleteFlashNews =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                widget.branch)
                                                            .doc(widget.mode)
                                                            .collection(
                                                                widget.mode)
                                                            .doc(widget.ID)
                                                            .collection("More")
                                                            .doc(unit.id);
                                                    deleteFlashNews.delete();
                                                    pushNotificationsSpecificPerson(
                                                        "sujithnimmala03@gmail.com",
                                                        "${unit.heading} Unit is deleted from ${widget.mode}",
                                                        "");
                                                  },
                                                  onTap: () {
                                                    showToastText(
                                                        "Long Press to Delete");
                                                  },
                                                ),
                                              ],
                                            ),
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                      height: widget.size * 5,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
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

  late TabController _tabController;

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
        data = '${mbSize.toStringAsFixed(2)} MB';
      } else {
        data = '${kbSize.toStringAsFixed(2)} KB';
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
    newQuestionsList = widget.unit.questions.split(";");
    newList = widget.unit.description.split(";");
    _tabController = new TabController(
      vsync: this,
      length: 2,
    );
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
    if (widget.unit.link.isNotEmpty)
      pdfFile = File("${folderPath}/pdfs/${getFileName(widget.unit.link)}");
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.size * 25),
        color: isExp
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.1),
        border: Border.all(color: isExp ? Colors.white54 : Colors.white12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pdfFile.existsSync()
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(widget.size * 25),
                      child: SizedBox(
                        height: widget.height * 160,
                        width: widget.size * 120,
                        child: Stack(
                          children: [
                            isLoading
                                ? PDFView(
                                    defaultPage: index,
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
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: widget.size * 15,
                                    top: widget.size * 8),
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
                                            borderRadius: BorderRadius.circular(
                                                widget.size * 25),
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.5)),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: widget.size * 3,
                                                horizontal: widget.size * 10),
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
                                            borderRadius: BorderRadius.circular(
                                                widget.size * 25),
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.5)),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: widget.size * 3,
                                                horizontal: widget.size * 8),
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
                      ),
                    )
                  : SizedBox(
                      height: 98, child: Image.asset("assets/pdf_icon.png")),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: widget.size * 5, horizontal: widget.size * 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "   ${widget.unit.heading.split(";").last}",
                        style: TextStyle(
                          fontSize: widget.size * 25.0,
                          color: Colors.amber,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: isExp ? 6 : 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(widget.size * 8),
                                    border: Border.all(color: Colors.white24)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: widget.size * 3,
                                      horizontal: widget.size * 8),
                                  child: Text(
                                    widget.unit.heading.split(";").first,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: widget.size * 15),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.circular(widget.size * 13)),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius:
                                        BorderRadius.circular(widget.size * 10),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.3))),
                                padding: EdgeInsets.all(widget.size * 3),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      " ~ ${widget.unit.size} ",
                                      style: TextStyle(
                                          color: Colors.lightBlueAccent,
                                          fontSize: widget.size * 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      " ${widget.unit.id.split("-").first}",
                                      style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: widget.size * 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 2,
                            child: widget.unit.link.isNotEmpty
                                ? Row(
                                    children: [
                                      InkWell(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      widget.size * 8),
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              border: Border.all(
                                                  color: pdfFile.existsSync()
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
                                                      pdfFile.existsSync()
                                                          ? "Read Now"
                                                          : "Download",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              widget.size * 20),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            if (pdfFile.existsSync()) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PdfViewerPage(
                                                              size: widget.size,
                                                              pdfUrl:
                                                                  "${folderPath}/pdfs/${getFileName(widget.unit.link)}")));
                                            } else {
                                              setState(() {
                                                isDownloaded = true;
                                              });
                                              await download(widget.unit.link);
                                              setState(() {});
                                            }
                                          }),
                                      if (pdfFile.existsSync())
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
                                    ],
                                  )
                                : Container(),
                          ),
                          Flexible(
                              child: widget.unit.description.isNotEmpty
                                  ? InkWell(
                                      child: Text(
                                        isExp ? "..Less " : "More.. ",
                                        style: TextStyle(
                                            color: Colors.greenAccent,
                                            fontWeight: FontWeight.w600,
                                            fontSize: widget.size * 20),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          isExp = !isExp;
                                        });
                                      },
                                    )
                                  : Container())
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (isDownloaded)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.size * 25),
              child: LinearProgressIndicator(),
            ),
          if (isExp)
            SizedBox(
              height: Height(context) / 2.7,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(widget.size * 8.0),
                    child: TabBarView(
                        physics: BouncingScrollPhysics(),
                        controller: _tabController,
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: widget.size * 60,
                                ),
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: newList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (newList.length > 1) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              bottom: widget.height * 8),
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
                                                        : newList[index]
                                                            .split("@")
                                                            .first,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            widget.size * 18),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              int indexNumber = 0;
                                              try {
                                                indexNumber = int.parse(
                                                    newList[index]
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
                                                              size: widget.size,
                                                              pdfUrl:
                                                                  "${folderPath}/pdfs/${getFileName(widget.unit.link)}",
                                                              defaultPage:
                                                                  indexNumber -
                                                                      1,
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
                                            padding: EdgeInsets.all(
                                                widget.size * 8.0),
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
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: widget.size * 60,
                                ),
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: newQuestionsList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
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
                                                Flexible(
                                                  child: Text(
                                                    isUser()
                                                        ? newQuestionsList[
                                                            index]
                                                        : newQuestionsList[
                                                                index]
                                                            .split("@")
                                                            .first,
                                                    style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize:
                                                            widget.size * 15),
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
                                                              size: widget.size,
                                                              pdfUrl:
                                                                  "${folderPath}/pdfs/${getFileName(widget.unit.link)}",
                                                              defaultPage:
                                                                  indexNumber -
                                                                      1,
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
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        widget.size * 8)),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  widget.size * 8.0),
                                              child: Text(
                                                "No Question",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: widget.size * 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                              ],
                            ),
                          ),
                        ]),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        height: widget.size * 40,
                        child: Center(
                          child: TabBar(
                            indicator: BoxDecoration(
                                border: Border.all(color: Colors.white12),
                                borderRadius:
                                    BorderRadius.circular(widget.size * 15),
                                color: Color.fromRGBO(4, 11, 23, 1)),
                            controller: _tabController,
                            isScrollable: true,
                            labelPadding: EdgeInsets.symmetric(horizontal: 25),
                            tabs: [
                              Tab(
                                child: Text(
                                  "Description",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.size * 25,
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "Questions",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: widget.size * 25),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class subMore extends StatefulWidget {
  final UnitsMoreConvertor unit;
  final String mode;
  final String photoUrl;
  final String branch;
  final String ID;
  final double size;
  final double height;
  final double width;

  const subMore(
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
    if (widget.unit.link.split(";").last.isNotEmpty &&
        widget.unit.link.split(";").first == "PDF")
      file = File(
          "${folderPath}/pdfs/${getFileName(widget.unit.link.split(";").last)}");

    return InkWell(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.size * 25),
          color: Colors.black.withOpacity(0.07),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.unit.link.split(";").first == "PDF")
                  file.existsSync() &&
                          widget.unit.link.split(";").last.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(widget.size * 25),
                          child: SizedBox(
                            height: widget.height * 160,
                            width: widget.size * 120,
                            child: Stack(
                              children: [
                                isLoading
                                    ? PDFView(
                                        defaultPage: index,
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
                          ),
                        )
                      : SizedBox(
                          height: 120,
                          child: Image.asset("assets/pdf_icon.png")),
                if (widget.unit.link.split(";").first == "Image")
                  InkWell(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(widget.size * 25),
                      child: SizedBox(
                        height: widget.height * 100,
                        width: widget.size * 160,
                        child: Image.network(
                          widget.unit.link.split(";").last,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImageZoom(
                                    size: widget.size,
                                    width: widget.width,
                                    height: widget.height,
                                    url: widget.unit.link.split(";").last,
                                    file: File(""),
                                  )));
                    },
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
                        width: widget.size * 50),
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: widget.size * 5,
                        horizontal: widget.size * 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.unit.heading.split(";").first,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: widget.size * 22),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: widget.size * 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (widget.unit.link.split(";").first == "PDF")
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
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                                              size: widget.size,
                                                              pdfUrl:
                                                                  "${folderPath}/pdfs/${getFileName(widget.unit.link.split(";").last)}")));
                                            } else {
                                              setState(() {
                                                isDownloaded = true;
                                              });
                                              await download(
                                                  widget.unit.link
                                                      .split(";")
                                                      .last,
                                                  "pdfs");
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
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.1),
                                    borderRadius:
                                        BorderRadius.circular(widget.size * 13),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.3))),
                                padding: EdgeInsets.all(widget.size * 3),
                                child: Text(
                                  " ${widget.unit.id.split("-").first}",
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: widget.size * 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (widget.unit.description.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: widget.size * 5, horizontal: widget.size * 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.unit.description,
                      style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                          fontSize: widget.size * 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
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
      onTap: () {
        if (widget.unit.link.split(";").first == "YouTube" ||
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
      physics: BouncingScrollPhysics(),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: widget.size * 40),
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
                                  if (BranchNew.photoUrl.isNotEmpty) {
                                    final Uri uri =
                                        Uri.parse(BranchNew.photoUrl);
                                    final String fileName =
                                        uri.pathSegments.last;
                                    var name = fileName.split("/").last;
                                    file = File("${folderPath}/updates/$name");
                                  }

                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: widget.size * 2,
                                        horizontal: widget.size * 8),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      widget.size * 15),
                                              border: Border.all(
                                                  color: Colors.white10)),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: widget.size * 35,
                                                    height: widget.size * 35,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              widget.size * 17),
                                                      image: BranchNew.photoUrl.isNotEmpty && file.existsSync()?DecorationImage(
                                                        image: FileImage(file),
                                                        fit: BoxFit.cover,
                                                      ):noImageFound,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  widget.size *
                                                                      5),
                                                      child: Text(
                                                        BranchNew.heading,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                widget.size *
                                                                    20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: widget.size * 45,
                                                    right: widget.size * 10,
                                                    bottom: widget.size * 5),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      BranchNew.description,
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize:
                                                              widget.size * 15),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: widget.size * 40,
                                                    right: widget.size * 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    if (BranchNew
                                                        .link.isNotEmpty)
                                                      InkWell(
                                                        child: Text(
                                                          "Open (Link)",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .lightBlueAccent,
                                                              fontSize:
                                                                  widget.size *
                                                                      15),
                                                        ),
                                                        onTap: () {
                                                          ExternalLaunchUrl(
                                                              BranchNew.link);
                                                        },
                                                      ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: widget.size * 5),
                                                      child: Text(
                                                        BranchNew.id
                                                            .split("-")
                                                            .first,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white38,
                                                            fontSize:
                                                                widget.size *
                                                                    10),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (isUser())
                                          Row(
                                            children: [
                                              Spacer(),
                                              InkWell(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[500],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            widget.size * 15),
                                                    border: Border.all(
                                                        color: Colors.white),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: widget.size * 10,
                                                        right: widget.size * 10,
                                                        top: widget.size * 5,
                                                        bottom:
                                                            widget.size * 5),
                                                    child: Text("Edit"),
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              updateCreator(
                                                                NewsId:
                                                                    BranchNew
                                                                        .id,
                                                                link: BranchNew
                                                                    .link,
                                                                heading:
                                                                    BranchNew
                                                                        .heading,
                                                                photoUrl:
                                                                    BranchNew
                                                                        .photoUrl,
                                                                subMessage:
                                                                    BranchNew
                                                                        .description,
                                                                branch: widget
                                                                    .branch,
                                                                width:
                                                                    widget.size,
                                                                height:
                                                                    widget.size,
                                                                size:
                                                                    widget.size,
                                                              )));
                                                },
                                              ),
                                              SizedBox(
                                                width: widget.size * 20,
                                              ),
                                              InkWell(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[500],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            widget.size * 15),
                                                    border: Border.all(
                                                        color: Colors.white),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: widget.size * 10,
                                                        right: widget.size * 10,
                                                        top: widget.size * 5,
                                                        bottom:
                                                            widget.size * 5),
                                                    child: Text("Delete"),
                                                  ),
                                                ),
                                                onTap: () async {
                                                  FirebaseFirestore.instance
                                                      .collection("update")
                                                      .doc(BranchNew.id)
                                                      .delete();
                                                  pushNotificationsSpecificPerson(
                                                      fullUserId(),
                                                      " ${BranchNew.heading} Deleted from Updates",
                                                      "");
                                                },
                                              ),
                                              SizedBox(
                                                width: widget.size * 20,
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
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
          ),
          Positioned(
              top: widget.size * 8,
              right: 0,
              left: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(widget.size * 8),
                        border: isBranch
                            ? Border.all(color: Colors.green.withOpacity(0.8))
                            : Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: widget.size * 10,
                            right: widget.size * 10,
                            top: widget.size * 3,
                            bottom: widget.size * 3),
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
