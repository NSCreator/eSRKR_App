// ignore_for_file: use_build_context_synchronously, camel_case_types, non_constant_identifier_names, must_be_immutable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:convert';

import '../SubPages.dart';
import '../TextField.dart';
import '../functions.dart';
import '../net.dart';
import '../test.dart';


class ImageShowAndDownload extends StatefulWidget {
  String  image;
  bool isZoom;

  ImageShowAndDownload(
      {super.key, required this.image,  this.isZoom = false});

  @override
  State<ImageShowAndDownload> createState() => _ImageShowAndDownloadState();
}

class _ImageShowAndDownloadState extends State<ImageShowAndDownload> {
  String filePath = "";

  @override
  void initState() {
    super.initState();
    getPath();
  }

  getPath() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    filePath =
    '${appDir.path}/${Uri.parse(widget.image).pathSegments.last}';
    if (!File(filePath).existsSync()) {
      await _downloadImages(widget.image);
    }
    setState(() {
      filePath;
    });
  }

  _downloadImages(String url) async {
    String name;
    final Uri uri = Uri.parse(url);
    if (url.startsWith('https://drive.google.com')) {
      name = url.split(";").first.split('/d/')[1].split('/')[0];
      url = "https://drive.google.com/uc?export=download&id=$name";
    } else {
      name = uri.pathSegments.last.split("/").last;
    }
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory('${documentDirectory.path}');
    if (!await newDirectory.exists()) {
      await newDirectory.create(recursive: true);
    }
    final file = File('${newDirectory.path}/$name');
    await file.writeAsBytes(response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return widget.isZoom
        ? InkWell(
      child: !File(filePath).existsSync()
          ? SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Image.network(
          widget.image,
          fit: BoxFit.cover,
        ),
      )
          : SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Image.file(
          File(filePath),
          fit: BoxFit.cover,
        ),
      ),
      onTap: () {
        if (widget.isZoom)
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Scaffold(
                      backgroundColor: Colors.black,
                      body: SafeArea(
                        child: Column(
                          children: [
                            backButton(
                              text: "back", child: SizedBox(),
                            ),
                            Expanded(
                              child: Center(
                                child: File(filePath).existsSync()
                                    ? PhotoView(
                                    imageProvider:
                                    FileImage(File(filePath)))
                                    : PhotoView(
                                  imageProvider:
                                  NetworkImage(widget.image),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))));
      },
    )
        : !File(filePath).existsSync()
        ? SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Image.network(
        widget.image,
        fit: BoxFit.cover,
      ),
    )
        : SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Image.file(
        File(filePath),
        fit: BoxFit.cover,
      ),
    );
  }
}

DecorationImage noImageFound = DecorationImage(
    image: AssetImage("assets/app_logo.png"), fit: BoxFit.cover);
DecorationImage ImageNotFoundForTextBooks = DecorationImage(
    image: AssetImage("assets/pdfTextBookIcon.png"), fit: BoxFit.cover);

TextStyle secondTabBarTextStyle(
    {Color color = Colors. black, required double size}) {
  return TextStyle(
    color: Colors. black,
    fontSize:   18,
  );
}

const TextStyle AppBarHeadingTextStyle =
    TextStyle(color: Colors. black, fontSize: 30, fontWeight: FontWeight.w700);
const TextStyle creatorHeadingTextStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors. black);

TextStyle secondHeadingTextStyle(
    {Color color = Colors. black}) {
  return TextStyle(
      color: color, fontSize:   22, fontWeight: FontWeight.w500);
}

class settings extends StatefulWidget {
  final String reg, branch, name;


