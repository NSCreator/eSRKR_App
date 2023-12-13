// ignore_for_file: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:srkr_study_app/test.dart';
import 'homePage/HomePage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'main.dart';
import 'homePage/settings.dart';
import 'dart:io';
import 'functions.dart';
import 'notification.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class addEvent extends StatefulWidget {
  String NewsId;
  String heading;
  String link;
  String photoUrl;
  String subMessage;
  String branch;
  final double size;

  addEvent(
      {this.NewsId = "",
      this.link = '',
      this.heading = "",
      this.photoUrl = "",
      this.subMessage = "",
      required this.size,
      required this.branch});

  @override
  State<addEvent> createState() => _addEventState();
}

class _addEventState extends State<addEvent> {
  FirebaseStorage storage = FirebaseStorage.instance;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backButton(
                size: widget.size,
                text: "Events Creator",
                child: SizedBox(
                  width: widget.size * 45,
                )),
            TextFieldContainer(
              child: TextFormField(
                controller: HeadingController,
                textInputAction: TextInputAction.next,
                style:
                    TextStyle(color: Colors.white, fontSize: widget.size * 20),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'heading',
                    hintStyle: TextStyle(color: Colors.white54)),
              ),
              heading: "Heading",
            ),
            TextFieldContainer(
              child: TextFormField(
                controller: DescriptionController,
                textInputAction: TextInputAction.next,
                style:
                    TextStyle(color: Colors.white, fontSize: widget.size * 20),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'description',
                    hintStyle: TextStyle(color: Colors.white54)),
              ),
              heading: "Description",
            ),
            TextFieldContainer(
              child: TextFormField(
                controller: LinkController,
                textInputAction: TextInputAction.next,
                style:
                    TextStyle(color: Colors.white, fontSize: widget.size * 20),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'youTube Url',
                    hintStyle: TextStyle(color: Colors.white54)),
              ),
              heading: "YouTube Url",
            ),
            if (_isImage == true)
              Padding(
                padding: EdgeInsets.only(
                    left: widget.size * 10, top: widget.size * 20),
                child: Row(
                  children: [
                    Container(
                        height: widget.size * 110,
                        width: widget.size * 180,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius:
                                BorderRadius.circular(widget.size * 14),
                            image: DecorationImage(
                                image: NetworkImage(
                                    PhotoUrlController.text.trim()),
                                fit: BoxFit.fill))),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: widget.size * 30,
                            top: widget.size * 10,
                            bottom: widget.size * 10,
                            right: widget.size * 10),
                        child: Text(
                          "Delete",
                          style: TextStyle(
                              fontSize: widget.size * 30,
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
                      left: widget.size * 15,
                      top: widget.size * 20,
                      bottom: widget.size * 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.upload,
                        size: widget.size * 35,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: widget.size * 5,
                      ),
                      Text(
                        "Upload Photo",
                        style: TextStyle(
                            fontSize: widget.size * 30, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  File file = File(pickedFile!.path);
                  final Reference ref =
                      storage.ref().child('${widget.branch}/events/${getID()}');
                  final TaskSnapshot task = await ref.putFile(file);
                  final String url = await task.ref.getDownloadURL();
                  PhotoUrlController.text = url;
                  bool _isLoading = false;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: Colors.black.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(widget.size * 20)),
                        elevation: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withOpacity(0.1)),
                            borderRadius:
                                BorderRadius.circular(widget.size * 20),
                          ),
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: <Widget>[
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(widget.size * 8.0),
                                  child: Text(
                                    "Image",
                                    style: TextStyle(
                                        fontSize: widget.size * 22,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.blue),
                                  ),
                                ),
                              ),
                              Stack(
                                children: <Widget>[
                                  Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) {
                                        _isLoading = false;
                                      }
                                      return progress == null
                                          ? child
                                          : Center(
                                              child:
                                                  CircularProgressIndicator());
                                    },
                                  ),
                                  if (_isLoading)
                                    Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                ],
                              ),
                              SizedBox(
                                height: widget.size * 10,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(widget.size * 5.0),
                                      child: Text(
                                        "Cancel & Delete",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: widget.size * 20),
                                      ),
                                    ),
                                    onTap: () async {
                                      final Uri uri = Uri.parse(url);
                                      final String fileName =
                                          uri.pathSegments.last;
                                      final Reference ref =
                                          storage.ref().child("/${fileName}");
                                      try {
                                        await ref.delete();
                                        showToastText(
                                            'Image deleted successfully');
                                      } catch (e) {
                                        showToastText(
                                            'Error deleting image: $e');
                                      }
                                      Navigator.pop(context);
                                    },
                                  ),
                                  SizedBox(
                                    width: widget.size * 20,
                                  ),
                                  InkWell(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(widget.size * 5.0),
                                      child: Text(
                                        "Okay",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: widget.size * 20),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        PhotoUrlController.text = url;
                                        _isImage = true;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
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
                      borderRadius: BorderRadius.circular(widget.size * 15),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: widget.size * 10,
                          right: widget.size * 10,
                          top: widget.size * 5,
                          bottom: widget.size * 5),
                      child: Text("Back..."),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (widget.NewsId.length > 3) {
                      // UpdateBranchNew(heading: HeadingController.text.trim(), description: DescriptionController.text.trim(), Date: getTime(), photoUrl: PhotoUrlController.text.trim(),id: widget.NewsId);
                      FirebaseFirestore.instance
                          .collection(widget.branch)
                          .doc("events")
                          .collection("events")
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
                      createevents(
                        heading: HeadingController.text.trim(),
                        description: DescriptionController.text,
                        videoUrl: LinkController.text.trim(),
                        photoUrl: PhotoUrlController.text.trim(),
                        created: fullUserId(),
                        branch: widget.branch,
                        id: getID(),
                      );
                      messageToOwner(
                          "${widget.branch} event is Created\nBy '${fullUserId()}\n    Heading : ${HeadingController.text.trim()}\n    Description : ${DescriptionController.text}    \nImage : ${PhotoUrlController.text}    \nLink : ${LinkController.text.trim()}\n **${widget.branch}");
                    }

                    HeadingController.clear();
                    LinkController.clear();
                    PhotoUrlController.clear();
                    Navigator.pop(context);
                  },
                  child: widget.NewsId.length < 3
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[500],
                            borderRadius:
                                BorderRadius.circular(widget.size * 15),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: widget.size * 10,
                                right: widget.size * 10,
                                top: widget.size * 5,
                                bottom: widget.size * 5),
                            child: Text("Create"),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[500],
                            borderRadius:
                                BorderRadius.circular(widget.size * 15),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: widget.size * 10,
                                right: widget.size * 10,
                                top: widget.size * 5,
                                bottom: widget.size * 5),
                            child: Text("Update"),
                          ),
                        ),
                ),
                SizedBox(
                  width: widget.size * 15,
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

TextStyle textFieldStyle(double size) {
  return TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: size * 20,
  );
}

