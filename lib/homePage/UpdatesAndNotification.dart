import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../SubPages.dart';
import '../TextField.dart';
import '../functions.dart';
import '../main.dart';
import '../notification.dart';
import 'settings.dart';
import 'HomePage.dart';

class newsUpadates extends StatefulWidget {
  String branch;
  double size;

  newsUpadates({required this.branch, required this.size});

  @override
  State<newsUpadates> createState() => _newsUpadatesState();
}

class _newsUpadatesState extends State<newsUpadates> {
  final FirebaseStorage storage = FirebaseStorage.instance;

  bool isBranch = false;
  String branch = '';

  @override
  void initState() {
    setState(() {
      branch = widget.branch;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.size*14.0, vertical: widget.size*5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Notification",
                  style: TextStyle(color: Colors.white, fontSize: widget.size*25),
                ),
                InkWell(
                  child: Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: widget.size * 30,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            notifications(
                              size: widget.size,
                              branch: widget.branch,
                            ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          final fadeTransition = FadeTransition(
                            opacity: animation,
                            child: child,
                          );

                          return Container(
                            color: Colors.black.withOpacity(animation.value),
                            child: AnimatedOpacity(
                                duration: Duration(milliseconds: 300),
                                opacity: animation.value.clamp(0.3, 1.0),
                                child: fadeTransition),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               "Other Branches",
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//           ),
//           StreamBuilder<List<branchSharingConvertor>>(
//               stream: readbranchSharing(),
//               builder: (context, snapshot) {
//                 final BranchNews = snapshot.data;
//                 switch (snapshot.connectionState) {
//                   case ConnectionState.waiting:
//                     return const Center(
//                         child: CircularProgressIndicator(
//                           strokeWidth: 0.3,
//                           color: Colors.cyan,
//                         ));
//                   default:
//                     if (snapshot.hasError) {
//                       return const Center(
//                           child: Text(
//                               'Error with Time Table Data or\n Check Internet Connection'));
//                     } else {
//                       if (BranchNews!.length == 0) {
//                         return Center(
//                             child: Text(
//                               "No Time Tables",
//                               style:
//                               TextStyle(color: Colors.amber.withOpacity(0.5)),
//                             ));
//                       } else
//                         return SizedBox(
//                           height: widget.size * 58,
//                           child: ListView.builder(
//                             itemCount: BranchNews.length,
//                             scrollDirection: Axis.horizontal,
//                             itemBuilder: (context, int index) {
//                               var BranchNew = BranchNews[index];
//                               file = File("");
//                               if (BranchNew.photoUrl.isNotEmpty) {
//                                 final Uri uri = Uri.parse(BranchNew.photoUrl);
//                                 final String fileName = uri.pathSegments.last;
//                                 var name = fileName.split("/").last;
//                                 file = File("${folderPath}/timetable/$name");
//                               }
//                               return (widget.branch!=BranchNew.id)||(widget.branch!=branch)?Padding(
//                                 padding: EdgeInsets.only(
//                                     left: index==0?widget.size * 14:widget.size * 5),
//                                 child: InkWell(
//                                   child: Column(
//                                     children: [
//                                       Container(
//                                         padding: EdgeInsets.all(3),
//                                         margin:  EdgeInsets.only(
//                                             bottom: widget.size * 2.0),
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                             BorderRadius.circular(
//                                                 widget.size * 27),
//                                             gradient: LinearGradient(
//                                               begin: Alignment.topLeft,
//                                               end: Alignment.bottomRight,
//                                               colors: [
//                                                 Colors.white,
//                                                 Colors.blueGrey,
//                                                 Colors.deepPurpleAccent,
//
//                                               ],
//                                             ),
//                                             border: Border.all(
//                                                 width: 2,
//
//                                                 style: BorderStyle.solid)),
//                                         child: Container(
//                                           height: widget.size * 45,
//                                           width: widget.size * 60,
//                                           decoration: BoxDecoration(
//                                             color: Colors.black.withOpacity(0.6),
//                                             image: DecorationImage(
//                                                 image: FileImage(file),
//                                                 fit: BoxFit.cover),
//                                             borderRadius:
//                                             BorderRadius.circular(
//                                                 widget.size * 23),
//                                           ),
//                                           child: Center(
//                                             child: Text(
//                                               BranchNew.id.toUpperCase(),
//                                               style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: widget.size * 18,
//                                                   fontWeight: FontWeight.w600,
//                                                   fontFamily: "test"),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//
//                                     ],
//                                   ),
//                                   onTap: () {
// setState(() {
//   branch=BranchNew.id;
// });
//                                   },
//                                 ),
//                               ):Container();
//                             },
//                           ),
//                         );
//                     }
//                 }
//               }),
          Padding(
            padding:  EdgeInsets.only(top: widget.size*20.0, left:widget.size* 10, right:widget.size* 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "College Updates",
                  style: TextStyle(color: Colors.white, fontSize: widget.size*20),
                ),
                InkWell(
                  child: Text(
                    "more",
                    style: TextStyle(color: Colors.orangeAccent, fontSize:widget.size* 20),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => updatesPage(
                              branch: branch,
                              size: widget.size,
                            )));
                  },
                ),
              ],
            ),
          ),
          StreamBuilder<List<UpdateConvertor>>(
              stream: readUpdate(branch),
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
                              left: widget.size*10, top: widget.size*10, bottom: widget.size*20, right: widget.size*8),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: min(2, BranchNews.length),
                          itemBuilder: (context, int index) {
                            final BranchNew = BranchNews[index];

                            return InkWell(
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(widget.size*15),
                                    color: Colors.black),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (BranchNew.link.isEmpty &&
                                        BranchNew.photoUrl.isNotEmpty)
                                      Padding(
                                        padding:  EdgeInsets.all(widget.size*3.0),
                                        child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(widget.size*15),
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
                                            padding:  EdgeInsets.symmetric(
                                                horizontal: widget.size*10.0, vertical:widget.size* 3),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                if (BranchNew
                                                    .heading.isNotEmpty)
                                                  Text(
                                                    BranchNew.heading,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                      widget.size * 20,
                                                    ),
                                                  ),
                                                if (BranchNew
                                                    .description.isNotEmpty)
                                                  Text(
                                                    " ${BranchNew.description}",
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                      fontSize:
                                                      widget.size * 14,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (BranchNew.link.isNotEmpty &&
                                            BranchNew.photoUrl.isNotEmpty)
                                          SizedBox(
                                            height:widget.size* 100,
                                            width: widget.size*140,
                                            child: Padding(
                                              padding:
                                              EdgeInsets.all(widget.size*3.0),
                                              child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(widget.size*15),
                                                  child: ImageShowAndDownload(
                                                    image: BranchNew.photoUrl,
                                                    isZoom: true,
                                                  )),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(
                                        height: 2,
                                        child: Divider(
                                          color: Colors.white24,
                                        )),
                                    Padding(
                                      padding:  EdgeInsets.symmetric(
                                          horizontal: widget.size*10.0, vertical: widget.size*2),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                                    fontSize:widget.size* 12,
                                                    color: Colors.white70),
                                              ),
                                              Icon(
                                                Icons.circle,
                                                color: Colors.white,
                                                size: widget.size*3,
                                              ),
                                              Text(
                                                "  ${BranchNew.creator.split("@").first}",
                                                style: TextStyle(
                                                    fontSize:widget.size* 12,
                                                    color: Colors.white70),
                                              ),
                                            ],
                                          ),
                                          if (isGmail() || isOwner())
                                            SizedBox(
                                              height: widget.size*18,
                                              child: PopupMenuButton(
                                                padding: EdgeInsets.all(0),
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
                                                            builder: (context) =>
                                                                updateCreator(
                                                                  mode: true,
                                                                  NewsId:
                                                                  BranchNew
                                                                      .id,
                                                                  link:
                                                                  BranchNew
                                                                      .link,
                                                                  heading:
                                                                  BranchNew
                                                                      .heading,
                                                                  photoUrl:
                                                                  BranchNew
                                                                      .photoUrl,
                                                                  subMessage:
                                                                  BranchNew
                                                                      .description,
                                                                  branch: widget
                                                                      .branch,
                                                                  size: widget
                                                                      .size,
                                                                )));
                                                  } else if (item == "delete") {
                                                    FirebaseFirestore.instance
                                                        .collection("update")
                                                        .doc(BranchNew.id)
                                                        .delete();
                                                    messageToOwner(
                                                        "Update is Deleted\nBy '${fullUserId()}\n    Heading : ${BranchNew.heading}\n    Description : ${BranchNew.description}    \nImage : ${BranchNew.photoUrl}    \nLink : ${BranchNew.link}\n **${widget.branch}");
                                                  }
                                                },
                                                itemBuilder:
                                                    (BuildContext context) =>
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
          Padding(
            padding:  EdgeInsets.all(widget.size*8.0),
            child: Text(
              "Our Updates",
              style: TextStyle(color: Colors.white, fontSize: widget.size*20),
            ),
          ),
          StreamBuilder<List<UpdateConvertor>>(
              stream: readBranchNew(branch),
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
                      return BranchNews!.isNotEmpty
                          ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: BranchNews.length,
                        itemBuilder: (context, int index) {
                          final BranchNew = BranchNews[index];

                          return InkWell(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: widget.size*2, horizontal: widget.size*5),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(widget.size*15)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  if (BranchNew.photoUrl.isNotEmpty)
                                    Padding(
                                      padding:
                                      EdgeInsets.all(widget.size * 3.0),
                                      child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(
                                              widget.size * 15),
                                          child: AspectRatio(
                                              aspectRatio: 16 / 9,
                                              child: ImageShowAndDownload(
                                                  isZoom: true,
                                                  image:
                                                  BranchNew.photoUrl))),
                                    ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: widget.size * 8),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Text(
                                            BranchNew.heading.isNotEmpty
                                                ? "${BranchNew.heading}"
                                                : "${widget.branch} (SRKR)",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: widget.size * 20,
                                                fontWeight:
                                                FontWeight.w500)),
                                        Spacer(),
                                        if (isGmail() || isOwner())
                                          SizedBox(
                                            height: widget.size*35,
                                            child: PopupMenuButton(
                                              icon: Icon(
                                                Icons.more_vert,
                                                color: Colors.white,
                                                size: widget.size * 16,
                                              ),
                                              // Callback that sets the selected popup menu item.
                                              onSelected: (item) async {
                                                if (item == "edit") {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              updateCreator(
                                                                NewsId:
                                                                BranchNew
                                                                    .id,
                                                                link:
                                                                BranchNew
                                                                    .link,
                                                                heading:
                                                                BranchNew
                                                                    .heading,
                                                                photoUrl:
                                                                BranchNew
                                                                    .photoUrl,
                                                                subMessage:
                                                                BranchNew
                                                                    .description,
                                                                branch: widget
                                                                    .branch,
                                                                size: widget
                                                                    .size,
                                                              )));

                                                } else if (item ==
                                                    "delete") {
                                                  if (BranchNew.photoUrl
                                                      .isNotEmpty) {
                                                    final Uri uri =
                                                    Uri.parse(BranchNew
                                                        .photoUrl);
                                                    final String fileName =
                                                        uri.pathSegments
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
                                                  }
                                                  messageToOwner(
                                                      "Branch News Updated.\nBy : '${fullUserId()}' \n    Heading : ${BranchNew.heading}\n    Description : ${BranchNew.description}\n    Image : ${BranchNew.photoUrl}\n **${widget.branch}");

                                                  FirebaseFirestore.instance
                                                      .collection(
                                                      widget.branch)
                                                      .doc(
                                                      "${widget.branch}News")
                                                      .collection(
                                                      "${widget.branch}News")
                                                      .doc(BranchNew.id)
                                                      .delete();
                                                }
                                              },
                                              itemBuilder:
                                                  (BuildContext context) =>
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
                                  ),
                                  if (BranchNew.description.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: widget.size * 10,
                                      ),
                                      child: StyledTextWidget(
                                        text: BranchNew.description,
                                        fontSize: widget.size * 14,
                                      ),
                                    ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: widget.size * 8,
                                      bottom: widget.size * 8,
                                    ),
                                    child: Text(
                                      BranchNew.id.split("-").first.length <
                                          12
                                          ? "${calculateTimeDifference(BranchNew.id)}"
                                          : "No Date",
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: widget.size * 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: (){
                              ExternalLaunchUrl(BranchNew.link);
                            },
                          );
                        },
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: widget.size*20,
                              ),
                              Icon(
                                Icons.newspaper,
                                color: Colors.white30,
                                size: widget.size*70,
                              ),
                              Text(
                                "No ${branch} Updates",
                                style: TextStyle(
                                    color: Colors.white54, fontSize:widget.size* 16),
                              )
                            ],
                          ),
                        ],
                      );
                    }
                }
              }),
          SizedBox(
            height: widget.size*50,
          )
        ],
      ),
    );
  }
}
