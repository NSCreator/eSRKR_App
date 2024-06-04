import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:srkr_study_app/auth_page.dart';
import 'package:srkr_study_app/uploader.dart';
import '../get_all_data.dart';
import '../net.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../notification.dart';
import '../pdf_viewer.dart';
import '../favorites.dart';
import '../functions.dart';
import '../settings/settings.dart';
import 'convertors.dart';
import 'creator.dart';

import 'package:dio/dio.dart';

class Subjects extends StatefulWidget {
  final bool mode;

  List<SubjectConverter> subjects;

  Subjects({
    Key? key,
    required this.mode,
    required this.subjects,
  }) : super(key: key);

  @override
  State<Subjects> createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  String subjectFilter = "None";
  List<String> ids = [];

  getData() async {
    List<SubjectConverter> subjects = await SubjectPreferences.get();
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              backButton(),
              Heading(heading: widget.mode ? "Subjects" : "Lab Subjects"),
              GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 8),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  childAspectRatio: 9 / 13.3,
                ),
                itemCount: widget.subjects.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  subjectUnitsData(
                            mode: widget.mode,
                            data: widget.subjects[index],
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
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
                    child: subjectsContainer(
                      data: widget.subjects[index],
                      ids: ids,
                      isSub: widget.mode,
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
  SubjectConverter data;

  bool isSub;

  subjectsContainer(
      {required this.ids, required this.data, required this.isSub});

  @override
  State<subjectsContainer> createState() => _subjectsContainerState();
}

class _subjectsContainerState extends State<subjectsContainer> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        subjectContainer(widget.data),
        Positioned(
            top: 10,
            right: 10,
            child: Row(
              children: [
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: widget.ids.contains(widget.data.id)
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                  ),
                  onTap: () async {
                    if (widget.isSub) {
                      if (widget.ids.contains(widget.data.id)) {
                        await SubjectPreferences.delete(widget.data.id);
                      } else {
                        await SubjectPreferences.add(widget.data);
                      }
                      List<SubjectConverter> subjects =
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
                      List<SubjectConverter> subjects =
                          await LabSubjectPreferences.get();
                      widget.ids = subjects.map((x) => x.id).toList();
                      setState(() {
                        widget.ids;
                      });
                    }
                  },
                ),
                if (isOwner())
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
                        firestore
                            .collection("StudyMaterials")
                            .doc(getBranch(fullUserId()))
                            .collection(
                                widget.isSub ? "Subjects" : "LabSubjects")
                            .doc(widget.data.id)
                            .delete();
                        await getBranchStudyMaterials(true);
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
            ))
      ],
    );
  }
}

final GlobalKey<_subjectUnitsDataState> UnitKey =
    GlobalKey<_subjectUnitsDataState>();

class subjectUnitsData extends StatefulWidget {
  SubjectConverter data;

  bool mode;

