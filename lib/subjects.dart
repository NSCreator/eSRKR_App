import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:srkr_study_app/test.dart';
import 'package:http/http.dart' as http;
import 'SubPages.dart';
import 'TextField.dart';
import 'add subjects.dart';
import 'favorites.dart';
import 'functions.dart';
import 'homePage/HomePage.dart';
import 'homePage/settings.dart';
import 'notification.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Subjects extends StatefulWidget {
  final String branch;
  List<RegSylMPConvertor> syllabusModelPaper;
  final String reg;

  List<subjectConvertor> subjects;

  Subjects({
    Key? key,
    required this.branch,
    required this.subjects,
    required this.syllabusModelPaper,
    required this.reg,
  }) : super(key: key);

  @override
  State<Subjects> createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  String subjectFilter = "None";
  List<String> ids = [];

  getData() async {
    List<subjectConvertor> subjects = await SubjectPreferences.get();
    ids = subjects.map((x) => x.id).toList();
    setState(() {
      ids;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    List<subjectConvertor> filteredItems = widget.subjects
        .where((item) => item.regulation.any((reg) => reg
            .toString()
            .toLowerCase()
            .startsWith(widget.reg.substring(0, 2))))
        .toList();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            " Subjects",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                    PopupMenuButton(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Text(
                              "Filter ",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            Icon(
                              Icons.filter_list,
                              color: Colors.black,
                              size: 20,
                            )
                          ],
                        ),
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
              ),
              Column(
                children: [
                  if (filteredItems.isNotEmpty && subjectFilter == "Regulation")
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Based On Your Regulation",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w500),
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          child: InkWell(
                            child: subjectsContainer(
                              data: SubjectsData,
                              branch: widget.branch,
                              isSub: true,
                              syllabusModelPaper: widget.syllabusModelPaper,
                              ids: ids,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration:
                                      Duration(milliseconds: 300),
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      subjectUnitsData(
                                    branch: widget.branch,
                                    mode: true,
                                    data: SubjectsData,
                                    syllabusModelPaper:
                                        widget.syllabusModelPaper,
                                    reg: widget.reg,
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
                        );
                      },
                    ),
                  if (filteredItems.isNotEmpty && subjectFilter == "Regulation")
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "All Subjects",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.subjects.length,
                    itemBuilder: (context, int index) {
                      final SubjectsData = widget.subjects[index];
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        child: InkWell(
                          child: subjectsContainer(
                            syllabusModelPaper: widget.syllabusModelPaper,
                            data: SubjectsData,
                            branch: widget.branch,
                            isSub: true,
                            ids: ids,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 300),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        subjectUnitsData(
                                  reg: widget.reg,
                                  syllabusModelPaper: widget.syllabusModelPaper,
                                  branch: widget.branch,
                                  mode: true,
                                  data: SubjectsData,
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
                      );
                    },
                  ),
                ],
              ),
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

class LabSubjects extends StatefulWidget {
  final String branch;
  final String reg;
  final List<RegSylMPConvertor> syllabusModelPaper;

  List<subjectConvertor> labSubjects;

  LabSubjects({
    Key? key,
    required this.branch,
    required this.labSubjects,
    required this.syllabusModelPaper,
    required this.reg,
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
                padding: const EdgeInsets.all(10.0),
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
                            " Lab Subjects",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.labSubjects.length,
                itemBuilder: (context, int index) {
                  final LabSubjectsData = widget.labSubjects[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: InkWell(
                      child: subjectsContainer(
                        syllabusModelPaper: widget.syllabusModelPaper,
                        data: LabSubjectsData,
                        branch: widget.branch,
                        isSub: false,
                        ids: [],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 300),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    subjectUnitsData(
                              reg: widget.reg,
                              syllabusModelPaper: widget.syllabusModelPaper,
                              branch: widget.branch,
                              mode: false,
                              data: LabSubjectsData,
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
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class subjectsContainer extends StatefulWidget {
  List<String> ids;
  subjectConvertor data;
  List<RegSylMPConvertor> syllabusModelPaper;
  String branch;
  bool isSub;

  subjectsContainer(
      {required this.ids,
      required this.data,
      required this.syllabusModelPaper,
      required this.branch,
      required this.isSub});

  @override
  State<subjectsContainer> createState() => _subjectsContainerState();
}

class _subjectsContainerState extends State<subjectsContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: widget.data.createdByAndPermissions.id == fullUserId()
              ? Colors.lightBlueAccent.withOpacity(0.15)
              : Colors.black.withOpacity(0.07),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 85,
                margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Center(
                  child: Text(
                    widget.data.heading.short,
                    style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: "test"),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.heading.full,
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    // if (widget.data.createdByAndPermissions.id.isNotEmpty)
                    //   Text(
                    //     "By ${widget.data.createdByAndPermissions.id.split("@").first}",
                    //     style: TextStyle(
                    //       fontSize: 12.0,
                    //       color: Colors.black.withOpacity(0.8),
                    //     ),
                    //     maxLines: 1,
                    //   ),
                  ],
                ),
              ),
              Row(
                children: [
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(20)),
                      child: widget.ids.contains(widget.data.id)
                          ? Icon(Icons.bookmark)
                          : Icon(Icons.bookmark_border_sharp),
                    ),
                    onTap: () async {
                      if (widget.isSub) {
                        if (widget.ids.contains(widget.data.id)) {
                          await SubjectPreferences.delete(widget.data.id);
                        } else {
                          await SubjectPreferences.add(widget.data);
                        }
                        List<subjectConvertor> subjects =
                            await SubjectPreferences.get();
                        widget.ids = subjects.map((x) => x.id).toList();
                        setState(() {
                          widget.ids;
                        });
                      } else {
                        if (widget.ids.contains(widget.data.id)) {
                          await LabSubjectPreferences.delete(widget.data.id);
                        } else {
                          await LabSubjectPreferences.add(widget.data);
                        }
                        List<subjectConvertor> subjects =
                            await LabSubjectPreferences.get();
                        widget.ids = subjects.map((x) => x.id).toList();
                        setState(() {
                          widget.ids;
                        });
                      }
                    },
                  ),
                  if (widget.data.createdByAndPermissions.id == fullUserId() ||
                      isOwner())
                    PopupMenuButton(
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.black,
                        size: 25,
                      ),
                      onSelected: (item) async {
                        if (item == "edit") {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 300),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      SubjectCreator(
                                data: widget.data,
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
                        } else if (item == "delete") {
                          FirebaseFirestore.instance
                              .collection("StudyMaterials")
                              .doc(widget.branch)
                              .collection(
                                  widget.isSub ? "Subjects" : "LabSubjects")
                              .doc(widget.data.id)
                              .delete();
                          await getBranchStudyMaterials(widget.branch, true);
                          messageToOwner("${widget.data.toJson()}");
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
              )
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     if (widget.data.regulation.isNotEmpty)
          //       Container(
          //         padding: EdgeInsets.symmetric(
          //             vertical:   3, horizontal:   8),
          //         margin:
          //             EdgeInsets.symmetric(horizontal:   8, vertical: 2),
          //         decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(  8),
          //             color: Colors.black45),
          //         child: Text(
          //           widget.data.regulation
          //               .toString()
          //               .replaceAll("[", "")
          //               .replaceAll("]", "")
          //               .replaceAll(",", " - "),
          //           style: TextStyle(color: Colors. black, fontSize:   10),
          //         ),
          //       ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

final GlobalKey<_subjectUnitsDataState> UnitKey =
    GlobalKey<_subjectUnitsDataState>();

class subjectUnitsData extends StatefulWidget {
  subjectConvertor data;
  String reg;
  bool mode;
  List<RegSylMPConvertor> syllabusModelPaper;

  String branch;

  subjectUnitsData({
    required this.mode,
    required this.reg,
    required this.syllabusModelPaper,
    required this.data,
    required this.branch,
  });

  @override
  State<subjectUnitsData> createState() => _subjectUnitsDataState();
}

class _subjectUnitsDataState extends State<subjectUnitsData>
    with TickerProviderStateMixin {
  late TabController _tabController;

  bool isReadMore = false;
  bool isDownloaded = false;
  String folderPath = "";
  File file = File("");
  String unitFilter = "all";
  String moreFilter = "all";

  final List<String> months = [
    'None',
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
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  List searchList = ["Units", "Text Books", "More"];
  int currentIndex = 0;
  Color inActive = Colors.blueGrey.withOpacity(0.3);
  Color active = Colors.white;

  @override
  void initState() {
    getPath();
    _tabController = new TabController(
      vsync: this,
      length: widget.mode ? 4 : 3,
    );

    super.initState();
  }

  void changeTab(int newIndex) {
    _tabController.animateTo(newIndex);
  }

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
    });
  }

  download(String pdfUrl) async {
    final Uri uri = Uri.parse(pdfUrl);
    final String fileName = uri.pathSegments.last;
    var name = fileName.split("/").last;
    if (pdfUrl.startsWith('https://drive.google.com')) {
      name = pdfUrl.split('/d/')[1].split('/')[0];

      pdfUrl = "https://drive.google.com/uc?export=download&id=$name";
    }
    final response = await http.get(Uri.parse(pdfUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory('${documentDirectory.path}/pdfs');
    if (!await newDirectory.exists()) {
      await newDirectory.create(recursive: true);
    }
    final file = File('${newDirectory.path}/${name}');
    await file.writeAsBytes(response.bodyBytes);
    setState(() {});
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
              text: widget.data.heading.short,
              child: Visibility(
                visible:
                    widget.data.createdByAndPermissions.id == fullUserId() ||
                        isOwner(),
                child: PopupMenuButton(
                  child: Container(
                    width: 120,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 25,
                        ),
                        SizedBox(
                          width: 70,
                          child: CarouselSlider(
                            items: List.generate(
                              [
                                widget.mode ? "Units" : "Manuals",
                                if (widget.mode) "Text Books",
                                "More"
                              ].length,
                              (int index) {
                                return Center(
                                  child: Text(
                                    [
                                      widget.mode ? "Units" : "Manuals",
                                      if (widget.mode) "Text Books",
                                      "More"
                                    ][index],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
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
                              height: 35,
                              autoPlayAnimationDuration:
                                  const Duration(seconds: 3),
                              autoPlay: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Callback that sets the selected popup menu item.
                  onSelected: (item) {
                    if (item == "Unit") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UnitsCreator(
                                    mode: "units",
                                    branch: widget.branch,
                                    subjectId: widget.data.id,
                                    subject: widget.data,
                                  )));
                    } else if (item == "Text Book") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UnitsCreator(
                                    mode: "textBook",
                                    branch: widget.branch,
                                    subjectId: widget.data.id,
                                    subject: widget.data,
                                  )));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UnitsCreator(
                                    mode: "more",
                                    branch: widget.branch,
                                    subjectId: widget.data.id,
                                    subject: widget.data,
                                  )));
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      value: "Unit",
                      child: Text(widget.mode ? "Unit" : "Records & Manuals"),
                    ),
                    if (widget.mode)
                      PopupMenuItem(
                        value: "Text Book",
                        child: Text('Text Book'),
                      ),
                    PopupMenuItem(
                      value: "More",
                      child: Text('More'),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blueGrey.withOpacity(0.1),
                    Colors.blueGrey.withOpacity(0.3),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.data.heading.full.isNotEmpty)
                          Text(
                            widget.data.heading.full,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Text(
                                "${months[int.tryParse(widget.data.id.split('-').first.split('.')[1]) ?? 1]} ${widget.data.id.split('-').first.split('.').last}     ",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 14),
                              ),
                              if (widget.data.regulation.isNotEmpty)
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 1, horizontal: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.black12,
                                      ),
                                      child: Text(
                                        widget.data.regulation
                                            .toString()
                                            .replaceAll("[", "")
                                            .replaceAll("]", "")
                                            .replaceAll(",", " - "),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (widget.data.createdByAndPermissions.id.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 5, left: 8, right: 8),
                            child: Text(
                              "By ${widget.data.createdByAndPermissions.id.replaceAll(";", " - @")}",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        if (widget.data.description.isNotEmpty)
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: 5, left: 8, right: 8),
                            child: Text(
                              widget.data.description,
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.9),
                                fontSize: 16,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.mode ? "Units " : "Records & Manuals ",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 25),
                  ),
                  Expanded(
                      child: Divider(
                    color: Colors.black,
                    thickness: 3,
                  )),
                  Row(
                    children: [
                      if (widget.mode)
                        PopupMenuButton(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 8),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Text(
                                  "Filter ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Icon(
                                  Icons.filter_list,
                                  color: Colors.white,
                                  size: 20,
                                )
                              ],
                            ),
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
                    ],
                  )
                ],
              ),
            ),
            unitFilter == "all"
                ? ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.data.units.length,
                    itemBuilder: (context, int index) {
                      final unit = widget.data.units[index];
                      return subUnit(
                        subject: widget.data,
                        data: unit,
                        creator: widget.data.createdByAndPermissions.id,
                        branch: widget.branch,
                        subjectId: widget.data.id,
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 5,
                    ),
                  )
                : ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.data.units
                        .where((unit) => unit.Unit.contains(unitFilter))
                        .toList()
                        .length,
                    itemBuilder: (context, int index) {
                      final filteredUnits = widget.data.units
                          .where((unit) => unit.Unit.contains(unitFilter))
                          .toList();
                      final unit = filteredUnits[index];
                      return subUnit(
                        subject: widget.data,
                        data: unit,
                        creator: widget.data.createdByAndPermissions.id,
                        branch: widget.branch,
                        subjectId: widget.data.id,
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 5,
                    ),
                  ),

            if (widget.mode)
              Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15, bottom: 10,top:15),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SyllabusAndModelPapers(
                                          data: widget.syllabusModelPaper,
                                          reg: widget.reg,
                                          branch: widget.branch,
                                        )));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Syllabus & Model Paper",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                                maxLines: 1,
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.black,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                      if (widget.reg != "None")
                        ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            itemCount: widget.syllabusModelPaper.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final data = widget.syllabusModelPaper[index];
                              if (data.reg.startsWith(widget.reg
                                      .substring(0, 10)
                                      .toUpperCase()) &&
                                  data.modelPaper.isNotEmpty &&
                                  data.syllabus.isNotEmpty) {
                                if (!File("${folderPath}/pdfs/${getFileName(data.syllabus)}")
                                        .existsSync() &&
                                    data.syllabus.isNotEmpty) {
                                  download(data.syllabus);
                                }
                                if (!File("${folderPath}/pdfs/${getFileName(data.modelPaper)}")
                                        .existsSync() &&
                                    data.modelPaper.isNotEmpty) {
                                  download(data.modelPaper);
                                }
                              }
                              return data.reg.startsWith(widget.reg
                                          .substring(0, 10)
                                          .toUpperCase()) &&
                                      data.modelPaper.isNotEmpty &&
                                      data.syllabus.isNotEmpty
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      padding: const EdgeInsets.all(5.0),
                                      margin: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PdfViewerPage(
                                                              pdfUrl:
                                                                  "${folderPath}/pdfs/${getFileName(data.syllabus)}")));
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: Container(
                                                        height: 50,
                                                        color: Colors.black12,
                                                        child:
                                                            File("${folderPath}/pdfs/${getFileName(data.syllabus)}")
                                                                    .existsSync()
                                                                ? PDFView(
                                                                    filePath:
                                                                        "${folderPath}/pdfs/${getFileName(data.syllabus)}",
                                                                  )
                                                                : Container()),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 5.0,
                                                        horizontal: 10),
                                                    child: Text(
                                                      "Syllabus Paper",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Divider(
                                              color: Colors.white,
                                              thickness: 2,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PdfViewerPage(
                                                              pdfUrl:
                                                                  "${folderPath}/pdfs/${getFileName(data.modelPaper)}")));
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: Container(
                                                        height: 50,
                                                        color: Colors.black12,
                                                        child:
                                                            File("${folderPath}/pdfs/${getFileName(data.modelPaper)}")
                                                                    .existsSync()
                                                                ? PDFView(
                                                                    filePath:
                                                                        "${folderPath}/pdfs/${getFileName(data.modelPaper)}",
                                                                  )
                                                                : Container()),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 5.0,
                                                        horizontal: 10),
                                                    child: Text(
                                                      "Model Paper",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container();
                            }),
                    ],
                  ),
                  if (widget.data.oldPapers.isNotEmpty)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 15.0, right: 10, top: 50, bottom: 10),
                          child: Text(
                            "Old Papers",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.data.oldPapers.length,
                          itemBuilder: (context, int index) {
                            final unit = widget.data.oldPapers[index];
                            return subOldPapers(
                              data: unit,
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 5,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            if (widget.mode)
              Column(
                children: [
                  if (widget.data.textBooks.isNotEmpty)
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Text Books",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 70,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.data.textBooks.length,
                      itemBuilder: (context, int index) {
                        final unit = widget.data.textBooks[index];
                        return textBookUnit(
                          branch: widget.branch,
                          subject: widget.data,
                          creator: widget.data.createdByAndPermissions.id,
                          textBook: unit,
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: 5,
                      ),
                    ),
                  ),
                ],
              ),
            if (widget.data.units.fold(
                    0,
                    (count, element) =>
                        count +
                        (element.Question.isNotEmpty
                            ? element.Question.length
                            : 0)) >
                0)
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 50, right: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Questions & Description ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                          Expanded(
                              child: Divider(
                            thickness: 3,
                            color: Colors.black,
                          )),
                          if (widget.mode)
                            PopupMenuButton(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Text(
                                      "Filter ",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    Icon(
                                      Icons.filter_list,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  ],
                                ),
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
                            )
                        ],
                      ),
                    ),
                    unitFilter == "all"
                        ? ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.data.units.length,
                            itemBuilder: (context, int index) {
                              final unit = widget.data.units[index];
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 3),
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      unit.Heading,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                    ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: unit.Description.length,
                                        itemBuilder: (context, int index) {
                                          final a = unit.Description[index];
                                          return InkWell(
                                              onTap: () {
                                                if (File(
                                                        "${folderPath}/pdfs/${getFileName(unit.Link)}")
                                                    .existsSync()) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PdfViewerPage(
                                                                pdfUrl:
                                                                    "${folderPath}/pdfs/${getFileName(unit.Link)}",
                                                                defaultPage: a
                                                                    .pageNumber,
                                                              )));
                                                } else {
                                                  showToastText("Download PDF");
                                                }
                                              },
                                              child: Text(
                                                a.data,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ));
                                        }),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 3),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 8),
                                      decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: unit.Question.length,
                                          itemBuilder: (context, int index) {
                                            final a = unit.Question[index];
                                            return InkWell(
                                                onTap: () {
                                                  if (File(
                                                          "${folderPath}/pdfs/${getFileName(unit.Link)}")
                                                      .existsSync()) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                PdfViewerPage(
                                                                  pdfUrl:
                                                                      "${folderPath}/pdfs/${getFileName(unit.Link)}",
                                                                  defaultPage: a
                                                                      .pageNumber,
                                                                )));
                                                  } else {
                                                    showToastText(
                                                        "Download PDF");
                                                  }
                                                },
                                                child: Text(
                                                  "${index + 1}. ${a.data}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18),
                                                ));
                                          }),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              height: 5,
                            ),
                          )
                        : ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.data.units
                                .where((unit) => unit.Unit.contains(unitFilter))
                                .toList()
                                .length,
                            itemBuilder: (context, int index) {
                              final filteredUnits = widget.data.units
                                  .where(
                                      (unit) => unit.Unit.contains(unitFilter))
                                  .toList();
                              final unit = filteredUnits[index];
                              return subUnit(
                                subject: widget.data,
                                data: unit,
                                creator: widget.data.createdByAndPermissions.id,
                                branch: widget.branch,
                                subjectId: widget.data.id,
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              height: 5,
                            ),
                          ),
                  ],
                ),
              ),
            if (widget.mode == "Subjects")
              Column(
                children: [
                  if (widget.data.textBooks.isNotEmpty)
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Text Books",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 70,
                    child: ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.data.textBooks.length,
                      itemBuilder: (context, int index) {
                        final unit = widget.data.textBooks[index];

                        return textBookUnit(
                          branch: widget.branch,
                          subject: widget.data,
                          creator: widget.data.createdByAndPermissions.id,
                          textBook: unit,
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: 5,
                      ),
                    ),
                  ),
                ],
              ),
            if(widget.data.moreInfos.isNotEmpty)Column(
              children: [

                Padding(
                  padding: EdgeInsets.only(
                    left: 15,right: 10
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "More Info ",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                      Expanded(
                          child: Divider(
                            thickness: 3,
                            color: Colors.black,
                          )),
                      PopupMenuButton(
                        icon:Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 3, horizontal: 8),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Text(
                                "Filter ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Icon(
                                Icons.filter_list,
                                color: Colors.white,
                                size: 20,
                              )
                            ],
                          ),
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
                        itemCount: widget.data.moreInfos.length,
                        itemBuilder: (context, int index) {
                          final unit = widget.data.moreInfos[index];

                          return subMore(
                            subjectId: widget.data.id,
                            branch: widget.branch,
                            data: unit,
                            creator: widget.data.createdByAndPermissions.id,
                            subject: widget.data,
                          );
                        },
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.data.moreInfos
                            .where((unit) => unit.Type.startsWith(moreFilter))
                            .toList()
                            .length,
                        itemBuilder: (context, int index) {
                          final filteredUnits = widget.data.moreInfos
                              .where((unit) => unit.Type.startsWith(moreFilter))
                              .toList();
                          final unit = filteredUnits[index];
                          return subMore(
                            subject: widget.data,
                            subjectId: widget.data.id,
                            branch: widget.branch,
                            creator: widget.data.createdByAndPermissions.id,
                            data: unit,
                          );
                        },
                      ),
              ],
            ),
            SizedBox(height: 50,),

          ],
        ),
      )),
    );
  }

  Widget tabs(String data, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: EdgeInsets.only(top: 3, bottom: 1, left: 3, right: 8),
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              color: Colors.black87, borderRadius: BorderRadius.circular(15)),
          child: Center(
              child: Text(
            "${count}",
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: "test"),
          )),
        ),
        Text(
          "$data   ",
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "test"),
        ),
      ],
    );
  }
}

