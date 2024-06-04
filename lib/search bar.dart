// @immutable
import 'package:flutter/material.dart';
import 'package:srkr_study_app/functions.dart';
import 'package:srkr_study_app/get_all_data.dart';
import 'package:srkr_study_app/settings/settings.dart';
import 'TextField.dart';
import 'subjects/subjects.dart';

class SearchPage extends StatefulWidget {
  BranchStudyMaterialsConverter data;


  SearchPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String name = "";

  @override
  Widget build(BuildContext context) => Scaffold(

          body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backButton(),
            Heading(heading: "Search Bar"),
            Padding(
              padding: EdgeInsets.symmetric( vertical: 5),
              child: TextFieldContainer(
                  child: TextField(

                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
                style: TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white54,
                    size: 30,
                  ),
                  border: InputBorder.none,
                  hintText: 'Search Bar',
                  hintStyle: TextStyle(color: Colors.white54, fontSize: 20),
                ),
              )),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Subjects(

                                            subjects: widget.data.subjects,
                                            mode: true,
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
                                  name.isEmpty) {
                                return InkWell(
                                  child: Row(
                                    children: [
                                      Expanded(child: Container(
                                        margin: EdgeInsets.only(
                                            left: 10, top: 2,bottom: 2),
                                        padding: EdgeInsets.symmetric( vertical: 5),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${data.heading.short}",
                                          style: TextStyle(
                                            fontSize: 25.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),),
                                      Expanded(
                                        flex:3,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 2),
                                          padding: EdgeInsets.only(
                                              left: 15, top: 5,bottom: 5),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.05),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${data.heading.full}",
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                subjectUnitsData(
                                                  mode: true,
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Subjects(

                                        subjects: widget.data.labSubjects,
                                        mode: false,
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
                                  name.isEmpty) {
                                return InkWell(
                                  child: Row(
                                    children: [
                                      Expanded(child: Container(
                                        margin: EdgeInsets.only(
                                            left: 10, top: 2,bottom: 2),
                                        padding: EdgeInsets.symmetric( vertical: 5),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.05),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${data.heading.short}",
                                          style: TextStyle(
                                            fontSize: 25.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),),
                                      Expanded(
                                        flex:3,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 2),
                                          padding: EdgeInsets.only(
                                              left: 10, top: 5,bottom: 5),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.05),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${data.heading.full}",
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                subjectUnitsData(
                                                  mode: false,
                                                  data: data,
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
