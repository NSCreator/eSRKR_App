import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:srkr_study_app/HomePage.dart';
import 'package:srkr_study_app/TextField.dart';
import 'package:srkr_study_app/settings.dart';
import 'SubPages.dart';

class MyAppq extends StatefulWidget {
  final String branch;
  final String reg;
  final double size;


  const MyAppq(
      {Key? key,
      required this.branch,
      required this.reg,
      required this.size})
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
  Widget build(BuildContext context) =>backGroundImage(child: Stack(
    children: [
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: widget.size * 70,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: widget.size * 10,
                  bottom: widget.size * 3,
                  top: widget.size * 5),
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
                            width: widget.size,
                            height: widget.size,
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
                if(data["image"].toString().isNotEmpty){
                  final Uri uri =
                  Uri.parse(data["image"]);
                  final String fileName =
                      uri.pathSegments.last;
                  var filename =
                      fileName.split("/").last;
                  final file = File(
                      "${folderPath}/subjects/$filename");
                }
                      if (name.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: widget.size * 15.0,
                              right: widget.size * 10,
                              top: widget.size * 5),
                          child: InkWell(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius:
                                  BorderRadius.all(
                                      Radius.circular(
                                          widget.size *
                                              20))),
                              child:
                              SingleChildScrollView(
                                physics:
                                const BouncingScrollPhysics(),
                                child: Row(
                                  children: [
                                    Container(
                                      width:
                                      widget.size *
                                          80.0,
                                      height:
                                      widget.size *
                                          50.0,
                                      decoration:
                                      BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                widget.size *
                                                    20)),
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
                                      widget.size *
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
                                              data['heading'],
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
                                                  .size *
                                                  2,
                                            ),
                                            Text(
                                              data[
                                              'description'],
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
                                            reg: data[
                                            "regulation"],

                                            size: widget
                                                .size,
                                            branch: widget
                                                .branch,
                                            ID: data[
                                            'id'],
                                            mode:
                                            "Subjects",
                                            name: data[
                                            "heading"],
                                            fullName: data[
                                            'description'],
                                            photoUrl: data[
                                            'image'],
                                          )));
                            },
                          ),
                        );
                      }
                      if (data['heading']
                          .toString()
                          .toLowerCase()
                          .startsWith(
                          name.toLowerCase())|| data['description']
                          .toString()
                          .toLowerCase()
                          .startsWith(
                          name.toLowerCase()) ) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: widget.size * 15.0,
                              right: widget.size * 10,
                              top: widget.size * 3),
                          child: InkWell(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius:
                                  BorderRadius.all(
                                      Radius.circular(
                                          widget.size *
                                              20))),
                              child:
                              SingleChildScrollView(
                                physics:
                                const BouncingScrollPhysics(),
                                child: Row(
                                  children: [
                                    Container(
                                      width:
                                      widget.size *
                                          80.0,
                                      height:
                                      widget.size *
                                          50.0,
                                      decoration:
                                      BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                widget.size *
                                                   20)),
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
                                      widget.size *
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
                                              data['heading'],
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
                                                  .size *
                                                  2,
                                            ),
                                            Text(
                                              data[
                                              'description'],
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
                                            reg: data[
                                            "regulation"],

                                            size: widget
                                                .size,
                                            branch: widget
                                                .branch,
                                            ID: data[
                                            'id'],
                                            mode:
                                            "Subjects",
                                            name: data[
                                            "heading"],
                                            fullName: data[
                                            'description'],
                                            photoUrl: data[
                                            'image'],
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
                  left: widget.size * 10,
                  bottom: widget.size * 3,
                  top: widget.size * 20),
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
                            width: widget.size,
                            height: widget.size,
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
                      if(data["image"].toString().isNotEmpty){
                        final Uri uri =
                        Uri.parse(data["image"]);
                        final String fileName =
                            uri.pathSegments.last;
                        var filename =
                            fileName.split("/").last;
                        final file = File(
                            "${folderPath}/labsubjects/$filename");
                      }
                      if (name.isEmpty) {
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
                                  borderRadius:
                                  BorderRadius.all(
                                      Radius.circular(
                                          widget.size *
                                              20))),
                              child:
                              SingleChildScrollView(
                                physics:
                                const BouncingScrollPhysics(),
                                child: Row(
                                  children: [
                                    Container(
                                      width:
                                      widget.size *
                                          80.0,
                                      height:
                                      widget.size *
                                          50.0,
                                      decoration:
                                      BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                widget.size *
                                                    20)),
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
                                      widget.size *
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
                                              data['heading'],
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
                                                  .size *
                                                  2,
                                            ),
                                            Text(
                                              data[
                                              'description'],
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
                                                  .size *
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
                                            reg: data[
                                            'regulation'],

                                            size: widget
                                                .size,
                                            branch: widget
                                                .branch,
                                            ID: data[
                                            'id'],
                                            mode:
                                            "LabSubjects",
                                            name: data[
                                            "heading"],
                                            fullName: data[
                                            'description'],
                                            photoUrl: data[
                                            'image'],
                                          )));
                            },
                          ),
                        );
                      }
                      if (data['heading']
                          .toString()
                          .toLowerCase()
                          .startsWith(
                          name.toLowerCase())|| data['description']
                          .toString()
                          .toLowerCase()
                          .startsWith(
                          name.toLowerCase())) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: widget.size * 15.0,
                              right: widget.size * 10,
                              top: widget.size * 3),
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
                                      widget.size *
                                          80.0,
                                      height:
                                      widget.size *
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
                                      widget.size *
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
                                              data['heading'],
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
                                                  .size *
                                                  2,
                                            ),
                                            Text(
                                              data[
                                              'description'],
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

                                            reg: data[
                                            "regulation"],


                                            size: widget
                                                .size,
                                            branch: widget
                                                .branch,
                                            ID: data[
                                            'id'],
                                            mode:
                                            "LabSubjects",
                                            name: data[
                                            "heading"],
                                            fullName: data[
                                            'description'],
                                            photoUrl: data[
                                            'image'],
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
              height: 150,
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
              horizontal: widget.size * 20,
              vertical: widget.size * 10),
          child: Row(
            children: [
              InkWell(
                child: Padding(
                  padding:  EdgeInsets.only(right: widget.size*10),
                  child: Icon(Icons.arrow_back,color: Colors.white,size: widget.size*30,),
                ),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
              Flexible(
                child: TextFieldContainer(child:
                TextField(
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
                ))
              ),
            ],
          ),
        ),
      ),
    ],
  ));
}


