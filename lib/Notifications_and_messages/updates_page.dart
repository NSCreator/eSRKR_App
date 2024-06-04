
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:srkr_study_app/Notifications_and_messages/updates_creator.dart';
import 'package:srkr_study_app/homePage/HomePage.dart';
import 'package:srkr_study_app/settings/settings.dart';

import '../functions.dart';
import '../notification.dart';
import '../uploader.dart';

class updatesPage extends StatefulWidget {
  final String branch;

  const updatesPage({
    Key? key,
    required this.branch,
  }) : super(key: key);

  @override
  State<updatesPage> createState() => _updatesPageState();
}

class _updatesPageState extends State<updatesPage> {
  bool isBranch = false;
  String folderPath = '';

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}';
    });
  }

  @override
  void initState() {
    setState(() {
      getPath();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              backButton(),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<List<UpdateConvertor>>(
                  stream: readUpdate(widget.branch),
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
                          if (BranchNews!.length == 0) {
                            return Center(
                                child: Text(
                                  "No Updates",
                                  style: TextStyle(color: Colors.lightBlueAccent),
                                ));
                          } else
                            return ListView.builder(
                              padding: EdgeInsets.only(
                                  left: 10, top: 10, bottom: 20, right: 8),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: BranchNews.length,
                              itemBuilder: (context, int index) {
                                final BranchNew = BranchNews[index];

                                return InkWell(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        if (BranchNew.link.isEmpty &&
                                            BranchNew.photoUrl.isNotEmpty)
                                          Padding(
                                            padding: EdgeInsets.all(3.0),
                                            child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(15),
                                                child: ImageShowAndDownload(
                                                  token: sub_esrkr,
                                                  image: BranchNew.photoUrl,
                                                  isZoom: true,
                                                )),
                                          ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                    vertical: 3),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    if (BranchNew
                                                        .heading.isNotEmpty)
                                                      Text(
                                                        BranchNew.heading,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    if (BranchNew
                                                        .description.isNotEmpty)
                                                      Text(
                                                        " ${BranchNew.description}",
                                                        style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(0.8),
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (BranchNew.link.isNotEmpty &&
                                                BranchNew.photoUrl.isNotEmpty)
                                              SizedBox(
                                                height: 100,
                                                width: 140,
                                                child: Padding(
                                                  padding: EdgeInsets.all(3.0),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          15),
                                                      child:
                                                      ImageShowAndDownload(
                                                        token: sub_esrkr,
                                                        image:
                                                        BranchNew.photoUrl,
                                                        isZoom: true,
                                                      )),
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(
                                            height: 2,
                                            child: Divider(
                                              color: Colors.black26,
                                            )),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 2),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${calculateTimeDifference(BranchNew.id)}  ",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black87),
                                                  ),
                                                  Icon(
                                                    Icons.circle,
                                                    color: Colors.black,
                                                    size: 3,
                                                  ),
                                                  Text(
                                                    "  ${BranchNew.creator.split("@").first}",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black87),
                                                  ),
                                                ],
                                              ),
                                              if (isGmail() || isOwner())
                                                SizedBox(
                                                  height: 18,
                                                  child: PopupMenuButton(
                                                    padding: EdgeInsets.all(0),
                                                    icon: Icon(
                                                      Icons.more_horiz,
                                                      color: Colors.black,
                                                      size: 18,
                                                    ),
                                                    // Callback that sets the selected popup menu item.
                                                    onSelected: (item) async {
                                                      if (item == "edit") {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                    updateCreator(
                                                                      NewsId:
                                                                      BranchNew.id,
                                                                      link:
                                                                      BranchNew.link,
                                                                      heading:
                                                                      BranchNew.heading,
                                                                      photoUrl:
                                                                      BranchNew.photoUrl,
                                                                      subMessage:
                                                                      BranchNew.description,
                                                                      branch:
                                                                      widget.branch,
                                                                    )));
                                                      } else if (item ==
                                                          "delete") {
                                                        firestore
                                                            .collection(
                                                            "update")
                                                            .doc(BranchNew.id)
                                                            .delete();
                                                        messageToOwner(
                                                            "Update is Deleted\nBy '${fullUserId()}\n    Heading : ${BranchNew.heading}\n    Description : ${BranchNew.description}    \nImage : ${BranchNew.photoUrl}    \nLink : ${BranchNew.link}\n **${widget.branch}");
                                                      }
                                                    },
                                                    itemBuilder: (BuildContext
                                                    context) =>
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
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    ExternalLaunchUrl(BranchNew.link);
                                  },
                                );
                              },
                            );
                        }
                    }
                  }),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
