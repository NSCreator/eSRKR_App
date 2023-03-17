// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names, import_of_legacy_library_into_null_safe

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'homepage.dart';

class Arduino extends StatefulWidget {
  const Arduino({Key? key}) : super(key: key);

  @override
  State<Arduino> createState() => _ArduinoState();
}

class _ArduinoState extends State<Arduino> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade700,
      body: SafeArea(
        child: Column(
          children: [
            const Center(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Arduino",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            )),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: InkWell(
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://ettron.com/wp-content/uploads/2021/07/different-types-of-Arduino-boards.jpg",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                color: Colors.black.withOpacity(0.7),
                                child: const Text(
                                  "Arduino Boards",
                                  style: TextStyle(
                                    fontSize: 35.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey.withOpacity(0.8),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(7)),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 40,
                                      color: Colors.white,
                                    )),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const arduinoBoards()));
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: InkWell(
                        child: Container(
                          height: 80,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://fiverr-res.cloudinary.com/images/t_main1,q_auto,f_auto,q_auto,f_auto/gigs/140496134/original/0d28d0884a323fd151c9e6fae143352ab0978f72/deliver-a-proof-of-concept-design-for-electronics-arduino.png",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                color: Colors.black.withOpacity(0.7),
                                child: const Text(
                                  "Arduino Projects",
                                  style: TextStyle(
                                    fontSize: 35.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey.withOpacity(0.8),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(7)),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 40,
                                      color: Colors.white,
                                    )),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const arduinoProjects()));
                        },
                      ),
                    ),
                    StreamBuilder<List<arduinoSubPageProjectsConvertor>>(
                      stream: readarduinoSubPageProjects(),
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
                              if (Subjects!.isNotEmpty) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, top: 20, bottom: 8),
                                      child: Text(
                                        "Mostly Viewed Projects",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 30,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: GridView.builder(
                                          scrollDirection: Axis.vertical,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing: 5,
                                            childAspectRatio: 1.02,
                                          ),
                                          itemCount: Subjects.length,
                                          itemBuilder:
                                              (BuildContext ctx, index) {
                                            return InkWell(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black38,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 130,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .black54,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      NetworkImage(
                                                                    Subjects[
                                                                            index]
                                                                        .photoUrl,
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            3.0),
                                                                    child: Container(
                                                                        decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.1),
                                                                          borderRadius:
                                                                              BorderRadius.circular(15),
                                                                        ),
                                                                        child: Column(
                                                                          children: const [
                                                                            Icon(
                                                                              Icons.favorite_border,
                                                                              size: 30,
                                                                              color: Colors.red,
                                                                            ),
                                                                            Icon(
                                                                              Icons.library_add_check_outlined,
                                                                              size: 30,
                                                                              color: Colors.tealAccent,
                                                                            ),
                                                                          ],
                                                                        )),
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.1),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25),
                                                                  ),
                                                                  child:
                                                                      const Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            3.5),
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .add_shopping_cart,
                                                                        size:
                                                                            30,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 5,
                                                                right: 5,
                                                                bottom: 3,
                                                                top: 5),
                                                        child: Text(
                                                          Subjects[index]
                                                              .heading,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10,
                                                                right: 10,
                                                                bottom: 1),
                                                        child: Text(
                                                          "by : ${Subjects[index].creator}",
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .white54),
                                                          maxLines: 1,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              arduinoProject(
                                                                youtubeUrl:
                                                                    Subjects[
                                                                            index]
                                                                        .videoUrl,
                                                                id: Subjects[
                                                                        index]
                                                                    .projectId,
                                                                heading: Subjects[
                                                                        index]
                                                                    .heading,
                                                                description: Subjects[
                                                                        index]
                                                                    .description,
                                                                photoUrl: Subjects[
                                                                        index]
                                                                    .photoUrl,
                                                                creator: Subjects[
                                                                        index]
                                                                    .creator,
                                                              )));
                                                });
                                          }),
                                    ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
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
    );
  }
}

class arduinoBoards extends StatefulWidget {
  const arduinoBoards({Key? key}) : super(key: key);

  @override
  State<arduinoBoards> createState() => _arduinoBoardsState();
}

