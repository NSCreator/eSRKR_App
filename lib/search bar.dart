import 'package:flutter/material.dart';
import 'package:srkr_study_app/test.dart';
import 'TextField.dart';
import 'subjects.dart';

class MyAppq extends StatefulWidget {
  BranchStudyMaterialsConvertor data;
  final String branch;
  final String reg;

  MyAppq({
    Key? key,
    required this.branch,
    required this.data,
    required this.reg,
  }) : super(key: key);

  @override
  State<MyAppq> createState() => _MyAppqState();
}

class _MyAppqState extends State<MyAppq> {
  String name = "";

  @override
  Widget build(BuildContext context) => Scaffold(

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  InkWell(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 30,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Flexible(
                      child: TextFieldContainer(
                          child: TextField(
                    onChanged: (val) {
                      setState(() {
                        name = val;
                      });
                    },
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      hintText: 'Search Bar',
                      hintStyle: TextStyle(color: Colors.black54, fontSize: 20),
                    ),
                  ))),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10, bottom: 3, top: 5),
                          child: InkWell(
                            child: Text(
                              "Subjects",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Subjects(
                                            branch: widget.branch,
                                            reg: widget.reg,
                                            subjects: widget.data.subjects,
                                            syllabusModelPaper:
                                                widget.data.regSylMP,
                                          )));
                            },
                          ),
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.data.subjects.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var data = widget.data.subjects[index];
                              if (data.heading.short
                                      .toLowerCase()
                                      .startsWith(name.toLowerCase()) ||
                                  data.heading.full
                                      .toLowerCase()
                                      .startsWith(name.toLowerCase()) ||
                                  data.regulation
                                      .contains(name.toUpperCase()) ||
                                  name.isEmpty) {
                                return InkWell(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${data.heading.short} - ${data.heading.full}",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black,
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
                                                  reg: widget.reg,
                                                  branch: widget.branch,
                                                  mode: true,
                                                  syllabusModelPaper:
                                                      widget
                                                          .data.regSylMP,
                                                  data: data,
                                                )));
                                  },
                                );
                              }
                              return Container();
                            }),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, bottom: 3, top: 20),
                          child: InkWell(
                            child: Text(
                              "Lab Subjects",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LabSubjects(
                                            branch: widget.branch,
                                            reg: widget.reg,
                                            labSubjects:
                                                widget.data.labSubjects,
                                            syllabusModelPaper:
                                                widget.data.regSylMP,
                                          )));
                            },
                          ),
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.data.labSubjects.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var data = widget.data.labSubjects[index];

                              if (data.heading.short
                                      .toLowerCase()
                                      .startsWith(name.toLowerCase()) ||
                                  data.heading.full
                                      .toLowerCase()
                                      .startsWith(name.toLowerCase()) ||
                                  data.regulation
                                      .contains(name.toUpperCase()) ||
                                  name.isEmpty) {
                                return InkWell(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${data.heading.short} - ${data.heading.full}",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black,
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
                                                  branch: widget.branch,
                                                  mode: false,
                                                  data: data,
                                                  reg: widget.reg,
                                                  syllabusModelPaper:
                                                      widget.data.regSylMP,
                                                )));
                                  },
                                );
                              }
                              return Container();
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
}
