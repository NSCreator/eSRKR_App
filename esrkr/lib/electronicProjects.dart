// ignore_for_file: import_of_legacy_library_into_null_safe, camel_case_types, non_constant_identifier_names, must_be_immutable, equal_keys_in_map, library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:prokoni/settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'arduino.dart';
import 'homepage.dart';
import 'imageZoom.dart';
import 'saveCartList.dart';

class electronicProjects extends StatefulWidget {
  const electronicProjects({Key? key}) : super(key: key);

  @override
  State<electronicProjects> createState() => _electronicProjectsState();
}

class _electronicProjectsState extends State<electronicProjects> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(53, 166, 204, 1),
                  Color.fromRGBO(24, 45, 74, 1),
                  Color.fromRGBO(21, 47, 61, 1)
                ]),
          ),
          child: Column(
            children: [
              const Center(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Electronic Projects",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
              )),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<List<electronicProjectsConvertor>>(
                        stream: readelectronicProjects(),
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
                                return const Center(child: Text('Error with TextBooks Data or\n Check Internet Connection'));
                              } else {
                                if (Books!.isEmpty) {

                                  return const Center(
                                    child: Padding(
                                      padding:  EdgeInsets.all(8.0),
                                      child: Text(
                                        "Other Projects are not available",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 10, top: 20,bottom: 8),
                                        child: Text(
                                          "Mostly Viewed Projects",
                                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500,color: Color.fromRGBO(195, 228, 250, 1),),
                                        ),
                                      ),
                                      Container(
                                        height: 148,
                                        child: ListView.builder(
                                          physics: const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: Books.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context, int index) {
                                            final SubjectsData = Books[index];
                                            if (SubjectsData.sub) {
                                              return InkWell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10),
                                                  child: Container(
                                                    width: 220,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black38,
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 135,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                              color: Colors.black54,
                                                              borderRadius: BorderRadius.circular(15),
                                                              image:  DecorationImage(
                                                                image: NetworkImage(
                                                                  SubjectsData.photoUrl,
                                                                ),
                                                                fit: BoxFit.cover,
                                                              )
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Align(
                                                                    alignment: Alignment.topLeft,
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(3.0),
                                                                      child: Container(
                                                                          decoration: BoxDecoration(
                                                                            color: Colors.black.withOpacity(0.1),
                                                                            borderRadius: BorderRadius.circular(15),

                                                                          ),
                                                                          child: Column(
                                                                            children: [
                                                                              InkWell(
                                                                                child: StreamBuilder<DocumentSnapshot>(
                                                                                  stream: FirebaseFirestore.instance.collection("electronicProjects").doc(SubjectsData.id).collection("likes").doc(fullUserId()).snapshots(),
                                                                                  builder: (context, snapshot) {
                                                                                    if (snapshot.hasData) {
                                                                                      if (snapshot.data!.exists) {
                                                                                        return const Icon(Icons.favorite,color: Colors.red,size: 30,);
                                                                                      } else {
                                                                                        return const Icon(Icons.favorite_border,color: Colors.red,size: 30,);
                                                                                      }
                                                                                    } else {
                                                                                      return Container();
                                                                                    }
                                                                                  },
                                                                                ),
                                                                                onTap:
                                                                                    () {
                                                                                  updateLike(
                                                                                      SubjectsData.id, fullUserId()
                                                                                  );
                                                                                },
                                                                              ),
                                                                              InkWell(
                                                                                child: StreamBuilder<DocumentSnapshot>(
                                                                                  stream: FirebaseFirestore.instance.collection('users').doc(fullUserId()).collection("savedElectronicProjects").doc(SubjectsData.id).snapshots(),
                                                                                  builder: (context, snapshot) {
                                                                                    if (snapshot.hasData) {
                                                                                      if (snapshot.data!.exists) {
                                                                                        return const Icon(
                                                                                            Icons.library_add_check,
                                                                                            size: 30, color: Colors.cyanAccent
                                                                                        );
                                                                                      } else {
                                                                                        return const Icon(
                                                                                          Icons.library_add_check_outlined,
                                                                                          size: 30,
                                                                                          color: Colors.cyanAccent,
                                                                                        );
                                                                                      }
                                                                                    } else {
                                                                                      return Container();
                                                                                    }
                                                                                  },
                                                                                ),
                                                                                onTap:
                                                                                    () async {
                                                                                  try {
                                                                                    await FirebaseFirestore
                                                                                        .instance
                                                                                        .collection('users')
                                                                                        .doc(fullUserId())
                                                                                        .collection("savedElectronicProjects")
                                                                                        .doc(SubjectsData.id)
                                                                                        .get()
                                                                                        .then((docSnapshot) {
                                                                                      if (docSnapshot.exists) {
                                                                                        FirebaseFirestore.instance.collection('users').doc(fullUserId()).collection("savedElectronicProjects").doc(SubjectsData.id).delete();
                                                                                        showToast("Removed from saved list");
                                                                                      } else {
                                                                                        createsavedelectronicProjects(projectId: SubjectsData.id, user: fullUserId(), description: SubjectsData.description, photoUrl: SubjectsData.photoUrl, videoUrl: SubjectsData.youtubeUrl, heading: SubjectsData.heading, circuitDiagram: SubjectsData.circuitDiagram, creator: SubjectsData.creator, creatorPhoto: SubjectsData.creatorPhoto, sourceName: SubjectsData.sourceName, source: SubjectsData.source);
                                                                                        showToast("Added to Save List");
                                                                                      }
                                                                                    });
                                                                                  } catch (e) {
                                                                                    print(
                                                                                        e);
                                                                                  }
                                                                                },
                                                                              ),
                                                                            ],
                                                                          )
                                                                      ),
                                                                    ),

                                                                  ),
                                                                  const Spacer(),
                                                                  InkWell(
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.black.withOpacity(0.1),
                                                                        borderRadius: BorderRadius.circular(25),

                                                                      ),
                                                                      child: const Padding(
                                                                        padding:  EdgeInsets.all(3.5),
                                                                        child: Align(
                                                                          alignment: Alignment.topRight,
                                                                          child: Icon(Icons.add_shopping_cart,size: 30,color: Colors.white,),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    onTap: (){
                                                                      showToast("Coming Soon");
                                                                    },
                                                                  ),
                                                                ],
                                                              ),

                                                              const Spacer(),
                                                              Align(
                                                                alignment: Alignment.bottomLeft,
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.black.withOpacity(0.4),
                                                                    borderRadius: BorderRadius.circular(15),

                                                                  ),
                                                                  child: Padding(
                                                                    padding:  const EdgeInsets.all(4.0),
                                                                    child: Text(SubjectsData.heading,style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Colors.white), maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,),
                                                                  ),
                                                                ),

                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:  const EdgeInsets.only(left: 10,right: 10),
                                                          child: Text("by ${SubjectsData.creator}",style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 11,color: Color.fromRGBO(164, 209, 245,1)),
                                                            maxLines: 1,

                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                onTap: () async {
                                                  if (fullUserId()!=ownnerId) {
                                                    try {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                          "electronicProjects")
                                                          .doc(SubjectsData.id)
                                                          .get()
                                                          .then(
                                                              (docSnapshot) async {
                                                            if (docSnapshot
                                                                .exists) {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                  "electronicProjects")
                                                                  .doc(SubjectsData
                                                                  .id)
                                                                  .update({
                                                                "views": docSnapshot
                                                                    .data()![
                                                                "views"] +
                                                                    1
                                                              });
                                                              showToast("+1 view");
                                                            } else {
                                                              showToast(
                                                                  "Error with adding views");
                                                            }
                                                          });
                                                    } catch (e) {
                                                      if (kDebugMode) {
                                                        print(e);
                                                      }
                                                    }
                                                  }
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => electronicProject(youtubeUrl: SubjectsData.youtubeUrl,circuitDiagram:SubjectsData.circuitDiagram,id: SubjectsData.id,heading: SubjectsData.heading,description: SubjectsData.description,photoUrl: SubjectsData.photoUrl, creatorPhoto: SubjectsData.creatorPhoto,creator: SubjectsData.creator, source: SubjectsData.source,sourceName: SubjectsData.sourceName,)));

                                                },
                                              );
                                            }
                                            else {
                                              return Container();                                              }
                                          },

                                        ),
                                      ),

                                    ],
                                  );
                                }
                              }
                          }
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "All Electronic Projects",
                          style: TextStyle(fontSize: 25, color: Colors.black),
                        ),
                      ),
                      StreamBuilder<List<electronicProjectsConvertor>>(
                        stream: readelectronicProjects(),
                        builder: (context, snapshot) {
                          final Subjects = snapshot.data;
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 0.3,
                                color: Colors.cyan,
                              ));
                            default:
                              if (snapshot.hasError) {
                                return const Text("Error with server");
                              } else {
                                return AnimationLimiter(
                                  child: ListView.separated(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: Subjects!.length,
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final SubjectsData = Subjects[index];
                                        return AnimationConfiguration
                                            .staggeredList(
                                          position: index,
                                          duration:
                                              const Duration(milliseconds: 375),
                                          child: SlideAnimation(
                                            verticalOffset: 50.0,
                                            child: FadeInAnimation(
                                              child: InkWell(
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topRight,
                                                        end: Alignment
                                                            .bottomLeft,
                                                        colors: [
                                                          Colors.black38,
                                                          Colors.black38,
                                                          Colors.black87
                                                        ]),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Flexible(
                                                            flex: 4,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(0.3),
                                                              child: Container(
                                                                height: 150,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .black38,
                                                                  borderRadius: const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          15)),
                                                                  image:
                                                                      DecorationImage(
                                                                    image:
                                                                        NetworkImage(
                                                                      SubjectsData
                                                                          .photoUrl,
                                                                    ),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 2,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    SubjectsData
                                                                        .creator,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        color: Colors
                                                                            .lightBlue),
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                  Text(
                                                                    SubjectsData
                                                                        .sourceName,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        color: Colors
                                                                            .lightBlue),
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                  Center(
                                                                    child:
                                                                        InkWell(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(5.0),
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            gradient:
                                                                                LinearGradient(begin: Alignment.topLeft, end: Alignment.topRight, colors: [
                                                                              Colors.orange,
                                                                              Colors.red
                                                                            ]),
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(8.0)),
                                                                            color:
                                                                                Colors.blue,
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(4.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                StreamBuilder<DocumentSnapshot>(
                                                                                  stream: FirebaseFirestore.instance.collection("electronicProjects").doc(SubjectsData.id).collection("likes").doc(fullUserId()).snapshots(),
                                                                                  builder: (context, snapshot) {
                                                                                    if (snapshot.hasData) {
                                                                                      if (snapshot.data!.exists) {
                                                                                        return const Icon(Icons.thumb_up);
                                                                                      } else {
                                                                                        return const Icon(Icons.thumb_up_alt_outlined);
                                                                                      }
                                                                                    } else {
                                                                                      return const Icon(Icons.thumb_up_alt_outlined);
                                                                                    }
                                                                                  },
                                                                                ),
                                                                                StreamBuilder<QuerySnapshot>(
                                                                                  stream: FirebaseFirestore.instance.collection("electronicProjects").doc(SubjectsData.id).collection("likes").snapshots(),
                                                                                  builder: (context, snapshot) {
                                                                                    if (snapshot.hasData) {
                                                                                      return Text(
                                                                                        " ${snapshot.data!.docs.length}",
                                                                                        style: const TextStyle(fontSize: 20),
                                                                                      );
                                                                                    } else {
                                                                                      return const Text("0");
                                                                                    }
                                                                                  },
                                                                                ),
                                                                                const Text(" Likes", style: TextStyle(fontSize: 16))
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        updateLike(
                                                                            SubjectsData.id,
                                                                            fullUserId());
                                                                      },
                                                                    ),
                                                                  ),
                                                                  Center(
                                                                    child:
                                                                        InkWell(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                5,
                                                                            right:
                                                                                5,
                                                                            bottom:
                                                                                5),
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            gradient:
                                                                                LinearGradient(begin: Alignment.topLeft, end: Alignment.topRight, colors: [
                                                                              Colors.orange,
                                                                              Colors.red
                                                                            ]),
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(8.0)),
                                                                            color:
                                                                                Colors.blue,
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(5.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                StreamBuilder<DocumentSnapshot>(
                                                                                  stream: FirebaseFirestore.instance.collection('users').doc(fullUserId()).collection("savedElectronicProjects").doc(SubjectsData.id).snapshots(),
                                                                                  builder: (context, snapshot) {
                                                                                    if (snapshot.hasData) {
                                                                                      if (snapshot.data!.exists) {
                                                                                        return const Icon(
                                                                                          Icons.library_add_check,
                                                                                          size: 18,
                                                                                        );
                                                                                      } else {
                                                                                        return const Icon(
                                                                                          Icons.library_add_check_outlined,
                                                                                          size: 18,
                                                                                        );
                                                                                      }
                                                                                    } else {
                                                                                      return Container();
                                                                                    }
                                                                                  },
                                                                                ),
                                                                                const Text(" Save", style: TextStyle(fontSize: 16))
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () async {
                                                                        try {
                                                                          await FirebaseFirestore
                                                                              .instance
                                                                              .collection('users')
                                                                              .doc(fullUserId())
                                                                              .collection("savedElectronicProjects")
                                                                              .doc(SubjectsData.id)
                                                                              .get()
                                                                              .then((docSnapshot) {
                                                                            if (docSnapshot.exists) {
                                                                              FirebaseFirestore.instance.collection('users').doc(fullUserId()).collection("savedElectronicProjects").doc(SubjectsData.id).delete();
                                                                              showToast("Removed from saved list");
                                                                            } else {
                                                                              createsavedelectronicProjects(projectId: SubjectsData.id, user: fullUserId(), description: SubjectsData.description, photoUrl: SubjectsData.photoUrl, videoUrl: SubjectsData.youtubeUrl, heading: SubjectsData.heading, circuitDiagram: SubjectsData.circuitDiagram, creator: SubjectsData.creator, creatorPhoto: SubjectsData.creatorPhoto, sourceName: SubjectsData.sourceName, source: SubjectsData.source);
                                                                              showToast("Added to Save List");
                                                                            }
                                                                          });
                                                                        } catch (e) {
                                                                          print(
                                                                              e);
                                                                        }
                                                                      },
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .circle,
                                                                        size: 5,
                                                                        color: Colors
                                                                            .redAccent,
                                                                      ),
                                                                      StreamBuilder<
                                                                          DocumentSnapshot>(
                                                                        stream: FirebaseFirestore
                                                                            .instance
                                                                            .collection("electronicProjects")
                                                                            .doc(SubjectsData.id)
                                                                            .snapshots(),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          if (snapshot
                                                                              .hasData) {
                                                                            return Text(
                                                                              " ${snapshot.data!["views"]}",
                                                                              style: const TextStyle(fontSize: 11, color: Colors.lightBlueAccent),
                                                                            );
                                                                          } else {
                                                                            return const Text("0");
                                                                          }
                                                                        },
                                                                      ),
                                                                      const Padding(
                                                                        padding: EdgeInsets.only(
                                                                            right:
                                                                                8,
                                                                            left:
                                                                                3),
                                                                        child:
                                                                            Text(
                                                                          "views",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 11),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20,
                                                                right: 20,
                                                                bottom: 2),
                                                        child: Text(
                                                          SubjectsData.heading,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .white),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () async {
                                                  if (fullUserId()!=ownnerId) {
                                                    try {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "electronicProjects")
                                                          .doc(SubjectsData.id)
                                                          .get()
                                                          .then(
                                                              (docSnapshot) async {
                                                        if (docSnapshot
                                                            .exists) {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "electronicProjects")
                                                              .doc(SubjectsData
                                                                  .id)
                                                              .update({
                                                            "views": docSnapshot
                                                                        .data()![
                                                                    "views"] +
                                                                1
                                                          });
                                                          showToast("+1 view");
                                                        } else {
                                                          showToast(
                                                              "Error with adding views");
                                                        }
                                                      });
                                                    } catch (e) {
                                                      if (kDebugMode) {
                                                        print(e);
                                                      }
                                                    }
                                                  }
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              electronicProject(
                                                                youtubeUrl:
                                                                    SubjectsData
                                                                        .youtubeUrl,
                                                                circuitDiagram:
                                                                    SubjectsData
                                                                        .circuitDiagram,
                                                                id: SubjectsData
                                                                    .id,
                                                                heading:
                                                                    SubjectsData
                                                                        .heading,
                                                                description:
                                                                    SubjectsData
                                                                        .description,
                                                                photoUrl:
                                                                    SubjectsData
                                                                        .photoUrl,
                                                                creator:
                                                                    SubjectsData
                                                                        .creator,
                                                                creatorPhoto:
                                                                    SubjectsData
                                                                        .creatorPhoto,
                                                                source:
                                                                    SubjectsData
                                                                        .source,
                                                                sourceName:
                                                                    SubjectsData
                                                                        .sourceName,
                                                              )));
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                            height: 4,
                                          )),
                                );
                              }
                          }
                        },
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

