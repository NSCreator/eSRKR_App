import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:srkr_study_app/settings/settings.dart';
import 'package:srkr_study_app/uploader.dart';
import 'functions.dart';
import 'notification.dart';
class eventsPage extends StatefulWidget {
  final String branch;


  const eventsPage({
    Key? key,
    required this.branch,

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backButton(),
            Padding(
              padding:  EdgeInsets.all( 10.0),
              child: Text("${widget.branch} Events",
                  style: TextStyle(
                    color: Colors. white,
                    fontSize:   25,
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
                          padding: EdgeInsets.symmetric(horizontal:  3),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: BranchNews!.length,
                          itemBuilder: (context, int index) {
                            final BranchNew = BranchNews[index];
      
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical:  2, horizontal:  3),
                              decoration: BoxDecoration(
                                  color: Colors. black.withOpacity(0.03),
                                  borderRadius: BorderRadius.circular( 15)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: Padding(
                                          padding: EdgeInsets.only(top:  5),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                  EdgeInsets.all( 5.0),
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
                                                            color: Colors. black,
                                                            fontSize:
                                                            20,
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
                                                            color: Colors. black,
                                                            fontSize:
                                                            10,
                                                            fontWeight:
                                                            FontWeight.w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              if (isGmail() || isOwner())
                                                SizedBox(
                                                  height:  40,
                                                  width:  30,
                                                  child: PopupMenuButton(
                                                    icon: Icon(
                                                      Icons.more_vert,
                                                      color: Colors. black,
                                                      size:   16,
                                                    ),
                                                    // Callback that sets the selected popup menu item.
                                                    onSelected: (item) async {
                                                      // if (item == "edit") {
                                                      //   Navigator.push(
                                                      //       context,
                                                      //       MaterialPageRoute(
                                                      //           builder:
                                                      //               (context) =>
                                                      //               addEvent(
                                                      //                 link: BranchNew
                                                      //                     .videoUrl,
                                                      //                 branch:
                                                      //                 widget.branch,
                                                      //                 NewsId:
                                                      //                 BranchNew.id,
                                                      //                 heading:
                                                      //                 BranchNew.heading,
                                                      //                 subMessage:
                                                      //                 BranchNew.description,
                                                      //                 photoUrl:
                                                      //                 BranchNew.photoUrl,
                                                      //
                                                      //               )));
                                                      // } else if (item ==
                                                      //     "delete") {
                                                      //   if (BranchNew.photoUrl
                                                      //       .isNotEmpty) {
                                                      //     final Uri uri =
                                                      //     Uri.parse(BranchNew
                                                      //         .photoUrl);
                                                      //     final String fileName =
                                                      //         uri.pathSegments
                                                      //             .last;
                                                      //     final Reference ref =
                                                      //     storage.ref().child(
                                                      //         "/${fileName}");
                                                      //     try {
                                                      //       await ref.delete();
                                                      //       showToastText(
                                                      //           'Image deleted successfully');
                                                      //     } catch (e) {
                                                      //       showToastText(
                                                      //           'Error deleting image: $e');
                                                      //     }
                                                      //   }
                                                      //   messageToOwner(
                                                      //       "Branch News Updated.\nBy : '${fullUserId()}' \n    Heading : ${BranchNew.heading}\n    Description : ${BranchNew.description}\n    Image : ${BranchNew.photoUrl}\n **${widget.branch}");
                                                      //
                                                      //   FirebaseFirestore.instance
                                                      //       .collection(
                                                      //       widget.branch)
                                                      //       .doc("events")
                                                      //       .collection("events")
                                                      //       .doc(BranchNew.id)
                                                      //       .delete();
                                                      // }
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
                                            BorderRadius.circular( 10),
                                            child: AspectRatio(
                                              aspectRatio: 16 / 9,
                                              child: InkWell(
                                                  onTap: () {
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             youtube(
                                                    //                 url: BranchNew
                                                    //                     .videoUrl)));
                                                  },
                                                  child: AspectRatio(
                                                    aspectRatio: 16 / 9,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors. black12,
                                                          // image: DecorationImage(
                                                          //   image: NetworkImage(
                                                          //       YoutubeThumbnail(
                                                          //           youtubeId:
                                                          //           extractVideoId(
                                                          //               BranchNew.videoUrl))
                                                          //           .hq()),
                                                          //   fit: BoxFit.cover,
                                                          // )
                                                      ),
                                                      child: Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: InkWell(
                                                            child: Container(
                                                                margin: EdgeInsets
                                                                    .all( 3),
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                    3,
                                                                    horizontal:
                                                                    5),
                                                                decoration:
                                                                BoxDecoration(
                                                                  color: Colors
                                                                      .black,
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      10),
                                                                ),
                                                                child: Text(
                                                                  "YouTube",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          . black,
                                                                      fontSize:
                                                                      16),
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
                                          vertical:  8, horizontal:  3),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular( 15),
                                        child: AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: Container(
                                              color: Colors.black,
                                              child: ImageShowAndDownload(
                                                image: BranchNew.photoUrl,
      
                                                isZoom: true, token: sub_esrkr,
                                              )),
                                        ),
                                      ),
                                    ),
                                  if (BranchNew.description.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left:   8,
                                          right:  5,
                                          bottom:  8),
                                      child: StyledTextWidget(
                                        text: BranchNew.description,
                                        fontSize:   16,
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
              height:   100,
            )
          ],
        ),
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
// class youtube extends StatefulWidget {
//   final url;
//
//   const youtube({Key? key, required this.url}) : super(key: key);
//
//   @override
//   State<youtube> createState() => _youtubeState();
// }

// class _youtubeState extends State<youtube> {
//   late YoutubePlayerController _controller;
//
//   @override
//   void initState() {
//     final videoID = YoutubePlayer.convertUrlToId(widget.url);
//     _controller = YoutubePlayerController(
//         initialVideoId: videoID!,
//         flags: const YoutubePlayerFlags(autoPlay: false));
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: YoutubePlayer(
//           controller: _controller,
//           showVideoProgressIndicator: true,
//           onReady: () => debugPrint("Ready"),
//           bottomActions: [
//             CurrentPosition(),
//             ProgressBar(
//               isExpanded: true,
//               colors: const ProgressBarColors(
//                   playedColor: Colors.amber, handleColor: Colors.amberAccent),
//             ),
//             const PlaybackSpeedButton(),
//             FullScreenButton()
//           ],
//         ),
//       ),
//     );
//   }
// }

String? extractVideoId(String url) {
  // Regular expression pattern to match YouTube video URLs
  RegExp regExp = RegExp(
      r"(?:youtu\.be/|youtube\.com/watch\?v=|youtube\.com/embed/|youtube\.com/v/|youtube\.com/user/[^#]*#p/|youtube\.com/s/|youtube\.com/playlist\?list=)([a-zA-Z0-9_-]+)");

  // Match the URL with the regular expression pattern
  Match match = regExp.firstMatch(url) as Match;

  // If a match is found, extract the video ID from the first capturing group
  return match.group(1);
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
