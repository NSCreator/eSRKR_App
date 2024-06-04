// ignore_for_file: use_build_context_synchronously, camel_case_types, non_constant_identifier_names, must_be_immutable

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:srkr_study_app/main.dart';
import 'package:srkr_study_app/settings/profile_page.dart';
import 'package:srkr_study_app/uploader.dart';
import 'dart:convert';
import '../Notifications_and_messages/convertor.dart';
import '../Notifications_and_messages/updates_creator.dart';
import '../auth_page.dart';
import '../functions.dart';
import '../syllabus_model_papers/creator.dart';
import 'downloaded_files.dart';
import '../subjects/creator.dart';
String version= "2024.5.7";
final random = Random();
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class ImageShowAndDownload extends StatefulWidget {
  final String image, token;
  final bool isZoom;

  ImageShowAndDownload(
      {required this.image, this.isZoom = false, required this.token});

  @override
  State<ImageShowAndDownload> createState() => _ImageShowAndDownloadState();
}

class _ImageShowAndDownloadState extends State<ImageShowAndDownload> {
  String filePath = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    final Directory appDir = await getApplicationDocumentsDirectory();

    final fileName = widget.image.split("/").last;

    filePath = '${appDir.path}/$fileName';

    if (await File(filePath).exists()) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      await _download(widget.image);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _download(String fileUrl) async {
    try {
      var response;
      if (fileUrl.startsWith('https://drive.google.com')) {
        String name = fileUrl.split('/d/')[1].split('/')[0];
        fileUrl = "https://drive.google.com/uc?export=download&id=$name";
        response = await http.get(Uri.parse(fileUrl));
      } else {
        try {
          response = await http.get(Uri.parse(fileUrl));
        } catch (e) {
          fileUrl = await getFileUrl(fileUrl, widget.token);

          response = await http.get(Uri.parse(fileUrl));
        }
      }
      if (response.statusCode == 200) {
        final documentDirectory = await getApplicationDocumentsDirectory();
        final newDirectory = Directory('${documentDirectory.path}');
        if (!await newDirectory.exists()) {
          await newDirectory.create(recursive: true);
        }
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
      } else {
        print('Failed to download file. HTTP Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(
        color: Colors.greenAccent,
      ));
    } else {
      if (widget.isZoom) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  backgroundColor: Colors.black,
                  body: SafeArea(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Image.file(
                              File(filePath),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          child: Image.file(
            File(filePath),
            fit: BoxFit.cover,
          ),
        );
      } else {
        return Image.file(
          File(filePath),
          fit: BoxFit.cover,
        );
      }
    }
  }
}

const TextStyle creatorHeadingTextStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white);

