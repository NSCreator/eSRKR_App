// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:srkr_study_app/HomePage.dart';
import 'package:srkr_study_app/SubPages.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'functins.dart';
import 'notification.dart';

class updateCreator extends StatefulWidget {
  String NewsId;
  String heading;
  String link;
  String photoUrl;
  String subMessage;
  String branch;
  final double size;
  final double height;
  final double width;

  updateCreator(
      {this.NewsId = "",
      this.link = '',
      this.heading = "",
      this.photoUrl = "",
      this.subMessage = "",
      required this.width,
      required this.size,
      required this.height,
      required this.branch});

  @override
  State<updateCreator> createState() => _updateCreatorState();
}

class _updateCreatorState extends State<updateCreator> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  String Branch = "";
  bool isBranch = false;
  final MessageController = TextEditingController();
  final subMessageController = TextEditingController();
  final PhotoUrlController = TextEditingController();
  final LinkController = TextEditingController();
  bool _isImage = false;
  void AutoFill() async {
    MessageController.text = widget.heading;
    PhotoUrlController.text = widget.photoUrl;
    subMessageController.text = widget.subMessage;
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
    MessageController.dispose();
    PhotoUrlController.dispose();
    LinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: Color.fromRGBO(7, 7, 23, 1.0),
            ),
          ),
          title: Text(
            "Updater",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8, bottom: 5),
              child: Text(
                "Message",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 3, right: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    controller: MessageController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Heading',
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8, bottom: 5),
              child: Text(
                "Description",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 3, right: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    //obscureText: true,
                    controller: subMessageController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Description',
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8, bottom: 5),
              child: Text(
                "Link",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 3, right: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    //obscureText: true,
                    controller: LinkController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Description or Full name',
                    ),
                  ),
                ),
              ),
            ),
            if (_isImage == true)
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 20),
                child: Row(
                  children: [
                    Container(
                        height: 110,
                        width: 180,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(14),
                            image: DecorationImage(
                                image: NetworkImage(
                                    PhotoUrlController.text.trim()),
                                fit: BoxFit.fill))),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 30, top: 10, bottom: 10, right: 10),
                        child: Text(
                          "Delete",
                          style: TextStyle(
                              fontSize: 30,
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
                  padding: const EdgeInsets.only(left: 15, top: 20, bottom: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.upload,
                        size: 35,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Upload Photo",
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  File file = File(pickedFile!.path);
                  final Reference ref = storage
                      .ref()
                      .child('update/${DateTime.now().toString()}.image');
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
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withOpacity(0.1)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: <Widget>[
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Image",
                                    style: TextStyle(
                                        fontSize: 22,
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
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "Cancel & Delete",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
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
                                    width: 20,
                                  ),
                                  InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "Okay",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
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
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(widget.size * 8),
                      border: isBranch
                          ? Border.all(color: Colors.green.withOpacity(1))
                          : Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: widget.width * 10,
                          right: widget.width * 10,
                          top: widget.height * 3,
                          bottom: widget.height * 3),
                      child: Text(
                        "Branch",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: widget.size * 30),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      isBranch = !isBranch;
                      isBranch ? Branch = widget.branch : Branch = "";
                    });
                    showToastText(Branch);
                  },
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Text("Back..."),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (widget.NewsId.length > 3) {
                      // UpdateBranchNew(heading: HeadingController.text.trim(), description: DescriptionController.text.trim(), Date: getTime(), photoUrl: PhotoUrlController.text.trim(),id: widget.NewsId);
                      FirebaseFirestore.instance
                          .collection("update")
                          .doc(widget.NewsId)
                          .update({
                        "heading": MessageController.text.trim(),
                        "link": LinkController.text.trim(),
                        "photoUrl": PhotoUrlController.text
                      });
                    } else {
                      createHomeUpdate(
                          branch: Branch,
                          description: subMessageController.text,
                          heading: MessageController.text,
                          photoUrl: PhotoUrlController.text.isNotEmpty
                              ? PhotoUrlController.text
                              : " ",
                          link: LinkController.text);

                      SendMessage("Update", MessageController.text, "");
                    }
                    MessageController.clear();
                    LinkController.clear();
                    PhotoUrlController.clear();
                    Navigator.pop(context);
                  },
                  child: widget.NewsId.length < 3
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[500],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Text("Create"),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[500],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Text("Update"),
                          ),
                        ),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NewsCreator extends StatefulWidget {
  String NewsId;
  String heading;
  String description;
  String photoUrl;
  String branch;

  NewsCreator(
      {this.NewsId = "",
      this.description = '',
      this.heading = "",
      this.photoUrl = "",
      required this.branch});

  @override
  State<NewsCreator> createState() => _NewsCreatorState();
}

