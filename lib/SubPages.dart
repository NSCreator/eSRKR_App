// ignore_for_file: camel_case_types, non_constant_identifier_names, must_be_immutable
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'package:path_provider/path_provider.dart';
import 'package:srkr_study_app/TextField.dart';
import 'package:srkr_study_app/homePage/HomePage.dart';
import 'package:srkr_study_app/homePage/settings.dart';
import 'package:srkr_study_app/test.dart';
import 'add subjects.dart';
import 'package:flutter/material.dart';
import 'functions.dart';
import 'package:http/http.dart' as http;

import 'notification.dart';

class RegSylMPConvertor {
  final String reg;
  final String syllabus, modelPaper;

  RegSylMPConvertor(
      {required this.syllabus, required this.reg, required this.modelPaper});

  Map<String, dynamic> toJson() =>
      {"syllabus": syllabus, "reg": reg, "modelPaper": modelPaper};

  static RegSylMPConvertor fromJson(Map<String, dynamic> json) =>
      RegSylMPConvertor(
        reg: json['reg'] ?? "",
        modelPaper: json['modelPaper'] ?? "",
        syllabus: json["syllabus"] ?? "",
      );

  static List<RegSylMPConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class RegTimeTableConvertor {
  final String regulation;
  final List<timeTableConvertor> timeTable;

  RegTimeTableConvertor({
    required this.regulation,
    required this.timeTable,
  });

  Map<String, dynamic> toJson() => {
        "regulation": regulation,
        "timeTables": timeTable.map((table) => table.toJson()).toList(),
      };

  static RegTimeTableConvertor fromJson(Map<String, dynamic> json) =>
      RegTimeTableConvertor(
        regulation: json['regulation'] ?? "",
        timeTable: timeTableConvertor.fromMapList(json['timeTables'] ?? []),
      );

  static List<RegTimeTableConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class timeTableConvertor {
  final String link;
  final String title;

  timeTableConvertor({
    required this.title,
    required this.link,
  });

  Map<String, dynamic> toJson() => {"title": title, "link": link};

  static timeTableConvertor fromJson(Map<String, dynamic> json) =>
      timeTableConvertor(
        link: json['link'] ?? "",
        title: json["title"] ?? "",
      );

  static List<timeTableConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class RegSylMP extends StatefulWidget {
  String branch;

  RegSylMP({required this.branch});

  @override
  State<RegSylMP> createState() => _RegSylMPState();
}

class _RegSylMPState extends State<RegSylMP> {
  List<RegSylMPConvertor> RegSylMPList = [];
  List<RegSylMPConvertor> UpdateRegSylMPList = [];

  Future<void> getRegulation() async {
    try {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection("StudyMaterials")
          .doc(widget.branch)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? data = documentSnapshot.data();

        if (data != null) {
          setState(() {
            RegSylMPList =
                RegSylMPConvertor.fromMapList(data["RegSylMP"] ?? []);
          });
        }
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  List<RegSylMPConvertor> descriptionList = [];
  final TextEditingController _syllabusController = TextEditingController();
  final TextEditingController _headingController = TextEditingController();
  final TextEditingController _modelPaperController = TextEditingController();
  int selectedDescriptionIndex = -1;

  void editDescription(int index) {
    setState(() {
      selectedDescriptionIndex = index;
      _syllabusController.text = descriptionList[index].syllabus;
      _modelPaperController.text = descriptionList[index].modelPaper;
    });
  }

  void saveDescription() {
    String editedHeading = _syllabusController.text;
    String editedPdfLink = _modelPaperController.text;
    String idLink = _headingController.text;

    if (editedHeading.isNotEmpty &&
        editedPdfLink.isNotEmpty &&
        selectedDescriptionIndex != -1) {
      setState(() {
        descriptionList[selectedDescriptionIndex] = RegSylMPConvertor(
            syllabus: editedHeading, modelPaper: editedPdfLink, reg: idLink);
        _syllabusController.clear();
        _modelPaperController.clear();
        selectedDescriptionIndex = -1;
      });
    }
  }

  @override
  void initState() {
    getRegulation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          // Prevents dismissing the dialog by tapping outside
                          builder: (context) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text('Creating...'),
                                ],
                              ),
                            );
                          },
                        );
                        String reg = "R20";
                        List<RegTimeTableConvertor> data = [];
                        for (int year = 1; year <= 4; year++) {
                          for (int sem = 1; sem <= 2; sem++) {
                            data.add(RegTimeTableConvertor(
                                regulation:
                                    "${reg.toUpperCase()} $year YEAR $sem SEM",
                                timeTable: []));
                          }
                        }

                        try {
                          await FirebaseFirestore.instance
                              .collection("StudyMaterials")
                              .doc("ECE")
                              .update({
                            "RegulationAndTimeTable":
                                data.map((info) => info.toJson()).toList(),
                          });
                        } catch (e) {
                          print("Error updating data: $e");
                          // Handle the error as needed
                        }

                        messageToOwner(
                            "Regulation is Created.\nBy '${fullUserId()}'\n   Regulation : $reg\n **${widget.branch}");
                        Navigator.pop(context);
                      },
                      child: Text("ADD All Regulation")),
                  ElevatedButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          // Prevents dismissing the dialog by tapping outside
                          builder: (context) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text('Creating...'),
                                ],
                              ),
                            );
                          },
                        );
                        String reg = "R20";

                        for (int year = 1; year <= 4; year++) {
                          UpdateRegSylMPList.add(RegSylMPConvertor(
                              syllabus: "",
                              reg: "${reg.toUpperCase()} $year YEAR",
                              modelPaper: ""));
                        }

                        try {
                          await FirebaseFirestore.instance
                              .collection("StudyMaterials")
                              .doc("ECE")
                              .update({
                            "RegSylMP":
                                UpdateRegSylMPList.map((info) => info.toJson())
                                    .toList()
                          });
                        } catch (e) {
                          print("Error updating data: $e");
                          // Handle the error as needed
                        }

                        messageToOwner(
                            "Regulation is Created.\nBy '${fullUserId()}'\n   Regulation : $reg\n **${widget.branch}");
                        Navigator.pop(context);
                      },
                      child: Text("ADD Regulation"))
                ],
              ),
              RefreshIndicator(
                onRefresh: getRegulation,
                child: ListView.builder(
                    itemCount: RegSylMPList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, int index) {
                      final data = RegSylMPList[index];
                      return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.reg,
                              style:
                                  TextStyle(color: Colors.amber, fontSize: 25),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Syllabus : ${data.syllabus}",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {}, child: Icon(Icons.edit))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Model Paper : ${data.modelPaper}",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {}, child: Icon(Icons.edit))
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class TimeTables extends StatefulWidget {
  List<RegTimeTableConvertor> data;
  String branch;
  String reg;

  TimeTables({required this.branch, required this.reg, required this.data});

  @override
  State<TimeTables> createState() => _TimeTablesState();
}

class _TimeTablesState extends State<TimeTables> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            backButton(
                text: "Time Tables ( All Regulations )", child: SizedBox()),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.data.length,
                itemBuilder: (context, int index) {
                  final data = widget.data[index];

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    decoration: BoxDecoration(
                        color: data.regulation == widget.reg.toUpperCase()
                            ? Colors.black38
                            : Colors.black12,
                        borderRadius: BorderRadius.circular(25)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Text(
                            data.regulation.toUpperCase(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontFamily: "test"),
                          ),
                        ),
                        data.timeTable.isNotEmpty
                            ? Container(
                          constraints: BoxConstraints(maxHeight: 100),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: data.timeTable.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, int index) {
                                    var BranchNew = data.timeTable[index];

                                    return Column(
                                      children: [
                                        SizedBox(
                                            height: 60,
                                            width: 80,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: ImageShowAndDownload(
                                                  image: BranchNew.link,
                                                  isZoom: true,
                                                ))),
                                        Text(
                                          BranchNew.title.toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "test"),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                            : Row(
                                children: [
                                  Icon(
                                    Icons.table_view,
                                    color: Colors.black26,
                                    size: 50,
                                  ),
                                  Expanded(
                                      child: Text(
                                    "No Time Tables from ${data.regulation}",
                                    style: TextStyle(
                                        color: Colors.black87, fontSize: 18),
                                    maxLines: 2,
                                  ))
                                ],
                              ),
                      ],
                    ),
                  );
                }),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    ));
  }
}


