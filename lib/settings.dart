// ignore_for_file: use_build_context_synchronously, camel_case_types, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../HomePage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_version/new_version.dart';
import 'TextField.dart';
import 'add subjects.dart';
import 'auth_page.dart';
import 'colorsConstant.dart';

int currentIndex = 0;
String branchTitle = "none";
String className = "Year";
String imageUrl = "https://drive.google.com/uc?export=view&id=12yZolNq49Fikqi-lh67f7sxQelEb_3Zt";

class settings extends StatefulWidget {
  const settings({Key? key}) : super(key: key);

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  String localVersion = "";
  final InputController = TextEditingController();
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String branchTitleOut = prefs.getString('branchTitle') ?? "ECE";
    String? classNameOut = prefs.getString('class');
    String? branchImageUrl = prefs.getString('branchUrl');

    setState(() {
      branchTitle = branchTitleOut;
      className = classNameOut!;
      imageUrl = branchImageUrl!;
    });
  }

  @override
  void initState() {
    super.initState();
    getStringValuesSF();
    final newVersion = NewVersion(
      androidId: "https://play.google.com/store/apps/details?id=com.nimmalasujith.esrkr",
    );
    advancedStatusCheck(newVersion);
  }

  advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();

    if (status != null) {
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'UPDATE!',
        dialogText: 'Please update the e-SRKR from " + "${status.localVersion} to ${status.storeVersion}',
        dismissButtonText: "Not Now",
        updateButtonText: "Lets update",
        dismissAction: () {
          Navigator.pop(context);
        },
      );
      setState(() {
        localVersion = status.localVersion;
      });
    }
  }

  List<mainSettings> SettingsData = [
    mainSettings(
      'Report',
    ),
    mainSettings(
      'About',
    ),
    mainSettings(
      'Privacy Policy',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/01/c7/f7/01c7f72511cc6ce7858e65b45d4f8c9c.jpg",),fit: BoxFit.fill)
        ),
        child: Container(
          color: Colors.black.withOpacity(0.8),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color:  Colors.black,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade500,
                                offset: Offset(4.0,4.0),
                                blurRadius: 50,
                                spreadRadius: 0.5,
                              ),
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(-4.0,-4.0),
                                blurRadius: 15,
                                spreadRadius: 0.5,
                              ),

                            ],
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://images.pond5.com/blue-burning-eagle-animated-logo-footage-102505417_iconl.jpeg",
                              ),
                              fit: BoxFit.cover,
                            ),),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 15,),
                              Center(
                                child: Text(
                                  branchTitle,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(220, 220, 227, 1),
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              InkWell(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 44),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white30,
                                    backgroundImage: NetworkImage(imageUrl),
                                    radius: 30,
                                  ),
                                ),
                                onTap: () => _showSecondPage(context, "https://drive.google.com/uc?export=view&id=1Mzx8ioES4Y10-xQqEIiQlMl09N8WDk-M"),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only( left: 20),
                              child: Text(
                                "User :",
                                style: TextStyle(color: Colors.orange,fontSize: 20,fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only( left: 3),
                              child: Text(
                                fullUserId(),
                                style: TextStyle(color: Colors.blue,fontSize: 18,fontWeight: FontWeight.w500),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only( right: 20),
                              child: InkWell(
                                  child: Text(
                                    "Log Out",
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 24),
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          backgroundColor: Colors.black.withOpacity(0.3),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          elevation: 16,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.tealAccent),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: ListView(
                                              shrinkWrap: true,
                                              children: <Widget>[
                                                SizedBox(height: 10),
                                                SizedBox(height: 5),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 15),
                                                  child: Text(
                                                    "Do you want Log Out",
                                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Center(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Spacer(),
                                                      InkWell(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.black26,
                                                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                                                            borderRadius: BorderRadius.circular(25),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                                            child: Text("Back",style: TextStyle(color: Colors.white),),
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      InkWell(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            border: Border.all(color: Colors.black),
                                                            borderRadius: BorderRadius.circular(25),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                                            child: Text(
                                                              "Log Out",
                                                              style: TextStyle(color: Colors.white),
                                                            ),
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          FirebaseAuth.instance.signOut();
                                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                                                        },
                                                      ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );

                                  }),
                            ),
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(userId()=="gmail.com")Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("User",style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.w500),),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white.withOpacity(0.1),
                                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                                      ),
                                      child: Row(
                                        children: [
                                          Text("   Create Home Page Update",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.w500),),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Icon(Icons.arrow_forward_ios),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: (){

                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white.withOpacity(0.1),
                                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                                      ),
                                      child: Row(
                                        children: [
                                          Text("   Create ECE News",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.w500),),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Icon(Icons.arrow_forward_ios),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  NewsCreator()));
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white.withOpacity(0.1),
                                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                                      ),
                                      child: Row(
                                        children: [
                                          Text("   Create Subject or Lab Subject",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.w500),),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Icon(Icons.arrow_forward_ios),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  SubjectsCreator()));
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white.withOpacity(0.1),
                                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                                      ),
                                      child: Row(
                                        children: [
                                          Text("   Create Books",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.w500),),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Icon(Icons.arrow_forward_ios),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  BooksCreator()));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white.withOpacity(0.1),
                                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("Saved Images ( In App )",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.w500),),
                                ),
                              ),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>  unseenImages()));
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: const Center(child: Text('Settings', style: TextStyle(fontSize: 20, color: Colors.white70))),
                          ),
                          const SizedBox(height: 5.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              margin: const EdgeInsets.all(3),
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: Colors.white.withOpacity(0.3),
                              ),
                              child: Column(
                                children: [
                                  GridView.count(
                                    physics: const NeverScrollableScrollPhysics(),
                                    childAspectRatio: 4,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(3),
                                    mainAxisSpacing: 3,
                                    crossAxisCount: 2,
                                    children: List.generate(
                                      SettingsData.length,
                                      (int index) {
                                        return InkWell(
                                          child: Container(
                                            margin: const EdgeInsets.all(2.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              color: Colors.black.withOpacity(0.7),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Center(
                                                  child: Text(
                                                SettingsData[index].title,
                                                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                              )),
                                            ),
                                          ),
                                          onTap: () {
                                            if (SettingsData[index].title == "Report") {
                                              _sendingMails("sujithnimmala03@gmail.com");
                                            } else if (SettingsData[index].title == "About") {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => const about()));
                                            } else {
                                              _ExternallaunchUrl("https://github.com/NSCreator/PRIVACY_POLACY/blob/main/Privacy-policy");
                                            }
                                          },

                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          StreamBuilder<List<followUsConvertor>>(
                              stream: readfollowUs(),
                              builder: (context, snapshot) {
                                final Books = snapshot.data;
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 0.3,
                                          color: Colors.cyan,
                                        ));
                                  default:
                                    if (snapshot.hasError) {
                                      return const Center(child: Text('Error with TextBooks Data or\n Check Internet Connection'));
                                    } else {
                                      if (Books!.isEmpty) {

                                        return const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Nothing To Follow",
                                              style: TextStyle(color: Color.fromRGBO(195, 228, 250, 1),),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(left: 10, top: 20,bottom: 8),
                                              child: Text(
                                                "Follow Us",
                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Color.fromRGBO(195, 228, 250, 1),),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 40,
                                              child: ListView.separated(
                                                physics: const BouncingScrollPhysics(),
                                                scrollDirection: Axis.horizontal,
                                                itemCount: Books.length,
                                                itemBuilder: (BuildContext context, int index) => InkWell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 5,bottom: 10),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: const Color.fromRGBO(174, 228, 242,0.15),),
                                                        borderRadius: BorderRadius.circular(15),
                                                        color: Colors.black.withOpacity(0.3),
                                                        // border: Border.all(color: Colors.white),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(15),
                                                              color: Colors.black.withOpacity(0.4),
                                                              image:  DecorationImage(
                                                                image: NetworkImage(
                                                                  Books[index].photoUrl,
                                                                ),
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                            height: 35,
                                                            width: 50,
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Text(Books[index].name,style: const TextStyle(fontSize: 16,color: Colors.white),),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    if(Books[index].name =="Gmail"){
                                                      _sendingMails(Books[index].link);
                                                    }
                                                    else{
                                                      if(Books[index].link.isNotEmpty)_ExternallaunchUrl(Books[index].link);
                                                      else showToast("No ${Books[index].name} Link");
                                                    }

                                                  },
                                                ),
                                                shrinkWrap: true,
                                                separatorBuilder: (context, index) => const SizedBox(
                                                  width: 9,
                                                ),
                                              ),
                                            ),

                                          ],
                                        );
                                      }
                                    }
                                }
                              }),
                          Center(
                            child: InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white.withOpacity(0.1),
                                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("APP DEVELOPMENT TEAM",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.w500),),
                                ),
                              ),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const appDevelopmentTeam()));
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: Text(
                              localVersion,
                              style: TextStyle(
                                fontSize: 9.0,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class mainSettings {
  String title;

  mainSettings(
    this.title,
  );
}

int branchIndex = 0;

class BranchApi {
  static Future<List<Branch>> getUsers() async {
    var url = Uri.parse('https://nscreator.github.io/srkr/srkrAppData.json');
    var response = await http.get(url);
    final body = jsonDecode(response.body);
    return body.map<Branch>(Branch.fromJson).toList();
  }
}

class Branch {
  final String heading;
  final String imageUrl, sublink, labsublink;
  final int subjects;
  final int labSubjects;

  const Branch({
    required this.heading,
    required this.subjects,
    required this.labSubjects,
    required this.imageUrl,
    required this.sublink,
    required this.labsublink,
  });

  static Branch fromJson(json) => Branch(
      heading: json['name'],
      subjects: json['subjects'].length,
      labSubjects: json['labSubjects'].length,
      imageUrl: json['imageLink'],
      sublink: json["subjectsLink"],
      labsublink: json['labSubjectsLink']);
}

class ClassApi {
  static Future<List<Class>> getUsers() async {
    var url = Uri.parse('https://nscreator.github.io/srkr/srkrAppData.json');
    var response = await http.get(url);
    final body = jsonDecode(response.body)[branchIndex]["classLink"];
    print(body);
    return body.map<Class>(Class.fromJson).toList();
  }
}

class Class {
  final String heading;
  final String syllabusLink;
  final String modelPaperLink;

  const Class({
    required this.syllabusLink,
    required this.modelPaperLink,
    required this.heading,
  });

  static Class fromJson(json) => Class(
        heading: json['class'],
        syllabusLink: json['syllabus'],
        modelPaperLink: json['model papers'],
      );
}

class about extends StatelessWidget {
  const about({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          //brightness: Brightness.light,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              color: Color.fromRGBO(7, 7, 23, 1.0),
            ),
          ),

          title: const Text('About'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new HomePage()));
            },
          ),
        ),
      ),
      body: FutureBuilder<List<aboutData>>(
        future: aboutDataApi.getUsers(),
        builder: (context, snapshot) {
          final abouts = snapshot.data;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return const Center(child: Text('Some error occurred!'));
              } else {
                return aboutbuild(abouts!);
              }
          }
        },
      ),
    );
  }

  Widget aboutbuild(List<aboutData> abouts) => SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: abouts.length,
            itemBuilder: (context, int index) {
              final about = abouts[index];

              return InkWell(
                child: Container(
                  margin: const EdgeInsets.all(6.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromRGBO(38, 39, 43, 0.6),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          about.heading,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white70),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 3, bottom: 3),
                          child: Text(
                            about.description,
                            style: TextStyle(color: Colors.white38),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  _ExternallaunchUrl(about.url);
                },
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
              height: 1,
            ),
          ),
        ),
      );
}