Stream<List<electronicProjectsConvertor>> readelectronicProjects() =>
    FirebaseFirestore.instance
        .collection('electronicProjects')
        .orderBy("heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => electronicProjectsConvertor.fromJson(doc.data()))
            .toList());

Future createelectronicProjects(
    {required String videoUrl,
    required String description,
    required String photoUrl,
    required String heading,
    required String circuitDiagram,
    required String source,
    required String creator,
    required String creatorPhoto,
    required String sourceName,
    }) async {
  final docflash =
      FirebaseFirestore.instance.collection("electronicProjects").doc();
  final flash = electronicProjectsConvertor(
      id: docflash.id,
      heading: heading,
      description: description,
      photoUrl: photoUrl,
      circuitDiagram: circuitDiagram,
      youtubeUrl: videoUrl,
      source: source,
      creator: creator,
      creatorPhoto: creatorPhoto,
      sourceName: sourceName);
  final json = flash.toJson();
  await docflash.set(json);
}

class electronicProjectsConvertor {
  String id;
  final String heading,
      description,
      photoUrl,
      circuitDiagram,
      youtubeUrl,
      creator,
      creatorPhoto,
      source,
      sourceName;
  final bool home,sub;
  electronicProjectsConvertor(
      {this.id = "",
      required this.heading,
      required this.description,
      required this.sourceName,
      required this.photoUrl,
      required this.circuitDiagram,
      required this.youtubeUrl,
      required this.source,
      required this.creatorPhoto,
        this.home = false,
         this.sub = false,
      required this.creator});

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "description": description,
        "home":home,
        "sub":sub,
        "photoUrl": photoUrl,
        "videoUrl": youtubeUrl,
        "circuitDiagram": circuitDiagram,
        "creatorPhoto": creatorPhoto,
        "creator": creator,
        "source": source,
        "sourceName": sourceName
      };

  static electronicProjectsConvertor fromJson(Map<String, dynamic> json) =>
      electronicProjectsConvertor(
          sourceName: json["sourceName"],
          sub: json["sub"],
          home: json["home"],
          source: json["source"],
          creator: json["creator"],
          creatorPhoto: json["creatorPhoto"],
          id: json['id'],
          circuitDiagram: json["circuitDiagram"],
          youtubeUrl: json["videoUrl"],
          heading: json["heading"],
          description: json["description"],
          photoUrl: json["photoUrl"]);
}




