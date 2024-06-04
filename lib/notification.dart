// ignore_for_file: must_be_immutable

import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'functions.dart';



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
     "fromTo": "sujithnimmala03@gmail.com~sujithnimmala03@gmail.com",
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
