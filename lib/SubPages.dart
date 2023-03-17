// ignore_for_file: camel_case_types, non_constant_identifier_names
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srkr_study_app/TextField.dart';
import 'package:srkr_study_app/HomePage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ads.dart';
import 'package:flutter/material.dart';

import 'favorites.dart';
import 'settings.dart';

bool unitsMode = false;

class NewsPage extends StatefulWidget {
  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      body: SafeArea(
        child: SingleChildScrollView(
          physics:const BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[500],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                          child: Text("<-- Back"),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                        child: Text("News"),
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 95,
                  )
                ],
              ),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: StreamBuilder<List<BranchNewConvertor>>(
                    stream: readBranchNew(),
                    builder: (context, snapshot) {
                      final BranchNews = snapshot.data;
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
                            return ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: BranchNews!.length,
                                itemBuilder: (context, int index) {
                                  final BranchNew = BranchNews[index];
                                  return InkWell(
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(color: Colors.white),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white38,
                                                      borderRadius: BorderRadius.circular(15),
                                                      border: Border.all(color: Colors.white),
                                                    ),
                                                    child: Image.network(
                                                      BranchNew.photoUrl,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )),
                                              Row(
                                                children: [
                                                  Spacer(),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 5, bottom: 3, right: 20),
                                                    child: Text(
                                                      BranchNew.Date,
                                                      style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w300),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15),
                                                child: Text(BranchNew.heading, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 25, top: 5, bottom: 5),
                                                child: Text(BranchNew.description, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300)),
                                              ),
                                              if (userId() == "gmail.com")
                                                Row(
                                                  children: [
                                                    Spacer(),
                                                    InkWell(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey[500],
                                                          borderRadius: BorderRadius.circular(15),
                                                          border: Border.all(color: Colors.white),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                                          child: Text("Edit"),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    NewsCreator(NewsId: BranchNew.id, heading: BranchNew.heading, description: BranchNew.description, photoUrl: BranchNew.photoUrl)));
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    InkWell(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey[500],
                                                          borderRadius: BorderRadius.circular(15),
                                                          border: Border.all(color: Colors.white),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                                          child: Text("Delete"),
                                                        ),
                                                      ),
                                                      onTap: () async{
                                                        final Uri uri = Uri.parse(BranchNew.photoUrl);
                                                        final String fileName = uri.pathSegments.last;
                                                        final Reference ref = storage.ref().child("/${fileName}");
                                                        try {
                                                          await ref.delete();
                                                          showToast('Image deleted successfully');
                                                        } catch (e) {
                                                          showToast('Error deleting image: $e');
                                                        }
                                                        FirebaseFirestore.instance.collection("ECE").doc("ECENews").collection("ECENews").doc(BranchNew.id).delete();
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                        if ((index + 1) % 1 == 0) CustomBannerAd01(),
                                      ],
                                    ),
                                    onTap: () async {
                                      _launchUrl(BranchNew.photoUrl);
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) => Divider(
                                      height: 9,
                                      color: Colors.white,
                                    ));
                          }
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Subjects extends StatefulWidget {

  Subjects({Key? key}) : super(key: key);

  @override
  State<Subjects> createState() => _SubjectsState();
}
class _SubjectsState extends State<Subjects> {
  bool like = false;
  List<SearchAddedSubjects> subjects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage("https://media.istockphoto.com/id/1299998230/vector/back-to-school-seamless-pattern-background.jpg?s=612x612&w=0&k=20&c=bo6MKVZuXvXrUSffhOU1XFbaz9xbMDG_t1dWfkSM8WE=4"),fit: BoxFit.fill)
        ),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[500],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                          child: Text("<-- Back"),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                        child: Text("Subjects"),
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 95,
                  )
                ],
              ),
              Image.network(""),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StreamBuilder<List<FlashConvertor>>(
                            stream: readFlashNews(),
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
                                    return const Center(child: Text('Error with TextBooks Data or\n Check Internet Connection'));
                                  } else {
                                    return ListView.separated(
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: user!.length,
                                        itemBuilder: (context, int index) {
                                          final SubjectsData = user[index];
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: 5,
                                              ),
                                              InkWell(
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.all(Radius.circular(10))),
                                                  child: SingleChildScrollView(
                                                    physics: const BouncingScrollPhysics(),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 90.0,
                                                          height: 70.0,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                            color: Colors.redAccent,
                                                            image: DecorationImage(
                                                              image: NetworkImage(
                                                                SubjectsData.PhotoUrl,
                                                              ),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),

                                                        Expanded(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      SubjectsData.heading,
                                                                      style: const TextStyle(
                                                                        fontSize: 20.0,
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    Spacer(),
                                                                    InkWell(
                                                                      child: Padding(
                                                                        padding:  EdgeInsets.only(right: 3),
                                                                        child:isLike(SubjectsData.id)
                                                                      ),
                                                                      onTap: (){
                                                                     print(isDocumentExsist(SubjectsData.id)!=false);
                                                                      },
                                                                    ),
                                                                    Text("${SubjectsData.like}",style: TextStyle(color: Colors.white,fontSize: 20),),
                                                                    SizedBox(width: 5,),
                                                                    InkWell(
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(right: 20),
                                                                        child: Icon(
                                                                          Icons.library_add_outlined,
                                                                          color: Colors.blue,
                                                                          size: 28,
                                                                        ),
                                                                      ),
                                                                      onTap: () {
                                                                        showDialog(
                                                                          context: context,
                                                                          builder: (context) {
                                                                            return Dialog(
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
                                                                                        "Do you want Add to Favourites",
                                                                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
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
                                                                                                border: Border.all(color: Colors.black),
                                                                                                borderRadius: BorderRadius.circular(25),
                                                                                              ),
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                                                                                child: Text("Back"),
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
                                                                                                  "Add + ",
                                                                                                  style: TextStyle(color: Colors.white),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            onTap: () {
                                                                                              FavouriteSubjects(SubjectId: SubjectsData.id,name: SubjectsData.heading,description: SubjectsData.description,photoUrl: SubjectsData.PhotoUrl);
                                                                                              Navigator.pop(context);
                                                                                              showToast("${SubjectsData.heading} is Added");
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
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 2,
                                                                ),
                                                                Text(
                                                                  SubjectsData.description,
                                                                  style: const TextStyle(
                                                                    fontSize: 13.0,
                                                                    color: Color.fromRGBO(204, 207, 222, 1),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 1,
                                                                ),
                                                                Text(
                                                                  'Added :${SubjectsData.Date}',
                                                                  style: const TextStyle(
                                                                    fontSize: 9.0,
                                                                    color: Colors.white60,
                                                                    //   fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                if (userId() == "gmail.com")
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(right: 10),
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(15),
                                                                        color: Colors.white.withOpacity(0.5),
                                                                        border: Border.all(color: Colors.white),
                                                                      ),
                                                                      child: InkWell(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                                                          child: Text("+Add"),
                                                                        ),
                                                                        onTap: () {
                                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => SubjectsCreator(Id: SubjectsData.id,heading: SubjectsData.heading,description: SubjectsData.description,photoUrl: SubjectsData.PhotoUrl,mode:"Subjects" ,)));
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                onTap: () async {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => subjectUnitsData(
                                                                ID: SubjectsData.id,
                                                                mode: "Subjects",
                                                            name: SubjectsData.heading,
                                                            fullName: SubjectsData.description,
                                                            photoUrl: SubjectsData.PhotoUrl,
                                                              )));
                                                },
                                                // onLongPress: () async {
                                                //   SharedPreferences prefs = await SharedPreferences.getInstance();
                                                //   String? SelectedSubjects = prefs.getString('addSubjects') ?? null;
                                                //   print(SelectedSubjects);
                                                //   if (SelectedSubjects != null) {
                                                //     final body = jsonDecode(SelectedSubjects);
                                                //     subjects = body.map<SearchAddedSubjects>(SearchAddedSubjects.fromJson).toList();
                                                //   }
                                                //   print(subjects);
                                                //   final person = subjects.where((element) => element.name == SubjectsData.heading);
                                                //   if (person.isEmpty) {
                                                //     subjects.add(SearchAddedSubjects(
                                                //         name: SubjectsData.heading, description: SubjectsData.description, date: SubjectsData.Date, id: SubjectsData.id, photoUrl: SubjectsData.PhotoUrl));
                                                //   } else {
                                                //     showToast("${SubjectsData.heading} is already added");
                                                //   }
                                                //   print(subjects);
                                                //   prefs.setString('addSubjects', jsonEncode(subjects));
                                                //   print(jsonEncode(subjects));
                                                //   showToast("${SubjectsData.heading} is Added");
                                                // },
                                              ),
                                              if ((index + 1) % 1 == 0) CustomBannerAd01(),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) => const SizedBox(
                                              height: 1,
                                            ));
                                  }
                              }
                            }),
                      ),
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
    Widget isLike(docName){
      isDocumentExsist(docName);
    return Text("data");
    }
  Future<bool>isDocumentExsist(docName)async{

    DocumentSnapshot<Map<String,dynamic>>document = await FirebaseFirestore
        .instance
        .collection('ECE')
        .doc("Subjects")
        .collection("Subjects")
        .doc(docName)
        .collection("like").doc(fullUserId()).get();
    if(document.exists){
      print("true");
      return true;
    }else{
      print("false");
      return false;
    }
  }
}

