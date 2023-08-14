// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:srkr_study_app/HomePage.dart';
import 'package:srkr_study_app/SubPages.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:srkr_study_app/settings.dart';
import 'dart:io';

import 'functins.dart';
import 'notification.dart';

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
   TextFieldContainer({required this.child,this.heading =""});

  @override
  State<TextFieldContainer> createState() => _TextFieldContainerState();
}


class _TextFieldContainerState extends State<TextFieldContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(widget.heading.isNotEmpty)Padding(
          padding: const EdgeInsets.only(left: 15, top: 8),
          child: Text(
            widget.heading,
            style: creatorHeadingTextStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 10, right: 10, top: 5, bottom: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white24,
              border: Border.all(color: Colors.white54),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}


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
  String type;
  String Heading;
  String Description;
  String photoUrl;
  String edition;
  String questions;
  String branch;
  String author;
  String PDFUrl;
  String UnitId;
  String mode;

  UnitsCreator(
      {required this.id,
      required this.mode,
      required this.branch,
      required this.type,
      this.edition = "",
      this.photoUrl = "",
      this.Description = "",
      this.Heading = "",
      this.questions = "",
      this.author = "",
      this.PDFUrl = "",
      this.UnitId = ""});

  @override
  State<UnitsCreator> createState() => _UnitsCreatorState();
}

class _UnitsCreatorState extends State<UnitsCreator> {
  String unit = "Unknown";
  bool isEdit = false;
  List list =["PDF","Image","YouTube","WebSite"];
  final HeadingController = TextEditingController();

  final PDFUrlController = TextEditingController();
  final PhotoUrlController = TextEditingController();
  final AuthorController = TextEditingController();
  final EditionController = TextEditingController();


  void AutoFill() {
    if(widget.type=="more")unit =widget.PDFUrl.split(";").first;
    HeadingController.text = widget.Heading;
    if(widget.Description.isNotEmpty)DescriptionList = widget.Description.split(";");
    if(widget.questions.isNotEmpty)QuestionsList = widget.questions.split(";");
    PDFUrlController.text = widget.PDFUrl.split(";").last;
    EditionController.text=widget.edition;
    PhotoUrlController.text=widget.photoUrl;
    AuthorController.text=widget.author;
    setState(() {

    });
  }
  List DescriptionList = [];
  final TextEditingController _DescriptionController = TextEditingController();
  int selectedDescriptionIndex = -1;

  List QuestionsList = [];
  final TextEditingController _QuestionsController = TextEditingController();
  int selectedQuestionsIndex = -1;

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
  void addDescription() {
    String points = _DescriptionController.text;
    if (points.isNotEmpty) {
      setState(() {
        DescriptionList.add(points);
        _DescriptionController.clear();
      });

    }
  }

  void editDescription(int index) {
    setState(() {
      selectedDescriptionIndex = index;
      _DescriptionController.text = DescriptionList[index];
    });
  }

  void saveDescription() {
    String editedImage = _DescriptionController.text;
    if (editedImage.isNotEmpty && selectedDescriptionIndex != -1) {
      setState(() {
        DescriptionList[selectedDescriptionIndex] = editedImage;
        _DescriptionController.clear();
        selectedDescriptionIndex = -1;
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
        String point = DescriptionList.removeAt(index);
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
        String Image = DescriptionList.removeAt(index);
        DescriptionList.insert(index + 1, Image);
        if (selectedDescriptionIndex == index) {
          selectedDescriptionIndex++;
        }
      });
    }
  }

  void addQuestion() {
    String points = _QuestionsController.text;
    if (points.isNotEmpty) {
      setState(() {
        QuestionsList.add(points);
        _QuestionsController.clear();
      });

    }
  }

  void editQuestion(int index) {
    setState(() {
      selectedQuestionsIndex = index;
      _QuestionsController.text = QuestionsList[index];
    });
  }

