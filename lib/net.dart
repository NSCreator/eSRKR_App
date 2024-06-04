// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srkr_study_app/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:srkr_study_app/subjects/subjects.dart';
import 'package:srkr_study_app/uploader.dart';
import 'settings/settings.dart';
import 'package:path/path.dart' as path;
class AskAi extends StatefulWidget {
  List<FileUploader> data;
   AskAi({required this.data});

  @override
  State<AskAi> createState() => _AskAiState();
}

class _AskAiState extends State<AskAi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              backButton(),
              Heading(heading: "Software Domain Route Map"),
              GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  childAspectRatio: 8.5 / 12.5,
                ),
                itemCount: widget.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return pdfContainer(data:widget.data[index]);
                },
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class TTS extends StatefulWidget {
  @override
  _TTSState createState() => _TTSState();
}

class _TTSState extends State<TTS> {

  TextEditingController textEditingController = TextEditingController();
  bool isSpeaking = false;
  final List<String> words = [];
  double pitch = 1; // Initial pitch value (range: 0.0 - 1.0)
  double speechRate = 0.5; // Initial speech rate value (range: 0.0 - 1.0)
  String selectedLanguage = 'en-US'; // Initial language
  List<DropdownMenuItem<String>> languageItems = []; // List of language items

  bool isExp = false;

  @override
  void initState() {
    super.initState();
    initTTS();
    loadSavedSettings();
    getAvailableLanguages();
  }

  // Initialize FlutterTts
  Future<void> initTts() async {
    await _flutterTts.setLanguage(selectedLanguage);
    await _flutterTts.setPitch(pitch);
    await _flutterTts.setSpeechRate(speechRate);
    await _flutterTts.setVolume(1);
  }


  Future<void> changeLanguage(String languageCode) async {
    await _flutterTts.setLanguage(languageCode);
    setState(() {
      selectedLanguage = languageCode;
    });
  }

