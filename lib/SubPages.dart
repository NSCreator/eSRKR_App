// ignore_for_file: camel_case_types, non_constant_identifier_names
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:srkr_study_app/TextField.dart';
import 'package:srkr_study_app/HomePage.dart';
import 'add subjects.dart';
import 'package:flutter/material.dart';
import 'favorites.dart';
import 'functins.dart';
import 'package:http/http.dart' as http;

class NewsPage extends StatefulWidget {
  final String branch;

  const NewsPage({Key? key, required this.branch}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  String folderPath = "";

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}/';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                "https://i.pinimg.com/736x/01/c7/f7/01c7f72511cc6ce7858e65b45d4f8c9c.jpg",
              ),
              fit: BoxFit.fill),
        ),
        child: Container(
          height: double.infinity,
          color: Colors.black.withOpacity(0.8),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: StreamBuilder<List<BranchNewConvertor>>(
                      stream: readBranchNew(widget.branch),
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
                              return ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: BranchNews!.length,
                                  itemBuilder: (context, int index) {
                                    final BranchNew = BranchNews[index];
                                    final Uri uri =
                                        Uri.parse(BranchNew.photoUrl);
                                    final String fileName =
                                        uri.pathSegments.last;
                                    var name = fileName.split("/").last;
                                    final file = File(
                                        "${folderPath}/${widget.branch.toLowerCase()}_news/$name");
                                    return InkWell(
                                      child: Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            margin: const EdgeInsets.all(4.0),
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.1)),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8,
                                                          left: 8,
                                                          bottom: 2),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 25,
                                                        width: 25,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          image:
                                                              DecorationImage(
                                                            image: AssetImage(
                                                                "assets/ece image 64x64.png"),
                                                          ),
                                                        ),
                                                      ),
                                                      if (BranchNew
                                                          .heading.isNotEmpty)
                                                        Text(
                                                            " ${BranchNew.heading}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .orangeAccent,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400))
                                                      else
                                                        Text(
                                                            " ${widget.branch} (SRKR)",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Image.file(file)),
                                                Row(
                                                  children: [
                                                    Spacer(),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              bottom: 3,
                                                              right: 20),
                                                      child: Text(
                                                        BranchNew.Date,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white54,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (BranchNew
                                                    .description.isNotEmpty)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 25,
                                                            top: 5,
                                                            bottom: 5),
                                                    child: Text(
                                                        BranchNew.description,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .lightBlueAccent,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300)),
                                                  ),
                                                if (userId())
                                                  Row(
                                                    children: [
                                                      Spacer(),
                                                      InkWell(
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey[500],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10,
                                                                    right: 10,
                                                                    top: 5,
                                                                    bottom: 5),
                                                            child: Text("Edit"),
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => NewsCreator(
                                                                      branch: widget
                                                                          .branch,
                                                                      NewsId:
                                                                          BranchNew
                                                                              .id,
                                                                      heading:
                                                                          BranchNew
                                                                              .heading,
                                                                      description:
                                                                          BranchNew
                                                                              .description,
                                                                      photoUrl:
                                                                          BranchNew
                                                                              .photoUrl)));
                                                        },
                                                      ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      InkWell(
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey[500],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10,
                                                                    right: 10,
                                                                    top: 5,
                                                                    bottom: 5),
                                                            child:
                                                                Text("Delete"),
                                                          ),
                                                        ),
                                                        onTap: () async {
                                                          final Uri uri = Uri
                                                              .parse(BranchNew
                                                                  .photoUrl);
                                                          final String
                                                              fileName = uri
                                                                  .pathSegments
                                                                  .last;
                                                          final Reference ref =
                                                              storage.ref().child(
                                                                  "/${fileName}");
                                                          try {
                                                            await ref.delete();
                                                            showToastText(
                                                                'Image deleted successfully');
                                                          } catch (e) {
                                                            showToastText(
                                                                'Error deleting image: $e');
                                                          }
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  widget.branch)
                                                              .doc(
                                                                  "${widget.branch}News")
                                                              .collection(
                                                                  "${widget.branch}News")
                                                              .doc(BranchNew.id)
                                                              .delete();
                                                        },
                                                      ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ImageZoom(
                                                      url: "",
                                                      file: file,
                                                    )));
                                      },
                                    );
                                  },
                                  separatorBuilder: (context, index) => Divider(
                                        height: 9,
                                        color: Colors.white,
                                      ));
                            }
                        }
                      }),
                ),
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white.withOpacity(0.3)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${widget.branch} News",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Subjects extends StatefulWidget {
  final String branch;

  Subjects({Key? key, required this.branch}) : super(key: key);

  @override
  State<Subjects> createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  String folderPath = "";

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}/';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://i.pinimg.com/736x/01/c7/f7/01c7f72511cc6ce7858e65b45d4f8c9c.jpg"),
                fit: BoxFit.fill)),
        child: Container(
          color: Colors.black.withOpacity(0.8),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: StreamBuilder<List<FlashConvertor>>(
                      stream: readFlashNews(widget.branch),
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
                              return ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: user!.length,
                                  itemBuilder: (context, int index) {
                                    final SubjectsData = user[index];
                                    final Uri uri =
                                        Uri.parse(SubjectsData.PhotoUrl);
                                    final String fileName =
                                        uri.pathSegments.last;
                                    var name = fileName.split("/").last;
                                    final file = File(
                                        "${folderPath}/${widget.branch.toLowerCase()}_subjects/$name");
                                    if (file.existsSync()) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.black38,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: SingleChildScrollView(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 90.0,
                                                      height: 70.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8.0)),
                                                        color: Colors.black,
                                                        image: DecorationImage(
                                                          image:
                                                              FileImage(file),
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
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              SubjectsData
                                                                  .heading,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 20.0,
                                                                color: Colors
                                                                    .orangeAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            InkWell(
                                                              child: StreamBuilder<
                                                                  DocumentSnapshot>(
                                                                stream: FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        widget
                                                                            .branch)
                                                                    .doc(
                                                                        "Subjects")
                                                                    .collection(
                                                                        "Subjects")
                                                                    .doc(
                                                                        SubjectsData
                                                                            .id)
                                                                    .collection(
                                                                        "likes")
                                                                    .doc(
                                                                        fullUserId())
                                                                    .snapshots(),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    if (snapshot
                                                                        .data!
                                                                        .exists) {
                                                                      return const Icon(
                                                                        Icons
                                                                            .favorite,
                                                                        color: Colors
                                                                            .red,
                                                                        size:
                                                                            26,
                                                                      );
                                                                    } else {
                                                                      return const Icon(
                                                                        Icons
                                                                            .favorite_border,
                                                                        color: Colors
                                                                            .red,
                                                                        size:
                                                                            26,
                                                                      );
                                                                    }
                                                                  } else {
                                                                    return Container();
                                                                  }
                                                                },
                                                              ),
                                                              onTap: () async {
                                                                try {
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          widget
                                                                              .branch)
                                                                      .doc(
                                                                          "Subjects")
                                                                      .collection(
                                                                          "Subjects")
                                                                      .doc(SubjectsData
                                                                          .id)
                                                                      .collection(
                                                                          "likes")
                                                                      .doc(
                                                                          fullUserId())
                                                                      .get()
                                                                      .then(
                                                                          (docSnapshot) {
                                                                    if (docSnapshot
                                                                        .exists) {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(widget
                                                                              .branch)
                                                                          .doc(
                                                                              "Subjects")
                                                                          .collection(
                                                                              "Subjects")
                                                                          .doc(SubjectsData
                                                                              .id)
                                                                          .collection(
                                                                              "likes")
                                                                          .doc(
                                                                              fullUserId())
                                                                          .delete();
                                                                      showToastText(
                                                                          "Unliked");
                                                                    } else {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(widget
                                                                              .branch)
                                                                          .doc(
                                                                              "Subjects")
                                                                          .collection(
                                                                              "Subjects")
                                                                          .doc(SubjectsData
                                                                              .id)
                                                                          .collection(
                                                                              "likes")
                                                                          .doc(
                                                                              fullUserId())
                                                                          .set({
                                                                        "id":
                                                                            fullUserId()
                                                                      });
                                                                      showToastText(
                                                                          "Liked");
                                                                    }
                                                                  });
                                                                } catch (e) {
                                                                  print(e);
                                                                }
                                                              },
                                                            ),
                                                            StreamBuilder<
                                                                QuerySnapshot>(
                                                              stream: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      widget
                                                                          .branch)
                                                                  .doc(
                                                                      "Subjects")
                                                                  .collection(
                                                                      "Subjects")
                                                                  .doc(
                                                                      SubjectsData
                                                                          .id)
                                                                  .collection(
                                                                      "likes")
                                                                  .snapshots(),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  return Text(
                                                                    " ${snapshot.data!.docs.length}",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .white),
                                                                  );
                                                                } else {
                                                                  return const Text(
                                                                      "0");
                                                                }
                                                              },
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            InkWell(
                                                              child: StreamBuilder<
                                                                  DocumentSnapshot>(
                                                                stream: FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'user')
                                                                    .doc(
                                                                        fullUserId())
                                                                    .collection(
                                                                        "FavouriteSubject")
                                                                    .doc(
                                                                        SubjectsData
                                                                            .id)
                                                                    .snapshots(),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    if (snapshot
                                                                        .data!
                                                                        .exists) {
                                                                      return const Icon(
                                                                          Icons
                                                                              .library_add_check,
                                                                          size:
                                                                              26,
                                                                          color:
                                                                              Colors.cyanAccent);
                                                                    } else {
                                                                      return const Icon(
                                                                        Icons
                                                                            .library_add_outlined,
                                                                        size:
                                                                            26,
                                                                        color: Colors
                                                                            .cyanAccent,
                                                                      );
                                                                    }
                                                                  } else {
                                                                    return Container();
                                                                  }
                                                                },
                                                              ),
                                                              onTap: () async {
                                                                try {
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'user')
                                                                      .doc(
                                                                          fullUserId())
                                                                      .collection(
                                                                          "FavouriteSubject")
                                                                      .doc(SubjectsData
                                                                          .id)
                                                                      .get()
                                                                      .then(
                                                                          (docSnapshot) {
                                                                    if (docSnapshot
                                                                        .exists) {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'user')
                                                                          .doc(
                                                                              fullUserId())
                                                                          .collection(
                                                                              "FavouriteSubject")
                                                                          .doc(SubjectsData
                                                                              .id)
                                                                          .delete();
                                                                      showToastText(
                                                                          "Removed from saved list");
                                                                    } else {
                                                                      FavouriteSubjects(
                                                                          branch: widget
                                                                              .branch,
                                                                          SubjectId: SubjectsData
                                                                              .id,
                                                                          name: SubjectsData
                                                                              .heading,
                                                                          description: SubjectsData
                                                                              .description,
                                                                          photoUrl:
                                                                              SubjectsData.PhotoUrl);
                                                                      showToastText(
                                                                          "${SubjectsData.heading} in favorites");
                                                                    }
                                                                  });
                                                                } catch (e) {
                                                                  print(e);
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          SubjectsData
                                                              .description,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 13.0,
                                                            color: Colors
                                                                .lightBlueAccent,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 1,
                                                        ),
                                                        Text(
                                                          'Added :${SubjectsData.Date}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 9.0,
                                                            color:
                                                                Colors.white60,
                                                            //   fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        if (userId())
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 10),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.3),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.5)),
                                                              ),
                                                              width: 70,
                                                              child: InkWell(
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .edit,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              3,
                                                                          right:
                                                                              3),
                                                                      child:
                                                                          Text(
                                                                        "Edit",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.w400,
                                                                            fontSize: 18),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => SubjectsCreator(
                                                                                branch: widget.branch,
                                                                                Id: SubjectsData.id,
                                                                                heading: SubjectsData.heading,
                                                                                description: SubjectsData.description,
                                                                                photoUrl: SubjectsData.PhotoUrl,
                                                                                mode: "Subjects",
                                                                              )));
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: () async {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          subjectUnitsData(
                                                            branch:
                                                                widget.branch,
                                                            ID: SubjectsData.id,
                                                            mode: "Subjects",
                                                            name: SubjectsData
                                                                .heading,
                                                            fullName:
                                                                SubjectsData
                                                                    .description,
                                                            photoUrl:
                                                                SubjectsData
                                                                    .PhotoUrl,
                                                          )));
                                            },
                                          ),
                                          // if ((index + 1) % 1 == 0)
                                          //   CustomBannerAd01(),
                                        ],
                                      );
                                    } else {
                                      download(SubjectsData.PhotoUrl,
                                          "${widget.branch.toLowerCase()}_subjects");
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          InkWell(
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.black38,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: SingleChildScrollView(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 90.0,
                                                      height: 70.0,
                                                      child: CachedNetworkImage(
                                                        imageUrl: SubjectsData
                                                            .PhotoUrl,
                                                        placeholder: (context,
                                                                url) =>
                                                            CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
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
                                                              SubjectsData
                                                                  .heading,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 20.0,
                                                                color: Colors
                                                                    .orangeAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            InkWell(
                                                              child: StreamBuilder<
                                                                  DocumentSnapshot>(
                                                                stream: FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        widget
                                                                            .branch)
                                                                    .doc(
                                                                        "Subjects")
                                                                    .collection(
                                                                        "Subjects")
                                                                    .doc(
                                                                        SubjectsData
                                                                            .id)
                                                                    .collection(
                                                                        "likes")
                                                                    .doc(
                                                                        fullUserId())
                                                                    .snapshots(),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    if (snapshot
                                                                        .data!
                                                                        .exists) {
                                                                      return const Icon(
                                                                        Icons
                                                                            .favorite,
                                                                        color: Colors
                                                                            .red,
                                                                        size:
                                                                            26,
                                                                      );
                                                                    } else {
                                                                      return const Icon(
                                                                        Icons
                                                                            .favorite_border,
                                                                        color: Colors
                                                                            .red,
                                                                        size:
                                                                            26,
                                                                      );
                                                                    }
                                                                  } else {
                                                                    return Container();
                                                                  }
                                                                },
                                                              ),
                                                              onTap: () async {
                                                                try {
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          widget
                                                                              .branch)
                                                                      .doc(
                                                                          "Subjects")
                                                                      .collection(
                                                                          "Subjects")
                                                                      .doc(SubjectsData
                                                                          .id)
                                                                      .collection(
                                                                          "likes")
                                                                      .doc(
                                                                          fullUserId())
                                                                      .get()
                                                                      .then(
                                                                          (docSnapshot) {
                                                                    if (docSnapshot
                                                                        .exists) {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(widget
                                                                              .branch)
                                                                          .doc(
                                                                              "Subjects")
                                                                          .collection(
                                                                              "Subjects")
                                                                          .doc(SubjectsData
                                                                              .id)
                                                                          .collection(
                                                                              "likes")
                                                                          .doc(
                                                                              fullUserId())
                                                                          .delete();
                                                                      showToastText(
                                                                          "Unliked");
                                                                    } else {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(widget
                                                                              .branch)
                                                                          .doc(
                                                                              "Subjects")
                                                                          .collection(
                                                                              "Subjects")
                                                                          .doc(SubjectsData
                                                                              .id)
                                                                          .collection(
                                                                              "likes")
                                                                          .doc(
                                                                              fullUserId())
                                                                          .set({
                                                                        "id":
                                                                            fullUserId()
                                                                      });
                                                                      showToastText(
                                                                          "Liked");
                                                                    }
                                                                  });
                                                                } catch (e) {
                                                                  print(e);
                                                                }
                                                              },
                                                            ),
                                                            StreamBuilder<
                                                                QuerySnapshot>(
                                                              stream: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      widget
                                                                          .branch)
                                                                  .doc(
                                                                      "Subjects")
                                                                  .collection(
                                                                      "Subjects")
                                                                  .doc(
                                                                      SubjectsData
                                                                          .id)
                                                                  .collection(
                                                                      "likes")
                                                                  .snapshots(),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  return Text(
                                                                    " ${snapshot.data!.docs.length}",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .white),
                                                                  );
                                                                } else {
                                                                  return const Text(
                                                                      "0");
                                                                }
                                                              },
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            InkWell(
                                                              child: StreamBuilder<
                                                                  DocumentSnapshot>(
                                                                stream: FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'user')
                                                                    .doc(
                                                                        fullUserId())
                                                                    .collection(
                                                                        "FavouriteSubject")
                                                                    .doc(
                                                                        SubjectsData
                                                                            .id)
                                                                    .snapshots(),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    if (snapshot
                                                                        .data!
                                                                        .exists) {
                                                                      return const Icon(
                                                                          Icons
                                                                              .library_add_check,
                                                                          size:
                                                                              26,
                                                                          color:
                                                                              Colors.cyanAccent);
                                                                    } else {
                                                                      return const Icon(
                                                                        Icons
                                                                            .library_add_outlined,
                                                                        size:
                                                                            26,
                                                                        color: Colors
                                                                            .cyanAccent,
                                                                      );
                                                                    }
                                                                  } else {
                                                                    return Container();
                                                                  }
                                                                },
                                                              ),
                                                              onTap: () async {
                                                                try {
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'user')
                                                                      .doc(
                                                                          fullUserId())
                                                                      .collection(
                                                                          "FavouriteSubject")
                                                                      .doc(SubjectsData
                                                                          .id)
                                                                      .get()
                                                                      .then(
                                                                          (docSnapshot) {
                                                                    if (docSnapshot
                                                                        .exists) {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'user')
                                                                          .doc(
                                                                              fullUserId())
                                                                          .collection(
                                                                              "FavouriteSubject")
                                                                          .doc(SubjectsData
                                                                              .id)
                                                                          .delete();
                                                                      showToastText(
                                                                          "Removed from saved list");
                                                                    } else {
                                                                      FavouriteSubjects(
                                                                          branch: widget
                                                                              .branch,
                                                                          SubjectId: SubjectsData
                                                                              .id,
                                                                          name: SubjectsData
                                                                              .heading,
                                                                          description: SubjectsData
                                                                              .description,
                                                                          photoUrl:
                                                                              SubjectsData.PhotoUrl);
                                                                      showToastText(
                                                                          "${SubjectsData.heading} in favorites");
                                                                    }
                                                                  });
                                                                } catch (e) {
                                                                  print(e);
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          SubjectsData
                                                              .description,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 13.0,
                                                            color: Colors
                                                                .lightBlueAccent,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 1,
                                                        ),
                                                        Text(
                                                          'Added :${SubjectsData.Date}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 9.0,
                                                            color:
                                                                Colors.white60,
                                                            //   fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        if (userId())
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 10),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.3),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.5)),
                                                              ),
                                                              width: 70,
                                                              child: InkWell(
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .edit,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              3,
                                                                          right:
                                                                              3),
                                                                      child:
                                                                          Text(
                                                                        "Edit",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.w400,
                                                                            fontSize: 18),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => SubjectsCreator(
                                                                                branch: widget.branch,
                                                                                Id: SubjectsData.id,
                                                                                heading: SubjectsData.heading,
                                                                                description: SubjectsData.description,
                                                                                photoUrl: SubjectsData.PhotoUrl,
                                                                                mode: "Subjects",
                                                                              )));
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: () async {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          subjectUnitsData(
                                                            branch:
                                                                widget.branch,
                                                            ID: SubjectsData.id,
                                                            mode: "Subjects",
                                                            name: SubjectsData
                                                                .heading,
                                                            fullName:
                                                                SubjectsData
                                                                    .description,
                                                            photoUrl:
                                                                SubjectsData
                                                                    .PhotoUrl,
                                                          )));
                                            },
                                          ),
                                          // if ((index + 1) % 1 == 0)
                                          //   CustomBannerAd01(),
                                        ],
                                      );
                                    }
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        height: 1,
                                      ));
                            }
                        }
                      }),
                ),
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white.withOpacity(0.3)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${widget.branch} Subjects",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget isLike(docName) {
    isDocumentExsist(docName);
    return Text("data");
  }

  Future<bool> isDocumentExsist(docName) async {
    DocumentSnapshot<Map<String, dynamic>> document = await FirebaseFirestore
        .instance
        .collection(widget.branch)
        .doc("Subjects")
        .collection("Subjects")
        .doc(docName)
        .collection("like")
        .doc(fullUserId())
        .get();
    if (document.exists) {
      print("true");
      return true;
    } else {
      print("false");
      return false;
    }
  }
}