class settings extends StatefulWidget {
  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
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
    FirebaseAuth auth = FirebaseAuth.instance;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              backButton(),
              Heading(heading: "My Account"),
              Container(
                width: double.infinity,
                color: Colors.blueGrey.shade900,
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.white54,
                      ),
                      child: Center(
                          child: Text(
                        picText(fullUserId()),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 30,
                        ),
                      )),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${auth.currentUser!.displayName != null ? auth.currentUser!.displayName!.split(";").first : fullUserId().toString().split("@").first}",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          fullUserId(),
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getBranch(fullUserId()),
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if(!isAnonymousUser())IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditProfilePage(
                                                onChange: (a) {
                                                  setState(() {});
                                                },
                                              )));
                                },
                                icon: Icon(
                                  Icons.edit,
                                  size: 20,
                                ))
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Heading(heading: "Settings"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.download_for_offline_outlined,
                                  color: Colors.white70,
                                  size: 25,
                                ),
                                Text(
                                  " See Downloaded Files",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 25,
                              color: Colors.white38,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PdfFileList()));
                      },
                    ),
                    if (!isAnonymousUser())
                      InkWell(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          margin: EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.password,
                                    color: Colors.white70,
                                    size: 25,
                                  ),
                                  Text(
                                    " Update Password",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 25,
                                color: Colors.white38,
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const UpdatePasswordPage()));
                        },
                      ),
                    InkWell(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.account_circle_outlined,
                                  color: Colors.white70,
                                  size: 25,
                                ),
                                Text(
                                  " Delete My Account",
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 25),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 25,
                              color: Colors.white38,
                            )
                          ],
                        ),
                      ),
                      onTap: () async {
                        try {
                          final FirebaseAuth _auth = FirebaseAuth.instance;
                          User? user = _auth.currentUser;

                          // Show confirmation dialog
                          bool confirm = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirm Delete Your Account'),
                                content: Text(
                                    'Are you sure you want to delete your account?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    // Cancel
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    // Confirm
                                    child: Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (confirm == true) {
                            await user!.delete();
                            await FirebaseAuth.instance.signOut();
                            showToastText('Account deleted successfully');
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Scaffold(body: LoginPage())));
                          } else {
                            showToastText('Account deletion cancelled');
                          }
                        } catch (e) {
                          print('Failed to delete account: $e');
                          showToastText("Error : $e");
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: Divider(color: Colors.white30,),
                    ),
                    InkWell(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: EdgeInsets.only(bottom: 2),
                        decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.report_problem_outlined,
                                  color: Colors.white70,
                                  size: 25,
                                ),
                                Text(
                                  " Report",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 25,
                              color: Colors.white38,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        sendingMails("sujithnimmala03@gmail.com");
                      },
                    ),
                    InkWell(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.privacy_tip_outlined,
                                  color: Colors.white70,
                                  size: 25,
                                ),
                                Text(
                                  " Privacy Policy",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 25,
                              color: Colors.white38,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        ExternalLaunchUrl(
                            "https://github.com/NSCreator/PRIVACY_POLACY/blob/main/Privacy-policy");
                      },
                    ),
                    InkWell(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.read_more,
                                  color: Colors.white70,
                                  size: 25,
                                ),
                                Text(
                                  " About",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 25,
                              color: Colors.white38,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const about()));
                      },
                    ),
                  ],
                ),
              ),
              if (isOwner())
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Heading(heading: "Update App"),
                          ElevatedButton(onPressed: () async {
                            await FirebaseDatabase.instance.ref("Updated").set(version+","+getID().toString());
                            showToastText("Data Updated");
                          }, child: Text("Update"))
                        ],
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Create News",
                              style: TextStyle(
                                  color: Colors.orangeAccent, fontSize: 25),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: InkWell(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      margin: EdgeInsets.only(
                                          bottom: 5, right: 2, top: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.add_box_outlined,
                                                  color: Colors.black87,
                                                  size: 25,
                                                ),
                                                Expanded(
                                                  child: Text(" Flash News",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 25),
                                                      maxLines: 1),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            size: 25,
                                            color: Colors.black54,
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FlashNewsCreator(
                                                    branch:
                                                        getBranch(fullUserId()),
                                                  )));
                                    },
                                  ),
                                ),
                                Flexible(
                                  child: InkWell(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      margin: EdgeInsets.only(
                                          bottom: 5, left: 2, top: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.add_box_outlined,
                                                color: Colors.black87,
                                                size: 25,
                                              ),
                                              Text(
                                                " News",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 25),
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            size: 25,
                                            color: Colors.black54,
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  updateCreator(
                                                    branch:
                                                        getBranch(fullUserId()),
                                                  )));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Create Materials",
                              style: TextStyle(
                                  color: Colors.orangeAccent, fontSize: 25),
                            ),
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                margin: EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.add_box_outlined,
                                          color: Colors.black87,
                                          size: 25,
                                        ),
                                        Text(
                                          "Add Syllabus & Model Paper",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 25,
                                      color: Colors.black54,
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SyllabusModelPaperCreator()));
                              },
                            ),
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                margin: EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.add_box_outlined,
                                          color: Colors.black87,
                                          size: 25,
                                        ),
                                        Text(
                                          "Add Software Route Map",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 25,
                                      color: Colors.black54,
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SoftwareRouteMapCreator()));
                              },
                            ),
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                margin: EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.add_box_outlined,
                                          color: Colors.black87,
                                          size: 25,
                                        ),
                                        Text(
                                          " Books",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 25,
                                      color: Colors.black54,
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BooksCreator(
                                              branch: getBranch(fullUserId()),
                                            )));
                              },
                            ),
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                margin: EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.add_box_outlined,
                                          color: Colors.black87,
                                          size: 25,
                                        ),
                                        Text(
                                          "Subjects",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 25,
                                      color: Colors.black54,
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SubjectCreator()));
                              },
                            ),
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                margin: EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.add_box_outlined,
                                          color: Colors.black87,
                                          size: 25,
                                        ),
                                        Text(
                                          "Lab Subjects",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 25,
                                      color: Colors.black54,
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SubjectCreator(
                                              isSub: false,
                                            )));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(color: Colors.blueGrey.shade900),
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: 10.0, left: 30, right: 30),
                        child: InkWell(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white54)),
                            child: Center(
                              child: Text(
                                "Logout",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 16,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: <Widget>[
                                        SizedBox(height: 15),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15),
                                          child: Text(
                                            "Do you want Log Out",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Spacer(),
                                              InkWell(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black26,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15,
                                                            vertical: 5),
                                                    child: Text(
                                                      "Back",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14),
                                                    ),
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15,
                                                            vertical: 5),
                                                    child: Text(
                                                      "Log Out",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () async {

                                                  if (isAnonymousUser()) {
                                                    final FirebaseAuth _auth =
                                                        FirebaseAuth.instance;
                                                    User? user =
                                                        _auth.currentUser;
                                                    await user!.delete();
                                                    await FirebaseAuth.instance
                                                        .signOut();
                                                    showToastText(
                                                        'Account deleted successfully');
                                                    Navigator.pop(context);
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Scaffold(
                                                                    body:
                                                                        MyApp())));

                                                  }else{
                                                    FirebaseAuth.instance
                                                        .signOut();
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  }

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
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "eSRKR",
                            style:
                                TextStyle(color: Colors.white38, fontSize: 14),
                          ),
                          Text(
                            "v$version",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white38,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "from NS",
                            style:
                                TextStyle(color: Colors.white38, fontSize: 14),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
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
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: Color.fromRGBO(7, 7, 23, 1.0),
            ),
          ),

          title: const Text('About'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
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
                    border: Border.all(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 15, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          about.heading,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black87),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 3, bottom: 3),
                          child: Text(
                            about.description,
                            style: TextStyle(color: Colors.black38),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  ExternalLaunchUrl(about.url);
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

  aboutData(
      {required this.heading, required this.description, required this.url});

  static aboutData fromJson(json) => aboutData(
      heading: json['heading'],
      description: json['description'],
      url: json['link']);
}