class aboutData {
  String heading;
  String description;
  String url;

  aboutData({required this.heading, required this.description, required this.url});

  static aboutData fromJson(json) => aboutData(heading: json['heading'], description: json['description'], url: json['link']);
}

mixin aboutDataApi {
  static Future<List<aboutData>> getUsers() async {
    var url = Uri.parse("https://nscreator.github.io/srkr/settings.json");
    var response = await http.get(url);
    final body = jsonDecode(response.body)["about"];
    return body.map<aboutData>(aboutData.fromJson).toList();
  }
}

class appDevelopmentTeam extends StatelessWidget {
  const appDevelopmentTeam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                "https://i.pinimg.com/736x/01/c7/f7/01c7f72511cc6ce7858e65b45d4f8c9c.jpg",
              ),
              fit: BoxFit.fill),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color.fromRGBO(38, 39, 43, 0.4),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 8, 8, 1),
                            child: Text('APP Development Team', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white54)),
                          ),
                          Spacer()
                        ],
                      ),
                      InkWell(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromRGBO(0, 2, 10, 0.5),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 3,
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(image: NetworkImage("https://drive.google.com/uc?export=view&id=1g0pUY2mr2EU8M-fb9ZEsyioyLRKXtsuR"))
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "NIMMALA SUJITH",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 13),
                            child: Text(
                              "R20-ECE-20B91A04H1",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 13),
                            child: Text(
                              "App Developer",
                              style: const TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  _sendingMails("sujithnimmala03@gmail.com");
                },
              ),
                      StreamBuilder<List<studentConvertor>>(
                          stream: Readstudent(),
                          builder: (context, snapshot) {
                            final students = snapshot.data;
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return const Center(
                                    child: CircularProgressIndicator(
                                  strokeWidth: 0.3,
                                  color: Colors.cyan,
                                ));
                              default:
                                if (snapshot.hasError) {
                                  return const Center(child: Text('Error with TextBooks Data or\n Check Internet Connection'));
                                } else {
                                  return buildStudent(students!);
                                }
                            }
                          }),
                    ],
                  ),
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.white.withOpacity(0.1)),
                              color: const Color.fromRGBO(38, 39, 43, 0.4),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(20, 8, 8, 1),
                                      child: Text('Faculty Team', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white54)),
                                    ),
                                    Spacer()
                                  ],
                                ),
                                StreamBuilder<List<FacultyConvertor>>(
                                    stream: ReadFaculty(),
                                    builder: (context, snapshot) {
                                      final students = snapshot.data;
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return const Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 0.3,
                                                color: Colors.cyan,
                                              ));
                                        default:
                                          if (snapshot.hasError) {
                                            return const Center(child: Text('Error with TextBooks Data or\n Check Internet Connection'));
                                          } else {
                                            return buildFaculty(students!);
                                          }
                                      }
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFaculty(List<FacultyConvertor> facultyDatas) => ListView.separated(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: facultyDatas.length,
      itemBuilder: (context, int index) {
        final facultyData = facultyDatas[index];
        return InkWell(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromRGBO(0, 2, 10, 0.5),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 3,
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(image: NetworkImage(facultyData.PhotoUrl))
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        facultyData.name,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 13),
                      child: Text(
                        facultyData.description,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 13),
                      child: Text(
                        facultyData.Role,
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            _sendingMails(facultyData.email);
          },
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
            height: 1,
          ));

  Widget buildStudent(List<studentConvertor> studentDatas) => ListView.separated(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: studentDatas.length,
        itemBuilder: (context, int index) {
          final studentData = studentDatas[index];
          return InkWell(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromRGBO(0, 2, 10, 0.5),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 3,
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(image: NetworkImage(studentData.PhotoUrl))
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          studentData.name,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 13),
                        child: Text(
                          studentData.description,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 13),
                        child: Text(
                          studentData.Role,
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () {
              _sendingMails(studentData.email);
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 1,
        ),
      );
}

Stream<List<studentConvertor>> Readstudent() =>
    FirebaseFirestore.instance.collection('App Dev').snapshots().map((snapshot) => snapshot.docs.map((doc) => studentConvertor.fromJson(doc.data())).toList());

Future createstudent({required String Name, required String description, required String Email, required String photoUrl, required String role}) async {
  final docBook = FirebaseFirestore.instance.collection("App Dev").doc();
  final Book = studentConvertor(id: docBook.id, name: Name, email: Email, description: description, PhotoUrl: photoUrl, Role: role);
  final json = Book.toJson();
  await docBook.set(json);
}

class studentConvertor {
  String email;
  String name;
  String description;
  String Role;
  String PhotoUrl, id;

  studentConvertor({
    required this.id,
    required this.email,
    required this.name,
    required this.description,
    required this.Role,
    required this.PhotoUrl,
  });

  static studentConvertor fromJson(json) => studentConvertor(
        id: json['id'],
        email: json['Email'],
        name: json['Name'],
        description: json['Description'],
        Role: json['Role'],
        PhotoUrl: json['PhotoUrl'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Name": name,
        "Email": email,
        "Description": description,
        "PhotoUrl": PhotoUrl,
        "Role": Role,
      };
}

Stream<List<FacultyConvertor>> ReadFaculty() =>
    FirebaseFirestore.instance.collection('Faculty').snapshots().map((snapshot) => snapshot.docs.map((doc) => FacultyConvertor.fromJson(doc.data())).toList());

Future createFaculty({required String Name, required String description, required String Email, required String photoUrl, required String role}) async {
  final docBook = FirebaseFirestore.instance.collection("Faculty").doc();
  final Book = studentConvertor(id: docBook.id, name: Name, email: Email, description: description, PhotoUrl: photoUrl, Role: role);
  final json = Book.toJson();
  await docBook.set(json);
}

class FacultyConvertor {
  String email;
  String name;
  String description;
  String Role;
  String PhotoUrl, id;

  FacultyConvertor({
    required this.id,
    required this.email,
    required this.name,
    required this.description,
    required this.Role,
    required this.PhotoUrl,
  });

  static FacultyConvertor fromJson(json) => FacultyConvertor(
    id: json['id'],
    email: json['Email'],
    name: json['Name'],
    description: json['Description'],
    Role: json['Role'],
    PhotoUrl: json['PhotoUrl'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "Name": name,
    "Email": email,
    "Description": description,
    "PhotoUrl": PhotoUrl,
    "Role": Role,
  };
}

_showSecondPage(BuildContext context, String url) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (ctx) => Scaffold(
        backgroundColor: const Color.fromRGBO(38, 39, 43, 0.4),
        body: Center(
          child: Hero(tag: 'magnifier', child: Image.network(url)),
        ),
      ),
    ),
  );
}

_sendingMails(String urlIn) async {
  var url = Uri.parse("mailto:$urlIn");
  if (!await launchUrl(url)) throw 'Could not launch $url';
}

_ExternallaunchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $urlIn';
  }
}
user0Id() {
  var user = FirebaseAuth.instance.currentUser!.email!.split("@");
  return user[0];
}
userId() {
  var user = FirebaseAuth.instance.currentUser!.email!.split("@");
  return user[1];
}

fullUserId() {
  var user = FirebaseAuth.instance.currentUser!.email!;
  return user;
}

Stream<List<followUsConvertor>> readfollowUs() => FirebaseFirestore.instance
    .collection('FollowUs')
    .orderBy("name", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => followUsConvertor.fromJson(doc.data())).toList());

class followUsConvertor {
  String id;
  final String name,link,photoUrl;



  followUsConvertor({this.id = "",required this.name,required this.link,required this.photoUrl});

  static followUsConvertor fromJson(Map<String, dynamic> json) =>
      followUsConvertor(id: json['id'],name: json["name"],link: json["link"],photoUrl: json["photoUrl"]);
}
 showToast(String message) async {
  await Fluttertoast.cancel();
  Fluttertoast.showToast(msg: message, fontSize: 18);
}