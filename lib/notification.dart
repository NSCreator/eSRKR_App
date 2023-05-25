import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:srkr_study_app/HomePage.dart';
import 'package:srkr_study_app/settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'TextField.dart';
import 'auth_page.dart';

class notifications extends StatefulWidget {
  const notifications({Key? key}) : super(key: key);

  @override
  State<notifications> createState() => _notificationsState();
}

class _notificationsState extends State<notifications>
    with SingleTickerProviderStateMixin {
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

  @override
  void dispose() {
    _tabController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      SizedBox(
        height: 20,
      ),
      Text("sdfgsdfg"),
      Center(
        child: TabBar(
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.orange),
          controller: _tabController,
          isScrollable: true,
          labelPadding: EdgeInsets.symmetric(horizontal: 30),
          tabs: [
            Tab(
              child: Text(
                "All",
                style: TextStyle(color: Colors.black),
              ),
            ),
            Tab(
              child: Text(
                "For You",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      Expanded(
        child: TabBarView(
          controller: _tabController,
          children: [
            StreamBuilder<List<NotificationsConvertor>>(
                stream: readNotifications(),
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
                            itemCount: Notifications!.length,
                            itemBuilder: (context, int index) {
                              final Notification = Notifications[index];
                              return InkWell(
                                child: Padding(
                                  padding: Notification.Name == userId()
                                      ? EdgeInsets.only(left: 45, right: 5)
                                      : EdgeInsets.only(right: 45, left: 5),
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: Notification.Name == userId()
                                        ? BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              bottomLeft: Radius.circular(25),
                                              topRight: Radius.circular(25),
                                              bottomRight: Radius.circular(5),
                                            ),
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            border: Border.all(
                                                color:
                                                    Colors.blueAccent.shade100),
                                          )
                                        : BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              bottomLeft: Radius.circular(5),
                                              topRight: Radius.circular(25),
                                              bottomRight: Radius.circular(25),
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
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 1, 25, 1),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        '${Notification.Time}',
                                                        style: const TextStyle(
                                                          fontSize: 9.0,
                                                          color: Colors.white70,
                                                          //   fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8,
                                                  bottom: 6,
                                                  right: 3,
                                                  top: 3),
                                              child: RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                      text:
                                                          " ~ ${Notification.description}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14)),
                                                  if (Notification.Url.length >
                                                      5)
                                                    TextSpan(
                                                      text: Notification.Url,
                                                      style: new TextStyle(
                                                          color: Colors.blue,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          fontSize: 15),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () async {
                                                              // ignore: deprecated_member_use
                                                              if (await canLaunch(
                                                                  Notification
                                                                      .Url)) {
                                                                // ignore: deprecated_member_use
                                                                await launch(
                                                                    Notification
                                                                        .Url);
                                                              } else {
                                                                throw 'Could not launch ${Notification.Url}';
                                                              }
                                                            },
                                                    ),
                                                ]),
                                              ),
                                            ),
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                                onLongPress: () {
                                  if (Notification.Name == userId() ||
                                      userDomain() == "gmail.com") {
                                    final deleteFlashNews = FirebaseFirestore
                                        .instance
                                        .collection("ECE")
                                        .doc("Notification")
                                        .collection("AllNotification")
                                        .doc(Notification.id);
                                    deleteFlashNews.delete();
                                    showToast("Your Message has been Deleted");
                                  } else {
                                    showToast(
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
            StreamBuilder<List<yourNotificationsConvertor>>(
                stream: readyourNotifications(),
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
                            itemCount: Notifications!.length,
                            itemBuilder: (context, int index) {
                              final Notification = Notifications[index];
                              return InkWell(
                                child: Padding(
                                  padding: Notification.Name == userId()
                                      ? EdgeInsets.only(left: 45, right: 5)
                                      : EdgeInsets.only(right: 45, left: 5),
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: Notification.Name == userId()
                                        ? BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              bottomLeft: Radius.circular(25),
                                              topRight: Radius.circular(25),
                                              bottomRight: Radius.circular(5),
                                            ),
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            border: Border.all(
                                                color:
                                                    Colors.blueAccent.shade100),
                                          )
                                        : BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              bottomLeft: Radius.circular(5),
                                              topRight: Radius.circular(25),
                                              bottomRight: Radius.circular(25),
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
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 1, 25, 1),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        '${Notification.Time}',
                                                        style: const TextStyle(
                                                          fontSize: 9.0,
                                                          color: Colors.white70,
                                                          //   fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8,
                                                  bottom: 6,
                                                  right: 3,
                                                  top: 3),
                                              child: RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                      text:
                                                          " ~ ${Notification.description}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14)),
                                                  if (Notification.Url.length >
                                                      5)
                                                    TextSpan(
                                                      text: Notification.Url,
                                                      style: new TextStyle(
                                                          color: Colors.blue,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          fontSize: 15),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () async {
                                                              // ignore: deprecated_member_use
                                                              if (await canLaunch(
                                                                  Notification
                                                                      .Url)) {
                                                                // ignore: deprecated_member_use
                                                                await launch(
                                                                    Notification
                                                                        .Url);
                                                              } else {
                                                                throw 'Could not launch ${Notification.Url}';
                                                              }
                                                            },
                                                    ),
                                                ]),
                                              ),
                                            ),
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                                onLongPress: () {
                                  if (Notification.Name == userId() ||
                                      userDomain() == "gmail.com") {
                                    final deleteFlashNews = FirebaseFirestore
                                        .instance
                                        .collection("ECE")
                                        .doc("Notification")
                                        .collection("AllNotification")
                                        .doc(Notification.id);
                                    deleteFlashNews.delete();
                                    showToast("Your Message has been Deleted");
                                  } else {
                                    showToast(
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
          ],
        ),
      ),
    ]));
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

Future showToast(String message) async {
  await Fluttertoast.cancel();
  Fluttertoast.showToast(msg: message, fontSize: 18);
}

Stream<List<yourNotificationsConvertor>> readyourNotifications() =>
    FirebaseFirestore.instance
        .collection('user')
        .doc(fullUserId())
        .collection("Notifications")
        .orderBy('Time', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => yourNotificationsConvertor.fromJson(doc.data()))
            .toList());

class yourNotificationsConvertor {
  String id;
  final String Name, Url, description, Time;

  yourNotificationsConvertor(
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

  static yourNotificationsConvertor fromJson(Map<String, dynamic> json) =>
      yourNotificationsConvertor(
          id: json['id'],
          Name: json["Name"],
          Url: json["Link"],
          description: json["Description"],
          Time: json["Time"]);
}

Stream<List<NotificationsConvertor>> readNotifications() =>
    FirebaseFirestore.instance
        .collection('ECE')
        .doc("Notification")
        .collection("AllNotification")
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
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
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