  void saveQuestion() {
    String editedImage = _QuestionsController.text;
    if (editedImage.isNotEmpty && selectedQuestionsIndex != -1) {
      setState(() {
        QuestionsList[selectedQuestionsIndex] = editedImage;
        _QuestionsController.clear();
        selectedQuestionsIndex = -1;
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
        String point = QuestionsList.removeAt(index);
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
        String Image = QuestionsList.removeAt(index);
        QuestionsList.insert(index + 1, Image);
        if (selectedQuestionsIndex == index) {
          selectedQuestionsIndex++;
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return backGroundImage(
        child: Column(
      children: [
        backButton(size: size(context),text: "Create Unit",),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(widget.type=="unit")Padding(
                  padding: const EdgeInsets.only(left: 15, top: 8,bottom: 10),
                  child: Text(
                    "Type Selected : $unit",
                    style: creatorHeadingTextStyle,
                  ),
                ),
                if(widget.type=="unit")SizedBox(
                  height: 30,
                  child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: 6, // Display only top 5 items
                      itemBuilder: (context, int index) {
                        if(index==0) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: InkWell(
                              child: Container(
                              decoration: BoxDecoration(

                                  color: unit=="Unknown"?Colors.white.withOpacity(0.6):Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10)
                              ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 8),
                                  child: Text("Unknown",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w500),),
                                )),
                              onTap: (){
                                setState(() {
                                  unit = "Unknown";
                                });
                              },
                            ),
                          );
                        } else{
                          return InkWell(
                            child: Container(
                                decoration: BoxDecoration(

                                    color: unit=="Unit $index"?Colors.white.withOpacity(0.6):Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 8),
                                  child: Text("Unit $index",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w500),),
                                )),
                            onTap: (){
                              setState(() {
                                unit = "Unit $index";
                              });
                            },
                          );
                        }
                      },
                  separatorBuilder: (context,index)=>SizedBox(width: 3,),),
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
                  heading:"Heading" ,
                ),
                if(widget.type=="more")Padding(
                  padding: const EdgeInsets.only(left: 15, top: 8,bottom: 10),
                  child: Text(
                    "Type Selected : $unit",
                    style: creatorHeadingTextStyle,
                  ),
                ),
                if(widget.type=="more")SizedBox(
                  height: 30,
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length, // Display only top 5 items
                    itemBuilder: (context, int index) {


                        return InkWell(
                          child: Container(
                              decoration: BoxDecoration(

                                  color: unit==list[index] ?Colors.white.withOpacity(0.6):Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 8),
                                child: Text(list[index],style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w500),),
                              )),
                          onTap: (){
                            setState(() {
                              unit = list[index];
                            });
                          },
                        );

                    },
                    separatorBuilder: (context,index)=>SizedBox(width: 3,),),
                ),
                TextFieldContainer(
                  child: TextFormField(
                    controller: PDFUrlController,
                    textInputAction: TextInputAction.next,
                    style: textFieldStyle(size(context)),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                      hintText: 'PDF Url',
                    ),
                  ),
                  heading:"PDF Url" ,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 8),
                  child: Text(
                    "Description",
                    style: creatorHeadingTextStyle,
                  ),
                ),
               ListView.builder(
                  itemCount: DescriptionList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(DescriptionList[index]),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                        title: Text(DescriptionList[index],style: TextStyle(color: Colors.white,fontSize: 20),),
                        trailing: SingleChildScrollView(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.delete,color: Colors.redAccent,),
                                onPressed: () {
                                  deleteDescription(index);
                                },

                              ),
                              IconButton(
                                icon: Icon(Icons.edit,color: Colors.greenAccent,),
                                onPressed: () {
                                  editDescription(index);
                                  setState(() {
                                    isEdit=true;
                                  });
                                },
                              ),
                              InkWell(
                                child: Icon(Icons.move_up,size: 30,color: Colors.amber,),
                                onTap: (){
                                  moveDescriptionUp(index);
                                },
                                onDoubleTap: (){
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
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                        child:TextFieldContainer(child:TextFormField(
                          controller: _DescriptionController,
                          style: textFieldStyle(size(context)),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Images Here',
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                        ) ,),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(!isEdit?Icons.add:Icons.save,size: 45,color: Colors.white,),
                      ),
                      onTap: (){
                        !isEdit?addDescription():saveDescription();
                        setState(() {
                          isEdit=false;
                        });
                      },
                    )
                  ],
                ),
                if(widget.type=="unit")Padding(
                  padding: const EdgeInsets.only(left: 15, top: 8),
                  child: Text(
                    "Questions",
                    style: creatorHeadingTextStyle,
                  ),
                ),
                if(widget.type=="unit")ListView.builder(
                  itemCount: QuestionsList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(QuestionsList[index]),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                        title: Text(QuestionsList[index],style: TextStyle(color: Colors.white,fontSize: 20),),
                        trailing: SingleChildScrollView(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.delete,color: Colors.redAccent,),
                                onPressed: () {
                                  deleteQuestion(index);
                                },

                              ),
                              IconButton(
                                icon: Icon(Icons.edit,color: Colors.greenAccent,),
                                onPressed: () {
                                  editQuestion(index);
                                  setState(() {
                                    isEdit=true;
                                  });
                                },
                              ),
                              InkWell(
                                child: Icon(Icons.move_up,size: 30,color: Colors.amber,),
                                onTap: (){
                                  moveQuestionUp(index);
                                },
                                onDoubleTap: (){
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
                if(widget.type=="unit")Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                        child:TextFieldContainer(child:TextFormField(
                          controller: _QuestionsController,
                          style: textFieldStyle(size(context)),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Images Here',
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                        ) ,),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(!isEdit?Icons.add:Icons.save,size: 45,color: Colors.white,),
                      ),
                      onTap: (){
                        !isEdit?addQuestion():saveQuestion();
                        setState(() {
                          isEdit=false;
                        });
                      },
                    )
                  ],
                ),
                if(widget.type=="textbook")TextFieldContainer(
                  child: TextFormField(
                    controller: PhotoUrlController,
                    textInputAction: TextInputAction.next,
                    style: textFieldStyle(size(context)),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                      hintText: 'Photo Url',
                    ),
                  ),
                  heading:"Photo Url" ,
                ),
                if(widget.type=="textbook")TextFieldContainer(
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
                  heading:"Author" ,
                ),
                if(widget.type=="textbook")TextFieldContainer(
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
                  heading:"Edition" ,
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
                        if(widget.type=="unit"){
                          if (widget.UnitId.length < 3) {

                            createUnits(
                              branch: widget.branch,
                              description: DescriptionList.join(";"),
                              questions: QuestionsList.join(";"),
                              heading: unit+";"+HeadingController.text.trim(),
                              PDFSize: "0",
                              PDFLink: PDFUrlController.text.trim(),
                              subjectsID: widget.id,
                              mode: widget.mode,
                            );
                          }
                          else {
                            FirebaseFirestore.instance
                                .collection(widget.branch)
                                .doc(widget.mode)
                                .collection(widget.mode)
                                .doc(widget.UnitId)
                                .collection("Units")
                                .doc(widget.id)
                                .update({
                              "Heading": unit+";"+HeadingController.text.trim(),
                              "PDFLink": PDFUrlController.text.trim(),
                              "Description": DescriptionList.join(";"),
                              "questions": QuestionsList.join(";")
                            });
                          }
                        }
                        else if(widget.type=="textbook"){
                          if (widget.UnitId.length < 3) {

                            createUnitsTextbooks(
                              branch: widget.branch,
                              description: DescriptionList.join(";"),
                              heading: HeadingController.text.trim(),
                              PDFLink: PDFUrlController.text.trim(),
                              subjectsID: widget.id,
                              mode: widget.mode,
                              photoUrl: PhotoUrlController.text.trim(), author: AuthorController.text.trim(),
                              edition: EditionController.text.trim(),
                            );
                          }
                          else {
                            FirebaseFirestore.instance
                                .collection(widget.branch)
                                .doc(widget.mode)
                                .collection(widget.mode)
                                .doc(widget.UnitId)
                                .collection("TextBooks")
                                .doc(widget.id)
                                .update({
                              "description": DescriptionList.join(";"),
                              "heading": HeadingController.text.trim(),
                              "author": AuthorController.text.trim(),
                              "photoUrl": PhotoUrlController.text.trim(),
                              "edition": EditionController.text.trim(),
                              "PDFLink": PDFUrlController.text.trim(),
                            });
                          }
                        }else{
                          if (widget.UnitId.length < 3) {

                            createUnitsMore(
                              branch: widget.branch,
                              subjectsID: widget.id,
                              mode: widget.mode, heading: HeadingController.text.trim(), description: DescriptionList.join(";"), link: unit+";"+PDFUrlController.text,

                            );
                          }
                          else {
                            FirebaseFirestore.instance
                                .collection(widget.branch)
                                .doc(widget.mode)
                                .collection(widget.mode)
                                .doc(widget.UnitId)
                                .collection("More")
                                .doc(widget.id)
                                .update({
                              "description": DescriptionList.join(";"),
                              "heading": HeadingController.text.trim(),
                              "author": AuthorController.text.trim(),
                              "photoUrl": PhotoUrlController.text.trim(),
                              "edition": EditionController.text.trim(),
                              "PDFLink": PDFUrlController.text.trim(),
                            });
                          }
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
        ),
      ],
    ));
  }
}
