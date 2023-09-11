import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srkr_study_app/ads.dart';
import 'package:srkr_study_app/functins.dart';

import 'HomePage.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'main.dart';





class ImageScreen extends StatefulWidget {
  final String branch;
  double size;

  ImageScreen({required this.branch,required this.size});

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  late final RewardedAd rewardedAd;


  bool isAdLoaded = false;

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdVideo.bannerAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdFailedToLoad: (LoadAdError error) {
          print("Failed to load rewarded ad, Error: $error");
        },
        onAdLoaded: (RewardedAd ad) {
          print("$ad loaded");
          showToastText("Add loaded");
          rewardedAd = ad;
          setState(() {
            isAdLoaded = true;
          });
          //set on full screen content call back
          _setFullScreenContentCallback();
        },
      ),
    );
  }

  //method to set show content call back
  void _setFullScreenContentCallback() {
    if (rewardedAd == null) {
      return;
    }
    rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      //when ad  shows fullscreen
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print("$ad onAdShowedFullScreenContent"),
      //when ad dismissed by user
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print("$ad onAdDismissedFullScreenContent");

        //dispose the dismissed ad
        ad.dispose();
      },
      //when ad fails to show
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print("$ad  onAdFailedToShowFullScreenContent: $error ");
        //dispose the failed ad
        ad.dispose();
      },

      //when impression is detected
      onAdImpression: (RewardedAd ad) => print("$ad Impression occured"),
    );
  }

  Future<void> _showRewardedAd() async {
    rewardedAd.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      num amount = rewardItem.amount;
      showToastText("You earned: $amount");

    });
    final imageRef = _firestore.collection("user").doc(fullUserId());

    final documentSnapshot = await imageRef.get();
    if (documentSnapshot.exists) {
      final data = documentSnapshot.data() as Map<String, dynamic>;
      if (data['adSeenCount']==null) {
        _firestore.collection("user").doc(fullUserId()).update({"adSeenCount":0});
      } else {
        _firestore.collection("user").doc(fullUserId()).update({"adSeenCount":data['adSeenCount']+1});

      }
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _canOpenImage = true;
  double remainingTime = 0;

  @override
  void initState() {
    super.initState();
    _checkImageOpenStatus();
    _loadRewardedAd();
  }

  Future<void> _checkImageOpenStatus() async {
    final user = _auth.currentUser;
    if (user != null) {
      final imageRef = _firestore.collection("user").doc(fullUserId());

      final documentSnapshot = await imageRef.get();
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        if (data['lastOpenAdTime'].toString().isEmpty) {
          setState(() {
            _canOpenImage = true; // 3600 seconds = 1 hour
          });
        } else {
          final lastOpenTime = data['lastOpenAdTime'] as Timestamp;

          final currentTime = Timestamp.now();
          final difference = currentTime.seconds - lastOpenTime.seconds;

          setState(() {
            _canOpenImage = difference >= 3600; // 3600 seconds = 1 hour
            remainingTime = (3600 - difference) / 60;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(widget.size *20.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(widget.size *15),
            border: Border.all(color: Colors.white30)),
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical:widget.size * 5, horizontal: widget.size *10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Support society => ",
                    style: TextStyle(color: Colors.white, fontSize: widget.size *20),
                  ),
                  Text(
                    "  for a small change",
                    style: TextStyle(color: Colors.white54, fontSize: widget.size *15),
                  ),
                ],
              ),
              _canOpenImage
                  ? isAdLoaded
                  ? InkWell(
                onTap: () async {
                  if (_canOpenImage) {
                    _showRewardedAd();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => supportList(
                              branch: widget.branch,
                            )));
                    final user = _auth.currentUser;
                    if (user != null) {
                      final imageRef = _firestore
                          .collection('user')
                          .doc(fullUserId());
                      await imageRef.update({
                        'lastOpenAdTime':
                        FieldValue.serverTimestamp(),
                      });
                    }
                    setState(() {
                      _canOpenImage = false;
                    });
                  }
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.lightGreenAccent,
                        borderRadius: BorderRadius.circular(widget.size *10)
                    ),
                    child: Padding(
                      padding:  EdgeInsets.symmetric(vertical: widget.size *5,horizontal: widget.size *10),
                      child: Text('Help',style: TextStyle(color: Colors.black,fontSize: widget.size *20,fontWeight: FontWeight.w700),),
                    )),
              )
                  : Text(
                'Wait for few secs',
                style: TextStyle(fontSize:widget.size * 18, color: Colors.amber),
              )
                  : Text(
                'Wait for ${remainingTime.round()} mins',
                style: TextStyle(fontSize: widget.size *18, color: Colors.amber),
              ),
              if (!_canOpenImage)
                InkWell(
                  child: Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size:widget.size * 35,
                  ),
                  onTap: () {
                    _checkImageOpenStatus();
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}

class supportList extends StatefulWidget {
  final String branch;

  const supportList({required this.branch});

  @override
  State<supportList> createState() => _supportListState();
}

class _supportListState extends State<supportList> {
  final TextEditingController _comment = TextEditingController();
  List comments = [];
  List commentsIds = [];
  String money = "0";