class _arduinoBoardsState extends State<arduinoBoards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade700,
      body: SafeArea(
        child: Column(
          children: [
            const Center(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Arduino Board",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
            )),
            Expanded(
              child: StreamBuilder<List<arduinoBoardsConvertor>>(
                stream: readarduinoBoards(),
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
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              itemBuilder: (BuildContext context, int index) {
                                final SubjectsData = Subjects[index];
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: InkWell(
                                        child: Container(
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
                                            // color: Colors.black,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 250,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black38,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        SubjectsData.photoUrl,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Container(
                                                      width: double.infinity,
                                                      // height: 50,
                                                      decoration:
                                                          const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        15),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            15)),
                                                        gradient:
                                                            LinearGradient(
                                                                begin: Alignment
                                                                    .topRight,
                                                                end: Alignment
                                                                    .bottomLeft,
                                                                colors: [
                                                              Colors.black12,
                                                              Colors.black38,
                                                              Colors.black54
                                                            ]),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          SubjectsData.name,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 28.0,
                                                            color: Colors
                                                                .tealAccent,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 2),
                                                child: Text(
                                                  SubjectsData.description,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      arduinoBoard(
                                                        pinDiagram: SubjectsData
                                                            .pinDiagram,
                                                        mainFeatures:
                                                            SubjectsData
                                                                .mainFeatures,
                                                        id: SubjectsData.id,
                                                        heading:
                                                            SubjectsData.name,
                                                        description:
                                                            SubjectsData
                                                                .description,
                                                        photoUrl: SubjectsData
                                                            .photoUrl,
                                                      )));
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: 10,
                                    child: Divider(
                                      color: Colors.blue,
                                    ),
                                  )),
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Stream<List<arduinoBoardsConvertor>> readarduinoBoards() =>
    FirebaseFirestore.instance
        .collection('arduino')
        .doc("arduinoBoards")
        .collection("Board")
        .orderBy("name", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => arduinoBoardsConvertor.fromJson(doc.data()))
            .toList());

Future createarduinoBoards(
    {required String name,
    required String description,
    required String photoUrl,
    required String mainFeatures,
    required String pinDiagram}) async {
  final docflash =
      FirebaseFirestore.instance
          .collection('arduino')
          .doc("arduinoBoards")
          .collection("Board").doc();
  final flash = arduinoBoardsConvertor(
      id: docflash.id,
      name: name,
      description: description,
      photoUrl: photoUrl,
      mainFeatures: mainFeatures,
      pinDiagram: pinDiagram);
  final json = flash.toJson();
  await docflash.set(json);
}

class arduinoBoardsConvertor {
  String id;
  final String name, description, photoUrl, mainFeatures, pinDiagram;

  arduinoBoardsConvertor(
      {this.id = "",
      required this.name,
      required this.description,
      required this.photoUrl,
      required this.pinDiagram,
      required this.mainFeatures});

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "photoUrl": photoUrl,

      };

  static arduinoBoardsConvertor fromJson(Map<String, dynamic> json) =>
      arduinoBoardsConvertor(
          id: json['id'],
          name: json["name"],
          description: json["description"],
          photoUrl: json["photoUrl"],
          pinDiagram: json["pinDiagram"],
          mainFeatures: json["mainFeatures"]);
}

class arduinoBoard extends StatefulWidget {
  String id, heading, description, photoUrl, mainFeatures, pinDiagram;

  arduinoBoard(
      {Key? key,
      required this.id,
      required this.heading,
      required this.description,
      required this.photoUrl,
      required this.mainFeatures,
      required this.pinDiagram})
      : super(key: key);

  @override
  State<arduinoBoard> createState() => _arduinoBoardState();
}

class _arduinoBoardState extends State<arduinoBoard> {
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
            children: [
              Text(
                widget.heading,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.heading,
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500,color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 5, right: 5, bottom: 5),
                        child: Text(widget.description,  style: const TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w400,color: Colors.white),),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        height: 230,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black.withOpacity(0.4),
                          border: Border.all(color: const Color.fromRGBO(174, 228, 242,0.5)),
                          image: DecorationImage(
                            image: NetworkImage(
                              widget.photoUrl,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      StreamBuilder<List<arduinoBoardMainFeaturesConvertor>>(
                        stream: readarduinoBoardMainFeatures(widget.id),
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

                                    if (widget.mainFeatures.isNotEmpty)
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, top: 15, bottom: 5),
                                        child: Text(
                                          "Main Features",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500,color: Colors.white),
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(
                                          "          ${widget.mainFeatures}" , style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.w400,color: Colors.white),),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 10,top: 20),
                                      child: ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: Subjects!.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final SubjectsData = Subjects[index];
                                          return Column(
                                            children: [
                                              Container(
                                                height: 100,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  color: Colors.black.withOpacity(0.4),
                                                  border: Border.all(color: const Color.fromRGBO(174, 228, 242,0.5)),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      "http://drive.google.com/uc?export=view&id=${SubjectsData.photoUrl}",
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(top: 10,bottom: 5),
                                                child: Text(
                                                  SubjectsData.heading,
                                                  style: TextStyle(
                                                      fontSize: 23,
                                                      fontWeight:
                                                          FontWeight.w700,color: Colors.white),
                                                ),
                                              ),
                                              Text(
                                                "     ${SubjectsData.description}",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w400,color: Colors.white),
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            const Divider(),
                                      ),
                                    ),
                                  ],
                                );
                              }
                          }
                        },
                      ),
                      if(widget.pinDiagram.isNotEmpty)Padding(
                        padding: EdgeInsets.only(left: 10, top: 20, bottom: 8),
                        child: Text(
                          "Pin Diagram",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500,color: Colors.white),
                        ),
                      ),
                      Image.network(widget.pinDiagram),
                      Center(
                          child: Text(
                        "---${widget.heading}---",
                        style: const TextStyle(fontSize: 10,color: Colors.white),
                      )),
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