class LabSubjects extends StatefulWidget {
  final String branch;

  const LabSubjects({Key? key, required this.branch}) : super(key: key);

  @override
  State<LabSubjects> createState() => _LabSubjectsState();
}

class _LabSubjectsState extends State<LabSubjects> {
  String folderPath = "";

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}/';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://i.pinimg.com/736x/01/c7/f7/01c7f72511cc6ce7858e65b45d4f8c9c.jpg"),
                fit: BoxFit.fill)),
        child: Container(
          height: double.infinity,
          color: Colors.black.withOpacity(0.8),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: StreamBuilder<List<LabSubjectsConvertor>>(
                      stream: readLabSubjects(widget.branch),
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
                              return const Center(
                                  child: Text(
                                      'Error with TextBooks Data or\n Check Internet Connection'));
                            } else {
                              return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: LabSubjects!.length,
                                itemBuilder: (context, int index) {
                                  final LabSubjectsData = LabSubjects[index];

                                  final Uri uri =
                                      Uri.parse(LabSubjectsData.PhotoUrl);
                                  final String fileName = uri.pathSegments.last;
                                  var name = fileName.split("/").last;
                                  final file = File(
                                      "${folderPath}/${widget.branch.toLowerCase()}_labsubjects/$name");
                                  if (file.existsSync()) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 5, left: 5, right: 5),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.black38,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: SingleChildScrollView(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 90.0,
                                                      height: 70.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8.0)),
                                                        color: Colors.redAccent,
                                                        image: DecorationImage(
                                                          image:
                                                              FileImage(file),
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
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              LabSubjectsData
                                                                  .heading,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 20.0,
                                                                color: Colors
                                                                    .orangeAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            InkWell(
                                                              child: StreamBuilder<
                                                                  DocumentSnapshot>(
                                                                stream: FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        widget
                                                                            .branch)
                                                                    .doc(
                                                                        "LabSubjects")
                                                                    .collection(
                                                                        "LabSubjects")
                                                                    .doc(
                                                                        LabSubjectsData
                                                                            .id)
                                                                    .collection(
                                                                        "likes")
                                                                    .doc(
                                                                        fullUserId())
                                                                    .snapshots(),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    if (snapshot
                                                                        .data!
                                                                        .exists) {
                                                                      return const Icon(
                                                                        Icons
                                                                            .favorite,
                                                                        color: Colors
                                                                            .red,
                                                                        size:
                                                                            26,
                                                                      );
                                                                    } else {
                                                                      return const Icon(
                                                                        Icons
                                                                            .favorite_border,
                                                                        color: Colors
                                                                            .red,
                                                                        size:
                                                                            26,
                                                                      );
                                                                    }
                                                                  } else {
                                                                    return Container();
                                                                  }
                                                                },
                                                              ),
                                                              onTap: () async {
                                                                try {
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          widget
                                                                              .branch)
                                                                      .doc(
                                                                          "LabSubjects")
                                                                      .collection(
                                                                          "LabSubjects")
                                                                      .doc(LabSubjectsData
                                                                          .id)
                                                                      .collection(
                                                                          "likes")
                                                                      .doc(
                                                                          fullUserId())
                                                                      .get()
                                                                      .then(
                                                                          (docSnapshot) {
                                                                    if (docSnapshot
                                                                        .exists) {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(widget
                                                                              .branch)
                                                                          .doc(
                                                                              "LabSubjects")
                                                                          .collection(
                                                                              "LabSubjects")
                                                                          .doc(LabSubjectsData
                                                                              .id)
                                                                          .collection(
                                                                              "likes")
                                                                          .doc(
                                                                              fullUserId())
                                                                          .delete();
                                                                      showToastText(
                                                                          "Unliked");
                                                                    } else {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(widget
                                                                              .branch)
                                                                          .doc(
                                                                              "LabSubjects")
                                                                          .collection(
                                                                              "LabSubjects")
                                                                          .doc(LabSubjectsData
                                                                              .id)
                                                                          .collection(
                                                                              "likes")
                                                                          .doc(
                                                                              fullUserId())
                                                                          .set({
                                                                        "id":
                                                                            fullUserId()
                                                                      });
                                                                      showToastText(
                                                                          "Liked");
                                                                    }
                                                                  });
                                                                } catch (e) {
                                                                  print(e);
                                                                }
                                                              },
                                                            ),
                                                            StreamBuilder<
                                                                QuerySnapshot>(
                                                              stream: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      widget
                                                                          .branch)
                                                                  .doc(
                                                                      "LabSubjects")
                                                                  .collection(
                                                                      "LabSubjects")
                                                                  .doc(
                                                                      LabSubjectsData
                                                                          .id)
                                                                  .collection(
                                                                      "likes")
                                                                  .snapshots(),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  return Text(
                                                                    " ${snapshot.data!.docs.length}",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .white),
                                                                  );
                                                                } else {
                                                                  return const Text(
                                                                      "0");
                                                                }
                                                              },
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            InkWell(
                                                              child: StreamBuilder<
                                                                  DocumentSnapshot>(
                                                                stream: FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'user')
                                                                    .doc(
                                                                        fullUserId())
                                                                    .collection(
                                                                        "FavouriteLabSubjects")
                                                                    .doc(
                                                                        LabSubjectsData
                                                                            .id)
                                                                    .snapshots(),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    if (snapshot
                                                                        .data!
                                                                        .exists) {
                                                                      return const Icon(
                                                                          Icons
                                                                              .library_add_check,
                                                                          size:
                                                                              26,
                                                                          color:
                                                                              Colors.cyanAccent);
                                                                    } else {
                                                                      return const Icon(
                                                                        Icons
                                                                            .library_add_outlined,
                                                                        size:
                                                                            26,
                                                                        color: Colors
                                                                            .cyanAccent,
                                                                      );
                                                                    }
                                                                  } else {
                                                                    return Container();
                                                                  }
                                                                },
                                                              ),
                                                              onTap: () async {
                                                                try {
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'user')
                                                                      .doc(
                                                                          fullUserId())
                                                                      .collection(
                                                                          "FavouriteLabSubjects")
                                                                      .doc(LabSubjectsData
                                                                          .id)
                                                                      .get()
                                                                      .then(
                                                                          (docSnapshot) {
                                                                    if (docSnapshot
                                                                        .exists) {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'user')
                                                                          .doc(
                                                                              fullUserId())
                                                                          .collection(
                                                                              "FavouriteLabSubjects")
                                                                          .doc(LabSubjectsData
                                                                              .id)
                                                                          .delete();
                                                                      showToastText(
                                                                          "Removed from saved list");
                                                                    } else {
                                                                      FavouriteLabSubjectsSubjects(
                                                                          branch: widget
                                                                              .branch,
                                                                          SubjectId: LabSubjectsData
                                                                              .id,
                                                                          name: LabSubjectsData
                                                                              .heading,
                                                                          description: LabSubjectsData
                                                                              .description,
                                                                          photoUrl:
                                                                              LabSubjectsData.PhotoUrl);
                                                                      showToastText(
                                                                          "${LabSubjectsData.heading} in favorites");
                                                                    }
                                                                  });
                                                                } catch (e) {
                                                                  print(e);
                                                                }
                                                              },
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          LabSubjectsData
                                                              .description,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 13.0,
                                                            color: Colors
                                                                .lightBlueAccent,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 1,
                                                        ),
                                                        Text(
                                                          'Added :${LabSubjectsData.Date}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 9.0,
                                                            color:
                                                                Colors.white60,
                                                            //   fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        if (userId())
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 10),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.5),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              child: InkWell(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right: 10,
                                                                      top: 5,
                                                                      bottom:
                                                                          5),
                                                                  child: Text(
                                                                      "+Add"),
                                                                ),
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => SubjectsCreator(
                                                                                branch: widget.branch,
                                                                                Id: LabSubjectsData.id,
                                                                                heading: LabSubjectsData.heading,
                                                                                description: LabSubjectsData.description,
                                                                                photoUrl: LabSubjectsData.PhotoUrl,
                                                                                mode: "LabSubjects",
                                                                              )));
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: () async {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          subjectUnitsData(
                                                            branch:
                                                                widget.branch,
                                                            ID: LabSubjectsData
                                                                .id,
                                                            mode: "LabSubjects",
                                                            name:
                                                                LabSubjectsData
                                                                    .heading,
                                                            fullName:
                                                                LabSubjectsData
                                                                    .description,
                                                            photoUrl:
                                                                LabSubjectsData
                                                                    .PhotoUrl,
                                                          )));
                                            },
                                            onLongPress: () {
                                              FavouriteLabSubjectsSubjects(
                                                  branch: widget.branch,
                                                  SubjectId: LabSubjectsData.id,
                                                  name: LabSubjectsData.heading,
                                                  description: LabSubjectsData
                                                      .description,
                                                  photoUrl:
                                                      LabSubjectsData.PhotoUrl);
                                            },
                                          ),
                                          // if ((index + 1) % 2 == 0)
                                          //   CustomBannerAd01(),
                                        ],
                                      ),
                                    );
                                  } else {
                                    download(LabSubjectsData.PhotoUrl,
                                        "${widget.branch.toLowerCase()}_labsubjects");
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 5, left: 5, right: 5),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.black38,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: SingleChildScrollView(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 80.0,
                                                      height: 70.0,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            LabSubjectsData
                                                                .PhotoUrl,
                                                        placeholder: (context,
                                                                url) =>
                                                            CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(
                                                          Icons.error,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
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
                                                              LabSubjectsData
                                                                  .heading,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 20.0,
                                                                color: Colors
                                                                    .orangeAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            InkWell(
                                                              child: StreamBuilder<
                                                                  DocumentSnapshot>(
                                                                stream: FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        widget
                                                                            .branch)
                                                                    .doc(
                                                                        "LabSubjects")
                                                                    .collection(
                                                                        "LabSubjects")
                                                                    .doc(
                                                                        LabSubjectsData
                                                                            .id)
                                                                    .collection(
                                                                        "likes")
                                                                    .doc(
                                                                        fullUserId())
                                                                    .snapshots(),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    if (snapshot
                                                                        .data!
                                                                        .exists) {
                                                                      return const Icon(
                                                                        Icons
                                                                            .favorite,
                                                                        color: Colors
                                                                            .red,
                                                                        size:
                                                                            26,
                                                                      );
                                                                    } else {
                                                                      return const Icon(
                                                                        Icons
                                                                            .favorite_border,
                                                                        color: Colors
                                                                            .red,
                                                                        size:
                                                                            26,
                                                                      );
                                                                    }
                                                                  } else {
                                                                    return Container();
                                                                  }
                                                                },
                                                              ),
                                                              onTap: () async {
                                                                try {
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          widget
                                                                              .branch)
                                                                      .doc(
                                                                          "LabSubjects")
                                                                      .collection(
                                                                          "LabSubjects")
                                                                      .doc(LabSubjectsData
                                                                          .id)
                                                                      .collection(
                                                                          "likes")
                                                                      .doc(
                                                                          fullUserId())
                                                                      .get()
                                                                      .then(
                                                                          (docSnapshot) {
                                                                    if (docSnapshot
                                                                        .exists) {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(widget
                                                                              .branch)
                                                                          .doc(
                                                                              "LabSubjects")
                                                                          .collection(
                                                                              "LabSubjects")
                                                                          .doc(LabSubjectsData
                                                                              .id)
                                                                          .collection(
                                                                              "likes")
                                                                          .doc(
                                                                              fullUserId())
                                                                          .delete();
                                                                      showToastText(
                                                                          "Unliked");
                                                                    } else {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(widget
                                                                              .branch)
                                                                          .doc(
                                                                              "LabSubjects")
                                                                          .collection(
                                                                              "LabSubjects")
                                                                          .doc(LabSubjectsData
                                                                              .id)
                                                                          .collection(
                                                                              "likes")
                                                                          .doc(
                                                                              fullUserId())
                                                                          .set({
                                                                        "id":
                                                                            fullUserId()
                                                                      });
                                                                      showToastText(
                                                                          "Liked");
                                                                    }
                                                                  });
                                                                } catch (e) {
                                                                  print(e);
                                                                }
                                                              },
                                                            ),
                                                            StreamBuilder<
                                                                QuerySnapshot>(
                                                              stream: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      widget
                                                                          .branch)
                                                                  .doc(
                                                                      "LabSubjects")
                                                                  .collection(
                                                                      "LabSubjects")
                                                                  .doc(
                                                                      LabSubjectsData
                                                                          .id)
                                                                  .collection(
                                                                      "likes")
                                                                  .snapshots(),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  return Text(
                                                                    " ${snapshot.data!.docs.length}",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .white),
                                                                  );
                                                                } else {
                                                                  return const Text(
                                                                      "0");
                                                                }
                                                              },
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            InkWell(
                                                              child: StreamBuilder<
                                                                  DocumentSnapshot>(
                                                                stream: FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'user')
                                                                    .doc(
                                                                        fullUserId())
                                                                    .collection(
                                                                        "FavouriteLabSubjects")
                                                                    .doc(
                                                                        LabSubjectsData
                                                                            .id)
                                                                    .snapshots(),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    if (snapshot
                                                                        .data!
                                                                        .exists) {
                                                                      return const Icon(
                                                                          Icons
                                                                              .library_add_check,
                                                                          size:
                                                                              26,
                                                                          color:
                                                                              Colors.cyanAccent);
                                                                    } else {
                                                                      return const Icon(
                                                                        Icons
                                                                            .library_add_outlined,
                                                                        size:
                                                                            26,
                                                                        color: Colors
                                                                            .cyanAccent,
                                                                      );
                                                                    }
                                                                  } else {
                                                                    return Container();
                                                                  }
                                                                },
                                                              ),
                                                              onTap: () async {
                                                                try {
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'user')
                                                                      .doc(
                                                                          fullUserId())
                                                                      .collection(
                                                                          "FavouriteLabSubjects")
                                                                      .doc(LabSubjectsData
                                                                          .id)
                                                                      .get()
                                                                      .then(
                                                                          (docSnapshot) {
                                                                    if (docSnapshot
                                                                        .exists) {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'user')
                                                                          .doc(
                                                                              fullUserId())
                                                                          .collection(
                                                                              "FavouriteLabSubjects")
                                                                          .doc(LabSubjectsData
                                                                              .id)
                                                                          .delete();
                                                                      showToastText(
                                                                          "Removed from saved list");
                                                                    } else {
                                                                      FavouriteLabSubjectsSubjects(
                                                                          branch: widget
                                                                              .branch,
                                                                          SubjectId: LabSubjectsData
                                                                              .id,
                                                                          name: LabSubjectsData
                                                                              .heading,
                                                                          description: LabSubjectsData
                                                                              .description,
                                                                          photoUrl:
                                                                              LabSubjectsData.PhotoUrl);
                                                                      showToastText(
                                                                          "${LabSubjectsData.heading} in favorites");
                                                                    }
                                                                  });
                                                                } catch (e) {
                                                                  print(e);
                                                                }
                                                              },
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          LabSubjectsData
                                                              .description,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 13.0,
                                                            color: Colors
                                                                .lightBlueAccent,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 1,
                                                        ),
                                                        Text(
                                                          'Added :${LabSubjectsData.Date}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 9.0,
                                                            color:
                                                                Colors.white60,
                                                            //   fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        if (userId())
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 10),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.5),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              child: InkWell(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right: 10,
                                                                      top: 5,
                                                                      bottom:
                                                                          5),
                                                                  child: Text(
                                                                      "+Add"),
                                                                ),
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => SubjectsCreator(
                                                                                branch: widget.branch,
                                                                                Id: LabSubjectsData.id,
                                                                                heading: LabSubjectsData.heading,
                                                                                description: LabSubjectsData.description,
                                                                                photoUrl: LabSubjectsData.PhotoUrl,
                                                                                mode: "LabSubjects",
                                                                              )));
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: () async {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          subjectUnitsData(
                                                            branch:
                                                                widget.branch,
                                                            ID: LabSubjectsData
                                                                .id,
                                                            mode: "LabSubjects",
                                                            name:
                                                                LabSubjectsData
                                                                    .heading,
                                                            fullName:
                                                                LabSubjectsData
                                                                    .description,
                                                            photoUrl:
                                                                LabSubjectsData
                                                                    .PhotoUrl,
                                                          )));
                                            },
                                            onLongPress: () {
                                              FavouriteLabSubjectsSubjects(
                                                  branch: widget.branch,
                                                  SubjectId: LabSubjectsData.id,
                                                  name: LabSubjectsData.heading,
                                                  description: LabSubjectsData
                                                      .description,
                                                  photoUrl:
                                                      LabSubjectsData.PhotoUrl);
                                            },
                                          ),
                                          // if ((index + 1) % 2 == 0)
                                          //   CustomBannerAd01(),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              );
                            }
                        }
                      }),
                ),
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white.withOpacity(0.3)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${widget.branch} Lab Subjects",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class allBooks extends StatefulWidget {
  final String branch;

  const allBooks({Key? key, required this.branch}) : super(key: key);

  @override
  State<allBooks> createState() => _allBooksState();
}