  subjectUnitsData({
    required this.mode,
    required this.data,
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

  Future<void> downloadAndUploadToFirebase(
      String url, BuildContext context) async {
    void showProgressDialog(BuildContext context, String message) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Please wait..."),
              ],
            ),
          );
        },
      );
    }

    showProgressDialog(context, 'Downloading');
    final documentDirectory = await getApplicationDocumentsDirectory();
    try {
      final filePath = '${documentDirectory.path}/pdfs/${getFileName(url)}';
      if (!File(filePath).existsSync()) {
        var response;
        if (url.startsWith('https://drive.google.com')) {
          String name = url.split('/d/')[1].split('/')[0];
          url = "https://drive.google.com/uc?export=download&id=$name";
          response = await http.get(Uri.parse(url));
        } else {
          try {
            response = await http.get(Uri.parse(url));
            url = url;
          } catch (e) {
            try {
              url = await getFileUrl(url, esrkr);
            } catch (e) {
              url = await getFileUrl(url, sub_esrkr);
            }

            response = await http.get(Uri.parse(url));
          }
        }
        if (response.statusCode == 200) {
          final Dio dio = Dio();

          await dio.download(url, filePath,
              onReceiveProgress: (receivedBytes, totalBytes) {
            if (totalBytes != -1) {
              print(receivedBytes / totalBytes);
            }
          });
        } else {
          print('Failed to download file. HTTP Status: ${response.statusCode}');
          Navigator.pop(context); // Dismiss the progress dialog
          return; // Exit the function
        }
      }

      FirebaseStorage storage = FirebaseStorage.instance;

      Reference ref = storage.ref().child('web/${getFileName(url)}');
      await ref.putFile(File(filePath));
      try {
        if (await ref.getDownloadURL() == null) {
          showProgressDialog(context, 'Uploading');

          await ref.putFile(File(filePath));

          String downloadURL = await ref.getDownloadURL();

          print(
              'File uploaded to Firebase Storage ${await ref.name}. Download URL: $downloadURL');
        } else {
          print(
              'File already exists in Firebase Storage${await ref.name} ::: ${await ref.getDownloadURL()}');
        }
      } catch (e) {
        print('Error checking file existence in Firebase Storage: $e');
      }
    } catch (e) {
      print('Error downloading and uploading file: $e');
      Navigator.pop(context); // Dismiss the progress dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    List<FileUploader> pdfUnits = [];
    List<FileUploader> otherUnits = [];

    widget.data.units.forEach((unit) {
      if (unit.fileName.split(".").last == "pdf") {
        pdfUnits.add(unit);
      } else {
        otherUnits.add(unit);
      }
    });

    return Scaffold(
      body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade900,
                        ),
                        child: Column(
                          children: [
                            backButton(),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.data.heading.short,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                  if (widget.data.heading.full.isNotEmpty)
                                    Text(
                                      widget.data.heading.full,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  Row(
                                    children: [
                                      if (widget.data.createdByAndPermissions.id
                                          .isNotEmpty)
                                        Expanded(
                                          child: Text(
                                            "By ${widget.data.createdByAndPermissions.id.replaceAll(";", " - @")}",
                                            style: TextStyle(
                                                color: Colors.white54,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      Text(
                                        "${months[int.tryParse(widget.data.id.split('-').first.split('.')[1]) ?? 1]} ${widget.data.id.split('-').first.split('.').last}",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  if (widget.data.description.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 5, left: 8, right: 8),
                                      child: Text(
                                        widget.data.description,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 15,
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
                    ],
                  ),
                ),
                Heading(heading: "Materials"),
                if (pdfUnits.isNotEmpty)
                  GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 2,
                      crossAxisCount: 3,
                      childAspectRatio: 8.5 / 15,
                    ),
                    itemCount: pdfUnits.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: [
                          pdfContainer(data: pdfUnits[index]),
                          // Positioned(
                          //     top: 10,
                          //     left: 10,
                          //     child: InkWell(onTap: (){
                          //       downloadAndUploadToFirebase(pdfUnits[index].url, context);
                          //     },child: Icon(Icons.share)))
                        ],
                      );
                    },
                  ),
                if (otherUnits.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, top: 15, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          "Other Extension files",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        Text(
                          "  Opens Externally",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                if (otherUnits.isNotEmpty)
                  ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: otherUnits.length,
                    itemBuilder: (context, int index) {
                      final unit = otherUnits[index];
                      return subUnit(
                        data: unit,
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 5,
                    ),
                  ),
                if (widget.data.textBooks.isNotEmpty)
                  Heading(heading: "Text Books"),
                if (widget.data.textBooks.isNotEmpty)
                  SizedBox(
                    height: 160,
                    child: ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.data.textBooks.length,
                      itemBuilder: (context, int index) {
                        final unit = widget.data.textBooks[index];

                        return Padding(
                          padding: EdgeInsets.only(left: index == 0 ? 10.0 : 0),
                          child: pdfContainer(
                            data: unit,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: 5,
                      ),
                    ),
                  ),
                if (widget.data.moreInfos.isNotEmpty)
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 10),
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
                              icon: Container(
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
                                  data: unit,
                                  creator:
                                      widget.data.createdByAndPermissions.id,
                                  subject: widget.data,
                                );
                              },
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget.data.moreInfos
                                  .where((unit) =>
                                      unit.Type.startsWith(moreFilter))
                                  .toList()
                                  .length,
                              itemBuilder: (context, int index) {
                                final filteredUnits = widget.data.moreInfos
                                    .where((unit) =>
                                        unit.Type.startsWith(moreFilter))
                                    .toList();
                                final unit = filteredUnits[index];
                                return subMore(
                                  subject: widget.data,
                                  subjectId: widget.data.id,
                                  creator:
                                      widget.data.createdByAndPermissions.id,
                                  data: unit,
                                );
                              },
                            ),
                    ],
                  ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          )),
    );
  }
}