TextStyle textFieldHintStyle(double size) {
  return TextStyle(
    color: Colors.white54,
    fontWeight: FontWeight.w300,
    fontSize: size * 18,
  );
}

class TextFieldContainer extends StatefulWidget {
  Widget child;
  String heading;

  TextFieldContainer({required this.child, this.heading = ""});

  @override
  State<TextFieldContainer> createState() => _TextFieldContainerState();
}

class _TextFieldContainerState extends State<TextFieldContainer> {
  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.heading.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: Size * 15, top: Size * 8),
            child: Text(
              widget.heading,
              style: creatorHeadingTextStyle,
            ),
          ),
        Padding(
          padding: EdgeInsets.only(
              left: Size * 10,
              right: Size * 10,
              top: Size * 5,
              bottom: Size * 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              border: Border.all(color: Colors.white12),
              borderRadius: BorderRadius.circular(Size * 15),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: Size * 10),
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}

class flashNewsCreator extends StatefulWidget {
  String NewsId;
  String heading;
  String branch;
  String link;
  final double size;

  flashNewsCreator({
    this.NewsId = "",
    this.link = '',
    this.heading = "",
    required this.size,
    required this.branch,
  });

  @override
  State<flashNewsCreator> createState() => _flashNewsCreatorState();
}

class _flashNewsCreatorState extends State<flashNewsCreator> {
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
              backButton(
                  size: widget.size,
                  text: "Flash News Creator",
                  child: SizedBox(
                    width: widget.size * 45,
                  )),
              TextFieldContainer(
                  heading: "Heading",
                  child: Padding(
                    padding: EdgeInsets.only(left: widget.size * 10),
                    child: TextFormField(
                      controller: HeadingController,
                      textInputAction: TextInputAction.next,
                      maxLines: null,
                      style: TextStyle(
                          color: Colors.white, fontSize: widget.size * 20),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        hintText: 'Heading',
                      ),
                    ),
                  )),
              TextFieldContainer(
                  heading: "Link",
                  child: Padding(
                    padding: EdgeInsets.only(left: widget.size * 10),
                    child: TextFormField(
                      //obscureText: true,
                      controller: LinkController,
                      textInputAction: TextInputAction.next,
                      maxLines: null,
                      style: TextStyle(
                          color: Colors.white, fontSize: widget.size * 20),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'if any link',
                          hintStyle: TextStyle(color: Colors.white54)),
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
                        borderRadius: BorderRadius.circular(widget.size * 15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: widget.size * 10,
                            right: widget.size * 10,
                            top: widget.size * 5,
                            bottom: widget.size * 5),
                        child: Text("Back..."),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (widget.NewsId.length > 3) {
                        // UpdateBranchNew(heading: HeadingController.text.trim(), description: DescriptionController.text.trim(), Date: getTime(), photoUrl: PhotoUrlController.text.trim(),id: widget.NewsId);
                        FirebaseFirestore.instance
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
                        FirebaseFirestore.instance
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
                                  BorderRadius.circular(widget.size * 15),
                              border: Border.all(color: Colors.white),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: widget.size * 10,
                                  right: widget.size * 10,
                                  top: widget.size * 5,
                                  bottom: widget.size * 5),
                              child: Text("Create"),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[500],
                              borderRadius:
                                  BorderRadius.circular(widget.size * 15),
                              border: Border.all(color: Colors.white),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: widget.size * 10,
                                  right: widget.size * 10,
                                  top: widget.size * 5,
                                  bottom: widget.size * 5),
                              child: Text("Update"),
                            ),
                          ),
                  ),
                  SizedBox(
                    width: widget.size * 15,
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

class timeTableSyllabusModalPaperCreator extends StatefulWidget {
  String id;
  String heading;
  String link;
  String mode;
  String reg;
  String branch;
  final double size;

  timeTableSyllabusModalPaperCreator({
    this.id = "",
    this.link = '',
    this.heading = "",
    required this.size,
    required this.mode,
    required this.reg,
    required this.branch,
  });

  @override
  State<timeTableSyllabusModalPaperCreator> createState() =>
      _timeTableSyllabusModalPaperCreatorState();
}

class _timeTableSyllabusModalPaperCreatorState
    extends State<timeTableSyllabusModalPaperCreator> {
  FirebaseStorage storage = FirebaseStorage.instance;

  final HeadingController = TextEditingController();

  final LinkController = TextEditingController();
  final PhotoUrlController = TextEditingController();
  bool _isImage = false;

  void AutoFill() async {
    HeadingController.text = widget.heading;
    if (widget.mode != "Time Table")
      HeadingController.text = widget.reg.substring(0, 10);
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
              backButton(
                  size: widget.size,
                  text: widget.mode,
                  child: SizedBox(
                    width: widget.size * 45,
                  )),
              TextFieldContainer(
                  heading: "Heading",
                  child: Padding(
                    padding: EdgeInsets.only(left: widget.size * 10),
                    child: TextFormField(
                      controller: HeadingController,
                      textInputAction: TextInputAction.next,
                      maxLines: null,
                      style: TextStyle(
                          color: Colors.white, fontSize: widget.size * 20),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        hintText: 'Heading',
                      ),
                    ),
                  )),
              if (widget.mode != "Time Table")
                TextFieldContainer(
                    heading: "Link",
                    child: Padding(
                      padding: EdgeInsets.only(left: widget.size * 10),
                      child: TextFormField(
                        //obscureText: true,
                        controller: LinkController,
                        textInputAction: TextInputAction.next,
                        maxLines: null,
                        style: TextStyle(
                            color: Colors.white, fontSize: widget.size * 20),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Link',
                            hintStyle: TextStyle(color: Colors.white54)),
                      ),
                    )),
              if (_isImage == true && widget.mode == "Time Table")
                Padding(
                  padding: EdgeInsets.only(
                      left: widget.size * 10, top: widget.size * 20),
                  child: Row(
                    children: [
                      Container(
                          height: widget.size * 110,
                          width: widget.size * 180,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius:
                                  BorderRadius.circular(widget.size * 14),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      PhotoUrlController.text.trim()),
                                  fit: BoxFit.fill))),
                      InkWell(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: widget.size * 30,
                              top: widget.size * 10,
                              bottom: widget.size * 10,
                              right: widget.size * 10),
                          child: Text(
                            "Delete",
                            style: TextStyle(
                                fontSize: widget.size * 30,
                                color: CupertinoColors.destructiveRed),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_isImage == false && widget.mode == "Time Table")
                InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: widget.size * 15,
                        top: widget.size * 20,
                        bottom: widget.size * 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.upload,
                          size: widget.size * 35,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: widget.size * 5,
                        ),
                        Text(
                          "Upload Photo",
                          style: TextStyle(
                              fontSize: widget.size * 30, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    File file = File(pickedFile!.path);
                    final Reference ref =
                        storage.ref().child('timetable/${getID()}');
                    final TaskSnapshot task = await ref.putFile(file);
                    final String url = await task.ref.getDownloadURL();
                    PhotoUrlController.text = url;
                    bool _isLoading = false;
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.black.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(widget.size * 20)),
                          elevation: 16,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.1)),
                              borderRadius:
                                  BorderRadius.circular(widget.size * 20),
                            ),
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              children: <Widget>[
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(widget.size * 8.0),
                                    child: Text(
                                      "Image",
                                      style: TextStyle(
                                          fontSize: widget.size * 22,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.blue),
                                    ),
                                  ),
                                ),
                                Stack(
                                  children: <Widget>[
                                    Image.network(
                                      url,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, progress) {
                                        if (progress == null) {
                                          _isLoading = false;
                                        }
                                        return progress == null
                                            ? child
                                            : Center(
                                                child:
                                                    CircularProgressIndicator());
                                      },
                                    ),
                                    if (_isLoading)
                                      Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                  ],
                                ),
                                SizedBox(
                                  height: widget.size * 10,
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(widget.size * 5.0),
                                        child: Text(
                                          "Cancel & Delete",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: widget.size * 20),
                                        ),
                                      ),
                                      onTap: () async {
                                        final Uri uri = Uri.parse(url);
                                        final String fileName =
                                            uri.pathSegments.last;
                                        final Reference ref =
                                            storage.ref().child("/${fileName}");
                                        try {
                                          await ref.delete();
                                          showToastText(
                                              'Image deleted successfully');
                                        } catch (e) {
                                          showToastText(
                                              'Error deleting image: $e');
                                        }
                                        Navigator.pop(context);
                                      },
                                    ),
                                    SizedBox(
                                      width: widget.size * 20,
                                    ),
                                    InkWell(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(widget.size * 5.0),
                                        child: Text(
                                          "Okay",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: widget.size * 20),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          PhotoUrlController.text = url;
                                          _isImage = true;
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
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
                        borderRadius: BorderRadius.circular(widget.size * 15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: widget.size * 10,
                            right: widget.size * 10,
                            top: widget.size * 5,
                            bottom: widget.size * 5),
                        child: Text("Back..."),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (widget.mode == "Time Table") {
                        if (widget.id.length > 3) {
                          FirebaseFirestore.instance
                              .collection(widget.branch)
                              .doc("regulation")
                              .collection("regulationWithSem")
                              .doc(widget.reg)
                              .collection("timeTables")
                              .doc(widget.id)
                              .update({
                            "heading": HeadingController.text.trim(),
                            "image": PhotoUrlController.text.trim()
                          });
                        } else {
                          createTimeTable(
                              branch: widget.branch,
                              heading: HeadingController.text.trim(),
                              photoUrl: PhotoUrlController.text.trim(),
                              reg: widget.reg);
                        }
                      } else {
                        if (widget.id.length > 3) {
                          if (widget.mode == "mp") {
                            FirebaseFirestore.instance
                                .collection(widget.branch)
                                .doc("regulation")
                                .collection("regulationWithYears")
                                .doc(widget.id.substring(0, 10))
                                .update({
                              "modelPaper": LinkController.text.trim(),
                            });
                          } else {
                            FirebaseFirestore.instance
                                .collection(widget.branch)
                                .doc("regulation")
                                .collection("regulationWithYears")
                                .doc(widget.id.substring(0, 10))
                                .update({
                              "syllabus": LinkController.text.trim(),
                            });
                          }
                        }
                      }

                      HeadingController.clear();
                      LinkController.clear();

                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: widget.id.length < 3
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[500],
                              borderRadius:
                                  BorderRadius.circular(widget.size * 15),
                              border: Border.all(color: Colors.white),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: widget.size * 10,
                                  right: widget.size * 10,
                                  top: widget.size * 5,
                                  bottom: widget.size * 5),
                              child: Text("Create"),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[500],
                              borderRadius:
                                  BorderRadius.circular(widget.size * 15),
                              border: Border.all(color: Colors.white),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: widget.size * 10,
                                  right: widget.size * 10,
                                  top: widget.size * 5,
                                  bottom: widget.size * 5),
                              child: Text("Update"),
                            ),
                          ),
                  ),
                  SizedBox(
                    width: widget.size * 15,
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

class updateCreator extends StatefulWidget {
  bool mode;
  String NewsId;
  String heading;
  String link;
  String photoUrl;
  String subMessage;
  String branch;
  final double size;

  updateCreator(
      {this.NewsId = "",
      this.link = '',
      this.heading = "",
      this.photoUrl = "",
      this.subMessage = "",
      this.mode = false,
      required this.size,
      required this.branch});

  @override
  State<updateCreator> createState() => _updateCreatorState();
}

class _updateCreatorState extends State<updateCreator> {
  FirebaseStorage storage = FirebaseStorage.instance;
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
            backButton(
                size: widget.size,
                text: "Updater",
                child: SizedBox(
                  width: widget.size * 45,
                )),
            TextFieldContainer(
              child: TextFormField(
                controller: HeadingController,
                textInputAction: TextInputAction.next,
                style:
                    TextStyle(color: Colors.white, fontSize: widget.size * 20),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Heading',
                    hintStyle: TextStyle(color: Colors.white54)),
              ),
              heading: "Heading",
            ),
            TextFieldContainer(
              child: TextFormField(
                controller: DescriptionController,
                textInputAction: TextInputAction.next,
                style:
                    TextStyle(color: Colors.white, fontSize: widget.size * 20),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Description',
                    hintStyle: TextStyle(color: Colors.white54)),
              ),
              heading: "Description",
            ),
            TextFieldContainer(
              child: TextFormField(
                controller: LinkController,
                textInputAction: TextInputAction.next,
                style:
                    TextStyle(color: Colors.white, fontSize: widget.size * 20),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Url',
                    hintStyle: TextStyle(color: Colors.white54)),
              ),
              heading: "Url",
            ),
            if (_isImage == true)
              Padding(
                padding: EdgeInsets.only(
                    left: widget.size * 10, top: widget.size * 20),
                child: Row(
                  children: [
                    Container(
                        height: widget.size * 110,
                        width: widget.size * 180,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius:
                                BorderRadius.circular(widget.size * 14),
                            image: DecorationImage(
                                image: NetworkImage(
                                    PhotoUrlController.text.trim()),
                                fit: BoxFit.fill))),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: widget.size * 30,
                            top: widget.size * 10,
                            bottom: widget.size * 10,
                            right: widget.size * 10),
                        child: Text(
                          "Delete",
                          style: TextStyle(
                              fontSize: widget.size * 30,
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
                      left: widget.size * 15,
                      top: widget.size * 20,
                      bottom: widget.size * 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.upload,
                        size: widget.size * 35,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: widget.size * 5,
                      ),
                      Text(
                        "Upload Photo",
                        style: TextStyle(
                            fontSize: widget.size * 30, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  File file = File(pickedFile!.path);
                  final Reference ref =
                      storage.ref().child('update/${getID()}');
                  final TaskSnapshot task = await ref.putFile(file);
                  final String url = await task.ref.getDownloadURL();
                  PhotoUrlController.text = url;
                  bool _isLoading = false;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: Colors.black.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(widget.size * 20)),
                        elevation: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withOpacity(0.1)),
                            borderRadius:
                                BorderRadius.circular(widget.size * 20),
                          ),
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: <Widget>[
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(widget.size * 8.0),
                                  child: Text(
                                    "Image",
                                    style: TextStyle(
                                        fontSize: widget.size * 22,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.blue),
                                  ),
                                ),
                              ),
                              Stack(
                                children: <Widget>[
                                  Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) {
                                        _isLoading = false;
                                      }
                                      return progress == null
                                          ? child
                                          : Center(
                                              child:
                                                  CircularProgressIndicator());
                                    },
                                  ),
                                  if (_isLoading)
                                    Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                ],
                              ),
                              SizedBox(
                                height: widget.size * 10,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(widget.size * 5.0),
                                      child: Text(
                                        "Cancel & Delete",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: widget.size * 20),
                                      ),
                                    ),
                                    onTap: () async {
                                      final Uri uri = Uri.parse(url);
                                      final String fileName =
                                          uri.pathSegments.last;
                                      final Reference ref =
                                          storage.ref().child("/${fileName}");
                                      try {
                                        await ref.delete();
                                        showToastText(
                                            'Image deleted successfully');
                                      } catch (e) {
                                        showToastText(
                                            'Error deleting image: $e');
                                      }
                                      Navigator.pop(context);
                                    },
                                  ),
                                  SizedBox(
                                    width: widget.size * 20,
                                  ),
                                  InkWell(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(widget.size * 5.0),
                                      child: Text(
                                        "Okay",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: widget.size * 20),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        PhotoUrlController.text = url;
                                        _isImage = true;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
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
                          style: TextStyle(color: Colors.white, fontSize: 20),
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
                      borderRadius: BorderRadius.circular(widget.size * 15),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: widget.size * 10,
                          right: widget.size * 10,
                          top: widget.size * 5,
                          bottom: widget.size * 5),
                      child: Text("Back..."),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (isSwitched || widget.mode) {
                      if (widget.NewsId.length > 3) {
                        // UpdateBranchNew(heading: HeadingController.text.trim(), description: DescriptionController.text.trim(), Date: getTime(), photoUrl: PhotoUrlController.text.trim(),id: widget.NewsId);
                        FirebaseFirestore.instance
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
                      FirebaseFirestore.instance
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
                                BorderRadius.circular(widget.size * 15),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: widget.size * 10,
                                right: widget.size * 10,
                                top: widget.size * 5,
                                bottom: widget.size * 5),
                            child: Text("Create"),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[500],
                            borderRadius:
                                BorderRadius.circular(widget.size * 15),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: widget.size * 10,
                                right: widget.size * 10,
                                top: widget.size * 5,
                                bottom: widget.size * 5),
                            child: Text("Update"),
                          ),
                        ),
                ),
                SizedBox(
                  width: widget.size * 15,
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}