class subUnit extends StatefulWidget {
  final subjectConvertor subject;
  final UnitConvertor data;
  final String branch, subjectId;
  final String creator;

  subUnit({
    Key? key,
    required this.data,
    required this.branch,
    required this.subject,
    required this.creator,
    required this.subjectId,
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
      int byteLength = response.body.length;
      double kbSize = byteLength / 1024; // Convert to KB
      double mbSize = kbSize / 1024; // Convert to MB

      if (mbSize >= 1.0) {
      } else {}
      // FirebaseFirestore.instance
      //     .collection(widget.branch)
      //     .doc(widget.mode)
      //     .collection(widget.mode)
      //     .doc(widget.ID)
      //     .collection("Units")
      //     .doc(widget.data.id)
      //     .update({"size": data});
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.Link.isNotEmpty)
      pdfFile = File("${folderPath}/pdfs/${getFileName(widget.data.Link)}");
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 1, // Blur radius
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.data.Link.length > 3)
                    File("${folderPath}/pdfs/${getFileName(widget.data.Link)}")
                                .existsSync() &&
                            widget.data.Link.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: SizedBox(
                                height: 60,
                                width: 80,
                                child: PDFView(
                                  filePath:
                                      "${folderPath}/pdfs/${getFileName(widget.data.Link)}",
                                )),
                          )
                        : Container(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.data.Heading}",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: pdfFile.existsSync()
                        ? InkWell(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
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
                          )
                        : Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Icon(
                                Icons.download_for_offline,
                                color: Colors.black,
                                size: 46,
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
                  )
                ],
              ),
            ),
            // if (widget.creator.contains(fullUserId()) || isOwner())
            //   PopupMenuButton(
            //     padding: EdgeInsets.zero,
            //
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 8),
            //       child: Icon(
            //         Icons.more_vert,
            //         color: Colors.black,
            //         size: 18,
            //       ),
            //     ),
            //     // Callback that sets the selected popup menu item.
            //     onSelected: (item) async {
            //       if (item == "edit") {
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => UnitsCreator(
            //                     subject: widget.subject,
            //                     mode: "units",
            //                     subjectId: widget.subjectId,
            //                     branch: widget.branch,
            //                     unit: widget.data)));
            //       } else if (item == "delete") {
            //         await _firestore
            //             .collection('StudyMaterials')
            //             .doc(widget.branch)
            //             .collection("Subjects")
            //             .doc(widget.subjectId)
            //             .update({
            //           'units': FieldValue.arrayRemove([widget.data.toJson()]),
            //         });
            //         Navigator.pop(context);
            //       }
            //     },
            //     itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            //       const PopupMenuItem(
            //         value: "edit",
            //         child: Text('Edit'),
            //       ),
            //       const PopupMenuItem(
            //         value: "delete",
            //         child: Text('Delete'),
            //       ),
            //     ],
            //   ),
          ],
        ),
      ),
      onTap: () async {
        if (pdfFile.existsSync()) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PdfViewerPage(
                      pdfUrl:
                          "${folderPath}/pdfs/${getFileName(widget.data.Link)}")));
        } else {
          setState(() {
            isDownloaded = true;
          });
          await download(widget.data.Link);
          setState(() {});
        }
      },
    );
  }
}

