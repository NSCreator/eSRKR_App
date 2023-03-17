// ignore_for_file: import_of_legacy_library_into_null_safe, non_constant_identifier_names, camel_case_types, must_be_immutable, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';

class raspberrypi extends StatefulWidget {
  const raspberrypi({Key? key}) : super(key: key);
  @override
  State<raspberrypi> createState() => _raspberrypiState();
}
class _raspberrypiState extends State<raspberrypi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade700,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const PageScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Center(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Raspberry Pi",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
              )),
              Padding(
                padding: const EdgeInsets.only(left: 8,right: 8),
                child: InkWell(
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.black38, borderRadius: BorderRadius.all(Radius.circular(15)),
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://ettron.com/wp-content/uploads/2021/07/different-types-of-Arduino-boards.jpg",
                        ),
                        fit: BoxFit.cover,
                      ),),
                    child: Row(
                      children: [
                        const SizedBox(width: 20,),
                        Container(
                          color: Colors.black.withOpacity(0.7),
                          child: const Text(
                            "Raspberry Pi Boards",
                            style:  TextStyle(
                              fontSize: 35.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.8),
                                borderRadius: const BorderRadius.all(Radius.circular(7)),),

                              child:const Icon(Icons.arrow_forward_ios,size: 40,color: Colors.white,)),
                        )
                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const raspberrypiBoards()));
                  },
                ),
              ),
              const SizedBox(height: 3,),
              Padding(
                padding : const EdgeInsets.only(left: 8,right: 8),
                child: InkWell(
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.black38, borderRadius: BorderRadius.all(Radius.circular(15)),
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://fiverr-res.cloudinary.com/images/t_main1,q_auto,f_auto,q_auto,f_auto/gigs/140496134/original/0d28d0884a323fd151c9e6fae143352ab0978f72/deliver-a-proof-of-concept-design-for-electronics-arduino.png",
                        ),
                        fit: BoxFit.cover,
                      ),),
                    child: Row(
                      children: [
                        const SizedBox(width: 20,),
                        Container(
                          color: Colors.black.withOpacity(0.7),
                          child: const Text(
                            "Raspberry Pi Projects",
                            style: TextStyle(
                              fontSize: 35.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(0.8),
                            borderRadius:const BorderRadius.all(Radius.circular(7)),),
                              child:const Icon(Icons.arrow_forward_ios,size: 40,color: Colors.white,)),
                        )
                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const raspberrypiProjects()));
                  },
                ),
              ),


              StreamBuilder<List<raspberrypiProjectsConvertor>>(
                stream: readraspberrypiProjects(),
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
                        if (Subjects!.isNotEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10,top: 20,bottom: 8),
                                child: Text("Mostly Viewed Projects",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 30),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5,right: 5),
                                child: GridView.builder(
                                    scrollDirection: Axis.vertical,
                                    physics:const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                      childAspectRatio: 1.02,
                                    ),
                                    itemCount: Subjects.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      if(Subjects[index].isSubPage == true){
                                        return InkWell(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black38,
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 130,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: Colors.black54,
                                                        borderRadius: BorderRadius.circular(15),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            Subjects[index].photoUrl,
                                                          ),
                                                          fit: BoxFit.cover,
                                                        )
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Align(
                                                              alignment: Alignment.topLeft,
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(3.0),
                                                                child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.black.withOpacity(0.1),
                                                                      borderRadius: BorderRadius.circular(15),

                                                                    ),
                                                                    child: Column(
                                                                      children: const [
                                                                        Icon(Icons.favorite_border,size: 30,color: Colors.red,),
                                                                        Icon(Icons.library_add_check_outlined,size: 30,color: Colors.tealAccent,),
                                                                      ],
                                                                    )
                                                                ),
                                                              ),

                                                            ),
                                                            const Spacer(),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.black.withOpacity(0.1),
                                                                borderRadius: BorderRadius.circular(25),

                                                              ),
                                                              child: const Padding(
                                                                padding: EdgeInsets.all(3.5),
                                                                child: Align(
                                                                  alignment: Alignment.topRight,
                                                                  child: Icon(Icons.add_shopping_cart,size: 30,color: Colors.white,),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),



                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:const EdgeInsets.only(left: 5,right: 5,bottom: 3,top: 5),
                                                    child: Text(Subjects[index].heading,style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Colors.white), maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 10,right: 10,bottom: 1),
                                                    child: Text("by : ${Subjects[index].creator}",style:const TextStyle(fontWeight: FontWeight.w400,fontSize: 11,color: Colors.white54),
                                                      maxLines: 1,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            onTap: (){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => raspberrypiProject(id: Subjects[index].id,heading: Subjects[index].heading,description: Subjects[index].description,photoUrl: Subjects[index].photoUrl,)));
                                            }
                                        );
                                      }
                                      else {
                                        return Container();
                                      }
                                    }),
                              ),
                            ],
                          );
                        }
                        else {
                          return
                            Container();
                        }
                      }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class raspberrypiBoards extends StatefulWidget {
  const raspberrypiBoards({Key? key}) : super(key: key);

  @override
  State<raspberrypiBoards> createState() => _raspberrypiBoardsState();
}