class _allBooksState extends State<allBooks> {
  String folderPath = "";

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}/';
    });
  }

  downloadImage(String photoUrl, String path) async {
    final Uri uri = Uri.parse(photoUrl);
    final String fileName = uri.pathSegments.last;
    var name = fileName.split("/").last;

    final ref = FirebaseStorage.instance.ref().child(fileName);
    final url = await ref.getDownloadURL();
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory('${documentDirectory.path}/$path');
    if (!await newDirectory.exists()) {
      await newDirectory.create(recursive: true);
      final file = File('${newDirectory.path}/${name}');
      await file.writeAsBytes(response.bodyBytes);
      showToastText(file.path);
    } else {
      final file = File('${newDirectory.path}/${name}');
      await file.writeAsBytes(response.bodyBytes);
      showToastText(file.path);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://i.pinimg.com/736x/01/c7/f7/01c7f72511cc6ce7858e65b45d4f8c9c.jpg"),
                fit: BoxFit.fill)),
        child: Container(
          height: double.infinity,
          color: Colors.black.withOpacity(0.8),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: StreamBuilder<List<BooksConvertor>>(
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
                              return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: Books!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final Uri uri =
                                      Uri.parse(Books[index].photoUrl);
                                  final String fileName = uri.pathSegments.last;
                                  var name = fileName.split("/").last;
                                  final file = File(
                                      "${folderPath}/${widget.branch.toLowerCase()}_books/$name");

                                  final Uri uri1 = Uri.parse(Books[index].link);
                                  final String fileName1 =
                                      uri1.pathSegments.last;
                                  var name1 = fileName1.split("/").last;
                                  final file1 =
                                      File("${folderPath}/pdfs/$name1");

                                  if (file.existsSync()) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.black.withOpacity(0.3),
                                          border: Border.all(
                                              color: Colors.white
                                                  .withOpacity(0.3)),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Flexible(
                                                  flex: 2,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            1.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: Colors.white
                                                              .withOpacity(0.5),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white),
                                                          image:
                                                              DecorationImage(
                                                                  image:
                                                                      FileImage(
                                                                          file),
                                                                  fit: BoxFit
                                                                      .fill)),
                                                      height: 125,
                                                      width: 90,
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 4,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8,
                                                            top: 3,
                                                            bottom: 3,
                                                            right: 3),
                                                    child: Container(
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              Books[index]
                                                                  .heading,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .orange,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 18),
                                                              maxLines: 1,
                                                            ),
                                                            Text(
                                                              Books[index]
                                                                  .Author,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .lightBlueAccent,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 13),
                                                              maxLines: 1,
                                                            ),
                                                            Text(
                                                              Books[index]
                                                                  .edition,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontSize: 14),
                                                              maxLines: 1,
                                                            ),
                                                            Text(
                                                                Books[index]
                                                                    .description,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.8),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        15)),
                                                            SizedBox(
                                                              height: 8,
                                                            ),
                                                            Row(
                                                              children: [
                                                                if (file1
                                                                    .existsSync())
                                                                  InkWell(
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.5),
                                                                          border:
                                                                              Border.all(color: Colors.green),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 3,
                                                                              right: 3),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Icon(
                                                                                Icons.download_outlined,
                                                                                color: Colors.green,
                                                                              ),
                                                                              Text(
                                                                                " & ",
                                                                                style: TextStyle(color: Colors.white, fontSize: 20),
                                                                              ),
                                                                              Text(
                                                                                "Open",
                                                                                style: TextStyle(color: Colors.white, fontSize: 20),
                                                                              ),
                                                                              Icon(
                                                                                Icons.open_in_new,
                                                                                color: Colors.greenAccent,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => PdfViewerPage(pdfUrl: "${folderPath}/pdfs/$name1")));
                                                                      })
                                                                else
                                                                  InkWell(
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.5),
                                                                        border: Border.all(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                3,
                                                                            right:
                                                                                3),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.download_outlined,
                                                                              color: Colors.red,
                                                                            ),
                                                                            Text(
                                                                              " & ",
                                                                              style: TextStyle(color: Colors.white, fontSize: 20),
                                                                            ),
                                                                            Text(
                                                                              "Open",
                                                                              style: TextStyle(color: Colors.white, fontSize: 20),
                                                                            ),
                                                                            Icon(
                                                                              Icons.open_in_new,
                                                                              color: Colors.greenAccent,
                                                                            )
                                                                          ],
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    onTap:
                                                                        () async {
                                                                      showToastText(
                                                                          "Downloading...");
                                                                      await download(
                                                                          Books[index]
                                                                              .link,
                                                                          "pdfs");
                                                                      setState(
                                                                          () {
                                                                        showToastText(
                                                                            "Downloaded");
                                                                      });
                                                                    },
                                                                  ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                InkWell(
                                                                  child: StreamBuilder<
                                                                      DocumentSnapshot>(
                                                                    stream: FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'user')
                                                                        .doc(
                                                                            fullUserId())
                                                                        .collection(
                                                                            "FavouriteBooks")
                                                                        .doc(Books[index]
                                                                            .id)
                                                                        .snapshots(),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      if (snapshot
                                                                          .hasData) {
                                                                        if (snapshot
                                                                            .data!
                                                                            .exists) {
                                                                          return Row(
                                                                            children: [
                                                                              const Icon(Icons.library_add_check, size: 26, color: Colors.green),
                                                                              Text(
                                                                                "Saved",
                                                                                style: TextStyle(color: Colors.greenAccent, fontSize: 20),
                                                                              )
                                                                            ],
                                                                          );
                                                                        } else {
                                                                          return Row(
                                                                            children: [
                                                                              const Icon(
                                                                                Icons.library_add_outlined,
                                                                                size: 26,
                                                                                color: Colors.cyan,
                                                                              ),
                                                                              Text(
                                                                                "Save",
                                                                                style: TextStyle(color: Colors.cyanAccent, fontSize: 20),
                                                                              )
                                                                            ],
                                                                          );
                                                                        }
                                                                      } else {
                                                                        return Row(
                                                                          children: [
                                                                            const Icon(
                                                                              Icons.library_add_outlined,
                                                                              size: 26,
                                                                              color: Colors.cyan,
                                                                            ),
                                                                            Text(
                                                                              "Save",
                                                                              style: TextStyle(color: Colors.cyanAccent, fontSize: 20),
                                                                            )
                                                                          ],
                                                                        );
                                                                      }
                                                                    },
                                                                  ),
                                                                  onTap:
                                                                      () async {
                                                                    try {
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'user')
                                                                          .doc(
                                                                              fullUserId())
                                                                          .collection(
                                                                              "FavouriteBooks")
                                                                          .doc(Books[index]
                                                                              .id)
                                                                          .get()
                                                                          .then(
                                                                              (docSnapshot) {
                                                                        if (docSnapshot
                                                                            .exists) {
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('user')
                                                                              .doc(fullUserId())
                                                                              .collection("FavouriteBooks")
                                                                              .doc(Books[index].id)
                                                                              .delete();
                                                                          showToastText(
                                                                              "Removed from saved list");
                                                                        } else {
                                                                          FavouriteBooksSubjects(
                                                                              description: Books[index].description,
                                                                              heading: Books[index].heading,
                                                                              link: Books[index].link,
                                                                              photoUrl: Books[index].photoUrl,
                                                                              Author: Books[index].Author,
                                                                              edition: Books[index].edition,
                                                                              branch: widget.branch,
                                                                              id: Books[index].id);
                                                                          showToastText(
                                                                              "${Books[index].heading} in favorites");
                                                                        }
                                                                      });
                                                                    } catch (e) {
                                                                      print(e);
                                                                    }
                                                                  },
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (userId())
                                              Row(
                                                children: [
                                                  Spacer(),
                                                  InkWell(
                                                    child: Chip(
                                                      elevation: 20,
                                                      backgroundColor:
                                                          Colors.black,
                                                      avatar: CircleAvatar(
                                                          backgroundColor:
                                                              Colors.black45,
                                                          child: Icon(
                                                            Icons.edit_outlined,
                                                          )),
                                                      label: Text(
                                                        "Edit",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      BooksCreator(
                                                                        branch:
                                                                            widget.branch,
                                                                        id: Books[index]
                                                                            .id,
                                                                        heading:
                                                                            Books[index].heading,
                                                                        description:
                                                                            Books[index].description,
                                                                        Edition:
                                                                            Books[index].edition,
                                                                        Link: Books[index]
                                                                            .link,
                                                                        Author:
                                                                            Books[index].Author,
                                                                        photoUrl:
                                                                            Books[index].photoUrl,
                                                                      )));
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  InkWell(
                                                    child: Chip(
                                                      elevation: 20,
                                                      backgroundColor:
                                                          Colors.black,
                                                      avatar: CircleAvatar(
                                                          backgroundColor:
                                                              Colors.black45,
                                                          child: Icon(
                                                            Icons
                                                                .delete_rounded,
                                                          )),
                                                      label: Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              widget.branch)
                                                          .doc("Books")
                                                          .collection(
                                                              "CoreBooks")
                                                          .doc(Books[index].id)
                                                          .delete();
                                                    },
                                                  ),
                                                  Spacer()
                                                ],
                                              ),
                                            // if ((index + 1) % 3 == 0)
                                            //   CustomBannerAd01(),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    downloadImage(Books[index].photoUrl,
                                        "${widget.branch.toLowerCase()}_books");
                                    return InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, top: 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            border:
                                                Border.all(color: Colors.white),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Colors.white
                                                            .withOpacity(0.5),
                                                        border: Border.all(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      child: Image.network(
                                                        Books[index].photoUrl,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      height: 135,
                                                      width: 90,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(Books[index]
                                                                .heading),
                                                            Text(Books[index]
                                                                .Author),
                                                            Text(Books[index]
                                                                .edition),
                                                            Text(Books[index]
                                                                .description),
                                                            SizedBox(
                                                              height: 8,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 8),
                                                              child: InkWell(
                                                                child:
                                                                    Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(15),
                                                                          color: Colors
                                                                              .white
                                                                              .withOpacity(0.5),
                                                                          border:
                                                                              Border.all(color: Colors.white),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Text("Download"),
                                                                        )),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                ],
                                              ),
                                              if (userId())
                                                Row(
                                                  children: [
                                                    Spacer(),
                                                    InkWell(
                                                      child: Chip(
                                                        elevation: 20,
                                                        backgroundColor:
                                                            Colors.black,
                                                        avatar: CircleAvatar(
                                                            backgroundColor:
                                                                Colors.black45,
                                                            child: Icon(
                                                              Icons
                                                                  .edit_outlined,
                                                            )),
                                                        label: Text(
                                                          "Edit",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        BooksCreator(
                                                                          branch:
                                                                              widget.branch,
                                                                          id: Books[index]
                                                                              .id,
                                                                          heading:
                                                                              Books[index].heading,
                                                                          description:
                                                                              Books[index].description,
                                                                          Edition:
                                                                              Books[index].edition,
                                                                          Link:
                                                                              Books[index].link,
                                                                          Author:
                                                                              Books[index].Author,
                                                                          photoUrl:
                                                                              Books[index].photoUrl,
                                                                        )));
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    InkWell(
                                                      child: Chip(
                                                        elevation: 20,
                                                        backgroundColor:
                                                            Colors.black,
                                                        avatar: CircleAvatar(
                                                            backgroundColor:
                                                                Colors.black45,
                                                            child: Icon(
                                                              Icons
                                                                  .delete_rounded,
                                                            )),
                                                        label: Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                widget.branch)
                                                            .doc("Books")
                                                            .collection(
                                                                "CoreBooks")
                                                            .doc(
                                                                Books[index].id)
                                                            .delete();
                                                      },
                                                    ),
                                                    Spacer()
                                                  ],
                                                ),
                                              // if ((index + 1) % 3 == 0)
                                              //   CustomBannerAd01(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        LaunchUrl(Books[index].link);
                                      },
                                    );
                                  }
                                },
                              );
                            }
                        }
                      }),
                ),
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white.withOpacity(0.3)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${widget.branch} Books",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class subjectUnitsData extends StatefulWidget {
  String ID, mode;
  String name;
  String fullName;
  String photoUrl;
  String branch;

  subjectUnitsData(
      {required this.ID,
      required this.mode,
      required this.photoUrl,
      required this.branch,
      this.name = "Subjects",
      required this.fullName});

  @override
  State<subjectUnitsData> createState() => _subjectUnitsDataState();
}