class subOldPapers extends StatefulWidget {
  final OldPapersConvertor data;

  subOldPapers({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<subOldPapers> createState() => _subOldPapersState();
}

class _subOldPapersState extends State<subOldPapers>
    with TickerProviderStateMixin {
  bool isDownloaded = false;
  String folderPath = "";
  File pdfFile = File("");

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
      int byteLength = response.body.length;
      double kbSize = byteLength / 1024; // Convert to KB
      double mbSize = kbSize / 1024; // Convert to MB

      if (mbSize >= 1.0) {
      } else {}
      // FirebaseFirestore.instance
      //     .collection(widget.branch)
      //     .doc(widget.mode)
      //     .collection(widget.mode)
      //     .doc(widget.ID)
      //     .collection("Units")
      //     .doc(widget.data.id)
      //     .update({"size": data});
    }
    setState(() {
      isDownloaded = false;
    });
  }

  @override
  void initState() {
    getPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.pdfLink.isNotEmpty)
      pdfFile = File("${folderPath}/pdfs/${getFileName(widget.data.pdfLink)}");
    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: Colors.black.withOpacity(0.15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.data.pdfLink.length > 3)
              File("${folderPath}/pdfs/${getFileName(widget.data.pdfLink)}")
                          .existsSync() &&
                      widget.data.pdfLink.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: SizedBox(
                          height: 60,
                          width: 80,
                          child: PDFView(
                            filePath:
                                "${folderPath}/pdfs/${getFileName(widget.data.pdfLink)}",
                          )),
                    )
                  : Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
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
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.data.heading}",
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            if (pdfFile.existsSync())
              InkWell(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.purpleAccent,
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
          ],
        ),
      ),
      onTap: () async {
        if (pdfFile.existsSync()) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PdfViewerPage(
                      pdfUrl:
                          "${folderPath}/pdfs/${getFileName(widget.data.pdfLink)}")));
        } else {
          setState(() {
            isDownloaded = true;
          });
          await download(widget.data.pdfLink);
          setState(() {});
        }
      },
    );
  }
}

