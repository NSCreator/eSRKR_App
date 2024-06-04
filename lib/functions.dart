// ignore_for_file: must_be_immutable, deprecated_member_use


import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'settings/settings.dart';
import 'notification.dart';
class scrollingImages extends StatefulWidget {
  AspectRatio ar;
  final List images;
  final String id,token;
  bool isZoom;

  scrollingImages(
      {Key? key, required this.images,required this.token, required this.id, this.isZoom = false,this.ar=const AspectRatio(aspectRatio: 16 / 9),})
      : super(key: key);

  @override
  State<scrollingImages> createState() => _scrollingImagesState();
}

class _scrollingImagesState extends State<scrollingImages> {
  String imagesDirPath = '';
  int currentPos = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(

      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CarouselSlider.builder(
              itemCount: widget.images.length,
              options: CarouselOptions(
                  aspectRatio: widget.ar.aspectRatio,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                  autoPlay: widget.images.length > 1 ? true : false,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentPos = index;
                    });
                  }),
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: AspectRatio(
                    aspectRatio: widget.ar.aspectRatio,
                    child: ImageShowAndDownload(
                      image: widget.images[itemIndex],
                      isZoom: widget.isZoom, token: widget.token,
                    ),
                  ),
                );
              }),
        ),

        Positioned(
          bottom: 5,right: 5,
          child: Container(
            decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(5)),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.images.map((url) {
                int index = widget.images.indexOf(url);
                return Container(
                  width: 4.0,
                  height: 4.0,
                  margin:
                  const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentPos == index
                        ? Colors.white
                        :  Colors.white24,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class Constants {
  static final String BASE_URL = 'https://fcm.googleapis.com/fcm/send';
  static final String KEY_SERVER = "AAAA1rq9xW8:APA91bE_dMaAdvS09kz8BOFA2Oy6ZUEee8tcTUMmNYsiyWVyBPbMRfoZ1VgmGD_arVZ9Uib_TDHhmjBvkW75tMovO8jdV6zgUOwZ4z5pmdrAz0MAodlFVd9ssphVxJ2l_WCDuB0KSjiU";
  static final String SENDER_ID = '922256000367	';
}

fullUserId() {
  if(FirebaseAuth.instance.currentUser!.isAnonymous) {
    return "Anonymous";
  }
  var user = FirebaseAuth.instance.currentUser!.email!;
  return user;
}

bool isGmail() {
  if(FirebaseAuth.instance.currentUser!.isAnonymous) {
    return false;
  }
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


String getID() {

  var now = new DateTime.now();
  return DateFormat('d.M.y-kk:mm:ss').format(now);
}

Future<void> ExternalLaunchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn, mode: LaunchMode.externalApplication)) {
    showToastText('Could not launch $urlIn');
    throw 'Could not launch $urlIn';
  }
}


String calculateTimeDifference(String inputDate) {
  DateTime parsedDate = DateFormat("dd.MM.yyyy-HH:mm:ss").parse(inputDate);
  DateTime currentDate = DateTime.now();

  Duration difference = currentDate.difference(parsedDate);

  if (difference.inDays > 365) {
    int years = difference.inDays ~/ 365;
    return "$years years ago";
  } else if (difference.inDays > 30) {
    int months = difference.inDays ~/ 30;
    return "$months months ago";
  } else if (difference.inDays > 0) {
    return "${difference.inDays} days ago";
  } else if (difference.inHours > 0) {
    return "${difference.inHours} hours ago";
  } else if (difference.inMinutes > 0) {
    return "${difference.inMinutes} minutes ago";
  } else {
    return "${difference.inSeconds} seconds ago";
  }
}
String formatTimeDifference(DateTime postedTime) {
  DateTime currentTime = DateTime.now();
  Duration difference = currentTime.difference(postedTime);

  int minutesDifference = difference.inMinutes;
  int hoursDifference = difference.inHours;
  int daysDifference = difference.inDays;
  int monthsDifference = currentTime.month -
      postedTime.month +
      (currentTime.year - postedTime.year) * 12;

  if (monthsDifference > 12) {
    int yearsDifference = monthsDifference ~/ 12;
    return '$yearsDifference years ago';
  } else if (monthsDifference > 0) {
    return '$monthsDifference months ago';
  } else if (daysDifference > 0) {
    return '$daysDifference days ago';
  } else if (hoursDifference > 0) {
    return '$hoursDifference hours ago';
  } else {
    return '$minutesDifference mins ago';
  }
}
String getFileName(String url) {
  var name=url.split(".").last;
  if (url.startsWith('https://drive.google.com')) {
    name = url.split('/d/')[1].split('/')[0];
  } else {
    final Uri uri = Uri.parse(url);
    final String fileName = uri.pathSegments.last;
    name = fileName.split("/").last;
  }
  return name;
}

String picText(String id) {
  var user;
  if (id.isNotEmpty) {
    user = id.split("@");
    if (user.length > 0) {
      int startIndex = user[0].length - 3;
      if (startIndex < 0) {
        startIndex = 0; // Ensure startIndex is not negative
      }
      return user[0].substring(startIndex).toUpperCase();
    }
  }
  return "";
}


isOwner() {
  if(FirebaseAuth.instance.currentUser!.isAnonymous) {
    return false;
  }
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
class backButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      bottom: false,
      child: Row(
        children: [
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              padding:  EdgeInsets.only(top:  2,bottom: 2,left:  5,right: 10),
              margin:  EdgeInsets.symmetric(vertical:  5,horizontal:  10),
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back,color: Colors.black,size:   15,),
                  Text(
                    "  back ",
                    style: TextStyle(
                        color: Colors. black,
                        fontSize:   12),

                  ),

                ],
              ),
            ),
          ),
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
        this.color = Colors. black,
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
                  style: TextStyle(color: Colors.deepOrange,
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
                    color: Colors. black12,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors. black54)),
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
                child: Text(
                  word.substring(2),
                  style: TextStyle(color: Colors. black, fontSize: fontSize ),
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


Future<void> updateToken(String branch) async {
  final token = await FirebaseMessaging.instance.getToken() ?? "";
  await FirebaseFirestore.instance
      .collection("tokens")
      .doc(fullUserId())
      .set({"id": fullUserId(),"time": getID(), "token": token, "branch": branch});
  NotificationService()
      .showNotification(title: "Welcome back to eSRKR!",body: "Your Details Updated");
}

