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
import 'package:srkr_study_app/TextField.dart';
import 'package:srkr_study_app/settings.dart';
import 'package:http/http.dart' as http;
import 'functins.dart';
import 'main.dart';

class notifications extends StatefulWidget {
  final String branch;
  final double size;
  final double height;
  final double width;

  const notifications(
      {Key? key,
      required this.branch,
      required this.width,
      required this.size,
      required this.height})
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
  Widget build(BuildContext context) => backGroundImage(
          child: Column(children: [
        backButton(
          size: widget.size,
          text: "Notifications",
        ),
        Container(
          color: Colors.transparent,
          height:widget.size * 40,
          child: Center(
            child: TabBar(
              indicator: BoxDecoration(
                  border: Border.all(color: Colors.white12),
                  borderRadius: BorderRadius.circular(widget.size * 15),
                  color: Color.fromRGBO(4, 11, 23, 1)),
              controller: _tabController,
              isScrollable: true,
              labelPadding: EdgeInsets.symmetric(horizontal: widget.width * 35),
              tabs: [
                Tab(
                  child: Text(
                    "All",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.size * 25,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "Personal",
                    style: TextStyle(
                        color: Colors.white, fontSize: widget.size * 25),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: widget.height * 10,
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
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              reverse: true,
                              itemCount: Notifications!.length,
                              itemBuilder: (context, int index) {
                                final Notification = Notifications[index];

                                return InkWell(
                                  child: Padding(
                                    padding: Notification.Name == fullUserId()
                                        ? EdgeInsets.only(
                                            left: widget.width * 45,
                                            right: widget.width * 5,
                                            top: widget.height * 5)
                                        : EdgeInsets.only(
                                            right: widget.width * 45,
                                            left: widget.width * 5,
                                            top: widget.height * 5),
                                    child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: Notification.Name ==
                                              fullUserId()
                                          ? BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    widget.size * 25),
                                                bottomLeft: Radius.circular(
                                                    widget.size * 25),
                                                topRight: Radius.circular(
                                                    widget.size * 25),
                                                bottomRight: Radius.circular(
                                                    widget.size * 5),
                                              ),
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              border: Border.all(
                                                  color: Colors
                                                      .blueAccent.shade100),
                                            )
                                          : BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    widget.size * 25),
                                                bottomLeft: Radius.circular(
                                                    widget.size * 5),
                                                topRight: Radius.circular(
                                                    widget.size * 25),
                                                bottomRight: Radius.circular(
                                                    widget.size * 25),
                                              ),
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.5)),
                                            ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: widget.width * 2,
                                          ),
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
                                                    "       @${Notification.Name}",
                                                    style: TextStyle(
                                                      fontSize:
                                                          widget.size * 12.0,
                                                      color: Colors.white54,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            widget.size * 8,
                                                            widget.size * 1,
                                                            widget.size * 25,
                                                            widget.size * 1),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          '${Notification.id}',
                                                          style: TextStyle(
                                                            fontSize:
                                                                widget.size *
                                                                    9.0,
                                                            color:
                                                                Colors.white70,
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
                                                    left: widget.size * 8,
                                                    bottom: widget.size * 6,
                                                    right: widget.size * 3,
                                                    top: widget.size * 3),
                                                child: StyledTextWidget(fontSize: widget.size*14, text: Notification.description,),
                                              ),
                                              if (Notification.Url.length > 3)
                                                Padding(
                                                  padding: EdgeInsets.all(
                                                      widget.size * 3.0),
                                                  child: Image.network(
                                                      Notification.Url),
                                                )
                                            ],
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  onLongPress: () {
                                    if (isUser()) {
                                      final deleteFlashNews = FirebaseFirestore
                                          .instance
                                          .collection(widget.branch)
                                          .doc("Notification")
                                          .collection("AllNotification")
                                          .doc(Notification.id);
                                      deleteFlashNews.delete();
                                      showToastText(
                                          "Your Message has been Deleted");
                                    } else {
                                      showToastText(
                                          "You can't delete");
                                    }
                                  },
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                    height: widget.height * 1,
                                  ));
                        }
                    }
                  }),
              StreamBuilder<List<NotificationsConvertor>>(
                  stream: readNotifications(
                      c0: "user", d0:fullUserId(), c1: "Notification"),
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
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              reverse: true,
                              itemCount: Notifications!.length,
                              itemBuilder: (context, int index) {
                                final Notification = Notifications[index];

                                return InkWell(
                                  child: Padding(
                                    padding: Notification.Name == fullUserId()
                                        ? EdgeInsets.only(
                                            left: widget.size * 45,
                                            right: widget.size * 5)
                                        : EdgeInsets.only(
                                            right: widget.size * 45,
                                            left: widget.size * 5),
                                    child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: Notification.Name ==
                                              fullUserId()
                                          ? BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    widget.size * 25),
                                                bottomLeft: Radius.circular(
                                                    widget.size * 25),
                                                topRight: Radius.circular(
                                                    widget.size * 25),
                                                bottomRight: Radius.circular(
                                                    widget.size * 5),
                                              ),
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              border: Border.all(
                                                  color: Colors
                                                      .blueAccent.shade100),
                                            )
                                          : BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    widget.size * 25),
                                                bottomLeft: Radius.circular(
                                                    widget.size * 5),
                                                topRight: Radius.circular(
                                                    widget.size * 25),
                                                bottomRight: Radius.circular(
                                                    widget.size * 25),
                                              ),
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.5)),
                                            ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: widget.width * 2,
                                          ),
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
                                                    "       @${Notification.Name}",
                                                    style: TextStyle(
                                                      fontSize:
                                                          widget.size * 12.0,
                                                      color: Colors.white54,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            widget.size * 8,
                                                            widget.size * 1,
                                                            widget.size * 25,
                                                            widget.size * 1),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          '${Notification.id}',
                                                          style: TextStyle(
                                                            fontSize:
                                                                widget.size *
                                                                    9.0,
                                                            color:
                                                                Colors.white70,
                                                            //   fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (Notification.description
                                                      .split("@")
                                                      .first ==
                                                  "Forgot Password ")
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: widget.size * 8,
                                                      bottom: widget.size * 6,
                                                      right: widget.size * 3,
                                                      top: widget.size * 3),
                                                  child: Text(
                                                    Notification.description
                                                        .split("@")
                                                        .first,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20
                                                    ),
                                                  ),
                                                )
                                              else
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: widget.size * 8,
                                                      bottom: widget.size * 6,
                                                      right: widget.size * 3,
                                                      top: widget.size * 3),
                                                  child: StyledTextWidget(fontSize: widget.size*14, text: Notification.description,),
                                                ),
                                              if (Notification.Url.length > 10)
                                                Padding(
                                                  padding: EdgeInsets.all(
                                                      widget.size * 3.0),
                                                  child: Image.network(
                                                      Notification.Url),
                                                )
                                            ],
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  onLongPress: () {
                                    final deleteFlashNews = FirebaseFirestore
                                        .instance
                                        .collection("user")
                                        .doc(fullUserId())
                                        .collection("Notification")
                                        .doc(Notification.id);
                                    deleteFlashNews.delete();
                                    showToastText(
                                        "Your Message Has Been Deleted");
                                  },
                                  onDoubleTap: () {
                                    onChage(Notification.Name);
                                  },
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                    height: widget.height * 1,
                                  ));
                        }
                    }
                  }),
            ],
          ),
        ),
        searchBar(
          width: widget.width,
          height: widget.height,
          size: widget.size,
          branch: widget.branch,
          tabController: _tabController,
          user: emailController,
        )
      ]));
}

