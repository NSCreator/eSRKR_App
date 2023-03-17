// ignore_for_file: camel_case_types, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'arduino.dart';

class electronicComponents extends StatefulWidget {
  @override
  State<electronicComponents> createState() => _electronicComponentsState();
}

class _electronicComponentsState extends State<electronicComponents> {
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
            children: [
              const Center(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Electronic Components",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
              )),
              Expanded(
                child: StreamBuilder<List<electronicComponentsConvertor>>(
                  stream: readelectronicComponents(),
                  builder: (context, snapshot) {
                    final Subjects = snapshot.data;
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 0.3,
                              color: Colors.cyan,
                            ));
                      default:
                        if (snapshot.hasError) {
                          return Text("Error with server");
                        }
                        else {
                          return AnimationLimiter(
                            child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: Subjects!.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(left: 8,right: 8,bottom: 3),
                                itemBuilder: (BuildContext context, int index) {
                                  final SubjectsData0 = Subjects[index];
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: InkWell(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: const Color.fromRGBO(174, 228, 242,0.1)),
                                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                                              color: Colors.black.withOpacity(0.3),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(1.5),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                            color: Colors.black.withOpacity(0.5),
                                                            image: DecorationImage(
                                                              image: NetworkImage(SubjectsData0.photoUrl,),

                                                              fit: BoxFit.cover,
                                                            )
                                                        ),
                                                        height: 70,
                                                        width: 125,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 5,top: 5,bottom: 3),
                                                        child: Text(SubjectsData0.name,style: TextStyle(fontSize: 40,color: Colors.white),),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 5,top: 3,bottom: 3,right: 5),
                                                  child: StreamBuilder<List<subElectronicComponentsConvertor>>(
                                                    stream: readsubElectronicComponents(SubjectsData0.id),
                                                    builder: (context, snapshot) {
                                                      final Subjects = snapshot.data;
                                                      switch (snapshot.connectionState) {
                                                        case ConnectionState.waiting:
                                                          return const Center(
                                                              child: CircularProgressIndicator(
                                                                strokeWidth: 0.3,
                                                                color: Colors.cyan,
                                                              ));
                                                        default:
                                                          if (snapshot.hasError) {
                                                            return const Text("Error with server");
                                                          }
                                                          else {
                                                            return Padding(
                                                              padding: const EdgeInsets.only(left: 20,right: 10),
                                                              child: ListView.builder(
                                                                physics: const NeverScrollableScrollPhysics(),
                                                                itemCount: Subjects!.length,
                                                                shrinkWrap: true,
                                                                itemBuilder: (BuildContext context, int index) {
                                                                  final SubjectsData = Subjects[index];
                                                                  return Padding(
                                                                    padding: const EdgeInsets.all(3.0),
                                                                    child: InkWell(
                                                                      child: Container(
                                                                          decoration:  BoxDecoration(
                                                                            borderRadius: BorderRadius.all(Radius.circular(15)
                                                                            ),
                                                                            gradient: LinearGradient(
                                                                                begin: Alignment.topRight,
                                                                                end: Alignment.bottomLeft,
                                                                                colors: [Colors.deepOrange.withOpacity(0.3), Colors.red.withOpacity(0.3),Colors.orangeAccent.withOpacity(0.3)]
                                                                            ),
                                                                          ),
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Text(SubjectsData.name,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.blue),),
                                                                          )),
                                                                      onTap: (){
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => electronicComponent(id1:SubjectsData0.id,pinDiagram:SubjectsData.pinDiagram,id2: SubjectsData.id,heading: SubjectsData.name,photoUrl: SubjectsData.photoUrl,)));

                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                                // separatorBuilder: (context, index) =>const Divider(),
                                                              ),
                                                            );
                                                          }
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () {

                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                            ),
                          );
                        }
                    }
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

Stream<List<electronicComponentsConvertor>> readelectronicComponents() => FirebaseFirestore.instance
    .collection('electronicComponents')
    .orderBy("heading", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => electronicComponentsConvertor.fromJson(doc.data())).toList());

Future createsensors({required String name, required String description,required String photoUrl}) async {
  final docflash = FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = electronicComponentsConvertor(id: docflash.id,name: name,photoUrl: "");
  final json = flash.toJson();
  await docflash.set(json);
}

class electronicComponentsConvertor {
  String id;
  final String name,photoUrl;
  electronicComponentsConvertor({this.id = "",required this.name,required this.photoUrl});
  Map<String, dynamic> toJson() => {
    "id": id,
    "heading":name,
    "photoUrl":photoUrl
  };

