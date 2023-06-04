import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:srkr_study_app/settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'TextField.dart';
import 'auth_page.dart';
import 'functins.dart';

_ExternalLaunchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $urlIn';
  }
}

class notifications extends StatefulWidget {
  final String branch;
  const notifications({Key? key, required this.branch}) : super(key: key);

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
    _tabController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Widget NotificationText(String text) {
    final regex = RegExp(r'(http[s]?:\/\/[^\s]+)');
    final matches = regex.allMatches(text);
    final List t = text.split(" ");
    return Wrap(
      children: [
        for (String number in t)
          if (matches.map((match) => match.group(0)!).toList().contains(number))
            InkWell(
              child: Text(
                "$number ",
                style: TextStyle(color: Colors.blueAccent),
              ),
              onTap: () {
                _ExternalLaunchUrl(number);
              },
            )
          else
            Text(
              "$number ",
              style: TextStyle(color: Colors.white),
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(2, 22, 38, 1),
        body: SafeArea(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Notifications",
                    style: TextStyle(color: Colors.white70, fontSize: 30),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Custom +",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              ],
            ),
            Container(
              height: 35,
              child: Center(
                child: TabBar(
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.orange),
                  controller: _tabController,
                  isScrollable: true,
                  labelPadding: EdgeInsets.symmetric(horizontal: 30),
                  tabs: [
                    Tab(
                      child: Text(
                        "All",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "For You",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: TabBarView(
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
                                        padding:
                                            Notification.Name == fullUserId()
                                                ? EdgeInsets.only(
                                                    left: 45, right: 5, top: 5)
                                                : EdgeInsets.only(
                                                    right: 45, left: 5, top: 5),
                                        child: Container(
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          decoration: Notification.Name ==
                                                  fullUserId()
                                              ? BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(25),
                                                    bottomLeft:
                                                        Radius.circular(25),
                                                    topRight:
                                                        Radius.circular(25),
                                                    bottomRight:
                                                        Radius.circular(5),
                                                  ),
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                  border: Border.all(
                                                      color: Colors
                                                          .blueAccent.shade100),
                                                )
                                              : BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(25),
                                                    bottomLeft:
                                                        Radius.circular(5),
                                                    topRight:
                                                        Radius.circular(25),
                                                    bottomRight:
                                                        Radius.circular(25),
                                                  ),
                                                  color: Colors.black
                                                      .withOpacity(0.5),
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
                                              const SizedBox(
                                                width: 2,
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
                                                        style: const TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors.white54,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                8, 1, 25, 1),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              '${Notification.Time}',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 9.0,
                                                                color: Colors
                                                                    .white70,
                                                                //   fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8,
                                                            bottom: 6,
                                                            right: 3,
                                                            top: 3),
                                                    child: NotificationText(
                                                        Notification
                                                            .description),
                                                  ),
                                                  if (Notification.Url.length >
                                                      3)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
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
                                        if (Notification.Name == userId() ||
                                            userDomain() == "gmail.com") {
                                          final deleteFlashNews =
                                              FirebaseFirestore.instance
                                                  .collection(widget.branch)
                                                  .doc("Notification")
                                                  .collection("AllNotification")
                                                  .doc(Notification.id);
                                          deleteFlashNews.delete();
                                          showToastText(
                                              "Your Message has been Deleted");
                                        } else {
                                          showToastText(
                                              "You are not message user to delete");
                                        }
                                      },
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        height: 1,
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
                                        padding:
                                            Notification.Name == fullUserId()
                                                ? EdgeInsets.only(
                                                    left: 45, right: 5)
                                                : EdgeInsets.only(
                                                    right: 45, left: 5),
                                        child: Container(
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          decoration: Notification.Name ==
                                                  fullUserId()
                                              ? BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(25),
                                                    bottomLeft:
                                                        Radius.circular(25),
                                                    topRight:
                                                        Radius.circular(25),
                                                    bottomRight:
                                                        Radius.circular(5),
                                                  ),
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                  border: Border.all(
                                                      color: Colors
                                                          .blueAccent.shade100),
                                                )
                                              : BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(25),
                                                    bottomLeft:
                                                        Radius.circular(5),
                                                    topRight:
                                                        Radius.circular(25),
                                                    bottomRight:
                                                        Radius.circular(25),
                                                  ),
                                                  color: Colors.black
                                                      .withOpacity(0.5),
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
                                              const SizedBox(
                                                width: 2,
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
                                                        style: const TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors.white54,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                8, 1, 25, 1),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              '${Notification.Time}',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 9.0,
                                                                color: Colors
                                                                    .white70,
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8,
                                                              bottom: 6,
                                                              right: 3,
                                                              top: 3),
                                                      child: Text(
                                                        Notification.description
                                                            .split("@")
                                                            .first,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    )
                                                  else
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8,
                                                              bottom: 6,
                                                              right: 3,
                                                              top: 3),
                                                      child: NotificationText(
                                                          Notification
                                                              .description),
                                                    ),
                                                  if (Notification.Url.length >
                                                      3)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
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
                                        onChage(Notification.Name);
                                      },
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        height: 1,
                                      ));
                            }
                        }
                      }),
                ],
              ),
            ),
            searchBar(
              branch: widget.branch,
              tabController: _tabController,
              user: emailController,
            )
          ]),
        ));
  }

  userId() {
    var user = FirebaseAuth.instance.currentUser!.email!.split("@");
    return user[0];
  }

  userDomain() {
    var user = FirebaseAuth.instance.currentUser!.email!.split("@");
    return user[1];
  }
}

