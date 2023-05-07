import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:srkr_study_app/HomePage.dart';

import 'SubPages.dart';
import 'settings.dart';

class MyAppq extends StatefulWidget {
  const MyAppq({Key? key}) : super(key: key);

  @override
  State<MyAppq> createState() => _MyAppqState();
}

class _MyAppqState extends State<MyAppq> {
  String name = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search Bar',
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 3, top: 5),
                    child: Text(
                      "Subjects",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('ECE')
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
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshots.data!.docs.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var data = snapshots.data!.docs[index].data()
                                    as Map<String, dynamic>;

                                if (name.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10, top: 3),
                                    child: InkWell(
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.black38,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: SingleChildScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 90.0,
                                                height: 50.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      data["Photo Url"],
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data['Heading'],
                                                    style: const TextStyle(
                                                      fontSize: 20.0,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    data['Description'],
                                                    style: const TextStyle(
                                                      fontSize: 13.0,
                                                      color: Color.fromRGBO(
                                                          204, 207, 222, 1),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 1,
                                                  ),
                                                  Text(
                                                    data['Date'],
                                                    style: const TextStyle(
                                                      fontSize: 9.0,
                                                      color: Colors.white60,
                                                      //   fontWeight: FontWeight.bold,
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
                                                      ID: data['id'],
                                                      mode: "Subjects",
                                                      name: data["Heading"],
                                                      fullName:
                                                          data['Description'],
                                                      photoUrl:
                                                          data['Photo Url'],
                                                    )));
                                      },
                                    ),
                                  );
                                }
                                if (data['Heading']
                                    .toString()
                                    .toLowerCase()
                                    .startsWith(name.toLowerCase())) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10, top: 3),
                                    child: InkWell(
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.black38,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: SingleChildScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 90.0,
                                                height: 50.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      data["Photo Url"],
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data['Heading'],
                                                    style: const TextStyle(
                                                      fontSize: 20.0,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    data['Description'],
                                                    style: const TextStyle(
                                                      fontSize: 13.0,
                                                      color: Color.fromRGBO(
                                                          204, 207, 222, 1),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 1,
                                                  ),
                                                  Text(
                                                    data['Date'],
                                                    style: const TextStyle(
                                                      fontSize: 9.0,
                                                      color: Colors.white60,
                                                      //   fontWeight: FontWeight.bold,
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
                                                      ID: data['id'],
                                                      mode: "Subjects",
                                                      name: data["Heading"],
                                                      fullName:
                                                          data['Description'],
                                                      photoUrl:
                                                          data['Photo Url'],
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
                    padding: const EdgeInsets.only(left: 10, bottom: 3, top: 5),
                    child: Text(
                      "Lab Subjects",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('ECE')
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
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshots.data!.docs.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var data = snapshots.data!.docs[index].data()
                                    as Map<String, dynamic>;

                                if (name.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10, top: 3),
                                    child: InkWell(
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.black38,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: SingleChildScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 90.0,
                                                height: 50.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      data["Photo Url"],
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data['Heading'],
                                                    style: const TextStyle(
                                                      fontSize: 20.0,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    data['Description'],
                                                    style: const TextStyle(
                                                      fontSize: 13.0,
                                                      color: Color.fromRGBO(
                                                          204, 207, 222, 1),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 1,
                                                  ),
                                                  Text(
                                                    data['Date'],
                                                    style: const TextStyle(
                                                      fontSize: 9.0,
                                                      color: Colors.white60,
                                                      //   fontWeight: FontWeight.bold,
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
                                                      ID: data['id'],
                                                      mode: "LabSubjects",
                                                      name: data["Heading"],
                                                      fullName:
                                                          data['Description'],
                                                      photoUrl:
                                                          data['Photo Url'],
                                                    )));
                                      },
                                    ),
                                  );
                                }
                                if (data['Heading']
                                    .toString()
                                    .toLowerCase()
                                    .startsWith(name.toLowerCase())) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10, top: 3),
                                    child: InkWell(
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.black38,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: SingleChildScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 90.0,
                                                height: 50.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      data["Photo Url"],
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data['Heading'],
                                                    style: const TextStyle(
                                                      fontSize: 20.0,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    data['Description'],
                                                    style: const TextStyle(
                                                      fontSize: 13.0,
                                                      color: Color.fromRGBO(
                                                          204, 207, 222, 1),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 1,
                                                  ),
                                                  Text(
                                                    data['Date'],
                                                    style: const TextStyle(
                                                      fontSize: 9.0,
                                                      color: Colors.white60,
                                                      //   fontWeight: FontWeight.bold,
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
                                                      ID: data['id'],
                                                      mode: "LabSubjects",
                                                      name: data["Heading"],
                                                      fullName:
                                                          data['Description'],
                                                      photoUrl:
                                                          data['Photo Url'],
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future showToast(String message) async {
  await Fluttertoast.cancel();
  Fluttertoast.showToast(msg: message, fontSize: 18);
}