GlobalKey<_DownloadState> downloadKey = GlobalKey<_DownloadState>();

class Download extends StatefulWidget {
  String url;

  Download({required this.url});

  @override
  State<Download> createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  bool isDownloaded = false;
  bool isLoading = false;
  String folderPath = "";
  File pdfFile = File("");
  double downloadProgress = 0.001;

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
    });
  }

  Future<void> download() async {
    setState(() {
      isLoading = true;
    });
    String url = '';
    try {
      var response;
      if (widget.url.startsWith('https://drive.google.com')) {
        String name = widget.url.split('/d/')[1].split('/')[0];
        url = "https://drive.google.com/uc?export=download&id=$name";
        response = await http.get(Uri.parse(url));
      } else {
        try {
          response = await http.get(Uri.parse(widget.url));
          url = widget.url;
        } catch (e) {
          try {
            url = await getFileUrl(widget.url, esrkr);
          } catch (e) {
            url = await getFileUrl(widget.url, sub_esrkr);
          }

          response = await http.get(Uri.parse(url));
        }
      }

      final Dio dio = Dio();

      if (response.statusCode == 200) {
        final documentDirectory = await getApplicationDocumentsDirectory();

        final filePath =
            '${documentDirectory.path}/pdfs/${getFileName(widget.url)}';

        setState(() {
          isDownloaded = true;
          isLoading = false;
        });
        await dio.download(url, filePath,
            onReceiveProgress: (receivedBytes, totalBytes) {
          if (totalBytes != -1) {
            setState(() {
              downloadProgress = receivedBytes / totalBytes;
            });
          }
        });
        setState(() {
          isDownloaded = false; // Update isDownloaded when download is complete
        });

        print('File downloaded successfully');
      } else {
        print('Failed to download file. HTTP Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getPath();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url.isNotEmpty)
      pdfFile = File("${folderPath}/pdfs/${getFileName(widget.url)}");

    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: pdfFile.existsSync() ? Colors.greenAccent : Colors.orange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: pdfFile.existsSync() && !isDownloaded
          ? InkWell(
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 25,
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
          : InkWell(
              onTap: () {
                if (isAnonymousUser()) {
                  showToastText("Please log in with your college ID.");
                  return;
                }
                download();
              },
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black,
                    ),
                    child: Icon(
                      Icons.download,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  if (isDownloaded && !isLoading)
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                        value: downloadProgress,
                      ),
                    )
                  else if (!isDownloaded && isLoading)
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                ],
              ),
            ),
    );
  }
}

class subUnit extends StatefulWidget {
  final FileUploader data;