class allBooks extends StatefulWidget {
  final String branch;

  const allBooks({
    Key? key,
    required this.branch,
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_sharp,
                            color: Colors.black,
                          ),
                          Text(
                            " Books",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: (16) / (13),
                            ),
                            itemCount: Books!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return textBookSub(
                                data: Books[index],
                                branch: widget.branch,
                              );
                            },
                          );
                        }
                    }
                  }),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class textBookSub extends StatefulWidget {
  String branch;
  BooksConvertor data;

  textBookSub({required this.data, required this.branch});

  @override
  State<textBookSub> createState() => _textBookSubState();
}

class _textBookSubState extends State<textBookSub>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  bool isDownloaded = false;
  String folderPath = "";

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
    });
  }

  download(String photoUrl) async {
    final Uri uri = Uri.parse(photoUrl);
    final String fileName = uri.pathSegments.last;
    var name = fileName.split("/").last;
    if (photoUrl.startsWith('https://drive.google.com')) {
      name = photoUrl.split('/d/')[1].split('/')[0];

      photoUrl = "https://drive.google.com/uc?export=download&id=$name";
    }
    final response = await http.get(Uri.parse(photoUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory('${documentDirectory.path}/pdfs');
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

  late TabController _tabController;

  @override
  void initState() {
    getPath();
    _tabController = new TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          padding: EdgeInsets.all(2.0),
          margin: EdgeInsets.all(2.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black.withOpacity(0.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (File("${folderPath}/pdfs/${getFileName(widget.data.link)}")
                      .existsSync() &&
                  widget.data.link.isNotEmpty)
                AspectRatio(
                  aspectRatio: (16) / (8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        isLoading
                            ? PDFView(
                                filePath:
                                    "${folderPath}/pdfs/${getFileName(widget.data.link)}",
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 2),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.data.heading,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Colors.black),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (File(
                                        "${folderPath}/pdfs/${getFileName(widget.data.link)}")
                                    .existsSync())
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: InkWell(
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                        size: 25,
                                      ),
                                      onLongPress: () async {
                                        if (File(
                                                "${folderPath}/pdfs/${getFileName(widget.data.link)}")
                                            .existsSync()) {
                                          await File(
                                                  "${folderPath}/pdfs/${getFileName(widget.data.link)}")
                                              .delete();
                                        }
                                        setState(() {});
                                        showToastText("File has been deleted");
                                      },
                                      onTap: () {
                                        showToastText("Long Press To Delete");
                                      },
                                    ),
                                  ),
                              ],
                            ),
                            if (!File(
                                    "${folderPath}/pdfs/${getFileName(widget.data.link)}")
                                .existsSync())
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "A : ${widget.data.Author}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Colors.black87),
                                  ),
                                  Text(
                                    "E : ${widget.data.edition}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                            if (widget.data.link.isNotEmpty &&
                                !File("${folderPath}/pdfs/${getFileName(widget.data.link)}")
                                    .existsSync())
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          color: Colors.blueGrey.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                              child: Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Row(
                                                  children: [
                                                    if (!File(
                                                            "${folderPath}/pdfs/${getFileName(widget.data.link)}")
                                                        .existsSync())
                                                      Text(
                                                        "Download ",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w800),
                                                      ),
                                                    Icon(
                                                      File("${folderPath}/pdfs/${getFileName(widget.data.link)}")
                                                              .existsSync()
                                                          ? Icons.open_in_new
                                                          : Icons
                                                              .download_for_offline_outlined,
                                                      color: Colors.greenAccent,
                                                      size: 25,
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
                                                          builder: (context) =>
                                                              PdfViewerPage(
                                                                  pdfUrl:
                                                                      "${folderPath}/pdfs/${getFileName(widget.data.link)}")));
                                                } else {
                                                  setState(() {
                                                    isDownloaded = true;
                                                  });
                                                  await download(
                                                      widget.data.link);
                                                }
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (isGmail() || isOwner())
                                    PopupMenuButton(
                                      child: Icon(
                                        Icons.more_vert,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                      // Callback that sets the selected popup menu item.
                                      onSelected: (item) async {
                                        if (item == "edit") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BooksCreator(
                                                        branch: widget.branch,
                                                        data: widget.data,
                                                      )));
                                        } else {
                                          messageToOwner("${widget.branch}");
                                          FirebaseFirestore.instance
                                              .collection("StudyMaterials")
                                              .doc(widget.branch)
                                              .collection("Books")
                                              .doc(widget.data.id)
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
                            if (isDownloaded)
                              LinearProgressIndicator(
                                color: Colors.amber,
                              ),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 3),
                            child: Text(
                              "Description : ${widget.data.description}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
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
                        pdfUrl:
                            "${folderPath}/pdfs/${getFileName(widget.data.link)}")));
          } else {
            showToastText("Download Book");
          }
        });
  }
}

