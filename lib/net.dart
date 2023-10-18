// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srkr_study_app/ads.dart';
import 'package:srkr_study_app/functins.dart';
import 'package:flutter/cupertino.dart';

import 'HomePage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'TextField.dart';
import 'main.dart';

import 'package:flutter/material.dart';

class HighlightedTextWidget extends StatefulWidget {
  final String text;
  final String highlightWord;

  HighlightedTextWidget({required this.text, required this.highlightWord});

  @override
  State<HighlightedTextWidget> createState() => _HighlightedTextWidgetState();
}

class _HighlightedTextWidgetState extends State<HighlightedTextWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    final words = widget.text.split(' ');

    for (var word in words) {
      final isHighlighted = word.toLowerCase() == widget.highlightWord.toLowerCase();
      final textStyle = isHighlighted
          ? TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.blue,
            )
          : TextStyle(fontSize: 18);

      widgets.add(
        Text(
          " $word",
          style: textStyle,
        ),
      );

      if (isHighlighted) {
        widgets.add(SizedBox(width: 8.0)); // Add some spacing for highlighted word.
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterTts flutterTts = FlutterTts();
  TextEditingController textEditingController = TextEditingController();
  bool isSpeaking = false;
  final List<String> words = [];
  double pitch = 1; // Initial pitch value (range: 0.0 - 1.0)
  double speechRate = 0.5; // Initial speech rate value (range: 0.0 - 1.0)
  String selectedLanguage = 'en-US'; // Initial language
  List<DropdownMenuItem<String>> languageItems = []; // List of language items
  String _currentWord = "";
  bool isExp = false;

  @override
  void initState() {
    super.initState();

    flutterTts.setProgressHandler((String text, int startOffset, int endOffset, String word) {
      setState(() {
        _currentWord = word;
        words.add(_currentWord);
      });
    });
    // Initialize the FlutterTts instance
    loadSavedSettings();

    // Get the list of available languages
    getAvailableLanguages();
    // Load saved settings
  }

  // Initialize FlutterTts
  Future<void> initTts() async {
    await flutterTts.setLanguage(selectedLanguage);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(speechRate);
    await flutterTts.setVolume(1);
  }

  Future<void> speakText(String text) async {
    await flutterTts.speak(text);
    setState(() {
      isSpeaking = true;
    });
  }

  // Function to pause text-to-speech
  Future<void> pauseSpeech() async {
    await flutterTts.pause();
    setState(() {
      isSpeaking = false;
    });
  }

  // Function to change language
  Future<void> changeLanguage(String languageCode) async {
    await flutterTts.setLanguage(languageCode);
    setState(() {
      selectedLanguage = languageCode;
    });
  }

  // Function to get the list of available languages
  Future<void> getAvailableLanguages() async {
    List<dynamic> languages = await flutterTts.getLanguages;
    setState(() {
      languageItems = languages
          .map((language) => DropdownMenuItem<String>(
                value: language.toString(),
                child: Text(language.toString()),
              ))
          .toList();
    });
  }

  ScrollController _scrollController = ScrollController();

  // Function to save settings
  Future<void> saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('pitch', pitch);
    prefs.setDouble('speechRate', speechRate);
    prefs.setString('selectedLanguage', selectedLanguage);
    prefs.setString('textToSpeak', textEditingController.text);
  }

  // Function to load saved settings
  Future<void> loadSavedSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      pitch = prefs.getDouble('pitch') ?? 1;
      speechRate = prefs.getDouble('speechRate') ?? 0.5;
      selectedLanguage = prefs.getString('selectedLanguage') ?? 'en-US';
      textEditingController.text = prefs.getString('textToSpeak') ?? '';
    });
    initTts();
  }

  @override
  void dispose() {
    // Dispose of the FlutterTts instance and the controller when done
    flutterTts.stop();
    textEditingController.dispose();
    // Save settings when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              backButton(
                size: Size,
                child: SizedBox(
                  width: Size*45,
                ),
                text: "Reader (Beta)",
              ),
              Expanded(
                child: isSpeaking
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(Size*8),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(Size*30),
                        ),
                        child: SingleChildScrollView(
                          reverse: true,
                          child: Wrap(
                            children: words.asMap().entries.map((entry) {
                              final word = entry.value;
                              return Text(
                                " $word",
                                style: TextStyle(
                                  fontSize:Size* 20.0,
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                          ),
                        ))
                    : Container(
                        decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding:  EdgeInsets.only(left:Size* 10),
                          child: TextFormField(
                            controller: textEditingController,
                            textInputAction: TextInputAction.next,
                            maxLines: null,
                            style: TextStyle(color: Colors.white, fontSize: Size*20),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none,
                              hintText: 'Write Here',
                            ),
                          ),
                        )),
              ),
              SizedBox(height: Size*20),

              if (isExp)
                Container(
                  padding: EdgeInsets.all(Size*10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Size*20),
                    gradient:
                    LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.transparent,
                      Colors.white.withOpacity(0.1),

                    ]),
                  ),
                  child: Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          valueIndicatorTextStyle: TextStyle(
                            fontSize: Size*13,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Text(
                                  "Pitch: ${pitch.toStringAsFixed(2)}",
                                  style: TextStyle(color: Colors.white, fontSize:Size* 20, fontWeight: FontWeight.w500),
                                ),
                                Expanded(
                                  child: Slider(
                                    value: pitch,
                                    min: 0.0, // Adjusted minimum value
                                    max: 1.0,
                                    onChanged: (value) {
                                      setState(() {
                                        pitch = value;
                                        flutterTts.setPitch(pitch);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Speech Rate: ${speechRate.toStringAsFixed(2)}",
                                  style: TextStyle(color: Colors.white, fontSize: Size*20, fontWeight: FontWeight.w500),
                                ),
                                Expanded(
                                  child: Slider(
                                    value: speechRate,
                                    min: 0.0, // Adjusted minimum value
                                    max: 1.0,
                                    onChanged: (value) {
                                      setState(() {
                                        speechRate = value;
                                        flutterTts.setSpeechRate(speechRate);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Change Language : ",
                            style: TextStyle(color: Colors.white, fontSize:Size* 20, fontWeight: FontWeight.w500),
                          ),
                          Expanded(
                            child: Center(
                              child: Container(
                                height:Size* 40,
                                decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(Size*20)),
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: Size* 8.0),
                                  child: DropdownButton<String>(
                                    value: selectedLanguage,
                                    items: languageItems,
                                    onChanged: (value) {
                                      // Call the changeLanguage function when a language is selected
                                      changeLanguage(value!);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          saveSettings();
                        },
                        child: Text(
                          "Save Changes",
                          style: TextStyle(fontSize: Size*16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height:Size* 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style:ElevatedButton.styleFrom(
   backgroundColor: Colors.blueGrey,
                        onPrimary: Colors.white
    ),
                    onPressed: () {
                      setState(() {
                        isExp = !isExp;
                      });
                    },
                    child: Text(
                      "Audio Settings",
                      style: TextStyle(fontSize: Size*16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (isSpeaking) {
                        pauseSpeech();
                      } else {
                        speakText(textEditingController.text);
                        saveSettings();
                      }
                    },
                    child: Text(
                      isSpeaking ? "Pause" : "Speak Text",
                      style: TextStyle(fontSize:Size* 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              SizedBox(height: Size*20),
            ],
          ),
        ),
      ),
    );
  }
}

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
      padding:  EdgeInsets.all(widget.size *15.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(widget.size *10),
            border: Border.all(color: Colors.white54)),
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
                    "Support Us => ",
                    style: TextStyle(color: Colors.white, fontSize: widget.size *20),
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
                      padding:  EdgeInsets.symmetric(vertical: widget.size *3,horizontal: widget.size *10),
                      child: Text('Help',style: TextStyle(color: Colors.black,fontSize: widget.size *20,fontWeight: FontWeight.w500),),
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
      data = "${picText("") + ":" + fullUserId()};$data";
    }
    FirebaseFirestore.instance.collection(widget.branch).doc("supportedList").update({
      "supportedList": isAdd ? FieldValue.arrayUnion([data]) : FieldValue.arrayRemove([data]),
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
    double Size=size(context);
    return Scaffold(
        body: SafeArea(
          child: Column(
      children: [
          backButton(
              size: size(context),
              text: "Supported List",
              child: SizedBox(
                width: Size *45,
              )),
          !commentsIds.contains(fullUserId())
              ? Padding(
                  padding:  EdgeInsets.symmetric(vertical:Size * 8, horizontal:Size * 20),
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(Size *20)),
                          child: Padding(
                            padding:  EdgeInsets.only(left:Size * 10),
                            child: TextFormField(
                              controller: _comment,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(color: Colors.white, fontSize: Size *25),
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
                          padding:  EdgeInsets.all(Size *5.0),
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
                  style: TextStyle(color: Colors.greenAccent, fontSize:Size * 30, fontWeight: FontWeight.w700),
                ),
          Padding(
            padding:  EdgeInsets.all(Size *5.0),
            child: Text(
              "Note : You can send message only for one time",
              style: TextStyle(color: Colors.amber, fontSize: Size *15),
            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: Size *10, horizontal:Size * 5),
            child: Text(
              "Thanks for being a member :)",
              style: TextStyle(color: Colors.white, fontSize:Size * 25, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            height: 3,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(Size *5),
            ),
          ),
          Expanded(
            child: Padding(
              padding:  EdgeInsets.symmetric(vertical: Size *10, horizontal:Size * 5),
              child: ListView.builder(
                shrinkWrap: true,
                reverse: false,
                padding: EdgeInsets.symmetric(horizontal: Size *10),
                itemCount: comments.length,
                itemBuilder: (BuildContext context, int index) {
                  String data = comments[index];
                  String user = data.split(";").first;
                  String comment = data.split(";").last;
                  return Padding(
                    padding:  EdgeInsets.symmetric(vertical:Size * 5),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Size *30), border: Border.all(color: Colors.white54)),
                          child: Padding(
                            padding:  EdgeInsets.all(Size *3.0),
                            child: Text(
                              user.split(":").first,
                              style: TextStyle(color: Colors.white, fontSize:Size * 20),
                            ),
                          ),
                        ),
                        SizedBox(
                          width:Size * 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "@${user.split(":").last}",
                              style: TextStyle(color: Colors.white54, fontSize: Size *13),
                            ),
                            Text(
                              comment,
                              style: TextStyle(color: Colors.white, fontSize:Size * 20),
                            ),
                          ],
                        ),
                        Spacer(),
                        if (isOwner())
                          InkWell(
                            child: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                              size: Size *30,
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
              style: TextStyle(color: Colors.white60, fontWeight: FontWeight.w500, fontSize: Size *13),
            ),
          ),
      ],
    ),
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
