import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:srkr_study_app/homePage/settings.dart';
import 'package:youtube/youtube_thumbnail.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:async';
import 'homePage/CreatingPage.dart';
import 'homePage/HomePage.dart';
import 'TextField.dart';
import 'auth_page.dart';
import 'functions.dart';
import 'homePage/UpdatesAndNotification.dart';
import 'notification.dart';


GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> backgroundHandler(RemoteMessage message) async {
  await _handleMessageData(message);
}

Future<void> _handleMessageData(RemoteMessage message) async {
  NotificationService().showNotification(
      title: message.notification!.title, body: message.notification!.body);
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().initNotification();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  // MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}


class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleMessageData(message);
      }
    });

    FirebaseMessaging.onMessage.listen((message) async {
      if (message.notification != null) {
        _handleMessageData(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessageData(message);
    });
  }

  @override
  void dispose() {
    super.dispose();
    FirebaseAuth.instance
        .authStateChanges()
        .where((user) => user?.emailVerified == true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'eSRKR',
      theme: ThemeData(
        useMaterial3: true,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,

        scaffoldBackgroundColor: Colors.black,
      ),
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(0.85),
            ),
            child: child!);
      },
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("user")
                      .doc(fullUserId())
                      .snapshots(),
                  builder: (context, mainsnapshot) {
                    switch (mainsnapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(
                            child: CircularProgressIndicator(
                          strokeWidth: 0.3,
                          color: Colors.cyan,
                        ));
                      default:
                        {

                          return bottomBarSelection(
                              branch: mainsnapshot.data!["branch"].toString(),
                              reg: mainsnapshot.data!['reg'].toString(),
                              name: mainsnapshot.data!['name'].toString());
                        }
                    }
                  });
            } else {
              return Scaffold(body: LoginPage());
            }
          }),
      debugShowCheckedModeBanner: false,
    );
  }
}

class bottomBarSelection extends StatefulWidget {
  String reg, branch, name;
  bottomBarSelection(
      {required this.branch, required this.reg, required this.name});

  @override
  State<bottomBarSelection> createState() => _bottomBarSelectionState();
}

class _bottomBarSelectionState extends State<bottomBarSelection> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return Container(
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
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: SafeArea(child: _buildPage(_currentIndex)),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            // Adjust blur intensity

            child: Container(
              height:Size* 85,

              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.black.withOpacity(0.2),
                      Colors.black,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20)),
              child: BottomNavigationBar(
                // elevation:16,
                currentIndex: _currentIndex,
                onTap: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },

                backgroundColor: Colors.transparent,
                type: BottomNavigationBarType.fixed,
                // showSelectedLabels: false,

                showUnselectedLabels: false,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.circle,
                      color: Colors.white,
                      size: 8,
                    ),
                    label: 'Home',
                    backgroundColor: Colors.red,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.shop,
                      color: Colors.white,
                      size: 17,
                    ),
                    label: 'Events',
                    backgroundColor: Colors.red,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      isGmail() || isOwner() ? Icons.add : Icons.extension,
                      color: Colors.white,
                      size: 22,
                    ),
                    label: isGmail() || isOwner() ? 'Add' : 'More',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.newspaper,
                      color: Colors.white,
                      size: 17,
                    ),
                    label: 'Updates',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 17,
                    ),
                    label: 'You',
                  ),
                ],
                selectedItemColor: Colors.white,
                // onTap:
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    double Size = size(context);

    switch (_currentIndex) {
      case 0:
        return HomePage(
          branch: widget.branch,
          size: Size, name: widget.name, reg: widget.reg
        ); // Replace with your actual HomePage widget
      case 1:
        return eventsPage(
          branch: widget.branch,
          size: Size,
        );
      case 2:
        return CreatePage(
          size: Size,
          branch: widget.branch,
          reg: widget.reg,
        );
      case 3:
        return newsUpadates(
          branch: widget.branch,
          size: Size,
        );
      case 4:
        return settings(
          name: widget.name,
          branch: widget.branch,
          reg: widget.reg,
          size: Size,
        );
      default:
        return Container();
    }
  }
}



Stream<List<eventsConvertor>> readevents(String branch) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("events")
        .collection("events")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => eventsConvertor.fromJson(doc.data()))
            .toList());