class textBookUnit extends StatefulWidget {
  final subjectConvertor subject;
  TextBookConvertor textBook;
  String branch, creator;

  textBookUnit(
      {required this.subject,
      required this.creator,
      required this.textBook,
      required this.branch});

  @override
  State<textBookUnit> createState() => _textBookUnitState();
}

class _textBookUnitState extends State<textBookUnit> {
  bool isLoading = true;
  bool isDownloaded = false;
  String folderPath = "";
  bool fullDescription = false;

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
    late File file = File("");
    if (widget.textBook.Link.isNotEmpty)
      file = File("${folderPath}/pdfs/${getFileName(widget.textBook.Link)}");
    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30)),
        width: 300,
        child: Row(
          children: [
            if (!file.existsSync() && widget.textBook.Link.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Icon(
                      Icons.download_for_offline,
                      color: Colors.black,
                      size: 50,
                    ),
                    if (isDownloaded)
                      SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(
                            color: Colors.amber,
                          ))
                  ],
                ),
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.textBook.Heading,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (file.existsSync())
                      InkWell(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.black.withOpacity(0.4),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.deepOrange,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                        onLongPress: () async {
                          if (File(
                                  "${folderPath}/pdfs/${getFileName(widget.textBook.Link)}")
                              .existsSync()) {
                            await File(
                                    "${folderPath}/pdfs/${getFileName(widget.textBook.Link)}")
                                .delete();
                          }
                          setState(() {});
                          showToastText("File has been deleted");
                        },
                        onTap: () {
                          showToastText("Long Press To Delete");
                        },
                      ),
                    if (widget.creator.split(";").contains(fullUserId()) ||
                        isOwner())
                      PopupMenuButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.black,
                          size: 20,
                        ),
                        // Callback that sets the selected popup menu item.
                        onSelected: (item) async {
                          if (item == "edit") {
                            // if (widget.isUnit)
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UnitsCreator(
                                        branch: widget.branch,
                                        mode: 'textBook',
                                        subjectId: widget.subject.id,
                                        subject: widget.subject,
                                        textBook: widget.textBook)));
                          } else if (item == "delete") {
                            await _firestore
                                .collection('StudyMaterials')
                                .doc(widget.branch)
                                .collection("Subjects")
                                .doc(widget.subject.id)
                                .update({
                              'textBooks': FieldValue.arrayRemove(
                                  [widget.textBook.toJson()]),
                            });
                            Navigator.pop(context);
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
      onTap: () async {
        File isFile =
            File("${folderPath}/pdfs/${getFileName(widget.textBook.Link)}");
        if (isFile.existsSync()) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PdfViewerPage(
                      pdfUrl:
                          "${folderPath}/pdfs/${getFileName(widget.textBook.Link)}")));
        } else {
          setState(() {
            isDownloaded = true;
          });
          await download(widget.textBook.Link, "pdfs");
          // setState(() {});
        }
      },
    );
  }
}