Stream<List<arduinoBoardMainFeaturesConvertor>> readarduinoBoardMainFeatures(
        String id) =>
    FirebaseFirestore.instance
        .collection('arduino')
        .doc("arduinoBoards")
        .collection("Board")
        .doc(id)
        .collection("mainFeatures")
        .orderBy("heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(
                (doc) => arduinoBoardMainFeaturesConvertor.fromJson(doc.data()))
            .toList());

Future createarduinoBoardMainFeatures(
    {required String heading,
    required String description,
    required String quantity}) async {
  final docflash =
      FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = arduinoBoardMainFeaturesConvertor(
      id: docflash.id,
      heading: heading,
      description: description,
      photoUrl: quantity);
  final json = flash.toJson();
  await docflash.set(json);
}

class arduinoBoardMainFeaturesConvertor {
  String id;
  final String heading, photoUrl, description;

  arduinoBoardMainFeaturesConvertor(
      {this.id = "",
      required this.heading,
      required this.photoUrl,
      required this.description});

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "photoUrl": photoUrl,
        "description": description
      };

  static arduinoBoardMainFeaturesConvertor fromJson(
          Map<String, dynamic> json) =>
      arduinoBoardMainFeaturesConvertor(
          id: json['id'],
          heading: json["heading"],
          photoUrl: json["photoUrl"],
          description: json["description"]);
}

class arduinoProjects extends StatefulWidget {
  const arduinoProjects({Key? key}) : super(key: key);

  @override
  State<arduinoProjects> createState() => _arduinoProjectsState();
}

