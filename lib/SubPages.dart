// ignore_for_file: camel_case_types, non_constant_identifier_names, must_be_immutable
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
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

import 'main.dart';
import 'notification.dart';

// class favorites extends StatefulWidget {
//   double size;
//
//   favorites({required this.size});
//
//   @override
//   State<favorites> createState() => _favoritesState();
// }
//
// class _favoritesState extends State<favorites> {
//   @override
//   Widget build(BuildContext context) {
//     double Size = size(context);
//
//     return backgroundcolor(
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 backButton(size: Size, text: "Favorites", child: SizedBox()),
//                 Padding(
//                   padding:  EdgeInsets.symmetric(vertical: Size*20.0),
//                   child: StreamBuilder<List<FavouriteSubjectsConvertor>>(
//                     stream: readFavouriteSubjects(),
//                     builder: (context, snapshot1) {
//                       final favourites1 = snapshot1.data;
//
//                       return StreamBuilder<List<FavouriteSubjectsConvertor>>(
//                         stream: readFavouriteLabSubjects(),
//                         builder: (context, snapshot2) {
//                           final favourites2 = snapshot2.data;
//
//                           if (snapshot1.connectionState ==
//                                   ConnectionState.waiting ||
//                               snapshot2.connectionState ==
//                                   ConnectionState.waiting) {
//                             return const Center(
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 0.3,
//                                 color: Colors.cyan,
//                               ),
//                             );
//                           } else if (snapshot1.hasError || snapshot2.hasError) {
//                             return Center(child: Text("Error"));
//                           } else if ((favourites1 != null &&
//                                   favourites1.isNotEmpty) ||
//                               (favourites2 != null && favourites2.isNotEmpty)) {
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ListView.separated(
//                                     itemCount: favourites1!.length,
//                                     shrinkWrap: true,
//                                     itemBuilder: (context, int index) {
//                                       final Favourite = favourites1[index];
//                                       return InkWell(
//                                         child: Padding(
//                                           padding:  EdgeInsets.symmetric(
//                                               horizontal:  Size*10.0),
//                                           child: Row(
//                                             children: [
//                                               Expanded(
//                                                 flex: 1,
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                       color: Colors.white24,
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               Size*50)),
//                                                   child: Padding(
//                                                     padding:  EdgeInsets
//                                                         .symmetric(
//                                                         vertical:  Size*8.0),
//                                                     child: Center(
//                                                         child: Text(
//                                                       Favourite.name
//                                                           .split(";")
//                                                           .first,
//                                                       style: TextStyle(
//                                                           color: Colors.white,
//                                                           fontFamily: "test",
//                                                           fontSize:  Size*20),
//                                                     )),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 5,
//                                                 child: Padding(
//                                                   padding:  EdgeInsets
//                                                       .symmetric(
//                                                       horizontal: Size* 5.0),
//                                                   child: Text(
//                                                     Favourite.name
//                                                         .split(";")
//                                                         .last,
//                                                     style: TextStyle(
//                                                         color: Colors.white,
//                                                         fontSize: Size* 20),
//                                                   ),
//                                                 ),
//                                               ),
//                                               InkWell(
//                                                 child: Icon(
//                                                   Icons
//                                                       .highlight_remove_outlined,
//                                                   color: Colors.orange,
//                                                   size: widget.size * 25,
//                                                 ),
//                                                 onTap: () {
//                                                   showDialog(
//                                                     context: context,
//                                                     builder: (context) {
//                                                       return Dialog(
//                                                         backgroundColor:
//                                                             Colors.transparent,
//                                                         shape: RoundedRectangleBorder(
//                                                             borderRadius: BorderRadius
//                                                                 .circular(widget
//                                                                         .size *
//                                                                     20)),
//                                                         elevation: 16,
//                                                         child: Container(
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             border: Border.all(
//                                                                 color: Colors
//                                                                     .white54),
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         widget.size *
//                                                                             20),
//                                                           ),
//                                                           child: ListView(
//                                                             shrinkWrap: true,
//                                                             children: <Widget>[
//                                                               SizedBox(
//                                                                   height: widget
//                                                                           .size *
//                                                                       10),
//                                                               SizedBox(
//                                                                   height: widget
//                                                                           .size *
//                                                                       5),
//                                                               Padding(
//                                                                 padding: EdgeInsets.only(
//                                                                     left: widget
//                                                                             .size *
//                                                                         15),
//                                                                 child: Text(
//                                                                   "Do you want Remove from Favourites",
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .white,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w600,
//                                                                       fontSize:
//                                                                           widget.size *
//                                                                               20),
//                                                                 ),
//                                                               ),
//                                                               SizedBox(
//                                                                 height: widget
//                                                                         .size *
//                                                                     5,
//                                                               ),
//                                                               Center(
//                                                                 child: Row(
//                                                                   mainAxisAlignment:
//                                                                       MainAxisAlignment
//                                                                           .center,
//                                                                   crossAxisAlignment:
//                                                                       CrossAxisAlignment
//                                                                           .center,
//                                                                   children: [
//                                                                     Spacer(),
//                                                                     InkWell(
//                                                                       child:
//                                                                           Container(
//                                                                         decoration:
//                                                                             BoxDecoration(
//                                                                           color:
//                                                                               Colors.white24,
//                                                                           border:
//                                                                               Border.all(color: Colors.white10),
//                                                                           borderRadius:
//                                                                               BorderRadius.circular(widget.size * 25),
//                                                                         ),
//                                                                         child:
//                                                                             Padding(
//                                                                           padding: EdgeInsets.only(
//                                                                               left: widget.size * 15,
//                                                                               right: widget.size * 15,
//                                                                               top: widget.size * 5,
//                                                                               bottom: widget.size * 5),
//                                                                           child:
//                                                                               Text(
//                                                                             "Back",
//                                                                             style:
//                                                                                 TextStyle(
//                                                                               color: Colors.white,
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                       onTap:
//                                                                           () {
//                                                                         Navigator.pop(
//                                                                             context);
//                                                                       },
//                                                                     ),
//                                                                     SizedBox(
//                                                                       width:
//                                                                           widget.size *
//                                                                               10,
//                                                                     ),
//                                                                     InkWell(
//                                                                       child:
//                                                                           Container(
//                                                                         decoration:
//                                                                             BoxDecoration(
//                                                                           color:
//                                                                               Colors.red,
//                                                                           border:
//                                                                               Border.all(color: Colors.black),
//                                                                           borderRadius:
//                                                                               BorderRadius.circular(widget.size * 25),
//                                                                         ),
//                                                                         child:
//                                                                             Padding(
//                                                                           padding: EdgeInsets.only(
//                                                                               left: widget.size * 15,
//                                                                               right: widget.size * 15,
//                                                                               top: widget.size * 5,
//                                                                               bottom: widget.size * 5),
//                                                                           child:
//                                                                               Text(
//                                                                             "Delete",
//                                                                             style:
//                                                                                 TextStyle(color: Colors.white),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                       onTap:
//                                                                           () {
//                                                                         FirebaseFirestore
//                                                                             .instance
//                                                                             .collection('user')
//                                                                             .doc(FirebaseAuth.instance.currentUser!.email!)
//                                                                             .collection("FavouriteSubject")
//                                                                             .doc(Favourite.id)
//                                                                             .delete();
//                                                                         Navigator.pop(
//                                                                             context);
//                                                                         showToastText(
//                                                                             "${Favourite.name} as been removed");
//                                                                       },
//                                                                     ),
//                                                                     SizedBox(
//                                                                       width:
//                                                                           widget.size *
//                                                                               20,
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                               SizedBox(
//                                                                 height: widget
//                                                                         .size *
//                                                                     10,
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       );
//                                                     },
//                                                   );
//                                                 },
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         onTap: () {
//                                           Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       subjectUnitsData(
//                                                         creator:
//                                                             Favourite.creator,
//                                                         reg: Favourite
//                                                             .regulation,
//                                                         size: widget.size,
//                                                         branch:
//                                                             Favourite.branch,
//                                                         ID: Favourite.id,
//                                                         mode: "Subjects",
//                                                         name: Favourite.name,
//                                                         description: Favourite
//                                                             .description,
//                                                       )));
//                                         },
//                                       );
//                                     },
//                                     separatorBuilder: (context, index) =>
//                                         SizedBox(
//                                           height: widget.size * 6,
//                                         )),
//                                 ListView.separated(
//                                     padding: EdgeInsets.symmetric(vertical:  Size*10),
//                                     itemCount: favourites2!.length,
//                                     shrinkWrap: true,
//                                     itemBuilder: (context, int index) {
//                                       final Favourite = favourites2[index];
//                                       return InkWell(
//                                         child: Padding(
//                                           padding:  EdgeInsets.symmetric(
//                                               horizontal: Size* 10.0),
//                                           child: Row(
//                                             children: [
//                                               Expanded(
//                                                 flex: 1,
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                       color: Colors.white24,
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               Size*50)),
//                                                   child: Padding(
//                                                     padding:  EdgeInsets
//                                                         .symmetric(
//                                                         vertical:  Size*8.0),
//                                                     child: Center(
//                                                         child: Text(
//                                                       Favourite.name
//                                                           .split(";")
//                                                           .first,
//                                                       style: TextStyle(
//                                                           color: Colors.white,
//                                                           fontFamily: "test",
//                                                           fontSize:  Size*20),
//                                                     )),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 5,
//                                                 child: Padding(
//                                                   padding:  EdgeInsets
//                                                       .symmetric(
//                                                       horizontal:  Size*5.0),
//                                                   child: Text(
//                                                     Favourite.name
//                                                         .split(";")
//                                                         .last,
//                                                     style: TextStyle(
//                                                         color: Colors.white,
//                                                         fontSize:  Size*20),
//                                                   ),
//                                                 ),
//                                               ),
//                                               InkWell(
//                                                 child: Icon(
//                                                   Icons
//                                                       .highlight_remove_outlined,
//                                                   color: Colors.orange,
//                                                   size: widget.size * 25,
//                                                 ),
//                                                 onTap: () {
//                                                   showDialog(
//                                                     context: context,
//                                                     builder: (context) {
//                                                       return Dialog(
//                                                         backgroundColor:
//                                                             Colors.transparent,
//                                                         shape: RoundedRectangleBorder(
//                                                             borderRadius: BorderRadius
//                                                                 .circular(widget
//                                                                         .size *
//                                                                     20)),
//                                                         elevation: 16,
//                                                         child: Container(
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             border: Border.all(
//                                                                 color: Colors
//                                                                     .white54),
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         widget.size *
//                                                                             20),
//                                                           ),
//                                                           child: ListView(
//                                                             shrinkWrap: true,
//                                                             children: <Widget>[
//                                                               SizedBox(
//                                                                   height: widget
//                                                                           .size *
//                                                                       10),
//                                                               SizedBox(
//                                                                   height: widget
//                                                                           .size *
//                                                                       5),
//                                                               Padding(
//                                                                 padding: EdgeInsets.only(
//                                                                     left: widget
//                                                                             .size *
//                                                                         15),
//                                                                 child: Text(
//                                                                   "Do you want Remove from Favourites",
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .white,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w600,
//                                                                       fontSize:
//                                                                           widget.size *
//                                                                               20),
//                                                                 ),
//                                                               ),
//                                                               SizedBox(
//                                                                 height: widget
//                                                                         .size *
//                                                                     5,
//                                                               ),
//                                                               Center(
//                                                                 child: Row(
//                                                                   mainAxisAlignment:
//                                                                       MainAxisAlignment
//                                                                           .center,
//                                                                   crossAxisAlignment:
//                                                                       CrossAxisAlignment
//                                                                           .center,
//                                                                   children: [
//                                                                     Spacer(),
//                                                                     InkWell(
//                                                                       child:
//                                                                           Container(
//                                                                         decoration:
//                                                                             BoxDecoration(
//                                                                           color:
//                                                                               Colors.white24,
//                                                                           border:
//                                                                               Border.all(color: Colors.white10),
//                                                                           borderRadius:
//                                                                               BorderRadius.circular(widget.size * 25),
//                                                                         ),
//                                                                         child:
//                                                                             Padding(
//                                                                           padding: EdgeInsets.only(
//                                                                               left: widget.size * 15,
//                                                                               right: widget.size * 15,
//                                                                               top: widget.size * 5,
//                                                                               bottom: widget.size * 5),
//                                                                           child:
//                                                                               Text(
//                                                                             "Back",
//                                                                             style:
//                                                                                 TextStyle(
//                                                                               color: Colors.white,
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                       onTap:
//                                                                           () {
//                                                                         Navigator.pop(
//                                                                             context);
//                                                                       },
//                                                                     ),
//                                                                     SizedBox(
//                                                                       width:
//                                                                           widget.size *
//                                                                               10,
//                                                                     ),
//                                                                     InkWell(
//                                                                       child:
//                                                                           Container(
//                                                                         decoration:
//                                                                             BoxDecoration(
//                                                                           color:
//                                                                               Colors.red,
//                                                                           border:
//                                                                               Border.all(color: Colors.black),
//                                                                           borderRadius:
//                                                                               BorderRadius.circular(widget.size * 25),
//                                                                         ),
//                                                                         child:
//                                                                             Padding(
//                                                                           padding: EdgeInsets.only(
//                                                                               left: widget.size * 15,
//                                                                               right: widget.size * 15,
//                                                                               top: widget.size * 5,
//                                                                               bottom: widget.size * 5),
//                                                                           child:
//                                                                               Text(
//                                                                             "Delete",
//                                                                             style:
//                                                                                 TextStyle(color: Colors.white),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                       onTap:
//                                                                           () {
//                                                                         FirebaseFirestore
//                                                                             .instance
//                                                                             .collection('user')
//                                                                             .doc(FirebaseAuth.instance.currentUser!.email!)
//                                                                             .collection("FavouriteLabSubjects")
//                                                                             .doc(Favourite.id)
//                                                                             .delete();
//
//                                                                         Navigator.pop(
//                                                                             context);
//                                                                         showToastText(
//                                                                             "${Favourite.name} as been removed");
//                                                                       },
//                                                                     ),
//                                                                     SizedBox(
//                                                                       width:
//                                                                           widget.size *
//                                                                               20,
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                               SizedBox(
//                                                                 height: widget
//                                                                         .size *
//                                                                     10,
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       );
//                                                     },
//                                                   );
//                                                 },
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         onTap: () {
//                                           Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       subjectUnitsData(
//                                                         reg: Favourite.name,
//                                                         size: widget.size,
//                                                         branch:
//                                                             Favourite.branch,
//                                                         ID: Favourite.id,
//                                                         mode: "LabSubjects",
//                                                         name: Favourite.name,
//                                                         description: Favourite
//                                                             .description,
//                                                         creator:
//                                                             Favourite.creator,
//                                                       )));
//                                         },
//                                       );
//                                     },
//                                     separatorBuilder: (context, index) =>
//                                         SizedBox(
//                                           width: widget.size * 6,
//                                         )),
//                               ],
//                             );
//                           } else {
//                             return Container(); // No data, don't show anything
//                           }
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    return backgroundcolor(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  backButton(
                      size: widget.size,
                      text: "Time Tables",
                      child: isGmail() || isOwner()
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
                              width: widget.size * 45,
                            )),
                  StreamBuilder<List<TimeTableConvertor>>(
                      stream:
                          readTimeTable(branch: widget.branch, reg: widget.reg),
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

                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              flex: 3,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        widget.size * 30),
                                                child: AspectRatio(
                                                  aspectRatio: 16 / 9,
                                                  child: ImageShowAndDownload(
                                                    image: data.photoUrl,
                                                    isZoom: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                                flex: 2,
                                                child: Center(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        widget.reg,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize:
                                                                widget.size *
                                                                    15),
                                                      ),
                                                      Text(
                                                        data.heading,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize:
                                                                widget.size *
                                                                    30),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                            }
                        }
                      }),
                ],
              ),
            ),
          )),
    );
  }
}