class electronicProject extends StatefulWidget {
  String id,
      heading,
      description,
      photoUrl,
      circuitDiagram,
      youtubeUrl,
      creator,
      source,
      creatorPhoto,
      sourceName;

  electronicProject(
      {Key? key,
      required this.sourceName,
      required this.creator,
      required this.creatorPhoto,
      required this.source,
      required this.id,
      required this.heading,
      required this.description,
      required this.photoUrl,
      required this.circuitDiagram,
      required this.youtubeUrl})
      : super(key: key);

  @override
  State<electronicProject> createState() => _electronicProjectState();
}

class _electronicProjectState extends State<electronicProject> {
  late bool like = false;
  late int likeCount = 0;
  late YoutubePlayerController _controller;
  final data1 = TextEditingController();
  final data2 = TextEditingController();
  final data3 = TextEditingController();
  final data4 = TextEditingController();

  @override
  void initState() {
    final videoID = YoutubePlayer.convertUrlToId(widget.youtubeUrl);
    _controller = YoutubePlayerController(
        initialVideoId: videoID!,
        flags: const YoutubePlayerFlags(autoPlay: false));
    super.initState();
  }

  @override
  void dispose() {
    data1.dispose();
    data3.dispose();
    data4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(53, 166, 204, 1),
                  Color.fromRGBO(24, 45, 74, 1),
                  Color.fromRGBO(21, 47, 61, 1)
                ]),
          ),
          child: Column(
            children: [
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Text(
                  widget.heading,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w500),
                ),
              )),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.heading,style: const TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.white),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration:  BoxDecoration(
                            borderRadius:const BorderRadius.only(
                              topRight: Radius.circular(15.0),
                              topLeft: Radius.circular(27.0),
                              bottomRight: Radius.circular(15.0),
                              bottomLeft: Radius.circular(15.0)
                            ),
                            color: Colors.black.withOpacity(0.3),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             Row(
                               children: [
                                 Padding(
                                   padding: const EdgeInsets.all(2.0),
                                   child: Container(
                                     decoration:  BoxDecoration(
                                       borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                       color: Colors.black.withOpacity(0.3),
                                       image: DecorationImage(image: NetworkImage(widget.creatorPhoto),
                                       fit: BoxFit.fill,
                                       filterQuality: FilterQuality.low)
                                     ),
                                     height:50,
                                     width: 50,
                                   ),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.only(left: 10,top: 3),
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     children: [
                                       Text(
                                         widget.creator,
                                         style: const TextStyle(
                                             color: Colors.white,
                                             fontSize: 22)
                                         , overflow: TextOverflow.ellipsis,
                                       ),
                                       Row(
                                         children: [
                                           Row(
                                             mainAxisAlignment: MainAxisAlignment.end,
                                             children:  [
                                               const Icon(Icons.circle,size: 5,color: Colors.redAccent,),
                                               StreamBuilder<DocumentSnapshot>(
                                                 stream: FirebaseFirestore.instance
                                                     .collection("electronicProjects").doc(widget.id)
                                                     .snapshots(),
                                                 builder: (context, snapshot) {
                                                   if (snapshot.hasData) {
                                                     return Text(" ${snapshot.data!["views"]}",style: const TextStyle(fontSize: 11,color: Colors.lightBlueAccent),);
                                                   } else {
                                                     return const Text("0");
                                                   }
                                                 },
                                               ),
                                               const Padding(
                                                 padding: EdgeInsets.only(right: 8,left: 3),
                                                 child: Text("views",style: TextStyle(color: Colors.white,fontSize: 13),),
                                               ),
                                             ],
                                           ),
                                           const Padding(
                                             padding: EdgeInsets.only(left: 15,right: 5),
                                             child: Icon(Icons.circle,size: 8,),
                                           ),
                                           InkWell(child: Text(widget.sourceName,style:const TextStyle(color: Colors.white,fontSize: 16),),onTap: (){
                                             _externalLaunchUrl(widget.source);
                                           },)
                                         ],
                                       )
                                     ],
                                   ),
                                 )
                               ],
                             ),
                              Row(
                                children: [
                                  const Spacer(),
                                  InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.topRight,
                                              colors: [Colors.orange, Colors.red]
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                          color: Colors.blue,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            children: [
                                              StreamBuilder<DocumentSnapshot>(
                                                stream: FirebaseFirestore.instance
                                              .collection("electronicProjects").doc(widget.id).collection("likes").doc(fullUserId())
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    if(snapshot.data!.exists) {
                                                      return const Icon(
                                                          Icons.thumb_up,size: 18,);
                                                    }else{
                                                      return const  Icon(Icons.thumb_up_alt_outlined,size: 18,);
                                                    }
                                                  } else {
                                                    return Container();
                                                  }
                                                },
                                              ),
                                              StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore.instance
                                                    .collection("electronicProjects").doc(widget.id).collection("likes")
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Text(" ${snapshot.data!.docs.length}",style: const TextStyle(fontSize: 16),);
                                                  } else {
                                                    return const Text("0");
                                                  }
                                                },
                                              ),
                                              const Text(" Likes",style: TextStyle(fontSize: 16))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: (){
                                      updateLike(widget.id,fullUserId());
                                    },
                                  ),
                                  const SizedBox(width: 10,),
                                  InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.topRight,
                                              colors: [Colors.orange, Colors.red]
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                          color: Colors.blue,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              StreamBuilder<DocumentSnapshot>(
                                                stream: FirebaseFirestore.instance
                                                    .collection('users').doc(fullUserId()).collection("savedElectronicProjects").doc(widget.id)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    if(snapshot.data!.exists) {
                                                      return const Icon(
                                                        Icons.library_add_check,size: 18,);
                                                    }else{
                                                      return const  Icon(Icons.library_add_check_outlined,size: 18,);
                                                    }
                                                  } else {
                                                    return Container();
                                                  }
                                                },
                                              ),
                                              const Text(" Save",style: TextStyle(fontSize: 16))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: ()async{
                                      try {
                                        await FirebaseFirestore.instance.collection('users').doc(fullUserId()).collection("savedElectronicProjects").doc(widget.id).get().then((docSnapshot) {
                                          if (docSnapshot.exists) {
                                            FirebaseFirestore.instance.collection('users').doc(fullUserId()).collection("savedElectronicProjects").doc(widget.id).delete();
                                            showToast("Removed from saved list");
                                          }else{
                                            createsavedelectronicProjects(projectId:widget.id,user:fullUserId(),description: widget.description,photoUrl: widget.photoUrl,videoUrl: widget.youtubeUrl,heading: widget.heading,circuitDiagram: widget.circuitDiagram,creator: widget.creator,creatorPhoto: widget.creatorPhoto,sourceName: widget.sourceName,source: widget.source);
                                            showToast("Added to Save List");
                                          }
                                        });
                                      } catch (e) {
                                        print(e);
                                      }

                                    },
                                  ),
                                  const SizedBox(width: 10,),
                                  InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.topRight,
                                              colors: [Colors.orange, Colors.red]
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                          color: Colors.blue,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 12,top: 5,bottom: 5,right: 12),
                                          child: Row(
                                            children: const [
                                              Icon(Icons.add_shopping_cart,size: 18,),
                                              Text(" Cart"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: (){
                                      showToast("Coming Soon");
                                    },
                                  ),
                                  const Spacer(),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      if (fullUserId()==ownnerId)Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          decoration:  BoxDecoration(
                            borderRadius:const  BorderRadius.all(Radius.circular(15.0)),
                            color: Colors.black.withOpacity(0.3),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding:  EdgeInsets.only(left: 10,top: 5),
                                child: Text("Add to ...",style: TextStyle(fontSize: 15,color: Colors.white),),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.topRight,
                                                colors: [Colors.orange, Colors.red]
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                            color: Colors.blue,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("Treading"),
                                          ),
                                        ),
                                      ),
                                      onTap: (){
                                        createtreadingProjects(projectId:widget.id,heading: widget.heading, description: widget.description, photoUrl: widget.photoUrl, videoUrl: widget.youtubeUrl,circuitDiagram: widget.circuitDiagram,mode: "ep",creator: "");
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.topRight,
                                                colors: [Colors.orange, Colors.red]
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                            color: Colors.blue,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("Status"),
                                          ),
                                        ),
                                      ),
                                      onTap: (){
                                        createStatus(heading: widget.heading,description: widget.description,projectId: widget.id,mode: "ep",photoUrl: widget.photoUrl,videoUrl: widget.youtubeUrl,circuitDiagram: widget.circuitDiagram);
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.topRight,
                                                colors: [Colors.orange, Colors.red]
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                            color: Colors.blue,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("Sub Page"),
                                          ),
                                        ),
                                      ),
                                      onTap: (){
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.topRight,
                                                colors: [Colors.orange, Colors.red]
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                            color: Colors.blue,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("Home Page"),
                                          ),
                                        ),
                                      ),
                                      onTap: (){
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      StreamBuilder<List<electronicProjectTableOfContentConvertor>>(
                        stream: readelectronicProjectTableOfContent(widget.id),
                        builder: (context, snapshot) {
                          final Subjects = snapshot.data;
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 0.3,
                                    color: Colors.cyan,
                                  ));
                            default:
                              if (snapshot.hasError) {
                                return const Text("Error with server");
                              }
                              else {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text("Table of Content : ",style: TextStyle(fontSize: 23,fontWeight: FontWeight.w500,color: Colors.white),),
                                          const Spacer(),
                                          if (fullUserId()==ownnerId)InkWell(
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 15),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.topRight,
                                                      colors: [Colors.orange, Colors.red]
                                                  ),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  color: Colors.blue,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 5,right: 5,top: 3,bottom: 3),
                                                  child: Row(
                                                    children: const [
                                                      Text(" Add "),
                                                      Icon(Icons.add,size: 20,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: (){
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    backgroundColor: Colors.black.withOpacity(0.3),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                    elevation: 16,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.white38),
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      child: ListView(
                                                        shrinkWrap: true,
                                                        children: <Widget>[
                                                          const Center(
                                                            child: Padding(
                                                              padding: EdgeInsets.all(8.0),
                                                              child: Text("Table of Content", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300, color: Colors.blue),),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding: EdgeInsets.only(left: 15, top: 5),
                                                            child: Text(
                                                              "Name",
                                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 5),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.white60,
                                                                border: Border.all(color: Colors.white),
                                                                borderRadius: BorderRadius.circular(14),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 20),
                                                                child: TextFormField(
                                                                  controller: data1,
                                                                  textInputAction: TextInputAction.next,
                                                                  decoration: const InputDecoration(
                                                                    border: InputBorder.none,
                                                                    hintText: 'Name',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:  EdgeInsets.only(left: 15, top: 5),
                                                            child: Text(
                                                              "Index",
                                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 15),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.white60,
                                                                border: Border.all(color: Colors.white),
                                                                borderRadius: BorderRadius.circular(14),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 20),
                                                                child: TextFormField(
                                                                  controller: data2,
                                                                  textInputAction: TextInputAction.next,
                                                                  decoration: const InputDecoration(
                                                                    border: InputBorder.none,
                                                                    hintText: 'Index',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          Row(
                                                            children: [
                                                              const Spacer(),
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(15),
                                                                    color: Colors.white.withOpacity(0.5),
                                                                    border: Border.all(color: Colors.white),
                                                                  ),
                                                                  child: const Padding(
                                                                    padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                                                    child: Text("Back"),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              InkWell(
                                                                  onTap: () {
                                                                    createelectronicProjectTableOfContent(index:data2.text.trim(),projectId: widget.id,heading: data1.text.trim());
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(15),
                                                                      color: Colors.white.withOpacity(0.5),
                                                                      border: Border.all(color: Colors.white),
                                                                    ),
                                                                    child: const Padding(
                                                                      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                                                      child: Text("Create"),
                                                                    ),
                                                                  )
                                                              ),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 10,)
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );

                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20,right: 10),
                                        child: ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: Subjects!.length,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context, int index) {
                                            final SubjectsData = Subjects[index];
                                            return Row(
                                              children: [
                                                const Icon(Icons.circle,size: 5,color: Colors.white,),
                                                const SizedBox(width: 10,),
                                                Text(SubjectsData.name,style: const TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w300),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                                const SizedBox(width: 10,),
                                                const Spacer(),
                                                if (fullUserId()==ownnerId)InkWell(
                                                    child: const Icon(Icons.delete,color: Colors.red,size: 22,),
                                                onTap: (){
                                                  FirebaseFirestore.instance.collection('electronicProjects').doc(widget.id).collection("tableOfContent").doc(SubjectsData.id).delete();
                                                  showToast("${SubjectsData.name} has been Deleted");
                                                },
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                          }
                        },
                      ),
                      if(widget.photoUrl.isNotEmpty)const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Image : ",style: TextStyle(fontSize: 23,fontWeight: FontWeight.w500,color: Colors.white),),
                      ),
                      if(widget.photoUrl.isNotEmpty)Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          child: Container(
                            height: 250,
                            alignment:
                            Alignment.center,
                            decoration:
                            BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(widget.photoUrl),
                                  fit: BoxFit.cover,
                                )),),
                          onTap: (){
                          showToast(longPressToViewImage);
                          },
                          onLongPress: (){
                            if(widget.photoUrl.length>3) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        zoom(url: widget.photoUrl)
                                ));
                            }else{
                              showToast(noImageUrl);
                            }

                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Description",style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.w500),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10,bottom: 25),
                        child: Text("              ${widget.description}",style: const TextStyle(fontSize: 16,fontWeight:FontWeight.w300,color: Colors.white),),
                      ),
                      StreamBuilder<List<electronicProjectrequiredComponentsConvertor>>(
                        stream: readelectronicProjectrequiredComponents(widget.id),
                        builder: (context, snapshot) {
                          final Subjects = snapshot.data;
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 0.3,
                                    color: Colors.cyan,
                                  ));
                            default:
                              if (snapshot.hasError) {
                                return const Text("Error with server");
                              }
                              else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                     Padding(
                                      padding: const EdgeInsets.only(left: 8,bottom: 10),
                                      child: Row(
                                        children: [
                                          const Text("Required Components",style: TextStyle(fontSize: 23,fontWeight: FontWeight.w500,color: Colors.white),),
                                          const Spacer(),
                                          if (fullUserId()==ownnerId)InkWell(
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 15),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.topRight,
                                                      colors: [Colors.orange, Colors.red]
                                                  ),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  color: Colors.blue,
                                                ),
                                                child: Padding(
                                                  padding:const EdgeInsets.only(left: 5,right: 5,top: 3,bottom: 3),
                                                  child: Row(
                                                    children: const[
                                                      Text(" Add "),
                                                      Icon(Icons.add,size: 20,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: (){
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    backgroundColor: Colors.black.withOpacity(0.3),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                    elevation: 16,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.white38),
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      child: ListView(
                                                        shrinkWrap: true,
                                                        children: <Widget>[
                                                          const Center(
                                                            child: Padding(
                                                              padding:  EdgeInsets.all(8.0),
                                                              child:  Text("Table of Content", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300, color: Colors.blue),),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:  EdgeInsets.only(left: 15, top: 5),
                                                            child: Text(
                                                              "Name",
                                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 5),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.white60,
                                                                border: Border.all(color: Colors.white),
                                                                borderRadius: BorderRadius.circular(14),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 20),
                                                                child: TextFormField(
                                                                  controller: data1,
                                                                  textInputAction: TextInputAction.next,
                                                                  decoration:const InputDecoration(
                                                                    border: InputBorder.none,
                                                                    hintText: 'Name',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding: EdgeInsets.only(left: 15, top: 5),
                                                            child: Text(
                                                              "Photo Url",
                                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 5),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.white60,
                                                                border: Border.all(color: Colors.white),
                                                                borderRadius: BorderRadius.circular(14),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 20),
                                                                child: TextFormField(
                                                                  controller: data2,
                                                                  textInputAction: TextInputAction.next,
                                                                  decoration:const InputDecoration(
                                                                    border: InputBorder.none,
                                                                    hintText: 'photo url',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:  EdgeInsets.only(left: 15, top: 5),
                                                            child: Text(
                                                              "Index",
                                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 15),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.white60,
                                                                border: Border.all(color: Colors.white),
                                                                borderRadius: BorderRadius.circular(14),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 20),
                                                                child: TextFormField(
                                                                  controller: data3,
                                                                  textInputAction: TextInputAction.next,
                                                                  decoration:const InputDecoration(
                                                                    border: InputBorder.none,
                                                                    hintText: 'Index',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          Row(
                                                            children: [
                                                              const Spacer(),
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(15),
                                                                    color: Colors.white.withOpacity(0.5),
                                                                    border: Border.all(color: Colors.white),
                                                                  ),
                                                                  child: const Padding(
                                                                    padding:  EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                                                    child: Text("Back"),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              InkWell(
                                                                  onTap: () {
                                                                    createelectronicProjectrequiredComponent(index:data3.text.trim(),projectId: widget.id,heading: data1.text.trim(),photoUrl: data2.text.trim());
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(15),
                                                                      color: Colors.white.withOpacity(0.5),
                                                                      border: Border.all(color: Colors.white),
                                                                    ),
                                                                    child: const Padding(
                                                                      padding:  EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                                                      child: Text("Add"),
                                                                    ),
                                                                  )
                                                              ),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 10,)
                                                        ],
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
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20,right: 10),
                                      child: ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: Subjects!.length,
                                        shrinkWrap: true,
                                        itemBuilder: (BuildContext context, int index) {
                                          final SubjectsData = Subjects[index];
                                          return InkWell(
                                            child: Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.circle,size: 5,color: Colors.white,),
                                                  const SizedBox(width: 5,),
                                                  Expanded(child: Text(SubjectsData.name,style:const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w300),)),
                                                  const Spacer(),
                                                  if (fullUserId()==ownnerId)InkWell(
                                                    child: const Icon(Icons.delete,color: Colors.red,size: 22,),
                                                    onTap: (){
                                                      FirebaseFirestore.instance.collection('electronicProjects').doc(widget.id).collection("requiredComponents").doc(SubjectsData.id).delete();
                                                      showToast("${SubjectsData.name} has been Deleted");
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onTap: (){
showToast(longPressToViewImage);
                                            },
                                            onLongPress: (){
                                              if(SubjectsData.photoUrl.length>3){
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            zoom(url: SubjectsData.photoUrl)
                                                    ));
                                              }
                                              else{
                                                showToast(noImageUrl);
                                              }
                                            },
                                          );
                                        },
                                        // separatorBuilder: (context, index) =>const Divider(),
                                      ),
                                    ),
                                  ],
                                );
                              }
                          }
                        },
                      ),
                      if(widget.circuitDiagram.isNotEmpty)const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Circuit Diagram : ",style: TextStyle(fontSize: 23,fontWeight: FontWeight.w500,color: Colors.white),),
                      ),
                      if(widget.circuitDiagram.isNotEmpty)Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Container(
                            height: 250,
                            alignment:
                            Alignment.center,
                            decoration:
                            BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(widget.circuitDiagram),
                                  fit: BoxFit.cover,
                                )),),
                          onTap: (){
                            showToast(longPressToViewImage);
                          },
                          onLongPress: (){
                            if(widget.circuitDiagram.length>3) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        zoom(url: widget.circuitDiagram)
                                ));
                            }
                            else{
                              showToast(noImageUrl);
                            }
                          },
                        ),
                      ),
                      StreamBuilder<List<electronicProjecttoolsRequiredConvertor>>(
                        stream: readelectronicProjecttoolsRequired(widget.id),
                        builder: (context, snapshot) {
                          final Subjects = snapshot.data;
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 0.3,
                                    color: Colors.cyan,
                                  ));
                            default:
                              if (snapshot.hasError) {
                                return const Text("Error with server");
                              }
                              else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                      Padding(
                                      padding:const EdgeInsets.only(left: 8,top: 13),
                                      child: Row(
                                        children: [
                                          const Text("Tools Required",style: TextStyle(fontSize: 23,fontWeight: FontWeight.w500,color: Colors.white),),
                                          const Spacer(),
                                          if (fullUserId()==ownnerId)InkWell(
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 20),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.topRight,
                                                      colors: [Colors.orange, Colors.red]
                                                  ),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                  color: Colors.blue,
                                                ),
                                                child: Padding(
                                                  padding:const EdgeInsets.only(left: 5,right: 5,top: 3,bottom: 3),
                                                  child: Row(
                                                    children: const [
                                                      Text(" Add "),
                                                      Icon(Icons.add,size: 20,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: (){
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    backgroundColor: Colors.black.withOpacity(0.3),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                    elevation: 16,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.white38),
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      child: ListView(
                                                        shrinkWrap: true,
                                                        children: <Widget>[
                                                          const Center(
                                                            child: Padding(
                                                              padding:  EdgeInsets.all(8.0),
                                                              child:  Text("Tools Required", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300, color: Colors.blue),),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:  EdgeInsets.only(left: 15, top: 5),
                                                            child: Text(
                                                              "Name",
                                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 5),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.white54,
                                                                border: Border.all(color: Colors.white),
                                                                borderRadius: BorderRadius.circular(14),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 20),
                                                                child: TextFormField(
                                                                  controller: data1,
                                                                  textInputAction: TextInputAction.next,
                                                                  decoration:const InputDecoration(
                                                                    border: InputBorder.none,
                                                                    hintText: 'Name',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:  EdgeInsets.only(left: 15, top: 5),
                                                            child: Text(
                                                              "Photo Url",
                                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 5),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.white54,
                                                                border: Border.all(color: Colors.white),
                                                                borderRadius: BorderRadius.circular(14),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 20),
                                                                child: TextFormField(
                                                                  controller: data2,
                                                                  textInputAction: TextInputAction.next,
                                                                  decoration:const InputDecoration(
                                                                    border: InputBorder.none,
                                                                    hintText: 'photo url',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding: EdgeInsets.only(left: 15, top: 5),
                                                            child: Text(
                                                              "Index",
                                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 15),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.white54,
                                                                border: Border.all(color: Colors.white),
                                                                borderRadius: BorderRadius.circular(14),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 20),
                                                                child: TextFormField(
                                                                  controller: data3,
                                                                  textInputAction: TextInputAction.next,
                                                                  decoration: const InputDecoration(
                                                                    border: InputBorder.none,
                                                                    hintText: 'Index',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          Row(
                                                            children: [
                                                              const Spacer(),
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(15),
                                                                    color: Colors.white.withOpacity(0.5),
                                                                    border: Border.all(color: Colors.white),
                                                                  ),
                                                                  child: const Padding(
                                                                    padding:  EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                                                    child: Text("Back"),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              InkWell(
                                                                  onTap: () {
                                                                    createelectronicProjecttoolsRequired(index:data3.text.trim(),id: widget.id,name: data1.text.trim(),photoUrl: data2.text.trim());
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(15),
                                                                      color: Colors.white.withOpacity(0.5),
                                                                      border: Border.all(color: Colors.white),
                                                                    ),
                                                                    child: const Padding(
                                                                      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                                                      child: Text("Add"),
                                                                    ),
                                                                  )
                                                              ),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 10,)
                                                        ],
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
                                    const SizedBox(height: 10,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20,right: 10),
                                      child: ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: Subjects!.length,
                                        shrinkWrap: true,
                                        itemBuilder: (BuildContext context, int index) {
                                          final SubjectsData = Subjects[index];
                                          return InkWell(
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.circle,size: 5,color: Colors.white,),
                                                  const SizedBox(width: 5,),
                                                  Text(SubjectsData.name,style:const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w300),),
                                                  const Spacer(),
                                                  if (fullUserId()==ownnerId)InkWell(
                                                    child:const Icon(Icons.delete,color: Colors.red,size: 22,),
                                                    onTap: (){
                                                      FirebaseFirestore.instance.collection('electronicProjects').doc(widget.id).collection("toolsRequired").doc(SubjectsData.id).delete();
                                                      showToast("${SubjectsData.name} has been Deleted");
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onTap: (){
                                              showToast(longPressToViewImage);
                                            },
                                            onLongPress: (){
                                              if(SubjectsData.photoUrl.length>3) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          zoom(url: SubjectsData.photoUrl)
                                                  ));
                                              } else{
                                                showToast(noImageUrl);
                                              }

                                            },
                                          );
                                        },
                                        // separatorBuilder: (context, index) =>const Divider(),
                                      ),
                                    ),
                                  ],
                                );
                              }
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 13,left: 10),
                        child: Row(
                          children: [
                            const Text("Demo Video",style: TextStyle(fontSize: 23,fontWeight: FontWeight.w500,color: Colors.white),),
                            const SizedBox(width: 20,),
                            SizedBox(
                                height: 25,
                                child: Image.network("https://ghiencongnghe.info/wp-content/uploads/2021/02/bia-youtube-la-gi.gif"))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8,bottom: 15),
                        child: YoutubePlayer(
                          controller: _controller,
                          showVideoProgressIndicator: true,
                          onReady: ()=>debugPrint("Ready"),
                          bottomActions: [
                            CurrentPosition(),
                            ProgressBar(
                              isExpanded: true,
                              colors: const ProgressBarColors(
                                playedColor: Colors.amber,
                                handleColor: Colors.amberAccent
                              ),
                            ),
                            const PlaybackSpeedButton(),
                            FullScreenButton()
                          ],
                        ),
                      ),
                      StreamBuilder<List<electronicProjectDownloadConvertor>>(
                        stream: readelectronicProjectDownload(widget.id),
                        builder: (context, snapshot) {
                          final Subjects = snapshot.data;
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 0.3,
                                color: Colors.cyan,
                              ));
                            default:
                              if (snapshot.hasError) {
                                return const Text("Error with server");
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Downloads",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                          Spacer(),
                                          if (fullUserId()==ownnerId)InkWell(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.topRight,
                                                      colors: [
                                                        Colors.orange,
                                                        Colors.red
                                                      ]),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  color: Colors.blue,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5,
                                                          right: 5,
                                                          top: 3,
                                                          bottom: 3),
                                                  child: Row(
                                                    children: const [
                                                      Text(" Add "),
                                                      Icon(
                                                        Icons.add,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    backgroundColor: Colors.black.withOpacity(0.3),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    elevation: 16,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .white38),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: ListView(
                                                        shrinkWrap: true,
                                                        children: <Widget>[
                                                          const Center(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                "Add Downloads",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        22,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 15,
                                                                    top: 5),
                                                            child: Text(
                                                              "Name",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10,
                                                                    right: 10,
                                                                    top: 3,
                                                                    bottom: 5),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white60,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            14),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            20),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      data1,
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .next,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        'Name',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 15,
                                                                    top: 5),
                                                            child: Text(
                                                              "Description",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10,
                                                                    right: 10,
                                                                    top: 3,
                                                                    bottom: 5),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white60,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            14),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            20),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      data2,
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .next,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        'Description',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 15,
                                                                    top: 5),
                                                            child: Text(
                                                              "Link",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10,
                                                                    right: 10,
                                                                    top: 3,
                                                                    bottom: 5),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white60,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            14),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            20),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      data3,
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .next,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        'link',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Spacer(),
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.5),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  child:
                                                                      const Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                        top: 5,
                                                                        bottom:
                                                                            5),
                                                                    child: Text(
                                                                        "Back"),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              InkWell(
                                                                  onTap: () {
                                                                    createelectronicProjectDownload(
                                                                        link: data3
                                                                            .text
                                                                            .trim(),
                                                                        id: widget
                                                                            .id,
                                                                        heading: data1
                                                                            .text
                                                                            .trim(),
                                                                        description: data2
                                                                            .text
                                                                            .trim());
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.5),
                                                                      border: Border.all(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    child:
                                                                        const Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10,
                                                                          top:
                                                                              5,
                                                                          bottom:
                                                                              5),
                                                                      child: Text(
                                                                          "Add"),
                                                                    ),
                                                                  )),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          )
                                                        ],
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
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 5),
                                      child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: Subjects!.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final SubjectsData = Subjects[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          border: Border.all(
                                                              color: const Color
                                                                      .fromRGBO(
                                                                  174,
                                                                  228,
                                                                  242,
                                                                  0.1)),
                                                          gradient: const LinearGradient(
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .topRight,
                                                              colors: [
                                                                Colors.orange,
                                                                Colors.red
                                                              ]),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: const [
                                                                  Icon(
                                                                    Icons
                                                                        .download_outlined,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 25,
                                                                  ),
                                                                  Text(
                                                                    "Download",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        if (SubjectsData
                                                            .link.isNotEmpty) {
                                                          _externalLaunchUrl(SubjectsData.link);
                                                        } else {
                                                          showToast(
                                                              "No Link Available");
                                                        }
                                                      },
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            SubjectsData.name,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          const Divider(
                                                            color:
                                                                Colors.white60,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Text(
                                                    "                ${SubjectsData.description}",
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white60),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }
                          }
                        },
                      ),
                      StreamBuilder<List<electronicProjectTagsConvertor>>(
                        stream: readelectronicProjectTags(widget.id),
                        builder: (context, snapshot) {
                          final Subjects = snapshot.data;
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 0.3,
                                color: Colors.cyan,
                              ));
                            default:
                              if (snapshot.hasError) {
                                return const Text("Error with server");
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Tags",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                          const Spacer(),
                                          if (fullUserId()==ownnerId)InkWell(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.topRight,
                                                      colors: [
                                                        Colors.orange,
                                                        Colors.red
                                                      ]),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  color: Colors.blue,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5,
                                                          right: 5,
                                                          top: 3,
                                                          bottom: 3),
                                                  child: Row(
                                                    children: const [
                                                      Text(" Add "),
                                                      Icon(
                                                        Icons.add,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    backgroundColor: Colors.black.withOpacity(0.3),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    elevation: 16,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .white24),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: ListView(
                                                        shrinkWrap: true,
                                                        children: <Widget>[
                                                          const Center(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                "Add Tags" ,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        22,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 15,
                                                                    top: 5),
                                                            child: Text(
                                                              "Name",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .white70),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10,
                                                                    right: 10,
                                                                    top: 3,
                                                                    bottom: 5),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white54,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white10),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            14),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            20),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      data1,
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .next,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        'Name',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Spacer(),
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.5),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  child:
                                                                      const Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                        top: 5,
                                                                        bottom:
                                                                            5),
                                                                    child: Text(
                                                                        "Back"),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              InkWell(
                                                                  onTap: () {
                                                                    createelectronicProjectTags(
                                                                        id: widget
                                                                            .id,
                                                                        heading: data1
                                                                            .text
                                                                            .trim());
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.5),
                                                                      border: Border.all(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    child:
                                                                        const Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10,
                                                                          top:
                                                                              5,
                                                                          bottom:
                                                                              5),
                                                                      child: Text(
                                                                          "Add"),
                                                                    ),
                                                                  )),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          )
                                                        ],
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
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 10),
                                      child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: Subjects!.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final SubjectsData = Subjects[index];
                                          return InkWell(
                                            child: Row(
                                              children: [
                                                Text(
                                                  "# ${SubjectsData.name}",
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.blue),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const Spacer(),
                                                if (fullUserId()==ownnerId)InkWell(
                                                    child: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                      size: 22,
                                                    ),
                                                    onTap: () {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'electronicProjects')
                                                          .doc(widget.id)
                                                          .collection("tags")
                                                          .doc(SubjectsData.id)
                                                          .delete();
                                                      showToast(
                                                          "${SubjectsData.name} has been Deleted");
                                                    },
                                                  ),
                                              ],
                                            ),
                                            onTap: (){

                                              showToast("Coming Soon...");
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }
                          }
                        },
                      ),
                      StreamBuilder<List<electronicProjectsConvertor>>(
                        stream: readotherelectronicProjects(id: widget.id),
                        builder: (context, snapshot) {
                          final Subjects = snapshot.data;
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 0.3,
                                color: Colors.cyan,
                              ));
                            default:
                              if (snapshot.hasError) {
                                return const Text("Error with server");
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10, top: 13),
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Other Projects",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                          const Spacer(),
                                          if (fullUserId()==ownnerId)InkWell(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.topRight,
                                                      colors: [
                                                        Colors.orange,
                                                        Colors.red
                                                      ]),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  color: Colors.blue,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5,
                                                          right: 5,
                                                          top: 3,
                                                          bottom: 3),
                                                  child: Row(
                                                    children: const [
                                                      Text(" Add "),
                                                      Icon(
                                                        Icons.add,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    backgroundColor: Colors
                                                        .black
                                                        .withOpacity(0.1),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    elevation: 16,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.1)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: ListView(
                                                        physics: BouncingScrollPhysics(),
                                                        shrinkWrap: true,
                                                        children: <Widget>[
                                                          const Center(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                "Add to Other Projects",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        22,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                            ),
                                                          ),
                                                          StreamBuilder<
                                                              List<
                                                                  electronicProjectsConvertor>>(
                                                            stream:
                                                                readelectronicProjects(),
                                                            builder: (context,
                                                                snapshot) {
                                                              final Subjects =
                                                                  snapshot.data;
                                                              switch (snapshot
                                                                  .connectionState) {
                                                                case ConnectionState
                                                                    .waiting:
                                                                  return const Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        0.3,
                                                                    color: Colors
                                                                        .cyan,
                                                                  ));
                                                                default:
                                                                  if (snapshot
                                                                      .hasError) {
                                                                    return const Text(
                                                                        "Error with server");
                                                                  } else {
                                                                    return ListView.separated(
                                                                        physics: const BouncingScrollPhysics(),
                                                                        itemCount: Subjects!.length,
                                                                        shrinkWrap: true,
                                                                        padding: const EdgeInsets.only(left: 5, right: 5),
                                                                        itemBuilder: (BuildContext context, int index) {
                                                                          final SubjectsData =
                                                                              Subjects[index];
                                                                          return Container(
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                              borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                              gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [
                                                                                Colors.black38,
                                                                                Colors.black38,
                                                                                Colors.black87
                                                                              ]),
                                                                            ),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Container(
                                                                                  decoration: BoxDecoration(
                                                                                    border: Border.all(color: Color.fromRGBO(174, 228, 242, 0.3)),
                                                                                    color: Colors.black38,
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                                    image: DecorationImage(
                                                                                      image: NetworkImage(
                                                                                        SubjectsData.photoUrl,
                                                                                      ),
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                  height: 40,
                                                                                  width: 70,
                                                                                ),
                                                                                Expanded(
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Text(
                                                                                        SubjectsData.heading,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                      InkWell(
                                                                                        child: Container(
                                                                                          decoration: const BoxDecoration(
                                                                                            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.topRight, colors: [
                                                                                              Colors.orange,
                                                                                              Colors.red
                                                                                            ]),
                                                                                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                                                            color: Colors.blue,
                                                                                          ),
                                                                                          child: const Padding(
                                                                                            padding: const EdgeInsets.all(5.0),
                                                                                            child: const Text("+ Add"),
                                                                                          ),
                                                                                        ),
                                                                                        onTap: () {
                                                                                          createotherelectronicProjects(projectId: widget.id,id: SubjectsData.id, videoUrl: SubjectsData.youtubeUrl, description: SubjectsData.description, photoUrl: SubjectsData.photoUrl, heading: SubjectsData.heading, circuitDiagram: SubjectsData.circuitDiagram, source: SubjectsData.source, creator: SubjectsData.creator, creatorPhoto: SubjectsData.creatorPhoto, sourceName: SubjectsData.sourceName);
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                        separatorBuilder: (context, index) => const SizedBox(
                                                                              height: 4,
                                                                            ));
                                                                  }
                                                              }
                                                            },
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          )
                                                        ],
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
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 10),
                                      child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: Subjects!.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final SubjectsData = Subjects[index];
                                          return Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: InkWell(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: Colors.black
                                                          .withOpacity(0.4),
                                                      border: Border.all(
                                                          color: const Color
                                                                  .fromRGBO(174,
                                                              228, 242, 0.5)),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          SubjectsData.photoUrl,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      SubjectsData.heading,
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.red),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            electronicProject(
                                                              youtubeUrl: SubjectsData.youtubeUrl,
                                                              circuitDiagram: SubjectsData.circuitDiagram,
                                                              id: SubjectsData.id,
                                                              heading: SubjectsData.heading,
                                                              description: SubjectsData.description,
                                                              photoUrl: SubjectsData.photoUrl,
                                                              creator: SubjectsData.creator,
                                                              creatorPhoto: SubjectsData.creatorPhoto,
                                                              source: SubjectsData.source,
                                                              sourceName: SubjectsData.sourceName,
                                                            )
                                                    ));
                                              },
                                              onLongPress: (){
                                                FirebaseFirestore.instance
                                                    .collection(
                                                    'electronicProjects')
                                                    .doc(widget.id)
                                                    .collection("otherProjects")
                                                    .doc(SubjectsData.id)
                                                    .delete();
                                                showToast(
                                                    "${SubjectsData.heading} has been Deleted");
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    )
                                  ],
                                );
                              }
                          }
                        },
                      )
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

