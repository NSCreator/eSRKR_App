import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:srkr_study_app/HomePage.dart';
import 'package:srkr_study_app/TextField.dart';
import 'SubPages.dart';

class MyAppq extends StatefulWidget {
  final String branch;
  final String reg;
  final double size;


  const MyAppq(
      {Key? key,
      required this.branch,
      required this.reg,
      required this.size})
      : super(key: key);

  @override
  State<MyAppq> createState() => _MyAppqState();
}

class _MyAppqState extends State<MyAppq> {
  String name = "";

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
  Widget build(BuildContext context) =>Scaffold(body: SafeArea(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: widget.size * 20,
              vertical: widget.size * 5),
          child: Row(
            children: [
              InkWell(
                child: Padding(
                  padding:  EdgeInsets.only(right: widget.size*10),
                  child: Icon(Icons.arrow_back,color: Colors.white,size: widget.size*30,),
                ),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
              Flexible(
                  child: TextFieldContainer(child:
                  TextField(
                    onChanged: (val) {
                      setState(() {
                        name = val;
                      });
                    },
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: widget.size * 20),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: widget.size * 20,
                      ),
                      border: InputBorder.none,
                      hintText: 'Search Bar',
                      hintStyle: TextStyle(
                          color: Colors.white60,
                          fontSize: widget.size * 20),
                    ),
                  ))
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              if(name.isNotEmpty)StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(widget.branch)
                    .doc("Subjects")
                    .collection("Subjects")
                    .snapshots(),
                builder: (context, snapshots) {
                  return (snapshots.connectionState ==
                      ConnectionState.waiting)
                      ? Center(
                    child: CircularProgressIndicator(),
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: widget.size * 10,
                                bottom: widget.size * 3,
                                top: widget.size * 5),
                            child: InkWell(
                              child: Text(
                                "Subjects",
                                style: TextStyle(
                                    color: Colors.purpleAccent,
                                    fontSize: widget.size * 20),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Subjects(
                                          branch: widget.branch,
                                          reg: widget.reg,
                                          width: widget.size,
                                          height: widget.size,
                                          size: widget.size,
                                        )));
                              },
                            ),
                          ),
                          ListView.builder(
                          physics:
                          NeverScrollableScrollPhysics(),
                          itemCount:
                          snapshots.data!.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var data = snapshots
                                .data!.docs[index]
                                .data() as Map<String, dynamic>;

                            if (data['heading']
                                .toString().split(";").first
                                .toLowerCase()
                                .startsWith(
                                name.toLowerCase())||data['heading']
                                .toString().split(";").last
                                .toLowerCase()
                                .startsWith(
                                name.toLowerCase())||data['regulation']
                                .toString()
                                .toLowerCase()
                                .startsWith(
                                name.toLowerCase())) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: widget.size * 10,
                                        vertical: widget.size * 1),
                                    child: InkWell(
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.black38,
                                            borderRadius:
                                            BorderRadius.all(
                                                Radius.circular(
                                                    widget.size *
                                                        20))),
                                        child:
                                        Padding(
                                          padding:  EdgeInsets.symmetric(horizontal: widget.size *10,vertical: widget.size *5),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                data['heading'].toString().replaceAll(";", " - "),
                                                style:
                                                TextStyle(
                                                  fontSize:
                                                  widget.size *
                                                      20.0,
                                                  color: Colors
                                                      .white,
                                                  fontWeight:
                                                  FontWeight
                                                      .w600,
                                                ),
                                              ),
                                              SizedBox(
                                                height: widget
                                                    .size *
                                                    2,
                                              ),
                                              Text(
                                                data[
                                                'description'],
                                                style:
                                                TextStyle(
                                                  fontSize:
                                                  widget.size *
                                                      13.0,
                                                  color: Colors.white60,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    subjectUnitsData(
                                                      reg: data[
                                                      "regulation"],

                                                      size: widget
                                                          .size,
                                                      branch: widget
                                                          .branch,
                                                      ID: data[
                                                      'id'],
                                                      mode:
                                                      "Subjects",
                                                      name: data[
                                                      "heading"],
                                                      description: data[
                                                      'description'], creator: data["creator"]??"",

                                                    )));
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Container(
                            );
                          }),
                        ],
                      );
                },
              ),

              if(name.isNotEmpty)StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(widget.branch)
                    .doc("LabSubjects")
                    .collection("LabSubjects")
                    .snapshots(),
                builder: (context, snapshots) {
                  return (snapshots.connectionState ==
                      ConnectionState.waiting)
                      ? Center(
                    child: CircularProgressIndicator(),
                  )
                      : ListView.builder(
                      physics:
                      NeverScrollableScrollPhysics(),
                      itemCount:
                      snapshots.data!.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var data = snapshots
                            .data!.docs[index]
                            .data() as Map<String, dynamic>;

                        if (data['heading']
                            .toString().split(";").first
                            .toLowerCase()
                            .startsWith(
                            name.toLowerCase())||data['heading']
                            .toString().split(";").last
                            .toLowerCase()
                            .startsWith(
                            name.toLowerCase())||data['regulation']
                            .toString()
                            .toLowerCase()
                            .startsWith(
                            name.toLowerCase())) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: widget.size * 10,
                                    bottom: widget.size * 3,
                                    top: widget.size * 20),
                                child: InkWell(
                                  child: Text(
                                    "Lab Subjects",
                                    style: TextStyle(
                                        color: Colors.purpleAccent,
                                        fontSize: widget.size * 20),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LabSubjects(
                                              branch: widget.branch,
                                              reg: widget.reg,

                                              size: widget.size,
                                            )));
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: widget.size * 10,
                                    vertical: widget.size * 1),
                                child: InkWell(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.black38,
                                        borderRadius:
                                        BorderRadius.all(
                                            Radius.circular(
                                                widget.size *
                                                    20))),
                                    child:
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: widget.size *15,vertical: widget.size *8),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            data['heading'],
                                            style:
                                            TextStyle(
                                              fontSize:
                                              widget.size *
                                                  20.0,
                                              color: Colors
                                                  .white,
                                              fontWeight:
                                              FontWeight
                                                  .w600,
                                            ),
                                          ),
                                          SizedBox(
                                            height: widget
                                                .size *
                                                2,
                                          ),
                                          Text(
                                            data[
                                            'description'],
                                            style:
                                            TextStyle(
                                              fontSize:
                                              widget.size *
                                                  13.0,
                                              color: Colors.white60,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                subjectUnitsData(

                                                  reg: data[
                                                  "regulation"],
                                                  size: widget
                                                      .size,
                                                  branch: widget
                                                      .branch,
                                                  ID: data[
                                                  'id'],
                                                  mode:
                                                  "LabSubjects",
                                                  name: data[
                                                  "heading"],
                                                  description: data[
                                                  'description'], creator: data["creator"]??"",

                                                )));
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                        return Container();
                      });
                },
              ),
