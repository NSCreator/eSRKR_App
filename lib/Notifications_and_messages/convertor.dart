import 'package:flutter/material.dart';
import 'package:srkr_study_app/settings/settings.dart';
import 'package:srkr_study_app/notification.dart';

import '../TextField.dart';
import '../functions.dart';

class FlashNewsCreator extends StatefulWidget {
  String NewsId;
  String heading;
  String branch;
  String link;

  FlashNewsCreator({
    this.NewsId = "",
    this.link = '',
    this.heading = "",
    required this.branch,
  });

  @override
  State<FlashNewsCreator> createState() => _FlashNewsCreatorState();
}

class _FlashNewsCreatorState extends State<FlashNewsCreator> {
  final HeadingController = TextEditingController();

  final LinkController = TextEditingController();

  void AutoFill() async {
    HeadingController.text = widget.heading;
    LinkController.text = widget.link;
  }

  @override
  void initState() {
    AutoFill();
    super.initState();
  }

  @override
  void dispose() {
    HeadingController.dispose();
    LinkController.dispose();
    super.dispose();
  }

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
                  heading: "Heading",
                  child: Padding(
                    padding: EdgeInsets.only(left:   10),
                    child: TextFormField(
                      controller: HeadingController,
                      textInputAction: TextInputAction.next,
                      maxLines: null,
                      style: TextStyle(
                          color: Colors. black, fontSize:   20),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors. black54),
                        border: InputBorder.none,
                        hintText: 'Heading',
                      ),
                    ),
                  )),
              TextFieldContainer(
                  heading: "Link",
                  child: Padding(
                    padding: EdgeInsets.only(left:   10),
                    child: TextFormField(
                      //obscureText: true,
                      controller: LinkController,
                      textInputAction: TextInputAction.next,
                      maxLines: null,
                      style: TextStyle(
                          color: Colors. black, fontSize:   20),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'if any link',
                          hintStyle: TextStyle(color: Colors. black54)),
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      if (widget.NewsId.length > 3) {
                        // UpdateBranchNew(heading: HeadingController.text.trim(), description: DescriptionController.text.trim(), Date: getTime(), photoUrl: PhotoUrlController.text.trim(),id: widget.NewsId);
                        firestore
                            .collection("srkrPage")
                            .doc("flashNews")
                            .collection("flashNews")
                            .doc(widget.NewsId)
                            .update({
                          "heading": HeadingController.text.trim(),
                          "link": LinkController.text.trim(),
                        });

                        messageToOwner(
                            "flash News is Updated\nBy '${fullUserId()}' \n  Heading : ${HeadingController.text.trim()}\n  Link: ${LinkController.text.trim()}\n **${widget.branch}");
                      } else {
                        String id = getID();
                        firestore
                            .collection("srkrPage")
                            .doc("flashNews")
                            .collection("flashNews")
                            .doc(id)
                            .set({
                          "id": id,
                          "heading": HeadingController.text.trim(),
                          "link": LinkController.text.trim(),
                        });
                        // SendMessage("flashNews;$id",HeadingController.text.trim(),"None");
                        messageToOwner(
                            "flash News is Created\nBy '${fullUserId()}' \n  Heading : ${HeadingController.text.trim()}\n  Link: ${LinkController.text.trim()}\n **${widget.branch}");
                      }

                      HeadingController.clear();
                      LinkController.clear();

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
      ),
    );
  }
}
