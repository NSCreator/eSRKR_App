import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:srkr_study_app/settings/settings.dart';

import '../TextField.dart';
import '../functions.dart';
import '../homePage/HomePage.dart';
import '../notification.dart';

class updateCreator extends StatefulWidget {
  bool mode;
  String NewsId;
  String heading;
  String link;
  String photoUrl;
  String subMessage;
  String branch;


  updateCreator(
      {this.NewsId = "",
        this.link = '',
        this.heading = "",
        this.photoUrl = "",
        this.subMessage = "",
        this.mode = false,

        required this.branch});

  @override
  State<updateCreator> createState() => _updateCreatorState();
}

class _updateCreatorState extends State<updateCreator> {
  String Branch = "";
  bool isBranch = false;
  final HeadingController = TextEditingController();
  final DescriptionController = TextEditingController();
  final PhotoUrlController = TextEditingController();
  final LinkController = TextEditingController();
  bool _isImage = false;

  void AutoFill() async {
    HeadingController.text = widget.heading;
    PhotoUrlController.text = widget.photoUrl;
    DescriptionController.text = widget.subMessage;
    LinkController.text = widget.link;
    if (widget.photoUrl.length > 3) {
      setState(() {
        _isImage = true;
      });
    }
  }

  @override
  void initState() {
    AutoFill();
    super.initState();
  }

  @override
  void dispose() {
    HeadingController.dispose();
    PhotoUrlController.dispose();
    LinkController.dispose();
    super.dispose();
  }

  bool isSwitched = false;

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
                TextFieldContainer(
                  child: TextFormField(
                    controller: HeadingController,
                    textInputAction: TextInputAction.next,
                    style:
                    TextStyle(color: Colors. black, fontSize:   20),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Heading',
                        hintStyle: TextStyle(color: Colors. black54)),
                  ),
                  heading: "Heading",
                ),
                TextFieldContainer(
                  child: TextFormField(
                    controller: DescriptionController,
                    textInputAction: TextInputAction.next,
                    style:
                    TextStyle(color: Colors. black, fontSize:   20),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Description',
                        hintStyle: TextStyle(color: Colors. black54)),
                  ),
                  heading: "Description",
                ),
                TextFieldContainer(
                  child: TextFormField(
                    controller: LinkController,
                    textInputAction: TextInputAction.next,
                    style:
                    TextStyle(color: Colors. black, fontSize:   20),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Url',
                        hintStyle: TextStyle(color: Colors. black54)),
                  ),
                  heading: "Url",
                ),
                if (_isImage == true)
                  Padding(
                    padding: EdgeInsets.only(
                        left:   10, top:   20),
                    child: Row(
                      children: [
                        Container(
                            height:   110,
                            width:   180,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius:
                                BorderRadius.circular(  14),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        PhotoUrlController.text.trim()),
                                    fit: BoxFit.fill))),
                        InkWell(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left:   30,
                                top:   10,
                                bottom:   10,
                                right:   10),
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                  fontSize:   30,
                                  color: CupertinoColors.destructiveRed),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_isImage == false)
                  InkWell(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left:   15,
                          top:   20,
                          bottom:   10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.upload,
                            size:   35,
                            color: Colors. black,
                          ),
                          SizedBox(
                            width:   5,
                          ),
                          Text(
                            "Upload Photo",
                            style: TextStyle(
                                fontSize:   30, color: Colors. black),
                          ),
                        ],
                      ),
                    ),

                  ),
                if (widget.NewsId.length < 3)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text(
                              "This is news for the whole college and branch.",
                              style: TextStyle(color: Colors. black, fontSize: 20),
                            )),
                        Expanded(
                          child: Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[500],
                          borderRadius: BorderRadius.circular(  15),
                          border: Border.all(color: Colors. black),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left:   10,
                              right:   10,
                              top:   5,
                              bottom:   5),
                          child: Text("Back..."),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (isSwitched || widget.mode) {
                          if (widget.NewsId.length > 3) {
                            // UpdateBranchNew(heading: HeadingController.text.trim(), description: DescriptionController.text.trim(), Date: getTime(), photoUrl: PhotoUrlController.text.trim(),id: widget.NewsId);
                            firestore
                                .collection("update")
                                .doc(widget.NewsId)
                                .update({
                              "heading": HeadingController.text.trim(),
                              "link": LinkController.text.trim(),
                              "image": PhotoUrlController.text,
                              "description": DescriptionController.text
                            });
                            messageToOwner(
                                "Update is Updated\nBy '${fullUserId()}\n    Heading : ${HeadingController.text.trim()}\n    Description : ${DescriptionController.text}    \nImage : ${PhotoUrlController.text}    \nLink : ${LinkController.text.trim()}\n **${widget.branch}");
                          } else {
                            String id = getID();
                            createHomeUpdate(
                                id: id,
                                creator: fullUserId(),
                                description: DescriptionController.text,
                                heading: HeadingController.text,
                                photoUrl: PhotoUrlController.text,
                                link: LinkController.text);
                            messageToOwner(
                                "Update is Created\nBy '${fullUserId()}\n    Heading : ${HeadingController.text.trim()}\n    Description : ${DescriptionController.text}    \nImage : ${PhotoUrlController.text}    \nLink : ${LinkController.text.trim()}\n **${widget.branch}");

                            // SendMessage("Update;$id",MessageController.text.trim(),widget.branch );
                          }
                        }

                        if (widget.NewsId.length > 3) {
                          firestore
                              .collection(widget.branch)
                              .doc("${widget.branch}News")
                              .collection("${widget.branch}News")
                              .doc(widget.NewsId)
                              .update({
                            "heading": HeadingController.text.trim(),
                            "description": DescriptionController.text.trim(),
                            "image": PhotoUrlController.text.trim()
                          });
                          messageToOwner(
                              "Branch News Updated.\nBy : '${fullUserId()}' \n    Heading : ${HeadingController.text.trim()}\n    Description : ${DescriptionController.text.trim()}\n    Image : ${PhotoUrlController.text.trim()}\n **${widget.branch}");
                        } else {
                          String id = getID();
                          createBranchNew(
                              id: id,
                              creator: fullUserId(),
                              description: DescriptionController.text,
                              heading: HeadingController.text,
                              photoUrl: PhotoUrlController.text,
                              link: LinkController.text,
                              branch: widget.branch);
                          messageToOwner(
                              "Branch News Created.\nBy : '${fullUserId()}' \n    Heading : ${HeadingController.text.trim()}\n    Description : ${DescriptionController.text.trim()}\n    Image : ${PhotoUrlController.text.trim()}\n **${widget.branch}");

                          // SendMessage("News;$id",HeadingController.text.trim(),widget.branch );
                        }
                        HeadingController.clear();
                        DescriptionController.clear();
                        PhotoUrlController.clear();
                        Navigator.pop(context);
                      },
                      child: widget.NewsId.length < 3
                          ? Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[500],
                          borderRadius:
                          BorderRadius.circular(  15),
                          border: Border.all(color: Colors. black),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left:   10,
                              right:   10,
                              top:   5,
                              bottom:   5),
                          child: Text("Create"),
                        ),
                      )
                          : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[500],
                          borderRadius:
                          BorderRadius.circular(  15),
                          border: Border.all(color: Colors. black),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left:   10,
                              right:   10,
                              top:   5,
                              bottom:   5),
                          child: Text("Update"),
                        ),
                      ),
                    ),
                    SizedBox(
                      width:   15,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
