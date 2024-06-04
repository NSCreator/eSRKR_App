import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srkr_study_app/functions.dart';
import 'package:srkr_study_app/settings/settings.dart';
import 'package:srkr_study_app/subjects/convertors.dart';
import 'package:srkr_study_app/subjects/subjects.dart';
import 'package:srkr_study_app/get_all_data.dart';


class favoritesSubjects extends StatefulWidget {
    


  @override
  State<favoritesSubjects> createState() => _favoritesSubjectsState();
}

class _favoritesSubjectsState extends State<favoritesSubjects> {
  List<SubjectConverter> subjects = [];
  List<SubjectConverter> labSubjects = [];
  List<SubjectConverter> regSubjects = [];
  List<SubjectConverter> regLabSubjects = [];

  getData() async {
    subjects = await SubjectPreferences.get();
    labSubjects = await LabSubjectPreferences.get();
    try {
      BranchStudyMaterialsConverter? data =
          await getBranchStudyMaterials( false);
      if (data != null) {
        regSubjects = data.subjects;
        regLabSubjects = data.labSubjects;
      } else {
        print("No data found for the specified branch.");
      }
    } catch (e) {
      print("Error getting subjects: $e");
    }
    setState(() {
      subjects;
      labSubjects;
      regSubjects;
      regLabSubjects;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
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
              if (subjects.isNotEmpty)
                Heading(heading: "Subjects"),
              if (subjects.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 16 / 6,
                      mainAxisSpacing: 8.0,

                    ),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: subjects.length,
                    itemBuilder: (context, int index) {
                      final data = subjects[index];
                      return InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                              const Duration(milliseconds: 300),
                              pageBuilder: (context, animation,
                                  secondaryAnimation) =>
                                  subjectUnitsData(

                                    mode:  true ,
                                    data: data,
                                  ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                final fadeTransition = FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );

                                return Container(
                                  color: Colors.black
                                      .withOpacity(animation.value),
                                  child: AnimatedOpacity(
                                    duration:
                                    Duration(milliseconds: 300),
                                    opacity:
                                    animation.value.clamp(0.3, 1.0),
                                    child: fadeTransition,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors. black.withOpacity(0.04),
                                Colors. black.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.all(2.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 85,
                                      padding: EdgeInsets.symmetric(
                                          vertical:   5),
                                      decoration: BoxDecoration(
                                          color: Colors. black.withOpacity(0.1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(  20))),
                                      child: Center(
                                        child: Text(
                                          data.heading.short,
                                          style: TextStyle(
                                            fontSize:   22.0,
                                            color: Colors. black,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "test"
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                      onTap: () async {
                                        await SubjectPreferences.delete(data.id);
                                        getData();
                                      },
                                    )
                                  ],
                                ),
                                if(data.heading.full.isNotEmpty)Text(
                                  data.heading.full,
                                  style: TextStyle(
                                      color: Colors. black, fontSize: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.library_books,
                          color: Colors. black26,
                          size: 80,
                        ),
                        Text(
                          "Add Subjects",
                          style:
                          TextStyle(color: Colors. black38, fontSize: 25),
                        )
                      ],
                    ),
                  ),
                ),
              if (labSubjects.isNotEmpty)
                Heading(heading: "Lab Subjects"),
              if (labSubjects.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 16 / 6,
                      mainAxisSpacing: 8.0,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: labSubjects.length,
                    itemBuilder: (context, int index) {
                      final data = labSubjects[index];
                      return InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                              const Duration(milliseconds: 300),
                              pageBuilder: (context, animation,
                                  secondaryAnimation) =>
                                  subjectUnitsData(


                                    mode:  false ,
                                    data: data,
                                  ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                final fadeTransition = FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );

                                return Container(
                                  color: Colors.black
                                      .withOpacity(animation.value),
                                  child: AnimatedOpacity(
                                    duration:
                                    Duration(milliseconds: 300),
                                    opacity:
                                    animation.value.clamp(0.3, 1.0),
                                    child: fadeTransition,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors. black.withOpacity(0.04),
                                Colors. black.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.all(2.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 85,
                                      padding: EdgeInsets.symmetric(
                                          vertical:   5),
                                      decoration: BoxDecoration(
                                          color: Colors. black.withOpacity(0.1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(  20))),
                                      child: Center(
                                        child: Text(
                                          data.heading.short,
                                          style: TextStyle(
                                              fontSize:   22.0,
                                              color: Colors. black,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "test"
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                      onTap: () async {
                                        await LabSubjectPreferences.delete(data.id);
                                        getData();
                                      },
                                    )
                                  ],
                                ),
                                if(data.heading.full.isNotEmpty)Text(
                                  data.heading.full,
                                  style: TextStyle(
                                      color: Colors. black, fontSize: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.library_books,
                          color: Colors. black26,
                          size: 80,
                        ),
                        Text(
                          "Add Lab Subjects",
                          style:
                          TextStyle(color: Colors. black38, fontSize: 25),
                        )
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SubjectPreferences {
  static const String key = "Subjects";

  static Future<void> save(List<SubjectConverter> subjects) async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsJson = subjects.map((subject) => subject.toJson()).toList();
    final subjectsString = jsonEncode(subjectsJson);
    await prefs.setString(key, subjectsString);
  }

  // Get a list of subjects from shared preferences
  static Future<List<SubjectConverter>> get() async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsString = prefs.getString(key);
    if (subjectsString != null) {
      final subjectsJson = jsonDecode(subjectsString) as List;
      return subjectsJson
          .map((json) => SubjectConverter.fromJson(json))
          .toList();
    } else {
      return [];
    }
  }

  // Add a new subject to shared preferences
  static Future<void> add(SubjectConverter newSubject) async {
    final List<SubjectConverter> subjects = await get();
    subjects.add(newSubject);
    await save(subjects);
  }

  // Delete a subject from shared preferences
  static Future<void> delete(String subjectId) async {
    List<SubjectConverter> subjects = await get();
    subjects.removeWhere((subject) => subject.id == subjectId);
    await save(subjects);
  }
}

class LabSubjectPreferences {
  static const String key = "labSubjects";

  static Future<void> save(List<SubjectConverter> subjects) async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsJson = subjects.map((subject) => subject.toJson()).toList();
    final subjectsString = jsonEncode(subjectsJson);
    await prefs.setString(key, subjectsString);
  }

  // Get a list of subjects from shared preferences
  static Future<List<SubjectConverter>> get() async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsString = prefs.getString(key);
    if (subjectsString != null) {
      final subjectsJson = jsonDecode(subjectsString) as List;
      return subjectsJson
          .map((json) => SubjectConverter.fromJson(json))
          .toList();
    } else {
      return [];
    }
  }

  // Add a new subject to shared preferences
  static Future<void> add(SubjectConverter newSubject) async {
    final List<SubjectConverter> subjects = await get();
    subjects.add(newSubject);
    await save(subjects);
  }

  // Delete a subject from shared preferences
  static Future<void> delete(String subjectId) async {
    List<SubjectConverter> subjects = await get();
    subjects.removeWhere((subject) => subject.id == subjectId);
    await save(subjects);
  }
}