  static electronicComponentsConvertor fromJson(Map<String, dynamic> json) =>
      electronicComponentsConvertor(id: json['id'],name: json["heading"],photoUrl: json["photoUrl"]);
}
Stream<List<subElectronicComponentsConvertor>> readsubElectronicComponents(String id) => FirebaseFirestore.instance
    .collection('electronicComponents').doc(id).collection("subComponents")
    .orderBy("name", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => subElectronicComponentsConvertor.fromJson(doc.data())).toList());

Future createtoolsRequired({required String heading, required String description, required bool isHomePage,required bool isSubPage, required String creator,required String photoUrl}) async {
  final docflash = FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = subElectronicComponentsConvertor(id: docflash.id,name: heading,pinDiagram: "",photoUrl: "");
  final json = flash.toJson();
  await docflash.set(json);
}

class subElectronicComponentsConvertor {
  String id;
  final String name,photoUrl,pinDiagram;

  subElectronicComponentsConvertor({this.id = "",required this.name,required this.photoUrl,required this.pinDiagram});

  Map<String, dynamic> toJson() => {
    "id": id,
    "name":name,

  };

  static subElectronicComponentsConvertor fromJson(Map<String, dynamic> json) =>
      subElectronicComponentsConvertor(id: json['id'],name: json["name"],photoUrl: json["photoUrl"],pinDiagram: json["pinDiagram"]);
}

class electronicComponent extends StatefulWidget {
  String id1,id2, heading,photoUrl,pinDiagram;
  electronicComponent({required this.id1,required this.id2,required this.heading,required this.photoUrl,required this.pinDiagram});


  @override
  State<electronicComponent> createState() => _electronicComponentState();
}

class _electronicComponentState extends State<electronicComponent> {
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
            children: [
              Center(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(widget.heading,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
              )),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10,top: 5,bottom: 10),
                        child: Text(widget.heading,style: const TextStyle(fontSize: 35,fontWeight: FontWeight.w500),),
                      ),
                      if(widget.photoUrl.isNotEmpty)Center(child: Image.network(widget.photoUrl)),
                      StreamBuilder<List<electronicComponentsDescriptionConvertor>>(
                        stream: readelectronicComponentsDescription(widget.id1,widget.id2),
                        builder: (context, snapshot) {
                          final Subjects = snapshot.data;
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 0.3,
                                    color: Colors.cyan,
                                  ));
                            default:
                              if (snapshot.hasError) {
                                return const Text("Error with server");
                              }
                              else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    if(widget.photoUrl.isNotEmpty) const Padding(
                                      padding: EdgeInsets.only(left: 10,top: 5,bottom: 5),
                                      child: Text("Description",style: TextStyle(fontSize: 35,fontWeight:FontWeight.w500),),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20,right: 10),
                                      child: ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: Subjects!.length,
                                        shrinkWrap: true,
                                        itemBuilder: (BuildContext context, int index) {
                                          final SubjectsData = Subjects[index];
                                          return Text("          ${SubjectsData.name}");
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }
                          }
                        },
                      ),
                      if(widget.pinDiagram.isNotEmpty)const Padding(
                        padding: EdgeInsets.only(left: 10,top: 5,bottom: 5),
                        child: Text("Pin Diagram",style: TextStyle(fontSize: 35,fontWeight: FontWeight.w500),),
                      ),
                      if(widget.pinDiagram.isNotEmpty)Padding(
                        padding: const EdgeInsets.only(left: 3,right: 3,top: 10,bottom: 5),
                        child: Image.network(widget.pinDiagram,),
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
}

Stream<List<electronicComponentsDescriptionConvertor>> readelectronicComponentsDescription(String id1,String id2) => FirebaseFirestore.instance
    .collection('electronicComponents').doc(id1).collection("subComponents").doc(id2).collection("electronicComponentsDescription")
    .orderBy("index", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => electronicComponentsDescriptionConvertor.fromJson(doc.data())).toList());

Future createtoolsRequred({required String heading, required String description, required bool isHomePage,required bool isSubPage, required String creator,required String photoUrl}) async {
  final docflash = FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = electronicComponentsDescriptionConvertor(id: docflash.id,name: heading,i: 0);
  final json = flash.toJson();
  await docflash.set(json);
}

class electronicComponentsDescriptionConvertor {
  String id;
  final String name;
  final int i;

  electronicComponentsDescriptionConvertor({this.id = "",required this.name,required this.i});

  Map<String, dynamic> toJson() => {
    "id": id,
    "description":name,
  };

  static electronicComponentsDescriptionConvertor fromJson(Map<String, dynamic> json) =>
      electronicComponentsDescriptionConvertor(id: json['id'],name: json["description"],i: json["index"]);
}