class _subjectUnitsDataState extends State<subjectUnitsData> {
  bool isReadMore = false;
  bool isDownloaded = false;
  String folderPath = "";
  File file = File("");

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final Uri uri = Uri.parse(widget.photoUrl);
    final String fileName = uri.pathSegments.last;
    var name = fileName.split("/").last;
    setState(() {
      folderPath = '${directory.path}/';
      if (widget.mode == "Subjects") {
        file =
            File("${folderPath}/${widget.branch.toLowerCase()}_subjects/$name");
      } else {
        file = File(
            "${folderPath}/${widget.branch.toLowerCase()}_labsubjects/$name");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://i.pinimg.com/736x/01/c7/f7/01c7f72511cc6ce7858e65b45d4f8c9c.jpg"),
                  fit: BoxFit.fill)),
          child: Container(
            color: Colors.black.withOpacity(0.9),
            child: SafeArea(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 145),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Units",
                                  style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.deepOrangeAccent),
                                ),
                                if (userId())
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: InkWell(
                                      child: Chip(
                                        elevation: 20,
                                        backgroundColor: Colors.white38,
                                        avatar: CircleAvatar(
                                            backgroundColor: Colors.black,
                                            child: Icon(
                                              Icons.add,
                                            )),
                                        label: Text(
                                          "ADD",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UnitsCreator(
                                                      branch: widget.branch,
                                                      id: widget.ID,
                                                      mode: widget.mode,
                                                    )));
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          StreamBuilder<List<UnitsConvertor>>(
                              stream: readUnits(widget.ID, widget.branch),
                              builder: (context, snapshot) {
                                final Units = snapshot.data;
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
                                      return Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: ListView.separated(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: Units!.length,
                                              itemBuilder:
                                                  (context, int index) {
                                                final unit = Units[index];

                                                return subUnit(
                                                  ID: widget.ID,
                                                  branch: widget.branch,
                                                  unit: unit,
                                                  mode: widget.mode,
                                                  photoUrl: widget.photoUrl,
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const SizedBox(
                                                        height: 5,
                                                      )));
                                    }
                                }
                              }),
                          // if (widget.mode == "Subjects")
                          //   StreamBuilder<List<TextBooksConvertor>>(
                          //       stream: readUnitTextBooks(widget.ID),
                          //       builder: (context, snapshot) {
                          //         final Units = snapshot.data;
                          //         switch (snapshot.connectionState) {
                          //           case ConnectionState.waiting:
                          //             return const Center(
                          //                 child: CircularProgressIndicator(
                          //               strokeWidth: 0.3,
                          //               color: Colors.cyan,
                          //             ));
                          //           default:
                          //             if (snapshot.hasError) {
                          //               return const Center(
                          //                   child: Text(
                          //                       'Error with TextBooks Data or\n Check Internet Connection'));
                          //             } else {
                          //               return Column(
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.start,
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.start,
                          //                 children: [
                          //                   Padding(
                          //                     padding: const EdgeInsets.only(
                          //                         left: 10,
                          //                         top: 20,
                          //                         bottom: 8),
                          //                     child: Text(
                          //                       "Text Books",
                          //                       style: TextStyle(
                          //                           fontSize: 30,
                          //                           color: Colors.white),
                          //                     ),
                          //                   ),
                          //                   if (Units!.length > 0)
                          //                     Container(
                          //                       height: 168,
                          //                       child: ListView.builder(
                          //                         physics:
                          //                             BouncingScrollPhysics(),
                          //                         shrinkWrap: true,
                          //                         itemCount: Units!.length,
                          //                         scrollDirection:
                          //                             Axis.horizontal,
                          //                         itemBuilder:
                          //                             (BuildContext context,
                          //                                 int index) {
                          //                           final SubjectsData =
                          //                               Units[index];
                          //                           return InkWell(
                          //                             child: Padding(
                          //                               padding:
                          //                                   const EdgeInsets
                          //                                           .only(
                          //                                       left: 10),
                          //                               child: Container(
                          //                                 width: 125,
                          //                                 decoration:
                          //                                     BoxDecoration(
                          //                                   color: Colors
                          //                                       .white
                          //                                       .withOpacity(
                          //                                           0.25),
                          //                                   borderRadius:
                          //                                       BorderRadius
                          //                                           .circular(
                          //                                               15),
                          //                                 ),
                          //                                 child: Column(
                          //                                   children: [
                          //                                     Container(
                          //                                       height: 155,
                          //                                       alignment:
                          //                                           Alignment
                          //                                               .center,
                          //                                       decoration:
                          //                                           BoxDecoration(
                          //                                               color: Colors
                          //                                                   .black54,
                          //                                               borderRadius: BorderRadius.circular(
                          //                                                   15),
                          //                                               image:
                          //                                                   DecorationImage(
                          //                                                 image:
                          //                                                     NetworkImage(
                          //                                                   "SubjectsData.photoUrl",
                          //                                                 ),
                          //                                                 fit:
                          //                                                     BoxFit.cover,
                          //                                               )),
                          //                                       child: Align(
                          //                                         alignment:
                          //                                             Alignment
                          //                                                 .bottomLeft,
                          //                                         child:
                          //                                             Container(
                          //                                           decoration:
                          //                                               BoxDecoration(
                          //                                             color: Colors
                          //                                                 .black
                          //                                                 .withOpacity(0.4),
                          //                                             borderRadius:
                          //                                                 BorderRadius.circular(15),
                          //                                           ),
                          //                                           child:
                          //                                               Padding(
                          //                                             padding:
                          //                                                 const EdgeInsets.all(4.0),
                          //                                             child:
                          //                                                 Text(
                          //                                               SubjectsData
                          //                                                   .heading,
                          //                                               style: const TextStyle(
                          //                                                   fontWeight: FontWeight.w400,
                          //                                                   fontSize: 16,
                          //                                                   color: Colors.white),
                          //                                               maxLines:
                          //                                                   2,
                          //                                               overflow:
                          //                                                   TextOverflow.ellipsis,
                          //                                             ),
                          //                                           ),
                          //                                         ),
                          //                                       ),
                          //                                     ),
                          //                                     Padding(
                          //                                       padding: const EdgeInsets
                          //                                               .only(
                          //                                           left: 10,
                          //                                           right:
                          //                                               10),
                          //                                       child: Text(
                          //                                         "by {SubjectsData.creator}",
                          //                                         style: const TextStyle(
                          //                                             fontWeight:
                          //                                                 FontWeight
                          //                                                     .w400,
                          //                                             fontSize:
                          //                                                 11,
                          //                                             color: Color.fromRGBO(
                          //                                                 164,
                          //                                                 209,
                          //                                                 245,
                          //                                                 1)),
                          //                                         maxLines: 1,
                          //                                       ),
                          //                                     )
                          //                                   ],
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                             onTap: () async {},
                          //                           );
                          //                         },
                          //                       ),
                          //                     )
                          //                   else
                          //                     Text("No TextBook")
                          //                 ],
                          //               );
                          //             }
                          //         }
                          //       }),
                          // StreamBuilder<List<UnitsConvertor>>(
                          //     stream: readUnits(widget.ID),
                          //     builder: (context, snapshot) {
                          //       final Units = snapshot.data;
                          //       switch (snapshot.connectionState) {
                          //         case ConnectionState.waiting:
                          //           return const Center(
                          //               child: CircularProgressIndicator(
                          //             strokeWidth: 0.3,
                          //             color: Colors.cyan,
                          //           ));
                          //         default:
                          //           if (snapshot.hasError) {
                          //             return const Center(
                          //                 child: Text(
                          //                     'Error with TextBooks Data or\n Check Internet Connection'));
                          //           } else {
                          //             return Column(
                          //               mainAxisAlignment:
                          //                   MainAxisAlignment.start,
                          //               crossAxisAlignment:
                          //                   CrossAxisAlignment.start,
                          //               children: [
                          //                 Padding(
                          //                   padding: const EdgeInsets.only(
                          //                       left: 10, top: 20, bottom: 8),
                          //                   child: Text(
                          //                     "Syllabus and Papers",
                          //                     style: TextStyle(
                          //                         fontSize: 30,
                          //                         color: Colors.white),
                          //                   ),
                          //                 ),
                          //                 Container(
                          //                   height: 168,
                          //                   child: ListView.builder(
                          //                     physics:
                          //                         BouncingScrollPhysics(),
                          //                     shrinkWrap: true,
                          //                     itemCount: Units!.length,
                          //                     scrollDirection:
                          //                         Axis.horizontal,
                          //                     itemBuilder:
                          //                         (BuildContext context,
                          //                             int index) {
                          //                       final SubjectsData =
                          //                           Units[index];
                          //                       return InkWell(
                          //                         child: Padding(
                          //                           padding:
                          //                               const EdgeInsets.only(
                          //                                   left: 10),
                          //                           child: Container(
                          //                             width: 130,
                          //                             decoration:
                          //                                 BoxDecoration(
                          //                               color: Colors.white
                          //                                   .withOpacity(
                          //                                       0.25),
                          //                               borderRadius:
                          //                                   BorderRadius
                          //                                       .circular(15),
                          //                             ),
                          //                             child: Column(
                          //                               children: [
                          //                                 Container(
                          //                                   height: 155,
                          //                                   alignment:
                          //                                       Alignment
                          //                                           .center,
                          //                                   decoration:
                          //                                       BoxDecoration(
                          //                                           color: Colors
                          //                                               .black54,
                          //                                           borderRadius:
                          //                                               BorderRadius.circular(
                          //                                                   15),
                          //                                           image:
                          //                                               DecorationImage(
                          //                                             image:
                          //                                                 NetworkImage(
                          //                                               "SubjectsData.photoUrl",
                          //                                             ),
                          //                                             fit: BoxFit
                          //                                                 .cover,
                          //                                           )),
                          //                                   child: Align(
                          //                                     alignment: Alignment
                          //                                         .bottomLeft,
                          //                                     child:
                          //                                         Container(
                          //                                       decoration:
                          //                                           BoxDecoration(
                          //                                         color: Colors
                          //                                             .black
                          //                                             .withOpacity(
                          //                                                 0.4),
                          //                                         borderRadius:
                          //                                             BorderRadius.circular(
                          //                                                 15),
                          //                                       ),
                          //                                       child:
                          //                                           Padding(
                          //                                         padding:
                          //                                             const EdgeInsets.all(
                          //                                                 4.0),
                          //                                         child: Text(
                          //                                           SubjectsData
                          //                                               .heading,
                          //                                           style: const TextStyle(
                          //                                               fontWeight: FontWeight
                          //                                                   .w400,
                          //                                               fontSize:
                          //                                                   16,
                          //                                               color:
                          //                                                   Colors.white),
                          //                                           maxLines:
                          //                                               2,
                          //                                           overflow:
                          //                                               TextOverflow
                          //                                                   .ellipsis,
                          //                                         ),
                          //                                       ),
                          //                                     ),
                          //                                   ),
                          //                                 ),
                          //                                 Padding(
                          //                                   padding:
                          //                                       const EdgeInsets
                          //                                               .only(
                          //                                           left: 10,
                          //                                           right:
                          //                                               10),
                          //                                   child: Text(
                          //                                     "by {SubjectsData.creator}",
                          //                                     style: const TextStyle(
                          //                                         fontWeight:
                          //                                             FontWeight
                          //                                                 .w400,
                          //                                         fontSize:
                          //                                             11,
                          //                                         color: Color
                          //                                             .fromRGBO(
                          //                                                 164,
                          //                                                 209,
                          //                                                 245,
                          //                                                 1)),
                          //                                     maxLines: 1,
                          //                                   ),
                          //                                 )
                          //                               ],
                          //                             ),
                          //                           ),
                          //                         ),
                          //                         onTap: () async {},
                          //                       );
                          //                     },
                          //                   ),
                          //                 ),
                          //               ],
                          //             );
                          //           }
                          //       }
                          //     }),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(29, 38, 38, 0.7),
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15)),
                                          image: DecorationImage(
                                              image: FileImage(file),
                                              fit: BoxFit.fill)),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              widget.name,
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.deepOrange,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.3),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            StreamBuilder<
                                                                DocumentSnapshot>(
                                                              stream: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      widget
                                                                          .branch)
                                                                  .doc(widget
                                                                      .mode)
                                                                  .collection(
                                                                      widget
                                                                          .mode)
                                                                  .doc(
                                                                      widget.ID)
                                                                  .collection(
                                                                      "likes")
                                                                  .doc(
                                                                      fullUserId())
                                                                  .snapshots(),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  if (snapshot
                                                                      .data!
                                                                      .exists) {
                                                                    return const Icon(
                                                                      Icons
                                                                          .favorite,
                                                                      color: Colors
                                                                          .red,
                                                                      size: 20,
                                                                    );
                                                                  } else {
                                                                    return const Icon(
                                                                      Icons
                                                                          .favorite_border,
                                                                      color: Colors
                                                                          .red,
                                                                      size: 20,
                                                                    );
                                                                  }
                                                                } else {
                                                                  return Container();
                                                                }
                                                              },
                                                            ),
                                                            StreamBuilder<
                                                                QuerySnapshot>(
                                                              stream: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      widget
                                                                          .branch)
                                                                  .doc(widget
                                                                      .mode)
                                                                  .collection(
                                                                      widget
                                                                          .mode)
                                                                  .doc(
                                                                      widget.ID)
                                                                  .collection(
                                                                      "likes")
                                                                  .snapshots(),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  return Text(
                                                                    "  ${snapshot.data!.docs.length}  Likes",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        color: Colors
                                                                            .white),
                                                                  );
                                                                } else {
                                                                  return const Text(
                                                                      "0",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              Colors.white));
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () async {
                                                      try {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                widget.branch)
                                                            .doc(widget.mode)
                                                            .collection(
                                                                widget.mode)
                                                            .doc(widget.ID)
                                                            .collection("likes")
                                                            .doc(fullUserId())
                                                            .get()
                                                            .then(
                                                                (docSnapshot) {
                                                          if (docSnapshot
                                                              .exists) {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    widget
                                                                        .branch)
                                                                .doc(
                                                                    widget.mode)
                                                                .collection(
                                                                    widget.mode)
                                                                .doc(widget.ID)
                                                                .collection(
                                                                    "likes")
                                                                .doc(
                                                                    fullUserId())
                                                                .delete();
                                                            showToastText(
                                                                "Unliked");
                                                          } else {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    widget
                                                                        .branch)
                                                                .doc(
                                                                    widget.mode)
                                                                .collection(
                                                                    widget.mode)
                                                                .doc(widget.ID)
                                                                .collection(
                                                                    "likes")
                                                                .doc(
                                                                    fullUserId())
                                                                .set({
                                                              "id": fullUserId()
                                                            });
                                                            showToastText(
                                                                "Liked");
                                                          }
                                                        });
                                                      } catch (e) {
                                                        print(e);
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.3),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              11)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10,
                                                            top: 3,
                                                            bottom: 3),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        if (widget.mode ==
                                                            "Subjects")
                                                          InkWell(
                                                            child: StreamBuilder<
                                                                DocumentSnapshot>(
                                                              stream: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'user')
                                                                  .doc(
                                                                      fullUserId())
                                                                  .collection(
                                                                      "FavouriteSubject")
                                                                  .doc(
                                                                      widget.ID)
                                                                  .snapshots(),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  if (snapshot
                                                                      .data!
                                                                      .exists) {
                                                                    return Row(
                                                                      children: [
                                                                        const Icon(
                                                                            Icons
                                                                                .library_add_check,
                                                                            size:
                                                                                23,
                                                                            color:
                                                                                Colors.cyanAccent),
                                                                        Text(
                                                                          " Saved",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 20),
                                                                        )
                                                                      ],
                                                                    );
                                                                  } else {
                                                                    return Row(
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .library_add_outlined,
                                                                          size:
                                                                              23,
                                                                          color:
                                                                              Colors.cyanAccent,
                                                                        ),
                                                                        Text(
                                                                          " Save",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 20),
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
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'user')
                                                                    .doc(
                                                                        fullUserId())
                                                                    .collection(
                                                                        "FavouriteSubject")
                                                                    .doc(widget
                                                                        .ID)
                                                                    .get()
                                                                    .then(
                                                                        (docSnapshot) {
                                                                  if (docSnapshot
                                                                      .exists) {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'user')
                                                                        .doc(
                                                                            fullUserId())
                                                                        .collection(
                                                                            "FavouriteSubject")
                                                                        .doc(widget
                                                                            .ID)
                                                                        .delete();
                                                                    showToastText(
                                                                        "Removed from saved list");
                                                                  } else {
                                                                    FavouriteSubjects(
                                                                        branch: widget
                                                                            .branch,
                                                                        SubjectId:
                                                                            widget
                                                                                .ID,
                                                                        name: widget
                                                                            .name,
                                                                        description:
                                                                            widget
                                                                                .fullName,
                                                                        photoUrl:
                                                                            widget.photoUrl);
                                                                    showToastText(
                                                                        "${widget.name} in favorites");
                                                                  }
                                                                });
                                                              } catch (e) {
                                                                print(e);
                                                              }
                                                            },
                                                          )
                                                        else
                                                          InkWell(
                                                            child: StreamBuilder<
                                                                DocumentSnapshot>(
                                                              stream: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'user')
                                                                  .doc(
                                                                      fullUserId())
                                                                  .collection(
                                                                      "FavouriteLabSubjects")
                                                                  .doc(
                                                                      widget.ID)
                                                                  .snapshots(),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  if (snapshot
                                                                      .data!
                                                                      .exists) {
                                                                    return Row(
                                                                      children: [
                                                                        const Icon(
                                                                            Icons
                                                                                .library_add_check,
                                                                            size:
                                                                                26,
                                                                            color:
                                                                                Colors.cyanAccent),
                                                                        Text(
                                                                          " Saved",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 16),
                                                                        )
                                                                      ],
                                                                    );
                                                                  } else {
                                                                    return Row(
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .library_add_outlined,
                                                                          size:
                                                                              26,
                                                                          color:
                                                                              Colors.cyanAccent,
                                                                        ),
                                                                        Text(
                                                                          " Save",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 16),
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
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'user')
                                                                    .doc(
                                                                        fullUserId())
                                                                    .collection(
                                                                        "FavouriteLabSubjects")
                                                                    .doc(widget
                                                                        .ID)
                                                                    .get()
                                                                    .then(
                                                                        (docSnapshot) {
                                                                  if (docSnapshot
                                                                      .exists) {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'user')
                                                                        .doc(
                                                                            fullUserId())
                                                                        .collection(
                                                                            "FavouriteLabSubjects")
                                                                        .doc(widget
                                                                            .ID)
                                                                        .delete();
                                                                    showToastText(
                                                                        "Removed from saved list");
                                                                  } else {
                                                                    FavouriteLabSubjectsSubjects(
                                                                        branch: widget
                                                                            .branch,
                                                                        SubjectId:
                                                                            widget
                                                                                .ID,
                                                                        name: widget
                                                                            .name,
                                                                        description:
                                                                            widget
                                                                                .fullName,
                                                                        photoUrl:
                                                                            widget.photoUrl);
                                                                    showToastText(
                                                                        "${widget.name} in favorites");
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
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 2, bottom: 3, right: 10),
                                child: Text(
                                  widget.fullName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      );

  Stream<List<UnitsConvertor>> readUnits(String subjectsID, String branch) =>
      FirebaseFirestore.instance
          .collection(branch)
          .doc(widget.mode)
          .collection(widget.mode)
          .doc(subjectsID)
          .collection("Units")
          .orderBy("Heading", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => UnitsConvertor.fromJson(doc.data()))
              .toList());

  Stream<List<TextBooksConvertor>> readUnitTextBooks(
          String subjectsID, String branch) =>
      FirebaseFirestore.instance
          .collection(branch)
          .doc(widget.mode)
          .collection(widget.mode)
          .doc(subjectsID)
          .collection("textBook")
          .orderBy("heading", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => TextBooksConvertor.fromJson(doc.data()))
              .toList());
}

