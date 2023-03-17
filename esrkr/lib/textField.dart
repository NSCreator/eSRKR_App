// ignore_for_file: camel_case_types, non_constant_identifier_names, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'arduino.dart';
import 'electronicProjects.dart';

class createNewOne extends StatefulWidget {
  String heading;
  String description;
  String photoUrl;
  String videoUrl;
  String circuitDiagram;
  String projectId;

  createNewOne({Key? key, this.circuitDiagram = "", this.description = "", this.heading = "", this.photoUrl = "", this.videoUrl = "", this.projectId = ""}) : super(key: key);

  @override
  State<createNewOne> createState() => _createNewOneState();
}

class _createNewOneState extends State<createNewOne> {
  final HeadingController = TextEditingController();
  final DescriptionController = TextEditingController();
  final PhotoUrl = TextEditingController();
  final VideoUrl = TextEditingController();
  final CircuitDiagram = TextEditingController();

  void AutoFill() {
    HeadingController.text = widget.heading;
    DescriptionController.text = widget.description;
    PhotoUrl.text = widget.photoUrl;
    VideoUrl.text = widget.videoUrl;
    CircuitDiagram.text = widget.circuitDiagram;
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
    PhotoUrl.dispose();
    VideoUrl.dispose();
    CircuitDiagram.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(53, 166, 204, 1),
                Color.fromRGBO(24, 45, 74, 1),
                Color.fromRGBO(21, 47, 61, 1)
              ]),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Data Creator"),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: HeadingController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Heading',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: DescriptionController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Description',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: DescriptionController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Photo Url',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: DescriptionController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Pin Diagram Url',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: DescriptionController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Video Url',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: DescriptionController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Source Name',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: DescriptionController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Source Url',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: DescriptionController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Creator Name',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: DescriptionController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Creator Photo',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextFormField(
                            controller: DescriptionController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Main Features',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class electronicProjectsCreator extends StatefulWidget {
  String heading;
  String description;
  String photoUrl;
  String videoUrl;
  String circuitDiagram;
  String projectId;

  electronicProjectsCreator({this.circuitDiagram = "", this.description = "", this.heading = "", this.photoUrl = "", this.videoUrl = "", this.projectId = ""});

  @override
  State<electronicProjectsCreator> createState() => _electronicProjectsCreatorState();
}

class _electronicProjectsCreatorState extends State<electronicProjectsCreator> {
  final HeadingController = TextEditingController();
  final DescriptionController = TextEditingController();
  final PhotoUrl = TextEditingController();
  final VideoUrl = TextEditingController();
  final CircuitDiagram = TextEditingController();