class _raspberrypiBoardsState extends State<raspberrypiBoards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade700,
      body: SafeArea(
        child: Column(
          children: [
            const Center(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Raspberry pi Board",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
            )),
            Expanded(
              child: StreamBuilder<List<raspiBoardsConvertor>>(
                stream: readraspiBoards(),
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
                        return AnimationLimiter(
                          child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: Subjects!.length,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(left: 5,right: 5),
                              itemBuilder: (BuildContext context, int index) {
                                final SubjectsData = Subjects[index];
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: InkWell(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(15)),
                                            gradient: LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                                colors: [Colors.black38, Colors.black38,Colors.black87]
                                            ),
                                            // color: Colors.black,
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 280,
                                                  width: double.infinity,
                                                  decoration:  BoxDecoration(
                                                    color: Colors.black38,
                                                    borderRadius:const BorderRadius.all(Radius.circular(15)),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        SubjectsData.photoUrl,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),),
                                                  child: Align(
                                                    alignment: Alignment.bottomLeft,
                                                    child: Container(
                                                      width: double.infinity,
                                                      // height: 50,
                                                      decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.only(
                                                            bottomLeft: Radius.circular(15),
                                                            bottomRight: Radius.circular(15)
                                                        ),
                                                        gradient: LinearGradient(
                                                            begin: Alignment.topRight,
                                                            end: Alignment.bottomLeft,
                                                            colors: [Colors.black12, Colors.black38,Colors.black54]
                                                        ),
                                                        // color: Colors.black,
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(
                                                          SubjectsData.name,
                                                          style: const TextStyle(
                                                            fontSize: 28.0,
                                                            color: Colors.tealAccent,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                              ),

                                              Padding(
                                                padding: const  EdgeInsets.only(left: 20,right: 20,bottom: 2),
                                                child:
                                                Text(
                                                  SubjectsData.description,
                                                  style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.white),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),


                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => raspberrypiBoard(id: SubjectsData.id,heading: SubjectsData.name,description: SubjectsData.description,photoUrl: SubjectsData.photoUrl,)));

                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => const SizedBox(
                                height: 10,
                                child: Divider(
                                  color: Colors.blue,
                                ),
                              )
                          ),
                        );
                      }
                  }
                },
              ),
            ),

          ],
        ),
      ),);
  }
}

Stream<List<raspiBoardsConvertor>> readraspiBoards() => FirebaseFirestore.instance
    .collection('raspberrypi').doc("raspberrypiBoard").collection("Boards")
    .orderBy("name", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => raspiBoardsConvertor.fromJson(doc.data())).toList());