updateLike(String documentId, String user) async {
  try {
    await FirebaseFirestore.instance
        .collection("electronicProjects")
        .doc(documentId)
        .collection("likes")
        .doc(user)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        FirebaseFirestore.instance
            .collection("electronicProjects")
            .doc(documentId)
            .collection("likes")
            .doc(user)
            .delete();
        showToast("Unliked");
      } else {
        FirebaseFirestore.instance
            .collection("electronicProjects")
            .doc(documentId)
            .collection("likes")
            .doc(user)
            .set({"id": user});
        showToast("Liked");
      }
    });
  } catch (e) {
    print(e);
  }
}

Stream<List<electronicProjectDownloadConvertor>> readelectronicProjectDownload(
        String id) =>
    FirebaseFirestore.instance
        .collection("electronicProjects")
        .doc(id)
        .collection("downloads")
        .orderBy("name", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                electronicProjectDownloadConvertor.fromJson(doc.data()))
            .toList());

Future createelectronicProjectDownload(
    {required String id,
    required String heading,
    required String description,
    required String link}) async {
  final docflash = FirebaseFirestore.instance
      .collection("electronicProjects")
      .doc(id)
      .collection("downloads")
      .doc();
  final flash = electronicProjectDownloadConvertor(
      id: docflash.id, name: heading, link: link, description: description);
  final json = flash.toJson();
  await docflash.set(json);
}

