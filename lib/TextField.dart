// ignore_for_file: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:srkr_study_app/HomePage.dart';
import 'package:srkr_study_app/SubPages.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:srkr_study_app/main.dart';
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
    double Size = size(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(widget.heading.isNotEmpty)Padding(
          padding:  EdgeInsets.only(left: Size*15, top:Size* 8),
          child: Text(
            widget.heading,
            style: creatorHeadingTextStyle,
          ),
        ),
        Padding(
          padding:  EdgeInsets.only(
              left: Size*10, right: Size*10, top: Size*5, bottom: Size*5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              // border: Border.all(color: Colors.white54),
              borderRadius: BorderRadius.circular(Size*20),
            ),
            child: Padding(
              padding:  EdgeInsets.only(left: Size*10),
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
  flashNewsCreator(
      {this.NewsId = "",
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
              backButton(size: widget.size,text: "Flash News Creator",child: SizedBox(width: widget.size*45,)),
              TextFieldContainer(heading: "Heading",
                  child: Padding(
                    padding:  EdgeInsets.only(left: widget.size*10),
                    child: TextFormField(
                      controller: HeadingController,
                      textInputAction: TextInputAction.next,
                      maxLines: null,
                      style: TextStyle(color: Colors.white,fontSize: widget.size*20),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        hintText: 'Heading',
                      ),
                    ),
                  )),

              TextFieldContainer(heading: "Link",
                  child: Padding(
                    padding:  EdgeInsets.only(left: widget.size*10),
                    child: TextFormField(
                      //obscureText: true,
                      controller: LinkController,
                      textInputAction: TextInputAction.next,
                      maxLines: null,
                      style: TextStyle(color: Colors.white,fontSize: widget.size*20),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Description or Full name',
                          hintStyle: TextStyle(color: Colors.white54)
                      ),
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
                        borderRadius: BorderRadius.circular(widget.size*15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(
                            left: widget.size*10, right: widget.size*10, top:widget.size* 5, bottom: widget.size*5),
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
                            .doc("flashNews").collection("flashNews").doc(widget.NewsId)
                            .update({
                          "heading": HeadingController.text.trim(),
                          "link": LinkController.text.trim(),
                        });

                        messageToOwner("flash News is Updated\nBy '${fullUserId()}' \n  Heading : ${HeadingController.text.trim()}\n  Link: ${LinkController.text.trim()}\n **${widget.branch}");

                      } else {
                        String id =  getID();
                        FirebaseFirestore.instance
                            .collection("srkrPage")
                            .doc("flashNews").collection("flashNews").doc(id)
                            .set({
                          "id":id,
                          "heading": HeadingController.text.trim(),
                          "link": LinkController.text.trim(),
                        });
                        // SendMessage("flashNews;$id",HeadingController.text.trim(),"None");
                        messageToOwner("flash News is Created\nBy '${fullUserId()}' \n  Heading : ${HeadingController.text.trim()}\n  Link: ${LinkController.text.trim()}\n **${widget.branch}");
                      }


                      HeadingController.clear();
                      LinkController.clear();

                      Navigator.pop(context);
                    },
                    child: widget.NewsId.length < 3
                        ? Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(widget.size*15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(
                            left: widget.size*10, right: widget.size*10, top:widget.size* 5, bottom: widget.size*5),
                        child: Text("Create"),
                      ),
                    )
                        : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(widget.size*15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(
                            left: widget.size*10, right: widget.size*10, top:widget.size* 5, bottom:widget.size* 5),
                        child: Text("Update"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width:widget.size* 15,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),);
  }
}

class timeTableSyllabusModalPaperCreator extends StatefulWidget {
  String id;
  String heading;
  String link;
  String link1;
  String mode;
  String reg;
  String branch;
  final double size;
  timeTableSyllabusModalPaperCreator(
      {this.id = "",
        this.link = '',
        this.link1 = '',
        this.heading = "",
        required this.size,
        required this.mode,
        required this.reg,
        required this.branch,
      });

  @override
  State<timeTableSyllabusModalPaperCreator> createState() => _timeTableSyllabusModalPaperCreatorState();
}

class _timeTableSyllabusModalPaperCreatorState extends State<timeTableSyllabusModalPaperCreator> {
  FirebaseStorage storage = FirebaseStorage.instance;

  final HeadingController = TextEditingController();

  final LinkController = TextEditingController();
  final LinkController1 = TextEditingController();
  final PhotoUrlController = TextEditingController();
  bool _isImage = false;
  void AutoFill() async {
    HeadingController.text = widget.heading;
    if(widget.mode!="Time Table")HeadingController.text = widget.reg.substring(0,10);
    LinkController.text = widget.link;
    LinkController1.text = widget.link1;
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
    LinkController1.dispose();
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
              backButton(size: widget.size,text: widget.mode,child: SizedBox(width: widget.size*45,)),
              TextFieldContainer(heading: "Heading",
                  child: Padding(
                    padding:  EdgeInsets.only(left:widget.size* 10),
                    child: TextFormField(
                      controller: HeadingController,
                      textInputAction: TextInputAction.next,
                      maxLines: null,
                      style: TextStyle(color: Colors.white,fontSize: widget.size*20),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        hintText: 'Heading',
                      ),
                    ),
                  )),

              if( widget.mode!="modalPaper")TextFieldContainer(heading: widget.mode!="Time Table"?"Syllabus":"Time Table",
                  child: Padding(
                    padding:  EdgeInsets.only(left: widget.size*10),
                    child: TextFormField(
                      //obscureText: true,
                      controller: LinkController,
                      textInputAction: TextInputAction.next,
                      maxLines: null,
                      style: TextStyle(color: Colors.white,fontSize: widget.size*20),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: widget.mode!="Time Table"?"Syllabus Link":"Time Table Link",
                          hintStyle: TextStyle(color: Colors.white54)
                      ),
                    ),
                  )),
              if( widget.mode=="modalPaper")TextFieldContainer(heading: "Modal Paper",
                  child: Padding(
                    padding:  EdgeInsets.only(left: widget.size*10),
                    child: TextFormField(
                      //obscureText: true,
                      controller: LinkController1,
                      textInputAction: TextInputAction.next,
                      maxLines: null,
                      style: TextStyle(color: Colors.white,fontSize:widget.size* 20),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Modal Paper Link',
                          hintStyle: TextStyle(color: Colors.white54)
                      ),
                    ),
                  )),
              if (_isImage == true &&widget.mode=="Time Table")
                Padding(
                  padding:  EdgeInsets.only(left:widget.size* 10, top:widget.size* 20),
                  child: Row(
                    children: [
                      Container(
                          height:widget.size* 110,
                          width: widget.size*180,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(widget.size*14),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      PhotoUrlController.text.trim()),
                                  fit: BoxFit.fill))),
                      InkWell(
                        child: Padding(
                          padding:  EdgeInsets.only(
                              left:widget.size* 30, top:widget.size* 10, bottom: widget.size*10, right:widget.size* 10),
                          child: Text(
                            "Delete",
                            style: TextStyle(
                                fontSize: widget.size*30,
                                color: CupertinoColors.destructiveRed),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_isImage == false&&widget.mode=="Time Table")
                InkWell(
                  child: Padding(
                    padding:  EdgeInsets.only(left: widget.size*15, top:widget.size* 20, bottom:widget.size* 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.upload,
                          size: widget.size*35,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: widget.size*5,
                        ),
                        Text(
                          "Upload Photo",
                          style: TextStyle(fontSize: widget.size*30, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                    File file = File(pickedFile!.path);
                    final Reference ref = storage.ref().child('timetable/${getID()}');
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
                              borderRadius: BorderRadius.circular(widget.size*20)),
                          elevation: 16,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.1)),
                              borderRadius: BorderRadius.circular(widget.size*20),
                            ),
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              children: <Widget>[
                                 Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(widget.size*8.0),
                                    child: Text(
                                      "Image",
                                      style: TextStyle(
                                          fontSize: widget.size*22,
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
                                  height: widget.size*10,
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      child: Padding(
                                        padding:  EdgeInsets.all(widget.size*5.0),
                                        child: Text(
                                          "Cancel & Delete",
                                          style: TextStyle(
                                              color: Colors.white, fontSize:widget.size* 20),
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
                                      width: widget.size*20,
                                    ),
                                    InkWell(
                                      child: Padding(
                                        padding:  EdgeInsets.all(widget.size*5.0),
                                        child: Text(
                                          "Okay",
                                          style: TextStyle(
                                              color: Colors.white, fontSize:widget.size* 20),
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
                        borderRadius: BorderRadius.circular(widget.size*15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(
                            left: widget.size*10, right: widget.size*10, top: widget.size*5, bottom: widget.size*5),
                        child: Text("Back..."),
                      ),

                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if(widget.mode=="Time Table"){
                        if (widget.id.length > 3) {
                          FirebaseFirestore.instance
                              .collection(widget.branch)
                              .doc("regulation")
                              .collection("regulationWithSem")
                              .doc(widget.reg)
                              .collection("timeTables")
                              .doc(widget.id).update({"heading":HeadingController.text.trim(),"image":PhotoUrlController.text.trim()});
                        } else {
                          createTimeTable(branch: widget.branch, heading: HeadingController.text.trim(), photoUrl: PhotoUrlController.text.trim(), reg: widget.reg);
                        }
                      }else{
                        if (widget.id.length > 3) {
                          if(widget.mode=="modalPaper"){
                            FirebaseFirestore.instance
                                .collection(widget.branch)
                                .doc("regulation")
                                .collection("regulationWithYears")
                                .doc(widget.id.substring(0, 10)).update({"modelPaper":LinkController1.text.trim(),});

                          }else{
                            FirebaseFirestore.instance
                                .collection(widget.branch)
                                .doc("regulation")
                                .collection("regulationWithYears")
                                .doc(widget.id.substring(0, 10)).update({"syllabus":LinkController.text.trim(),});

                          }
                        }
                      }


                      HeadingController.clear();
                      LinkController.clear();

                      Navigator.pop(context);
                    },
                    child: widget.id.length < 3
                        ? Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(widget.size*15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(
                            left: widget.size*10, right:widget.size* 10, top: widget.size*5, bottom: widget.size*5),
                        child: Text("Create"),
                      ),
                    )
                        : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(widget.size*15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(
                            left: widget.size*10, right: widget.size*10, top:widget.size* 5, bottom: widget.size*5),
                        child: Text("Update"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width:widget.size* 15,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),);
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


  updateCreator(
      {this.NewsId = "",
        this.link = '',
        this.heading = "",
        this.photoUrl = "",
        this.subMessage = "",

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backButton(size: widget.size,text: "Updater",child: SizedBox(width: widget.size*45,)),
            TextFieldContainer(child: TextFormField(
              controller: HeadingController,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: Colors.white,fontSize: widget.size*20),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Heading',
                  hintStyle: TextStyle(color: Colors.white54)
              ),
            ),heading: "Heading",),
            TextFieldContainer(child: TextFormField(
              controller: DescriptionController,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: Colors.white,fontSize: widget.size*20),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.white54)
              ),
            ),heading: "Description",),
  TextFieldContainer(child: TextFormField(
              controller: LinkController,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: Colors.white,fontSize: widget.size*20),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Url',
                  hintStyle: TextStyle(color: Colors.white54)
              ),
            ),heading: "Url",),



            if (_isImage == true)
              Padding(
                padding:  EdgeInsets.only(left:widget.size* 10, top:widget.size* 20),
                child: Row(
                  children: [
                    Container(
                        height:widget.size* 110,
                        width:widget.size* 180,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(widget.size*14),
                            image: DecorationImage(
                                image: NetworkImage(
                                    PhotoUrlController.text.trim()),
                                fit: BoxFit.fill))),
                    InkWell(
                      child: Padding(
                        padding:  EdgeInsets.only(
                            left:widget.size* 30, top: widget.size*10, bottom:widget.size* 10, right: widget.size*10),
                        child: Text(
                          "Delete",
                          style: TextStyle(
                              fontSize:widget.size* 30,
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
                  padding:  EdgeInsets.only(left:widget.size* 15, top:widget.size* 20, bottom: widget.size*10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.upload,
                        size: widget.size*35,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: widget.size*5,
                      ),
                      Text(
                        "Upload Photo",
                        style: TextStyle(fontSize: widget.size*30, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                  File file = File(pickedFile!.path);
                  final Reference ref = storage.ref().child('update/${getID()}');
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
                            borderRadius: BorderRadius.circular(widget.size*20)),
                        elevation: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withOpacity(0.1)),
                            borderRadius: BorderRadius.circular(widget.size*20),
                          ),
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: <Widget>[
                               Center(
                                child: Padding(
                                  padding: EdgeInsets.all(widget.size*8.0),
                                  child: Text(
                                    "Image",
                                    style: TextStyle(
                                        fontSize:widget.size* 22,
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
                                height: widget.size*10,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    child: Padding(
                                      padding:  EdgeInsets.all(widget.size*5.0),
                                      child: Text(
                                        "Cancel & Delete",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: widget.size*20),
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
                                      padding:  EdgeInsets.all(widget.size*5.0),
                                      child: Text(
                                        "Okay",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: widget.size*20),
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
                      borderRadius: BorderRadius.circular(widget.size*15),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Padding(
                      padding:  EdgeInsets.only(
                          left: widget.size*10, right: widget.size*10, top:widget.size* 5, bottom: widget.size*5),
                      child: Text("Back..."),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if(true){
                      if (widget.NewsId.length > 3) {
                        // UpdateBranchNew(heading: HeadingController.text.trim(), description: DescriptionController.text.trim(), Date: getTime(), photoUrl: PhotoUrlController.text.trim(),id: widget.NewsId);
                        FirebaseFirestore.instance
                            .collection("update")
                            .doc(widget.NewsId)
                            .update({
                          "heading": HeadingController.text.trim(),
                          "link": LinkController.text.trim(),
                          "image": PhotoUrlController.text,
                          "description":DescriptionController.text
                        });
                        messageToOwner("Update is Updated\nBy '${fullUserId()}\n    Heading : ${HeadingController.text.trim()}\n    Description : ${DescriptionController.text}    \nImage : ${PhotoUrlController.text}    \nLink : ${LinkController.text.trim()}\n **${widget.branch}");
                      } else {
                        String id =  getID();
                        createHomeUpdate(
                            id: id,
                            creator:fullUserId(),
                            description: DescriptionController.text,
                            heading: HeadingController.text,
                            photoUrl: PhotoUrlController.text,
                            link: LinkController.text);
                        messageToOwner("Update is Created\nBy '${fullUserId()}\n    Heading : ${HeadingController.text.trim()}\n    Description : ${DescriptionController.text}    \nImage : ${PhotoUrlController.text}    \nLink : ${LinkController.text.trim()}\n **${widget.branch}");

                        // SendMessage("Update;$id",MessageController.text.trim(),widget.branch );

                      }


                      HeadingController.clear();
                      LinkController.clear();
                      PhotoUrlController.clear();
                      Navigator.pop(context);
                    }else{

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
                          messageToOwner("Branch News Updated.\nBy : '${fullUserId()}' \n    Heading : ${HeadingController.text.trim()}\n    Description : ${DescriptionController.text.trim()}\n    Image : ${PhotoUrlController.text.trim()}\n **${widget.branch}");
                        } else {
                          String id= getID();
                          createBranchNew(
                              branch: widget.branch,
                              heading: HeadingController.text.trim(),
                              description: DescriptionController.text.trim(),
                              photoUrl: PhotoUrlController.text, id: id);
                          messageToOwner("Branch News Created.\nBy : '${fullUserId()}' \n    Heading : ${HeadingController.text.trim()}\n    Description : ${DescriptionController.text.trim()}\n    Image : ${PhotoUrlController.text.trim()}\n **${widget.branch}");

                          // SendMessage("News;$id",HeadingController.text.trim(),widget.branch );

                        }
                        HeadingController.clear();
                        DescriptionController.clear();
                        PhotoUrlController.clear();
                        Navigator.pop(context);


                    }

                  },
                  child: widget.NewsId.length < 3
                      ? Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(widget.size*15),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Padding(
                      padding:  EdgeInsets.only(
                          left: widget.size*10, right: widget.size*10, top:widget.size* 5, bottom:widget.size* 5),
                      child: Text("Create"),
                    ),
                  )
                      : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(widget.size*15),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Padding(
                      padding:  EdgeInsets.only(
                          left: widget.size*10, right: widget.size*10, top: widget.size*5, bottom: widget.size*5),
                      child: Text("Update"),
                    ),
                  ),
                ),
                SizedBox(
                  width:widget.size* 15,
                ),
              ],
            ),
          ],
        ),
      ),
    ));
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
    double Size=size(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              backButton(size: Size, text: "Branch News Creator",child: SizedBox(width:Size* 45,),),
              TextFieldContainer(child: TextFormField(
                controller: HeadingController,
                textInputAction: TextInputAction.next,
                style: TextStyle(color: Colors.white,fontSize: Size*20),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Heading',
                    hintStyle: TextStyle(color: Colors.white54)
                ),
              ),heading: "Heading",),
              TextFieldContainer(child: TextFormField(
                controller: DescriptionController,
                textInputAction: TextInputAction.next,
                style: TextStyle(color: Colors.white,fontSize: Size*20),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Description',
                    hintStyle: TextStyle(color: Colors.white54)
                ),
              ),heading: "Description",),


              if (_isImage == true)
                Padding(
                  padding:  EdgeInsets.only(left: Size*10, top: Size*20),
                  child: Row(
                    children: [
                      Container(
                          height: Size*110,
                          width: Size*180,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(Size*14),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      PhotoUrlController.text.trim()),
                                  fit: BoxFit.fill))),
                      InkWell(
                        child: Padding(
                          padding:  EdgeInsets.only(
                              left: Size*30, top:Size* 10, bottom: Size*10, right: Size*10),
                          child: Text(
                            "Delete",
                            style: TextStyle(
                                fontSize:Size* 30,
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
                    padding:  EdgeInsets.only(left: Size*15, top: Size*20, bottom: Size*10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.upload,
                          size:Size* 35,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width:Size* 5,
                        ),
                        Text(
                          "Upload Photo",
                          style: TextStyle(fontSize:Size* 30, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    File file = File(pickedFile!.path);
                    final Reference ref = storage.ref().child(
                        '${widget.branch.toLowerCase()}/news/${DateTime.now().toString()}');
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
                              borderRadius: BorderRadius.circular(Size*20)),
                          elevation: 16,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.1)),
                              borderRadius: BorderRadius.circular(Size*20),
                            ),
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              children: <Widget>[
                                 Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(Size*8.0),
                                    child: Text(
                                      "Image",
                                      style: TextStyle(
                                          fontSize: Size*22,
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
                                        padding:  EdgeInsets.all(Size*5.0),
                                        child: Text(
                                          "Cancel & Delete",
                                          style: TextStyle(
                                              color: Colors.white, fontSize:Size* 20),
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
                                      width: Size*20,
                                    ),
                                    InkWell(
                                      child: Padding(
                                        padding:  EdgeInsets.all(Size*5.0),
                                        child: Text(
                                          "Okay",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: Size*20),
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
                height:Size* 20,
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
                        borderRadius: BorderRadius.circular(Size*15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(
                            left:Size* 10, right: Size*10, top:Size* 5, bottom: Size*5),
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
                        messageToOwner("Branch News Updated.\nBy : '${fullUserId()}' \n    Heading : ${HeadingController.text.trim()}\n    Description : ${DescriptionController.text.trim()}\n    Image : ${PhotoUrlController.text.trim()}\n **${widget.branch}");
                      } else {
                        String id= getID();
                        createBranchNew(
                            branch: widget.branch,
                            heading: HeadingController.text.trim(),
                            description: DescriptionController.text.trim(),
                            photoUrl: PhotoUrlController.text, id: id);
                        messageToOwner("Branch News Created.\nBy : '${fullUserId()}' \n    Heading : ${HeadingController.text.trim()}\n    Description : ${DescriptionController.text.trim()}\n    Image : ${PhotoUrlController.text.trim()}\n **${widget.branch}");

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
                        borderRadius: BorderRadius.circular(Size*15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(
                            left: Size*10, right: Size*10, top: Size*5, bottom: Size*5),
                        child: Text("Create"),
                      ),
                    )
                        : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(Size*15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(
                            left: Size*10, right:Size* 10, top: Size*5, bottom: Size*5),
                        child: Text("Update"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Size*15,
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

class SubjectsCreator extends StatefulWidget {
  String Id;
  String heading;
  String description;
  double size;
  String photoUrl;
  String mode;
  String branch;
  String reg;

  SubjectsCreator(
      {this.Id = "",
        this.description = '',
        this.heading = "",
        this.reg = "",
        this.photoUrl = "",
        this.mode = "Subjects",
        required this.branch,
        required this.size
      });

  @override
  State<SubjectsCreator> createState() => _SubjectsCreatorState();
}

class _SubjectsCreatorState extends State<SubjectsCreator> {
  final HeadingController = TextEditingController();
  final HeadingController1 = TextEditingController();
  final DescriptionController = TextEditingController();
  final FirebaseStorage storage = FirebaseStorage.instance;
  bool _isImage = false;
  String reg="";

  void AutoFill() async {
    HeadingController.text = widget.heading;
    DescriptionController.text = widget.description;
    reg = widget.reg;
    if (widget.photoUrl.length > 3) {
      setState(() {
        _isImage = true;
      });
    }
  }
  String selectedLanguage = 'none';
  @override
  void initState() {
    AutoFill();
    super.initState();
  }

  @override
  void dispose() {
    HeadingController.dispose();
    DescriptionController.dispose();
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
              backButton(size: size(context),text:"Subject Editor" ,child: SizedBox(width:widget.size* 45,)),

             Row(
               children: [
                 Flexible(
                   child: TextFieldContainer(child: TextFormField(
                     controller: HeadingController,
                     textInputAction: TextInputAction.next,
                     style: TextStyle(color: Colors.white,fontSize: widget.size*20),
                     decoration: InputDecoration(
                         border: InputBorder.none,
                         hintText: 'Name',
                         hintStyle: TextStyle(color: Colors.white54)
                     ),
                   ),heading: "Short Name",),
                 ),
                 Flexible(
                   flex: 2,
                   child: TextFieldContainer(child: TextFormField(
                     controller: HeadingController1,
                     textInputAction: TextInputAction.next,
                     style: TextStyle(color: Colors.white,fontSize: widget.size*20),
                     decoration: InputDecoration(
                         border: InputBorder.none,
                         hintText: 'Full Name',
                         hintStyle: TextStyle(color: Colors.white54)
                     ),
                   ),heading: "Full Name",),
                 ),
               ],
             ),


              TextFieldContainer(child: TextFormField(
                //obscureText: true,
                controller: DescriptionController,
                textInputAction: TextInputAction.next,
                style: TextStyle(color: Colors.white,fontSize:widget.size* 20),

                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Description or Full name',
                    hintStyle: TextStyle(color: Colors.white54)

                ),
              ),heading: "Description",),

              SizedBox(
                height:widget.size* 5,
              ),
              if (widget.Id.length < 3)
                Divider(
                  height: widget.size*5,
                  color: Colors.white,
                ),
              if (widget.Id.length < 3)
                Padding(
                  padding:  EdgeInsets.all(widget.size*8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(widget.size*15),
                      border: Border.all(color: Colors.white54),
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
                                fontSize:widget.size* 16),
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
                                  fontSize: widget.size*16)),
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
                  height: widget.size*5,
                  color: Colors.white,
                ),
              SizedBox(
                height:widget.size* 20,
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal:widget.size* 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              widget.size * 8),
                          color: Colors.white24,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: widget.size * 5,
                              horizontal: widget.size * 10),
                          child: Text(
                            "Change Regulation",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: widget.size * 22),
                          ),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: Colors.transparent,

                              elevation: 20,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(widget.size*30)
                                ),
                                child: StreamBuilder<List<RegulationConvertor>>(
                                    stream: readRegulation(widget.branch),
                                    builder: (context, snapshot) {
                                      final user = snapshot.data;
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
                                                    'Error with Regulation Data or\n Check Internet Connection'));
                                          } else {
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: user!.length,
                                              itemBuilder: (context, int index) {
                                                final SubjectsData = user[index];
                                                return Center(
                                                  child: Padding(
                                                    padding:  EdgeInsets.symmetric(vertical:widget.size*5.0),
                                                    child: InkWell(
                                                      child: Text(
                                                        SubjectsData.id.toUpperCase(),
                                                        style: TextStyle(
                                                            color: Colors.black87,
                                                            fontSize: widget.size*20,fontWeight: FontWeight.bold),
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          reg=SubjectsData.id;
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                      }
                                    }),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Text("$reg",style: TextStyle(color: Colors.white,fontSize: widget.size*20,fontWeight: FontWeight.w800),)
                  ],
                ),
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
                        borderRadius: BorderRadius.circular(widget.size*15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(
                            left:widget.size* 10, right: widget.size*10, top: widget.size*5, bottom: widget.size*5),
                        child: Text("<-- Back"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width:widget.size* 10,
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
                            "heading": HeadingController.text.trim()+';'+HeadingController1.text.trim(),
                            "description": DescriptionController.text.trim(),
                            "regulation":reg
                          });
                          messageToOwner("Subject Updated.\nBy : '${fullUserId()}' \n    Heading : ${ HeadingController.text.trim()+';'+HeadingController1.text.trim()}\n    Description : ${DescriptionController.text.trim()}\n    regulation : ${reg}\n **${widget.branch}");

                        } else {
                          FirebaseFirestore.instance
                              .collection(widget.branch)
                              .doc("LabSubjects")
                              .collection("LabSubjects")
                              .doc(widget.Id)
                              .update({
                            "heading": HeadingController.text.trim()+';'+HeadingController1.text.trim(),
                            "description": DescriptionController.text.trim(),
                            "regulation":reg
                          });
                          messageToOwner("Subject Updated.\nBy : '${fullUserId()}' \n    Heading : ${HeadingController.text.trim()+';'+HeadingController1.text.trim()}\n    Description : ${DescriptionController.text.trim()}\n    regulation : ${reg}\n **${widget.branch}");

                        }
                      } else {
                        if (widget.mode == "LabSubjects") {
                          createLabSubjects(
                            branch: widget.branch,
                            regulation: reg,
                            heading: HeadingController.text.trim()+';'+HeadingController1.text.trim(),
                            description: DescriptionController.text.trim(),
                            creator: fullUserId(),
                          );
                          messageToOwner("Lab Subject Created.\nBy : '${fullUserId()}' \n    Heading : ${HeadingController.text.trim()+';'+HeadingController1.text.trim()}\n    Description : ${DescriptionController.text.trim()}\n    regulation : ${reg}\n **${widget.branch}");

                        } else {
                          createSubjects(
                              branch: widget.branch,
                              heading: HeadingController.text.trim()+';'+HeadingController1.text.trim(),
                              description: DescriptionController.text.trim(),
                              creator: fullUserId(),
                              regulation: reg);
                          messageToOwner("Subject Created.\nBy : '${fullUserId()}' \n    Heading : ${HeadingController.text.trim()+';'+HeadingController1.text.trim()}\n    Description : ${DescriptionController.text.trim()}\n    regulation : ${reg}\n **${widget.branch}");

                        }
                      }
                      HeadingController.clear();
                      DescriptionController.clear();
                      Navigator.pop(context);
                    },
                    child: widget.Id.length < 3
                        ? Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(widget.size*15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(
                            left:widget.size* 10, right: widget.size*10, top:widget.size* 5, bottom: widget.size*5),
                        child: Text("Create"),
                      ),
                    )
                        : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(widget.size*15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(
                            left: widget.size*10, right:widget.size* 10, top: widget.size*5, bottom:widget.size* 5),
                        child: Text("Update"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: widget.size*20,
                  )
                ],
              ),
              SizedBox(
                height: widget.size*10,
              ),
            ],
          ),
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
    double Size=size(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              backButton(size:Size , child: SizedBox(width: Size*45),text:"Books Creator"),
              TextFieldContainer(child: TextFormField(
                controller: HeadingController,
                textInputAction: TextInputAction.next,
                style: TextStyle(color: Colors.white,fontSize: Size*20),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Heading',
                    hintStyle: TextStyle(color: Colors.white54)
                ),
              ),heading: "Heading",),
              TextFieldContainer(child: TextFormField(
                controller: DescriptionController,
                textInputAction: TextInputAction.next,
                style: TextStyle(color: Colors.white,fontSize: Size*20),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Description',
                    hintStyle: TextStyle(color: Colors.white54)
                ),
              ),heading: "Description",),
              TextFieldContainer(child: TextFormField(
                controller: PhotoUrlController,
                textInputAction: TextInputAction.next,
                style: TextStyle(color: Colors.white,fontSize: Size*20),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Image',
                    hintStyle: TextStyle(color: Colors.white54)
                ),
              ),heading: "Image",),
              TextFieldContainer(child: TextFormField(
                controller: AuthorController,
                textInputAction: TextInputAction.next,
                style: TextStyle(color: Colors.white,fontSize: Size*20),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Author',
                    hintStyle: TextStyle(color: Colors.white54)
                ),
              ),heading: "Author",),
              TextFieldContainer(child: TextFormField(
                controller: EditionController,
                textInputAction: TextInputAction.next,
                style: TextStyle(color: Colors.white,fontSize: Size*20),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Edition',
                    hintStyle: TextStyle(color: Colors.white54)
                ),
              ),heading: "Edition",),
              TextFieldContainer(child: TextFormField(
                controller: LinkController,
                textInputAction: TextInputAction.next,
                style: TextStyle(color: Colors.white,fontSize: Size*20),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'PDF Link',
                    hintStyle: TextStyle(color: Colors.white54)
                ),
              ),heading: "PDF Link",),

              SizedBox(
                height:Size* 20,
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
                          borderRadius: BorderRadius.circular(Size*15),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Padding(
                          padding:  EdgeInsets.only(
                              left:Size* 10, right: Size*10, top:Size* 5, bottom: Size*5),
                          child: Text("Back"),
                        ),
                      )),
                  SizedBox(
                    width: Size*10,
                  ),
                  InkWell(
                    onTap: () {
                      if (widget.id.isNotEmpty) {
                        FirebaseFirestore.instance
                            .collection(widget.branch)
                            .doc("Books")
                            .collection("CoreBooks")
                            .doc(widget.id)
                            .update({
                          "heading": HeadingController.text.trim(),
                          "edition": EditionController.text.trim(),
                          "author": AuthorController.text.trim(),
                          "link": LinkController.text.trim(),
                          "description": DescriptionController.text.trim(),
                          "image": PhotoUrlController.text.trim()
                        });
                        messageToOwner("Book Updated.\nBy : '${fullUserId()}' \n    Heading : ${HeadingController.text.trim()}\n    Description : ${DescriptionController.text.trim()}\n    Image : ${PhotoUrlController.text}\n    Author : ${AuthorController.text}\n    Edition : ${EditionController.text}\n    PDF Link : ${LinkController.text}\n **${widget.branch}");

                      } else {
                        createBook(
                            branch: widget.branch,
                            heading: HeadingController.text.trim(),
                            description: DescriptionController.text.trim(),
                            photoUrl: PhotoUrlController.text.trim(),
                            edition: EditionController.text.trim(),
                            Author: AuthorController.text.trim(),
                            link: LinkController.text.trim());
                        messageToOwner("Book Created.\nBy : '${fullUserId()}' \n    Heading : ${HeadingController.text.trim()}\n    Description : ${DescriptionController.text.trim()}\n    Image : ${PhotoUrlController.text}\n    Author : ${AuthorController.text}\n    Edition : ${EditionController.text}\n    PDF Link : ${LinkController.text}\n **${widget.branch}");

                      }
                      Navigator.pop(context);
                    },
                    child: widget.id.length < 3
                        ? Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(Size*15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(
                            left: Size*10, right: Size*10, top: Size*5, bottom: Size*5),
                        child: Text("Create"),
                      ),
                    )
                        : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(Size*15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(
                            left:Size* 10, right: Size*10, top: Size*5, bottom:Size* 5),
                        child: Text("Update"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Size*20,
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
  String id;
  String type;
  String Heading,subjectName;
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
        required this.subjectName,
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
  List list =["PDF","Image","YouTube","WebSite","More"];
  final HeadingController = TextEditingController();

  final PDFUrlController = TextEditingController();
  final PhotoUrlController = TextEditingController();
  final AuthorController = TextEditingController();
  final EditionController = TextEditingController();


  void AutoFill() {
    if(widget.type=="more")unit =widget.PDFUrl.split(";").first;
    if(widget.type=="unit")HeadingController.text = widget.Heading.split(";").last;
    if(widget.type=="more"||widget.type=="textbook")HeadingController.text = widget.Heading;
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
    double Size =size(context);
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              backButton(size: size(context),text: "Create Unit",child: SizedBox(width:Size* 45,)),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(widget.type=="unit")Padding(
                        padding:  EdgeInsets.only(left: Size*15, top:Size* 8,bottom: Size*10),
                        child: Text(
                          "Type Selected : $unit",
                          style: creatorHeadingTextStyle,
                        ),
                      ),
                      if(widget.type=="unit")SizedBox(
                        height:Size* 30,
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 6, // Display only top 5 items
                          itemBuilder: (context, int index) {
                            if(index==0) {
                              return Padding(
                                padding:  EdgeInsets.only(left:Size* 25),
                                child: InkWell(
                                  child: Container(
                                      decoration: BoxDecoration(

                                          color: unit=="Unknown"?Colors.white.withOpacity(0.6):Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(Size*10)
                                      ),
                                      child: Padding(
                                        padding:  EdgeInsets.symmetric(vertical:Size* 3,horizontal:Size* 8),
                                        child: Text("Unknown",style: TextStyle(color: Colors.white,fontSize: Size*25,fontWeight: FontWeight.w500),),
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
                                        borderRadius: BorderRadius.circular(Size*10)
                                    ),
                                    child: Padding(
                                      padding:  EdgeInsets.symmetric(vertical: Size*3,horizontal:Size* 8),
                                      child: Text("Unit $index",style: TextStyle(color: Colors.white,fontSize: Size*25,fontWeight: FontWeight.w500),),
                                    )),
                                onTap: (){
                                  setState(() {
                                    unit = "Unit $index";
                                  });
                                },
                              );
                            }
                          },
                          separatorBuilder: (context,index)=>SizedBox(width: Size*3,),),
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
                        padding:  EdgeInsets.only(left:Size* 15, top: Size*8,bottom: Size*10),
                        child: Text(
                          "Type Selected : $unit",
                          style: creatorHeadingTextStyle,
                        ),
                      ),
                      if(widget.type=="more")SizedBox(
                        height:Size* 30,
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: list.length, // Display only top 5 items
                          itemBuilder: (context, int index) {


                            return InkWell(
                              child: Container(
                                  decoration: BoxDecoration(

                                      color: unit==list[index] ?Colors.white.withOpacity(0.6):Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(Size*10)
                                  ),
                                  child: Padding(
                                    padding:  EdgeInsets.symmetric(vertical: Size*3,horizontal: Size*8),
                                    child: Text(list[index],style: TextStyle(color: Colors.white,fontSize:Size* 25,fontWeight: FontWeight.w500),),
                                  )),
                              onTap: (){
                                setState(() {
                                  unit = list[index];
                                });
                              },
                            );

                          },
                          separatorBuilder: (context,index)=>SizedBox(width:Size* 3,),),
                      ),
                      if(unit!="More")TextFieldContainer(
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
                        padding:  EdgeInsets.only(left: Size*15, top: Size*8),
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
                              padding: EdgeInsets.symmetric(horizontal: Size*16.0),
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
                              title: Text(DescriptionList[index],style: TextStyle(color: Colors.white,fontSize: Size*20),),
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
                                      child: Icon(Icons.move_up,size: Size*30,color: Colors.amber,),
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
                               EdgeInsets.only(left: Size*10, right: Size*10, top: Size*5, bottom: Size*5),
                              child:TextFieldContainer(child:TextFormField(
                                controller: _DescriptionController,
                                style: textFieldStyle(size(context)),
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter Description Here',
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
                                borderRadius: BorderRadius.circular(Size*14),
                              ),
                              child: Icon(!isEdit?Icons.add:Icons.save,size: Size*45,color: Colors.white,),
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
                        padding:  EdgeInsets.only(left: Size*15, top: Size*8),
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
                              padding: EdgeInsets.symmetric(horizontal:Size* 16.0),
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
                              title: Text(QuestionsList[index],style: TextStyle(color: Colors.white,fontSize:Size* 20),),
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
                                      child: Icon(Icons.move_up,size:Size* 30,color: Colors.amber,),
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
                               EdgeInsets.only(left: Size*10, right: Size*10, top:Size* 5, bottom:Size* 5),
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
                                borderRadius: BorderRadius.circular(Size*14),
                              ),
                              child: Icon(!isEdit?Icons.add:Icons.save,size:Size* 45,color: Colors.white,),
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
                        height: Size*10,
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
                                borderRadius: BorderRadius.circular(Size*15),
                                color: Colors.white.withOpacity(0.5),
                                border: Border.all(color: Colors.white),
                              ),
                              child: Padding(
                                padding:  EdgeInsets.only(
                                    left:Size* 10, right: Size*10, top: Size*5, bottom: Size*5),
                                child: Text("Back"),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Size*10,
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
                                  messageToOwner("Unit Created in ${widget.subjectName.split(";").last} (${widget.mode})\n By '${fullUserId()}' \n    Heading : ${HeadingController.text.trim()}\n    PDF Url : ${PDFUrlController.text.trim()}\n    Description : ${DescriptionList}\n    Questions : ${QuestionsList}\n **${widget.branch}" );

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
                                    "heading": unit+";"+HeadingController.text.trim(),
                                    "link": PDFUrlController.text.trim(),
                                    "description": DescriptionList.join(";"),
                                    "questions": QuestionsList.join(";")
                                  });
                                  messageToOwner("Unit Updated in ${widget.subjectName.split(";").last} (${widget.mode})\n By '${fullUserId()}' \n    Heading : ${HeadingController.text.trim()}\n    PDF Url : ${PDFUrlController.text.trim()}\n    Description : ${DescriptionList}\n    Questions : ${QuestionsList}\n **${widget.branch}" );

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
                                  messageToOwner("Text Book Created in ${widget.subjectName.split(";").last}\n By '${fullUserId()}' \n    Heading : ${HeadingController.text.trim()}\n    PDF Url : ${PDFUrlController.text.trim()}\n    Description : ${DescriptionList}\n    Photo Url : ${PhotoUrlController.text}\n    Author : ${AuthorController.text}\n    Edition : ${EditionController.text}\n **${widget.branch}" );

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
                                    "image": PhotoUrlController.text.trim(),
                                    "edition": EditionController.text.trim(),
                                    "link": PDFUrlController.text.trim(),
                                  });
                                  messageToOwner("Text Book Updated in ${widget.subjectName.split(";").last}\n By '${fullUserId()}' \n    Heading : ${HeadingController.text.trim()}\n    PDF Url : ${PDFUrlController.text.trim()}\n    Description : ${DescriptionList}\n    Photo Url : ${PhotoUrlController.text}\n    Author : ${AuthorController.text}\n    Edition : ${EditionController.text}\n **${widget.branch}" );

                                }
                              }
                              else{
                                if (widget.UnitId.length < 3) {

                                  createUnitsMore(
                                    branch: widget.branch,
                                    subjectsID: widget.id,
                                    mode: widget.mode,
                                    heading: HeadingController.text.trim(),
                                    description: DescriptionList.join(";"),
                                    link: unit+";"+PDFUrlController.text,

                                  );
                                  messageToOwner("More Created in ${widget.subjectName.split(";").last} (${widget.mode})\n By '${fullUserId()}' \n    Heading : ${HeadingController.text.trim()}\n    Url : ${unit}=>${PDFUrlController.text.trim()}\n    Description : ${DescriptionList}\n **${widget.branch}" );

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
                                    "link": unit+";"+PDFUrlController.text.trim(),
                                  });
                                  messageToOwner("More Updated in ${widget.subjectName.split(";").last} (${widget.mode})\n By '${fullUserId()}' \n    Heading : ${HeadingController.text.trim()}\n    Url : ${unit}=>${PDFUrlController.text.trim()}\n    Description : ${DescriptionList}\n **${widget.branch}" );

                                }
                              }
                              Navigator.pop(context);
                            },
                            child: widget.UnitId.length < 3
                                ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Size*15),
                                color: Colors.white.withOpacity(0.5),
                                border: Border.all(color: Colors.white),
                              ),
                              child: Padding(
                                padding:  EdgeInsets.only(
                                    left: Size*10, right: Size*10, top:Size* 5, bottom:Size* 5),
                                child: Text("Create"),
                              ),
                            )
                                : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Size*15),
                                color: Colors.white.withOpacity(0.5),
                                border: Border.all(color: Colors.white),
                              ),
                              child: Padding(
                                padding:  EdgeInsets.only(
                                    left: Size*10, right: Size*10, top:Size* 5, bottom: Size*5),
                                child: Text("Update"),
                              ),
                            ),
                          ),
                          SizedBox(
                            width:Size* 20,
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