Future createUnits(
    {required String mode,
    required String branch,
    required String heading,
    required String description,
    required String PDFSize,
    required String questions,
    required String PDFLink,
    required String subjectsID}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc(mode)
      .collection(mode)
      .doc(subjectsID)
      .collection("Units")
      .doc();
  final flash = UnitsConvertor(
      id: docflash.id,
      heading: heading,
      questions: questions,
      description: description,
      PDFSize: PDFSize,
      PDFLink: PDFLink,
      Date: getDate());
  final json = flash.toJson();
  await docflash.set(json);
}

class UnitsConvertor {
  String id;
  final String heading, questions, description, PDFSize, PDFLink, Date;

  UnitsConvertor(
      {this.id = "",
      required this.heading,
      required this.questions,
      required this.description,
      required this.PDFSize,
      required this.PDFLink,
      required this.Date});

  Map<String, dynamic> toJson() => {
        "id": id,
        "Heading": heading,
        "questions": questions,
        "Description": description,
        "PDFSize": PDFSize,
        "PDFLink": PDFLink,
        "Date": Date
      };

  static UnitsConvertor fromJson(Map<String, dynamic> json) => UnitsConvertor(
      PDFLink: json["PDFLink"],
      id: json['id'],
      heading: json["Heading"],
      questions: json["questions"],
      description: json["Description"],
      PDFSize: json["PDFSize"],
      Date: json["Date"]);
}

