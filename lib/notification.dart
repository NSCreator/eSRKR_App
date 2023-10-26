// ignore_for_file: must_be_immutable

import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:srkr_study_app/HomePage.dart';
import 'package:http/http.dart' as http;
import 'functions.dart';
import 'main.dart';

class notifications extends StatefulWidget {
  final String branch;
  final double size;


  const notifications(
      {Key? key,
      required this.branch,
      required this.size,})
      : super(key: key);

  @override
  State<notifications> createState() => _notificationsState();
}

class _notificationsState extends State<notifications>
    with SingleTickerProviderStateMixin {
  late String user = "";
  final emailController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(
      vsync: this,
      length: 2,
    );
  }
  Map<String, Color> colorMap = {};

  // Function to get or generate a color for a given combination
  Color getColorForCombination(String combination) {
    if (!colorMap.containsKey(combination)) {
      // Generate a random color if the combination is not in the map
      colorMap[combination] = Color(0xFF000000 + (combination.hashCode & 0xFFFFFF));
    }
    return colorMap[combination]!;
  }

  onChage(String name) {
    setState(() {
      emailController.text = name;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: SafeArea(
        child: Column(children: [
          backButton(
              size: widget.size,
              text: "Notifications",
              child: SizedBox(
                width: widget.size *45,
              )),
          Container(
            color: Colors.transparent,
            height: widget.size * 30,
            child: Center(
              child: TabBar(
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.size * 15),
                    color: Colors.white24),
                controller: _tabController,
                isScrollable: true,
                labelPadding: EdgeInsets.symmetric(horizontal: widget.size * 5),
                tabs: [
                  Tab(
                    child: Text(
                      "   All   ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: widget.size * 25,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "   Personal   ",
                      style: TextStyle(
                          color: Colors.white, fontSize: widget.size * 25),
                    ),
                  )
                ],
              ),
            ),
          ),

          Expanded(
            child: TabBarView(
              physics: BouncingScrollPhysics(),
              controller: _tabController,
              children: [
                StreamBuilder<List<NotificationsConvertor>>(
                    stream: readNotifications(
                        c0: widget.branch,
                        d0: "Notification",
                        c1: "AllNotification"),
                    builder: (context, snapshot) {
                      final Notifications = snapshot.data;
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
                                shrinkWrap: true,
                                reverse: true,
                                itemCount: Notifications!.length,
                                itemBuilder: (context, int index) {
                                  final Notification = Notifications[index];

                                  return Padding(
                                    padding: Notification.fromTo == fullUserId()
                                        ? EdgeInsets.only(
                                            left: widget.size * 30,
                                            right: widget.size * 5,
                                            top:widget.size * 5)
                                        : EdgeInsets.only(
                                            right:widget.size * 30,
                                            left: widget.size * 5,
                                            top: widget.size * 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (Notification.fromTo.split("~")[0] != fullUserId())
                                          Padding(
                                            padding: EdgeInsets.all(
                                                widget.size * 3.0),
                                            child: Container(
                                              height: widget.size * 35,
                                              width: widget.size * 35,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        widget.size * 17),
                                                color: getColorForCombination( picText(Notification.fromTo.split("~")[0])),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                picText(Notification.fromTo.split("~")[0]),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: widget.size * 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                            ),
                                          ),
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                widget.size * 15,
                                              ),
                                              color: Notification.fromTo.split("~")[0] != fullUserId()?Colors.white12:Colors.blue.withOpacity(0.3),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                    child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "   ~ ${Notification.fromTo.split("@")[0]}",
                                                          style: TextStyle(
                                                            fontSize:
                                                                widget.size *
                                                                    12.0,
                                                            color: getColorForCombination( picText(Notification.fromTo.split("~")[0])),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  widget.size *
                                                                      8,
                                                                  widget.size *
                                                                      1,
                                                                  widget.size *
                                                                      10,
                                                                  widget.size *
                                                                      1),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                '${Notification.id}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        widget.size *
                                                                            10.0,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500
                                                                    //   fontWeight: FontWeight.bold,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left:
                                                              widget.size * 10,
                                                          right:
                                                              widget.size * 5,
                                                          top: widget.size * 3,
                                                          bottom: widget.size * 8,
                                                      ),
                                                      child: StyledTextWidget(
                                                        fontSize:
                                                            widget.size * 13,
                                                        text: Notification.data,

                                                      ),
                                                    ),
                                                    if (Notification
                                                            .image.length >
                                                        3)
                                                      InkWell(
                                                        child: Padding(
                                                          padding: EdgeInsets.all(
                                                              widget.size * 3.0),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(widget.size *15),
                                                            child: Image.network(
                                                                Notification.image),
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            PageRouteBuilder(
                                                              transitionDuration:
                                                              const Duration(milliseconds: 300),
                                                              pageBuilder: (context, animation,
                                                                  secondaryAnimation) =>
                                                                  ImageZoom(

                                                                    size: widget.size, url:Notification
                                                                      .image , file: File(""),
                                                                  ),
                                                              transitionsBuilder: (context, animation,
                                                                  secondaryAnimation, child) {
                                                                final fadeTransition = FadeTransition(
                                                                  opacity: animation,
                                                                  child: child,
                                                                );

                                                                return Container(
                                                                  color: Colors.black
                                                                      .withOpacity(animation.value),
                                                                  child: AnimatedOpacity(
                                                                      duration:
                                                                      Duration(milliseconds: 300),
                                                                      opacity: animation.value
                                                                          .clamp(0.3, 1.0),
                                                                      child: fadeTransition),
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                      )
                                                  ],
                                                ))
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (isOwner()||isGmail()||Notification.fromTo.split("~")[0] == fullUserId())
                                          SizedBox(
                                            width: 20,
                                            child: PopupMenuButton(
                                              icon: Icon(
                                                Icons.more_vert,
                                                color: Colors.white,
                                                size: widget.size * 25,
                                              ),
                                              // Callback that sets the selected popup menu item.
                                              onSelected: (item) {
                                                if (item == "delete") {
                                                  FirebaseFirestore.instance
                                                      .collection(widget.branch)
                                                      .doc("Notification")
                                                      .collection(
                                                          "AllNotification")
                                                      .doc(Notification.id)
                                                      .delete();
                                                  showToastText(
                                                      "Your Message has been Deleted");
                                                }
                                              },
                                              itemBuilder:
                                                  (BuildContext context) =>
                                                      <PopupMenuEntry>[
                                                const PopupMenuItem(
                                                  value: "delete",
                                                  child: Text('Delete'),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                      height: widget.size * 1,
                                    ));
                          }
                      }
                    }),
                StreamBuilder<List<NotificationsConvertor>>(
                    stream: readNotifications(
                        c0: "user", d0: fullUserId(), c1: "Notification"),
                    builder: (context, snapshot) {
                      final Notifications = snapshot.data;
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
                                    'Error with Notifications or\n Check Internet Connection'));
                          } else {
                            return ListView.separated(
                                shrinkWrap: true,
                                reverse: true,
                                itemCount: Notifications!.length,
                                itemBuilder: (context, int index) {
                                  final Notification = Notifications[index];

                                  return Padding(
                                    padding: Notification.fromTo.split("~")[0] == fullUserId()
                                        ? EdgeInsets.only(
                                      bottom: index==0?widget.size * 15:0,
                                        left: widget.size * 35,
                                        right: widget.size *5,
                                        top:widget.size *5)
                                        : EdgeInsets.only(
                                        bottom: index==0?widget.size *15:0,

                                        right: widget.size *35,
                                        left: widget.size * 5,
                                        top:widget.size *5),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        if (Notification.fromTo.split("~")[0] != fullUserId())
                                          Padding(
                                            padding: EdgeInsets.all(
                                                widget.size * 3.0),
                                            child: Container(
                                              height: widget.size * 35,
                                              width: widget.size * 35,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    widget.size * 17),
                                                color: getColorForCombination( picText(Notification.fromTo.split("~")[0])),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                    picText(Notification.fromTo),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: widget.size * 13,
                                                        fontWeight:
                                                        FontWeight.w800),
                                                  )),
                                            ),
                                          ),
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                widget.size * 15,
                                              ),
                                              color: Notification.fromTo.split("~")[0] != fullUserId()?Colors.white12:Colors.blue.withOpacity(0.3),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                            Notification.fromTo.split("~")[0] != fullUserId()?"   ~ ${Notification.fromTo.split("~")[0].split("@")[0]}":"   to ${Notification.fromTo.split("~")[1].split("@")[0]}",
                                                              style: TextStyle(
                                                                fontSize:
                                                                widget.size *
                                                                    12.0,
                                                                color: getColorForCombination( picText(Notification.fromTo.split("~")[0])),
                                                                fontWeight:
                                                                FontWeight.w500,
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
                                                                  widget.size *
                                                                      8,
                                                                  widget.size *
                                                                      1,
                                                                  widget.size *
                                                                      10,
                                                                  widget.size *
                                                                      1),
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    '${Notification.id}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        widget.size *
                                                                            10.0,
                                                                        color: Colors
                                                                            .white,

                                                                      //   fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                            left:
                                                            widget.size * 10,
                                                            right:
                                                            widget.size * 5,
                                                            top: widget.size * 3,
                                                            bottom: widget.size * 8,
                                                          ),
                                                          child: StyledTextWidget(
                                                            fontSize:
                                                            widget.size * 13,
                                                            text: Notification.data,

                                                          ),
                                                        ),
                                                        if (Notification
                                                            .image.length >
                                                            3)
                                                          InkWell(
                                                            child: Padding(
                                                              padding: EdgeInsets.all(
                                                                  widget.size * 3.0),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(widget.size *15),
                                                                child: Image.network(
                                                                    Notification.image),
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                PageRouteBuilder(
                                                                  transitionDuration:
                                                                  const Duration(milliseconds: 300),
                                                                  pageBuilder: (context, animation,
                                                                      secondaryAnimation) =>
                                                                      ImageZoom(

                                                                        size: widget.size, url:Notification
                                                                          .image , file: File(""),
                                                                      ),
                                                                  transitionsBuilder: (context, animation,
                                                                      secondaryAnimation, child) {
                                                                    final fadeTransition = FadeTransition(
                                                                      opacity: animation,
                                                                      child: child,
                                                                    );

                                                                    return Container(
                                                                      color: Colors.black
                                                                          .withOpacity(animation.value),
                                                                      child: AnimatedOpacity(
                                                                          duration:
                                                                          Duration(milliseconds: 300),
                                                                          opacity: animation.value
                                                                              .clamp(0.3, 1.0),
                                                                          child: fadeTransition),
                                                                    );
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                          )
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                          SizedBox(
                                            width: 25,
                                            child: PopupMenuButton(
                                              icon: Icon(
                                                Icons.more_vert,
                                                color: Colors.white,
                                                size: widget.size * 25,
                                              ),
                                              // Callback that sets the selected popup menu item.
                                              onSelected: (item) {
                                                if (item == "delete") {
                                                  FirebaseFirestore
                                                      .instance
                                                      .collection("user")
                                                      .doc(fullUserId())
                                                      .collection("Notification")
                                                      .doc(Notification.id).delete();
                                                  showToastText(
                                                      "Your Message Has Been Deleted");
                                                }else if(item == "reply"){
                                                  if (Notification.fromTo.split("~")[0] != fullUserId())onChage(Notification.fromTo.split("~")[0]);
                                                  else{
                                                    onChage(Notification.fromTo.split("~")[1]);
                                                  }
                                                }
                                              },
                                              itemBuilder:
                                                  (BuildContext context) =>
                                              <PopupMenuEntry>[
                                                const PopupMenuItem(
                                                  value: "delete",
                                                  child: Text('Delete'),
                                                ), const PopupMenuItem(
                                                  value: "reply",
                                                  child: Text('Reply'),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                      height:widget.size * 1,
                                    ));
                          }
                      }
                    }),
              ],
            ),
          ),

          searchBar(

            size: widget.size,
            branch: widget.branch,
            tabController: _tabController,
            user: emailController,
          )
        ]),
      ));
}