  Future<void> getAvailableLanguages() async {
    List<dynamic> languages = await _flutterTts.getLanguages;
    setState(() {
      languageItems = languages
          .map((language) => DropdownMenuItem<String>(
                value: language.toString(),
                child: Text(language.toString()),
              ))
          .toList();
    });
  }

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
    _flutterTts.stop();
    textEditingController.dispose();
    super.dispose();
  }


  FlutterTts _flutterTts = FlutterTts();

  List<Map> _voices = [];
  Map? _currentVoice;

  int? _currentWordStart, _currentWordEnd;

  void initTTS() {
    _flutterTts.setProgressHandler((text, start, end, word) {
      setState(() {
        _currentWordStart = start;
        _currentWordEnd = end;
      });
    });
    _flutterTts.getVoices.then((data) {
      try {
        List<Map> voices = List<Map>.from(data);
        setState(() {
          _voices =
              voices.where((voice) => voice["name"].contains("en")).toList();
          _currentVoice = _voices.first;
          setVoice(_currentVoice!);
        });
      } catch (e) {
        print(e);
      }
    });
  }

  void setVoice(Map voice) {
    _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }
  bool isPlaying =false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                backButton(

                ),
                Heading(heading: "Text To Speech -- Testing",padding: EdgeInsets.zero,)
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: isPlaying
                    ? SingleChildScrollView(child: _buildUI())
                    : Container(
                        decoration: BoxDecoration(
                            color:  Colors. white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(  30)),


                        child: Padding(
                          padding: EdgeInsets.only(left:   10),
                          child: TextFormField(
                            controller: textEditingController,
                            textInputAction: TextInputAction.next,
                            maxLines: null,
                            style: TextStyle(
                                color: Colors. white, fontSize:   20),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors. white54),
                              border: InputBorder.none,
                              hintText: 'Write Here',
                            ),
                          ),
                        )),
              ),
            ),
            SizedBox(height:   20),
            if (isExp)
              Container(
                padding: EdgeInsets.all(  10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(  20),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors. black.withOpacity(0.1),
                        Colors.transparent,
                        Colors. black.withOpacity(0.1),
                      ]),
                ),
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        valueIndicatorTextStyle: TextStyle(
                          fontSize:   13,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _speakerSelector(),
                          Row(
                            children: [
                              Text(
                                "Pitch: ${pitch.toStringAsFixed(2)}",
                                style: TextStyle(
                                    color: Colors. black,
                                    fontSize:   20,
                                    fontWeight: FontWeight.w500),
                              ),
                              Expanded(
                                child: Slider(
                                  value: pitch,
                                  min: 0.0, // Adjusted minimum value
                                  max: 1.0,
                                  onChanged: (value) {
                                    setState(() {
                                      pitch = value;
                                      _flutterTts.setPitch(pitch);
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
                                style: TextStyle(
                                    color: Colors. black,
                                    fontSize:   20,
                                    fontWeight: FontWeight.w500),
                              ),
                              Expanded(
                                child: Slider(
                                  value: speechRate,
                                  min: 0.0, // Adjusted minimum value
                                  max: 1.0,
                                  onChanged: (value) {
                                    setState(() {
                                      speechRate = value;
                                      _flutterTts.setSpeechRate(speechRate);
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
                          style: TextStyle(
                              color: Colors. black,
                              fontSize:   20,
                              fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: Center(
                            child: Container(
                              height:   40,
                              decoration: BoxDecoration(
                                  color: Colors. black87,
                                  borderRadius:
                                      BorderRadius.circular(  20)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:   8.0),
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
                        style: TextStyle(
                            fontSize:   16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height:   20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                  ),
                  onPressed: () {
                    setState(() {
                      isExp = !isExp;
                    });
                  },
                  child: Text(
                    "Audio Settings",
                    style: TextStyle(
                        fontSize:   16, fontWeight: FontWeight.bold),
                  ),
                ),

              ],
            ),
            SizedBox(height:   20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if(!isPlaying){
            _flutterTts.speak(textEditingController.text);
            saveSettings();
            setState(() {
              isPlaying=true;
            });
          }else{
            _flutterTts.pause();
            setState(() {
              isPlaying=false;
            });
          }


        },
        child:  Icon(
          isPlaying?Icons.pause:Icons.play_arrow,
        ),
      ),
    );
  }
  Widget _buildUI() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 20,
                color: Colors.white,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: textEditingController.text.substring(0, _currentWordStart),
                ),
                if (_currentWordStart != null)
                  TextSpan(
                    text: textEditingController.text.substring(
                        _currentWordStart!, _currentWordEnd),
                    style:  TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.greenAccent.withOpacity(0.5),
                    ),
                  ),
                if (_currentWordEnd != null)
                  TextSpan(
                    text: textEditingController.text.substring(_currentWordEnd!),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _speakerSelector() {
    return DropdownButton(
      value: _currentVoice,
      items: _voices
          .map(
            (_voice) => DropdownMenuItem(
          value: _voice,
          child: Text(
            _voice["name"],
          ),
        ),
      )
          .toList(),
      onChanged: (value) {},
    );
  }
}

// class ImageScreen extends StatefulWidget {
//   final String branch;
//
//
//   ImageScreen({required this.branch,  });
//
//   @override
//   _ImageScreenState createState() => _ImageScreenState();
// }
//
// class _ImageScreenState extends State<ImageScreen> {
//   late final RewardedAd rewardedAd;
//
//
//   bool isAdLoaded = false;
//
//   void _loadRewardedAd() {
//     RewardedAd.load(
//       adUnitId: AdVideo.bannerAdUnitId,
//       request: const AdRequest(),
//       rewardedAdLoadCallback: RewardedAdLoadCallback(
//         onAdFailedToLoad: (LoadAdError error) {
//           print("Failed to load rewarded ad, Error: $error");
//         },
//         onAdLoaded: (RewardedAd ad) {
//           print("$ad loaded");
//           showToastText("Add loaded");
//           rewardedAd = ad;
//           setState(() {
//             isAdLoaded = true;
//           });
//           //set on full screen content call back
//           _setFullScreenContentCallback();
//         },
//       ),
//     );
//   }
//
//   //method to set show content call back
//   void _setFullScreenContentCallback() {
//     rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
//       //when ad  shows fullscreen
//       onAdShowedFullScreenContent: (RewardedAd ad) =>
//           print("$ad onAdShowedFullScreenContent"),
//       //when ad dismissed by user
//       onAdDismissedFullScreenContent: (RewardedAd ad) {
//         print("$ad onAdDismissedFullScreenContent");
//
//         //dispose the dismissed ad
//         ad.dispose();
//       },
//       //when ad fails to show
//       onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
//         print("$ad  onAdFailedToShowFullScreenContent: $error ");
//         //dispose the failed ad
//         ad.dispose();
//       },
//
//       //when impression is detected
//       onAdImpression: (RewardedAd ad) => print("$ad Impression occured"),
//     );
//   }
//
//   Future<void> _showRewardedAd() async {
//     rewardedAd.show(
//         onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
//       num amount = rewardItem.amount;
//       showToastText("You earned: $amount");
//
//     });
//     final imageRef = _firestore.collection("user").doc(fullUserId());
//
//     final documentSnapshot = await imageRef.get();
//     if (documentSnapshot.exists) {
//       final data = documentSnapshot.data() as Map<String, dynamic>;
//       if (data['adSeenCount']==null) {
//         _firestore.collection("user").doc(fullUserId()).update({"adSeenCount":0});
//       } else {
//         _firestore.collection("user").doc(fullUserId()).update({"adSeenCount":data['adSeenCount']+1});
//
//       }
//     }
//   }
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   bool _canOpenImage = true;
//   double remainingTime = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkImageOpenStatus();
//     _loadRewardedAd();
//   }
//
//   Future<void> _checkImageOpenStatus() async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       final imageRef = _firestore.collection("user").doc(fullUserId());
//
//       final documentSnapshot = await imageRef.get();
//       if (documentSnapshot.exists) {
//         final data = documentSnapshot.data() as Map<String, dynamic>;
//         if (data['lastOpenAdTime'].toString().isEmpty) {
//           setState(() {
//             _canOpenImage = true; // 3600 seconds = 1 hour
//           });
//         } else {
//           final lastOpenTime = data['lastOpenAdTime'] as Timestamp;
//
//           final currentTime = Timestamp.now();
//           final difference = currentTime.seconds - lastOpenTime.seconds;
//
//           setState(() {
//             _canOpenImage = difference >= 3600; // 3600 seconds = 1 hour
//             remainingTime = (3600 - difference) / 60;
//           });
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:  EdgeInsets.all( 15.0),
//       child: Container(
//         decoration: BoxDecoration(
//             color: Colors.black,
//             borderRadius: BorderRadius.circular( 10),
//             border: Border.all(color: Colors. black54)),
//         child: Padding(
//           padding:  EdgeInsets.symmetric(vertical:  5, horizontal:  10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Support Us",
//                     style: TextStyle(color: Colors. white, fontSize:  20),
//                   ),
//                 ],
//               ),
//               _canOpenImage
//                   ? isAdLoaded
//                   ? InkWell(
//                 onTap: () async {
//                   if (_canOpenImage) {
//                     _showRewardedAd();
//
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => supportList(
//                               branch: widget.branch,
//                             )));
//                     final user = _auth.currentUser;
//                     if (user != null) {
//                       final imageRef = _firestore
//                           .collection('user')
//                           .doc(fullUserId());
//                       await imageRef.update({
//                         'lastOpenAdTime':
//                         FieldValue.serverTimestamp(),
//                       });
//                     }
//                     setState(() {
//                       _canOpenImage = false;
//                     });
//                   }
//                 },
//                 child: Container(
//                     decoration: BoxDecoration(
//                         color: Colors.lightGreenAccent,
//                         borderRadius: BorderRadius.circular( 10)
//                     ),
//                     child: Padding(
//                       padding:  EdgeInsets.symmetric(vertical:  3,horizontal:  10),
//                       child: Text('Join',style: TextStyle(color: Colors.black,fontSize:  20,fontWeight: FontWeight.w500),),
//                     )),
//               )
//                   : Text(
//                 'Wait for few secs',
//                 style: TextStyle(fontSize:  18, color: Colors.amber),
//               )
//                   : Text(
//                 'Wait for ${remainingTime.round()} mins',
//                 style: TextStyle(fontSize:  18, color: Colors.amber),
//               ),
//               if (!_canOpenImage)
//                 InkWell(
//                   child: Icon(
//                     Icons.refresh,
//                     color: Colors. black,
//                     size:  35,
//                   ),
//                   onTap: () {
//                     _checkImageOpenStatus();
//                   },
//                 )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          backButton(
            ),
          !commentsIds.contains(fullUserId())
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      vertical:   8, horizontal:   20),
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors. black38,
                              borderRadius: BorderRadius.circular(  20)),
                          child: Padding(
                            padding: EdgeInsets.only(left:   10),
                            child: TextFormField(
                              controller: _comment,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(
                                  color: Colors. black, fontSize:   25),
                              maxLines: null,
                              // Allows the field to expand as needed
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                  color: Colors. black87,
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
                          padding: EdgeInsets.all(  5.0),
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
                      fontSize:   30,
                      fontWeight: FontWeight.w700),
                ),
          Padding(
            padding: EdgeInsets.all(  5.0),
            child: Text(
              "Note : You can send message only for one time",
              style: TextStyle(color: Colors.amber, fontSize:   15),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(vertical:   10, horizontal:   5),
            child: Text(
              "Thanks for being a member :)",
              style: TextStyle(
                  color: Colors. black,
                  fontSize:   25,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            height:   3,
            width:   150,
            decoration: BoxDecoration(
              color: Colors. black54,
              borderRadius: BorderRadius.circular(  5),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical:   10, horizontal:   5),
              child: ListView.builder(
                shrinkWrap: true,
                reverse: false,
                padding: EdgeInsets.symmetric(horizontal:   10),
                itemCount: comments.length,
                itemBuilder: (BuildContext context, int index) {
                  String data = comments[index];
                  String user = data.split(";").first;
                  String comment = data.split(";").last;
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical:   5),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(  30),
                              border: Border.all(color: Colors. black54)),
                          child: Padding(
                            padding: EdgeInsets.all(  3.0),
                            child: Text(
                              user.split(":").first,
                              style: TextStyle(
                                  color: Colors. black, fontSize:   20),
                            ),
                          ),
                        ),
                        SizedBox(
                          width:   10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "@${user.split(":").last}",
                              style: TextStyle(
                                  color: Colors. black54, fontSize:   13),
                            ),
                            Text(
                              comment,
                              style: TextStyle(
                                  color: Colors. black, fontSize:   20),
                            ),
                          ],
                        ),
                        Spacer(),
                        if (isOwner())
                          InkWell(
                            child: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                              size:   30,
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
                  color: Colors. black54,
                  fontWeight: FontWeight.w500,
                  fontSize:   13),
            ),
          ),
        ],
      ),
    ));
  }
}
 openFile(String filePath,String name) async {
  showToastText("Loading...");

    if ( File(filePath).existsSync()) {


      Directory tempDir = await getTemporaryDirectory();
      String fileNameWithoutExtension = path.basenameWithoutExtension(filePath);
      String newFilePath = path.join(tempDir.path, '$fileNameWithoutExtension.${name.split(".").last}');
      await File(filePath).copy(newFilePath);
      if (await File(newFilePath).exists()) {
        await OpenFilex.open(newFilePath);
      } else {
        showToastText('Failed to create temporary file');
      }
    } else {
      showToastText('File does not exist');
    }

}