  void AutoFill() {
    HeadingController.text = widget.heading;
    DescriptionController.text = widget.description;
    PhotoUrl.text = widget.photoUrl;
    VideoUrl.text = widget.videoUrl;
    CircuitDiagram.text = widget.circuitDiagram;
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
    PhotoUrl.dispose();
    VideoUrl.dispose();
    CircuitDiagram.dispose();
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
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              color: Color.fromRGBO(7, 7, 23, 1.0),
            ),
          ),
          title: const Text(
            "Create Electronic Projects",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
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
            const Padding(
              padding:  EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Project Heading",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Heading',
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding:  EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Project Description",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Description or Full name',
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Project Photo Url",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    controller: PhotoUrl,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'PDF Name',
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding:  EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Video Url (--YouTub--)",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
                    controller: VideoUrl,
                    textInputAction: TextInputAction.next,
                    decoration:const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'PDF Url',
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding:  EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Circuit Diagram",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
                    controller: CircuitDiagram,
                    textInputAction: TextInputAction.next,
                    decoration:const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'PDF Url',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Spacer(),
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
                    child: const Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                      child: Text("Back"),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    if (widget.projectId.length < 3) {
                      createelectronicProjects(
                        photoUrl: "",
                        circuitDiagram: "",
                        videoUrl: "",
                        description: DescriptionController.text.trim(),
                        heading: HeadingController.text.trim(),
                        creatorPhoto: "",
                        creator: "",
                        source: "",
                        sourceName: ""

                      );
                    } else {
                      FirebaseFirestore.instance.collection("electronicProjects").doc(widget.projectId).update({
                        "Heading": HeadingController.text.trim(),
                        "PDFSize": CircuitDiagram.text.trim(),
                        "PDFLink": VideoUrl.text.trim(),
                        "Description": DescriptionController.text.trim(),
                        "Date": "getTime",
                        "PDFName": PhotoUrl.text.trim()
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: widget.projectId.length < 3
                      ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.5),
                      border: Border.all(color: Colors.white),
                    ),
                    child: const Padding(
                      padding:  EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                      child: Text("Create"),
                    ),
                  )
                      : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.5),
                      border: Border.all(color: Colors.white),
                    ),
                    child: const Padding(
                      padding:  EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                      child: Text("Update"),
                    ),
                  ),
                ),
                const SizedBox(
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

class arduinoBoardCreator extends StatefulWidget {
  String heading;
  String description;
  String photoUrl;
  String videoUrl;
  String circuitDiagram;
  String projectId;

  arduinoBoardCreator({Key? key, this.circuitDiagram = "", this.description = "", this.heading = "", this.photoUrl = "", this.videoUrl = "", this.projectId = ""}) : super(key: key);

  @override
  State<arduinoBoardCreator> createState() => _arduinoBoardCreatorState();
}

class _arduinoBoardCreatorState extends State<arduinoBoardCreator> {
  final nameController = TextEditingController();
  final DescriptionController = TextEditingController();
  final PhotoUrl = TextEditingController();
  final VideoUrl = TextEditingController();
  final CircuitDiagram = TextEditingController();

  void AutoFill() {
    nameController.text = widget.heading;
    DescriptionController.text = widget.description;
    PhotoUrl.text = widget.photoUrl;
    VideoUrl.text = widget.videoUrl;
    CircuitDiagram.text = widget.circuitDiagram;
  }

  @override
  void initState() {
    AutoFill();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    DescriptionController.dispose();
    PhotoUrl.dispose();
    VideoUrl.dispose();
    CircuitDiagram.dispose();
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
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              color: Color.fromRGBO(7, 7, 23, 1.0),
            ),
          ),
          title: const Text(
            "Create Electronic Projects",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
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
            const Padding(
              padding:  EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Project Heading",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    decoration:const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Heading',
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Project Description",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Description or Full name',
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding:  EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Project Photo Url",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    controller: PhotoUrl,
                    textInputAction: TextInputAction.next,
                    decoration:const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'PDF Name',
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Video Url (--YouTub--)",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
                    controller: VideoUrl,
                    textInputAction: TextInputAction.next,
                    decoration:const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'PDF Url',
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding:  EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Circuit Diagram",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
                    controller: CircuitDiagram,
                    textInputAction: TextInputAction.next,
                    decoration:const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'PDF Url',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Spacer(),
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
                    child: const Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                      child: Text("Back"),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    if (widget.projectId.length < 3) {
                      createarduinoBoards(
                        name: nameController.text.trim(),
                        description: DescriptionController.text.trim(),
                        mainFeatures: "",
                        pinDiagram: "",
                        photoUrl: PhotoUrl.text.trim(),
                        );
                    } else {
                      FirebaseFirestore.instance.collection('arduino')
                          .doc("arduinoProjects")
                          .collection("projects").doc(widget.projectId).update({
                        "heading": nameController.text.trim(),
                        "PDFSize": CircuitDiagram.text.trim(),
                        "videoUrl": VideoUrl.text.trim(),
                        "description": DescriptionController.text.trim(),
                        "photoUrl": PhotoUrl.text.trim()
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: widget.projectId.length < 3
                      ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.5),
                      border: Border.all(color: Colors.white),
                    ),
                    child:const Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                      child: Text("Create"),
                    ),
                  )
                      : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.5),
                      border: Border.all(color: Colors.white),
                    ),
                    child:const Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                      child: Text("Update"),
                    ),
                  ),
                ),
                const SizedBox(
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


class arduinoProjectCreator extends StatefulWidget {
  String heading;
  String description;
  String photoUrl;
  String videoUrl;
  String circuitDiagram;
  String projectId;

  arduinoProjectCreator({Key? key, this.circuitDiagram = "", this.description = "", this.heading = "", this.photoUrl = "", this.videoUrl = "", this.projectId = ""}) : super(key: key);

  @override
  State<arduinoProjectCreator> createState() => _arduinoProjectCreatorState();
}

class _arduinoProjectCreatorState extends State<arduinoProjectCreator> {
  final HeadingController = TextEditingController();
  final DescriptionController = TextEditingController();
  final PhotoUrl = TextEditingController();
  final VideoUrl = TextEditingController();
  final CircuitDiagram = TextEditingController();

  void AutoFill() {
    HeadingController.text = widget.heading;
    DescriptionController.text = widget.description;
    PhotoUrl.text = widget.photoUrl;
    VideoUrl.text = widget.videoUrl;
    CircuitDiagram.text = widget.circuitDiagram;
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
    PhotoUrl.dispose();
    VideoUrl.dispose();
    CircuitDiagram.dispose();
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
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              color: Color.fromRGBO(7, 7, 23, 1.0),
            ),
          ),
          title: const Text(
            "Create Electronic Projects",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
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
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Project Heading",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Heading',
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Project Description",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Description or Full name',
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding:  EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Project Photo Url",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    controller: PhotoUrl,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'PDF Name',
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding:  EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Video Url (--YouTub--)",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
                    controller: VideoUrl,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'PDF Url',
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding:  EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Circuit Diagram",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
                    controller: CircuitDiagram,
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
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                      child: Text("Back"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    if (widget.projectId.length < 3) {
                      createarduinoProjects(heading: HeadingController.text.trim(),
                      description: DescriptionController.text.trim(),
                      creator: "",
                      photoUrl: PhotoUrl.text.trim(),
                        videoUrl: VideoUrl.text.trim(),

                      );
                    } else {
                      FirebaseFirestore.instance.collection('arduino')
                        .doc("arduinoProjects")
                        .collection("projects").doc(widget.projectId).update({
                        "heading": HeadingController.text.trim(),
                        "PDFSize": CircuitDiagram.text.trim(),
                        "videoUrl": VideoUrl.text.trim(),
                        "description": DescriptionController.text.trim(),
                        "photoUrl": PhotoUrl.text.trim()
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: widget.projectId.length < 3
                      ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.5),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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




class arduinoProjectrequiredComponentCreator extends StatefulWidget {
  String heading;
  String index;
  String photoUrl;
  String projectId;

  arduinoProjectrequiredComponentCreator({this.heading = "", this.photoUrl = "",this.index="", this.projectId = ""});

  @override
  State<arduinoProjectrequiredComponentCreator> createState() => _arduinoProjectrequiredComponentCreatorState();
}

class _arduinoProjectrequiredComponentCreatorState extends State<arduinoProjectrequiredComponentCreator> {
  final HeadingController = TextEditingController();
  final indexController = TextEditingController();
  final description = TextEditingController();


  void AutoFill() {
    HeadingController.text = widget.heading;
    indexController.text = widget.index;
    description.text = widget.photoUrl;
  }

  @override
  void initState() {
    AutoFill();
    super.initState();
  }

  @override
  void dispose() {
    HeadingController.dispose();
    indexController.dispose();
    description.dispose();
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
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              color: Color.fromRGBO(7, 7, 23, 1.0),
            ),
          ),
          title: const Text(
            "Create Required Component",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
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
                "Table of Content Heading",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    controller: description,
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
              padding: const EdgeInsets.only(left: 15, top: 8),
              child: Text(
                "Index",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    controller: indexController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Index',
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
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                      child: Text("Back"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                    onTap: () {

                      createelectronicProjectTableOfContent(index:indexController.text.trim(),projectId: widget.projectId,heading: HeadingController.text.trim());

                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white.withOpacity(0.5),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                        child: Text("Create"),
                      ),
                    )
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