class searchBar extends StatefulWidget {
  final TabController tabController;
  final TextEditingController user;
  final String branch;
  final double size;


  const searchBar(
      {Key? key,
      required this.tabController,
      required this.user,
      required this.branch,
      required this.size,
      })
      : super(key: key);

  @override
  State<searchBar> createState() => _searchBarState();
}

class _searchBarState extends State<searchBar> {
  late TextEditingController emailController;
  final TextEditingController bodyController = TextEditingController();
  late TabController _tabController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = widget.tabController;
    emailController = widget.user;
    _tabController.addListener(_handleTabChange);
    emailController.addListener(_setUser);
  }

  void _setUser() {
    setState(() {});
  }

  void _handleTabChange() {
    setState(() {
      currentIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    super.dispose();
  }

  bool isExp = false;
  late String image = "";
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: [
          if(currentIndex == 1)Row(
            children: [
              SizedBox(
                width: widget.size *250,
                child: Padding(
                  padding: EdgeInsets.only(left:widget.size * 5,),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      // border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(widget.size *50),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left:widget.size * 10),
                      child: TextField(
                        style: TextStyle(
                            color: Colors.white, fontSize: widget.size * 13),
                        cursorColor: Colors.white,
                        cursorHeight: widget.size * 10,
                        controller: emailController,
                        maxLines: 1,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: ' ID ',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 7,
                child: Padding(
                  padding: EdgeInsets.only(left: widget.size *5, right: widget.size *5, top: widget.size *5, bottom: widget.size *5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      // border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(widget.size *50),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: widget.size *25 ),
                      child: TextField(
                        style: TextStyle(
                            color: Colors.white, fontSize: widget.size * 15),
                        cursorColor: Colors.white,
                        cursorHeight: widget.size * 10,
                        controller: bodyController,
                        maxLines: null,
                        scrollPhysics: BouncingScrollPhysics(),
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: ' Message ',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                  flex: 2,
                  //fit: FlexFit.tight,
                  child: Padding(
                    padding: EdgeInsets.only(right: widget.size * 10),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(widget.size * 30),
                          color: Colors.white.withOpacity(0.1)
                          // border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: widget.size * 3,
                              vertical: widget.size * 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (isOwner()||isGmail())
                                InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(isExp ? image : ""),
                                          fit: BoxFit.fill),
                                    ),
                                    child: !isExp
                                        ? InkWell(
                                            child: Icon(
                                              Icons.upload,
                                              color: Colors.blue,
                                              size: widget.size *30,
                                            ),
                                            onTap: () async {
                                              final pickedFile = await ImagePicker()
                                                  .pickImage(
                                                      source: ImageSource.gallery);
                                              final Reference ref = storage.ref().child(
                                                  'notification/${fullUserId()}/${pickedFile!.path.split("/").last}');
                                              final TaskSnapshot task = await ref
                                                  .putFile(File(pickedFile.path));
                                              image = await task.ref.getDownloadURL();
                                              setState(() {
                                                image;
                                              });
                                              isExp = true;
                                            },
                                          )
                                        : Container(),
                                  ),
                                ),
                              Icon(
                                Icons.send,
                                color: Colors.blue,
                                size: widget.size *30,
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        if (currentIndex == 0) {
                          SendMessageInBackground(
                              widget.branch, bodyController.text.trim(), image);
                        } else {
                          pushNotificationsSpecificPerson(
                              "${fullUserId()}~${emailController.text.trim()}",
                              bodyController.text,
                              image);
                        }
                        bodyController.clear();
                      },
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}

Future<bool> pushNotificationsSpecificDevice({
  required String token,
  required String title,
  required String body,
}) async {
  String dataNotifications = '{ "to" : "$token",'
      ' "notification" : {'
      ' "title":"$title",'
      '"body":"$body"'
      ' }'
      ' }';

  await http.post(
    Uri.parse(Constants.BASE_URL),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key= ${Constants.KEY_SERVER}',
    },
    body: dataNotifications,
  );
  return true;
}

 messageToOwner(String message) async {
   FirebaseFirestore.instance
       .collection("user")
       .doc("sujithnimmala03@gmail.com")
       .collection("Notification")
       .doc(getID())
       .set({
     "id": getID(),
     "fromTo": "${fullUserId()}~sujithnimmala03@gmail.com",
     "data": message,
     "image": ""
   });
  FirebaseFirestore.instance
      .collection("tokens")
      .doc("sujithnimmala03@gmail.com")
      .get()
      .then((DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      var data = snapshot.data();
      if (data != null && data is Map<String, dynamic>) {
        // Access the dictionary values
        String value = data['token'];
        pushNotificationsSpecificDevice(
          title: "sujithnimmala03@gmail.com",
          body: message,
          token: value,
        );
      }
    } else {
      print("Document does not exist.");
    }
  }).catchError((error) {
    print("An error occurred while retrieving data: $error");
  });
}

Future<void> pushNotificationsSpecificPerson(
    String sendTo, String message, String url) async {
  FirebaseFirestore.instance
      .collection("tokens")
      .doc(sendTo.split("~").last.trim())
      .get()
      .then((DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      var data = snapshot.data();
      if (data != null && data is Map<String, dynamic>) {
        String value = data['token'];

        FirebaseFirestore.instance
            .collection("user")
            .doc(sendTo.split("~").last.trim())
            .collection("Notification")
            .doc(getID())
            .set({
          "id": getID(),
          "fromTo": sendTo,
          "data": message,
          "image": url
        });
        FirebaseFirestore.instance
            .collection("user")
            .doc(fullUserId())
            .collection("Notification")
            .doc(getID())
            .set({
          "id": getID(),
          "fromTo": sendTo,
          "data": message,
          "image": url
        });

        pushNotificationsSpecificDevice(
          title: fullUserId(),
          body: message,
          token: value,
        );
      }
    } else {
      print("Document does not exist.");
    }
  }).catchError((error) {
    print("An error occurred while retrieving data: $error");
  });
}

void SendMessage(String title, String message, String branch) async {
  int count = 0;
  final CollectionReference collectionRef = FirebaseFirestore.instance
      .collection('tokens'); // Replace with your collection name

  try {
    final QuerySnapshot querySnapshot = await collectionRef.get();

    if (querySnapshot.docs.isNotEmpty) {
      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (final document in documents) {
        final data = document.data() as Map<String, dynamic>;
        if (branch.isNotEmpty) {
          if (data["branch"] == branch) {
            await pushNotificationsSpecificDevice(
              title: title,
              body: "$message",
              token: data["token"],
            );
          }
        } else {
          await pushNotificationsSpecificDevice(
            title: title,
            body: "$message",
            token: data["token"],
          );
        }
        count++;
        NotificationService().showNotification(
            id: 1,
            title: "Notification :$title",
            body: "Send to $count members");
      }
    } else {
      print('No documents found');
    }
  } catch (e) {
    print('Error: $e');
  }
}

void SendMessageInBackground(String branch, String message, String url) async {
  int count = 0;
  final CollectionReference collectionRef = FirebaseFirestore.instance
      .collection('tokens'); // Replace with your collection name

  try {
    final QuerySnapshot querySnapshot = await collectionRef.get();

    if (querySnapshot.docs.isNotEmpty) {
      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      if (isOwner()||isGmail()) {
        for (final document in documents) {
          final data = document.data() as Map<String, dynamic>;

          if (data["branch"] == branch) {
            await pushNotificationsSpecificDevice(
              title: fullUserId(),
              body: "$message",
              token: data["token"],
            );
            count++;
          }
        }

        NotificationService().showNotification(
            id: 1,
            title: "Notification Update",
            body: "Send to $count members");
      }
    }

      FirebaseFirestore.instance
          .collection(branch)
          .doc("Notification")
          .collection("AllNotification")
          .doc(getID())
          .set({
        "id": getID(),
        "fromTo": "${fullUserId()}",
        "data": message,
        "image": url
      });
      FirebaseFirestore.instance
          .collection("tokens")
          .doc(
          "sujithnimmala03@gmail.com") // Replace "documentId" with the ID of the document you want to retrieve
          .get()
          .then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          var data = snapshot.data();
          if (data != null && data is Map<String, dynamic>) {
            String value = data['token'];

            pushNotificationsSpecificDevice(
              title: fullUserId(),
              body: message,
              token: value,
            );
          }
        } else {
          print("Document does not exist.");
        }
      }).catchError((error) {
        print("An error occurred while retrieving data: $error");
      });

  } catch (e) {
    print('Error: $e');
  }
}

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    final String notificationId = UniqueKey().toString();
    return notificationsPlugin.show(id > 0 ? id : notificationId.hashCode,
        title, body, await notificationDetails());
  }
}