class Subjects extends StatefulWidget {
  final String branch;
  List<syllabusConvertor> syllabusModelPaper;
  final String reg;
  final double size;
  final double height;
  final double width;

  Subjects(
      {Key? key,
      required this.branch,
      required this.syllabusModelPaper,
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: widget.size * 3, horizontal: widget.size * 8),
                  margin: EdgeInsets.symmetric(
                      vertical: widget.size * 8, horizontal: widget.size * 8),
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(widget.size * 8)),
                  child: Row(
                    children: [
                      Text(
                        "Filter ",
                        style: TextStyle(
                            color: Colors.white, fontSize: widget.size * 20),
                      ),
                      Icon(
                        Icons.filter_list,
                        color: Colors.white,
                        size: widget.size * 20,
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
          StreamBuilder<List<subjectConvertor>>(
              stream: readSubject(widget.branch),
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
                      List<subjectConvertor> filteredItems = user!
                          .where((item) => item.regulation.any((reg) => reg
                              .toString()
                              .toLowerCase()
                              .startsWith(widget.reg.substring(0, 2))))
                          .toList();

                      return Column(
                        children: [
                          if (filteredItems.isNotEmpty &&
                              subjectFilter == "Regulation")
                            Padding(
                              padding: EdgeInsets.all(widget.size * 8.0),
                              child: Text(
                                "Based On Your Regulation",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.size * 25,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          if (filteredItems.isNotEmpty &&
                              subjectFilter == "Regulation")
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: user.length,
                              itemBuilder: (context, int index) {
                                final SubjectsData = user[index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: widget.width * 10,
                                      vertical: widget.height * 1),
                                  child: InkWell(
                                    child: subjectsContainer(
                                      data: SubjectsData,
                                      branch: widget.branch,
                                      isSub: true, syllabusModelPaper: widget.syllabusModelPaper,
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
                                            size: widget.size,
                                            branch: widget.branch,
                                            mode: true,
                                            data: SubjectsData,
                                                syllabusModelPaper: widget.syllabusModelPaper, reg: widget.reg,
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
                          if (filteredItems.isNotEmpty &&
                              subjectFilter == "Regulation")
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: widget.size * 10),
                              child: Text(
                                "All Subjects",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.size * 25,
                                    fontWeight: FontWeight.w500),
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
                                  child: subjectsContainer(
                                    syllabusModelPaper: widget.syllabusModelPaper,
                                    data: SubjectsData,
                                    branch: widget.branch,
                                    isSub: true,
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
                                              reg: widget.reg,
                                              syllabusModelPaper: widget.syllabusModelPaper,
                                          size: widget.size,
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
          SizedBox(
            height: widget.size * 50,
          )
        ],
      ),
    );
  }
}

class subjectsContainer extends StatefulWidget {
  subjectConvertor data;
  List<syllabusConvertor> syllabusModelPaper;
  String branch;
  bool isSub;

  subjectsContainer(
      {required this.data, required this.syllabusModelPaper,required this.branch, required this.isSub});

  @override
  State<subjectsContainer> createState() => _subjectsContainerState();
}

class _subjectsContainerState extends State<subjectsContainer> {
  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: widget.data.createdByAndPermissions.id == fullUserId()
              ? Colors.lightBlueAccent.withOpacity(0.2)
              : Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.all(Radius.circular(Size * 20))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: Size * 3, horizontal: Size * 3),
                padding: EdgeInsets.symmetric(vertical: Size * 6,horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius:
                        BorderRadius.all(
                            Radius.circular(Size * 20)
                        )
                ),
                child: Text(
                  widget.data.heading.short,
                  style: TextStyle(
                    fontSize: Size * 25.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.heading.full,
                      style: TextStyle(
                        fontSize: Size * 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    if (
                        widget.data.createdByAndPermissions.id.isNotEmpty)
                      Text(
                        "By ${widget.data.createdByAndPermissions.id.split("@").first}",
                        style: TextStyle(
                          fontSize: Size * 12.0,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        maxLines: 1,
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(Size * 8.0),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(Size * 20)),
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
                                    // FavouriteSubjects(
                                    //   id: widget.data.id,
                                    //   branch: widget.branch,
                                    //   regulation: widget.data.regulation,
                                    //   name: widget.data.heading,
                                    //   description: widget.data.description,
                                    //   creator: widget.data.creator,
                                    // );
                                    // showToastText(
                                    //     "${widget.data.heading} in favorites");
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
                                        Icon(Icons.library_add_check,
                                            size: Size * 23,
                                            color: Colors.cyanAccent),
                                        Text(
                                          " Saved",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Size * 20),
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
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Size * 20),
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
                                    showToastText(
                                        "Removed from saved list");
                                  } else {
                                    // FavouriteLabSubjectsSubjects(
                                    //   id: widget.data.id,
                                    //   regulation: widget.data.regulation,
                                    //   branch: widget.branch,
                                    //   name: widget.data.heading,
                                    //   description: widget.data.description,
                                    //   creator: widget.data.creator,
                                    // );
                                    // showToastText(
                                    //     "${widget.data.heading} in favorites");
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

                  downloadAllPdfs(
                    branch: widget.branch,
                    SubjectID: widget.data.id,
                    mode: "LabSubjects",
                    size: Size * 0.65,
                  ),
                  if (widget.isSub &&
                      (widget.data.createdByAndPermissions.id ==
                          fullUserId() ||
                          isOwner()))
                    PopupMenuButton(
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: Size * 25,
                      ),

                      onSelected: (item) {
                        if (item == "edit") {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                              const Duration(milliseconds: 300),
                              pageBuilder: (context, animation,
                                  secondaryAnimation) =>
                                  SubjectCreator(
                                    data: widget.data,
                                    size: Size,
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
                                      duration: Duration(milliseconds: 300),
                                      opacity:
                                      animation.value.clamp(0.3, 1.0),
                                      child: fadeTransition),
                                );
                              },
                            ),
                          );
                        } else if (item == "delete") {
                          FirebaseFirestore.instance
                              .collection("StudyMaterials")
                              .doc(widget.branch)
                              .collection("Subjects")
                              .doc(widget.data.id)
                              .delete();
                          messageToOwner("${widget.data}");
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
                  if (!widget.isSub &&
                      (widget.data.createdByAndPermissions.id ==
                          fullUserId() ||
                          isOwner()))
                    PopupMenuButton(
                      child: Icon(
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
                              const Duration(milliseconds: 300),
                              pageBuilder: (context, animation,
                                  secondaryAnimation) =>
                                  SubjectCreator(
                                    isSub: false,
                                    data: widget.data,
                                    size: Size,
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
                                      duration: Duration(milliseconds: 300),
                                      opacity:
                                      animation.value.clamp(0.3, 1.0),
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
                          messageToOwner("${widget.data}");
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
              )
            ],
          ),

            Row(
              mainAxisAlignment:  MainAxisAlignment.center,

              children: [
                if (widget.data.regulation.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Size * 3, horizontal: Size * 8),
                    margin: EdgeInsets.symmetric(horizontal: Size * 8,vertical: 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Size * 8),
                        color: Colors.black45),
                    child: Text(
                      widget.data.regulation.toString().replaceAll("[","").replaceAll("]", "").replaceAll(",", " - "),
                      style:
                          TextStyle(color: Colors.white, fontSize: Size * 10),
                    ),
                  ),

              ],
            ),
        ],
      ),
    );
  }
}

class LabSubjects extends StatefulWidget {
  final String branch;
  final String reg;
  final List<syllabusConvertor> syllabusModelPaper;
  final double size;