class electronicProjectDownloadConvertor {
  String id;
  final String name, link, description;

  electronicProjectDownloadConvertor(
      {this.id = "",
      required this.name,
      required this.link,
      required this.description});

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "link": link, "description": description};

  static electronicProjectDownloadConvertor fromJson(
          Map<String, dynamic> json) =>
      electronicProjectDownloadConvertor(
          id: json['id'],
          name: json["name"],
          link: json["link"],
          description: json["description"]);
}

Stream<List<electronicProjectTableOfContentConvertor>>
    readelectronicProjectTableOfContent(String id) => FirebaseFirestore.instance
        .collection('electronicProjects')
        .doc(id)
        .collection("tableOfContent")
        .orderBy("index", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                electronicProjectTableOfContentConvertor.fromJson(doc.data()))
            .toList());

Future createelectronicProjectTableOfContent(
    {required String projectId,
    required String heading,
    required String index}) async {
  final docflash = FirebaseFirestore.instance
      .collection('electronicProjects')
      .doc(projectId)
      .collection("tableOfContent")
      .doc();
  final flash = electronicProjectTableOfContentConvertor(
      id: docflash.id, name: heading, index: index);
  final json = flash.toJson();
  await docflash.set(json);
}

class electronicProjectTableOfContentConvertor {
  String id;
  final String name;
  final String index;