Stream<List<NotificationsConvertor>> readNotifications(
        {required String c0, required String d0, required String c1}) =>
    FirebaseFirestore.instance
        .collection(c0)
        .doc(d0)
        .collection(c1)
        .orderBy('id', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationsConvertor.fromJson(doc.data()))
            .toList());


class NotificationsConvertor {
  String id;
  final String fromTo, image, data;

  NotificationsConvertor({
    this.id = "",
    required this.fromTo,
    required this.image,
    required this.data,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "fromTo": fromTo,
        "image": image,
        "data": data,
      };

  static NotificationsConvertor fromJson(Map<String, dynamic> json) =>
      NotificationsConvertor(
        id: json['id'],
        fromTo: json["fromTo"],
        image: json["image"],
        data: json["data"],
      );
}

Future<void> downloadAllImages(
    BuildContext context, String branch, String reg) async {
  List list = [];

  final directory = await getApplicationDocumentsDirectory();

  String folderPath = directory.path;

  final CollectionReference timetable =
  FirebaseFirestore.instance.collection(branch).doc("regulation").collection("regulationWithSem").doc(reg).collection("timeTables");

  try {
    final QuerySnapshot querySnapshot = await timetable.get();
    if (querySnapshot.docs.isNotEmpty) {
      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (final document in documents) {
        final data = document.data() as Map<String, dynamic>;
        if (data["image"].length > 3) {
          final Uri uri = Uri.parse(data["image"]);
          final String fileName = uri.pathSegments.last;
          var name = fileName.split("/").last;
          final file = await File("${folderPath}/timetable/$name");
          if (!file.existsSync()) {
            list.add(data["image"] + ";" + "timetable");
          }
        }
      }
    } else {
      print('No documents found');
    }
  } catch (e) {
    print('Error: $e');
  }
  
  final CollectionReference updates =
      FirebaseFirestore.instance.collection("update");

  try {
    final QuerySnapshot querySnapshot = await updates.get();
    if (querySnapshot.docs.isNotEmpty) {
      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (final document in documents) {
        final data = document.data() as Map<String, dynamic>;
        if (data["image"].length > 3) {
          final Uri uri = Uri.parse(data["image"]);
          final String fileName = uri.pathSegments.last;
          var name = fileName.split("/").last;
          final file = await File("${folderPath}/updates/$name");
          if (!file.existsSync()) {
            list.add(data["image"] + ";" + "updates");
          }
        }
      }
    } else {
      print('No documents found');
    }
  } catch (e) {
    print('Error: $e');
  }

  final CollectionReference News = FirebaseFirestore.instance
      .collection(branch)
      .doc("${branch}News")
      .collection("${branch}News");

  try {
    final QuerySnapshot querySnapshot = await News.get();
    if (querySnapshot.docs.isNotEmpty) {
      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (final document in documents) {
        final data = document.data() as Map<String, dynamic>;
        if (data["image"].length > 3) {
          final Uri uri = Uri.parse(data["image"]);
          final String fileName = uri.pathSegments.last;
          var name = fileName.split("/").last;
          final file = await File("${folderPath}/news/$name");
          if (!file.existsSync()) {
            list.add(data["image"] + ";" + "news");
          }
        }
      }
    } else {
      print('No documents found');
    }
  } catch (e) {
    print('Error: $e');
  }

  final CollectionReference books = FirebaseFirestore.instance
      .collection(branch)
      .doc("Books")
      .collection("CoreBooks");

  try {
    final QuerySnapshot querySnapshot = await books.get();
    if (querySnapshot.docs.isNotEmpty) {
      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (final document in documents) {
        final data = document.data() as Map<String, dynamic>;
        if (data["image"].length > 3) {
          final Uri uri = Uri.parse(data["image"]);
          final String fileName = uri.pathSegments.last;
          var name = fileName.split("/").last;
          final file = await File("${folderPath}/books/$name");
          if (!file.existsSync()) {
            list.add(data["image"] + ";" + "books");
          }
        }
      }
    } else {
      print('No documents found');
    }
  } catch (e) {
    print('Error: $e');
  }
  if (list.isNotEmpty) {
    await showDialog(
      context: context,
      builder: (context) => ImageDownloadScreen(
        images: list,
      ),
    );
    list=[];
  }
}

class ImageDownloadScreen extends StatefulWidget {
  List images;