class subMore extends StatefulWidget {
  final MoreInfoConvertor data;
  final subjectConvertor subject;
  final String creator, subjectId, branch;

  const subMore({
    Key? key,
    required this.data,
    required this.subject,
    required this.subjectId,
    required this.branch,
    required this.creator,
  }) : super(key: key);

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
    if (widget.data.Link.isNotEmpty && widget.data.Type == "PDF")
      file = File("${folderPath}/pdfs/${getFileName(widget.data.Link)}");

    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black.withOpacity(0.08),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Row(
                children: [
                  if (file.existsSync() &&
                      widget.data.Link.isNotEmpty &&
                      widget.data.Type == "PDF")
                    SizedBox(
                      width: 100,
                      height: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            isLoading
                                ? PDFView(
                                    defaultPage: 0,
                                    filePath:
                                        "${folderPath}/pdfs/${getFileName(widget.data.Link)}",
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
                                padding: EdgeInsets.only(right: 2, bottom: 2),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.black.withOpacity(0.8),
                                    border: Border.all(
                                        color: Colors.black.withOpacity(0.5)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      "$pages",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (widget.data.Type == "Image")
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: SizedBox(
                        width: 100,
                        height: 60,
                        child: ImageShowAndDownload(
                          image: widget.data.Link,
                        ),
                      ),
                    )
                  else if (widget.data.Type == "YouTube" ||
                      widget.data.Type == "WebSite")
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black38),
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: AssetImage(
                                      widget.data.Type == "YouTube"
                                          ? "assets/YouTubeIcon.png"
                                          : "assets/googleIcon.png"),
                                  fit: BoxFit.cover)),
                          height: 35,
                          width: 40),
                    )
                  else
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        widget.data.Type,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w800),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      "  ${widget.data.Heading}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.creator.contains(fullUserId()) || isOwner())
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
                                  builder: (context) => UnitsCreator(
                                        moreInfo: widget.data,
                                        branch: widget.branch,
                                        mode: "more",
                                        subjectId: widget.subject.id,
                                        subject: widget.subject,
                                      )));
                        } else if (item == "delete") {
                          List<dynamic> updatedUnits = widget.subject.moreInfos
                              .where((unit) => unit.id != widget.data.id)
                              .toList();
                          await _firestore
                              .collection('StudyMaterials')
                              .doc(widget.branch)
                              .collection("Subjects")
                              .doc(widget.subjectId)
                              .update({'moreInfos': updatedUnits});
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
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      widget.data.Link.isNotEmpty && widget.data.Type == "PDF"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (file.existsSync())
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: 5,
                                    ),
                                    child: InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 5),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: Colors.deepOrange,
                                                size: 25,
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
                                        padding: EdgeInsets.only(
                                            left: 10, bottom: 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color:
                                                Colors.black.withOpacity(0.8),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 3, horizontal: 5),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Download",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Icon(
                                                  Icons.file_download_outlined,
                                                  color: Colors.purpleAccent,
                                                  size: 25,
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
                                            widget.data.Link, "pdfs");
                                        setState(() {
                                          isDownloaded = false;
                                        });
                                      }),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                  if (isDownloaded)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: LinearProgressIndicator(),
                    ),
                  if (widget.data.Description.isNotEmpty)
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.data.Description.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (widget.data.Description.length > 0) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 3, left: 10),
                              child: Flexible(
                                child: Text(
                                  widget.data.Description[index],
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.8),
                                      fontSize: 15),
                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "No Question",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
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
                      pdfUrl:
                          "${folderPath}/pdfs/${getFileName(widget.data.Link)}")));
        } else if (widget.data.Type == "YouTube" ||
            widget.data.Type == "WebSite") ExternalLaunchUrl(widget.data.Link);
      },
    );
  }
}