Future createraspiBoards({required String name, required String description,required String photoUrl}) async {
  final docflash = FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = raspiBoardsConvertor(id: docflash.id,name: name,description: description,photoUrl: photoUrl);
  final json = flash.toJson();
  await docflash.set(json);
}

class raspiBoardsConvertor {
  String id;
  final String name,description,photoUrl;


  raspiBoardsConvertor({this.id = "",required this.name,required this.description,required this.photoUrl});

  Map<String, dynamic> toJson() => {
    "id": id,
    "name":name,
    "description":description,
    "photoUrl":photoUrl
  };

  static raspiBoardsConvertor fromJson(Map<String, dynamic> json) =>
      raspiBoardsConvertor(id: json['id'],name: json["name"],description: json["description"],photoUrl: json["photoUrl"]);
}

class raspberrypiBoard extends StatefulWidget {
  String id, heading, description,photoUrl;
  raspberrypiBoard({required this.id,required this.heading, required this.description,required this.photoUrl});

  @override
  State<raspberrypiBoard> createState() => _raspberrypiBoardState();
}

class _raspberrypiBoardState extends State<raspberrypiBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.heading,style: const TextStyle(fontSize: 30,fontWeight: FontWeight.w500),),
              Text(widget.description),
              Image.network(widget.photoUrl),
              StreamBuilder<List<raspiSpecificationConvertor>>(
                stream: readraspiSpecification(widget.id),
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
                              padding: EdgeInsets.only(left: 5),
                              child: Text("Specification",style: TextStyle(fontSize: 25),),
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
                                  return Row(
                                    children: [
                                      const Icon(Icons.circle,size: 10,),
                                      const SizedBox(width: 5,),
                                      Expanded(child: Text(SubjectsData.name)),
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
              Center(child: Text("--${widget.heading}--"))
            ],
          ),
        ),
      ),
    );
  }
}
Stream<List<raspiSpecificationConvertor>> readraspiSpecification(String id) => FirebaseFirestore.instance
    .collection('raspberrypi').doc("raspberrypiBoard").collection("Boards").doc(id).collection("specification")
    .orderBy("data", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => raspiSpecificationConvertor.fromJson(doc.data())).toList());

Future createraspiSpecification({required String heading, required String description, required bool isHomePage,required bool isSubPage, required String creator,required String photoUrl}) async {
  final docflash = FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = raspiSpecificationConvertor(id: docflash.id,name: heading);
  final json = flash.toJson();
  await docflash.set(json);
}

class raspiSpecificationConvertor {
  String id;
  final String name;

  raspiSpecificationConvertor({this.id = "",required this.name});

  Map<String, dynamic> toJson() => {
    "id": id,
    "data":name,

  };

  static raspiSpecificationConvertor fromJson(Map<String, dynamic> json) =>
      raspiSpecificationConvertor(id: json['id'],name: json["data"]);
}


class raspberrypiProjects extends StatefulWidget {
  const raspberrypiProjects({Key? key}) : super(key: key);

  @override
  State<raspberrypiProjects> createState() => _raspberrypiProjectsState();
}