class LabSubjects extends StatefulWidget {
  const LabSubjects({Key? key}) : super(key: key);

  @override
  State<LabSubjects> createState() => _LabSubjectsState();
}

class _LabSubjectsState extends State<LabSubjects> {
  List<SearchAddedSubjects> labSubjects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[500],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                          child: Text("<-- Back"),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                        child: Text("Lab Subjects"),
                      ),
                    ),
                  ),
                  Spacer(),
                  if (userId() != "gmail.com")
                    SizedBox(
                      width: 66,
                    ),
                  if (userId() == "gmail.com")
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.5),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                          child: Text("+Add"),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SubjectsCreator()));
                      },
                    ),
                  SizedBox(
                    width: 23,
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              StreamBuilder<List<LabSubjectsConvertor>>(
                  stream: readLabSubjects(),
                  builder: (context, snapshot) {
                    final LabSubjects = snapshot.data;
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
                          return ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: LabSubjects!.length,
                              itemBuilder: (context, int index) {
                                final LabSubjectsData = LabSubjects[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.all(Radius.circular(10))),
                                          child: SingleChildScrollView(
                                            physics: const BouncingScrollPhysics(),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 90.0,
                                                  height: 70.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                    color: Colors.redAccent,
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        LabSubjectsData.PhotoUrl,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              LabSubjectsData.heading,
                                                              style: const TextStyle(
                                                                fontSize: 20.0,
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            InkWell(
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(right: 20),
                                                                child: Icon(Icons.library_add_outlined,color: Colors.white,),
                                                              ),
                                                              onTap: (){

                                                              },
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          LabSubjectsData.description,
                                                          style: const TextStyle(
                                                            fontSize: 13.0,
                                                            color: Color.fromRGBO(204, 207, 222, 1),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 1,
                                                        ),
                                                        Text(
                                                          'Added :${LabSubjectsData.Date}',
                                                          style: const TextStyle(
                                                            fontSize: 9.0,
                                                            color: Colors.white60,
                                                            //   fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        if (userId() == "gmail.com")
                                                          Padding(
                                                            padding: const EdgeInsets.only(right: 10),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(15),
                                                                color: Colors.white.withOpacity(0.5),
                                                                border: Border.all(color: Colors.white),
                                                              ),
                                                              child: InkWell(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                                                  child: Text("+Add"),
                                                                ),
                                                                onTap: () {
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SubjectsCreator(Id: LabSubjectsData.id,heading: LabSubjectsData.heading,description: LabSubjectsData.description,photoUrl: LabSubjectsData.PhotoUrl,mode:"LabSubjects" ,)));
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => subjectUnitsData(
                                                        ID: LabSubjectsData.id,
                                                        mode: "LabSubjects",
                                                    name: LabSubjectsData.heading,
                                                    fullName: LabSubjectsData.description,
                                                    photoUrl: LabSubjectsData.PhotoUrl,
                                                      )));
                                        },
                                        onLongPress: (){
                                          FavouriteLabSubjectsSubjects(SubjectId: LabSubjectsData.id,name: LabSubjectsData.heading,description: LabSubjectsData.description,photoUrl: LabSubjectsData.PhotoUrl);
                                        },
                                      ),
                                      if ((index + 1) % 6 == 0) CustomBannerAd01(),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => const SizedBox(
                                    height: 1,
                                  ));
                        }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class Books extends StatefulWidget {
  const Books({Key? key}) : super(key: key);

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[500],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                          child: Text("<-- Back"),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                        child: Text("Books"),
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 95,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<List<BooksConvertor>>(
                  stream: ReadBook(),
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
                          return ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: Books!.length,
                              itemBuilder: (BuildContext context, int index) => InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white.withOpacity(0.5),
                                      border: Border.all(color: Colors.white),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  color: Colors.white.withOpacity(0.5),
                                                  border: Border.all(color: Colors.white),
                                                ),
                                                child: Image.network(
                                                  Books[index].photoUrl,
                                                  fit: BoxFit.fill,
                                                ),
                                                height: 135,
                                                width: 90,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(Books[index].heading),
                                                      Text(Books[index].Author),
                                                      Text(Books[index].edition),
                                                      Text(Books[index].description),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 8),
                                                        child: InkWell(
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(15),
                                                                color: Colors.white.withOpacity(0.5),
                                                                border: Border.all(color: Colors.white),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Text("Download"),
                                                              )),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                          ],
                                        ),
                                        if (userId() == "gmail.com")
                                          Row(
                                            children: [
                                              Spacer(),
                                              InkWell(
                                                child: Chip(
                                                  elevation: 20,
                                                  backgroundColor: Colors.black,
                                                  avatar: CircleAvatar(
                                                      backgroundColor: Colors.black45,
                                                      child: Icon(
                                                        Icons.edit_outlined,
                                                      )),
                                                  label: Text(
                                                    "Edit",
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => BooksCreator(
                                                            id: Books[index].id,
                                                            heading: Books[index].heading,
                                                            description: Books[index].description,
                                                            Edition: Books[index].edition,
                                                            Link: Books[index].link,
                                                            Author: Books[index].Author,
                                                            photoUrl: Books[index].photoUrl,
                                                          )));
                                                },
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                child: Chip(
                                                  elevation: 20,
                                                  backgroundColor: Colors.black,
                                                  avatar: CircleAvatar(
                                                      backgroundColor: Colors.black45,
                                                      child: Icon(
                                                        Icons.delete_rounded,
                                                      )),
                                                  label: Text(
                                                    "Delete",
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                                onTap: () {
                                                  FirebaseFirestore.instance.collection("ECE").doc("Books").collection("CoreBooks").doc(Books[index].id).delete();
                                                },
                                              ),
                                              Spacer()
                                            ],
                                          ),
                                        if ((index + 1) % 3 == 0) CustomBannerAd01(),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  _launchUrl(Books[index].link);
                                },
                              ),
                              separatorBuilder: (context, index) => const SizedBox(
                                height: 15,
                              ));
                        }
                    }
                  }),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_launchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn, mode: LaunchMode.inAppWebView)) throw 'Could not launch $urlIn';
}

_ExternallaunchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $urlIn';
  }
}


// ignore: must_be_immutable
class subjectUnitsData extends StatefulWidget {
  String ID, mode;
  String name;
  String fullName;
  String photoUrl;

  subjectUnitsData({required this.ID, required this.mode,required this.photoUrl,this.name="Subject",required this.fullName});

  @override
  State<subjectUnitsData> createState() => _subjectUnitsDataState();
}

class _subjectUnitsDataState extends State<subjectUnitsData> {
  bool isReadMore = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/01/c7/f7/01c7f72511cc6ce7858e65b45d4f8c9c.jpg"),fit: BoxFit.fill)
          ),
          child: Container(
            color: Colors.black.withOpacity(0.9),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[500],
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.white),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                              child: Text("<-- Back"),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[500],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                            child: Text(widget.name),
                          ),
                        ),
                      ),
                      Spacer(),
                      if (userId() == "gmail.com")
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: InkWell(
                            child: Chip(
                              elevation: 20,
                              backgroundColor: Colors.white38,
                              avatar: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    Icons.add,
                                  )),
                              label: Text(
                                "ADD",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UnitsCreator(
                                        id: widget.ID,
                                        mode: widget.mode,
                                      )));
                            },
                          ),
                        )
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                            image: DecorationImage(image:NetworkImage(widget.photoUrl),fit: BoxFit.fill )
                          ),
                        ),
                      ),
                      Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(widget.name,style: TextStyle(fontSize: 23,color: Colors.white),),
                                Text(widget.fullName,style: TextStyle(fontSize: 15,color: Colors.white),),
                              ],
                            ),
                          )),

                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 20,bottom: 3),
                              child: Text("Units",style: TextStyle(fontSize: 30,color: Colors.white),),
                            ),
                            StreamBuilder<List<UnitsConvertor>>(
                                stream: readUnits(widget.ID),
                                builder: (context, snapshot) {
                                  final Units = snapshot.data;
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
                                        return Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: ListView.separated(
                                                physics: const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: Units!.length,
                                                itemBuilder: (context, int index) {
                                                  final unit = Units[index];
                                                  return SizedBox(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: double.infinity,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(20),
                                                            color: Colors.white.withOpacity(0.07),
                                                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 15, top: 8, bottom: 8, right: 8),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  unit.heading,
                                                                  style: const TextStyle(
                                                                    fontSize: 18.0,
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Flexible(
                                                                      child: Container(
                                                                        child: buildText(unit.description)
                                                                      ),
                                                                      flex: 4,
                                                                    ),
                                                                    Flexible(
                                                                      child: Column(
                                                                        children: [
                                                                          InkWell(
                                                                            child: Container(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(15),
                                                                                color: Colors.white.withOpacity(0.5),
                                                                                border: Border.all(color: Colors.white),
                                                                              ),
                                                                              child: Row(
                                                                                children: [
                                                                                  Text("  Open"),
                                                                                  Icon(Icons.open_in_new)
                                                                                ],
                                                                              ),
                                                                            ),
                                                                              onTap: (){
                                                                                _launchUrl(unit.PDFLink);
                                                                              },
                                                                          ),
                                                                          // SizedBox(height: 3,),
                                                                          // Container(
                                                                          //   decoration: BoxDecoration(
                                                                          //     borderRadius: BorderRadius.circular(15),
                                                                          //     color: Colors.white.withOpacity(0.5),
                                                                          //     border: Border.all(color: Colors.white),
                                                                          //   ),
                                                                          //   child: Row(
                                                                          //     children: [
                                                                          //       Text("  Download"),
                                                                          //       Icon(Icons.download_outlined)
                                                                          //     ],
                                                                          //   ),
                                                                          // )
                                                                        ],
                                                                      ),
                                                                      flex: 1,
                                                                    )
                                                                  ],
                                                                ),
                                                                // const Padding(
                                                                //   padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                                                                //   child: Text(
                                                                //     'Download PDF :',
                                                                //     style: TextStyle(
                                                                //       fontSize: 13.0,
                                                                //       color: Colors.white70,
                                                                //       fontWeight: FontWeight.w700,
                                                                //     ),
                                                                //   ),
                                                                // ),
                                                                // Padding(
                                                                //   padding: const EdgeInsets.only(left: 10, right: 60),
                                                                //   child: InkWell(
                                                                //     child: Container(
                                                                //       decoration: BoxDecoration(
                                                                //         borderRadius: BorderRadius.circular(12),
                                                                //         color: const Color.fromRGBO(0, 2, 10, 0.5),
                                                                //       ),
                                                                //       child: Column(
                                                                //         children: [
                                                                //           Padding(
                                                                //             padding: const EdgeInsets.only(left: 30),
                                                                //             child: Row(
                                                                //               children: [
                                                                //                 Column(
                                                                //                   children: [
                                                                //                     Text(
                                                                //                       unit.PDFName,
                                                                //                       style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                                                //                     ),
                                                                //                     Padding(
                                                                //                       padding: const EdgeInsets.only(bottom: 3),
                                                                //                       child: Text(
                                                                //                         'Size : ${unit.PDFSize}',
                                                                //                         style: const TextStyle(
                                                                //                           fontSize: 10.0,
                                                                //                           color: Colors.white60,
                                                                //                           fontWeight: FontWeight.bold,
                                                                //                         ),
                                                                //                       ),
                                                                //                     ),
                                                                //                   ],
                                                                //                 ),
                                                                //                 const Spacer(),
                                                                //                 const Padding(
                                                                //                   padding: EdgeInsets.only(right: 20),
                                                                //                   child: Icon(
                                                                //                     Icons.download_for_offline_outlined,
                                                                //                     color: Colors.white54,
                                                                //                   ),
                                                                //                 ),
                                                                //               ],
                                                                //             ),
                                                                //           ),
                                                                //         ],
                                                                //       ),
                                                                //     ),
                                                                //     onTap: () {
                                                                //       _launchUrl(unit.PDFLink);
                                                                //     },
                                                                //   ),
                                                                // ),
                                                                // Row(
                                                                //   children: [
                                                                //     Spacer(),
                                                                //     Padding(
                                                                //       padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                                                                //       child: Text(unit.Date),
                                                                //     ),
                                                                //   ],
                                                                // ),
                                                                // if (userId() == "gmail.com")
                                                                //   Row(
                                                                //     children: [
                                                                //       InkWell(
                                                                //         child: Chip(
                                                                //           elevation: 20,
                                                                //           backgroundColor: Colors.black,
                                                                //           avatar: CircleAvatar(
                                                                //               backgroundColor: Colors.black45,
                                                                //               child: Icon(
                                                                //                 Icons.edit_outlined,
                                                                //               )),
                                                                //           label: Text(
                                                                //             "Edit",
                                                                //             style: TextStyle(color: Colors.white),
                                                                //           ),
                                                                //         ),
                                                                //         onTap: () {
                                                                //           Navigator.push(
                                                                //               context,
                                                                //               MaterialPageRoute(
                                                                //                   builder: (context) => UnitsCreator(
                                                                //                         mode: widget.mode,
                                                                //                         UnitId: widget.ID,
                                                                //                         id: unit.id,
                                                                //                         Heading: unit.heading,
                                                                //                         Description: unit.description,
                                                                //                         PDFName: unit.PDFName,
                                                                //                         PDFSize: unit.PDFSize,
                                                                //                         PDFUrl: unit.PDFLink,
                                                                //                       )));
                                                                //         },
                                                                //       ),
                                                                //       InkWell(
                                                                //         child: Chip(
                                                                //           elevation: 20,
                                                                //           backgroundColor: Colors.black,
                                                                //           avatar: CircleAvatar(
                                                                //               backgroundColor: Colors.black45,
                                                                //               child: Icon(
                                                                //                 Icons.delete_rounded,
                                                                //               )),
                                                                //           label: Text(
                                                                //             "Delete",
                                                                //             style: TextStyle(color: Colors.white),
                                                                //           ),
                                                                //         ),
                                                                //         onTap: () {
                                                                //           final deleteFlashNews = FirebaseFirestore.instance
                                                                //               .collection('ECE')
                                                                //               .doc(widget.mode)
                                                                //               .collection(widget.mode)
                                                                //               .doc(widget.ID)
                                                                //               .collection("Units")
                                                                //               .doc(unit.id);
                                                                //           deleteFlashNews.delete();
                                                                //         },
                                                                //       ),
                                                                //     ],
                                                                //   )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        if ((index + 1) % 2 == 0) CustomBannerAd01(),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                separatorBuilder: (context, index) => const SizedBox(
                                                      height: 5,
                                                    )));
                                      }
                                  }
                                }),
                            if(widget.mode=="Subject")StreamBuilder<List<UnitsConvertor>>(
                                stream: readUnits(widget.ID),
                                builder: (context, snapshot) {
                                  final Units = snapshot.data;
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
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10,top: 20,bottom: 8),
                                              child: Text("Text Books",style: TextStyle(fontSize: 30,color: Colors.white),),
                                            ),
                                            Container(
                                              height: 168,
                                              child: ListView.builder(
                                                physics: BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: Units!.length,
                                                scrollDirection: Axis.horizontal,
                                                itemBuilder: (BuildContext context, int index) {
                                                  final SubjectsData = Units[index];
                                                  return InkWell(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10),
                                                      child: Container(
                                                        width: 125,
                                                        decoration: BoxDecoration(
                                                          color: Colors.white.withOpacity(0.25),
                                                          borderRadius: BorderRadius.circular(15),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: 155,
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                  color: Colors.black54,
                                                                  borderRadius: BorderRadius.circular(15),
                                                                  image:  DecorationImage(
                                                                    image: NetworkImage(
                                                                      "SubjectsData.photoUrl",
                                                                    ),
                                                                    fit: BoxFit.cover,
                                                                  )
                                                              ),
                                                              child: Align(
                                                                alignment: Alignment.bottomLeft,
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.black.withOpacity(0.4),
                                                                    borderRadius: BorderRadius.circular(15),

                                                                  ),
                                                                  child: Padding(
                                                                    padding:  const EdgeInsets.all(4.0),
                                                                    child: Text(SubjectsData.heading,style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Colors.white), maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,),
                                                                  ),
                                                                ),

                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:  const EdgeInsets.only(left: 10,right: 10),
                                                              child: Text("by {SubjectsData.creator}",style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 11,color: Color.fromRGBO(164, 209, 245,1)),
                                                                maxLines: 1,

                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () async {

                                                    },
                                                  );
                                                },

                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                  }
                                }),
                            StreamBuilder<List<UnitsConvertor>>(
                                stream: readUnits(widget.ID),
                                builder: (context, snapshot) {
                                  final Units = snapshot.data;
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
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10,top: 20,bottom: 8),
                                              child: Text("Syllabus and Papers",style: TextStyle(fontSize: 30,color: Colors.white),),
                                            ),
                                            Container(
                                              height: 168,
                                              child: ListView.builder(
                                                physics: BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: Units!.length,
                                                scrollDirection: Axis.horizontal,
                                                itemBuilder: (BuildContext context, int index) {
                                                  final SubjectsData = Units[index];
                                                  return InkWell(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10),
                                                      child: Container(
                                                        width: 130,
                                                        decoration: BoxDecoration(
                                                          color: Colors.white.withOpacity(0.25),
                                                          borderRadius: BorderRadius.circular(15),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: 155,
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                  color: Colors.black54,
                                                                  borderRadius: BorderRadius.circular(15),
                                                                  image:  DecorationImage(
                                                                    image: NetworkImage(
                                                                      "SubjectsData.photoUrl",
                                                                    ),
                                                                    fit: BoxFit.cover,
                                                                  )
                                                              ),
                                                              child: Align(
                                                                alignment: Alignment.bottomLeft,
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.black.withOpacity(0.4),
                                                                    borderRadius: BorderRadius.circular(15),

                                                                  ),
                                                                  child: Padding(
                                                                    padding:  const EdgeInsets.all(4.0),
                                                                    child: Text(SubjectsData.heading,style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Colors.white), maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,),
                                                                  ),
                                                                ),

                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:  const EdgeInsets.only(left: 10,right: 10),
                                                              child: Text("by {SubjectsData.creator}",style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 11,color: Color.fromRGBO(164, 209, 245,1)),
                                                                maxLines: 1,

                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () async {

                                                    },
                                                  );
                                                },

                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  Widget buildText(String text){
    final maxLines = isReadMore ? null :2;
    final overflow = isReadMore?TextOverflow.visible:TextOverflow.ellipsis;
    return Text(text,
    maxLines: maxLines,
      overflow: overflow,
      style: const TextStyle(
        fontSize: 10.0,
        color: Color.fromRGBO(204, 207, 222, 0.8),
        fontWeight: FontWeight.bold,
      ),
    );
  }
  Stream<List<UnitsConvertor>> readUnits(String subjectsID) => FirebaseFirestore.instance
      .collection('ECE')
      .doc(widget.mode)
      .collection(widget.mode)
      .doc(subjectsID)
      .collection("Units")
      .orderBy("Heading", descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => UnitsConvertor.fromJson(doc.data())).toList());
}