Future createUnitTextBooks(
    {required String mode,
    required String branch,
    required String heading,
    required String description,
    required String regulation,
    required String date,
    required String link,
    required String subjectsID}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc(mode)
      .collection(mode)
      .doc(subjectsID)
      .collection("textBooks")
      .doc();
  final flash = TextBooksConvertor(
      id: docflash.id,
      heading: heading,
      date: date,
      link: link,
      regulation: regulation);
  final json = flash.toJson();
  await docflash.set(json);
}

class TextBooksConvertor {
  String id;
  final String heading, link, date, regulation;

  TextBooksConvertor(
      {this.id = "",
      required this.heading,
      required this.regulation,
      required this.link,
      required this.date});

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "link": link,
        "date": date,
        "reg": regulation
      };

  static TextBooksConvertor fromJson(Map<String, dynamic> json) =>
      TextBooksConvertor(
          link: json["link"],
          id: json['id'],
          heading: json["heading"],
          date: json["date"],
          regulation: json['reg']);
}

class Units {
  String heading, description, pdfName, pdfSize, pdfLink;

  Units(
      {required this.heading,
      required this.description,
      required this.pdfSize,
      required this.pdfName,
      required this.pdfLink});

  static Units fromJson(json) => Units(
        heading: json['heading'],
        description: json['description'],
        pdfName: json['pdfName'],
        pdfSize: json['pdfSize'],
        pdfLink: json['pdfLink'],
      );
}

