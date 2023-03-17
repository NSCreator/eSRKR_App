import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'arduino.dart';
import 'imageZoom.dart';
import 'settings.dart';

class sensors extends StatefulWidget {
  const sensors({Key? key}) : super(key: key);

  @override
  State<sensors> createState() => _sensorsState();
}

class _sensorsState extends State<sensors> {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Sensors",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder<List<sensorsConvertor>>(
                  stream: readsensors(),
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
                                itemBuilder: (BuildContext context, int index) {
                                  final SubjectsData = Subjects[index];
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: InkWell(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 5,right: 5,bottom: 4),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.3), borderRadius: const BorderRadius.all(Radius.circular(15)),
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.black38, borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            SubjectsData.photoUrl,
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.black.withOpacity(0.6), borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                border: Border.all(color: Color.fromRGBO(174, 228, 242,0.3)),
                                                                color: Colors.black38, borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                image: DecorationImage(
                                                                  image: NetworkImage(
                                                                    SubjectsData.photoUrl,
                                                                  ),
                                                                  fit: BoxFit.cover,
                                                                ),),
                                                              height: 70,
                                                              width: 110,
                                                            ),
                                                            Expanded(
                                                                child: Container(

                                                                  decoration: BoxDecoration(
                                                                    // border: Border.all(color: Color.fromRGBO(174, 228, 242,0.3)),
                                                                    color:Colors.black.withOpacity(0.7),
                                                                    borderRadius: const BorderRadius.only(
                                                                        topRight: Radius.circular(10),
                                                                        bottomRight: Radius.circular(10)
                                                                    ),
                                                                  ),

                                                                  child: Padding(
                                                                    padding:const  EdgeInsets.all(8.0),
                                                                    child: Text(SubjectsData.name,style:const TextStyle(fontSize: 19,color: Colors.white), maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,),
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                      )
                                                  ),
                                                  StreamBuilder<List<sensorsDetailsConvertor>>(
                                                    stream: readsensorsDetails(SubjectsData.id),
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
                                                          } else {
                                                            return  ListView.separated(
                                                                physics: const BouncingScrollPhysics(),
                                                                itemCount: Subjects!.length,
                                                                shrinkWrap: true,
                                                                padding: EdgeInsets.only(left: 5,right: 5),
                                                                itemBuilder: (BuildContext context, int index) {
                                                                  final data = Subjects[index];
                                                                  return Padding(
                                                                    padding: const EdgeInsets.only(left: 10,right: 10),
                                                                    child: Row(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left: 5,right: 5),
                                                                          child: Icon(Icons.circle,size: 6,color: Colors.white,),
                                                                        ),
                                                                        Text(data.name,style: TextStyle(fontSize: 16,color: Colors.white),),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                                separatorBuilder: (context, index) => const SizedBox(
                                                                  height: 10,
                                                                  child: Divider(
                                                                    color: Colors.blue,
                                                                  ),
                                                                )
                                                            );

                                                          }
                                                      }
                                                    },
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => sensor(pinDiagram:SubjectsData.pinDiagram,id: SubjectsData.id,heading: SubjectsData.name,description: SubjectsData.description,photoUrl: SubjectsData.photoUrl,)));

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

Stream<List<sensorsDetailsConvertor>> readsensorsDetails(String id) =>
    FirebaseFirestore.instance
        .collection('sensors').doc(id).collection("details")
        .orderBy("name", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => sensorsDetailsConvertor.fromJson(doc.data()))
        .toList());

Future createsensorsDetails(
    {required String heading,required String id}) async {
  final docflash =
  FirebaseFirestore.instance.collection('sensors').doc(id).collection("details").doc();
  final flash = sensorsDetailsConvertor(
      id: docflash.id,
      name: heading,
  );
  final json = flash.toJson();
  await docflash.set(json);
}

class sensorsDetailsConvertor {
  String id;
  final String name;

  sensorsDetailsConvertor({this.id = "", required this.name});

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };

  static sensorsDetailsConvertor fromJson(Map<String, dynamic> json) =>
      sensorsDetailsConvertor(id: json['id'], name: json["name"]);
}


Stream<List<sensorsConvertor>> readsensors() => FirebaseFirestore.instance
    .collection('sensors')
    .orderBy("name", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => sensorsConvertor.fromJson(doc.data())).toList());

Future createsensors({required String name, required String description,required String photoUrl}) async {
  final docflash = FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = sensorsConvertor(id: docflash.id,name: name,description: description,photoUrl: photoUrl,pinDiagram: "");
  final json = flash.toJson();
  await docflash.set(json);
}

class sensorsConvertor {
  String id;
  final String name,description,photoUrl,pinDiagram;