class searchBar extends StatefulWidget {
  final TabController tabController;
  final TextEditingController user;
  final String branch;

  const searchBar(
      {Key? key,
      required this.tabController,
      required this.user,
      required this.branch})
      : super(key: key);

  @override
  State<searchBar> createState() => _searchBarState();
}

class _searchBarState extends State<searchBar> {
  late TextEditingController emailController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  late TabController _tabController;

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

    print('Current Tab Index: $currentIndex');
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    emailController.removeListener(_setUser);
    _tabController.dispose();
    emailController.dispose();
    bodyController.dispose();
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextField(
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                              cursorColor: Colors.white,
                              cursorHeight: 10,
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
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.1),
                          image: DecorationImage(
                              image: NetworkImage(isExp ? Url : ""),
                              fit: BoxFit.fill),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.1)),
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
                                                  fontSize: 16),
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Icon(
                                              Icons.upload,
                                              color: Colors.blue,
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () async {
                                        final pickedFile = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.gallery);
                                        final Reference ref = storage.ref().child(
                                            'notification/${fullUserId()}/${pickedFile!.path.split("/").last}');
                                        final TaskSnapshot task = await ref
                                            .putFile(File(pickedFile.path));
                                        Url = await task.ref.getDownloadURL();
                                        setState(() {
                                          Url;
                                        });
                                        isExp = true;
                                      },
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 8,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(color: Colors.white.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextField(
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        cursorColor: Colors.white,
                        cursorHeight: 20,
                        controller: bodyController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Send Message ( All )',
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
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.1),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 3, right: 3, top: 10, bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                "Send",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                              SizedBox(
                                width: 3,
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

Future<void> pushNotificationsSpecificPerson(
    String sendTo, String message, String url) async {
  FirebaseFirestore.instance
      .collection("tokens")
      .doc(
          sendTo) // Replace "documentId" with the ID of the document you want to retrieve
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
          "Time": getDate(),
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
          "Time": getDate(),
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
            id: 0,
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
      if (userId()) {
        if (branch.isNotEmpty) {
          FirebaseFirestore.instance
              .collection(branch)
              .doc("Notification")
              .collection("AllNotification")
              .doc(getID())
              .set({
            "id": getID(),
            "Name": "${fullUserId()}",
            "Time": getDate(),
            "Description": message,
            "Link": url
          });
        } else {
          List B = ["EEE", "ECE"];
          for (final b in B) {
            FirebaseFirestore.instance
                .collection(b)
                .doc("Notification")
                .collection("AllNotification")
                .doc(getID())
                .set({
              "id": getID(),
              "Name": "${fullUserId()} (owner)",
              "Time": getDate(),
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
              id: 0,
              title: "Notification Update",
              body: "Send to $count members");
        }
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
      {int id = 1, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }
}

Stream<List<NotificationsConvertor>> readNotifications(
        {required String c0, required String d0, required String c1}) =>
    FirebaseFirestore.instance
        .collection(c0)
        .doc(d0)
        .collection(c1)
        .orderBy('Time', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationsConvertor.fromJson(doc.data()))
            .toList());

class NotificationsConvertor {
  String id;
  final String Name, Url, description, Time;

  NotificationsConvertor(
      {this.id = "",
      required this.Name,
      required this.Url,
      required this.description,
      required this.Time});

  Map<String, dynamic> toJson() => {
        "id": id,
        "Name": Name,
        "Link": Url,
        "Description": description,
        "Time": Time,
      };

  static NotificationsConvertor fromJson(Map<String, dynamic> json) =>
      NotificationsConvertor(
          id: json['id'],
          Name: json["Name"],
          Url: json["Link"],
          description: json["Description"],
          Time: json["Time"]);
}

Future createNotifications(
    {required String User,
    required String description,
    required String Url,
    required String Time}) async {
  final docflash = FirebaseFirestore.instance
      .collection("ECE")
      .doc("Notification")
      .collection("AllNotification")
      .doc();
  final flash = NotificationsConvertor(
    id: docflash.id,
    Time: Time,
    Name: User,
    Url: Url,
    description: description,
  );
  final json = flash.toJson();
  await docflash.set(json);
}
