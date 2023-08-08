import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'SubPages.dart';

class MyAppq extends StatefulWidget {
  final String branch;
  final String reg;
  final double size;
  final double height;
  final double width;

  const MyAppq(
      {Key? key,
      required this.branch,
      required this.reg,
      required this.width,
      required this.size,
      required this.height})
      : super(key: key);

  @override
  State<MyAppq> createState() => _MyAppqState();
}

class _MyAppqState extends State<MyAppq> {
  String name = "";

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
        body: Container(
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://i.pinimg.com/736x/01/c7/f7/01c7f72511cc6ce7858e65b45d4f8c9c.jpg"),
                    fit: BoxFit.fill)),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Scaffold(
                  backgroundColor: Colors.black.withOpacity(0.8),
                  body: SafeArea(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: widget.height * 70,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: widget.width * 10,
                                    bottom: widget.height * 3,
                                    top: widget.height * 5),
                                child: InkWell(
                                  child: Text(
                                    "Subjects",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: widget.size * 30),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Subjects(
                                                  branch: widget.branch,
                                                  reg: widget.reg,
                                                  width: widget.width,
                                                  height: widget.height,
                                                  size: widget.size,
                                                )));
                                  },
                                ),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection(widget.branch)
                                    .doc("Subjects")
                                    .collection("Subjects")
                                    .snapshots(),
                                builder: (context, snapshots) {
                                  return (snapshots.connectionState ==
                                          ConnectionState.waiting)
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              snapshots.data!.docs.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            var data = snapshots
                                                .data!.docs[index]
                                                .data() as Map<String, dynamic>;
                                            final Uri uri =
                                                Uri.parse(data["Photo Url"]);
                                            final String fileName =
                                                uri.pathSegments.last;
                                            var filename =
                                                fileName.split("/").last;
                                            final file = File(
                                                "${folderPath}/${widget.branch.toLowerCase()}_subjects/$filename");
                                            if (name.isEmpty) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    left: widget.width * 15.0,
                                                    right: widget.width * 10,
                                                    top: widget.height * 5),
                                                child: InkWell(
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Colors.black38,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    widget.size *
                                                                        10))),
                                                    child:
                                                        SingleChildScrollView(
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width:
                                                                widget.width *
                                                                    80.0,
                                                            height:
                                                                widget.height *
                                                                    50.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(
                                                                      widget.size *
                                                                          8.0)),
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    FileImage(
                                                                        file),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                widget.width *
                                                                    10,
                                                          ),
                                                          Expanded(
                                                              child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                data['Heading'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      widget.size *
                                                                          20.0,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: widget
                                                                        .height *
                                                                    2,
                                                              ),
                                                              Text(
                                                                data[
                                                                    'Description'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      widget.size *
                                                                          13.0,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          204,
                                                                          207,
                                                                          222,
                                                                          0.8),
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
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                subjectUnitsData(
                                                                  date: "2012",
                                                                  req: "",
                                                                  pdfs: 0,
                                                                  width: widget
                                                                      .width,
                                                                  height: widget
                                                                      .height,
                                                                  size: widget
                                                                      .size,
                                                                  branch: widget
                                                                      .branch,
                                                                  ID: data[
                                                                      'id'],
                                                                  mode:
                                                                      "Subjects",
                                                                  name: data[
                                                                      "Heading"],
                                                                  fullName: data[
                                                                      'Description'],
                                                                  photoUrl: data[
                                                                      'Photo Url'],
                                                                )));
                                                  },
                                                ),
                                              );
                                            }
                                            if (data['Heading']
                                                .toString()
                                                .toLowerCase()
                                                .startsWith(
                                                    name.toLowerCase())) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    left: widget.width * 15.0,
                                                    right: widget.width * 10,
                                                    top: widget.height * 3),
                                                child: InkWell(
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Colors.black38,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    widget.size *
                                                                        10))),
                                                    child:
                                                        SingleChildScrollView(
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width:
                                                                widget.width *
                                                                    80.0,
                                                            height:
                                                                widget.height *
                                                                    50.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(
                                                                      widget.size *
                                                                          8.0)),
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    FileImage(
                                                                        file),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                widget.width *
                                                                    10,
                                                          ),
                                                          Expanded(
                                                              child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                data['Heading'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      widget.size *
                                                                          20.0,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: widget
                                                                        .height *
                                                                    2,
                                                              ),
                                                              Text(
                                                                data[
                                                                    'Description'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      widget.size *
                                                                          13.0,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          204,
                                                                          207,
                                                                          222,
                                                                          0.8),
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
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                subjectUnitsData(
                                                                  date: "2012",
                                                                  req: "kh",
                                                                  pdfs: 0,
                                                                  width: widget
                                                                      .width,
                                                                  height: widget
                                                                      .height,
                                                                  size: widget
                                                                      .size,
                                                                  branch: widget
                                                                      .branch,
                                                                  ID: data[
                                                                      'id'],
                                                                  mode:
                                                                      "Subjects",
                                                                  name: data[
                                                                      "Heading"],
                                                                  fullName: data[
                                                                      'Description'],
                                                                  photoUrl: data[
                                                                      'Photo Url'],
                                                                )));
                                                  },
                                                ),
                                              );
                                            }
                                            return Container();
                                          });
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: widget.width * 10,
                                    bottom: widget.height * 3,
                                    top: widget.height * 20),
                                child: InkWell(
                                  child: Text(
                                    "Lab Subjects",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: widget.size * 30),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LabSubjects(
                                                  branch: widget.branch,
                                                  reg: widget.reg,
                                                  width: widget.width,
                                                  height: widget.height,
                                                  size: widget.size,
                                                )));
                                  },
                                ),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection(widget.branch)
                                    .doc("LabSubjects")
                                    .collection("LabSubjects")
                                    .snapshots(),
                                builder: (context, snapshots) {
                                  return (snapshots.connectionState ==
                                          ConnectionState.waiting)
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              snapshots.data!.docs.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            var data = snapshots
                                                .data!.docs[index]
                                                .data() as Map<String, dynamic>;
                                            final Uri uri =
                                                Uri.parse(data["Photo Url"]);
                                            final String fileName =
                                                uri.pathSegments.last;
                                            var filename =
                                                fileName.split("/").last;
                                            final file = File(
                                                "${folderPath}/${widget.branch.toLowerCase()}_labsubjects/$filename");
                                            if (name.isEmpty) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    left: widget.width * 15.0,
                                                    right: widget.width * 10,
                                                    top: widget.height * 4),
                                                child: InkWell(
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Colors.black38,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    widget.size *
                                                                        10))),
                                                    child:
                                                        SingleChildScrollView(
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width:
                                                                widget.width *
                                                                    80.0,
                                                            height:
                                                                widget.height *
                                                                    50.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(
                                                                      widget.size *
                                                                          8.0)),
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    FileImage(
                                                                        file),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                widget.width *
                                                                    10,
                                                          ),
                                                          Expanded(
                                                              child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                data['Heading'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      widget.size *
                                                                          20.0,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: widget
                                                                        .height *
                                                                    2,
                                                              ),
                                                              Text(
                                                                data[
                                                                    'Description'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      widget.size *
                                                                          13.0,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          204,
                                                                          207,
                                                                          222,
                                                                          0.8),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: widget
                                                                        .height *
                                                                    1,
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
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                subjectUnitsData(
                                                                  date: "2012",
                                                                  req: "fghg",
                                                                  pdfs: 0,
                                                                  width: widget
                                                                      .width,
                                                                  height: widget
                                                                      .height,
                                                                  size: widget
                                                                      .size,
                                                                  branch: widget
                                                                      .branch,
                                                                  ID: data[
                                                                      'id'],
                                                                  mode:
                                                                      "LabSubjects",
                                                                  name: data[
                                                                      "Heading"],
                                                                  fullName: data[
                                                                      'Description'],
                                                                  photoUrl: data[
                                                                      'Photo Url'],
                                                                )));
                                                  },
                                                ),
                                              );
                                            }
                                            if (data['Heading']
                                                .toString()
                                                .toLowerCase()
                                                .startsWith(
                                                    name.toLowerCase())) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    left: widget.width * 15.0,
                                                    right: widget.width * 10,
                                                    top: widget.height * 3),
                                                child: InkWell(
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Colors.black38,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    widget.size *
                                                                        10))),
                                                    child:
                                                        SingleChildScrollView(
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width:
                                                                widget.width *
                                                                    80.0,
                                                            height:
                                                                widget.height *
                                                                    50.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(
                                                                      widget.size *
                                                                          8.0)),
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    FileImage(
                                                                        file),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                widget.width *
                                                                    10,
                                                          ),
                                                          Expanded(
                                                              child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                data['Heading'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      widget.size *
                                                                          20.0,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: widget
                                                                        .height *
                                                                    2,
                                                              ),
                                                              Text(
                                                                data[
                                                                    'Description'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      widget.size *
                                                                          13.0,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          204,
                                                                          207,
                                                                          222,
                                                                          0.8),
                                                                ),
                                                              )
                                                            ],
                                                          ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                subjectUnitsData(
                                                                  date: "2012",
                                                                  req: "hgd",
                                                                  pdfs: 0,
                                                                  width: widget
                                                                      .width,
                                                                  height: widget
                                                                      .height,
                                                                  size: widget
                                                                      .size,
                                                                  branch: widget
                                                                      .branch,
                                                                  ID: data[
                                                                      'id'],
                                                                  mode:
                                                                      "LabSubjects",
                                                                  name: data[
                                                                      "Heading"],
                                                                  fullName: data[
                                                                      'Description'],
                                                                  photoUrl: data[
                                                                      'Photo Url'],
                                                                )));
                                                  },
                                                ),
                                              );
                                            }
                                            return Container();
                                          });
                                },
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 10,bottom: 3,top: 5),
                              //   child: Text("Books",style: TextStyle(color: Colors.white,fontSize: 30),),
                              // ),
                              // StreamBuilder<QuerySnapshot>(
                              //   stream: FirebaseFirestore.instance.collection('ECE').doc("Books").collection("CoreBooks").snapshots(),
                              //   builder: (context, snapshots) {
                              //     return (snapshots.connectionState == ConnectionState.waiting)
                              //         ? Center(
                              //       child: CircularProgressIndicator(),
                              //     )
                              //         : ListView.builder(
                              //         physics: NeverScrollableScrollPhysics(),
                              //         itemCount: snapshots.data!.docs.length,
                              //         shrinkWrap: true,
                              //         itemBuilder: (context, index) {
                              //           var data = snapshots.data!.docs[index].data()
                              //           as Map<String, dynamic>;
                              //
                              //           if (name.isEmpty) {
                              //             return Padding(
                              //               padding: const EdgeInsets.only(left: 10.0,right: 10,top: 3),
                              //               child: InkWell(
                              //                 child: Container(
                              //                   width: double.infinity,
                              //                   decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.all(Radius.circular(10))),
                              //                   child: SingleChildScrollView(
                              //                     physics: const BouncingScrollPhysics(),
                              //                     child: Row(
                              //                       children: [
                              //                         Container(
                              //                           width: 60.0,
                              //                           height: 80.0,
                              //                           decoration: BoxDecoration(
                              //                             borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              //                             color: Colors.black.withOpacity(0.5),
                              //                             image: DecorationImage(
                              //                               image: NetworkImage(
                              //                                 data["Photo Url"],
                              //                               ),
                              //                               fit: BoxFit.cover,
                              //                             ),
                              //                           ),
                              //                         ),
                              //                         const SizedBox(
                              //                           width: 10,
                              //                         ),
                              //                         Expanded(
                              //                             child: Column(
                              //                               mainAxisAlignment: MainAxisAlignment.center,
                              //                               crossAxisAlignment: CrossAxisAlignment.start,
                              //                               children: [
                              //                                 Text(
                              //                                   data['Heading'],
                              //                                   style: const TextStyle(
                              //                                     fontSize: 20.0,
                              //                                     color: Colors.white,
                              //                                     fontWeight: FontWeight.w600,
                              //                                   ),
                              //                                 ),
                              //                                 SizedBox(
                              //                                   height: 2,
                              //                                 ),
                              //                                 Text(
                              //                                   data['Description'],
                              //                                   style: const TextStyle(
                              //                                     fontSize: 12.0,
                              //                                     color: Color.fromRGBO(204, 207, 222, 1),
                              //                                   ),
                              //                                   maxLines: 2,
                              //                                 ),
                              //                                 SizedBox(
                              //                                   height: 1,
                              //                                 ),
                              //                                 Text(
                              //                                   data['Author'],
                              //                                   style: const TextStyle(
                              //                                     fontSize:11.0,
                              //                                     color: Colors.blue,
                              //                                      fontWeight: FontWeight.bold,
                              //                                   ),
                              //                                 ),
                              //                                 Text(
                              //                                   data['Date'],
                              //                                   style: const TextStyle(
                              //                                     fontSize: 7.0,
                              //                                     color: Colors.white60,
                              //                                     //   fontWeight: FontWeight.bold,
                              //                                   ),
                              //                                 ),
                              //                               ],
                              //                             ))
                              //                       ],
                              //                     ),
                              //                   ),
                              //                 ),
                              //                 onTap: (){
                              //                   Navigator.push(
                              //                       context,
                              //                       MaterialPageRoute(
                              //                           builder: (context) => subjectUnitsData(
                              //                             ID:  data['id'],
                              //                             mode: "Subjects",
                              //                             name: data["Heading"],
                              //                             fullName: data['Description'],
                              //                             photoUrl: data['Photo Url'],
                              //                           )));
                              //                 },
                              //
                              //               ),
                              //             );
                              //           }
                              //           if (data['Heading'].toString().toLowerCase().startsWith(name.toLowerCase())) {
                              //             return Padding(
                              //               padding: const EdgeInsets.only(left: 10.0,right: 10,top: 3),
                              //               child: InkWell(
                              //                 child: Container(
                              //                   width: double.infinity,
                              //                   decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.all(Radius.circular(10))),
                              //                   child: SingleChildScrollView(
                              //                     physics: const BouncingScrollPhysics(),
                              //                     child: Row(
                              //                       children: [
                              //                         Container(
                              //                           width: 70.0,
                              //                           height: 100.0,
                              //                           decoration: BoxDecoration(
                              //                             borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              //                             color: Colors.black.withOpacity(0.5),
                              //                             image: DecorationImage(
                              //                               image: NetworkImage(
                              //                                 data["Photo Url"],
                              //                               ),
                              //                               fit: BoxFit.cover,
                              //                             ),
                              //                           ),
                              //                         ),
                              //                         const SizedBox(
                              //                           width: 10,
                              //                         ),
                              //                         Expanded(
                              //                             child: Column(
                              //                               mainAxisAlignment: MainAxisAlignment.center,
                              //                               crossAxisAlignment: CrossAxisAlignment.start,
                              //                               children: [
                              //                                 Text(
                              //                                   data['Heading'],
                              //                                   style: const TextStyle(
                              //                                     fontSize: 20.0,
                              //                                     color: Colors.white,
                              //                                     fontWeight: FontWeight.w600,
                              //                                   ),
                              //                                 ),
                              //                                 SizedBox(
                              //                                   height: 2,
                              //                                 ),
                              //                                 Text(
                              //                                   data['Description'],
                              //                                   style: const TextStyle(
                              //                                     fontSize: 13.0,
                              //                                     color: Color.fromRGBO(204, 207, 222, 1),
                              //                                   ),
                              //                                 ),
                              //                                 SizedBox(
                              //                                   height: 1,
                              //                                 ),
                              //                                 Text(
                              //                                   data['Date'],
                              //                                   style: const TextStyle(
                              //                                     fontSize: 9.0,
                              //                                     color: Colors.white60,
                              //                                     //   fontWeight: FontWeight.bold,
                              //                                   ),
                              //                                 ),
                              //                               ],
                              //                             ))
                              //                       ],
                              //                     ),
                              //                   ),
                              //                 ),
                              //                 onTap: (){
                              //                   Navigator.push(
                              //                       context,
                              //                       MaterialPageRoute(
                              //                           builder: (context) => subjectUnitsData(
                              //                             ID:  data['id'],
                              //                             mode: "Subjects",
                              //                             name: data["Heading"],
                              //                             fullName: data['Description'],
                              //                             photoUrl: data['Photo Url'],
                              //                           )));
                              //                 },
                              //
                              //               ),
                              //             );
                              //           }
                              //           return Container();
                              //         });
                              //   },
                              // ),
                              SizedBox(
                                height: 120,
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: widget.width * 20,
                                vertical: widget.height * 10),
                            child: Row(
                              children: [
                                InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(Icons.arrow_back,color: Colors.white,size: 30,),
                                  ),
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                ),
                                Flexible(
                                  child: Container(
                                    height: widget.height * 45,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      border: Border.all(color: Colors.white60),
                                      borderRadius:
                                          BorderRadius.circular(widget.size * 12),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: widget.width * 20),
                                      child: TextField(
                                        onChanged: (val) {
                                          setState(() {
                                            name = val;
                                          });
                                        },
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: widget.size * 25),
                                        decoration: InputDecoration(
                                          icon: Icon(
                                            Icons.search,
                                            color: Colors.white,
                                            size: widget.size * 25,
                                          ),
                                          border: InputBorder.none,
                                          hintText: 'Search Bar',
                                          hintStyle: TextStyle(
                                              color: Colors.white60,
                                              fontSize: widget.size * 23),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))));
  }
}