class _arduinoProjectsState extends State<arduinoProjects> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade700,
      body: SafeArea(
        child: Column(
          children: [
            const Center(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Arduino Projects",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
            )),
            Expanded(
              child: StreamBuilder<List<arduinoProjectsConvertor>>(
                stream: readarduinoProjects(),
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
                              itemBuilder: (BuildContext context, int index) {
                                final SubjectsData = Subjects[index];
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: InkWell(
                                        child: Container(
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
                                            // color: Colors.black,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 200,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.black38,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(15)),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      SubjectsData.photoUrl,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 150,
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      height: 50,
                                                      decoration:
                                                          const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        15),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            15)),
                                                        gradient:
                                                            LinearGradient(
                                                                begin: Alignment
                                                                    .topRight,
                                                                end: Alignment
                                                                    .bottomLeft,
                                                                colors: [
                                                              Colors.black12,
                                                              Colors.black38,
                                                              Colors.black54
                                                            ]),
                                                        // color: Colors.black,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10,
                                                                top: 5,
                                                                bottom: 3,
                                                                right: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              SubjectsData
                                                                  .heading,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 28.0,
                                                                color: Colors
                                                                    .tealAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Spacer(),
                                                                Text(
                                                                  "by : ${SubjectsData.creator}",
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        11.0,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
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
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 2),
                                                child: Text(
                                                  SubjectsData.description,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      arduinoProject(
                                                        id: SubjectsData.id,
                                                        heading: SubjectsData
                                                            .heading,
                                                        description:
                                                            SubjectsData
                                                                .description,
                                                        photoUrl: SubjectsData
                                                            .photoUrl,
                                                        youtubeUrl: SubjectsData
                                                            .videoUrl,
                                                      )));
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: 10,
                                    child: Divider(
                                      color: Colors.blue,
                                    ),
                                  )),
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class arduinoProject extends StatefulWidget {
  String id, heading, description, photoUrl, youtubeUrl, creator;

  arduinoProject(
      {Key? key,
      required this.id,
      required this.heading,
      this.creator = "",
      required this.description,
      required this.photoUrl,
      required this.youtubeUrl})
      : super(key: key);

  @override
  State<arduinoProject> createState() => _arduinoProjectState();
}

class _arduinoProjectState extends State<arduinoProject> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    final videoID = YoutubePlayer.convertUrlToId(widget.youtubeUrl);
    _controller = YoutubePlayerController(
        initialVideoId: videoID!,
        flags: const YoutubePlayerFlags(autoPlay: false));
    super.initState();
  }

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
            children: [
              Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: [Colors.orange, Colors.red]),
                  ),
                  child: Center(
                      child: Text(
                    widget.heading,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w500),
                  ))),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Text(
                          widget.heading,
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500,color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: const Color.fromRGBO(174, 228, 242,0.1)),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                                colors: [Colors.orange, Colors.red]),
                          ),
                          child: Row(
                            children:  [
                              CircleAvatar(radius: 20,backgroundImage: NetworkImage("https://secure.gravatar.com/avatar/25a55eac98738e7b7e188d701e36045a?s=64&d=mm&r=g"),),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("widget.creator"),
                                  Row(
                                    children: [
                                      Icon(Icons.thumb_up_alt_outlined,size: 25,),
                                      SizedBox(width: 3,),
                                      Text("2",style: TextStyle(fontSize: 20),),
                                      SizedBox(width: 30,),
                                      Icon(Icons.library_add_check_outlined,size: 25,),
                                      Icon(Icons.add_shopping_cart_outlined,size: 25,)

                                    ],
                                  ),
                                ],
                              )],
                          ),
                        ),
                      ),
                      if(true)Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Tap to Add...",style: TextStyle(color: Colors.white,fontSize: 20),),
                            SizedBox(height: 8,),
                            Row(
                              children: [
                                InkWell(
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
                                      child: Text("Treading"),
                                    ),
                                  ),
                                  onTap: () {
                                    createtreadingProjects(
                                        projectId: widget.id,
                                        heading: widget.heading,
                                        description: widget.description,
                                        creator: widget.creator,
                                        photoUrl: widget.photoUrl,
                                        videoUrl: widget.youtubeUrl,
                                        circuitDiagram: "",
                                        mode: "a");
                                    showToast("Added to Treading");
                                  },
                                ),
                                InkWell(
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
                                      child: Text("Status"),
                                    ),
                                  ),
                                  onTap: () {
                                    createStatus(
                                        heading: widget.heading,
                                        description: widget.description,
                                        projectId: widget.id,
                                        mode: "arduino",
                                        photoUrl: widget.photoUrl,
                                        videoUrl: widget.youtubeUrl,
                                        circuitDiagram: "");
                                    showToast("Added to Status");
                                  },
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                InkWell(
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
                                      child: Text("SubPage"),
                                    ),
                                  ),
                                  onTap: () {
                                    createarduinoSubPageProjects(
                                      projectId: widget.id,
                                      heading: widget.heading,
                                      description: widget.description,
                                      creator: widget.creator,
                                      photoUrl: widget.photoUrl,
                                      videoUrl: widget.youtubeUrl,
                                    );
                                    showToast("Added to Arduino Page");
                                  },
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                InkWell(
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
                                      child: Text("HomePage"),
                                    ),
                                  ),
                                  onTap: () {
                                    createarduinoHomePageProjects(
                                        heading: widget.heading,
                                        description: widget.description,
                                        creator: widget.creator,
                                        photoUrl: widget.photoUrl,
                                        videoUrl: widget.youtubeUrl,
                                        projectId: widget.id);
                                    showToast("Added to Home Page");
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 10, top: 10, bottom: 10),
                        child: Text(
                          "     ${widget.description}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400,color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.black.withOpacity(0.4),
                            border: Border.all(
                                color:
                                    const Color.fromRGBO(174, 228, 242, 0.5)),
                            image: DecorationImage(
                              image: NetworkImage(
                                widget.photoUrl,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder<
                          List<arduinoProjectTableOfContentConvertor>>(
                        stream: readarduinoProjectTableOfContent(widget.id),
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
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, top: 8),
                                      child: Text(
                                        "Table of Content : ",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 10),
                                      child: ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: Subjects!.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final SubjectsData = Subjects[index];
                                          return Row(
                                            children: [
                                              const Icon(
                                                Icons.circle,
                                                size: 15,
                                                color: Colors.white70,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                SubjectsData.name,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              )
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            const Divider(),
                                      ),
                                    ),
                                  ],
                                );
                              }
                          }
                        },
                      ),
                      StreamBuilder<List<arduinoProjectComponentConvertor>>(
                        stream: readarduinoProjectComponent(widget.id),
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
                                    const Text(
                                      "Components",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 10),
                                      child: ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: Subjects!.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final SubjectsData = Subjects[index];
                                          return Row(
                                            children: [
                                              Text("${SubjectsData.quantity}",
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.red)),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                SubjectsData.name,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(
                                                width: 30,
                                              )
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            const Divider(),
                                      ),
                                    ),
                                  ],
                                );
                              }
                          }
                        },
                      ),
                      if (widget.photoUrl.isNotEmpty)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Pin or Circuit Diagram",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                height: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.black.withOpacity(0.4),
                                  border: Border.all(
                                      color:
                                      const Color.fromRGBO(174, 228, 242, 0.5)),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      widget.photoUrl,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      StreamBuilder<List<arduinoProjectPinConnectionConvertor>>(
                        stream: readarduinoProjectPinConnection(widget.id),
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
                                      padding: const EdgeInsets.only(top: 10,),
                                      child: const Text(
                                        "Pin Connections",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w500,color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 10),
                                      child: ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: Subjects!.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final SubjectsData = Subjects[index];
                                          return Row(
                                            children: [
                                              const Icon(
                                                Icons.circle,
                                                size: 15,
                                                color: Colors.white70,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                SubjectsData.name,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(
                                                width: 30,
                                              )
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            const Divider(),
                                      ),
                                    ),
                                  ],
                                );
                              }
                          }
                        },
                      ),
                      StreamBuilder<List<arduinoProjectDescriptionConvertor>>(
                        stream: readarduinoProjectDescription(widget.id),
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
                                    const Padding(
                                      padding:  EdgeInsets.only(top: 10,left: 10),
                                      child:  Text(
                                        "Project Description",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w500,color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: Subjects!.length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final SubjectsData = Subjects[index];
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10,top: 3,bottom: 3),
                                              child: Text(SubjectsData.heading,
                                                  style: const TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.white,fontWeight: FontWeight.w500)),
                                            ),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 15,right: 15),
                                              child: Container(
                                                height: 240,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.black
                                                      .withOpacity(0.4),
                                                  border: Border.all(
                                                      color:
                                                          const Color.fromRGBO(
                                                              174,
                                                              228,
                                                              242,
                                                              0.5)),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      SubjectsData.photoUrl,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                                              child: Text(
                                                "          ${SubjectsData.description}",
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                );
                              }
                          }
                        },
                      ),
                      if (widget.youtubeUrl.isNotEmpty)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Demo Video",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w500,color: Colors.white),
                              ),
                            ),
                            YoutubePlayer(
                              controller: _controller,
                              showVideoProgressIndicator: true,
                              onReady: () => debugPrint("Ready"),
                              bottomActions: [
                                CurrentPosition(),
                                ProgressBar(
                                  isExpanded: true,
                                  colors: const ProgressBarColors(
                                      playedColor: Colors.amber,
                                      handleColor: Colors.amberAccent),
                                ),
                                const PlaybackSpeedButton(),
                                FullScreenButton()
                              ],
                            ),
                          ],
                        ),
                      StreamBuilder<List<arduinoProjectDownloadConvertor>>(
                        stream: readarduinoProjectDownload(widget.id),
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
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Downloads",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w500,color: Colors.white),
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
                                            padding: const EdgeInsets.only(top: 8,),
                                            child: Row(
                                              children: [
                                               InkWell(
                                                 child: Container(
                                                   decoration: BoxDecoration(
                                                     borderRadius: BorderRadius.circular(15),
                                                     border: Border.all(color: const Color.fromRGBO(174, 228, 242,0.1)),
                                                     gradient: LinearGradient(
                                                         begin: Alignment.topLeft,
                                                         end: Alignment.topRight,
                                                         colors: [Colors.orange, Colors.red]),
                                                   ),
                                                   child: Padding(
                                                     padding: const EdgeInsets.all(5.0),
                                                     child: Row(
                                                       children: [
                                                         Icon(Icons.download_outlined,color: Colors.white,size: 25,),
                                                         Text("Download",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),)
                                                       ],
                                                     ),
                                                   ),
                                                 ),
                                                 onTap: (){
                                                   if(SubjectsData.link.isNotEmpty){
                                                   _externalLaunchUrl(SubjectsData.link);
                                                 }
                                                   else {
                                                      showToast("No Link Available");
                                                   }
                                                   },
                                               ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    SubjectsData.description,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
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
                      StreamBuilder<List<arduinoProjectTagsConvertor>>(
                        stream: readarduinoProjectTags(widget.id),
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
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Tags",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 10),
                                      child: ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: Subjects!.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final SubjectsData = Subjects[index];
                                          return Row(
                                            children: [
                                              Text(
                                                "# ${SubjectsData.name}",
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.blue),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            const Divider(),
                                      ),
                                    ),
                                  ],
                                );
                              }
                          }
                        },
                      ),
                      StreamBuilder<List<arduinoProjectOtherProjectsConvertor>>(
                        stream: readarduinoProjectOtherProjects(widget.id),
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
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Other Projects",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w500,
                                        color: Colors.white
                                        ),
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
                                          return InkWell(
                                            child: Row(
                                              children: [
                                                Container(
                                                  height:50,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                    color: Colors.black.withOpacity(0.4),
                                                    border: Border.all(color: const Color.fromRGBO(174, 228, 242,0.5)),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        SubjectsData.photoUrl,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8,),
                                                Expanded(
                                                  child: Text(
                                                    SubjectsData.heading,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.red),
                                                     maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            onTap: (){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => arduinoProject(creator:SubjectsData.creator,id: SubjectsData.projectId, heading: SubjectsData.heading, description: SubjectsData.description, photoUrl: SubjectsData.photoUrl, youtubeUrl: SubjectsData.videoUrl)));

                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 20,)
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

_externalLaunchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn, mode: LaunchMode.externalApplication))
    throw 'Could not launch $urlIn';
}

_launchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn, mode: LaunchMode.inAppWebView))
    throw 'Could not launch $urlIn';
}

Stream<List<arduinoProjectsConvertor>> readarduinoProjects() =>
    FirebaseFirestore.instance
        .collection('arduino')
        .doc("arduinoProjects")
        .collection("projects")
        .orderBy("heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => arduinoProjectsConvertor.fromJson(doc.data()))
            .toList());

Future createarduinoProjects(
    {required String heading,
    required String description,
    required String videoUrl,
    required String creator,
    required String photoUrl
    }) async {
  final docflash =
      FirebaseFirestore.instance
          .collection('arduino')
          .doc("arduinoProjects")
          .collection("projects").doc();
  final flash = arduinoProjectsConvertor(
      id: docflash.id,
      heading: heading,
      description: description,
      creator: creator,
      photoUrl: photoUrl,
      videoUrl: videoUrl);
  final json = flash.toJson();
  await docflash.set(json);
}

class arduinoProjectsConvertor {
  String id;
  final String heading, description, creator, photoUrl, videoUrl;

  arduinoProjectsConvertor(
      {this.id = "",
      required this.videoUrl,
      required this.heading,
      required this.description,
      required this.creator,
      required this.photoUrl});

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "description": description,
        "creator": creator,
        "photoUrl": photoUrl,
        "videoUrl": videoUrl
      };

  static arduinoProjectsConvertor fromJson(Map<String, dynamic> json) =>
      arduinoProjectsConvertor(
          id: json['id'],
          videoUrl: json["videoUrl"],
          heading: json["heading"],
          description: json["description"],
          creator: json["creator"],
          photoUrl: json["photoUrl"]);
}

