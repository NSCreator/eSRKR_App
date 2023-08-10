import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srkr_study_app/functins.dart';

import 'HomePage.dart';


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';



class MyHomePage extends StatefulWidget {


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  late final RewardedAd rewardedAd;
  final String rewardedAdUnitId = "ca-app-pub-7097300908994281/7894809729"; //sample ad unit id

  //load ad
  @override
  void initState(){
    super.initState();

    //load ad here...
    _loadRewardedAd();
  }

  //method to load an ad
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request:const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        //when failed to load
        onAdFailedToLoad: (LoadAdError error){
          print("Failed to load rewarded ad, Error: $error");
        },
        //when loaded
        onAdLoaded: (RewardedAd ad){
          print("$ad loaded");
          showToastText("Add loaded");
          rewardedAd = ad;

          //set on full screen content call back
          _setFullScreenContentCallback();
        },
      ),
    );
  }

  //method to set show content call back
  void _setFullScreenContentCallback(){
    if(rewardedAd == null) return;
    rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      //when ad  shows fullscreen
      onAdShowedFullScreenContent: (RewardedAd ad) => print("$ad onAdShowedFullScreenContent"),
      //when ad dismissed by user
      onAdDismissedFullScreenContent: (RewardedAd ad){
        print("$ad onAdDismissedFullScreenContent");

        //dispose the dismissed ad
        ad.dispose();
      },
      //when ad fails to show
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error){
        print("$ad  onAdFailedToShowFullScreenContent: $error ");
        //dispose the failed ad
        ad.dispose();
      },

      //when impression is detected
      onAdImpression: (RewardedAd ad) =>print("$ad Impression occured"),
    );

  }

  //show ad method
  void _showRewardedAd(){
    //this method take a on user earned reward call back
    rewardedAd.show(
      //user earned a reward
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem){
          num amount = rewardItem.amount;
          showToastText("You earned: $amount");
        }
    );
  }
  void showToastText(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(
        child: InkWell(
          onTap: _showRewardedAd,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            height: 100,
            color: Colors.orange,
            child: const Text(
              "Show Rewarded Ad",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 35),
            ),
          ),

        ),
      ),
    );
  }



}
class ImageScreen extends StatefulWidget {
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _canOpenImage = true;
  double remainingTime =0;

  @override
  void initState() {
    super.initState();
    _checkImageOpenStatus();
  }

  Future<void> _checkImageOpenStatus() async {
    final user = _auth.currentUser;
    if (user != null) {
      final imageRef = _firestore.collection("user").doc(fullUserId());

      final documentSnapshot = await imageRef.get();
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        if(data['lastOpenAdTime'].toString().isEmpty){
          setState(() {
            _canOpenImage = true; // 3600 seconds = 1 hour
          });
        }
       else{
          final lastOpenTime = data['lastOpenAdTime'] as Timestamp;

          final currentTime = Timestamp.now();
          final difference = currentTime.seconds - lastOpenTime.seconds;

          setState(() {
            _canOpenImage = difference >= 3600; // 3600 seconds = 1 hour
            remainingTime = (3600-difference)/60 ;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white30)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Support society => ",style: TextStyle(color: Colors.white,fontSize: 20),),
                  Text("  for a small change",style: TextStyle(color: Colors.white54,fontSize: 15),),
                ],
              ),
              _canOpenImage
                  ? ElevatedButton(
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
                  if (_canOpenImage) {
                    final user = _auth.currentUser;
                    if (user != null) {
                      final imageRef =
                      _firestore.collection('user').doc(fullUserId());
                      await imageRef.update({
                        'lastOpenAdTime': FieldValue.serverTimestamp(),
                      });
                    }

                    setState(() {
                      _canOpenImage = false;
                    });
                  }
                },
                child: Text('Register...'),
              )
                  : Text(
                'Wait for ${remainingTime.round()} mins',
                style: TextStyle(fontSize: 18,color: Colors.amber),
              ),

            ],
          ),
        ),
      ),
    );
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