class BooksCreator extends StatefulWidget {
  BooksConvertor? data;
  String branch;

  BooksCreator(
      {
        required this.branch,
         this.data,
      });
  @override
  State<BooksCreator> createState() => _BooksCreatorState();
}

class _BooksCreatorState extends State<BooksCreator> {

  final HeadingController = TextEditingController();
  final DescriptionController = TextEditingController();
  final LinkController = TextEditingController();
  final EditionController = TextEditingController();
  final AuthorController = TextEditingController();

  void autoFill() async {
    HeadingController.text = widget.data!.heading;
    DescriptionController.text = widget.data!.description;
    LinkController.text = widget.data!.link;
    EditionController.text = widget.data!.edition;
    AuthorController.text = widget.data!.Author;
  }

  @override
  void initState() {
    super.initState();
    if(widget.data!=null) {
      autoFill();
    }
  }

  @override
  void dispose() {
    HeadingController.dispose();
    DescriptionController.dispose();
    LinkController.dispose();
    EditionController.dispose();
    AuthorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double Size = size(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              backButton(
                  size: Size,
                  child: SizedBox(width: Size * 45),
                  text: "Books Creator"),
              TextFieldContainer(
                child: TextFormField(
                  controller: HeadingController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.white, fontSize: Size * 20),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Heading',
                      hintStyle: TextStyle(color: Colors.white54)),
                ),
                heading: "Heading",
              ),
              TextFieldContainer(
                child: TextFormField(
                  controller: DescriptionController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.white, fontSize: Size * 20),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Description',
                      hintStyle: TextStyle(color: Colors.white54)),
                ),
                heading: "Description",
              ),
              TextFieldContainer(
                child: TextFormField(
                  controller: AuthorController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.white, fontSize: Size * 20),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Author',
                      hintStyle: TextStyle(color: Colors.white54)),
                ),
                heading: "Author",
              ),
              TextFieldContainer(
                child: TextFormField(
                  controller: EditionController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.white, fontSize: Size * 20),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Edition',
                      hintStyle: TextStyle(color: Colors.white54)),
                ),
                heading: "Edition",
              ),
              TextFieldContainer(
                child: TextFormField(
                  controller: LinkController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.white, fontSize: Size * 20),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Link',
                      hintStyle: TextStyle(color: Colors.white54)),
                ),
                heading: "PDF Link",
              ),
              SizedBox(
                height: Size * 20,
              ),
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Back")),
                  SizedBox(
                    width: Size * 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {

                        createBook(
                            isUpdate:widget.data!=null,
                            branch: widget.branch,
                            heading: HeadingController.text.trim(),
                            description: DescriptionController.text.trim(),
                            edition: EditionController.text.trim(),
                            Author: AuthorController.text.trim(),
                            link: LinkController.text.trim(),
                          id: widget.data!=null?widget.data!.id:getID(),

                        );
                      Navigator.pop(context);
                    },
                    child: widget.data==null
                        ? Text("Create")
                        : Text("Update"),
                  ),
                  SizedBox(
                    width: Size * 20,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UnitsCreator extends StatefulWidget {
  final subjectConvertor subject;
  final UnitConvertor? unit;
  final TextBookConvertor? textBook;
  final MoreInfoConvertor? moreInfo;
  String branch;
  String subjectId;
  String mode;

  UnitsCreator({
    required this.mode,
    required this.subjectId,
    required this.subject,
    this.unit,
    this.textBook,
    this.moreInfo,
    required this.branch,
  });

  @override
  State<UnitsCreator> createState() => _UnitsCreatorState();
}

class _UnitsCreatorState extends State<UnitsCreator> {
  String unit = "Unknown";
  bool isEdit = false;
  List list = ["PDF", "Image", "YouTube", "WebSite", "More"];
  final HeadingController = TextEditingController();

  final PDFUrlController = TextEditingController();
  final PhotoUrlController = TextEditingController();
  final AuthorController = TextEditingController();
  final EditionController = TextEditingController();

  void AutoFill() {
    if (widget.mode == "units" && widget.unit != null) {
      HeadingController.text = widget.unit!.Heading;
      unit = widget.unit!.Unit;
      PDFUrlController.text = widget.unit!.Link;
      DescriptionList = widget.unit!.Description;
    } else if (widget.mode == "textBook" && widget.textBook != null) {
      HeadingController.text = widget.textBook!.Heading;
      PDFUrlController.text = widget.textBook!.Link;
      AuthorController.text = widget.textBook!.Author;
      EditionController.text = widget.textBook!.Edition;
    } else if (widget.mode == "more" && widget.moreInfo != null) {
      HeadingController.text = widget.moreInfo!.Heading;
      PDFUrlController.text = widget.moreInfo!.Link;
      unit = widget.moreInfo!.Type;
    }
    setState(() {
      DescriptionList;
      unit;
    });
  }

  @override
  void initState() {
    AutoFill();

    super.initState();
  }

  @override
  void dispose() {
    HeadingController.dispose();

    PDFUrlController.dispose();
    super.dispose();
  }

  List<DescriptionAndQuestionConvertor> DescriptionList = [];
  final TextEditingController _DescriptionController = TextEditingController();
  int selectedDescriptionIndex = -1;
  int DescriptionPageNumber = 0;
  int QuestionPageNumber = 0;

  void addDescription() {
    String points = _DescriptionController.text;
    if (points.isNotEmpty) {
      setState(() {
        DescriptionList.add(DescriptionAndQuestionConvertor(
            pageNumber: DescriptionPageNumber, data: points));
        _DescriptionController.clear();
      });
    }
  }

  void editDescription(int index) {
    setState(() {
      selectedDescriptionIndex = index;
      _DescriptionController.text = DescriptionList[index].data;
      DescriptionPageNumber = DescriptionList[index].pageNumber;
    });
  }

  void saveDescription() {
    String editedImage = _DescriptionController.text;
    if (editedImage.isNotEmpty && selectedDescriptionIndex != -1) {
      DescriptionList.removeAt(selectedDescriptionIndex);
      if (selectedDescriptionIndex == selectedDescriptionIndex) {
        selectedDescriptionIndex = -1;
        _DescriptionController.clear();
      }
      setState(() {
        DescriptionList.add(DescriptionAndQuestionConvertor(
            pageNumber: DescriptionPageNumber, data: editedImage));
        _DescriptionController.clear();
        _DescriptionController.clear();
        selectedDescriptionIndex = -1;
        DescriptionPageNumber = 0;
      });
    }
  }

  void deleteDescription(int index) {
    setState(() {
      DescriptionList.removeAt(index);
      if (selectedDescriptionIndex == index) {
        selectedDescriptionIndex = -1;
        _DescriptionController.clear();
      }
    });
  }

  void moveDescriptionUp(int index) {
    if (index > 0) {
      setState(() {
        DescriptionAndQuestionConvertor point = DescriptionList.removeAt(index);
        DescriptionList.insert(index - 1, point);
        if (selectedDescriptionIndex == index) {
          selectedDescriptionIndex--;
        }
      });
    }
  }

  void moveDescriptionDown(int index) {
    if (index < DescriptionList.length - 1) {
      setState(() {
        DescriptionAndQuestionConvertor image = DescriptionList.removeAt(index);
        DescriptionList.insert(index + 1, image);
        if (selectedDescriptionIndex == index) {
          selectedDescriptionIndex++;
        }
      });
    }
  }

  List<String> NormalDescriptionList = [];
  final TextEditingController _NormalDescriptionController =
      TextEditingController();
  int selectedNormalDescriptionIndex = -1;

  void addNormalDescription() {
    String points = _NormalDescriptionController.text;
    if (points.isNotEmpty) {
      setState(() {
        NormalDescriptionList.add(points);
        _NormalDescriptionController.clear();
      });
    }
  }

  void editNormalDescription(int index) {
    setState(() {
      selectedNormalDescriptionIndex = index;
      _NormalDescriptionController.text = NormalDescriptionList[index];
    });
  }

  void saveNormalDescription() {
    String editedImage = _NormalDescriptionController.text;
    if (editedImage.isNotEmpty && selectedNormalDescriptionIndex != -1) {
      setState(() {
        NormalDescriptionList[selectedNormalDescriptionIndex] = editedImage;
        _NormalDescriptionController.clear();
        selectedNormalDescriptionIndex = -1;
      });
    }
  }

  void deleteNormalDescription(int index) {
    setState(() {
      NormalDescriptionList.removeAt(index);
      if (selectedNormalDescriptionIndex == index) {
        selectedNormalDescriptionIndex = -1;
        _NormalDescriptionController.clear();
      }
    });
  }

  void moveNormalDescriptionUp(int index) {
    if (index > 0) {
      setState(() {
        String point = NormalDescriptionList.removeAt(index);
        NormalDescriptionList.insert(index - 1, point);
        if (selectedNormalDescriptionIndex == index) {
          selectedNormalDescriptionIndex--;
        }
      });
    }
  }

  void moveNormalDescriptionDown(int index) {
    if (index < NormalDescriptionList.length - 1) {
      setState(() {
        String Image = NormalDescriptionList.removeAt(index);
        NormalDescriptionList.insert(index + 1, Image);
        if (selectedNormalDescriptionIndex == index) {
          selectedNormalDescriptionIndex++;
        }
      });
    }
  }

  List<DescriptionAndQuestionConvertor> QuestionsList = [];
  final TextEditingController _QuestionsController = TextEditingController();
  int selectedQuestionsIndex = -1;

  void addQuestion() {
    String points = _QuestionsController.text;
    if (points.isNotEmpty) {
      setState(() {
        QuestionsList.add(
          DescriptionAndQuestionConvertor(
              pageNumber: QuestionPageNumber, data: points),
        );
        _QuestionsController.clear();
      });
    }
  }

  void editQuestion(int index) {
    setState(() {
      selectedQuestionsIndex = index;
      _QuestionsController.text = QuestionsList[index].data;
      QuestionPageNumber = QuestionsList[index].pageNumber;
    });
  }

  void saveQuestion() {
    String editedImage = _QuestionsController.text;
    if (editedImage.isNotEmpty && selectedQuestionsIndex != -1) {
      QuestionsList.removeAt(selectedQuestionsIndex);
      if (selectedQuestionsIndex == selectedQuestionsIndex) {
        selectedQuestionsIndex = -1;
        _QuestionsController.clear();
      }
      setState(() {
        QuestionsList.add(DescriptionAndQuestionConvertor(
            pageNumber: QuestionPageNumber, data: editedImage));
        _QuestionsController.clear();
        _QuestionsController.clear();
        selectedQuestionsIndex = -1;
        QuestionPageNumber = 0;
      });
    }
  }

  void deleteQuestion(int index) {
    setState(() {
      QuestionsList.removeAt(index);
      if (selectedQuestionsIndex == index) {
        selectedQuestionsIndex = -1;
        _QuestionsController.clear();
      }
    });
  }

  void moveQuestionUp(int index) {
    if (index > 0) {
      setState(() {
        DescriptionAndQuestionConvertor point = QuestionsList.removeAt(index);
        QuestionsList.insert(index - 1, point);
        if (selectedQuestionsIndex == index) {
          selectedQuestionsIndex--;
        }
      });
    }
  }

  void moveQuestionDown(int index) {
    if (index < QuestionsList.length - 1) {
      setState(() {
        DescriptionAndQuestionConvertor question =
            QuestionsList.removeAt(index);
        QuestionsList.insert(index + 1, question);
        if (selectedQuestionsIndex == index) {
          selectedQuestionsIndex++;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          backButton(
              size: size(context),
              text: "Create Unit",
              child: SizedBox(
                width: Size * 45,
              )),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.mode == "units")
                    Padding(
                      padding: EdgeInsets.only(
                          left: Size * 15, top: Size * 8, bottom: Size * 10),
                      child: Text(
                        "Type Selected : $unit",
                        style: creatorHeadingTextStyle,
                      ),
                    ),
                  if (widget.mode == "units")
                    SizedBox(
                      height: Size * 30,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        // Display only top 5 items
                        itemBuilder: (context, int index) {
                          if (index == 0) {
                            return Padding(
                              padding: EdgeInsets.only(left: Size * 25),
                              child: InkWell(
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: unit == "Unknown"
                                            ? Colors.white.withOpacity(0.6)
                                            : Colors.white.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(Size * 10)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: Size * 3,
                                          horizontal: Size * 8),
                                      child: Text(
                                        "Unknown",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Size * 25,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                                onTap: () {
                                  setState(() {
                                    unit = "Unknown";
                                  });
                                },
                              ),
                            );
                          } else {
                            return InkWell(
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: unit == "Unit $index"
                                          ? Colors.white.withOpacity(0.6)
                                          : Colors.white.withOpacity(0.1),
                                      borderRadius:
                                          BorderRadius.circular(Size * 10)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Size * 3,
                                        horizontal: Size * 8),
                                    child: Text(
                                      "Unit $index",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Size * 25,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )),
                              onTap: () {
                                setState(() {
                                  unit = "Unit $index";
                                });
                              },
                            );
                          }
                        },
                        separatorBuilder: (context, index) => SizedBox(
                          width: Size * 3,
                        ),
                      ),
                    ),
                  TextFieldContainer(
                    child: TextFormField(
                      controller: HeadingController,
                      textInputAction: TextInputAction.next,
                      style: textFieldStyle(size(context)),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        hintText: 'Heading',
                      ),
                    ),
                    heading: "Heading",
                  ),
                  if (widget.mode == "more")
                    Padding(
                      padding: EdgeInsets.only(
                          left: Size * 15, top: Size * 8, bottom: Size * 10),
                      child: Text(
                        "Type Selected : $unit",
                        style: creatorHeadingTextStyle,
                      ),
                    ),
                  if (widget.mode == "more")
                    SizedBox(
                      height: Size * 30,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: list.length,
                        // Display only top 5 items
                        itemBuilder: (context, int index) {
                          return InkWell(
                            child: Container(
                                decoration: BoxDecoration(
                                    color: unit == list[index]
                                        ? Colors.white.withOpacity(0.6)
                                        : Colors.white.withOpacity(0.1),
                                    borderRadius:
                                        BorderRadius.circular(Size * 10)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Size * 3, horizontal: Size * 8),
                                  child: Text(
                                    list[index],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Size * 25,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )),
                            onTap: () {
                              setState(() {
                                unit = list[index];
                              });
                            },
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(
                          width: Size * 3,
                        ),
                      ),
                    ),
                  if (unit != "more")
                    TextFieldContainer(
                      child: TextFormField(
                        controller: PDFUrlController,
                        textInputAction: TextInputAction.next,
                        style: textFieldStyle(size(context)),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                          hintText: 'Url',
                        ),
                      ),
                      heading: unit != "more"
                          ? "PDF Url"
                          : "Any Url (.img, .pdf, YT, .Web)",
                    ),
                  if (widget.mode == "units")
                    Padding(
                      padding: EdgeInsets.only(left: Size * 15, top: Size * 8),
                      child: Text(
                        "Description",
                        style: creatorHeadingTextStyle,
                      ),
                    ),
                  if (widget.mode == "units")
                    ListView.builder(
                      itemCount: DescriptionList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(DescriptionList[index].data),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding:
                                EdgeInsets.symmetric(horizontal: Size * 16.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            deleteDescription(index);
                          },
                          child: ListTile(
                            title: Text(
                              DescriptionList[index].data,
                              style: TextStyle(
                                  color: Colors.white, fontSize: Size * 20),
                            ),
                            trailing: SingleChildScrollView(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () {
                                      deleteDescription(index);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.greenAccent,
                                    ),
                                    onPressed: () {
                                      editDescription(index);
                                      setState(() {
                                        isEdit = true;
                                      });
                                    },
                                  ),
                                  InkWell(
                                    child: Icon(
                                      Icons.move_up,
                                      size: Size * 30,
                                      color: Colors.amber,
                                    ),
                                    onTap: () {
                                      moveDescriptionUp(index);
                                    },
                                    onDoubleTap: () {
                                      moveDescriptionDown(index);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              editDescription(index);
                            },
                          ),
                        );
                      },
                    ),
                  if (widget.mode == "units")
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: Size * 10,
                              right: Size * 10,
                              top: Size * 5,
                              bottom: Size * 5),
                          child: TextFieldContainer(
                            child: TextFormField(
                              controller: _DescriptionController,
                              style: textFieldStyle(size(context)),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter Description Here',
                                hintStyle: TextStyle(color: Colors.white54),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: Size * 10,
                                    right: Size * 10,
                                    top: Size * 5,
                                    bottom: Size * 5),
                                child: TextFieldContainer(
                                  child: TextFormField(
                                    style: textFieldStyle(size(context)),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      DescriptionPageNumber = int.parse(value);
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter Page Number (Optional)',
                                      hintStyle:
                                          TextStyle(color: Colors.white54),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              child: !isEdit ? Text("Add") : Text("Save"),
                              onPressed: () {
                                !isEdit ? addDescription() : saveDescription();
                                setState(() {
                                  isEdit = false;
                                });
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  if (widget.mode == "units")
                    Padding(
                      padding: EdgeInsets.only(left: Size * 15, top: Size * 8),
                      child: Text(
                        "Question",
                        style: creatorHeadingTextStyle,
                      ),
                    ),
                  if (widget.mode == "units")
                    ListView.builder(
                      itemCount: QuestionsList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(QuestionsList[index].data),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding:
                                EdgeInsets.symmetric(horizontal: Size * 16.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            deleteQuestion(index);
                          },
                          child: ListTile(
                            title: Text(
                              QuestionsList[index].data,
                              style: TextStyle(
                                  color: Colors.white, fontSize: Size * 20),
                            ),
                            trailing: SingleChildScrollView(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () {
                                      deleteQuestion(index);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.greenAccent,
                                    ),
                                    onPressed: () {
                                      editQuestion(index);
                                      setState(() {
                                        isEdit = true;
                                      });
                                    },
                                  ),
                                  InkWell(
                                    child: Icon(
                                      Icons.move_up,
                                      size: Size * 30,
                                      color: Colors.amber,
                                    ),
                                    onTap: () {
                                      moveQuestionUp(index);
                                    },
                                    onDoubleTap: () {
                                      moveQuestionDown(index);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              editQuestion(index);
                            },
                          ),
                        );
                      },
                    ),
                  if (widget.mode == "units")
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: Size * 10,
                              right: Size * 10,
                              top: Size * 5,
                              bottom: Size * 5),
                          child: TextFieldContainer(
                              child: TextFormField(
                            controller: _QuestionsController,
                            style: textFieldStyle(size(context)),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Question Here',
                              hintStyle: TextStyle(color: Colors.white54),
                            ),
                          )),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: Size * 10,
                                    right: Size * 10,
                                    top: Size * 5,
                                    bottom: Size * 5),
                                child: TextFieldContainer(
                                    child: TextFormField(
                                  style: textFieldStyle(size(context)),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 1,
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Question Here',
                                    hintStyle: TextStyle(color: Colors.white54),
                                  ),
                                )),
                              ),
                            ),
                            InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  border: Border.all(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.circular(Size * 14),
                                ),
                                child: Icon(
                                  !isEdit ? Icons.add : Icons.save,
                                  size: Size * 45,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                !isEdit ? addQuestion() : saveQuestion();
                                setState(() {
                                  isEdit = false;
                                });
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  if (widget.mode == "more")
                    Padding(
                      padding: EdgeInsets.only(left: Size * 15, top: Size * 8),
                      child: Text(
                        "Description",
                        style: creatorHeadingTextStyle,
                      ),
                    ),
                  if (widget.mode == "more")
                    ListView.builder(
                      itemCount: NormalDescriptionList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(NormalDescriptionList[index]),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding:
                                EdgeInsets.symmetric(horizontal: Size * 16.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            deleteNormalDescription(index);
                          },
                          child: ListTile(
                            title: Text(
                              NormalDescriptionList[index],
                              style: TextStyle(
                                  color: Colors.white, fontSize: Size * 20),
                            ),
                            trailing: SingleChildScrollView(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () {
                                      deleteNormalDescription(index);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.greenAccent,
                                    ),
                                    onPressed: () {
                                      editNormalDescription(index);
                                      setState(() {
                                        isEdit = true;
                                      });
                                    },
                                  ),
                                  InkWell(
                                    child: Icon(
                                      Icons.move_up,
                                      size: Size * 30,
                                      color: Colors.amber,
                                    ),
                                    onTap: () {
                                      moveNormalDescriptionUp(index);
                                    },
                                    onDoubleTap: () {
                                      moveNormalDescriptionDown(index);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              editNormalDescription(index);
                            },
                          ),
                        );
                      },
                    ),
                  if (widget.mode == "more")
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: Size * 10,
                                right: Size * 10,
                                top: Size * 5,
                                bottom: Size * 5),
                            child: TextFieldContainer(
                                child: TextFormField(
                              controller: _NormalDescriptionController,
                              style: textFieldStyle(size(context)),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter Description Here',
                                hintStyle: TextStyle(color: Colors.white54),
                              ),
                            )),
                          ),
                        ),
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(Size * 14),
                            ),
                            child: Icon(
                              !isEdit ? Icons.add : Icons.save,
                              size: Size * 45,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            !isEdit ? addNormalDescription() : saveNormalDescription();
                            setState(() {
                              isEdit = false;
                            });
                          },
                        )
                      ],
                    ),
                  if (widget.mode == "textBook")
                    TextFieldContainer(
                      child: TextFormField(
                        controller: AuthorController,
                        textInputAction: TextInputAction.next,
                        style: textFieldStyle(size(context)),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                          hintText: 'Author',
                        ),
                      ),
                      heading: "Author",
                    ),
                  if (widget.mode == "textBook")
                    TextFieldContainer(
                      child: TextFormField(
                        controller: EditionController,
                        textInputAction: TextInputAction.next,
                        style: textFieldStyle(size(context)),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                          hintText: 'Edition',
                        ),
                      ),
                      heading: "Edition",
                    ),
                  SizedBox(
                    height: Size * 10,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Back"),
                      ),
                      SizedBox(
                        width: Size * 10,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.greenAccent),
                          ),
                          onPressed: () async {
                            if (widget.mode == "units") {
                              if (widget.unit == null) {
                                await _firestore
                                    .collection('StudyMaterials')
                                    .doc(widget.branch)
                                    .collection("Subjects")
                                    .doc(widget.subjectId)
                                    .update({
                                  'units': FieldValue.arrayUnion([
                                    UnitConvertor(
                                      id: getID(),
                                      Heading: HeadingController.text.trim(),
                                      Description: DescriptionList,
                                      Link: PDFUrlController.text,
                                      Unit: unit,
                                      Size: '',
                                      Question: QuestionsList,
                                    ).toJson(),
                                  ]),
                                });
                              } else {
                                List<UnitConvertor> updatedUnits = List.from(
                                  widget.subject.units
                                      .where(
                                          (unit) => unit.id != widget.unit!.id)
                                      .toList(),
                                );
                                try {
                                  updatedUnits.add(UnitConvertor(
                                    id: widget.unit!.id,
                                    Heading: HeadingController.text.trim(),
                                    Description: DescriptionList,
                                    Link: PDFUrlController.text,
                                    Unit: unit,
                                    Size: widget.unit!.Size,
                                    Question: QuestionsList,
                                  ));
                                } catch (e) {
                                  print("Error updating units: $e");
                                }
                                await _firestore
                                    .collection('StudyMaterials')
                                    .doc(widget.branch)
                                    .collection("Subjects")
                                    .doc(widget.subjectId)
                                    .update({
                                  'units': updatedUnits
                                      .map((unit) => unit.toJson())
                                      .toList(),
                                });
                              }
                            } else if (widget.mode == "textBook") {
                              if (widget.textBook == null) {
                                await _firestore
                                    .collection('StudyMaterials')
                                    .doc(widget.branch)
                                    .collection("Subjects")
                                    .doc(widget.subjectId)
                                    .update({
                                  'textBooks': FieldValue.arrayUnion([
                                    TextBookConvertor(
                                      id: getID(),
                                      Heading: HeadingController.text.trim(),
                                      Link: PDFUrlController.text,
                                      Size: '',
                                      Author: AuthorController.text.trim(),
                                      Edition: EditionController.text.trim(),
                                    ).toJson(),
                                  ]),
                                });
                              } else {
                                List<TextBookConvertor> updatedTextBook =
                                    List.from(
                                  widget.subject.moreInfos
                                      .where((unit) =>
                                          unit.id != widget.moreInfo!.id)
                                      .toList(),
                                );

                                try {
                                  updatedTextBook.add(TextBookConvertor(
                                    id: widget.textBook!.id,
                                    Heading: HeadingController.text.trim(),
                                    Link: PDFUrlController.text,
                                    Size: widget.textBook!.Size,
                                    Author: AuthorController.text,
                                    Edition: EditionController.text,
                                  ));
                                } catch (e) {
                                  print("Error updating units: $e");
                                }
                                await _firestore
                                    .collection('StudyMaterials')
                                    .doc(widget.branch)
                                    .collection("Subjects")
                                    .doc(widget.subjectId)
                                    .update({
                                  'textBooks': updatedTextBook
                                      .map((unit) => unit.toJson())
                                      .toList(),
                                });
                              }
                            } else {
                              if (widget.moreInfo == null) {
                                await _firestore
                                    .collection('StudyMaterials')
                                    .doc(widget.branch)
                                    .collection("Subjects")
                                    .doc(widget.subjectId)
                                    .update({
                                  'moreInfos': FieldValue.arrayUnion([
                                    MoreInfoConvertor(
                                      id: getID(),
                                      Heading: HeadingController.text.trim(),
                                      Link: PDFUrlController.text,
                                      Description: NormalDescriptionList,
                                      Type: unit,
                                    ).toJson(),
                                  ]),
                                });
                              } else {
                                List<MoreInfoConvertor> updatedMore = List.from(
                                  widget.subject.moreInfos
                                      .where((unit) =>
                                          unit.id != widget.moreInfo!.id)
                                      .toList(),
                                );

                                try {
                                  updatedMore.add(MoreInfoConvertor(
                                    id: widget.moreInfo!.id,
                                    Heading: HeadingController.text.trim(),
                                    Description: NormalDescriptionList,
                                    Link: PDFUrlController.text,
                                    Type: unit,
                                  ));
                                } catch (e) {
                                  print("Error updating units: $e");
                                }
                                await _firestore
                                    .collection('StudyMaterials')
                                    .doc(widget.branch)
                                    .collection("Subjects")
                                    .doc(widget.subjectId)
                                    .update({
                                  'moreInfos': updatedMore
                                      .map((unit) => unit.toJson())
                                      .toList(),
                                });
                              }
                            }

                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text(widget.unit == null ||
                                  widget.textBook == null ||
                                  widget.moreInfo == null
                              ? "Create"
                              : "Update")),
                      SizedBox(
                        width: Size * 20,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

Stream<List<RegulationConvertor>> readRegulation(String branch) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("regulation")
        .collection("regulationWithSem")
        .orderBy("id", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RegulationConvertor.fromJson(doc.data()))
            .toList());