mixin aboutDataApi {
  static Future<List<aboutData>> getUsers() async {
    var url = Uri.parse("https://nscreator.github.io/srkr/settings.json");
    var response = await http.get(url);
    final body = jsonDecode(response.body)["about"];
    return body.map<aboutData>(aboutData.fromJson).toList();
  }
}

class Heading extends StatelessWidget {
  final String heading;
  final EdgeInsets padding;

  Heading(
      {required this.heading,
      this.padding =
          const EdgeInsets.only(left: 15.0, bottom: 10, right: 15, top: 10)});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        heading,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class SoftwareRouteMapCreator extends StatefulWidget {
  @override
  State<SoftwareRouteMapCreator> createState() =>
      _SoftwareRouteMapCreatorState();
}

class _SoftwareRouteMapCreatorState extends State<SoftwareRouteMapCreator> {
  late List<FileUploader> data;

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
              Uploader(
                token: esrkr,
                path: "softwareRouteMaps",
                type: FileType.any,
                allowMultiple: true,
                getIVF: (file) {
                  setState(() {
                    data = file;
                  });
                },
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
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      int id = 0;
                      for (FileUploader x in data) {
                        id++;
                        await FirebaseFirestore.instance
                            .collection("softwareRouteMap")
                            .doc("${id}")
                            .set(x.toJson());
                      }
                      Navigator.pop(context);
                    },
                    child: Text("Create"),
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
    );
  }
}