  LabSubjects({
    Key? key,
    required this.branch,
    required this.syllabusModelPaper,
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
    getPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: widget.size * 10,
          ),
          StreamBuilder<List<subjectConvertor>>(
              stream: readLabSubject(widget.branch),
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
                      return Center(
                          child: Text(
                              'Error with TextBooks Data or\n Check Internet Connection'
                          )
                      );
                    } else {
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: LabSubjects!.length,
                        itemBuilder: (context, int index) {
                          final LabSubjectsData = LabSubjects[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: widget.size * 2,
                                horizontal: widget.size * 10),
                            child: InkWell(
                              child: subjectsContainer(
                                syllabusModelPaper: widget.syllabusModelPaper,
                                data: LabSubjectsData,
                                branch: widget.branch,
                                isSub: false,
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
                                          reg: widget.reg,
                                          syllabusModelPaper: widget.syllabusModelPaper,
                                      size: widget.size,
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
                            ),
                          );
                        },
                      );
                    }
                }
              }),
        ],
      ),
    );
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
                        return const Center(
                            child: Text(
                                'Error with TextBooks Data or\n Check Internet Connection'));
                      } else {
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio:
                                (widget.size * 16) / (widget.size * 13),
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
  BooksConvertor data;
  double size;

  textBookSub(
      {required this.size,
      required this.data,
      required this.branch});

  @override
  State<textBookSub> createState() => _textBookSubState();
}

class _textBookSubState extends State<textBookSub> with SingleTickerProviderStateMixin {

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
          padding: EdgeInsets.all(widget.size * 2.0),
          margin: EdgeInsets.all(widget.size * 2.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.size * 15),
              color: Colors.white.withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                    blurRadius: 2,
                    color: Colors.black12,
                    offset: Offset(1, 3))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if(File("${folderPath}/pdfs/${getFileName(widget.data.link)}")
                  .existsSync() &&
                  widget.data.link.isNotEmpty)AspectRatio(
                aspectRatio: (widget.size * 16) / (widget.size * 8),
                child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(widget.size * 15),
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
                      padding: EdgeInsets.symmetric(vertical: widget.size * 2.0,horizontal: 2),
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
                                      fontSize: widget.size * 18,
                                      color: Colors.white),
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
                                      size: widget.size * 25,
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
                          if(!File(
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
                                    fontSize: widget.size * 15,
                                    color: Colors.white70),
                              ),
                              Text(
                                "E : ${widget.data.edition}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: widget.size * 15,
                                    color: Colors.white70),
                              ),
                            ],
                          ),

                          if (widget.data.link.isNotEmpty&&!File(
                              "${folderPath}/pdfs/${getFileName(widget.data.link)}")
                              .existsSync())
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                            child: Padding(
                                              padding: EdgeInsets.all(widget.size * 3),
                                              child: Row(
                                                children: [
                                                  if (!File(
                                                          "${folderPath}/pdfs/${getFileName(widget.data.link)}")
                                                      .existsSync())
                                                    Text(
                                                      "Download ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: widget.size * 15,
                                                          fontWeight: FontWeight.w800),
                                                    ),
                                                  Icon(
                                                    File("${folderPath}/pdfs/${getFileName(widget.data.link)}")
                                                            .existsSync()
                                                        ? Icons.open_in_new
                                                        : Icons
                                                            .download_for_offline_outlined,
                                                    color: Colors.greenAccent,
                                                    size: widget.size * 25,
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
                                                await download(widget.data.link);
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
                                                  branch: widget.branch, data: widget.data,

                                                )));
                                      } else{
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
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: widget.size * 2.0,horizontal: 3),
                            child: Text("Description : ${widget.data.description}",style: TextStyle(color: Colors.white,fontSize: 18),),
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
          File isFile = File("${folderPath}/pdfs/${getFileName(widget.data.link)}");
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
        });
  }
}