class _NewsCreatorState extends State<NewsCreator> {
  final FirebaseStorage storage = FirebaseStorage.instance;

  final HeadingController = TextEditingController();
  final DescriptionController = TextEditingController();
  final PhotoUrlController = TextEditingController();
  final LinkController = TextEditingController();
  bool _isImage = false;
  void AutoFill() async {
    HeadingController.text = widget.heading;
    DescriptionController.text = widget.description;
    PhotoUrlController.text = widget.photoUrl;
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
    DescriptionController.dispose();
    PhotoUrlController.dispose();
    LinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: Color.fromRGBO(7, 7, 23, 1.0),
            ),
          ),
          title: Text(
            "Flash News Editor",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8, bottom: 5),
              child: Text(
                "Heading",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 3, right: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    controller: HeadingController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Heading',
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8, bottom: 5),
              child: Text(
                "Description",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 3, right: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    //obscureText: true,
                    controller: DescriptionController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Description or Full name',
                    ),
                  ),
                ),
              ),
            ),
            if (_isImage == true)
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 20),
                child: Row(
                  children: [
                    Container(
                        height: 110,
                        width: 180,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(14),
                            image: DecorationImage(
                                image: NetworkImage(
                                    PhotoUrlController.text.trim()),
                                fit: BoxFit.fill))),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 30, top: 10, bottom: 10, right: 10),
                        child: Text(
                          "Delete",
                          style: TextStyle(
                              fontSize: 30,
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
                  padding: const EdgeInsets.only(left: 15, top: 20, bottom: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.upload,
                        size: 35,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Upload Photo",
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  File file = File(pickedFile!.path);
                  final Reference ref = storage.ref().child(
                      '${widget.branch.toLowerCase()}/news/${DateTime.now().toString()}.image');
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
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withOpacity(0.1)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: <Widget>[
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Image",
                                    style: TextStyle(
                                        fontSize: 22,
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
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "Cancel & Delete",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
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
                                    width: 20,
                                  ),
                                  InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "Okay",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
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
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Text("Back..."),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                InkWell(
                  onTap: () {
                    if (widget.NewsId.length > 3) {
                      // UpdateBranchNew(heading: HeadingController.text.trim(), description: DescriptionController.text.trim(), Date: getTime(), photoUrl: PhotoUrlController.text.trim(),id: widget.NewsId);
                      FirebaseFirestore.instance
                          .collection(widget.branch)
                          .doc("${widget.branch}News")
                          .collection("${widget.branch}News")
                          .doc(widget.NewsId)
                          .update({
                        "Heading": HeadingController.text.trim(),
                        "Description": DescriptionController.text.trim(),
                        "Photo Url": PhotoUrlController.text.trim()
                      });
                    } else {
                      createBranchNew(
                          branch: widget.branch,
                          heading: HeadingController.text.trim(),
                          description: DescriptionController.text.trim(),
                          photoUrl: PhotoUrlController.text.isNotEmpty
                              ? PhotoUrlController.text
                              : " ");
                      SendMessage("${HeadingController.text} News",
                          DescriptionController.text, widget.branch);
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
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Text("Create"),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[500],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Text("Update"),
                          ),
                        ),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SubjectsCreator extends StatefulWidget {
  String Id;
  String heading;
  String description;
  String photoUrl;
  String mode;
  String branch;

  SubjectsCreator(
      {this.Id = "",
      this.description = '',
      this.heading = "",
      this.photoUrl = "",
      this.mode = "Subjects",
      required this.branch});

  @override
  State<SubjectsCreator> createState() => _SubjectsCreatorState();
}

class _SubjectsCreatorState extends State<SubjectsCreator> {
  final HeadingController = TextEditingController();
  final DescriptionController = TextEditingController();
  final PhotoUrlController = TextEditingController();
  final FirebaseStorage storage = FirebaseStorage.instance;
  bool _isImage = false;
  void AutoFill() async {
    HeadingController.text = widget.heading;
    DescriptionController.text = widget.description;
    PhotoUrlController.text = widget.photoUrl;
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
    DescriptionController.dispose();
    PhotoUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: Color.fromRGBO(7, 7, 23, 1.0),
            ),
          ),
          title: Text(
            "Subject Editor",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Heading",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    controller: HeadingController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Heading',
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Description",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    //obscureText: true,
                    controller: DescriptionController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Description or Full name',
                    ),
                  ),
                ),
              ),
            ),
            if (_isImage == true)
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 20),
                child: Row(
                  children: [
                    Container(
                        height: 110,
                        width: 180,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(14),
                            image: DecorationImage(
                                image: NetworkImage(
                                    PhotoUrlController.text.trim()),
                                fit: BoxFit.fill))),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 30, top: 10, bottom: 10, right: 10),
                        child: Text(
                          "Delete",
                          style: TextStyle(
                              fontSize: 30,
                              color: CupertinoColors.destructiveRed),
                        ),
                      ),
                      onTap: () async {
                        final Uri uri =
                            Uri.parse(PhotoUrlController.text.trim());
                        final String fileName = uri.pathSegments.last;
                        final Reference ref =
                            storage.ref().child("/${fileName}");
                        try {
                          await ref.delete();
                          showToastText('Image deleted successfully');
                          setState(() {
                            _isImage = false;
                          });
                        } catch (e) {
                          showToastText('Error deleting image: $e');
                        }
                        PhotoUrlController.text = " ";
                      },
                    ),
                  ],
                ),
              ),
            if (_isImage == false)
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 20, bottom: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.upload,
                        size: 35,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Upload Photo",
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  File file = File(pickedFile!.path);
                  final Reference ref = storage.ref().child(
                      '${widget.branch.toLowerCase()}/${widget.mode}/${DateTime.now().toString()}.firebase');
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
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withOpacity(0.1)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: <Widget>[
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Image",
                                    style: TextStyle(
                                        fontSize: 22,
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
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "Cancel & Delete",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
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
                                    width: 20,
                                  ),
                                  InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "Okay",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
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
            SizedBox(
              height: 5,
            ),
            if (widget.Id.length < 3)
              Divider(
                height: 5,
                color: Colors.white,
              ),
            if (widget.Id.length < 3)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Column(
                    children: [
                      RadioListTile(
                        activeColor: Colors.white,
                        tileColor: Colors.white38,
                        title: Text(
                          "Subject",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                        value: "Subjects",
                        groupValue: widget.mode,
                        onChanged: (value) {
                          setState(() {
                            widget.mode = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        title: Text("Lab Subject",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16)),
                        value: "LabSubjects",
                        activeColor: Colors.white,
                        tileColor: Colors.white38,
                        groupValue: widget.mode,
                        onChanged: (value) {
                          setState(() {
                            widget.mode = value.toString();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            if (widget.Id.length < 3)
              Divider(
                height: 5,
                color: Colors.white,
              ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Text("<-- Back"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    if (widget.Id.length > 3) {
                      if (widget.mode != "LabSubjects") {
                        FirebaseFirestore.instance
                            .collection(widget.branch)
                            .doc("Subjects")
                            .collection("Subjects")
                            .doc(widget.Id)
                            .update({
                          "Heading": HeadingController.text.trim(),
                          "Description": DescriptionController.text.trim(),

                          "Photo Url": PhotoUrlController.text
                        });
                      } else {
                        FirebaseFirestore.instance
                            .collection(widget.branch)
                            .doc("LabSubjects")
                            .collection("LabSubjects")
                            .doc(widget.Id)
                            .update({
                          "Heading": HeadingController.text.trim(),
                          "Description": DescriptionController.text.trim(),

                          "Photo Url": PhotoUrlController.text
                        });
                      }
                    } else {
                      if (widget.mode == "LabSubjects") {
                        createLabSubjects(
                            branch: widget.branch,
                            regulation: "3-2",
                            heading: HeadingController.text.trim(),
                            description: DescriptionController.text.trim(),
                            PhotoUrl: PhotoUrlController.text,
                           );
                      } else {
                        createSubjects(
                            branch: widget.branch,
                            heading: HeadingController.text.trim(),
                            description: DescriptionController.text.trim(),
                            PhotoUrl: PhotoUrlController.text,
                            regulation: "3-2");
                      }
                    }
                    HeadingController.clear();
                    DescriptionController.clear();
                    PhotoUrlController.clear();
                    Navigator.pop(context);
                  },
                  child: widget.Id.length < 3
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[500],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Text("Create"),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[500],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Text("Update"),
                          ),
                        ),
                ),
                SizedBox(
                  width: 20,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class BooksCreator extends StatefulWidget {
  String id;
  String heading;
  String description;
  String photoUrl;
  String Date;
  String Link;
  String Edition;
  String Author;
  String branch;

  BooksCreator(
      {this.id = "",
      this.description = '',
      this.heading = "",
      this.photoUrl = "",
      this.Date = "",
      this.Author = "",
      this.Edition = "",
      required this.branch,
      this.Link = ""});

  @override
  State<BooksCreator> createState() => _BooksCreatorState();
}

class _BooksCreatorState extends State<BooksCreator> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final HeadingController = TextEditingController();
  final DescriptionController = TextEditingController();
  final PhotoUrlController = TextEditingController();
  final LinkController = TextEditingController();
  final EditionController = TextEditingController();
  final AuthorController = TextEditingController();

  void autoFill() async {
    HeadingController.text = widget.heading;
    DescriptionController.text = widget.description;
    PhotoUrlController.text = widget.photoUrl;
    LinkController.text = widget.Link;
    EditionController.text = widget.Edition;
    AuthorController.text = widget.Author;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    autoFill();
  }

  @override
  void dispose() {
    HeadingController.dispose();
    DescriptionController.dispose();
    PhotoUrlController.dispose();
    LinkController.dispose();
    EditionController.dispose();
    AuthorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: Color.fromRGBO(7, 7, 23, 1.0),
            ),
          ),
          title: Text(
            "Books Editor",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Heading",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    controller: HeadingController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Heading',
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Description",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    //obscureText: true,
                    controller: DescriptionController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Description or Full name',
                    ),
                    //autovalidateMode: AutovalidateMode.onUserInteraction,
                    //validator: (value) => value != null && value.length < 6 ? "Enter min. 6 characters" : null,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Photo Url",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    // obscureText: true,
                    controller: PhotoUrlController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Photo Url',
                    ),
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    // validator: (value) => value != null && value.length < 6 ? "Enter min. 6 characters" : null,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Author",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    // obscureText: true,
                    controller: AuthorController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Author',
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Edition",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    // obscureText: true,
                    controller: EditionController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Edition',
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "PDF Link",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    // obscureText: true,
                    controller: LinkController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'PDF Link',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Spacer(),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Text("Back"),
                      ),
                    )),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    if (widget.id.length > 3) {
                      FirebaseFirestore.instance
                          .collection(widget.branch)
                          .doc("Books")
                          .collection("CoreBooks")
                          .doc(widget.id)
                          .update({
                        "Heading": HeadingController.text.trim(),
                        "Edition": EditionController.text.trim(),
                        "Author": AuthorController.text.trim(),
                        "Link": LinkController.text.trim(),
                        "Description": DescriptionController.text.trim(),
                        "Photo Url": PhotoUrlController.text.trim()
                      });
                    } else {
                      createBook(
                          branch: widget.branch,
                          heading: HeadingController.text.trim(),
                          description: DescriptionController.text.trim(),
                          photoUrl: PhotoUrlController.text.trim(),
                          edition: EditionController.text.trim(),
                          Author: AuthorController.text.trim(),
                          link: LinkController.text.trim());
                    }
                    Navigator.pop(context);
                  },
                  child: widget.id.length < 3
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[500],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Text("Create"),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[500],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Text("Update"),
                          ),
                        ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class UnitsCreator extends StatefulWidget {
  String id;
  String Heading;
  String Description;
  String Date;
  String questions;
  String branch;
  String PDFSize;
  String PDFUrl;
  String UnitId;
  String mode;

  UnitsCreator(
      {required this.id,
      required this.mode,
      required this.branch,
      this.Date = "",
      this.Description = "",
      this.Heading = "",
      this.questions = "",
      this.PDFSize = "",
      this.PDFUrl = "",
      this.UnitId = ""});

  @override
  State<UnitsCreator> createState() => _UnitsCreatorState();
}

class _UnitsCreatorState extends State<UnitsCreator> {
  final HeadingController = TextEditingController();
  final DescriptionController = TextEditingController();
  final questionsController = TextEditingController();
  final PDFUrlController = TextEditingController();
  final PDFSizeController = TextEditingController();

  void AutoFill() {
    HeadingController.text = widget.Heading;
    DescriptionController.text = widget.Description;
    questionsController.text = widget.questions;
    PDFUrlController.text = widget.PDFUrl;
    PDFSizeController.text = widget.PDFSize;
  }

  @override
  void initState() {
    AutoFill();
    super.initState();
  }

  @override
  void dispose() {
    HeadingController.dispose();
    DescriptionController.dispose();
    questionsController.dispose();
    PDFUrlController.dispose();
    PDFSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: Color.fromRGBO(7, 7, 23, 1.0),
            ),
          ),
          title: Text(
            "Unit Data Creator",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey.shade800,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Unit Heading",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    controller: HeadingController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Heading',
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Unit Description",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    //obscureText: true,
                    controller: DescriptionController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Description or Full name',
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Questions",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    controller: questionsController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'PDF Name',
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "PDF Url",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    // obscureText: true,
                    controller: PDFUrlController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'PDF Url',
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "PDF Size",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    // obscureText: true,
                    controller: PDFSizeController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'PDF Url',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.5),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Text("Back"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    if (widget.UnitId.length < 3) {
                      createUnits(
                        branch: widget.branch,
                        description: DescriptionController.text.trim(),
                        questions: questionsController.text.trim(),
                        heading: HeadingController.text.trim(),
                        PDFSize: PDFSizeController.text.trim(),
                        PDFLink: PDFUrlController.text.trim(),
                        subjectsID: widget.id,
                        mode: widget.mode,
                      );
                    } else {
                      FirebaseFirestore.instance
                          .collection(widget.branch)
                          .doc(widget.mode)
                          .collection(widget.mode)
                          .doc(widget.UnitId)
                          .collection("Units")
                          .doc(widget.id)
                          .update({
                        "Heading": HeadingController.text.trim(),
                        "PDFSize": PDFSizeController.text.trim(),
                        "PDFLink": PDFUrlController.text.trim(),
                        "Description": DescriptionController.text.trim(),

                        "questions": questionsController.text.trim()
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: widget.UnitId.length < 3
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(0.5),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Text("Create"),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(0.5),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Text("Update"),
                          ),
                        ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
