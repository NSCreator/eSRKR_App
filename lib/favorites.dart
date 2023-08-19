import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:srkr_study_app/settings.dart';
import 'SubPages.dart';
import 'functins.dart';
TextStyle favoritesHeadingTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 30,
    fontWeight: FontWeight.w600);
class favorites extends StatefulWidget {
  final String branch;
  final double size;
  final double height;
  final double width;
  const favorites(
      {Key? key,
      required this.branch,
      required this.width,
      required this.size,
      required this.height})
      : super(key: key);

  @override
  State<favorites> createState() => _favoritesState();
}

class _favoritesState extends State<favorites> {
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
    return Stack(
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              StreamBuilder<List<FavouriteSubjectsConvertor>>(
                  stream: readFavouriteSubjects(),
                  builder: (context, snapshot) {
                    final Favourites = snapshot.data;
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(
                            child: CircularProgressIndicator(
                          strokeWidth: 0.3,
                          color: Colors.cyan,
                        ));
                      default:
                        if (snapshot.hasError) {
                          return Center(child: Text("Error"));
                        } else {
                          if (Favourites!.length > 0)
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                  child: Text(
                                    "Subjects",
                                    style: favoritesHeadingTextStyle),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: widget.width * 20,
                                      right: widget.width * 10),
                                  child: ListView.separated(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: Favourites.length,
                                      itemBuilder: (context, int index) {
                                        final Favourite = Favourites[index];
                                        if(Favourite.photoUrl.isNotEmpty){
                                          final Uri uri =
                                          Uri.parse(Favourite.photoUrl);
                                          final String fileName =
                                              uri.pathSegments.last;
                                          var name = fileName.split("/").last;
                                           file = File(
                                              "${folderPath}/subjects/$name");
                                        }
                                        return InkWell(
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: Colors.black38,
                                                borderRadius: BorderRadius
                                                    .all(Radius.circular(
                                                        widget.size * 20))),
                                            child: SingleChildScrollView(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width:
                                                        widget.width * 90.0,
                                                    height:
                                                        widget.height * 50.0,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  widget.size *
                                                                      20)),
                                                      color: Colors.redAccent,
                                                      border: Border.all(color: Colors.white30),
                                                      image: DecorationImage(
                                                        image:
                                                            FileImage(file),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: widget.width * 10,
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
                                                      Row(
                                                        children: [
                                                          Text(
                                                            Favourite.name,
                                                            style: TextStyle(
                                                              fontSize: widget
                                                                      .size *
                                                                  20.0,
                                                              color: Colors
                                                                  .orangeAccent,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          InkWell(
                                                            child: Icon(
                                                              Icons
                                                                  .highlight_remove_outlined,
                                                              color: Colors
                                                                  .red,
                                                              size: widget
                                                                      .size *
                                                                  30,
                                                            ),
                                                            onTap: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return Dialog(
                                                                    backgroundColor: Colors.transparent,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(widget.size * 20)),
                                                                    elevation:
                                                                        16,
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border:
                                                                            Border.all(color: Colors.white54),
                                                                        borderRadius:
                                                                            BorderRadius.circular(widget.size * 20),
                                                                      ),
                                                                      child:
                                                                          ListView(
                                                                        shrinkWrap:
                                                                            true,
                                                                        children: <Widget>[
                                                                          SizedBox(height: widget.height * 10),
                                                                          SizedBox(height: widget.height * 5),
                                                                          Padding(
                                                                            padding: EdgeInsets.only(left: widget.width * 15),
                                                                            child: Text(
                                                                              "Do you want Remove from Favourites",
                                                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: widget.size * 20),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height: widget.height * 5,
                                                                          ),
                                                                          Center(
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Spacer(),
                                                                                InkWell(
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.white24,
                                                                                      border: Border.all(color: Colors.white10),
                                                                                      borderRadius: BorderRadius.circular(widget.size * 25),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.only(left: widget.width * 15, right: widget.width * 15, top: widget.height * 5, bottom: widget.height * 5),
                                                                                      child: Text("Back",style: TextStyle(color: Colors.white,),),
                                                                                    ),
                                                                                  ),
                                                                                  onTap: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                ),
                                                                                SizedBox(
                                                                                  width: widget.width * 10,
                                                                                ),
                                                                                InkWell(
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.red,
                                                                                      border: Border.all(color: Colors.black),
                                                                                      borderRadius: BorderRadius.circular(widget.size * 25),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.only(left: widget.width * 15, right: widget.width * 15, top: widget.height * 5, bottom: widget.height * 5),
                                                                                      child: Text(
                                                                                        "Delete",
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  onTap: () {
                                                                                    FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.email!).collection("FavouriteSubject").doc(Favourite.id).delete();
                                                                                    Navigator.pop(context);
                                                                                    showToastText("${Favourite.name} as been removed");
                                                                                  },
                                                                                ),
                                                                                SizedBox(
                                                                                  width: widget.width * 20,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height: widget.height * 10,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          )
                                                        ],
                                                      ),

                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 10),
                                                        child: Text(
                                                          Favourite.description,
                                                          style: TextStyle(
                                                            fontSize:
                                                                widget.size *
                                                                    15.0,
                                                            color:
                                                                Colors.white70,
                                                          ),
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

                                                          reg: Favourite.name,

                                                          size: widget.size,
                                                          branch: Favourite
                                                              .branch,
                                                          ID: Favourite
                                                              .subjectId,
                                                          mode: "Subjects",
                                                          name:
                                                              Favourite.name,
                                                          fullName: Favourite
                                                              .description,
                                                          photoUrl: Favourite
                                                              .photoUrl,
                                                        )));
                                          },
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                            height: widget.height * 6,
                                          )),
                                ),
                              ],
                            );
                          else
                            return Center(
                              child: Padding(
                                padding:
                                    EdgeInsets.only(top: widget.height * 10),
                                child: InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.white30),
                                        borderRadius: BorderRadius.circular(
                                            widget.size * 20),
                                      ),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(widget.size * 8.0),
                                        child: Text(
                                          "No Favorite Subjects",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: widget.size * 20),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      showToastText("Add Subjects");
                                    }),
                              ),
                            );
                        }
                    }
                  }),
              //TODO Favourite Lab Subjects Stream Builder
              StreamBuilder<List<FavouriteLabSubjectsConvertor>>(
                  stream: readFavouriteLabSubjects(),
                  builder: (context, snapshot) {
                    final Favourites = snapshot.data;
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(
                            child: CircularProgressIndicator(
                          strokeWidth: 0.3,
                          color: Colors.cyan,
                        ));
                      default:
                        if (snapshot.hasError) {
                          return Center(child: Text("Error"));
                        } else {
                          if (Favourites!.length > 0)
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                  child: Text(
                                    "Lab Subjects",
                                    style: favoritesHeadingTextStyle,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: widget.width * 20,
                                      right: widget.width * 10),
                                  child: ListView.separated(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: Favourites.length,
                                      itemBuilder: (context, int index) {
                                        final Favourite = Favourites[index];
                                        if(Favourite.photoUrl.isNotEmpty){
                                          final Uri uri =
                                          Uri.parse(Favourite.photoUrl);
                                          final String fileName =
                                              uri.pathSegments.last;
                                          var name = fileName.split("/").last;
                                           file = File(
                                              "${folderPath}/labsubjects/$name");
                                        }
                                        return InkWell(
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: Colors.black38,
                                                borderRadius: BorderRadius
                                                    .all(Radius.circular(
                                                        widget.size * 20))),
                                            child: SingleChildScrollView(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width:
                                                        widget.width * 90.0,
                                                    height:
                                                        widget.height * 50.0,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.white30),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  widget.size *
                                                                      20)),
                                                      color: Colors.redAccent,
                                                      image: DecorationImage(
                                                        image:
                                                            FileImage(file),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: widget.width * 10,
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
                                                      Row(
                                                        children: [
                                                          Text(
                                                            Favourite.name,
                                                            style: TextStyle(
                                                              fontSize: widget
                                                                      .size *
                                                                  20.0,
                                                              color: Colors
                                                                  .orangeAccent,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          InkWell(
                                                            child: Icon(
                                                              Icons
                                                                  .highlight_remove_outlined,
                                                              color: Colors
                                                                  .red,
                                                              size: widget
                                                                      .size *
                                                                  30,
                                                            ),
                                                            onTap: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return Dialog(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(widget.size * 20)),
                                                                    elevation:
                                                                        16,
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border:
                                                                            Border.all(color: Colors.tealAccent),
                                                                        borderRadius:
                                                                            BorderRadius.circular(widget.size * 20),
                                                                      ),
                                                                      child:
                                                                          ListView(
                                                                        shrinkWrap:
                                                                            true,
                                                                        children: <Widget>[
                                                                          SizedBox(height: widget.height * 15),
                                                                          Padding(
                                                                            padding: EdgeInsets.only(left: widget.width * 15),
                                                                            child: Text(
                                                                              "Do you want Remove from Favourites",
                                                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: widget.size * 18),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height: widget.height * 5,
                                                                          ),
                                                                          Center(
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Spacer(),
                                                                                InkWell(
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.black26,
                                                                                      border: Border.all(color: Colors.black),
                                                                                      borderRadius: BorderRadius.circular(widget.size * 25),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.only(left: widget.width * 15, right: widget.width * 15, top: widget.height * 5, bottom: widget.height * 5),
                                                                                      child: Text("Back"),
                                                                                    ),
                                                                                  ),
                                                                                  onTap: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                ),
                                                                                SizedBox(
                                                                                  width: widget.width * 10,
                                                                                ),
                                                                                InkWell(
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.red,
                                                                                      border: Border.all(color: Colors.black),
                                                                                      borderRadius: BorderRadius.circular(widget.size * 25),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.only(left: widget.width * 15, right: widget.width * 15, top: widget.height * 5, bottom: widget.height * 5),
                                                                                      child: Text(
                                                                                        "Delete",
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  onTap: () {
                                                                                    FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.email!).collection("FavouriteLabSubjects").doc(Favourite.id).delete();
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                ),
                                                                                SizedBox(
                                                                                  width: widget.width * 20,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height: widget.height * 10,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            widget.height * 2,
                                                      ),
                                                      Text(
                                                        Favourite.description,
                                                        style: TextStyle(
                                                          fontSize:
                                                              widget.size *
                                                                  15.0,
                                                          color: Colors
                                                              .white70,
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
                                                          reg:Favourite.name,

                                                          size: widget.size,
                                                          branch: Favourite
                                                              .branch,
                                                          ID: Favourite
                                                              .subjectId,
                                                          mode: "LabSubjects",
                                                          name:
                                                              Favourite.name,
                                                          fullName: Favourite
                                                              .description,
                                                          photoUrl: Favourite
                                                              .photoUrl,
                                                        )));
                                          },
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                            height: widget.height * 5,
                                          )),
                                ),
                              ],
                            );
                          else
                            return Padding(
                              padding:
                                  EdgeInsets.only(top: widget.height * 15),
                              child: Center(
                                child: InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white54),
                                        borderRadius: BorderRadius.circular(
                                            widget.size * 20),
                                      ),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(widget.size * 8.0),
                                        child: Text(
                                          "No Favorite Lab Subjects",
                                          style:
                                              TextStyle(color: Colors.white,fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      showToastText("Add La Subjects");
                                    }),
                              ),
                            );
                        }
                    }
                  }),

              SizedBox(
                height: 150,
              )
            ],
          ),
        ),

      ],
    );
  }
}