Future createevents({
      required String id,
    required String heading,
    required String description,
    required String videoUrl,
    required String created,
    required String branch,
    required String photoUrl}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc("events")
      .collection("events")
      .doc(id);
  final flash = eventsConvertor(
    id: id,
    heading: heading,
    photoUrl: photoUrl,
    description: description,
    created: created,
    videoUrl: videoUrl,
  );
  final json = flash.toJson();
  await docflash.set(json);
}

class eventsConvertor {
  String id;
  final String heading, photoUrl, description, videoUrl, created;

  eventsConvertor({
    this.id = "",
    required this.heading,
    required this.photoUrl,
    required this.description,
    required this.videoUrl,
    required this.created,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "image": photoUrl,
        "videoUrl": videoUrl,
        "description": description,
        "created": created,
      };

  static eventsConvertor fromJson(Map<String, dynamic> json) => eventsConvertor(
        id: json['id'],
        heading: json["heading"],
        photoUrl: json["image"],
        videoUrl: json["videoUrl"],
        created: json["created"],
        description: json["description"],
      );
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

class eventsPage extends StatefulWidget {
  final String branch;
  final double size;

  const eventsPage({
    Key? key,
    required this.branch,
    required this.size,
  }) : super(key: key);

  @override
  State<eventsPage> createState() => _eventsPageState();
}

class _eventsPageState extends State<eventsPage> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  String folderPath = "";

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
    });
  }

  @override
  void initState() {
    getPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.all(widget.size*10.0),
            child: Text("${widget.branch} Events",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.size * 25,
                )),
          ),
          StreamBuilder<List<eventsConvertor>>(
              stream: readevents(widget.branch),
              builder: (context, snapshot) {
                final BranchNews = snapshot.data;
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 0.3,
                      color: Colors.cyan,
                    ));
                  default:
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text(
                              'Error with TextBooks Data or\n Check Internet Connection'));
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: widget.size*3),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: BranchNews!.length,
                        itemBuilder: (context, int index) {
                          final BranchNew = BranchNews[index];

                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: widget.size*2, horizontal:widget.size* 3),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(widget.size*15)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Padding(
                                        padding: EdgeInsets.only(top:widget.size* 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                     EdgeInsets.all(widget.size*5.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        BranchNew.heading
                                                                .isNotEmpty
                                                            ? "${BranchNew.heading}"
                                                            : "${widget.branch} (SRKR)",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              widget.size * 20,
                                                        )),
                                                    Text(
                                                      BranchNew.id
                                                                  .split("-")
                                                                  .first
                                                                  .length <
                                                              12
                                                          ? "${calculateTimeDifference(BranchNew.id)}"
                                                          : "No Date",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              widget.size * 10,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (isGmail() || isOwner())
                                              SizedBox(
                                                height:widget.size* 40,
                                                width:widget.size* 30,
                                                child: PopupMenuButton(
                                                  icon: Icon(
                                                    Icons.more_vert,
                                                    color: Colors.white,
                                                    size: widget.size * 16,
                                                  ),
                                                  // Callback that sets the selected popup menu item.
                                                  onSelected: (item) async {
                                                    if (item == "edit") {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      addEvent(
                                                                        link: BranchNew
                                                                            .videoUrl,
                                                                        branch:
                                                                            widget.branch,
                                                                        NewsId:
                                                                            BranchNew.id,
                                                                        heading:
                                                                            BranchNew.heading,
                                                                        subMessage:
                                                                            BranchNew.description,
                                                                        photoUrl:
                                                                            BranchNew.photoUrl,
                                                                        size: widget
                                                                            .size,
                                                                      )));
                                                    } else if (item ==
                                                        "delete") {
                                                      if (BranchNew.photoUrl
                                                          .isNotEmpty) {
                                                        final Uri uri =
                                                            Uri.parse(BranchNew
                                                                .photoUrl);
                                                        final String fileName =
                                                            uri.pathSegments
                                                                .last;
                                                        final Reference ref =
                                                            storage.ref().child(
                                                                "/${fileName}");
                                                        try {
                                                          await ref.delete();
                                                          showToastText(
                                                              'Image deleted successfully');
                                                        } catch (e) {
                                                          showToastText(
                                                              'Error deleting image: $e');
                                                        }
                                                      }
                                                      messageToOwner(
                                                          "Branch News Updated.\nBy : '${fullUserId()}' \n    Heading : ${BranchNew.heading}\n    Description : ${BranchNew.description}\n    Image : ${BranchNew.photoUrl}\n **${widget.branch}");

                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              widget.branch)
                                                          .doc("events")
                                                          .collection("events")
                                                          .doc(BranchNew.id)
                                                          .delete();
                                                    }
                                                  },
                                                  itemBuilder:
                                                      (BuildContext context) =>
                                                          <PopupMenuEntry>[
                                                    const PopupMenuItem(
                                                      value: "edit",
                                                      child: Text('Edit'),
                                                    ),
                                                    const PopupMenuItem(
                                                      value: "delete",
                                                      child: Text('Delete'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (BranchNew.videoUrl.isNotEmpty)
                                      Flexible(
                                        flex: 2,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(widget.size*10),
                                          child: AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              youtube(
                                                                  url: BranchNew
                                                                      .videoUrl)));
                                                },
                                                child: AspectRatio(
                                                  aspectRatio: 16 / 9,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white12,
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              YoutubeThumbnail(
                                                                      youtubeId:
                                                                          extractVideoId(
                                                                              BranchNew.videoUrl))
                                                                  .hq()),
                                                          fit: BoxFit.cover,
                                                        )),
                                                    child: Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: InkWell(
                                                          child: Container(
                                                              margin: EdgeInsets
                                                                  .all(widget.size*3),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                      widget.size*3,
                                                                      horizontal:
                                                                      widget.size*5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .black,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        widget.size* 10),
                                                              ),
                                                              child: Text(
                                                                "YouTube",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                    widget.size*16),
                                                              )),
                                                          onTap: () {
                                                            ExternalLaunchUrl(
                                                                BranchNew
                                                                    .videoUrl);
                                                          },
                                                        )),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                                if (BranchNew.photoUrl.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:widget.size* 8, horizontal:widget.size* 3),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(widget.size*15),
                                      child: AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: Container(
                                            color: Colors.black,
                                            child: ImageShowAndDownload(
                                              image: BranchNew.photoUrl,
                                              isZoom: true,
                                            )),
                                      ),
                                    ),
                                  ),
                                if (BranchNew.description.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: widget.size * 8,
                                        right:widget.size* 5,
                                        bottom: widget.size*8),
                                    child: StyledTextWidget(
                                      text: BranchNew.description,
                                      fontSize: widget.size * 16,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                }
              }),
          SizedBox(
            height: widget.size * 100,
          )
        ],
      ),
    );
  }

  String getInitials(String fullName) {
    List<String> words = fullName.split(" ");
    String initials = "";

    for (var word in words) {
      if (word.isNotEmpty) {
        initials += word[0].toLowerCase();
      }
    }

    return initials.toUpperCase();
  }
}