class textBookUnit extends StatefulWidget {
  final subjectConvertor subject;
  TextBookConvertor textBook;
  String branch,creator;
  double size;
  textBookUnit(
      {required this.size,
      required this.subject,
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
        margin: EdgeInsets.symmetric(horizontal: widget.size * 10),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(widget.size * 30)),
        width: widget.size * 300,
        child: Row(
          children: [
            if (!file.existsSync() && widget.textBook.Link.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: widget.size * 8.0, horizontal: widget.size * 10),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Icon(
                      Icons.download_for_offline,
                      color: Colors.white,
                      size: widget.size * 50,
                    ),
                    if (isDownloaded)
                      SizedBox(
                          height: widget.size * 40,
                          width: widget.size * 40,
                          child: CircularProgressIndicator(
                            color: Colors.amber,
                          ))
                  ],
                ),
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: widget.size * 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.textBook.Heading,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: widget.size * 16,
                            color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (file.existsSync())
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: widget.size * 3,
                              horizontal: widget.size * 3),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(widget.size * 25),
                            color: Colors.black.withOpacity(0.4),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: widget.size * 3,
                                horizontal: widget.size * 5),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.deepOrange,
                                  size: widget.size * 30,
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
                          color: Colors.white,
                          size: widget.size * 20,
                        ),
                        // Callback that sets the selected popup menu item.
                        onSelected: (item) async {
                          if (item == "edit") {


                            // if (widget.isUnit)
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UnitsCreator(
                                            branch: widget.branch, mode: 'textBook', subjectId: widget.subject.id, subject: widget.subject,textBook:widget.textBook

                                          )));

                          } else if (item == "delete") {
                            await _firestore
                                .collection('StudyMaterials')
                                .doc(widget.branch)
                                .collection("Subjects")
                                .doc(widget.subject.id)
                                .update({
                              'textBooks': FieldValue.arrayRemove([widget.textBook.toJson()]),
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
                      size: widget.size,
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

final GlobalKey<_subjectUnitsDataState> UnitKey =
    GlobalKey<_subjectUnitsDataState>();

class subjectUnitsData extends StatefulWidget {

  subjectConvertor data;
  String reg;
  bool mode;
  List<syllabusConvertor> syllabusModelPaper;

  String branch;
  final double size;

  subjectUnitsData({
    required this.mode,
    required this.reg,
    required this.syllabusModelPaper,
    required this.data,
    required this.branch,
    required this.size,
  }) : super(key: UnitKey);

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



  @override
  void initState() {
    getPath();
    _tabController = new TabController(
      vsync: this,
      length:widget.mode?4:3,
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
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return backgroundcolor(
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(widget.size * 30),
                        bottomRight: Radius.circular(widget.size * 30),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.blueGrey.withOpacity(0.1),
                          Colors.blueGrey.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        backButton(
                          size: widget.size * 0.9,
                          text: widget.data.heading.short,
                          child: Visibility(
                            visible: widget.data.createdByAndPermissions.id ==
                                fullUserId() ||
                                isOwner(),
                            child: PopupMenuButton(
                              child: Container(
                                width: widget.size * 120,
                                margin: EdgeInsets.symmetric(
                                    horizontal: widget.size * 5),
                                padding: EdgeInsets.symmetric(
                                    horizontal: widget.size * 5),
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(Size * 20),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: widget.size * 25,
                                    ),
                                    SizedBox(
                                      width: widget.size * 70,
                                      child: CarouselSlider(
                                        items: List.generate(
                                          [
                                            widget.mode?"Units":"Manuals",
                                            if (widget.mode )
                                              "Text Books",
                                            "More"
                                          ].length,
                                              (int index) {
                                            return Center(
                                              child: Text(
                                                [
                                                  widget.mode?"Units":"Manuals",
                                                  if (widget.mode )
                                                    "Text Books",
                                                  "More"
                                                ][index],
                                                style: TextStyle(
                                                  fontSize: widget.size * 15.0,
                                                  color: Colors.white,
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
                                          height: widget.size * 35,
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
                                            subjectId: widget.data.id, subject: widget.data,
                                          )));
                                } else if (item == "Text Book") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UnitsCreator(
                                            mode: "textBook",
                                            branch: widget.branch,
                                            subjectId: widget.data.id, subject: widget.data,
                                          )));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UnitsCreator(
                                            mode: "more",
                                            branch: widget.branch,
                                            subjectId: widget.data.id, subject: widget.data,
                                          )));
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry>[
                                PopupMenuItem(
                                  value: "Unit",
                                  child: Text(widget.mode
                                      ? "Unit"
                                      : "Records & Manuals"),
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: widget.size * 10,
                              vertical: widget.size * 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.data.heading.full.isNotEmpty)
                                Text(
                                  widget.data.heading.full,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.size * 18,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: widget.size * 10),
                                child: Row(
                                  children: [
                                    Text(
                                      "${months[int.tryParse(widget.data.id.split('-').first.split('.')[1]) ?? 1]} ${widget.data.id.split('-').first.split('.').last}     ",
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: widget.size * 14),
                                    ),
                                    if (widget.data.regulation.isNotEmpty)
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: widget.size * 1,
                                                horizontal: widget.size * 5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                  widget.size * 8),
                                              color: Colors.white12,
                                            ),
                                            child: Text(
                                              widget.data.regulation.toString().replaceAll("[", "").replaceAll("]", "").replaceAll(",", " - "),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: widget.size * 12),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (widget.data.createdByAndPermissions.id.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: widget.size * 5,
                                      left: widget.size * 8,
                                      right: widget.size * 8),
                                  child: Text(
                                    "@${widget.data.createdByAndPermissions.id.replaceAll(";", " - @")}",
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: widget.size * 10,
                                        fontWeight: FontWeight.w400),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              if (widget.data.description.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: widget.size * 5,
                                      left: widget.size * 8,
                                      right: widget.size * 8),
                                  child: Text(
                                    widget.data.description,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: widget.size * 16,
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
                ),
                SliverToBoxAdapter(
                  child: tabBarForUnit(
                    isSub: widget.mode,
                    units: widget.data.units.length,
                    textBooks: widget.data.textBooks.length,
                    moreInfo: widget.data.moreInfos.length,
                    tabController: _tabController,
                    question: widget.data.units.fold(0, (count, element) =>
                    count + (element.Question.isNotEmpty ? element.Question.length : 0)),
                    oldPapers: widget.data.oldPapers.length,
                  ),
                ),



              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: widget.size * 10,
                          vertical: widget.size * 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.mode
                                ? "Units"
                                : "Records & Manuals",
                            style: TextStyle(
                                color: Colors.white,
                                // fontWeight: FontWeight.w500,
                                fontSize: widget.size * 25),
                          ),
                          Row(
                            children: [
                              if (widget.mode )
                                PopupMenuButton(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: widget.size * 3,
                                        horizontal: widget.size * 8),
                                    decoration: BoxDecoration(
                                        color: Colors.white10,
                                        borderRadius: BorderRadius.circular(
                                            widget.size * 8)),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Filter ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: widget.size * 20),
                                        ),
                                        Icon(
                                          Icons.filter_list,
                                          color: Colors.white,
                                          size: widget.size * 20,
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
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: widget.size * 10.0),
                      child: unitFilter == "all"
                          ? ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.data.units.length,
                        itemBuilder: (context, int index) {
                          final unit = widget.data.units[index];
                          return subUnit(
                            subject: widget.data,
                            size: widget.size,
                            data: unit,
                            creator: widget.data.createdByAndPermissions.id,
                            branch: widget.branch,
                            subjectId: widget.data.id,
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(
                          height: widget.size * 5,
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
                            size: widget.size,
                            creator: widget.data.createdByAndPermissions.id,
                            branch: widget.branch,
                            subjectId: widget.data.id,
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(
                          height: widget.size * 5,
                        ),
                      ),
                    ),
                    if (widget.mode)
                      Column(
                        children: [
                          if (widget.data.textBooks.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: widget.size * 10,
                                  vertical: widget.size * 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Text Books",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: widget.size * 25),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(
                            height: widget.size * 70,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.data.textBooks.length,
                              itemBuilder: (context, int index) {
                                final unit = widget.data.textBooks[index];

                                return textBookUnit(

                                  size: widget.size,
                                  branch: widget.branch, subject: widget.data, creator: widget.data.createdByAndPermissions.id, textBook: unit,
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                height: widget.size * 5,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                if(widget.mode)Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10, bottom: 10),
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
                                        size: widget.size,
                                      )));
                        },
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Syllabus & Model Paper",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                        itemCount: widget.syllabusModelPaper.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final data = widget.syllabusModelPaper[index];
                          if (data.id
                              .startsWith(widget.reg.substring(0, 10))) {
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

                          return data.id.startsWith(
                              widget.reg.substring(0, 10)) &&
                              data.modelPaper.isNotEmpty &&
                              data.syllabus.isNotEmpty
                              ? Row(
                            children: [
                              Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(25),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                  height: 80,
                                                  color: Colors.white12,
                                                  child: File("${folderPath}/pdfs/${getFileName(data.syllabus)}")
                                                      .existsSync()
                                                      ? PDFView(
                                                    filePath:
                                                    "${folderPath}/pdfs/${getFileName(data.syllabus)}",
                                                  )
                                                      : Container()),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => PdfViewerPage(
                                                              size: widget
                                                                  .size,
                                                              pdfUrl:
                                                              "${folderPath}/pdfs/${getFileName(data.syllabus)}")));
                                                },
                                                child: Container(
                                                  height: 80,
                                                  width:
                                                  double.infinity,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets
                                              .symmetric(vertical: 5.0),
                                          child: Text(
                                            "Syllabus Paper ( ${widget.reg.substring(0, 10)} )",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                              Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(25),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                  height: 80,
                                                  color: Colors.white12,
                                                  child: File("${folderPath}/pdfs/${getFileName(data.modelPaper)}")
                                                      .existsSync()
                                                      ? PDFView(
                                                    filePath:
                                                    "${folderPath}/pdfs/${getFileName(data.modelPaper)}",
                                                  )
                                                      : Container()),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => PdfViewerPage(
                                                              size: widget
                                                                  .size,
                                                              pdfUrl:
                                                              "${folderPath}/pdfs/${getFileName(data.modelPaper)}")));
                                                },
                                                child: Container(
                                                  height: 80,
                                                  width:
                                                  double.infinity,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets
                                              .symmetric(vertical: 5.0),
                                          child: Text(
                                            "Model Paper ( ${widget.reg.substring(0, 10)} )",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ],
                          )
                              : Container();
                        }),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10, top: 30, bottom: 10),
                          child: Text(
                            "Old Papers",
                            style: TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.data.oldPapers.length,
                          itemBuilder: (context, int index) {
                            final unit = widget.data.oldPapers[index];
                            return subOldPapers(data: unit, size: 1,);
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: widget.size * 5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: widget.size * 10,
                          vertical: widget.size * 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Questions & Description",
                            style: TextStyle(
                                color: Colors.white,
                                // fontWeight: FontWeight.w500,
                                fontSize: widget.size * 25),
                          ),
                          Row(
                            children: [
                              if (widget.mode)
                                PopupMenuButton(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: widget.size * 3,
                                        horizontal: widget.size * 8),
                                    decoration: BoxDecoration(
                                        color: Colors.white10,
                                        borderRadius: BorderRadius.circular(
                                            widget.size * 8)),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Filter ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: widget.size * 20),
                                        ),
                                        Icon(
                                          Icons.filter_list,
                                          color: Colors.white,
                                          size: widget.size * 20,
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
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.data.units.length,
                      itemBuilder: (context, int index) {
                        final unit = widget.data.units[index];
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                          padding: EdgeInsets.symmetric(vertical: 3,horizontal: 8),
                          decoration: BoxDecoration(
                              color: Colors.white12,borderRadius: BorderRadius.circular(15)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(unit.Heading,style: TextStyle(color: Colors.amber,fontSize: 15),),
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
                                                          size: widget.size,
                                                          pdfUrl:
                                                          "${folderPath}/pdfs/${getFileName(unit.Link)}",
                                                          defaultPage:a.pageNumber,
                                                        )));
                                          } else {
                                            showToastText("Download PDF");
                                          }
                                        },
                                        child: Text(a.data,style: TextStyle(color: Colors.white,fontSize: 16),));
                                  }),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 3),
                                padding: EdgeInsets.symmetric(vertical: 3,horizontal: 8),
                                decoration: BoxDecoration(
                                    color: Colors.black54,borderRadius: BorderRadius.circular(10)
                                ),
                                child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: unit.Question.length,
                                    itemBuilder: (context, int index) {
                                      final a = unit.Question[index];
                                      return InkWell(onTap: () {
                                        if (File(
                                            "${folderPath}/pdfs/${getFileName(unit.Link)}")
                                            .existsSync()) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PdfViewerPage(
                                                        size: widget.size,
                                                        pdfUrl:
                                                        "${folderPath}/pdfs/${getFileName(unit.Link)}",
                                                        defaultPage:a.pageNumber,
                                                      )));
                                        } else {
                                          showToastText("Download PDF");
                                        }
                                      },child: Text("${index+1}. ${a.data}",style: TextStyle(color: Colors.white,fontSize: 18),));
                                    }),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: widget.size * 5,
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
                          size: widget.size,
                          creator: widget.data.createdByAndPermissions.id,
                          branch: widget.branch,
                          subjectId: widget.data.id,
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: widget.size * 5,
                      ),
                    ),
                    if (widget.mode == "Subjects")
                      Column(
                        children: [
                          if (widget.data.textBooks.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: widget.size * 10,
                                  vertical: widget.size * 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Text Books",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: widget.size * 25),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(
                            height: widget.size * 70,
                            child: ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.data.textBooks.length,
                              itemBuilder: (context, int index) {
                                final unit = widget.data.textBooks[index];

                                return textBookUnit(

                                  size: widget.size,
                                  branch: widget.branch, subject: widget.data, creator: widget.data.createdByAndPermissions.id, textBook: unit,
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                height: widget.size * 5,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                Column(
                  children: [

                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: widget.size * 10,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "More",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: widget.size * 25),
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
                          branch: widget.branch,
                          size: widget.size,
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
                          branch: widget.branch,
                          creator:
                          widget.data.createdByAndPermissions.id,
                          data: unit,
                          size: 1,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
//     return backgroundcolor(
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: SafeArea(
//           child: SingleChildScrollView(
//             controller: _controller,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(widget.size * 40),
//                         bottomRight: Radius.circular(widget.size * 40)),
//                     gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Colors.transparent,
//                           Colors.transparent,
//                           Colors.transparent,
//                           Colors.transparent,
//                           Colors.blueGrey.withOpacity(0.1),
//                           Colors.white12
//                         ]),
//                   ),
//                   child: Column(
//                     children: [
//                       backButton(
//                         size: widget.size * 0.9,
//                         text: widget.data!.heading.short,
//                         child: Visibility(
//                           visible: widget.data.createdByAndPermissions.id ==
//                                   fullUserId() ||
//                               isOwner(),
//                           child: PopupMenuButton(
//                             child: Container(
//                               width: widget.size * 120,
//                               margin: EdgeInsets.symmetric(
//                                   horizontal: widget.size * 5),
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: widget.size * 5),
//                               decoration: BoxDecoration(
//                                 color: Colors.white12,
//                                 borderRadius: BorderRadius.circular(Size * 20),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.add,
//                                     color: Colors.white,
//                                     size: widget.size * 25,
//                                   ),
//                                   SizedBox(
//                                     width: widget.size * 70,
//                                     child: CarouselSlider(
//                                       items: List.generate(
//                                         [
//                                           "Units",
//                                           if (widget.mode == "Subjects")
//                                             "Text Books",
//                                           "More"
//                                         ].length,
//                                         (int index) {
//                                           return Center(
//                                             child: Text(
//                                               [
//                                                 "Units",
//                                                 if (widget.mode == "Subjects")
//                                                   "Text Books",
//                                                 "More"
//                                               ][index],
//                                               style: TextStyle(
//                                                 fontSize: widget.size * 15.0,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                       //Slider Container properties
//                                       options: CarouselOptions(
//                                         scrollDirection: Axis.vertical,
//                                         // Set the axis to vertical
//                                         viewportFraction: 0.95,
//                                         disableCenter: true,
//                                         enlargeCenterPage: true,
//                                         height: widget.size * 35,
//                                         autoPlayAnimationDuration:
//                                             const Duration(seconds: 3),
//                                         autoPlay: true,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             // Callback that sets the selected popup menu item.
//                             onSelected: (item) {
//                               if (item == "Unit") {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => UnitsCreator(
//                                               mode: "units",
//                                               branch: widget.branch,
//                                               subjectId: widget.data.id, subject: widget.data,
//                                             )));
//                               } else if (item == "Text Book") {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => UnitsCreator(
//                                               mode: "textBook",
//                                               branch: widget.branch,
//                                               subjectId: widget.data.id, subject: widget.data,
//                                             )));
//                               } else {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => UnitsCreator(
//                                               mode: "more",
//                                               branch: widget.branch,
//                                               subjectId: widget.data.id, subject: widget.data,
//                                             )));
//                               }
//                             },
//                             itemBuilder: (BuildContext context) =>
//                                 <PopupMenuEntry>[
//                               PopupMenuItem(
//                                 value: "Unit",
//                                 child: Text(widget.mode == "Subjects"
//                                     ? "Unit"
//                                     : "Records & Manuals"),
//                               ),
//                               if (widget.mode == "Subjects")
//                                 PopupMenuItem(
//                                   value: "Text Book",
//                                   child: Text('Text Book'),
//                                 ),
//                               PopupMenuItem(
//                                 value: "More",
//                                 child: Text('More'),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: widget.size * 10,
//                             vertical: widget.size * 10),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             if (widget.data.heading.full.isNotEmpty)
//                               Padding(
//                                 padding: EdgeInsets.only(
//                                     bottom: widget.size * 5,
//                                     left: widget.size * 8,
//                                     right: widget.size * 8),
//                                 child: Text(
//                                   widget.data.heading.full,
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: widget.size * 22,
//                                   ),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: widget.size * 10),
//                               child: Row(
//                                 children: [
//                                   Text(
//                                     "${months[int.tryParse(widget.data.id.split('-').first.split('.')[1]) ?? 1]} ${widget.data.id.split('-').first.split('.').last}     ",
//                                     style: TextStyle(
//                                         color: Colors.white60,
//                                         fontSize: widget.size * 14),
//                                   ),
//                                   if (widget.data.regulation.isNotEmpty)
//                                     Container(
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(
//                                               widget.size * 8),
//                                           color: Colors.white24,
//                                           border:
//                                               Border.all(color: Colors.white10)),
//                                       child: Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: widget.size * 2,
//                                             horizontal: widget.size * 5),
//                                         child: Text(
//                                           widget.data.regulation.toString(),
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: widget.size * 12),
//                                         ),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                             if (widget.data.createdByAndPermissions.id.isNotEmpty)
//                               Padding(
//                                 padding: EdgeInsets.only(
//                                     top: widget.size * 5,
//                                     left: widget.size * 8,
//                                     right: widget.size * 8),
//                                 child: Text(
//                                   "@${widget.data.createdByAndPermissions.id.replaceAll(";", " - @")}",
//                                   style: TextStyle(
//                                       color: Colors.white70,
//                                       fontSize: widget.size * 14,
//                                       fontWeight: FontWeight.w400),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             if (widget.data.description.isNotEmpty)
//                               Padding(
//                                 padding: EdgeInsets.only(
//                                     bottom: widget.size * 5,
//                                     left: widget.size * 8,
//                                     right: widget.size * 8),
//                                 child: Text(
//                                   widget.data.description,
//                                   style: TextStyle(
//                                     color: Colors.white.withOpacity(0.8),
//                                     fontSize: widget.size * 16,
//                                   ),
//                                   maxLines: 3,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 tabBarForUnit(
//                   tabController: _tabController,
//                 ),
//                 Expanded(
//                   child: TabBarView(controller: _tabController, children: [
//                     SingleChildScrollView(
//                       controller: _controller,
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: widget.size * 10,
//                                 vertical: widget.size * 10),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   widget.mode == "Subjects"
//                                       ? "Units"
//                                       : "Records & Manuals",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       // fontWeight: FontWeight.w500,
//                                       fontSize: widget.size * 25),
//                                 ),
//                                 Row(
//                                   children: [
//                                     if (widget.mode == "Subjects")
//                                       PopupMenuButton(
//                                         child: Container(
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: widget.size * 3,
//                                               horizontal: widget.size * 8),
//                                           decoration: BoxDecoration(
//                                               color: Colors.white10,
//                                               borderRadius: BorderRadius.circular(
//                                                   widget.size * 8)),
//                                           child: Row(
//                                             children: [
//                                               Text(
//                                                 "Filter ",
//                                                 style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize: widget.size * 20),
//                                               ),
//                                               Icon(
//                                                 Icons.filter_list,
//                                                 color: Colors.white,
//                                                 size: widget.size * 20,
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                         // Callback that sets the selected popup menu item.
//                                         onSelected: (item) {
//                                           setState(() {
//                                             unitFilter = item as String;
//                                           });
//                                         },
//                                         itemBuilder: (BuildContext context) =>
//                                         <PopupMenuEntry>[
//                                           PopupMenuItem(
//                                             value: "all",
//                                             child: Text('All'),
//                                           ),
//                                           PopupMenuItem(
//                                             value: "Unit 1",
//                                             child: Text('Unit 1'),
//                                           ),
//                                           PopupMenuItem(
//                                             value: "Unit 2",
//                                             child: Text('Unit 2'),
//                                           ),
//                                           PopupMenuItem(
//                                             value: "Unit 3",
//                                             child: Text('Unit 3'),
//                                           ),
//                                           PopupMenuItem(
//                                             value: "Unit 4",
//                                             child: Text('Unit 4'),
//                                           ),
//                                           PopupMenuItem(
//                                             value: "Unit 5",
//                                             child: Text('Unit 5'),
//                                           ),
//                                         ],
//                                       ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding:
//                             EdgeInsets.symmetric(horizontal: widget.size * 10.0),
//                             child: unitFilter == "all"
//                                 ? ListView.separated(
//                               physics: NeverScrollableScrollPhysics(),
//                               shrinkWrap: true,
//                               itemCount: widget.data.units.length,
//                               itemBuilder: (context, int index) {
//                                 final unit = widget.data.units[index];
//                                 return subUnit(
//                                   subject: widget.data,
//                                   size: widget.size,
//                                   data: unit,
//                                   creator: widget.data.createdByAndPermissions.id,
//                                   branch: widget.branch,
//                                   subjectId: widget.data.id,
//                                 );
//                               },
//                               separatorBuilder: (context, index) => SizedBox(
//                                 height: widget.size * 5,
//                               ),
//                             )
//                                 : ListView.separated(
//                               physics: NeverScrollableScrollPhysics(),
//                               shrinkWrap: true,
//                               itemCount: widget.data.units
//                                   .where((unit) => unit.Unit.contains(unitFilter))
//                                   .toList()
//                                   .length,
//                               itemBuilder: (context, int index) {
//                                 final filteredUnits = widget.data.units
//                                     .where(
//                                         (unit) => unit.Unit.contains(unitFilter))
//                                     .toList();
//                                 final unit = filteredUnits[index];
//                                 return subUnit(
//                                   subject: widget.data,
//                                   data: unit,
//                                   size: widget.size,
//                                   creator: widget.data.createdByAndPermissions.id,
//                                   branch: widget.branch,
//                                   subjectId: widget.data.id,
//                                 );
//                               },
//                               separatorBuilder: (context, index) => SizedBox(
//                                 height: widget.size * 5,
//                               ),
//                             ),
//                           ),
//                           if (widget.mode == "Subjects")
//                             Column(
//                               children: [
//                                 if (widget.data.textBooks.isNotEmpty)
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: widget.size * 10,
//                                         vertical: widget.size * 15),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           "Text Books",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w500,
//                                               fontSize: widget.size * 25),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 SizedBox(
//                                   height: widget.size * 70,
//                                   child: ListView.separated(
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount: widget.data.textBooks.length,
//                                     itemBuilder: (context, int index) {
//                                       final unit = widget.data.textBooks[index];
//
//                                       return textBookUnit(
//
//                                         size: widget.size,
//                                         branch: widget.branch, subject: widget.data, creator: widget.data.createdByAndPermissions.id, textBook: unit,
//                                       );
//                                     },
//                                     separatorBuilder: (context, index) => SizedBox(
//                                       height: widget.size * 5,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                         ],
//                       ),
//                     ),
//                     Column(
//                       children: [
//                         if (widget.data.textBooks.isNotEmpty)
//                           Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: widget.size * 10,
//                                 vertical: widget.size * 15),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "Text Books",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: widget.size * 25),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         SizedBox(
//                           height: widget.size * 70,
//                           child: ListView.separated(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: widget.data.textBooks.length,
//                             itemBuilder: (context, int index) {
//                               final unit = widget.data.textBooks[index];
//
//                               return textBookUnit(
//
//                                 size: widget.size,
//                                 branch: widget.branch, subject: widget.data, creator: widget.data.createdByAndPermissions.id, textBook: unit,
//                               );
//                             },
//                             separatorBuilder: (context, index) => SizedBox(
//                               height: widget.size * 5,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: widget.size * 10,
//                               vertical: widget.size * 10),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//
//                                     "Questions & Description",
//
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     // fontWeight: FontWeight.w500,
//                                     fontSize: widget.size * 25),
//                               ),
//                               Row(
//                                 children: [
//                                   if (widget.mode == "Subjects")
//                                     PopupMenuButton(
//                                       child: Container(
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: widget.size * 3,
//                                             horizontal: widget.size * 8),
//                                         decoration: BoxDecoration(
//                                             color: Colors.white10,
//                                             borderRadius: BorderRadius.circular(
//                                                 widget.size * 8)),
//                                         child: Row(
//                                           children: [
//                                             Text(
//                                               "Filter ",
//                                               style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: widget.size * 20),
//                                             ),
//                                             Icon(
//                                               Icons.filter_list,
//                                               color: Colors.white,
//                                               size: widget.size * 20,
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                       // Callback that sets the selected popup menu item.
//                                       onSelected: (item) {
//                                         setState(() {
//                                           unitFilter = item as String;
//                                         });
//                                       },
//                                       itemBuilder: (BuildContext context) =>
//                                       <PopupMenuEntry>[
//                                         PopupMenuItem(
//                                           value: "all",
//                                           child: Text('All'),
//                                         ),
//                                         PopupMenuItem(
//                                           value: "Unit 1",
//                                           child: Text('Unit 1'),
//                                         ),
//                                         PopupMenuItem(
//                                           value: "Unit 2",
//                                           child: Text('Unit 2'),
//                                         ),
//                                         PopupMenuItem(
//                                           value: "Unit 3",
//                                           child: Text('Unit 3'),
//                                         ),
//                                         PopupMenuItem(
//                                           value: "Unit 4",
//                                           child: Text('Unit 4'),
//                                         ),
//                                         PopupMenuItem(
//                                           value: "Unit 5",
//                                           child: Text('Unit 5'),
//                                         ),
//                                       ],
//                                     ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                         unitFilter == "all"
//                             ? ListView.separated(
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemCount: widget.data.units.length,
//                           itemBuilder: (context, int index) {
//                             final unit = widget.data.units[index];
//                             return Container(
//                               margin: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
//                               padding: EdgeInsets.symmetric(vertical: 3,horizontal: 8),
//                               decoration: BoxDecoration(
//                                 color: Colors.white12,borderRadius: BorderRadius.circular(15)
//                               ),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(unit.Heading,style: TextStyle(color: Colors.amber,fontSize: 15),),
//                                   ListView.builder(
//                                     physics: NeverScrollableScrollPhysics(),
//                                     shrinkWrap: true,
//                                     itemCount: unit.Description.length,
//                                     itemBuilder: (context, int index) {
//                                       final a = unit.Description[index];
//                                       return InkWell(
//                                           onTap: () {
//                                             if (File(
//                                                 "${folderPath}/pdfs/${getFileName(unit.Link)}")
//                                                 .existsSync()) {
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           PdfViewerPage(
//                                                             size: widget.size,
//                                                             pdfUrl:
//                                                             "${folderPath}/pdfs/${getFileName(unit.Link)}",
//                                                             defaultPage:a.pageNumber,
//                                                           )));
//                                             } else {
//                                               showToastText("Download PDF");
//                                             }
//                                           },
//                                       child: Text(a.data,style: TextStyle(color: Colors.white,fontSize: 16),));
//                                     }),
//                                   Container(
//                                     margin: EdgeInsets.symmetric(vertical: 3),
//                                     padding: EdgeInsets.symmetric(vertical: 3,horizontal: 8),
//                                     decoration: BoxDecoration(
//                                         color: Colors.black54,borderRadius: BorderRadius.circular(10)
//                                     ),
//                                     child: ListView.builder(
//                                       physics: NeverScrollableScrollPhysics(),
//                                       shrinkWrap: true,
//                                       itemCount: unit.Question.length,
//                                       itemBuilder: (context, int index) {
//                                         final a = unit.Question[index];
//                                         return InkWell(onTap: () {
//                                           if (File(
//                                               "${folderPath}/pdfs/${getFileName(unit.Link)}")
//                                               .existsSync()) {
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         PdfViewerPage(
//                                                           size: widget.size,
//                                                           pdfUrl:
//                                                           "${folderPath}/pdfs/${getFileName(unit.Link)}",
//                                                           defaultPage:a.pageNumber,
//                                                         )));
//                                           } else {
//                                             showToastText("Download PDF");
//                                           }
//                                         },child: Text("${index+1}. ${a.data}",style: TextStyle(color: Colors.white,fontSize: 18),));
//                                       }),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                           separatorBuilder: (context, index) => SizedBox(
//                             height: widget.size * 5,
//                           ),
//                         )
//                             : ListView.separated(
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemCount: widget.data.units
//                               .where((unit) => unit.Unit.contains(unitFilter))
//                               .toList()
//                               .length,
//                           itemBuilder: (context, int index) {
//                             final filteredUnits = widget.data.units
//                                 .where(
//                                     (unit) => unit.Unit.contains(unitFilter))
//                                 .toList();
//                             final unit = filteredUnits[index];
//                             return subUnit(
//                               subject: widget.data,
//                               data: unit,
//                               size: widget.size,
//                               creator: widget.data.createdByAndPermissions.id,
//                               branch: widget.branch,
//                               subjectId: widget.data.id,
//                             );
//                           },
//                           separatorBuilder: (context, index) => SizedBox(
//                             height: widget.size * 5,
//                           ),
//                         ),
//                         if (widget.mode == "Subjects")
//                           Column(
//                             children: [
//                               if (widget.data.textBooks.isNotEmpty)
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: widget.size * 10,
//                                       vertical: widget.size * 15),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         "Text Books",
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: widget.size * 25),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               SizedBox(
//                                 height: widget.size * 70,
//                                 child: ListView.separated(
//                                   scrollDirection: Axis.horizontal,
//                                   itemCount: widget.data.textBooks.length,
//                                   itemBuilder: (context, int index) {
//                                     final unit = widget.data.textBooks[index];
//
//                                     return textBookUnit(
//
//                                       size: widget.size,
//                                       branch: widget.branch, subject: widget.data, creator: widget.data.createdByAndPermissions.id, textBook: unit,
//                                     );
//                                   },
//                                   separatorBuilder: (context, index) => SizedBox(
//                                     height: widget.size * 5,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                       ],
//                     ),
//
//
//
//                     Column(
//                       children: [
//                         if (widget.data.moreInfos.isNotEmpty)
//                           Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: widget.size * 10,
//                                 vertical: widget.size * 10),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "More",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: widget.size * 25),
//                                 ),
//                                 PopupMenuButton(
//                                   icon: Icon(
//                                     Icons.filter_list,
//                                     color: Colors.white,
//                                     size: widget.size * 25,
//                                   ),
//                                   // Callback that sets the selected popup menu item.
//                                   onSelected: (item) {
//                                     setState(() {
//                                       moreFilter = item as String;
//                                     });
//                                   },
//                                   itemBuilder: (BuildContext context) =>
//                                       <PopupMenuEntry>[
//                                     PopupMenuItem(
//                                       value: "all",
//                                       child: Text('All'),
//                                     ),
//                                     PopupMenuItem(
//                                       value: "PDF",
//                                       child: Text('.pdf'),
//                                     ),
//                                     PopupMenuItem(
//                                       value: "Image",
//                                       child: Text('Image'),
//                                     ),
//                                     PopupMenuItem(
//                                       value: "WebSite",
//                                       child: Text('WebSite'),
//                                     ),
//                                     PopupMenuItem(
//                                       value: "YouTube",
//                                       child: Text('YouTube'),
//                                     ),
//                                     PopupMenuItem(
//                                       value: "More",
//                                       child: Text('More'),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         moreFilter == "all"
//                             ? ListView.builder(
//                                 physics: NeverScrollableScrollPhysics(),
//                                 shrinkWrap: true,
//                                 itemCount: widget.data.moreInfos.length,
//                                 itemBuilder: (context, int index) {
//                                   final unit = widget.data.moreInfos[index];
//
//                                   return subMore(
//                                     subjectId: widget.data.id,
//                                     branch: widget.branch,
//                                     size: widget.size,
//                                     data: unit,
//                                     creator:
//                                         widget.data.createdByAndPermissions.id,
//                                     subject: widget.data,
//                                   );
//                                 },
//                               )
//                             : ListView.builder(
//                                 shrinkWrap: true,
//                                 physics: NeverScrollableScrollPhysics(),
//                                 itemCount: widget.data.moreInfos
//                                     .where((unit) =>
//                                         unit.Type.startsWith(moreFilter))
//                                     .toList()
//                                     .length,
//                                 itemBuilder: (context, int index) {
//                                   final filteredUnits = widget.data.moreInfos
//                                       .where((unit) =>
//                                           unit.Type.startsWith(moreFilter))
//                                       .toList();
//                                   final unit = filteredUnits[index];
//                                   return subMore(
//                                     subject: widget.data,
//                                     subjectId: widget.data.id,
//                                     branch: widget.branch,
//                                     creator:
//                                         widget.data.createdByAndPermissions.id,
//                                     data: unit,
//                                     size: 1,
//                                   );
//                                 },
//                               ),
//                       ],
//                     ),
//
//                   ]),
//                 ),
//               ],
//             ),
//           ),
//         ),

// //         floatingActionButton: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             // Row(
// //             //   mainAxisAlignment: MainAxisAlignment.end,
// //             //   children: [
// //             //     Container(
// //             //       decoration: BoxDecoration(
// //             //           color: Colors.white12,
// //             //           borderRadius: BorderRadius.circular(widget.size * 20)),
// //             //       child: Padding(
// //             //         padding: EdgeInsets.all(widget.size * 8.0),
// //             //         child: Row(
// //             //           mainAxisAlignment: MainAxisAlignment.center,
// //             //           crossAxisAlignment: CrossAxisAlignment.center,
// //             //           children: [
// //             //             if (widget.mode == "Subjects")
// //             //               InkWell(
// //             //                 child: StreamBuilder<DocumentSnapshot>(
// //             //                   stream: FirebaseFirestore.instance
// //             //                       .collection('user')
// //             //                       .doc(fullUserId())
// //             //                       .collection("FavouriteSubject")
// //             //                       .doc(widget.ID)
// //             //                       .snapshots(),
// //             //                   builder: (context, snapshot) {
// //             //                     if (snapshot.hasData) {
// //             //                       if (snapshot.data!.exists) {
// //             //                         return Icon(Icons.bookmark_added_rounded,
// //             //                             size: widget.size * 30,
// //             //                             color: Colors.cyanAccent);
// //             //                       } else {
// //             //                         return Icon(
// //             //                           Icons.bookmark_border,
// //             //                           size: widget.size * 30,
// //             //                           color: Colors.cyanAccent,
// //             //                         );
// //             //                       }
// //             //                     } else {
// //             //                       return Container();
// //             //                     }
// //             //                   },
// //             //                 ),
// //             //                 onTap: () async {
// //             //                   try {
// //             //                     await FirebaseFirestore.instance
// //             //                         .collection('user')
// //             //                         .doc(fullUserId())
// //             //                         .collection("FavouriteSubject")
// //             //                         .doc(widget.ID)
// //             //                         .get()
// //             //                         .then((docSnapshot) {
// //             //                       if (docSnapshot.exists) {
// //             //                         FirebaseFirestore.instance
// //             //                             .collection('user')
// //             //                             .doc(fullUserId())
// //             //                             .collection("FavouriteSubject")
// //             //                             .doc(widget.ID)
// //             //                             .delete();
// //             //                         showToastText("Removed from saved list");
// //             //                       } else {
// //             //                         FavouriteSubjects(
// //             //                           branch: widget.branch,
// //             //                           id: widget.ID,
// //             //                           regulation: widget.reg,
// //             //                           name: widget.name,
// //             //                           description: widget.description,
// //             //                           creator: widget.creator,
// //             //                         );
// //             //                         showToastText(
// //             //                             "${widget.name} in favorites");
// //             //                       }
// //             //                     });
// //             //                   } catch (e) {
// //             //                     print(e);
// //             //                   }
// //             //                 },
// //             //               )
// //             //             else
// //             //               InkWell(
// //             //                 child: StreamBuilder<DocumentSnapshot>(
// //             //                   stream: FirebaseFirestore.instance
// //             //                       .collection('user')
// //             //                       .doc(fullUserId())
// //             //                       .collection("FavouriteLabSubjects")
// //             //                       .doc(widget.ID)
// //             //                       .snapshots(),
// //             //                   builder: (context, snapshot) {
// //             //                     if (snapshot.hasData) {
// //             //                       if (snapshot.data!.exists) {
// //             //                         return Row(
// //             //                           children: [
// //             //                             Icon(Icons.library_add_check,
// //             //                                 size: widget.size * 23,
// //             //                                 color: Colors.cyanAccent),
// //             //                             Text(
// //             //                               " Saved",
// //             //                               style: TextStyle(
// //             //                                   color: Colors.white,
// //             //                                   fontSize: widget.size * 20),
// //             //                             )
// //             //                           ],
// //             //                         );
// //             //                       } else {
// //             //                         return Row(
// //             //                           children: [
// //             //                             Icon(
// //             //                               Icons.library_add_outlined,
// //             //                               size: widget.size * 23,
// //             //                               color: Colors.cyanAccent,
// //             //                             ),
// //             //                             Text(
// //             //                               " Save",
// //             //                               style: TextStyle(
// //             //                                   color: Colors.white,
// //             //                                   fontSize: widget.size * 20),
// //             //                             )
// //             //                           ],
// //             //                         );
// //             //                       }
// //             //                     } else {
// //             //                       return Container();
// //             //                     }
// //             //                   },
// //             //                 ),
// //             //                 onTap: () async {
// //             //                   try {
// //             //                     await FirebaseFirestore.instance
// //             //                         .collection('user')
// //             //                         .doc(fullUserId())
// //             //                         .collection("FavouriteLabSubjects")
// //             //                         .doc(widget.ID)
// //             //                         .get()
// //             //                         .then((docSnapshot) {
// //             //                       if (docSnapshot.exists) {
// //             //                         FirebaseFirestore.instance
// //             //                             .collection('user')
// //             //                             .doc(fullUserId())
// //             //                             .collection("FavouriteLabSubjects")
// //             //                             .doc(widget.ID)
// //             //                             .delete();
// //             //                         showToastText("Removed from saved list");
// //             //                       } else {
// //             //                         FavouriteLabSubjectsSubjects(
// //             //                           branch: widget.branch,
// //             //                           id: widget.ID,
// //             //                           regulation: widget.reg,
// //             //                           name: widget.name,
// //             //                           description: widget.description,
// //             //                           creator: widget.creator,
// //             //                         );
// //             //                         showToastText(
// //             //                             "${widget.name} in favorites");
// //             //                       }
// //             //                     });
// //             //                   } catch (e) {
// //             //                     print(e);
// //             //                   }
// //             //                 },
// //             //               )
// //             //           ],
// //             //         ),
// //             //       ),
// //             //     ),
// //             //     SizedBox(
// //             //       width: widget.size * 10,
// //             //     ),
// //             //     downloadAllPdfs(
// //             //       branch: widget.branch,
// //             //       SubjectID: widget.ID,
// //             //       mode: widget.mode,
// //             //       size: widget.size,
// //             //     ),
// //             //   ],
// //             // ),
// //             Container(
// //               width: 120,
// //            margin: EdgeInsets.symmetric(horizontal: 100),
// // padding: EdgeInsets.symmetric(horizontal: 5),
// //               decoration: BoxDecoration(
// //                 color: Colors.white24,
// //                 borderRadius: BorderRadius.circular(Size * 20),
// //               ),
// //               child: Row(
// //                 children: [
// //                   Icon(
// //                     Icons.add,
// //                     color: Colors.white,
// //                     size: widget.size * 25,
// //                   ),
// //                   SizedBox(width: widget.size * 70,
// //                     child:CarouselSlider(
// //                       items: List.generate(
// //                         searchList.length,
// //                             (int index) {
// //                           return Center(
// //                             child: Text(
// //                               searchList[index],
// //                               style: TextStyle(
// //                                 fontSize: widget.size * 15.0,
// //                                 color: Colors.white,
// //                               ),
// //                             ),
// //                           );
// //                         },
// //                       ),
// //                       //Slider Container properties
// //                       options: CarouselOptions(
// //                         scrollDirection: Axis.vertical,
// //                         // Set the axis to vertical
// //                         viewportFraction: 0.95,
// //                         disableCenter: true,
// //                         enlargeCenterPage: true,
// //                         height: widget.size * 35,
// //                         autoPlayAnimationDuration:
// //                         const Duration(seconds: 3),
// //                         autoPlay: true,
// //                       ),
// //                     ),),
// //
// //                 ],
// //               ),
// //             ),
// //
// //           ],
// //         ),
//       ),
//     );
  }

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

class subUnit extends StatefulWidget {
  final subjectConvertor subject;
  final UnitConvertor data;
  final String branch, subjectId;
  final String creator;
  final double size;

  subUnit({
    Key? key,
    required this.data,
    required this.branch,
    required this.subject,
    required this.creator,
    required this.size,
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
      } else {
      }
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
    // set();

    super.initState();
  }

  // set() {
  //   newQuestionsList = widget.data.questions.split(";");
  //   newList = widget.data.description.split(";");
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.data.Link.isNotEmpty)
      pdfFile = File("${folderPath}/pdfs/${getFileName(widget.data.Link)}");
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.size * 28),
            color: Colors.white.withOpacity(0.1)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.data.Link.length > 3)
                        File("${folderPath}/pdfs/${getFileName(widget.data.Link)}")
                                    .existsSync() &&
                                widget.data.Link.isNotEmpty
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(widget.size * 25),
                                child: SizedBox(
                                    height: widget.size * 60,
                                    width: widget.size * 80,
                                    child: PDFView(
                                      filePath:
                                          "${folderPath}/pdfs/${getFileName(widget.data.Link)}",
                                    )),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: widget.size * 8.0,
                                    horizontal: widget.size * 10),
                                child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Icon(
                                      Icons.download_for_offline,
                                      color: Colors.white,
                                      size: widget.size * 50,
                                    ),
                                    if (isDownloaded)
                                      SizedBox(
                                          height: widget.size * 40,
                                          width: widget.size * 40,
                                          child: CircularProgressIndicator(
                                            color: Colors.amber,
                                          ))
                                  ],
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
                                "${widget.data.Heading}",
                                style: TextStyle(
                                  fontSize: widget.size * 22.0,
                                  color: Colors.white,
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
                              borderRadius: BorderRadius.circular(
                                  widget.size * 20),
                              color: Colors.black,
                            ),
                            child: Icon(Icons.close,color: Colors.purpleAccent,),
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

                ],
              ),
            ),
            if (widget.creator.contains(fullUserId()) || isOwner())
              PopupMenuButton(
                padding: EdgeInsets.zero,

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: widget.size * 18,
                  ),
                ),
                // Callback that sets the selected popup menu item.
                onSelected: (item) async {
                  if (item == "edit") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UnitsCreator(
                                subject: widget.subject,
                                mode: "units",
                                subjectId: widget.subjectId,
                                branch: widget.branch,
                                unit: widget.data
                            )));
                  } else if (item == "delete") {
                    await _firestore
                        .collection('StudyMaterials')
                        .doc(widget.branch)
                        .collection("Subjects")
                        .doc(widget.subjectId)
                        .update({
                      'units': FieldValue.arrayRemove([widget.data.toJson()]),
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
      onTap: () async {
        if (pdfFile.existsSync()) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PdfViewerPage(
                      size: widget.size,
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
  final double size;
  subOldPapers({
    Key? key,
    required this.data,
    required this.size,
  }) : super(key: key);
  @override
  State<subOldPapers> createState() => _subOldPapersState();
}

class _subOldPapersState extends State<subOldPapers> with TickerProviderStateMixin {
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
      } else {
      }
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
            borderRadius: BorderRadius.circular(widget.size * 28),
            color: Colors.white.withOpacity(0.15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.data.pdfLink.length > 3)
              File("${folderPath}/pdfs/${getFileName(widget.data.pdfLink)}")
                          .existsSync() &&
                      widget.data.pdfLink.isNotEmpty
                  ? ClipRRect(
                      borderRadius:
                          BorderRadius.circular(widget.size * 25),
                      child: SizedBox(
                          height: widget.size * 60,
                          width: widget.size * 80,
                          child: PDFView(
                            filePath:
                                "${folderPath}/pdfs/${getFileName(widget.data.pdfLink)}",
                          )),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: widget.size * 8.0,
                          horizontal: widget.size * 10),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Icon(
                            Icons.download_for_offline,
                            color: Colors.white,
                            size: widget.size * 50,
                          ),
                          if (isDownloaded)
                            SizedBox(
                                height: widget.size * 40,
                                width: widget.size * 40,
                                child: CircularProgressIndicator(
                                  color: Colors.amber,
                                ))
                        ],
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
                      "${widget.data.heading}",
                      style: TextStyle(
                        fontSize: widget.size * 22.0,
                        color: Colors.white,
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
                    borderRadius: BorderRadius.circular(
                        widget.size * 20),
                    color: Colors.black,
                  ),
                  child: Icon(Icons.close,color: Colors.purpleAccent,),
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
                      size: widget.size,
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
  final double size;

  const subMore(
      {Key? key,
      required this.data,
      required this.subject,
      required this.subjectId,
      required this.branch,
      required this.creator,
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
    if (widget.data.Link.isNotEmpty && widget.data.Type == "PDF")
      file = File("${folderPath}/pdfs/${getFileName(widget.data.Link)}");

    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: widget.size * 8.0, vertical: widget.size * 2),
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
                      widget.data.Link.isNotEmpty &&
                      widget.data.Type == "PDF")
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
                    )
                  else if (widget.data.Type == "Image")
                    ClipRRect(
                      borderRadius: BorderRadius.circular(widget.size * 25),
                      child: SizedBox(
                        width: widget.size * 100,
                        height: widget.size * 60,
                        child: ImageShowAndDownload(
                          image: widget.data.Link,
                        ),
                      ),
                    )
                  else if (widget.data.Type == "YouTube" ||
                      widget.data.Type == "WebSite")
                    Padding(
                      padding: EdgeInsets.all(widget.size * 8.0),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white30),
                              borderRadius:
                                  BorderRadius.circular(widget.size * 10),
                              image: DecorationImage(
                                  image: AssetImage(
                                      widget.data.Type == "YouTube"
                                          ? "assets/YouTubeIcon.png"
                                          : "assets/googleIcon.png"),
                                  fit: BoxFit.cover)),
                          height: widget.size * 35,
                          width: widget.size * 40),
                    )
                  else
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: widget.size * 5,
                          vertical: widget.size * 1),
                      decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(widget.size * 5)),
                      child: Text(
                        widget.data.Type,
                        style: TextStyle(
                            fontSize: widget.size * 12,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      "  ${widget.data.Heading}",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: widget.size * 20),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.creator.contains(fullUserId()) || isOwner())
                    PopupMenuButton(
                      child: Icon(
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
                                  builder: (context) => UnitsCreator(
                                    moreInfo:widget.data,
                                        branch: widget.branch,
                                        mode: "more", subjectId: widget.subject.id, subject: widget.subject,
                                      )));
                        } else if (item == "delete") {
                          List<dynamic> updatedUnits = widget
                              .subject.moreInfos
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
                                        right: widget.size * 5,
                                      ),
                                      child: InkWell(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                widget.size * 15),
                                            color:
                                                Colors.white.withOpacity(0.8),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: widget.size * 3,
                                                horizontal: widget.size * 5),
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
                                                      fontSize:
                                                          widget.size * 20,
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
                                          showToastText("Long Press To Delete");
                                        },
                                      ),
                                    )
                                  else
                                    InkWell(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: widget.size * 10,
                                              bottom: widget.size * 5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      widget.size * 15),
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: widget.size * 3,
                                                  horizontal: widget.size * 5),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Download",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize:
                                                            widget.size * 20,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .file_download_outlined,
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
                        padding: EdgeInsets.symmetric(
                            horizontal: widget.size * 20.0),
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
                                padding: EdgeInsets.only(
                                    bottom: widget.size * 3,
                                    left: widget.size * 10),
                                child: Flexible(
                                  child: Text(
                                    widget.data.Description[index],
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: widget.size * 15),
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
                                        color: Colors.white,
                                        fontSize: widget.size * 18,
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
                      size: widget.size,
                      pdfUrl:
                          "${folderPath}/pdfs/${getFileName(widget.data.Link)}")));
        } else if (widget.data.Type == "YouTube" ||
            widget.data.Type == "WebSite") ExternalLaunchUrl(widget.data.Link);
      },
    );
  }
}