Stream<List<arduinoSubPageProjectsConvertor>> readarduinoSubPageProjects() =>
    FirebaseFirestore.instance
        .collection('arduino')
        .doc("subPage")
        .collection("projects")
        .orderBy("heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => arduinoSubPageProjectsConvertor.fromJson(doc.data()))
            .toList());

Future createarduinoSubPageProjects(
    {required String heading,
    required String description,
    required String creator,
    required String photoUrl,
    required String videoUrl,
    required String projectId}) async {
  final docflash = FirebaseFirestore.instance
      .collection('arduino')
      .doc("subPage")
      .collection("projects")
      .doc();
  final flash = arduinoSubPageProjectsConvertor(
      id: docflash.id,
      heading: heading,
      description: description,
      creator: creator,
      photoUrl: photoUrl,
      videoUrl: videoUrl,
      projectId: projectId);
  final json = flash.toJson();
  await docflash.set(json);
}

class arduinoSubPageProjectsConvertor {
  String id;
  final String heading, description, creator, photoUrl, videoUrl, projectId;

  arduinoSubPageProjectsConvertor(
      {required this.projectId,
      this.id = "",
      required this.videoUrl,
      required this.heading,
      required this.description,
      required this.creator,
      required this.photoUrl});

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "description": description,
        "projectId": projectId,
        "creator": creator,
        "photoUrl": photoUrl,
        "videoUrl": videoUrl
      };

  static arduinoSubPageProjectsConvertor fromJson(Map<String, dynamic> json) =>
      arduinoSubPageProjectsConvertor(
          projectId: json["projectId"],
          id: json['id'],
          videoUrl: json["videoUrl"],
          heading: json["heading"],
          description: json["description"],
          creator: json["creator"],
          photoUrl: json["photoUrl"]);
}