class SyllabusAndModelPapers extends StatefulWidget {
  List<RegSylMPConvertor> data;

  String reg, branch;

  SyllabusAndModelPapers(
      {required this.branch, required this.reg, required this.data});

  @override
  State<SyllabusAndModelPapers> createState() => _SyllabusAndModelPapersState();
}

class _SyllabusAndModelPapersState extends State<SyllabusAndModelPapers>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
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
    _tabController = new TabController(
      vsync: this,
      length: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        SizedBox(
          height: 10,
        ),
        InkWell(
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10,bottom: 10),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 20,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        TabBar(
          tabAlignment: TabAlignment.center,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black12),
          controller: _tabController,
          isScrollable: true,
          labelPadding: EdgeInsets.symmetric(horizontal: 10),
          tabs: [
            Tab(
              child: Text(
                "  Syllabus  ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            Tab(
              child: Text(
                "  Model paper  ",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: TabBarView(
            physics: BouncingScrollPhysics(),
            controller: _tabController,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.data.length,
                itemBuilder: (context, int index) {
                  var data = widget.data[index];
                  return syllabusAndModelpaperContainer(
                    id: data.reg,
                    reg: widget.reg,
                    branch: widget.branch,
                    link: data.syllabus,
                    mode: "syll",
                  );
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.data.length,
                itemBuilder: (context, int index) {
                  var data = widget.data[index];

                  return syllabusAndModelpaperContainer(
                      id: data.reg,
                      reg: widget.reg,
                      branch: widget.branch,
                      link: data.modelPaper,
                      mode: "mp");
                },
              ),
            ],
          ),
        ),
      ]),
    ));
  }
}