  ImageDownloadScreen({Key? key, required this.images}) : super(key: key);

  @override
  _ImageDownloadScreenState createState() => _ImageDownloadScreenState();
}

class _ImageDownloadScreenState extends State<ImageDownloadScreen> {
  int totalImages = 0;
  int downloadedImages = 0;
  double overallProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _downloadImages();
  }

  _downloadImages() async {
    totalImages = widget.images.length;
    downloadedImages = 0;
    overallProgress = 0.0;

    for (String url in widget.images) {
      final Uri uri = Uri.parse(url.split(";").first);
      final String fileName = uri.pathSegments.last;
      var name = fileName.split("/").last;
      if (url.startsWith('https://drive.google.com')) {
        name = url.split(";").first.split('/d/')[1].split('/')[0];

        url = "https://drive.google.com/uc?export=download&id=$name";
      }
      final response = await http.get(Uri.parse(url.split(";").first));
      final documentDirectory = await getApplicationDocumentsDirectory();
      final newDirectory =
          Directory('${documentDirectory.path}/${url.split(";").last}');
      if (!await newDirectory.exists()) {
        await newDirectory.create(recursive: true);
      }
      final file = File('${newDirectory.path}/${name.split(";").first}');
      await file.writeAsBytes(response.bodyBytes);

      setState(() {
        downloadedImages++;
        overallProgress = downloadedImages / totalImages;
      });

      await Future.delayed(Duration(milliseconds: 100));
    }
    showNotification(downloadedImages);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Just A Movement',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              '...downloading image $downloadedImages of $totalImages',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            LinearProgressIndicator(
              value: overallProgress,
            ),
          ],
        ),
      ),
    );
  }
}

void showNotification(int count) {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  flutterLocalNotificationsPlugin.show(
    1,
    '$count images downloaded',
    null,
    platformChannelSpecifics,
  );
}