  @override
  void initState() {
    super.initState();
    getComments();
  }

  addComment(bool isAdd, String data) {
    if (isAdd) {
      if (data.isEmpty) {
        data = "owner : Thanks for helping";
      }
      data = "${picText() + ":" + fullUserId()};$data";
    }
    FirebaseFirestore.instance
        .collection(widget.branch)
        .doc("supportedList")
        .update({
      "supportedList": isAdd
          ? FieldValue.arrayUnion([data])
          : FieldValue.arrayRemove([data]),
    });
  }

  getComments() async {
    await FirebaseFirestore.instance
        .collection(widget.branch)
        .doc("supportedList")
        .get()
        .then((DocumentSnapshot snapshot) async {
      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null && data is Map<String, dynamic>) {
          comments = data['supportedList'];
          money = data['money'];
          for (String x in comments) {
            commentsIds.add(x.split(";").first.split(":").last);
          }
          setState(() {
            money;
            comments.sort();
            commentsIds;
          });
        }
      } else {
        print("Document does not exist.");
      }
    }).catchError((error) {
      print("An error occurred while retrieving data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return backGroundImage(child: Column(
      children: [
        backButton(size: size(context),text: "Supported List",child: SizedBox(width: 45,)),
        !commentsIds.contains(fullUserId())
            ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
              child: Row(
          children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      controller: _comment,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      style:
                      TextStyle(color: Colors.white, fontSize: 25),
                      maxLines: null,
                      // Allows the field to expand as needed
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(
                          color: Colors.white60,
                        ),
                        border: InputBorder.none,
                        hintText: 'write your message',
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.send,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                onTap: () async {
                  await addComment(true, _comment.text);
                  getComments();
                  _comment.clear();
                },
              )
          ],
        ),
            )
            : Text(
          "Your already Submitted",
          style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 30,
              fontWeight: FontWeight.w700),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            "Note : You can send message only for one time",
            style: TextStyle(color: Colors.amber, fontSize: 15),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Text(
            "Thanks for being a member :)",
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          height: 3,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Expanded(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: ListView.builder(
              shrinkWrap: true,
              reverse: false,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemCount: comments.length,
              itemBuilder: (BuildContext context, int index) {
                String data = comments[index];
                String user = data.split(";").first;
                String comment = data.split(";").last;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white54)),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            user.split(":").first,
                            style: TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "@${user.split(":").last}",
                            style: TextStyle(
                                color: Colors.white54, fontSize: 13),
                          ),
                          Text(
                            comment,
                            style: TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                      Spacer(),
                      if (isUser())
                        InkWell(
                          child: Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                            size: 30,
                          ),
                          onTap: () {
                            addComment(false, data);
                            getComments();
                          },
                        )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            "Earned money \$ $money",
            style: TextStyle(
                color: Colors.white60,
                fontWeight: FontWeight.w500,
                fontSize: 13),
          ),
        ),
      ],
    ));
  }
}

class UpdateConvertorUtil {
  // Add a new UpdateConvertor instance to the list in SharedPreferences
  static Future<void> addUpdateConvertor(UpdateConvertor update) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> updateList = prefs.getStringList('update_list') ?? [];
    updateList.add(jsonEncode(update.toJson()));
    await prefs.setStringList('update_list', updateList);
  }

  // Get the list of UpdateConvertor instances from SharedPreferences
  static Future<List<UpdateConvertor>> getUpdateConvertorList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> updateList = prefs.getStringList('update_list') ?? [];
    return updateList.map((jsonString) {
      Map<String, dynamic> updateMap = jsonDecode(jsonString);
      return UpdateConvertor.fromJson(updateMap);
    }).toList();
  }

  // Remove a specific UpdateConvertor instance from the list in SharedPreferences
  static Future<void> removeUpdateConvertor(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> updateList = prefs.getStringList('update_list') ?? [];
    if (index >= 0 && index < updateList.length) {
      updateList.removeAt(index);
      await prefs.setStringList('update_list', updateList);
    }
  }
}

class BranchNewConvertorUtil {
  // Add a new UpdateConvertor instance to the list in SharedPreferences
  static Future<void> addUpdateConvertor(BranchNewConvertor update) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> updateList = prefs.getStringList('news_list') ?? [];
    updateList.add(jsonEncode(update.toJson()));
    await prefs.setStringList('news_list', updateList);
  }

  // Get the list of UpdateConvertor instances from SharedPreferences
  static Future<List<BranchNewConvertor>> getUpdateConvertorList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> updateList = prefs.getStringList('news_list') ?? [];
    return updateList.map((jsonString) {
      Map<String, dynamic> updateMap = jsonDecode(jsonString);
      return BranchNewConvertor.fromJson(updateMap);
    }).toList();
  }

  // Remove a specific UpdateConvertor instance from the list in SharedPreferences
  static Future<void> removeUpdateConvertor(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> updateList = prefs.getStringList('news_list') ?? [];
    if (index >= 0 && index < updateList.length) {
      updateList.removeAt(index);
      await prefs.setStringList('news_list', updateList);
    }
  }
}
