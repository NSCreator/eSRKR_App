// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'arduino.dart';
import 'electronicProjects.dart';

class saveCartList extends StatefulWidget {
  const saveCartList({Key? key}) : super(key: key);

  @override
  State<saveCartList> createState() => _saveCartListState();
}

class _saveCartListState extends State<saveCartList> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: InkWell(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                                colors: [Colors.orange, Colors.red]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            color: Colors.blue,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Saved"),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            index = 0;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: InkWell(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight,
                                  colors: [Colors.orange, Colors.red]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              color: Colors.blue,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("  Cart  "),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              index = 1;
                            });
                          }),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index == 0)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "Arduino Projects",
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "Other Projects",
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            StreamBuilder<
                                List<savedelectronicProjectsConvertor>>(
                              stream: readsavedelectronicProjects(
                                  "sujithnimmala03@gmail.com"),
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
                                      return ListView.separated(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: Subjects!.length,
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final SubjectsData =
                                                Subjects[index];
                                            return Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topRight,
                                                    end: Alignment.bottomLeft,
                                                    colors: [
                                                      Colors.black38,
                                                      Colors.black38,
                                                      Colors.black87
                                                    ]),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color
                                                                  .fromRGBO(174,
                                                              228, 242, 0.3)),
                                                      color: Colors.black38,
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  15)),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          SubjectsData.photoUrl,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    height: 60,
                                                    width: 90,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          SubjectsData.heading,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 17),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Flexible(
                                                              flex: 1,
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    SubjectsData
                                                                        .creator,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                  Text(
                                                                    SubjectsData
                                                                        .sourceName,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Flexible(
                                                              flex: 1,
                                                              child: InkWell(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 5,
                                                                      right: 5,
                                                                      bottom:
                                                                          5),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      gradient: LinearGradient(
                                                                          begin:
                                                                              Alignment.topLeft,
                                                                          end: Alignment.topRight,
                                                                          colors: [
                                                                            Colors.orange,
                                                                            Colors.red
                                                                          ]),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(9.0)),
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              5.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          StreamBuilder<
                                                                              DocumentSnapshot>(
                                                                            stream:
                                                                                FirebaseFirestore.instance.collection('users').doc("sujithnimmala03@gmail.com").collection("savedElectronicProjects").doc(SubjectsData.id).snapshots(),
                                                                            builder:
                                                                                (context, snapshot) {
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
                                                                          const Text(
                                                                              " Save",
                                                                              style: TextStyle(fontSize: 16))
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
                                                                        .collection(
                                                                            'users')
                                                                        .doc(
                                                                            "sujithnimmala03@gmail.com")
                                                                        .collection(
                                                                            "savedElectronicProjects")
                                                                        .doc(SubjectsData
                                                                            .id)
                                                                        .get()
                                                                        .then(
                                                                            (docSnapshot) {
                                                                      if (docSnapshot
                                                                          .exists) {
                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection('users')
                                                                            .doc("sujithnimmala03@gmail.com")
                                                                            .collection("savedElectronicProjects")
                                                                            .doc(SubjectsData.id)
                                                                            .delete();
                                                                        showToast(
                                                                            "Removed from saved list");
                                                                      } else {
                                                                        createsavedelectronicProjects(
                                                                            projectId: SubjectsData
                                                                                .id,
                                                                            user:
                                                                                "sujithnimmala03@gmail.com",
                                                                            description:
                                                                                SubjectsData.description,
                                                                            photoUrl: SubjectsData.photoUrl,
                                                                            videoUrl: SubjectsData.youtubeUrl,
                                                                            heading: SubjectsData.heading,
                                                                            circuitDiagram: SubjectsData.circuitDiagram,
                                                                            creator: SubjectsData.creator,
                                                                            creatorPhoto: SubjectsData.creatorPhoto,
                                                                            sourceName: SubjectsData.sourceName,
                                                                            source: SubjectsData.source);
                                                                        showToast(
                                                                            "Added to Save List");
                                                                      }
                                                                    });
                                                                  } catch (e) {
                                                                    if (kDebugMode) {
                                                                      print(e);
                                                                    }
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(
                                                height: 4,
                                              ));
                                    }
                                }
                              },
                            )
                          ],
                        )
                      else
                        Center(
                          child: Text("Coming Soon"),
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Stream<List<savedelectronicProjectsConvertor>> readsavedelectronicProjects(
        String user) =>
    FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .collection("savedElectronicProjects")
        .orderBy("heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => savedelectronicProjectsConvertor.fromJson(doc.data()))
            .toList());

Future createsavedelectronicProjects(
    {required String projectId,
    required String user,
    required String videoUrl,
    required String description,
    required String photoUrl,
    required String heading,
    required String circuitDiagram,
    required String source,
    required String creator,
    required String creatorPhoto,
    required String sourceName}) async {
  final docflash = FirebaseFirestore.instance
      .collection('users')
      .doc(user)
      .collection("savedElectronicProjects")
      .doc(projectId);
  final flash = savedelectronicProjectsConvertor(
      id: projectId,
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

class savedelectronicProjectsConvertor {
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

  savedelectronicProjectsConvertor(
      {this.id = "",
      required this.heading,
      required this.description,
      required this.sourceName,
      required this.photoUrl,
      required this.circuitDiagram,
      required this.youtubeUrl,
      required this.source,
      required this.creatorPhoto,
      required this.creator});

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "description": description,
        "photoUrl": photoUrl,
        "videoUrl": youtubeUrl,
        "circuitDiagram": circuitDiagram,
        "creatorPhoto": creatorPhoto,
        "creator": creator,
        "source": source,
        "sourceName": sourceName,
      };

  static savedelectronicProjectsConvertor fromJson(Map<String, dynamic> json) =>
      savedelectronicProjectsConvertor(
          sourceName: json["sourceName"],
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