  electronicProjectTableOfContentConvertor(
      {this.id = "", required this.name, required this.index});

  Map<String, dynamic> toJson() => {"id": id, "name": name, "index": index};

  static electronicProjectTableOfContentConvertor fromJson(
          Map<String, dynamic> json) =>
      electronicProjectTableOfContentConvertor(
          index: json["index"], id: json['id'], name: json["name"]);
}

Stream<List<electronicProjectrequiredComponentsConvertor>>
    readelectronicProjectrequiredComponents(String id) => FirebaseFirestore
        .instance
        .collection('electronicProjects')
        .doc(id)
        .collection("requiredComponents")
        .orderBy("index", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => electronicProjectrequiredComponentsConvertor
                .fromJson(doc.data()))
            .toList());

Future createelectronicProjectrequiredComponent(
    {required String projectId,
    required String heading,
    required String photoUrl,
    required String index}) async {
  final docflash = FirebaseFirestore.instance
      .collection('electronicProjects')
      .doc(projectId)
      .collection("requiredComponents")
      .doc();
  final flash = electronicProjectrequiredComponentsConvertor(
      id: docflash.id, name: heading, index: index, photoUrl: photoUrl);
  final json = flash.toJson();
  await docflash.set(json);
}

class electronicProjectrequiredComponentsConvertor {
  String id;
  final String name, photoUrl, index;