class _raspberrypiProjectsState extends State<raspberrypiProjects> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade700,
      body: SafeArea(
        child: Column(
          children: [
            const Center(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Raspberry Pi Projects",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
            )),
            Expanded(
              child: StreamBuilder<List<raspberrypiProjectsConvertor>>(
                stream: readraspberrypiProjects(),
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
                        return AnimationLimiter(
                          child: ListView.separated(
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
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(15)),
                                            gradient: LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                                colors: [Colors.black38, Colors.black38,Colors.black87]
                                            ),
                                            // color: Colors.black,
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 200,
                                                width: double.infinity,
                                                decoration:  BoxDecoration(
                                                  color: Colors.black38,
                                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      SubjectsData.photoUrl,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),),
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height:150 ,),
                                                    Container(
                                                      width: double.infinity,
                                                      height: 50,
                                                      decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.only(
                                                            bottomLeft: Radius.circular(15),
                                                            bottomRight: Radius.circular(15)
                                                        ),
                                                        gradient: LinearGradient(
                                                            begin: Alignment.topRight,
                                                            end: Alignment.bottomLeft,
                                                            colors: [Colors.black12, Colors.black38,Colors.black54]
                                                        ),
                                                        // color: Colors.black,
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 10,top: 5,bottom: 3,right: 10),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              SubjectsData.heading,
                                                              style: const TextStyle(
                                                                fontSize: 28.0,
                                                                color: Colors.tealAccent,
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Spacer(),
                                                                Text(
                                                                  "by : ${SubjectsData.creator}",
                                                                  style: const TextStyle(
                                                                    fontSize: 11.0,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w400,
                                                                  ),
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              Padding(
                                                padding:  EdgeInsets.only(left: 20,right: 20,bottom: 2),
                                                child:
                                                Text(
                                                  SubjectsData.description,
                                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.white),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),


                                            ],
                                          ),
                                        ),
                                        onTap: () {

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => raspberrypiProject(id: SubjectsData.id,heading: SubjectsData.heading,description: SubjectsData.description,photoUrl: SubjectsData.photoUrl,)));

                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => const SizedBox(
                                height: 10,
                                child: Divider(
                                  color: Colors.blue,
                                ),
                              )
                          ),
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),);
  }
}

class raspberrypiProject extends StatefulWidget {
  String id, heading, description,photoUrl;
  raspberrypiProject({required this.id,required this.heading, required this.description,required this.photoUrl});
  @override
  State<raspberrypiProject> createState() => _raspberrypiProjectState();
}

class _raspberrypiProjectState extends State<raspberrypiProject> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.heading,style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500),),
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 10,top: 10,bottom: 10),
                child: Container(child: Text(widget.description,style: TextStyle(fontSize: 15),)),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Image.network(widget.photoUrl),
              ),
              const Divider(),
              StreamBuilder<List<arduinoProjectComponentConvertor>>(
                stream: readarduinoProjectComponent(widget.id),
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
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Components",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
                            const SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(left: 20,right: 10),
                              child: ListView.separated(
                                itemCount: Subjects!.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  final SubjectsData = Subjects[index];
                                  return Row(
                                    children: [
                                      Text("${SubjectsData.quantity}",style: const TextStyle(fontSize: 20,color: Colors.red)),
                                      const SizedBox(width: 10,),
                                      Text(SubjectsData.name,style: const TextStyle(fontSize: 20,),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                      const SizedBox(width: 30,)
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) =>Divider(),
                              ),
                            ),
                          ],
                        );
                      }
                  }
                },
              ),
              StreamBuilder<List<arduinoProjectDescriptionConvertor>>(
                stream: readarduinoProjectDescription(widget.id),
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
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Project Description",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: Subjects!.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                final SubjectsData = Subjects[index];
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(SubjectsData.heading,style: TextStyle(fontSize: 20,color: Colors.black)),
                                    SizedBox(width: 10,),
                                    Image.network(SubjectsData.photoUrl),
                                    Text(SubjectsData.description,style: TextStyle(fontSize: 20,),),

                                  ],
                                );
                              },
                            ),
                            InkWell(child: Text("Download",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500)),
                            onTap: (){
                              _launchUrl("blob:https://projecthub.arduino.cc/1faa3a2c-b16d-421c-82fe-02745f4bf9a5");
                            },)
                          ],
                        );
                      }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
_externalLaunchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn, mode: LaunchMode.externalApplication)) throw 'Could not launch $urlIn';
}

_launchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn, mode: LaunchMode.inAppWebView)) throw 'Could not launch $urlIn';
}