Stream<List<arduinoProjectComponentConvertor>> readarduinoProjectComponent(
        String id) =>
    FirebaseFirestore.instance
        .collection('arduino')
        .doc("arduinoProjects")
        .collection("projects")
        .doc(id)
        .collection("components")
        .orderBy("name", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => arduinoProjectComponentConvertor.fromJson(doc.data()))
            .toList());

Future createarduinoProjectComponent(
    {required String heading,
    required String description,
    required int quantity}) async {
  final docflash =
      FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = arduinoProjectComponentConvertor(
      id: docflash.id, name: heading, link: description, quantity: quantity);
  final json = flash.toJson();
  await docflash.set(json);
}

class arduinoProjectComponentConvertor {
  String id;
  final String name, link;
  final int quantity;

  arduinoProjectComponentConvertor(
      {this.id = "",
      required this.name,
      required this.link,
      required this.quantity});

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "link": link, "quantity": quantity};

  static arduinoProjectComponentConvertor fromJson(Map<String, dynamic> json) =>
      arduinoProjectComponentConvertor(
          id: json['id'],
          name: json["name"],
          link: json["link"],
          quantity: json["quantity"]);
}

Stream<List<arduinoProjectPinConnectionConvertor>>
    readarduinoProjectPinConnection(String id) => FirebaseFirestore.instance
        .collection('arduino')
        .doc("arduinoProjects")
        .collection("projects")
        .doc(id)
        .collection("pinConnections")
        .orderBy("name", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                arduinoProjectPinConnectionConvertor.fromJson(doc.data()))
            .toList());

Future createarduinoProjectPinConnection(
    {required String heading,
    required String description,
    required int quantity}) async {
  final docflash =
      FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = arduinoProjectPinConnectionConvertor(
      id: docflash.id, name: heading, link: description, quantity: quantity);
  final json = flash.toJson();
  await docflash.set(json);
}

class arduinoProjectPinConnectionConvertor {
  String id;
  final String name, link;
  final int quantity;

  arduinoProjectPinConnectionConvertor(
      {this.id = "",
      required this.name,
      required this.link,
      required this.quantity});

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "link": link, "quantity": quantity};

  static arduinoProjectPinConnectionConvertor fromJson(
          Map<String, dynamic> json) =>
      arduinoProjectPinConnectionConvertor(
          id: json['id'],
          name: json["name"],
          link: json["link"],
          quantity: json["quantity"]);
}

Stream<List<arduinoProjectTableOfContentConvertor>>
    readarduinoProjectTableOfContent(String id) => FirebaseFirestore.instance
        .collection('arduino')
        .doc("arduinoProjects")
        .collection("projects")
        .doc(id)
        .collection("tableOfContent")
        .orderBy("name", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                arduinoProjectTableOfContentConvertor.fromJson(doc.data()))
            .toList());

Future createarduinoProjectTableOfContent(
    {required String heading,
    required String description,
    required int quantity}) async {
  final docflash =
      FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = arduinoProjectTableOfContentConvertor(
      id: docflash.id, name: heading, photoUrl: description);
  final json = flash.toJson();
  await docflash.set(json);
}

class arduinoProjectTableOfContentConvertor {
  String id;
  final String name, photoUrl;

  arduinoProjectTableOfContentConvertor(
      {this.id = "", required this.name, required this.photoUrl});

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "link": photoUrl,
      };

  static arduinoProjectTableOfContentConvertor fromJson(
          Map<String, dynamic> json) =>
      arduinoProjectTableOfContentConvertor(
          id: json['id'], name: json["name"], photoUrl: json["link"]);
}

Stream<List<arduinoProjectDownloadConvertor>> readarduinoProjectDownload(
        String id) =>
    FirebaseFirestore.instance
        .collection('arduino')
        .doc("arduinoProjects")
        .collection("projects")
        .doc(id)
        .collection("downloads")
        .orderBy("name", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => arduinoProjectDownloadConvertor.fromJson(doc.data()))
            .toList());

Future createarduinoProjectDownload(
    {required String heading,
    required String description,
    required int quantity}) async {
  final docflash =
      FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = arduinoProjectDownloadConvertor(
      id: docflash.id,
      name: heading,
      link: description,
      description: description);
  final json = flash.toJson();
  await docflash.set(json);
}