class subUnit extends StatefulWidget {
  final UnitsConvertor unit;
  final String mode;
  final String photoUrl;
  final String branch;
  final String ID;

  const subUnit(
      {Key? key,
      required this.unit,
      required this.mode,
      required this.photoUrl,
      required this.branch,
      required this.ID})
      : super(key: key);

  @override
  State<subUnit> createState() => _subUnitState();
}

class _subUnitState extends State<subUnit> {
  bool isReadMore = false;
  bool isQuestions = false;
  bool isDownloaded = false;
  String folderPath = "";
  File file = File("");
  bool isExp = false;
  List<String> newList = [];
  List<String> newQuestionsList = [];
  bool fullDescription = false;

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final Uri uri = Uri.parse(widget.photoUrl);
    final String fileName = uri.pathSegments.last;
    var name = fileName.split("/").last;
    setState(() {
      folderPath = '${directory.path}/';
      if (widget.mode == "Subjects") {
        file =
            File("${folderPath}/${widget.branch.toLowerCase()}_subjects/$name");
      } else {
        file = File(
            "${folderPath}/${widget.branch.toLowerCase()}_labsubjects/$name");
      }
    });
  }

  download(String photoUrl, String path) async {
    final Uri uri = Uri.parse(photoUrl);
    final String fileName = uri.pathSegments.last;
    var name = fileName.split("/").last;
    final response = await http.get(Uri.parse(photoUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory('${documentDirectory.path}/$path');
    if (!await newDirectory.exists()) {
      await newDirectory.create(recursive: true);
      final file = File('${newDirectory.path}/${name}');
      await file.writeAsBytes(response.bodyBytes);
      showToastText(file.path);
      setState(() {
        isDownloaded = false;
      });
    } else {
      final file = File('${newDirectory.path}/${name}');
      await file.writeAsBytes(response.bodyBytes);
      showToastText(file.path);
      setState(() {
        isDownloaded = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getPath();
    newQuestionsList = widget.unit.questions.split(";");
    newList = widget.unit.description.split(",");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Uri uri = Uri.parse(widget.unit.PDFLink);
    final String fileName = uri.pathSegments.last;
    var name = fileName.split("/").last;
    final file = File("${folderPath}/pdfs/$name");
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.07),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, top: 3, bottom: 2, right: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.unit.heading,
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                if (widget.unit.description.isNotEmpty)
                  InkWell(
                    child: Text(
                      "Read More ",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      setState(() {
                        isExp = !isExp;
                      });
                    },
                  )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  if (!fullDescription || !isExp)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white.withOpacity(0.07),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.black.withOpacity(0.5),
                                  border: Border.all(
                                      color: file.existsSync()
                                          ? Colors.green
                                          : Colors.white),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 3, right: 3),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            top: 3,
                                            bottom: 3),
                                        child: Text(
                                          file.existsSync()
                                              ? "Open"
                                              : "Download",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                      Icon(
                                        file.existsSync()
                                            ? Icons.open_in_new
                                            : Icons
                                                .download_for_offline_outlined,
                                        color: Colors.greenAccent,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () async {
                                if (file.existsSync()) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PdfViewerPage(
                                              pdfUrl:
                                                  "${folderPath}/pdfs/$name")));
                                } else {
                                  setState(() {
                                    isDownloaded = true;
                                  });
                                  await download(widget.unit.PDFLink, "pdfs");
                                }
                              }),
                          if (file.existsSync())
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, top: 1, bottom: 1),
                              child: InkWell(
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                  size: 25,
                                ),
                                onTap: () async {
                                  if (file.existsSync()) {
                                    await file.delete();
                                  }
                                  setState(() {});
                                  showToastText("File has been deleted");
                                },
                              ),
                            )
                        ],
                      ),
                    ),
                  if (isExp)
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color:
                                                Colors.white.withOpacity(0.09),
                                            border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.5)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              fullDescription
                                                  ? "collapse"
                                                  : "Expand",
                                              style: TextStyle(
                                                  color: Colors.lightBlueAccent,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          fullDescription = !fullDescription;
                                        });
                                      },
                                    ),
                                    if (widget.unit.questions.isNotEmpty)
                                      InkWell(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white
                                                  .withOpacity(0.09),
                                              border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.5)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                isQuestions
                                                    ? "Hide"
                                                    : "Questions",
                                                style: TextStyle(
                                                    color: isQuestions
                                                        ? Colors.redAccent
                                                        : Colors
                                                            .lightGreenAccent,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            isQuestions = !isQuestions;
                                          });
                                        },
                                      ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color:
                                                Colors.white.withOpacity(0.09),
                                            border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.5)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Icon(
                                              Icons.info_outline,
                                              size: 25,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 11, top: 5, bottom: 5),
                                  child: Text(
                                    "File Description...",
                                    style: TextStyle(
                                        color: Colors.orangeAccent,
                                        fontSize: 25),
                                  ),
                                ),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: newList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (newList.length > 1) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: InkWell(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  size: 8,
                                                  color: Colors.lightBlueAccent,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    newList[index],
                                                    style: const TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              int indexNumber = 0;
                                              try {
                                                indexNumber = int.parse(
                                                        newList[index]
                                                            .split('@')
                                                            .last
                                                            .trim()) -
                                                    2;
                                              } catch (e) {
                                                indexNumber = 0;
                                              }
                                              if (file.existsSync()) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PdfViewerPage(
                                                              pdfUrl:
                                                                  "${folderPath}/pdfs/$name",
                                                              defaultPage:
                                                                  indexNumber,
                                                            )));
                                              } else {
                                                showToastText("Download PDF");
                                              }
                                            },
                                          ),
                                        );
                                      } else {
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              newList[0],
                                              style: const TextStyle(
                                                  color: Colors.amberAccent,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        );
                                      }
                                    })
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (isQuestions)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 10),
                    child: Text(
                      "Questions...",
                      style:
                          TextStyle(color: Colors.orangeAccent, fontSize: 25),
                    ),
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: newQuestionsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (newQuestionsList.length > 1) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: InkWell(
                              child: Row(
                                children: [
                                  Text("${index + 1}. ",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18)),
                                  Expanded(
                                    child: Text(
                                      newQuestionsList[index],
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                int indexNumber = 0;
                                try {
                                  indexNumber = int.parse(newList[index]
                                          .split('@')
                                          .last
                                          .trim()) -
                                      2;
                                } catch (e) {
                                  indexNumber = 0;
                                }
                                if (file.existsSync()) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PdfViewerPage(
                                                pdfUrl:
                                                    "${folderPath}/pdfs/$name",
                                                defaultPage: indexNumber,
                                              )));
                                } else {
                                  showToastText("Download PDF");
                                }
                              },
                            ),
                          );
                        } else {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                newQuestionsList[0],
                                style: const TextStyle(
                                    color: Colors.amberAccent, fontSize: 18),
                              ),
                            ),
                          );
                        }
                      }),
                ],
              ),
            if (userId())
              Row(
                children: [
                  InkWell(
                    child: Chip(
                      elevation: 20,
                      backgroundColor: Colors.black,
                      avatar: CircleAvatar(
                          backgroundColor: Colors.black45,
                          child: Icon(
                            Icons.edit_outlined,
                          )),
                      label: Text(
                        "Edit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UnitsCreator(
                                    branch: widget.branch,
                                    mode: widget.mode,
                                    id: widget.unit.id,
                                    Heading: widget.unit.heading,
                                    Description: widget.unit.description,
                                    questions: widget.unit.questions,
                                    PDFSize: widget.unit.PDFSize,
                                    PDFUrl: widget.unit.PDFLink,
                                  )));
                    },
                  ),
                  InkWell(
                    child: Chip(
                      elevation: 20,
                      backgroundColor: Colors.black,
                      avatar: CircleAvatar(
                          backgroundColor: Colors.black45,
                          child: Icon(
                            Icons.delete_rounded,
                          )),
                      label: Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onTap: () {
                      final deleteFlashNews = FirebaseFirestore.instance
                          .collection(widget.branch)
                          .doc(widget.mode)
                          .collection(widget.mode)
                          .doc(widget.ID)
                          .collection("Units")
                          .doc(widget.unit.id);
                      deleteFlashNews.delete();
                    },
                  ),
                ],
              ),
            if (isDownloaded) LinearProgressIndicator()
          ],
        ),
      ),
    );
  }
}

class SearchAddedSubjects {
  String name, date;
  String description, id, photoUrl;

  SearchAddedSubjects(
      {required this.name,
      required this.description,
      required this.date,
      required this.id,
      required this.photoUrl});

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'id': id,
        'date': date,
        'photoUrl': photoUrl
      };

  static SearchAddedSubjects fromJson(json) => SearchAddedSubjects(
      name: json['name'],
      description: json['description'],
      date: json["date"],
      id: json['id'],
      photoUrl: json['photoUrl']);
}