Future createUnits(
    {required String mode,
    required String heading,
    required String description,
    required String PDFSize,
    required String Date,
    required String PDFName,
    required String PDFLink,
    required String subjectsID}) async {
  final docflash = FirebaseFirestore.instance.collection("ECE").doc(mode).collection(mode).doc(subjectsID).collection("Units").doc();
  final flash = UnitsConvertor(id: docflash.id, heading: heading, PDFName: PDFName, description: description, PDFSize: PDFSize, PDFLink: PDFLink, Date: Date);
  final json = flash.toJson();
  await docflash.set(json);
}

class UnitsConvertor {
  String id;
  final String heading, PDFName, description, PDFSize, PDFLink, Date;

  UnitsConvertor({this.id = "", required this.heading, required this.PDFName, required this.description, required this.PDFSize, required this.PDFLink, required this.Date});

  Map<String, dynamic> toJson() => {"id": id, "Heading": heading, "PDFName": PDFName, "Description": description, "PDFSize": PDFSize, "PDFLink": PDFLink, "Date": Date};

  static UnitsConvertor fromJson(Map<String, dynamic> json) =>
      UnitsConvertor(PDFLink: json["PDFLink"], id: json['id'], heading: json["Heading"], PDFName: json["PDFName"], description: json["Description"], PDFSize: json["PDFSize"], Date: json["Date"]);
}

class Units {
  String heading, description, pdfName, pdfSize, pdfLink;

  Units({required this.heading, required this.description, required this.pdfSize, required this.pdfName, required this.pdfLink});

  static Units fromJson(json) => Units(
        heading: json['heading'],
        description: json['description'],
        pdfName: json['pdfName'],
        pdfSize: json['pdfSize'],
        pdfLink: json['pdfLink'],
      );
}

Future showToast(String message) async {
  await Fluttertoast.cancel();
  Fluttertoast.showToast(msg: message, fontSize: 18);
}

class SearchAddedSubjects {
  String name, date;
  String description, id, photoUrl;

  SearchAddedSubjects({required this.name, required this.description, required this.date, required this.id, required this.photoUrl});

  Map<String, dynamic> toJson() => {'name': name, 'description': description, 'id': id, 'date': date, 'photoUrl': photoUrl};

  static SearchAddedSubjects fromJson(json) => SearchAddedSubjects(name: json['name'], description: json['description'], date: json["date"], id: json['id'], photoUrl: json['photoUrl']);
}