class arduinoProjectDownloadConvertor {
  String id;
  final String name, link, description;

  arduinoProjectDownloadConvertor(
      {this.id = "",
      required this.name,
      required this.link,
      required this.description});

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "link": link, "description": description};

  static arduinoProjectDownloadConvertor fromJson(Map<String, dynamic> json) =>
      arduinoProjectDownloadConvertor(
          id: json['id'],
          name: json["name"],
          link: json["link"],
          description: json["description"]);
}

Stream<List<arduinoProjectTagsConvertor>> readarduinoProjectTags(String id) =>
    FirebaseFirestore.instance
        .collection('arduino')
        .doc("arduinoProjects")
        .collection("projects")
        .doc(id)
        .collection("tags")
        .orderBy("name", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => arduinoProjectTagsConvertor.fromJson(doc.data()))
            .toList());

Future createarduinoProjectTags(
    {required String heading,
    required String description,
    required int quantity}) async {
  final docflash =
      FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = arduinoProjectDownloadConvertor(
      id: docflash.id,
      name: heading,
      link: description,
      description: description);
  final json = flash.toJson();
  await docflash.set(json);
}

class arduinoProjectTagsConvertor {
  String id;
  final String name;

  arduinoProjectTagsConvertor({this.id = "", required this.name});

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  static arduinoProjectTagsConvertor fromJson(Map<String, dynamic> json) =>
      arduinoProjectTagsConvertor(id: json['id'], name: json["name"]);
}

Stream<List<arduinoProjectOtherProjectsConvertor>>
    readarduinoProjectOtherProjects(String id) => FirebaseFirestore.instance
        .collection('arduino')
        .doc("arduinoProjects")
        .collection("projects")
        .doc(id)
        .collection("otherProjects")
        .orderBy("heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                arduinoProjectOtherProjectsConvertor.fromJson(doc.data()))
            .toList());

Future createarduinoProjectOtherProjects(
    {required String heading,
    required String description,
    required String projectId,required String videoUrl,required String photoUrl,required String creator}) async {
  final docflash =
      FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = arduinoProjectOtherProjectsConvertor(
      id: docflash.id, heading: heading, projectId:projectId, photoUrl: photoUrl,videoUrl: videoUrl,description: description,creator: creator);
  final json = flash.toJson();
  await docflash.set(json);
}

class arduinoProjectOtherProjectsConvertor {
  String id;
  final String heading, photoUrl, projectId,description,videoUrl,creator;

  arduinoProjectOtherProjectsConvertor(
      {this.id = "",
      required this.heading,
      required this.photoUrl,
      required this.projectId,required this.description,required this.videoUrl,required this.creator});

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "photoUrl": photoUrl,
        "projectId": projectId,
    "description":description,
    "videoUrl":videoUrl,
    "creator":creator
      };

  static arduinoProjectOtherProjectsConvertor fromJson(
          Map<String, dynamic> json) =>
      arduinoProjectOtherProjectsConvertor(
          id: json['id'],
          heading: json["heading"],
          photoUrl: json["photoUrl"],
          projectId: json["projectId"],videoUrl: json["videoUrl"],description: json["description"],creator: json["creator"]);
}

Stream<List<arduinoProjectDescriptionConvertor>> readarduinoProjectDescription(
        String id) =>
    FirebaseFirestore.instance
        .collection('arduino')
        .doc("arduinoProjects")
        .collection("projects")
        .doc(id)
        .collection("projectDescription")
        .orderBy("heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                arduinoProjectDescriptionConvertor.fromJson(doc.data()))
            .toList());

Future createarduinoProjectDescription(
    {required String heading,
    required String description,
    required String photoUrl}) async {
  final docflash =
      FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = arduinoProjectDescriptionConvertor(
      id: docflash.id,
      heading: heading,
      description: description,
      photoUrl: photoUrl);
  final json = flash.toJson();
  await docflash.set(json);
}

class arduinoProjectDescriptionConvertor {
  String id;
  final String heading, description, photoUrl;

  arduinoProjectDescriptionConvertor(
      {this.id = "",
      required this.heading,
      required this.description,
      required this.photoUrl});

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "description": description,
        "photoUrl": photoUrl
      };

  static arduinoProjectDescriptionConvertor fromJson(
          Map<String, dynamic> json) =>
      arduinoProjectDescriptionConvertor(
          id: json['id'],
          heading: json["heading"],
          description: json["description"],
          photoUrl: json["photoUrl"]);
}
Future showToast(String message) async {
  await Fluttertoast.cancel();
  Fluttertoast.showToast(msg: message, fontSize: 18);
}