class youtube extends StatefulWidget {
  final url;

  const youtube({Key? key, required this.url}) : super(key: key);

  @override
  State<youtube> createState() => _youtubeState();
}

class _youtubeState extends State<youtube> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    final videoID = YoutubePlayer.convertUrlToId(widget.url);
    _controller = YoutubePlayerController(
        initialVideoId: videoID!,
        flags: const YoutubePlayerFlags(autoPlay: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: () => debugPrint("Ready"),
          bottomActions: [
            CurrentPosition(),
            ProgressBar(
              isExpanded: true,
              colors: const ProgressBarColors(
                  playedColor: Colors.amber, handleColor: Colors.amberAccent),
            ),
            const PlaybackSpeedButton(),
            FullScreenButton()
          ],
        ),
      ),
    );
  }
}

String? extractVideoId(String url) {
  // Regular expression pattern to match YouTube video URLs
  RegExp regExp = RegExp(
      r"(?:youtu\.be/|youtube\.com/watch\?v=|youtube\.com/embed/|youtube\.com/v/|youtube\.com/user/[^#]*#p/|youtube\.com/s/|youtube\.com/playlist\?list=)([a-zA-Z0-9_-]+)");

  // Match the URL with the regular expression pattern
  Match match = regExp.firstMatch(url) as Match;

  // If a match is found, extract the video ID from the first capturing group
  return match.group(1);
}