  sensorsConvertor({this.id = "",required this.name,required this.description,required this.photoUrl,required this.pinDiagram});

  Map<String, dynamic> toJson() => {
    "id": id,
    "name":name,
    "description":description,
    "photoUrl":photoUrl,
    "pinDiagram":pinDiagram
  };

  static sensorsConvertor fromJson(Map<String, dynamic> json) =>
      sensorsConvertor(id: json['id'],name: json["name"],description: json["description"],photoUrl: json["photoUrl"],pinDiagram: json["pinDiagram"]);
}

class sensor extends StatefulWidget {
  String id, heading, description,photoUrl,pinDiagram;
  sensor({required this.id,required this.heading, required this.description,required this.photoUrl,required this.pinDiagram});


  @override
  State<sensor> createState() => _sensorState();
}

class _sensorState extends State<sensor> {
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
                padding: const EdgeInsets.all(2.0),
                child: Text(widget.heading,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500),),
              )),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.heading,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.w500,color: Colors.white),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("                 ${widget.description}",style: const TextStyle(color: Colors.white),),
                      ),
                      if(widget.photoUrl.isNotEmpty)Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text("Image :",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500,color: Colors.white),),
                      ),
                      if(widget.photoUrl.isNotEmpty)Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          child: Container(
                            height: 250,
                            alignment:
                            Alignment.center,
                            decoration:
                            BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(widget.photoUrl),
                                  fit: BoxFit.cover,
                                )),),
                          onTap: (){
                            showToast(longPressToViewImage);
                          },
                          onLongPress: (){
                            if(widget.photoUrl.length>3) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          zoom(url: widget.photoUrl)
                                  ));
                            }else{
                              showToast(noImageUrl);
                            }

                          },
                        ),
                      ),
                      if(widget.pinDiagram.isNotEmpty)Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text("Pin Diagram :",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
                      ),
                      if(widget.pinDiagram.isNotEmpty)Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          child: Container(
                            height: 250,
                            alignment:
                            Alignment.center,
                            decoration:
                            BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(widget.pinDiagram),
                                  fit: BoxFit.cover,
                                )),),
                          onTap: (){
                            showToast(longPressToViewImage);
                          },
                          onLongPress: (){
                            if(widget.pinDiagram.length>3) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          zoom(url: widget.pinDiagram)
                                  ));
                            }else{
                              showToast(noImageUrl);
                            }

                          },
                        ),
                      ),
                      StreamBuilder<List<pinOutDetailConvertor>>(
                        stream: readpinOutDetail(widget.id),
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
                                      padding: EdgeInsets.only(left: 8),
                                      child: Text("Pin Out InDetail",style: TextStyle(fontSize: 25,color: Colors.white),),
                                    ),
                                    const SizedBox(height: 10,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20,right: 10),
                                      child: ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: Subjects!.length,
                                        shrinkWrap: true,
                                        itemBuilder: (BuildContext context, int index) {
                                          final SubjectsData = Subjects[index];
                                          return Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(Icons.circle,size: 10,color: Colors.white,),
                                                  const SizedBox(width: 5,),
                                                  Expanded(child: Text(SubjectsData.name,style: TextStyle(fontSize: 20,color: Colors.white),)),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 20,top: 5,bottom: 5,right: 5),
                                                child: Text(SubjectsData.description,style: TextStyle(fontSize: 16,color: Colors.white),),
                                              )
                                            ],
                                          );
                                        },
                                        // separatorBuilder: (context, index) =>const Divider(),
                                      ),
                                    ),
                                  ],
                                );
                              }
                          }
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Example Code :",style: TextStyle(fontSize: 25,color: Colors.white),),
                      ),
                      const SizedBox(height: 20,)
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
Stream<List<pinOutDetailConvertor>> readpinOutDetail(String id) => FirebaseFirestore.instance
    .collection('sensors').doc(id).collection("pinOutInDetail")
    .orderBy("name", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => pinOutDetailConvertor.fromJson(doc.data())).toList());

Future createtoolsRequired({required String heading, required String description, required bool isHomePage,required bool isSubPage, required String creator,required String photoUrl}) async {
  final docflash = FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = pinOutDetailConvertor(id: docflash.id,name: heading,description: "");
  final json = flash.toJson();
  await docflash.set(json);
}

class pinOutDetailConvertor {
  String id;
  final String name,description;

  pinOutDetailConvertor({this.id = "",required this.name,required this.description});

  Map<String, dynamic> toJson() => {
    "id": id,
    "name":name,
    "description":description

  };

  static pinOutDetailConvertor fromJson(Map<String, dynamic> json) =>
      pinOutDetailConvertor(id: json['id'],name: json["name"],description: json["description"]);
}