class SyllabusAndModelPapers extends StatefulWidget {
  List<syllabusConvertor> data;
  double size;
  String reg, branch;

  SyllabusAndModelPapers(
      {required this.size,
      required this.branch,
      required this.reg,
      required this.data});

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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orangeAccent.withOpacity(0.1),
            Colors.blue.withOpacity(0.2),
            Colors.deepPurpleAccent.withOpacity(0.12),
          ],
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(children: [
              SizedBox(
                height: widget.size * 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: widget.size * 10, right: widget.size * 10),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: widget.size * 20,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    color: Colors.transparent,
                    height: widget.size * 30,
                    child: Center(
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(widget.size * 15),
                            color: Colors.white12),
                        controller: _tabController,
                        isScrollable: true,
                        labelPadding:
                            EdgeInsets.symmetric(horizontal: widget.size * 10),
                        tabs: [
                          Tab(
                            child: Text(
                              "  Syllabus  ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: widget.size * 20,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "  Model paper  ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: widget.size * 20),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: widget.size * 40,
                  ),
                ],
              ),
              SizedBox(
                height: widget.size * 10,
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
                          size: widget.size,
                          id: data.id,
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
                            size: widget.size,
                            id: data.id,
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
          )),
    );
  }
}

class syllabusAndModelpaperContainer extends StatefulWidget {
  String reg, branch, link, id, mode;

