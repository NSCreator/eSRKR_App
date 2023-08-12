// ignore_for_file: must_be_immutable

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

    SnackBar(content: Text(text), backgroundColor: Colors.orange);
  }
}

double screenWidth(BuildContext context) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width/400;

  return screenWidth;
}

double screenHeight(BuildContext context) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenHeight = mediaQuery.size.height/800;
  return screenHeight;
}

double Width(BuildContext context) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;

  return screenWidth;
}

double Height(BuildContext context) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenHeight = mediaQuery.size.height;
  return screenHeight;
}
double screenSize(BuildContext context) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenHeight = ((mediaQuery.size.height/800)+(mediaQuery.size.width/400))/2;
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



picText() {
  var user = FirebaseAuth.instance.currentUser!.email!.split("@");
  return user[0].substring(user[0].length - 3).toUpperCase();
}

isUser() {
  var user = FirebaseAuth.instance.currentUser!.email!.split("@");
  return user[1] == "gmail.com";
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
class backButton extends StatefulWidget {
  @override
  State<backButton> createState() => _backButtonState();
}

class _backButtonState extends State<backButton> {
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      child: Padding(
        padding: const EdgeInsets.only(left:10,right: 10),
        child: Icon(Icons.arrow_back,color: Colors.white,size: 30,),
      ),
      onTap: (){
        Navigator.pop(context);
      },
    );
  }
}

Future<void> LaunchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn, mode: LaunchMode.inAppWebView))
    throw 'Could not launch $urlIn';
}

Future<void> updateToken() async {
  final token = await FirebaseMessaging.instance.getToken() ?? "";
  await FirebaseFirestore.instance
      .collection("tokens")
      .doc(fullUserId())
      .set({"id": fullUserId(), "token": token, "branch": ""});
  NotificationService()
      .showNotification(title: "Message Token is Updated", body: null);
}

void like(bool isAdd, String updateId) {
  FirebaseFirestore.instance.collection("update").doc(updateId).update({
    "likedBy": isAdd
        ? FieldValue.arrayUnion([fullUserId()])
        : FieldValue.arrayRemove([fullUserId()]),
  });
}

class downloadAllPdfs extends StatefulWidget {
  String branch,SubjectID;
  List pdfs;
 downloadAllPdfs({required this.branch,required this.SubjectID,required this.pdfs});

  @override
  State<downloadAllPdfs> createState() => _downloadAllPdfsState();
}

class _downloadAllPdfsState extends State<downloadAllPdfs> {
  bool isDownloaded = false;

  double _downloadProgress =0;
  double data=0;
  download(String photoUrl, String path) async {
    final Uri uri = Uri.parse(photoUrl);
    final String fileName = uri.pathSegments.last;
    var name = fileName.split("/").last;
    if (photoUrl.startsWith('https://drive.google.com')) {
      name = photoUrl.split('/d/')[1].split('/')[0];

      photoUrl = "https://drive.google.com/uc?export=download&id=$name";
    }
    final response = await http.get(Uri.parse(photoUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory('${documentDirectory.path}/$path');
    if (!await newDirectory.exists()) {
      await newDirectory.create(recursive: true);
    }
    final file = File('${newDirectory.path}/${name}');
    await file.writeAsBytes(response.bodyBytes);


  }
  void _updateProgress(int downloadedBytes, int totalBytes) {
    setState(() {
      _downloadProgress = downloadedBytes / totalBytes;
    });
  }
   downloadAllImages() async {

    
    final CollectionReference subjects = FirebaseFirestore.instance
        .collection(widget.branch)
        .doc("Subjects")
        .collection("Subjects").doc(widget.SubjectID).collection("Units");

    try {
      final QuerySnapshot querySnapshot = await subjects.get();
      if (querySnapshot.docs.isNotEmpty) {
        int totalDownloadingCount=0;
        int totalDownloadedCount = 0;
        final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
        setState(() {
          totalDownloadedCount = documents.length;
        });
        for (final document in documents) {
          final data = document.data() as Map<String, dynamic>;
          if (data["PDFLink"].length > 3) {
           await download(data["PDFLink"],"pdfs" );
           setState(() {
             totalDownloadingCount++;
             _updateProgress(totalDownloadingCount,totalDownloadedCount);
           });
          }
        }

        setState(() {
          isDownloaded = false;
        });
      } else {
        print('No documents found');
      }
    } catch (e) {
      print('Error: $e');
    }
   

  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[

          SizedBox(
            height: 28,
            width: 28,
            child: CircularProgressIndicator(
               strokeWidth: 3,
              color: Colors.green,
              value:_downloadProgress,
            ),
          ),
          if(isDownloaded)SizedBox(
            height: 34,
            width: 34,
            child: CircularProgressIndicator(
              strokeWidth: 2,

              color: Colors.red,
            ),
          ),
          Icon(isDownloaded?Icons.download_done:Icons.download_for_offline_outlined, size: 30.0,color: isDownloaded?Colors.greenAccent:Colors.white54,),
        ],
      ),
      onTap: (){
        setState(() {
          isDownloaded=true;
        });
        downloadAllImages();
      },
    );
  }
}