  subUnit({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<subUnit> createState() => _subUnitState();
}

class _subUnitState extends State<subUnit> with TickerProviderStateMixin {
  String folderPath = "";
  File pdfFile = File("");

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
    if (widget.data.url.isNotEmpty)
      pdfFile = File("${folderPath}/pdfs/${getFileName(widget.data.url)}");
    return InkWell(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white10,
              border: Border.all(color: Colors.white12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1), // Shadow color
                  spreadRadius: 1, // Spread radius
                  blurRadius: 1, // Blur radius
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          "${widget.data.fileName.split(".").first}",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            margin: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.orangeAccent,
                            ),
                            child: Text(
                              widget.data.fileName.split(".").last,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                          Text(
                            "${widget.data.size}",
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Download(url: "${widget.data.url}"),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () async {
        if (File("${folderPath}/pdfs/${getFileName(widget.data.url)}")
            .existsSync()) {
          print(
              "${folderPath}/pdfs/${getFileName(widget.data.url)}.${widget.data.fileName.split(".").last}");
          await openFile("${folderPath}/pdfs/${getFileName(widget.data.url)}",
              widget.data.fileName.split(".").last);
        } else {
          showToastText("Tap Download Button");
        }
      },
    );
  }
}

String getFileNameFromUrl(String url) {
  Uri uri = Uri.parse(url);
  List<String> segments = uri.pathSegments;

  String lastSegment = segments.last;
  String decodedSegment = Uri.decodeComponent(lastSegment.split("/").last);

  return decodedSegment;
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
  final SubjectConverter subject;
  final String creator, subjectId;

  const subMore({
    Key? key,
    required this.data,
    required this.subject,
    required this.subjectId,
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
                          token: esrkr,
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
                                        mode: "more",
                                        subjectId: widget.subject.id,
                                        subject: widget.subject,
                                      )));
                        } else if (item == "delete") {
                          List<dynamic> updatedUnits = widget.subject.moreInfos
                              .where((unit) => unit.id != widget.data.id)
                              .toList();
                          await firestore
                              .collection('StudyMaterials')
                              .doc(getBranch(fullUserId()))
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

Widget subjectContainer(SubjectConverter data) {
  String url = "";
  if (data.units.isNotEmpty)
    url = data.units[random.nextInt(data.units.length)].thumbnailUrl ?? "";
  else if (data.textBooks.isNotEmpty)
    url = data.textBooks[random.nextInt(data.textBooks.length)].thumbnailUrl ??
        "";
  return Center(
    child: Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Container(

                margin: EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(11)),
                child: Stack(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: AspectRatio(
                            aspectRatio: 8.5 / 11,
                            child: url.isNotEmpty &&
                                    (data.units.isNotEmpty ||
                                        data.textBooks.isNotEmpty)
                                ? ImageShowAndDownload(
                                    image: url,
                                    token: esrkr,
                                  )
                                : Container())),
                    Positioned(
                        top: 0,
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Colors.transparent,


                                Colors.black26,
                                Colors.black38,
                                Colors.black54,
                                Colors.black87,
                                Colors.black
                              ],
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              data.heading.short,
                              style: TextStyle(color: Colors.white,fontSize: 25),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
            Text(
              data.heading.full.length <= 15
                  ? data.heading.full
                  : "${data.heading.full.substring(0, 15)}...",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ],
    ),
  );
}

class pdfContainer extends StatefulWidget {
  final FileUploader data;

  pdfContainer({required this.data});

  @override
  State<pdfContainer> createState() => _pdfContainerState();
}

class _pdfContainerState extends State<pdfContainer> {
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

  File pdfFile = File("");

  @override
  Widget build(BuildContext context) {
    if (widget.data.url.isNotEmpty)
      pdfFile = File("${folderPath}/pdfs/${getFileName(widget.data.url)}");
    return InkWell(
      onTap: () async {
        if (pdfFile.existsSync()) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PdfViewerPage(
                      pdfUrl:
                          "${folderPath}/pdfs/${getFileName(widget.data.url)}")));
        } else {
          showToastText("Tap Download Button");
        }
      },
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15)),
                    child: Stack(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: AspectRatio(
                                aspectRatio: 8.5 / 12,
                                child: ImageShowAndDownload(
                                  token: esrkr,
                                  image: widget.data.thumbnailUrl,
                                ))),
                        Positioned(
                            top: 5,
                            right: 5,
                            child: Download(url: widget.data.url)),
                        Positioned(
                            bottom: 5,
                            left: 5,
                            child: Text(
                              widget.data.size,
                              style: TextStyle(fontSize: 15),
                              maxLines: 1,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: SingleChildScrollView(
                  child: Text(
                    widget.data.fileName.split(".").first.replaceAll("-", " "),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                    maxLines: 2,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