if(name.isEmpty)Padding(
    padding:  EdgeInsets.all(widget.size *100.0),
    child:   Row(
      children: [
        Expanded(
          child: Padding(
            padding:  EdgeInsets.all(widget.size *8.0),
            child: InkWell(
              child: Container(
                height: widget.size * 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.size * 20),
                  color: Colors.white.withOpacity(0.1),
                ),
                child: Center(
                  child: Text(
                    "SUB",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: widget.size * 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: "test"),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Subjects(
                          branch: widget.branch,
                          reg: widget.reg,
                          width: widget.size,
                          height: widget.size,
                          size: widget.size,
                        ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      final fadeTransition = FadeTransition(
                        opacity: animation,
                        child: child,
                      );

                      return Container(
                        color: Colors.black.withOpacity(animation.value),
                        child: AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: animation.value.clamp(0.3, 1.0),
                            child: fadeTransition),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),

        Expanded(
          child: Padding(
            padding:  EdgeInsets.all(widget.size *8.0),
            child: InkWell(
              child: Container(
                height: widget.size * 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.size * 20),
                  color: Colors.white.withOpacity(0.1),
                ),
                child: Center(
                  child: Text(
                    "LAB",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: widget.size * 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: "test"),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        LabSubjects(
                          branch: widget.branch,
                          reg: widget.reg,

                          size: widget.size,
                        ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      final fadeTransition = FadeTransition(
                        opacity: animation,
                        child: child,
                      );

                      return Container(
                        color: Colors.black.withOpacity(animation.value),
                        child: AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: animation.value.clamp(0.3, 1.0),
                            child: fadeTransition),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ),
),
              SizedBox(
                height: widget.size *50,
              )
            ],
          ),
        ),

      ],
    ),
  ));
}