Stream<List<FavouriteSubjectsConvertor>> readFavouriteSubjects() =>
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.email!)
        .collection("FavouriteSubject")
        .orderBy("name", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FavouriteSubjectsConvertor.fromJson(doc.data()))
            .toList());

Future FavouriteSubjects(
    {
      required SubjectId,
    required name,
    required description,
    required photoUrl,
    required branch
    }) async {
  final docflash = FirebaseFirestore.instance
      .collection("user")
      .doc(FirebaseAuth.instance.currentUser!.email!)
      .collection("FavouriteSubject")
      .doc(SubjectId);
  final flash = FavouriteSubjectsConvertor(
      id: SubjectId,
      subjectId: SubjectId,
      name: name,
      description: description,
      branch: branch,
      photoUrl: photoUrl);
  final json = flash.toJson();
  await docflash.set(json);
}

class FavouriteSubjectsConvertor {
  String id;
  final String subjectId, name, description, photoUrl, branch;

  FavouriteSubjectsConvertor(
      {this.id = "",
      required this.subjectId,
      required this.photoUrl,
      required this.name,
      required this.description,
      required this.branch});

  Map<String, dynamic> toJson() => {
        "id": id,
        "subjectId": subjectId,
        "description": description,
        "name": name,
        "photoUrl": photoUrl,
        "branch": branch
      };