Stream<List<raspberrypiProjectsConvertor>> readraspberrypiProjects() => FirebaseFirestore.instance
    .collection('raspberrypi').doc("raspberrypiProjects").collection("projects")
    .orderBy("heading", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => raspberrypiProjectsConvertor.fromJson(doc.data())).toList());

Future createarduinoProjects({required String heading, required String description, required bool isHomePage,required bool isSubPage, required String creator,required String photoUrl}) async {
  final docflash = FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = raspberrypiProjectsConvertor(id: docflash.id,heading: heading,description: description,isHomePage: isHomePage,isSubPage: isSubPage,creator: creator,photoUrl: photoUrl);
  final json = flash.toJson();
  await docflash.set(json);
}

class raspberrypiProjectsConvertor {
  String id;
  final String heading,description,creator,photoUrl;
  final bool isSubPage,isHomePage;

  raspberrypiProjectsConvertor({required this.isSubPage,required this.isHomePage,this.id = "",required this.heading,required this.description,required this.creator,required this.photoUrl});

  Map<String, dynamic> toJson() => {
    "id": id,
    "heading":heading,
    "description":description,
    "isSubPage":isSubPage,
    "isHomePage":isHomePage,
    "creator":creator,
    "photoUrl":photoUrl
  };

  static raspberrypiProjectsConvertor fromJson(Map<String, dynamic> json) =>
      raspberrypiProjectsConvertor(id: json['id'],isSubPage:json["isSubPage"],isHomePage:json["isHomePage"],heading: json["heading"],description: json["description"],creator: json["creator"],photoUrl: json["photoUrl"]);
}

Stream<List<arduinoProjectComponentConvertor>> readarduinoProjectComponent(String id) => FirebaseFirestore.instance
    .collection('arduino').doc("arduinoProjects").collection("projects").doc(id).collection("components")
    .orderBy("name", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => arduinoProjectComponentConvertor.fromJson(doc.data())).toList());

Future createarduinoProjectComponent({required String heading, required String description, required int quantity}) async {
  final docflash = FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = arduinoProjectComponentConvertor(id: docflash.id,name: heading,link: description,quantity:quantity );
  final json = flash.toJson();
  await docflash.set(json);
}

class arduinoProjectComponentConvertor {
  String id;
  final String name,link;
  final int quantity;



  arduinoProjectComponentConvertor({this.id = "",required this.name,required this.link,required this.quantity});

  Map<String, dynamic> toJson() => {
    "id": id,
    "name":name,
    "link":link,
    "quantity":quantity
  };

  static arduinoProjectComponentConvertor fromJson(Map<String, dynamic> json) =>
      arduinoProjectComponentConvertor(id: json['id'],name: json["name"],link: json["link"],quantity: json["quantity"]);
}

Stream<List<arduinoProjectDescriptionConvertor>> readarduinoProjectDescription(String id) => FirebaseFirestore.instance
    .collection('arduino').doc("arduinoProjects").collection("projects").doc(id).collection("projectDescription")
    .orderBy("heading", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => arduinoProjectDescriptionConvertor.fromJson(doc.data())).toList());

Future createarduinoProjectDescription({required String heading, required String description, required String photoUrl}) async {
  final docflash = FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = arduinoProjectDescriptionConvertor(id: docflash.id,heading: heading,description: description,photoUrl:photoUrl );
  final json = flash.toJson();
  await docflash.set(json);
}

class arduinoProjectDescriptionConvertor {
  String id;
  final String heading,description,photoUrl;




  arduinoProjectDescriptionConvertor({this.id = "",required this.heading,required this.description,required this.photoUrl});

  Map<String, dynamic> toJson() => {
    "id": id,
    "heading":heading,
    "description":description,
    "photoUrl":photoUrl
  };

  static arduinoProjectDescriptionConvertor fromJson(Map<String, dynamic> json) =>
      arduinoProjectDescriptionConvertor(id: json['id'],heading: json["heading"],description: json["description"],photoUrl: json["photoUrl"]);
}