class searchBar extends StatefulWidget {
  final TabController tabController;
  final TextEditingController user;
  final String branch;
  final double size;
  final double height;
  final double width;

  const searchBar(
      {Key? key,
      required this.tabController,
      required this.user,
      required this.branch,
      required this.width,
      required this.size,
      required this.height})
      : super(key: key);

  @override
  State<searchBar> createState() => _searchBarState();
}

class _searchBarState extends State<searchBar> {
  late TextEditingController emailController;
  final TextEditingController bodyController = TextEditingController();
  late TabController _tabController;
  int currentIndex =0;

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
  late String Url = "";
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 7,
                child: currentIndex == 1
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: widget.size * 10,
                            vertical: widget.size * 5),
                        child: Container(
                          height: widget.size * 35,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.5)),
                            borderRadius:
                                BorderRadius.circular(widget.size * 12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: widget.size * 10),
                            child: TextField(
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: widget.size * 18),
                              cursorColor: Colors.white,
                              cursorHeight: widget.size * 10,
                              controller: emailController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter Email',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ),
              Flexible(
                  flex: 4,
                  //fit: FlexFit.tight,
                  child: isUser()
                      ? Padding(
                          padding: EdgeInsets.only(right: widget.size * 10),
                          child: InkWell(
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(widget.size * 15),
                                color: Colors.white.withOpacity(0.1),
                                image: DecorationImage(
                                    image: NetworkImage(isExp
                                        ? Url
                                        : "https://firebasestorage.googleapis.com/v0/b/e-srkr.appspot.com/o/old-black-background-grunge-texture-dark-wallpaper-blackboard-chalkboard-room-wall_1258-28312.avif?alt=media&token=7435f44c-7a51-4000-9b90-bf33e008f75d"),
                                    fit: BoxFit.fill),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.1)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AspectRatio(
                                    aspectRatio: isExp ? 16 / 9 : 4 / 1,
                                    child: !isExp
                                        ? InkWell(
                                            child: Center(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Upload Photo",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            widget.size * 16),
                                                  ),
                                                  SizedBox(
                                                    width: widget.size * 3,
                                                  ),
                                                  Icon(
                                                    Icons.upload,
                                                    color: Colors.blue,
                                                  )
                                                ],
                                              ),
                                            ),
                                            onTap: () async {
                                              final pickedFile =
                                                  await ImagePicker().pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              final Reference ref = storage
                                                  .ref()
                                                  .child(
                                                      'notification/${fullUserId()}/${pickedFile!.path.split("/").last}');
                                              final TaskSnapshot task =
                                                  await ref.putFile(
                                                      File(pickedFile.path));
                                              Url = await task.ref
                                                  .getDownloadURL();
                                              setState(() {
                                                Url;
                                              });
                                              isExp = true;
                                            },
                                          )
                                        : Container(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container())
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 7,
                child: TextFieldContainer(
                  child: TextField(
                    style: TextStyle(color: Colors.white, fontSize: widget.size * 20),
                    cursorColor: Colors.white,
                    cursorHeight: widget.size * 20,
                    controller: bodyController,
                    maxLines: null,
                    scrollPhysics: BouncingScrollPhysics(),
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Message ',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.6),
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
                          borderRadius: BorderRadius.circular(widget.size * 15),
                          color: Colors.white.withOpacity(0.1),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: widget.size * 3,
                              vertical: widget.size * 10),
                          child: Row(
                            children: [
                              Text(
                                "Send",
                                style: TextStyle(
                                    color: Colors.white, fontSize: widget.size * 17),
                              ),
                              SizedBox(
                                width: widget.size * 3,
                              ),
                              Icon(
                                Icons.send,
                                color: Colors.blue,
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        if (currentIndex == 0) {
                          SendMessageInBackground(
                              widget.branch, bodyController.text.trim(), Url);
                        } else {
                          pushNotificationsSpecificPerson(
                              emailController.text.trim(),
                              bodyController.text,
                              Url);
                        }
                        emailController.clear();
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

Future<void> pushNotificationsToOwner(
    String message) async {
  FirebaseFirestore.instance
      .collection("tokens")
      .doc(
      "sujithnimmala03@gmail.com")
      .get()
      .then((DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      var data = snapshot.data();
      if (data != null && data is Map<String, dynamic>) {
        // Access the dictionary values
        String value = data['token'];

        FirebaseFirestore.instance
            .collection("user")
            .doc("sujithnimmala03@gmail.com")
            .collection("Notification")
            .doc(getID())
            .set({
          "id": getID(),
          "Name": "sujithnimmala03@gmail.com",
          "Description": message,
          "Link": ""
        });

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
      .doc(
          sendTo)
      .get()
      .then((DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      var data = snapshot.data();
      if (data != null && data is Map<String, dynamic>) {
        // Access the dictionary values
        String value = data['token'];

        FirebaseFirestore.instance
            .collection("user")
            .doc(sendTo)
            .collection("Notification")
            .doc(getID())
            .set({
          "id": getID(),
          "Name": fullUserId(),

          "Description": message,
          "Link": url
        });
        FirebaseFirestore.instance
            .collection("user")
            .doc(fullUserId())
            .collection("Notification")
            .doc(getID())
            .set({
          "id": getID(),
          "Name": fullUserId(),
          "Description": message,
          "Link": url
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
      if (isUser()) {
        if (branch.isNotEmpty) {
          FirebaseFirestore.instance
              .collection(branch)
              .doc("Notification")
              .collection("AllNotification")
              .doc(getID())
              .set({
            "id": getID(),
            "Name": "${fullUserId()}",
            "Description": message,
            "Link": url
          });
        } else {
          List B = ["ECE", "EEE","MECH","CIVIL","CSE","IT"];
          for (final b in B) {
            FirebaseFirestore.instance
                .collection(b)
                .doc("Notification")
                .collection("AllNotification")
                .doc(getID())
                .set({
              "id": getID(),
              "Name": "${fullUserId()} (owner)",

              "Description": message,
              "Link": url
            });
          }
        }
        for (final document in documents) {
          final data = document.data() as Map<String, dynamic>;
          if (branch.isNotEmpty) {
            if (data["branch"] == branch) {
              await pushNotificationsSpecificDevice(
                title: fullUserId(),
                body: "$message",
                token: data["token"],
              );
              count++;
            }
          } else {
            await pushNotificationsSpecificDevice(
              title: fullUserId(),
              body: "$message",
              token: data["token"],
            );
            count++;
          }

          NotificationService().showNotification(
              id: 1,
              title: "Notification Update",
              body: "Send to $count members");
        }
      } else {
        FirebaseFirestore.instance
            .collection(branch)
            .doc("Notification")
            .collection("AllNotification")
            .doc(getID())
            .set({
          "id": getID(),
          "Name": "${fullUserId()}",

          "Description": message,
          "Link": url
        });
        FirebaseFirestore.instance
            .collection("tokens")
            .doc("sujithnimmala03@gmail.com") // Replace "documentId" with the ID of the document you want to retrieve
            .get()
            .then((DocumentSnapshot snapshot) {
          if (snapshot.exists) {
            var data = snapshot.data();
            if (data != null && data is Map<String, dynamic>) {
              String value = data['token'];

              pushNotificationsSpecificDevice(
                title: "Alert Notification (All)",
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
    } else {
      print('No documents found');
    }
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
  final String Name, Url, description;

  NotificationsConvertor(
      {this.id = "",
      required this.Name,
      required this.Url,
      required this.description,
     });

  Map<String, dynamic> toJson() => {
        "id": id,
        "Name": Name,
        "Link": Url,
        "Description": description,
      };

  static NotificationsConvertor fromJson(Map<String, dynamic> json) =>
      NotificationsConvertor(
          id: json['id'],
          Name: json["Name"],
          Url: json["Link"],
          description: json["Description"],);
}

Future<void> downloadAllImages(
    BuildContext context, String branch, String reg) async {
  List list = [];

  final directory = await getApplicationDocumentsDirectory();

  String folderPath = directory.path;

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
  final CollectionReference subjects = FirebaseFirestore.instance
      .collection(branch)
      .doc("Subjects")
      .collection("Subjects");

  try {
    final QuerySnapshot querySnapshot = await subjects.get();
    if (querySnapshot.docs.isNotEmpty) {
      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (final document in documents) {
        final data = document.data() as Map<String, dynamic>;
        if (data["image"].length > 3) {
          final Uri uri = Uri.parse(data["image"]);
          final String fileName = uri.pathSegments.last;
          var name = fileName.split("/").last;
          final file = await File("${folderPath}/subjects/$name");
          if (!file.existsSync()) {
            list.add(data["image"] + ";" + "subjects");
          }
        }
      }
    } else {
      print('No documents found');
    }
  } catch (e) {
    print('Error: $e');
  }

  final CollectionReference labSubjects = FirebaseFirestore.instance
      .collection(branch)
      .doc("LabSubjects")
      .collection("LabSubjects");

  try {
    final QuerySnapshot querySnapshot = await labSubjects.get();
    if (querySnapshot.docs.isNotEmpty) {
      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (final document in documents) {
        final data = document.data() as Map<String, dynamic>;
        if (data["image"].length > 3) {
          final Uri uri = Uri.parse(data["image"]);
          final String fileName = uri.pathSegments.last;
          var name = fileName.split("/").last;
          final file = await File("${folderPath}/labsubjects/$name");
          if (!file.existsSync()) {
            list.add(data["image"] + ";" + "labsubjects");
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
