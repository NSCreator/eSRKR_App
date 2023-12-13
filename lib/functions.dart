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

import 'notification.dart';

class Constants {
  static final String BASE_URL = 'https://fcm.googleapis.com/fcm/send';
  static final String KEY_SERVER = "AAAA1rq9xW8:APA91bE_dMaAdvS09kz8BOFA2Oy6ZUEee8tcTUMmNYsiyWVyBPbMRfoZ1VgmGD_arVZ9Uib_TDHhmjBvkW75tMovO8jdV6zgUOwZ4z5pmdrAz0MAodlFVd9ssphVxJ2l_WCDuB0KSjiU";
  static final String SENDER_ID = '922256000367	';
}
class backgroundcolor extends StatefulWidget {
  Widget child;

  backgroundcolor({required this.child});

  @override
  State<backgroundcolor> createState() => _backgroundcolorState();
}

class _backgroundcolorState extends State<backgroundcolor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.blue.withOpacity(0.12),
            Colors.black.withOpacity(0.12),
          ],
        ),
      ),
      child: widget.child,
    );
  }
}

fullUserId() {
  var user = FirebaseAuth.instance.currentUser!.email!;
  return user;
}

bool isGmail() {
  var user = FirebaseAuth.instance.currentUser!.email!;

  String numberString = user.substring(0, 2);

  int? number = int.tryParse(numberString);

  if (number == null && user.split("@").last == "srkrec.ac.in") {
    return true;
  } else {
    return false;
  }
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



picText(String id) {
  var user;
  user = FirebaseAuth.instance.currentUser!.email!.split("@");
  if(id.isNotEmpty)user = id.split("@");
  return user[0].substring(user[0].length - 3).toUpperCase();
}

isOwner() {
  return FirebaseAuth.instance.currentUser!.email!.split("@").last == "gmail.com";
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
  final Color color;
  final double size;
  final String text;
   Widget child;

  backButton({
    this.color = Colors.white,
    required this.size,
    this.text = "",
     required this.child,
  }) ;
  @override
  State<backButton> createState() => _backButtonState();
}

class _backButtonState extends State<backButton> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.symmetric(vertical: widget.size*5,horizontal: widget.size*5),
      child: InkWell(
        onTap: (){
          Navigator.pop(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:  EdgeInsets.only(left:widget.size * 10,right: widget.size * 10),
              child: Icon(Icons.arrow_back,color: widget.color,size:widget.size *  20,),
            ),
           if(widget.text.isNotEmpty) Expanded(
             child: Text(
               widget.text,
               style: TextStyle(
                   color: Colors.white,
                   fontSize: widget.size * 20,
                   fontWeight: FontWeight.w600),
               maxLines: 1,
               overflow: TextOverflow.ellipsis,
             ),
           ),
            widget.child
          ],
        ),
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
                  "${word.substring(0,35)}.... ",
                  style: TextStyle(color: Colors.lightBlueAccent,
                      fontSize: fontSize),
                ),
                onTap: () {
                  ExternalLaunchUrl(word);
                },
              ),
            ),
            TextSpan(text: ' '),
          ],
        ));
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
                  style: TextStyle(color: Colors.white, fontSize: fontSize ),
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

              fontSize: fontSize, color: color,
          ),
        ));

      } else if (word.startsWith('"') && word.endsWith('"')) {
        spans.add(TextSpan(
          text: word.substring(1, word.length - 1) + ' ',
          style: TextStyle(

            fontSize: fontSize, color: color,
          ),
        ));

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
                  fontSize: fontSize, color: color)),
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

Future<void> updateToken(String branch) async {
  final token = await FirebaseMessaging.instance.getToken() ?? "";
  branch.isNotEmpty?await FirebaseFirestore.instance
      .collection("tokens")
      .doc(fullUserId())
      .set({"id": fullUserId(), "token": token, "branch": branch}):await FirebaseFirestore.instance
      .collection("tokens")
      .doc(fullUserId())
      .update({"token": token});
  NotificationService()
      .showNotification(title: "Welcome back to eSRKR!",body: "Message Token is Updated");
}


class downloadAllPdfs extends StatefulWidget {
  String branch,SubjectID;
  String mode;
  double size;
 downloadAllPdfs({required this.branch,required this.SubjectID,required this.mode,required this.size});

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
        .doc(widget.mode=="Subjects"?"Subjects":"LabSubjects")
        .collection(widget.mode=="Subjects"?"Subjects":"LabSubjects").doc(widget.SubjectID).collection("Units");

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
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(20)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
              Icon(isDownloaded?Icons.download_done:Icons.file_download_outlined, size:widget.size* 30.0,color: isDownloaded?Colors.greenAccent:Colors.purpleAccent,),
            ],
          ),
        ),
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