  double size;

  syllabusAndModelpaperContainer(
      {required this.size,
      required this.reg,
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
                      size: widget.size,
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
        padding: EdgeInsets.symmetric(
            horizontal: widget.size * 5.0, vertical: widget.size * 3),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius:
                  BorderRadius.all(Radius.circular(widget.size * 30))),
          child: Row(
            children: [
              if (widget.link.length > 3)
                File("${folderPath}/pdfs/${getFileName(widget.link)}")
                            .existsSync() &&
                        widget.link.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(widget.size * 25),
                        child: SizedBox(
                            height: widget.size * 60,
                            width: widget.size * 100,
                            child: PDFView(
                              filePath:
                                  "${folderPath}/pdfs/${getFileName(widget.link)}",
                            )),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: widget.size * 8.0,
                            horizontal: widget.size * 25),
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Icon(
                              Icons.download_for_offline,
                              color: Colors.white,
                              size: widget.size * 50,
                            ),
                            if (isDownloaded)
                              SizedBox(
                                  height: widget.size * 40,
                                  width: widget.size * 40,
                                  child: CircularProgressIndicator(
                                    color: Colors.amber,
                                  ))
                          ],
                        ),
                      ),
              SizedBox(
                width: widget.size * 20,
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
                          fontSize: widget.size * 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (widget.link.isEmpty)
                        Text(
                          "No Data",
                          style: TextStyle(
                            fontSize: widget.size * 20.0,
                            color: Colors.amber,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      if (widget.link.isNotEmpty &&
                          File("${folderPath}/pdfs/${getFileName(widget.link)}")
                              .existsSync())
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
                            color: Colors.white,
                            size: widget.size * 25,
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
                                                size: widget.size,
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
                                                size: widget.size,
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
    return backgroundcolor(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                backButton(
                    size: widget.size,
                    text: "College Updates",
                    child: SizedBox(
                      width: widget.size * 80,
                    )),
                SizedBox(
                  height: widget.size * 10,
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
                                    left: widget.size * 10,
                                    top: widget.size * 10,
                                    bottom: widget.size * 20,
                                    right: widget.size * 8),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: BranchNews.length,
                                itemBuilder: (context, int index) {
                                  final BranchNew = BranchNews[index];

                                  return InkWell(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 2),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              widget.size * 15),
                                          color: Colors.black),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (BranchNew.link.isEmpty &&
                                              BranchNew.photoUrl.isNotEmpty)
                                            Padding(
                                              padding: EdgeInsets.all(
                                                  widget.size * 3.0),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          widget.size * 15),
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
                                                      horizontal:
                                                          widget.size * 10.0,
                                                      vertical:
                                                          widget.size * 3),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      if (BranchNew
                                                          .heading.isNotEmpty)
                                                        Text(
                                                          BranchNew.heading,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                widget.size *
                                                                    20,
                                                          ),
                                                        ),
                                                      if (BranchNew.description
                                                          .isNotEmpty)
                                                        Text(
                                                          " ${BranchNew.description}",
                                                          style: TextStyle(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.8),
                                                            fontSize:
                                                                widget.size *
                                                                    14,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              if (BranchNew.link.isNotEmpty &&
                                                  BranchNew.photoUrl.isNotEmpty)
                                                SizedBox(
                                                  height: widget.size * 100,
                                                  width: widget.size * 140,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        widget.size * 3.0),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(widget
                                                                        .size *
                                                                    15),
                                                        child:
                                                            ImageShowAndDownload(
                                                          image: BranchNew
                                                              .photoUrl,
                                                          isZoom: true,
                                                        )),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          SizedBox(
                                              height: widget.size * 2,
                                              child: Divider(
                                                color: Colors.white24,
                                              )),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: widget.size * 10.0,
                                                vertical: widget.size * 2),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                          fontSize:
                                                              widget.size * 12,
                                                          color:
                                                              Colors.white70),
                                                    ),
                                                    Icon(
                                                      Icons.circle,
                                                      color: Colors.white,
                                                      size: widget.size * 3,
                                                    ),
                                                    Text(
                                                      "  ${BranchNew.creator.split("@").first}",
                                                      style: TextStyle(
                                                          fontSize:
                                                              widget.size * 12,
                                                          color:
                                                              Colors.white70),
                                                    ),
                                                  ],
                                                ),
                                                if (isGmail() || isOwner())
                                                  SizedBox(
                                                    height: widget.size * 18,
                                                    child: PopupMenuButton(
                                                      padding:
                                                          EdgeInsets.all(0),
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
                                                                            size:
                                                                                widget.size,
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
                  height: widget.size * 50,
                )
              ],
            ),
          ),
        ),
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
  int monthsDifference = currentTime.month -
      postedTime.month +
      (currentTime.year - postedTime.year) * 12;

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