  electronicProjectrequiredComponentsConvertor(
      {this.id = "",
      required this.name,
      required this.index,
      required this.photoUrl});

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "index": index, "photoUrl": photoUrl};

  static electronicProjectrequiredComponentsConvertor fromJson(
          Map<String, dynamic> json) =>
      electronicProjectrequiredComponentsConvertor(
          id: json['id'],
          name: json["name"],
          photoUrl: json["photoUrl"],
          index: json["index"]);
}

Stream<List<electronicProjecttoolsRequiredConvertor>>
    readelectronicProjecttoolsRequired(String id) => FirebaseFirestore.instance
        .collection('electronicProjects')
        .doc(id)
        .collection("toolsRequired")
        .orderBy("name", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                electronicProjecttoolsRequiredConvertor.fromJson(doc.data()))
            .toList());

Future createelectronicProjecttoolsRequired(
    {required String id,
    required String name,
    required String index,
    required String photoUrl}) async {
  final docflash = FirebaseFirestore.instance
      .collection('electronicProjects')
      .doc(id)
      .collection("toolsRequired")
      .doc();
  final flash = electronicProjecttoolsRequiredConvertor(
      id: docflash.id, name: name, index: index, photoUrl: photoUrl);
  final json = flash.toJson();
  await docflash.set(json);
}

