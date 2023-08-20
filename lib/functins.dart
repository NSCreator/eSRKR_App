// ignore_for_file: must_be_immutable, deprecated_member_use

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

import 'main.dart';
import 'notification.dart';

class Constants {
  static final String BASE_URL = 'https://fcm.googleapis.com/fcm/send';
  static final String KEY_SERVER = "AAAA1rq9xW8:APA91bE_dMaAdvS09kz8BOFA2Oy6ZUEee8tcTUMmNYsiyWVyBPbMRfoZ1VgmGD_arVZ9Uib_TDHhmjBvkW75tMovO8jdV6zgUOwZ4z5pmdrAz0MAodlFVd9ssphVxJ2l_WCDuB0KSjiU";
  static final String SENDER_ID = '922256000367	';
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
double size(BuildContext context) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenHeight = ((mediaQuery.size.height/800)+(mediaQuery.size.width/400))/2;
  return screenHeight;
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
  return FirebaseAuth.instance.currentUser!.email! == "sujithnimmala03@gmail.com";
}



Future<void> showToastText(String message) async {
  await Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: message,
    fontSize: 18,
    timeInSecForIosWeb: 3
  );
}
class backButton extends StatefulWidget {
  Color color;
  double size;
  String text;

  backButton({ this.color=Colors.white,required this.size, this.text=""});
  @override
  State<backButton> createState() => _backButtonState();
}

class _backButtonState extends State<backButton> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            child: Padding(
              padding:  EdgeInsets.only(left:widget.size * 10,right: widget.size * 10),
              child: Icon(Icons.arrow_back,color: widget.color,size:widget.size *  30,),
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),
         if(widget.text.isNotEmpty) Padding(
            padding: EdgeInsets.only(bottom: widget.size * 10),
            child: Text(
              widget.text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.size * 30,
                  fontWeight: FontWeight.w600),
            ),
          ),
          if(widget.text.isNotEmpty)SizedBox(
            width: 45,
          )
        ],
      ),
    );
  }
}
class StyledTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  StyledTextWidget(
      {required this.text,
        this.fontSize = 14,
        this.color = Colors.white,
        this.fontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    final regex = RegExp(r'(http[s]?:\/\/[^\s]+)');
    final matches = regex.allMatches(text);
    List<InlineSpan> spans = [];

    List<String> words = text.split(' ');

    for (String word in words) {
      if (matches.map((match) => match.group(0)!).toList().contains(word))
      {
        spans.add(TextSpan(
          children: [
            WidgetSpan(
              child: InkWell(
                child: Text(
                  "$word ",
                  style: TextStyle(color: Colors.blueAccent),
                ),
                onTap: () {
                  ExternalLaunchUrl(word);
                },
              ),
            ),
            TextSpan(text: ' '),
          ],
        ));
        InkWell(
          child: Text(
            "$word ",
            style: TextStyle(color: Colors.blueAccent),
          ),
          onTap: () {
            ExternalLaunchUrl(word);
          },
        );
      }
      else if (word.startsWith('**')) {
        spans.add(TextSpan(
          children: [
            WidgetSpan(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.white54)),
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
                child: Text(
                  word.substring(2),
                  style: TextStyle(color: Colors.white, fontSize: fontSize - 5),
                ),
              ),
            ),
            TextSpan(text: ' '),
          ],
        ));
      } else if (word.startsWith("'") && word.endsWith("'")) {
        spans.add(TextSpan(
          text: word.substring(1, word.length - 1) + ' ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ));

      } else if (word.startsWith('"') && word.endsWith('"')) {
        spans.add(TextSpan(
          text: word.substring(1, word.length - 1) + ' ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ));

      } else if (word.contains('@')) {
        String url = word.substring(word.indexOf('@') + 1);
        spans.add(
          WidgetSpan(
            child: InkWell(
              onTap: () async {
                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
              child: Text(
                word.split("@").first + ' ',
                style: TextStyle(
                    color: Colors.lightBlueAccent, fontSize: fontSize),
              ),
            ),
          ),
        );
      } else {
        spans.add(TextSpan(text: word + ' '));
      }
    }

    return Wrap(
      children: [
        RichText(
          text: TextSpan(
              children: spans,
              style: TextStyle(
                  fontSize: fontSize, color: color, fontWeight: fontWeight)),
        ),
      ],
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
      .showNotification(title: "Welcome back to eSRKR!",body: "Message Token is Updated");
}


class downloadAllPdfs extends StatefulWidget {
  String branch,SubjectID;
  List pdfs;
  double size;
 downloadAllPdfs({required this.branch,required this.SubjectID,required this.pdfs,required this.size});

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
          if (data["link"].length > 3) {
           await download(data["link"],"pdfs" );
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
            height:widget.size* 28,
            width: widget.size*28,
            child: CircularProgressIndicator(
               strokeWidth: 3,
              color: Colors.green,
              value:_downloadProgress,
            ),
          ),
          if(isDownloaded)SizedBox(
            height:widget.size* 34,
            width: widget.size*34,
            child: CircularProgressIndicator(
              strokeWidth: 2,

              color: Colors.red,
            ),
          ),
          Icon(isDownloaded?Icons.download_done:Icons.download_for_offline_outlined, size:widget.size* 30.0,color: isDownloaded?Colors.greenAccent:Colors.white54,),
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