  const settings({
    Key? key,
    required this.reg,
    required this.name,
    required this.branch,

  }) : super(key: key);

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {

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
  List<RegTimeTableConvertor> RegTimeTable = [];
  Future<void> getData(bool isReload) async {
    try {
      BranchStudyMaterialsConvertor? data =
      await getBranchStudyMaterials(widget.branch, isReload);
      if (data != null) {
        setState(() {
          RegTimeTable = data.regulationAndTimeTable;
        });
      } else {
        print("No data found for the specified branch.");
      }
    } catch (e) {
      print("Error getting subjects: $e");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(true);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.arrow_back),
                    Text(
                      "Back",
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
              ),
              Padding(
                padding:  EdgeInsets.all(15.0),
                child: Text(
                  "My Account",
                  style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height:  70,
                      width:  70,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors. black,
                      ),
                      child: Center(
                          child: Text(
                        picText(""),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize:  30,
                            fontFamily: "test"),
                      )),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.name.replaceAll(";", " ").toUpperCase()}",
                          style: TextStyle(
                              fontSize:  25.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: "test"),
                        ),
                        Text(
                          fullUserId(),
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize:  18,
                              fontFamily: "test"),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${widget.branch} ${widget.reg}",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize:  20,
                            fontFamily: "test")),

                    InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal:  8),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(  20),
                          color: Colors.black38,
                        ),
                        child: Icon(Icons.edit,color: Colors.white,size: 30,),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              // backgroundColor:
                              // Colors.blueGrey.withOpacity(0.6),
                              // shape: RoundedRectangleBorder(
                              //     borderRadius:
                              //     BorderRadius.circular(
                              //           20)),
                              elevation: 20,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors. white,
                                    borderRadius: BorderRadius.circular(
                                        30)),
                                child: ListView.builder(
                                  physics:
                                  const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: RegTimeTable.length,
                                  itemBuilder:
                                      (context, int index) {
                                    final SubjectsData =
                                    RegTimeTable[index];
                                    return Center(
                                      child: Padding(
                                        padding: EdgeInsets
                                            .symmetric(
                                            vertical:
                                            3.0),
                                        child: InkWell(
                                          child: Text(
                                            SubjectsData.regulation
                                                .toUpperCase(),
                                            style: TextStyle(
                                                color: Colors
                                                    .black87,
                                                fontSize:
                                                20,
                                                fontWeight:
                                                FontWeight
                                                    .bold,fontFamily: "test"),
                                          ),
                                          onTap: () {
                                            FirebaseFirestore
                                                .instance
                                                .collection(
                                                "user")
                                                .doc(
                                                fullUserId())
                                                .update({
                                              "reg":
                                              SubjectsData
                                                  .regulation
                                            });
                                            Navigator.pop(
                                                context);

                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 5.0),

              Padding(
                padding:  EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Settings",style: TextStyle(color: Colors.deepOrange.withOpacity(0.9),fontSize:25,fontWeight: FontWeight.w500),),

                    InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical:5),
                        margin: EdgeInsets.only(top: 10,bottom: 2),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.report_problem_outlined,
                                  color: Colors.black87,
                                  size:  25,
                                ),
                                Text(" Report",style: TextStyle(color: Colors.black,fontSize: 25),),
                              ],
                            ),
                            Icon(Icons.chevron_right,size: 25,color: Colors.black54,)
                          ],
                        ),
                      ),
                      onTap: (){
                        sendingMails("sujithnimmala03@gmail.com");
                      },
                    ),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal:  10,vertical:  5),
                        margin: EdgeInsets.symmetric(vertical:  2),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular( 10)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.privacy_tip_outlined,
                                  color: Colors.black87,
                                  size:   25,
                                ),
                                Text(" Privacy Policy",style: TextStyle(color: Colors.black,fontSize:  25),),
                              ],
                            ),
                            Icon(Icons.chevron_right,size:  25,color: Colors.black54,)
                          ],
                        ),
                      ),
                      onTap: (){
                        ExternalLaunchUrl(
                            "https://github.com/NSCreator/PRIVACY_POLACY/blob/main/Privacy-policy");

                      },
                    ),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal:  10,vertical:  5),
                        margin: EdgeInsets.symmetric(vertical:  2),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular( 10)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.read_more,
                                  color: Colors.black87,
                                  size:   25,
                                ),
                                Text(" About",style: TextStyle(color: Colors.black,fontSize:  25),),
                              ],
                            ),
                            Icon(Icons.chevron_right,size:  25,color: Colors.black54,)
                          ],
                        ),
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const about()));

                                      },
                    ),
                  ],
                ),
              ),

                Padding(
                  padding:  EdgeInsets.all( 8.0),
                  child: Column(
                    children: [
                      // Container(
                      //   padding: EdgeInsets.symmetric(vertical:  5, horizontal:  8),
                      //   decoration: BoxDecoration(
                      //       color: Colors.black,
                      //       borderRadius: BorderRadius.circular( 20)),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       InkWell(
                      //         child: Container(
                      //           padding: EdgeInsets.symmetric(
                      //               horizontal:  10, vertical:  5),
                      //           margin:
                      //           EdgeInsets.only(bottom:  5, left:  2, top:  10),
                      //           decoration: BoxDecoration(
                      //               color: Colors. black12,
                      //               borderRadius: BorderRadius.circular( 10)),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               Row(
                      //                 children: [
                      //                   Icon(
                      //                     Icons.add_box_outlined,
                      //                     color: Colors.  black87,
                      //                     size:   25,
                      //                   ),
                      //                   Text(
                      //                     " Create Events",
                      //                     style: TextStyle(
                      //                         color: Colors. black, fontSize:  25),
                      //                   ),
                      //                 ],
                      //               ),
                      //               Icon(
                      //                 Icons.chevron_right,
                      //                 size:  25,
                      //                 color: Colors. black54,
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //         onTap: () {
                      //           Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) => addEvent(
                      //
                      //                     branch: widget.branch,
                      //                   )));
                      //         },
                      //       ),
                      //       InkWell(
                      //         child: Container(
                      //           padding: EdgeInsets.symmetric(
                      //               horizontal:  10, vertical:  5),
                      //           margin:
                      //           EdgeInsets.only(bottom:  5, left:  2, top:  10),
                      //           decoration: BoxDecoration(
                      //               color: Colors. black12,
                      //               borderRadius: BorderRadius.circular( 10)),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               Row(
                      //                 children: [
                      //                   Icon(
                      //                     Icons.add_box_outlined,
                      //                     color: Colors.  black87,
                      //                     size:   25,
                      //                   ),
                      //                   Text(
                      //                     " Create Regulation by R2_",
                      //                     style: TextStyle(
                      //                         color: Colors. black, fontSize:  25),
                      //                   ),
                      //                 ],
                      //               ),
                      //               Icon(
                      //                 Icons.chevron_right,
                      //                 size:  25,
                      //                 color: Colors. black54,
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //         onTap: () {
                      //           Navigator.push(context, MaterialPageRoute(builder: (context)=>RegSylMP( branch: widget.branch,)));
                      //
                      //         },
                      //       ),
                      //       Text(
                      //         "Create News",
                      //         style: TextStyle(
                      //             color: Colors.orangeAccent, fontSize:  25),
                      //       ),
                      //       Row(
                      //         children: [
                      //           Flexible(
                      //             child: InkWell(
                      //               child: Container(
                      //                 padding: EdgeInsets.symmetric(
                      //                     horizontal:  10, vertical:  5),
                      //                 margin: EdgeInsets.only(
                      //                     bottom:  5, right:  2, top:  10),
                      //                 decoration: BoxDecoration(
                      //                     color: Colors. black12,
                      //                     borderRadius: BorderRadius.circular( 10)),
                      //                 child: Row(
                      //                   mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //                   children: [
                      //                     Expanded(
                      //                       child: Row(
                      //                         children: [
                      //                           Icon(
                      //                             Icons.add_box_outlined,
                      //                             color: Colors.  black87,
                      //                             size:   25,
                      //                           ),
                      //                           Expanded(
                      //                             child: Text(" Flash News",
                      //                                 style: TextStyle(
                      //                                     color: Colors. black,
                      //                                     fontSize:  25),
                      //                                 maxLines: 1),
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ),
                      //                     Icon(
                      //                       Icons.chevron_right,
                      //                       size:  25,
                      //                       color: Colors. black54,
                      //                     )
                      //                   ],
                      //                 ),
                      //               ),
                      //               onTap: () {
                      //                 Navigator.push(
                      //                     context,
                      //                     MaterialPageRoute(
                      //                         builder: (context) =>
                      //                             flashNewsCreator(
                      //                               branch: widget.branch,
                      //
                      //                             )));
                      //               },
                      //             ),
                      //           ),
                      //           Flexible(
                      //             child: InkWell(
                      //               child: Container(
                      //                 padding: EdgeInsets.symmetric(
                      //                     horizontal:  10, vertical:  5),
                      //                 margin: EdgeInsets.only(
                      //                     bottom:  5, left:  2, top:  10),
                      //                 decoration: BoxDecoration(
                      //                     color: Colors. black12,
                      //                     borderRadius: BorderRadius.circular( 10)),
                      //                 child: Row(
                      //                   mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //                   children: [
                      //                     Row(
                      //                       children: [
                      //                         Icon(
                      //                           Icons.add_box_outlined,
                      //                           color: Colors.  black87,
                      //                           size:   25,
                      //                         ),
                      //                         Text(
                      //                           " News",
                      //                           style: TextStyle(
                      //                               color: Colors. black,
                      //                               fontSize:  25),
                      //                         ),
                      //                       ],
                      //                     ),
                      //                     Icon(
                      //                       Icons.chevron_right,
                      //                       size:  25,
                      //                       color: Colors. black54,
                      //                     )
                      //                   ],
                      //                 ),
                      //               ),
                      //               onTap: () {
                      //                 Navigator.push(
                      //                     context,
                      //                     MaterialPageRoute(
                      //                         builder: (context) => updateCreator(
                      //                           branch: widget.branch,
                      //
                      //                         )));
                      //               },
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical:  5, horizontal:  8),
                        margin: EdgeInsets.symmetric(vertical:  10),

                        decoration: BoxDecoration(
                            color: Colors. black12,
                            borderRadius: BorderRadius.circular( 20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Create Materials",
                              style: TextStyle(
                                  color: Colors.orangeAccent, fontSize:  25),
                            ),

                            InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:  10, vertical:  5),
                                margin: EdgeInsets.only(bottom:  5),
                                decoration: BoxDecoration(
                                    color: Colors. black12,
                                    borderRadius: BorderRadius.circular( 10)),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.add_box_outlined,
                                          color: Colors.  black87,
                                          size:   25,
                                        ),
                                        Text(
                                          " Books",
                                          style: TextStyle(
                                              color: Colors. black, fontSize:  25),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size:  25,
                                      color: Colors. black54,
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BooksCreator(
                                          branch: widget.branch,
                                        )));
                              },
                            ),
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:  10, vertical:  5),
                                margin: EdgeInsets.only(bottom:  5),
                                decoration: BoxDecoration(
                                    color: Colors. black12,
                                    borderRadius: BorderRadius.circular( 10)),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.add_box_outlined,
                                          color: Colors.  black87,
                                          size:   25,
                                        ),
                                        Text(
                                          "Subjects",
                                          style: TextStyle(
                                              color: Colors. black, fontSize:  25),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size:  25,
                                      color: Colors. black54,
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SubjectCreator(
                                          branch: widget.branch,
                                        )));
                              },
                            ),
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:  10, vertical:  5),
                                margin: EdgeInsets.only(bottom:  5),
                                decoration: BoxDecoration(
                                    color: Colors. black12,
                                    borderRadius: BorderRadius.circular( 10)),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.add_box_outlined,
                                          color: Colors.  black87,
                                          size:   25,
                                        ),
                                        Text(
                                          "Lab Subjects",
                                          style: TextStyle(
                                              color: Colors. black, fontSize:  25),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size:  25,
                                      color: Colors. black54,
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SubjectCreator(
                                          branch: widget.branch,   isSub: false,
                                        )));
                              },
                            ),
                          ],
                        ),
                      ),

                      // Container(
                      //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      //   margin: EdgeInsets.symmetric(vertical: 10),
                      //
                      //   decoration: BoxDecoration(
                      //       color: Colors.black,
                      //       borderRadius: BorderRadius.circular(20)),
                      //   child: Column(
                      //     children: [
                      //       InkWell(
                      //         child: Container(
                      //           padding: EdgeInsets.symmetric(
                      //               horizontal: 10, vertical: 5),
                      //           margin:
                      //           EdgeInsets.only(bottom: 5, right: 2, top: 10),
                      //           decoration: BoxDecoration(
                      //               color: Colors. black12,
                      //               borderRadius: BorderRadius.circular(10)),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               Row(
                      //                 children: [
                      //                   Icon(
                      //                     Icons.add_box_outlined,
                      //                     color: Colors. black54,
                      //                     size:   25,
                      //                   ),
                      //                   Text(
                      //                     " Time Table",
                      //                     style: TextStyle(
                      //                         color: Colors. black, fontSize: 25),
                      //                   ),
                      //                 ],
                      //               ),
                      //               Icon(
                      //                 Icons.chevron_right,
                      //                 size: 25,
                      //                 color: Colors. black54,
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //         onTap: () {
                      //           Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) =>
                      //                       timeTableSyllabusModalPaperCreator(
                      //
                      //                         mode: 'Time Table',
                      //                         reg: widget.reg,
                      //                         branch: widget.branch,
                      //                       )));
                      //         },
                      //       ),
                      //       InkWell(
                      //         child: Container(
                      //           padding: EdgeInsets.symmetric(
                      //               horizontal: 10, vertical: 5),
                      //           margin:
                      //           EdgeInsets.only(bottom: 5, right: 2, top: 10),
                      //           decoration: BoxDecoration(
                      //               color: Colors. black12,
                      //               borderRadius: BorderRadius.circular(10)),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               Row(
                      //                 children: [
                      //                   Icon(
                      //                     Icons.add_box_outlined,
                      //                     color: Colors. black54,
                      //                     size:   25,
                      //                   ),
                      //                   Text(
                      //                     " Syllabus",
                      //                     style: TextStyle(
                      //                         color: Colors. black, fontSize: 25),
                      //                   ),
                      //                 ],
                      //               ),
                      //               Icon(
                      //                 Icons.chevron_right,
                      //                 size: 25,
                      //                 color: Colors. black54,
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //         onTap: () {
                      //           if (widget.reg.isNotEmpty && widget.reg != "None")
                      //             Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                     builder: (context) =>
                      //                         timeTableSyllabusModalPaperCreator(
                      //                           heading: widget.reg,
                      //
                      //                           mode: 'Syllabus',
                      //                           reg: widget.reg,
                      //                           branch: widget.branch,
                      //                           id: widget.reg,
                      //                         )));
                      //           else {
                      //             showToastText("Select Your Regulation");
                      //           }
                      //         },
                      //       ),
                      //       InkWell(
                      //         child: Container(
                      //           padding: EdgeInsets.symmetric(
                      //               horizontal: 10, vertical: 5),
                      //           margin:
                      //           EdgeInsets.only(bottom: 5, left: 2, top: 10),
                      //           decoration: BoxDecoration(
                      //               color: Colors. black12,
                      //               borderRadius: BorderRadius.circular(10)),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               Row(
                      //                 children: [
                      //                   Icon(
                      //                     Icons.add_box_outlined,
                      //                     color: Colors. black54,
                      //                     size:   25,
                      //                   ),
                      //                   Text(
                      //                     " Model Paper",
                      //                     style: TextStyle(
                      //                         color: Colors. black,
                      //                         fontSize:   22),
                      //                   ),
                      //                 ],
                      //               ),
                      //               Icon(
                      //                 Icons.chevron_right,
                      //                 size: 25,
                      //                 color: Colors. black54,
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //         onTap: () {
                      //           if (widget.reg.isNotEmpty && widget.reg != "None")
                      //             Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                     builder: (context) =>
                      //                         timeTableSyllabusModalPaperCreator(
                      //                           heading: widget.reg,
                      //
                      //                           mode: 'modalPaper',
                      //                           reg: widget.reg,
                      //                           branch: widget.branch,
                      //                           id: widget.reg,
                      //                         )));
                      //           else {
                      //             showToastText("Select Your Regulation");
                      //           }
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // )

                    ],
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
                                padding: EdgeInsets.all(  8.0),
                                child: Text(
                                  "Nothing To Follow",
                                  style: TextStyle(
                                    color: Color.fromRGBO(195, 228, 250, 1),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left:   10,
                                      top:   20,
                                      bottom:   8),
                                  child: Text(
                                    "Follow Us",
                                    style: TextStyle(
                                      fontSize:   20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(  8.0),
                                  child: Container(
                                    constraints: BoxConstraints(maxHeight: 50),
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: Books.length,
                                      itemBuilder:
                                          (BuildContext context, int index) =>
                                              InkWell(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left:   5,
                                              bottom:   10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                    15),
                                              color: Colors.white,
                                              // border: Border.all(color: Colors. black),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                              15),
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        Books[index].photoUrl,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  height:   35,
                                                  width:   50,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(
                                                        5.0),
                                                  child: Text(
                                                    Books[index].name,
                                                    style: TextStyle(
                                                        fontSize:   20,
                                                        color: Colors. black,fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          if (Books[index].name == "Gmail") {
                                            sendingMails(Books[index].link);
                                          } else {
                                            if (Books[index].link.isNotEmpty)
                                              ExternalLaunchUrl(Books[index].link);
                                            else
                                              showToastText(
                                                  "No ${Books[index].name} Link");
                                          }
                                        },
                                      ),
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                        width:   9,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        }
                    }
                  }),

              SizedBox(
                height:   30,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical:  10),
                decoration: BoxDecoration(color: Colors.black12),
                child: Column(
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(bottom:  10.0,left:  30,right:  30),
                      child: InkWell(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical:  5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                              borderRadius: BorderRadius.circular(  10),
                              border: Border.all(color: Colors.black26)),
                          child: Center(
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize:   22,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(  20)),
                                elevation: 16,
                                child: Container(
                                  decoration: BoxDecoration(

                                    borderRadius:
                                        BorderRadius.circular(  20),
                                  ),
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      SizedBox(height:   15),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left:   15),
                                        child: Text(
                                          "Do you want Log Out",
                                          style: TextStyle(
                                              color: Colors. black,
                                              fontWeight: FontWeight.w600,
                                              fontSize:   18),
                                        ),
                                      ),
                                      SizedBox(
                                        height:   5,
                                      ),
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Spacer(),
                                            InkWell(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black26,

                                                  borderRadius:
                                                      BorderRadius.circular(
                                                            25),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:   15,
                                                      vertical:   5),
                                                  child: Text(
                                                    "Back",
                                                    style: TextStyle(
                                                        color: Colors. black,
                                                        fontSize:   14),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            SizedBox(
                                              width:   10,
                                            ),
                                            InkWell(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.red,

                                                  borderRadius:
                                                      BorderRadius.circular(
                                                            25),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:   15,
                                                      vertical:   5),
                                                  child: Text(
                                                    "Log Out",
                                                    style: TextStyle(
                                                        color: Colors. black,
                                                        fontSize:   14),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                FirebaseAuth.instance.signOut();
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            SizedBox(
                                              width:   20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height:   10,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "eSRKR",
                          style: TextStyle(
                              color: Colors.white   , fontSize:   14),
                        ),
                        Text(
                          "v2023.12.31",
                          style: TextStyle(
                            fontSize:   9.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "from NS",
                          style: TextStyle(
                              color: Colors.white, fontSize:   14),
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
    );
  }
}
class HomePageImagesConvertor {
  String id;
  final String image;

  HomePageImagesConvertor({
    this.id = "",
    required this.image,
  });

  static HomePageImagesConvertor fromJson(Map<String, dynamic> json) =>
      HomePageImagesConvertor(
        id: json['id'],
        image: json["image"],
      );
}

Stream<List<HomePageImagesConvertor>> readHomePageImagesConvertor() =>
    FirebaseFirestore.instance.collection("HomePageImages").snapshots().map(
            (snapshot) => snapshot.docs
            .map((doc) => HomePageImagesConvertor.fromJson(doc.data()))
            .toList());

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
                    border: Border.all(color: Colors. black),
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
                              color: Colors. black87),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 3, bottom: 3),
                          child: Text(
                            about.description,
                            style: TextStyle(color: Colors. black38),
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