  static FavouriteSubjectsConvertor fromJson(Map<String, dynamic> json) =>
      FavouriteSubjectsConvertor(
          id: json['id'],
          subjectId: json["subjectId"],
          branch: json['branch'],
          photoUrl: json["photoUrl"],
          name: json["name"],
          description: json["description"]);
}

Stream<List<FavouriteLabSubjectsConvertor>> readFavouriteLabSubjects() =>
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.email!)
        .collection("FavouriteLabSubjects")
        .orderBy("name", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FavouriteLabSubjectsConvertor.fromJson(doc.data()))
            .toList());

Future FavouriteLabSubjectsSubjects(
    {required SubjectId,
    required name,
    required description,
    required photoUrl,
    required branch}) async {
  final docflash = FirebaseFirestore.instance
      .collection("user")
      .doc(FirebaseAuth.instance.currentUser!.email!)
      .collection("FavouriteLabSubjects")
      .doc(SubjectId);
  final flash = FavouriteLabSubjectsConvertor(
      id: SubjectId,
      subjectId: SubjectId,
      name: name,
      description: description,
      branch: branch,
      photoUrl: photoUrl);
  final json = flash.toJson();
  await docflash.set(json);
}

class FavouriteLabSubjectsConvertor {
  String id;
  final String subjectId, name, description, photoUrl, branch;

  FavouriteLabSubjectsConvertor(
      {this.id = "",
      required this.subjectId,
      required this.photoUrl,
      required this.name,
      required this.description,
      required this.branch});

  Map<String, dynamic> toJson() => {
        "id": id,
        "subjectId": subjectId,
        "description": description,
        "name": name,
        "photoUrl": photoUrl,
        "branch": branch
      };

  static FavouriteLabSubjectsConvertor fromJson(Map<String, dynamic> json) =>
      FavouriteLabSubjectsConvertor(
          id: json['id'],
          subjectId: json["subjectId"],
          branch: json['branch'],
          photoUrl: json["photoUrl"],
          name: json["name"],
          description: json["description"]);
}