class syllabusAndModelpaperContainer extends StatefulWidget {
  String reg, branch, link, id, mode;

  syllabusAndModelpaperContainer(
      {required this.reg,
      required this.mode,
      required this.branch,
      required this.id,
      required this.link});

  @override
  State<syllabusAndModelpaperContainer> createState() =>
      _syllabusAndModelpaperContainerState();
}

class _syllabusAndModelpaperContainerState
    extends State<syllabusAndModelpaperContainer> {
  bool isLoading = false;
  bool isDownloaded = false;
  String folderPath = "";
  File pdf = File("");

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
    });
  }

  download(String photoUrl) async {
    final Uri uri = Uri.parse(photoUrl);
    final String fileName = uri.pathSegments.last;
    var name = fileName.split("/").last;
    if (photoUrl.startsWith('https://drive.google.com')) {
      name = photoUrl.split('/d/')[1].split('/')[0];

      photoUrl = "https://drive.google.com/uc?export=download&id=$name";
    }
    final response = await http.get(Uri.parse(photoUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory('${documentDirectory.path}/pdfs');
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
    return InkWell(
      onTap: () async {
        File isFile = File("${folderPath}/pdfs/${getFileName(widget.link)}");
        if (isFile.existsSync()) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PdfViewerPage(
                      pdfUrl:
                          "${folderPath}/pdfs/${getFileName(widget.link)}")));
        } else {
          setState(() {
            isDownloaded = true;
          });
          await download(widget.link);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Row(
            children: [
              if (widget.link.length > 3)
                File("${folderPath}/pdfs/${getFileName(widget.link)}")
                            .existsSync() &&
                        widget.link.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: SizedBox(
                            height: 60,
                            width: 100,
                            child: PDFView(
                              filePath:
                                  "${folderPath}/pdfs/${getFileName(widget.link)}",
                            )),
                      )
                    : Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Icon(
                              Icons.download_for_offline,
                              color: Colors.black,
                              size: 50,
                            ),
                            if (isDownloaded)
                              SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CircularProgressIndicator(
                                    color: Colors.amber,
                                  ))
                          ],
                        ),
                      ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.id.toUpperCase(),
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (widget.link.isEmpty)
                        Text(
                          "No Data",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.amber,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      if (widget.link.isNotEmpty &&
                          File("${folderPath}/pdfs/${getFileName(widget.link)}")
                              .existsSync())
                        Padding(
                          padding: EdgeInsets.only(
                              left: 5, right: 5, top: 1, bottom: 1),
                          child: InkWell(
                            child: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                              size: 25,
                            ),
                            onLongPress: () async {
                              if (File(
                                      "${folderPath}/pdfs/${getFileName(widget.link)}")
                                  .existsSync()) {
                                await File(
                                        "${folderPath}/pdfs/${getFileName(widget.link)}")
                                    .delete();
                              }
                              setState(() {});
                              showToastText("File has been deleted");
                            },
                            onTap: () {
                              showToastText("Long Press To Delete");
                            },
                          ),
                        ),
                      if (isGmail() || isOwner())
                        PopupMenuButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.black,
                            size: 25,
                          ),
                          // Callback that sets the selected popup menu item.
                          onSelected: (item) {
                            if (item == "edit") {
                              widget.mode == "syl"
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              timeTableSyllabusModalPaperCreator(
                                                mode: 'syl',
                                                reg: widget.reg,
                                                branch: widget.branch,
                                                id: widget.id,
                                                heading: widget.id,
                                                link: widget.link,
                                              )))
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              timeTableSyllabusModalPaperCreator(
                                                mode: widget.mode,
                                                reg: widget.reg,
                                                branch: widget.branch,
                                                id: widget.id,
                                                heading: widget.id,
                                                link: widget.link,
                                              )));
                            } else if (item == "delete") {
                              widget.mode == "syl"
                                  ? FirebaseFirestore.instance
                                      .collection(widget.branch)
                                      .doc("regulation")
                                      .collection("regulationWithYears")
                                      .doc(widget.id.substring(0, 10))
                                      .update({"syllabus": ""})
                                  : FirebaseFirestore.instance
                                      .collection(widget.branch)
                                      .doc("regulation")
                                      .collection("regulationWithYears")
                                      .doc(widget.id.substring(0, 10))
                                      .update({"modelPaper": ""});
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
                  if (widget.link.isNotEmpty)
                    InkWell(
                      onTap: () {
                        ExternalLaunchUrl(widget.link);
                      },
                      child: Text(
                        "Link (open)",
                        style: TextStyle(
                          fontSize: 18.0,
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
  }
}

class updatesPage extends StatefulWidget {
  final String branch;

  const updatesPage({
    Key? key,
    required this.branch,
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
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              backButton(
                  text: "College Updates",
                  child: SizedBox(
                    width: 80,
                  )),
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
                              padding: EdgeInsets.only(
                                  left: 10, top: 10, bottom: 20, right: 8),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: BranchNews.length,
                              itemBuilder: (context, int index) {
                                final BranchNew = BranchNews[index];

                                return InkWell(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (BranchNew.link.isEmpty &&
                                            BranchNew.photoUrl.isNotEmpty)
                                          Padding(
                                            padding: EdgeInsets.all(3.0),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: ImageShowAndDownload(
                                                  image: BranchNew.photoUrl,
                                                  isZoom: true,
                                                )),
                                          ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                    vertical: 3),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (BranchNew
                                                        .heading.isNotEmpty)
                                                      Text(
                                                        BranchNew.heading,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    if (BranchNew
                                                        .description.isNotEmpty)
                                                      Text(
                                                        " ${BranchNew.description}",
                                                        style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(0.8),
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (BranchNew.link.isNotEmpty &&
                                                BranchNew.photoUrl.isNotEmpty)
                                              SizedBox(
                                                height: 100,
                                                width: 140,
                                                child: Padding(
                                                  padding: EdgeInsets.all(3.0),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child:
                                                          ImageShowAndDownload(
                                                        image:
                                                            BranchNew.photoUrl,
                                                        isZoom: true,
                                                      )),
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(
                                            height: 2,
                                            child: Divider(
                                              color: Colors.black26,
                                            )),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 2),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${calculateTimeDifference(BranchNew.id)}  ",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black87),
                                                  ),
                                                  Icon(
                                                    Icons.circle,
                                                    color: Colors.black,
                                                    size: 3,
                                                  ),
                                                  Text(
                                                    "  ${BranchNew.creator.split("@").first}",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black87),
                                                  ),
                                                ],
                                              ),
                                              if (isGmail() || isOwner())
                                                SizedBox(
                                                  height: 18,
                                                  child: PopupMenuButton(
                                                    padding: EdgeInsets.all(0),
                                                    icon: Icon(
                                                      Icons.more_horiz,
                                                      color: Colors.black,
                                                      size: 18,
                                                    ),
                                                    // Callback that sets the selected popup menu item.
                                                    onSelected: (item) async {
                                                      if (item == "edit") {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        updateCreator(
                                                                          NewsId:
                                                                              BranchNew.id,
                                                                          link:
                                                                              BranchNew.link,
                                                                          heading:
                                                                              BranchNew.heading,
                                                                          photoUrl:
                                                                              BranchNew.photoUrl,
                                                                          subMessage:
                                                                              BranchNew.description,
                                                                          branch:
                                                                              widget.branch,
                                                                        )));
                                                      } else if (item ==
                                                          "delete") {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "update")
                                                            .doc(BranchNew.id)
                                                            .delete();
                                                        messageToOwner(
                                                            "Update is Deleted\nBy '${fullUserId()}\n    Heading : ${BranchNew.heading}\n    Description : ${BranchNew.description}    \nImage : ${BranchNew.photoUrl}    \nLink : ${BranchNew.link}\n **${widget.branch}");
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
                                );
                              },
                            );
                        }
                    }
                  }),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}

