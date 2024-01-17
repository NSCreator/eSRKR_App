import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../SubPages.dart';
import '../TextField.dart';
import '../functions.dart';
import '../notification.dart';
import 'settings.dart';
import 'HomePage.dart';

class newsUpadates extends StatefulWidget {
  String branch;

  newsUpadates({
    required this.branch,
  });

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
    return Scaffold(
      backgroundColor: Color.fromRGBO(
          228, 234, 245
          ,1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 20,
                          ),
                          Text(
                            " Back",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.notifications_none,
                              color: Colors.black,
                              size: 25,
                            ),
                            Text(
                              " Notification",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,fontFamily: "test"),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 300),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    notifications(
                              branch: widget.branch,
                            ),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              final fadeTransition = FadeTransition(
                                opacity: animation,
                                child: child,
                              );

                              return Container(
                                color:
                                    Colors.black.withOpacity(animation.value),
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
              StreamBuilder<List<FlashNewsConvertor>>(
                  stream: readSRKRFlashNews(),
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
                          return Favourites!.isNotEmpty
                              ? Column(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Flash News",
                                  style: secondHeadingTextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              CarouselSlider(
                                  items: List.generate(
                                      Favourites.length,
                                          (int index) {
                                        final BranchNew =
                                        Favourites[index];
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                child: Padding(
                                                  padding: EdgeInsets
                                                      .only(
                                                      left: 20),
                                                  child: Text(
                                                    BranchNew
                                                        .heading,
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500,
                                                        fontFamily:
                                                        "test",
                                                        fontSize:
                                                        16),
                                                    maxLines: 3,
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                  ),
                                                ),
                                                onTap: () {
                                                  if (BranchNew.Url
                                                      .isNotEmpty) {
                                                    ExternalLaunchUrl(
                                                        BranchNew
                                                            .Url);
                                                  } else {
                                                    showToastText(
                                                        "No Url Found");
                                                  }
                                                },
                                              ),
                                            ),
                                            if (isGmail())
                                              PopupMenuButton(
                                                icon: Icon(
                                                  Icons.more_vert,
                                                  color:
                                                  Colors.black,
                                                  size: 25,
                                                ),
                                                // Callback that sets the selected popup menu item.
                                                onSelected: (item) {
                                                  if (item ==
                                                      "edit") {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                flashNewsCreator(
                                                                  branch: widget.branch,
                                                                  heading: BranchNew.heading,
                                                                  link: BranchNew.Url,
                                                                  NewsId: BranchNew.id,
                                                                )));
                                                  } else if (item ==
                                                      "delete") {
                                                    messageToOwner(
                                                        "Flash News is Deleted\nBy : '${fullUserId()}' \n   Heading : ${BranchNew.heading}\n   Link : ${BranchNew.Url}");

                                                    FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                        "srkrPage")
                                                        .doc(
                                                        "flashNews")
                                                        .collection(
                                                        "flashNews")
                                                        .doc(
                                                        BranchNew
                                                            .id)
                                                        .delete();
                                                  }
                                                },
                                                itemBuilder: (BuildContext
                                                context) =>
                                                <PopupMenuEntry>[
                                                  const PopupMenuItem(
                                                    value: "edit",
                                                    child: Text(
                                                        'Edit'),
                                                  ),
                                                  const PopupMenuItem(
                                                    value: "delete",
                                                    child: Text(
                                                        'Delete'),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        );
                                      }),
                                  options: CarouselOptions(
                                    viewportFraction: 1,
                                    enlargeCenterPage: true,
                                    height: 60,
                                    autoPlayAnimationDuration:
                                    Duration(
                                        milliseconds: 1800),
                                    autoPlay:
                                    Favourites.length > 1
                                        ? true
                                        : false,
                                  )),
                            ],
                          )
                              : Container();
                        }
                    }
                  }),
              InkWell(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Exam Notifications  ",
                        style: TextStyle(color: Colors.black, fontSize: 25,fontWeight: FontWeight.w500),
                      ),
                      Expanded(child: Text("College WebSite", style: TextStyle(color: Colors.black45, fontSize: 16),))
                    ],
                  ),
                ),
                onTap: () {
                  ExternalLaunchUrl("http://www.srkrexams.in/Login.aspx");
                },
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => updatesPage(
                                branch: branch,
                              )));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "College Updates",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      ),
                      Icon(Icons.arrow_forward_ios_outlined,size: 20,)
                    ],
                  ),
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
                                  left: 10, top: 10, bottom: 20, right: 10),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: min(2, BranchNews.length),
                              itemBuilder: (context, int index) {
                                final BranchNew = BranchNews[index];

                                return InkWell(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (BranchNew.link.isEmpty &&
                                            BranchNew.photoUrl.isNotEmpty)
                                          Padding(
                                            padding: EdgeInsets.all(3.0),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
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
                                                    horizontal: 10.0,
                                                    vertical: 3),
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
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    if (BranchNew
                                                        .description.isNotEmpty)
                                                      Text(
                                                        " ${BranchNew.description}",
                                                        style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(0.8),
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (BranchNew.link.isNotEmpty &&
                                                BranchNew.photoUrl.isNotEmpty)
                                              SizedBox(
                                                height: 100,
                                                width: 140,
                                                child: Padding(
                                                  padding: EdgeInsets.all(3.0),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child:
                                                          ImageShowAndDownload(
                                                        image:
                                                            BranchNew.photoUrl,
                                                        isZoom: true,
                                                      )),
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(
                                            height: 2,
                                            child: Divider(
                                              color: Colors.black26,
                                            )),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 2),
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
                                                        fontSize: 12,
                                                        color: Colors.black87),
                                                  ),
                                                  Icon(
                                                    Icons.circle,
                                                    color: Colors.black,
                                                    size: 3,
                                                  ),
                                                  Text(
                                                    "  ${BranchNew.creator.split("@").first}",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black87),
                                                  ),
                                                ],
                                              ),
                                              if (isGmail() || isOwner())
                                                SizedBox(
                                                  height: 18,
                                                  child: PopupMenuButton(
                                                    padding: EdgeInsets.all(0),
                                                    icon: Icon(
                                                      Icons.more_horiz,
                                                      color: Colors.black,
                                                      size: 18,
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
                                                                          mode:
                                                                              true,
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
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Our Updates",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w500),
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
                                            vertical: 2, horizontal: 5),
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (BranchNew.photoUrl.isNotEmpty)
                                              Padding(
                                                padding: EdgeInsets.all(3.0),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: AspectRatio(
                                                        aspectRatio: 16 / 9,
                                                        child:
                                                            ImageShowAndDownload(
                                                                isZoom: true,
                                                                image: BranchNew
                                                                    .photoUrl))),
                                              ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      BranchNew.heading
                                                              .isNotEmpty
                                                          ? "${BranchNew.heading}"
                                                          : "${widget.branch} (SRKR)",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  Spacer(),
                                                  if (isGmail() || isOwner())
                                                    SizedBox(
                                                      height: 35,
                                                      child: PopupMenuButton(
                                                        icon: Icon(
                                                          Icons.more_vert,
                                                          color: Colors.black,
                                                          size: 16,
                                                        ),
                                                        // Callback that sets the selected popup menu item.
                                                        onSelected:
                                                            (item) async {
                                                          if (item == "edit") {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            updateCreator(
                                                                              NewsId: BranchNew.id,
                                                                              link: BranchNew.link,
                                                                              heading: BranchNew.heading,
                                                                              photoUrl: BranchNew.photoUrl,
                                                                              subMessage: BranchNew.description,
                                                                              branch: widget.branch,
                                                                            )));
                                                          } else if (item ==
                                                              "delete") {
                                                            if (BranchNew
                                                                .photoUrl
                                                                .isNotEmpty) {
                                                              final Uri uri = Uri
                                                                  .parse(BranchNew
                                                                      .photoUrl);
                                                              final String
                                                                  fileName =
                                                                  uri.pathSegments
                                                                      .last;
                                                              final Reference
                                                                  ref = storage
                                                                      .ref()
                                                                      .child(
                                                                          "/${fileName}");
                                                              try {
                                                                await ref
                                                                    .delete();
                                                                showToastText(
                                                                    'Image deleted successfully');
                                                              } catch (e) {
                                                                showToastText(
                                                                    'Error deleting image: $e');
                                                              }
                                                            }
                                                            messageToOwner(
                                                                "Branch News Updated.\nBy : '${fullUserId()}' \n    Heading : ${BranchNew.heading}\n    Description : ${BranchNew.description}\n    Image : ${BranchNew.photoUrl}\n **${widget.branch}");

                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    widget
                                                                        .branch)
                                                                .doc(
                                                                    "${widget.branch}News")
                                                                .collection(
                                                                    "${widget.branch}News")
                                                                .doc(BranchNew
                                                                    .id)
                                                                .delete();
                                                          }
                                                        },
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context) =>
                                                                <PopupMenuEntry>[
                                                          const PopupMenuItem(
                                                            value: "edit",
                                                            child: Text('Edit'),
                                                          ),
                                                          const PopupMenuItem(
                                                            value: "delete",
                                                            child:
                                                                Text('Delete'),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            if (BranchNew
                                                .description.isNotEmpty)
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                child: StyledTextWidget(
                                                  text: BranchNew.description,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 8,
                                                bottom: 8,
                                              ),
                                              child: Text(
                                                BranchNew.id
                                                            .split("-")
                                                            .first
                                                            .length <
                                                        12
                                                    ? "${calculateTimeDifference(BranchNew.id)}"
                                                    : "No Date",
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Icon(
                                          Icons.newspaper,
                                          color: Colors.black26,
                                          size: 70,
                                        ),
                                        Text(
                                          "No ${branch} Updates",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16),
                                        )
                                      ],
                                    ),
                                  ],
                                );
                        }
                    }
                  }),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