class electronicProjecttoolsRequiredConvertor {
  String id;
  final String name, photoUrl, index;

  electronicProjecttoolsRequiredConvertor(
      {this.id = "",
      required this.name,
      required this.photoUrl,
      required this.index});

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "photoUrl": photoUrl, "index": index};

  static electronicProjecttoolsRequiredConvertor fromJson(
          Map<String, dynamic> json) =>
      electronicProjecttoolsRequiredConvertor(
          id: json['id'],
          name: json["name"],
          photoUrl: json["photoUrl"],
          index: json["index"]);
}

Stream<List<electronicProjectTagsConvertor>> readelectronicProjectTags(
        String id) =>
    FirebaseFirestore.instance
        .collection('electronicProjects')
        .doc(id)
        .collection("tags")
        .orderBy("name", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => electronicProjectTagsConvertor.fromJson(doc.data()))
            .toList());

Future createelectronicProjectTags(
    {required String id, required String heading}) async {
  final docflash = FirebaseFirestore.instance
      .collection('electronicProjects')
      .doc(id)
      .collection("tags")
      .doc();
  final flash = electronicProjectTagsConvertor(id: docflash.id, name: heading);
  final json = flash.toJson();
  await docflash.set(json);
}

class electronicProjectTagsConvertor {
  String id;
  final String name;

  electronicProjectTagsConvertor({this.id = "", required this.name});

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  static electronicProjectTagsConvertor fromJson(Map<String, dynamic> json) =>
      electronicProjectTagsConvertor(id: json['id'], name: json["name"]);
}

Stream<List<electronicProjectsConvertor>> readotherelectronicProjects(
        {required String id}) =>
    FirebaseFirestore.instance
        .collection('electronicProjects')
        .doc(id)
        .collection("otherProjects")
        .orderBy("heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => electronicProjectsConvertor.fromJson(doc.data()))
            .toList());

Future createotherelectronicProjects(
    {required String videoUrl,
      required String projectId,
    required String id,
    required String description,
    required String photoUrl,
    required String heading,
    required String circuitDiagram,
    required String source,
    required String creator,
    required String creatorPhoto,
    required String sourceName}) async {
  final docflash = FirebaseFirestore.instance
      .collection('electronicProjects')
      .doc(projectId)
      .collection("otherProjects")
      .doc(id);
  final flash = electronicProjectsConvertor(
      id: id,
      heading: heading,
      description: description,
      photoUrl: photoUrl,
      circuitDiagram: circuitDiagram,
      youtubeUrl: videoUrl,
      source: source,
      creator: creator,
      creatorPhoto: creatorPhoto,
      sourceName: sourceName);
  final json = flash.toJson();
  await docflash.set(json);
}
_externalLaunchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn, mode: LaunchMode.externalApplication))
    throw 'Could not launch $urlIn';
}