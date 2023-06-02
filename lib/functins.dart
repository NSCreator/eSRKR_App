import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'notification.dart';

class Constants {
  static final String BASE_URL = 'https://fcm.googleapis.com/fcm/send';
  static final String KEY_SERVER =
      'AAAA9CTzPoM:APA91bHTk4DcD6fSCJh-EaGH7KreA92u9kpri6o6Sl8euReOgCduR7595Eup4SYfGH6xg1tSaXcZ659kJlQ-ae48H66Ufx-a2xNLl4rlho4EI2A1grpmmuU0JbIsT_Fu7KndWzyDFz9C';
  static final String SENDER_ID = '1048591941251';
}

Future<void> sendingMails(String urlIn) async {
  var url = Uri.parse("mailto:$urlIn");
  if (!await launchUrl(url)) throw 'Could not launch $url';
}

class Utils {
  static showSnackBar(String? text) {
    if (text == null) return;
    final snackBar =
        SnackBar(content: Text(text), backgroundColor: Colors.orange);
  }
}

double screenWidth(BuildContext context) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width / 400;

  return screenWidth;
}

double screenHeight(BuildContext context) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenHeight = mediaQuery.size.height / 850;
  return screenHeight;
}

String getDate() {
  var now = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');
  String formattedDate = formatter.format(now);
  return formattedDate;
}

String getID() {
  var now = new DateTime.now();
  return DateFormat('d.M.y-kk:mm:ss').format(now);
}

Future<void> ExternalLaunchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $urlIn';
  }
}

user0Id() {
  var user = FirebaseAuth.instance.currentUser!.email!.split("@");
  return user[0];
}

userId() {
  var user = FirebaseAuth.instance.currentUser!.email!.split("@");
  return user[1];
}

fullUserId() {
  var user = FirebaseAuth.instance.currentUser!.email!;
  return user;
}

Future<void> showToastText(String message) async {
  await Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: message,
    fontSize: 18,
  );
}

Future<void> LaunchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn, mode: LaunchMode.inAppWebView))
    throw 'Could not launch $urlIn';
}

Future<void> updateToken() async {
  final token = await FirebaseMessaging.instance.getToken() ?? "";
  await FirebaseFirestore.instance.collection("tokens").doc(fullUserId()).set({
    "id": fullUserId(),
    "token": token,
  });
  NotificationService()
      .showNotification(id: 1, title: "Message Token is Updated", body: null);
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
    showToast(file.path);
  } else {
    final file = File('${newDirectory.path}/${name}');
    await file.writeAsBytes(response.bodyBytes);
    showToast(file.path);
  }
}
