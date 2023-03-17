
// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prokoni/electronicProjects.dart';
import 'package:prokoni/raspberrypi.dart';
import 'package:prokoni/sensors.dart';

import 'arduino.dart';
import 'electronicComponents.dart';
import 'saveCartList.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [ Color.fromRGBO(53, 166, 204, 1),Color.fromRGBO(24, 45, 74, 1),Color.fromRGBO(21, 47, 61, 1)]
            ),
          ),
          child: Column(
            children: [
              Container(
                decoration:  const BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: [Color.fromRGBO( 0, 0, 0, 0.6), Color.fromRGBO(28, 112, 138, 0.3)]
                  ),
                ),
                child: Row(
                  children: const[
                     Padding(
                       padding: EdgeInsets.only(left: 20,top: 4,bottom: 4),
                       child: Text("ProKoni.in",
                        style: TextStyle(
                          fontSize: 28.0,
                          color: Color.fromRGBO(192, 237, 252,1 ),
                          fontWeight: FontWeight.w400,
                        ),),
                     )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics:const  BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: StreamBuilder<List<statusConvertor>>(
                            stream: readStatus(),
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
                                    return const Center(
                                        child: Text(
                                            'Error with Server or\n Check Internet Connection'));
                                  } else {
                                    if (BranchNews!.isEmpty) {
                                      return Container();
                                    } else {
                                      return CarouselSlider(
                                        items: List.generate(
                                          BranchNews.length,
                                              (int index) {
                                            final BranchNew = BranchNews[index];
                                            return InkWell(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 180,
                                                    width: double.infinity,
                                                    // margin: const EdgeInsets.all(4.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15),
                                                      color: Colors.black.withOpacity(0.4),
                                                      border: Border.all(color: const Color.fromRGBO(174, 228, 242,0.5)),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          BranchNew.photoUrl,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(BranchNew.heading,overflow: TextOverflow.ellipsis,style: const TextStyle(color: Color.fromRGBO(213, 224, 227,1,),fontSize: 17),)
                                                ],
                                              ),
                                              onTap: () async {
                                             if(BranchNew.mode=="arduino"){
                                               Navigator.push(
                                                   context,
                                                   MaterialPageRoute(
                                                       builder: (context) => arduinoProject(id: BranchNew.projectId, heading: BranchNew.heading, description: BranchNew.description, photoUrl: BranchNew.photoUrl, youtubeUrl: BranchNew.videoUrl)));
                                             }
                                             else if (BranchNew.mode == "ep"){
                                               // Navigator.push(
                                               //     context,
                                               //     MaterialPageRoute(
                                               //         builder: (context) => electronicProject(circuitDiagram:BranchNew.circuitDiagram,id: BranchNew.projectId, heading: BranchNew.heading, description: BranchNew.description, photoUrl: BranchNew.photoUrl, youtubeUrl: BranchNew.videoUrl)));

                                             }
                                                },
                                            );
                                          },
                                        ),
                                        //Slider Container properties
                                        options: CarouselOptions(
                                          viewportFraction: 0.95,
                                          enlargeCenterPage: true,
                                          height: 230,
                                          autoPlayAnimationDuration:
                                          const Duration(milliseconds: 2000),
                                          autoPlay: true,
                                        ),
                                      );
                                    }
                                  }
                              }
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20,bottom: 5),
                        child: Row(
                          children: const [
                            Text("Projects",
                              style:  TextStyle(
                                fontSize: 35.0,
                                color: Color.fromRGBO(195, 228, 250, 1),
                                fontWeight: FontWeight.w500,
                              ),)
                          ],
                        ),
                      ),
                      StreamBuilder<List<projectListConvertor>>(
                        stream: readProjectList(),
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
                                if (Subjects!.isNotEmpty) {
                                  return ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: Subjects.length,
                                    itemBuilder: (context, int index) {
                                      final SubjectsData = Subjects[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 2,left: 10,right: 10),
                                        child: InkWell(
                                          child: Container(
                                            height: 67,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Color.fromRGBO(174, 228, 242,0.3)),
                                              color: Colors.black38, borderRadius: const BorderRadius.all(Radius.circular(15)),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  SubjectsData.photoUrl,
                                                ),
                                                fit: BoxFit.cover,
                                              ),),
                                            child: Row(
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Spacer(),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.black.withOpacity(0.6),
                                                        borderRadius: BorderRadius.circular(15),
                                                      ),

                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 10,right: 10,top: 5),
                                                            child: Text(
                                                              SubjectsData.heading,
                                                              style: const TextStyle(
                                                                fontSize: 30.0,
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            SubjectsData.description,
                                                            style: const TextStyle(
                                                              fontSize: 13.0,
                                                              color: Color.fromRGBO(177, 182, 186, 1),
                                                            ),
                                                          ),
                                                          SizedBox(height: 3,)
                                                        ],
                                                      ),
                                                    ),


                                                  ],
                                                ),
                                                const Spacer(),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 10),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.blueGrey.withOpacity(0.8),
                                                        borderRadius: const BorderRadius.all(Radius.circular(7)),),

                                                      child: const Icon(Icons.arrow_forward_ios,size: 35,color: Colors.white,)),
                                                )
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            if(SubjectsData.index == 0){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => const Arduino()));
                                            }
                                            else if( SubjectsData.index== 1){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => const raspberrypi()));
                                            }
                                            if(SubjectsData.index == 2){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => const electronicProjects()));
                                            }
                                            else if(SubjectsData.index == 3){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => const sensors()));
                                            }
                                            else if(SubjectsData.index == 4){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => electronicComponents()));
                                            }
                                          },
                                        ),
                                      );


                                    },
                                  );
                                } else {
                                  return
                                    Container();
                                }
                              }
                          }
                        },
                      ),

                      StreamBuilder<List<treadingProjectsConvertor>>(
                          stream: readtreadingProjects(),
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
                                          "No Treading Projects",
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
                                            "Treading Projects",
                                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500,color: Color.fromRGBO(195, 228, 250, 1),),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 140,
                                          child: ListView.separated(
                                            physics: const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: Books.length,
                                            itemBuilder: (BuildContext context, int index) => InkWell(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 10),
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
                                                        height: 140,
                                                        width: 200,
                                                        child: Align(
                                                          alignment: Alignment.bottomLeft,
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.black.withOpacity(0.5),
                                                              borderRadius: BorderRadius.circular(15),

                                                            ),
                                                            child:  Padding(
                                                              padding: EdgeInsets.all(7.0),
                                                              child: Text(Books[index].heading,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Colors.white), maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,),
                                                            ),
                                                          ),

                                                        ),
                                                      ),

                                                      if(Books[index].mode=="a")Padding(
                                                        padding: const EdgeInsets.only(left: 1,right: 1),
                                                        child: Column(
                                                          children: const[
                                                            SizedBox(height: 22,),
                                                            Text("A",style: TextStyle(color: Color.fromRGBO(146, 202, 247,1),),),
                                                            Text("R",style: TextStyle(color: Color.fromRGBO(146, 202, 247,1),),),
                                                            Text("D",style: TextStyle(color: Color.fromRGBO(146, 202, 247,1),),),
                                                            Text("U",style: TextStyle(color: Color.fromRGBO(146, 202, 247,1),),),
                                                            Text("I",style: TextStyle(color: Color.fromRGBO(146, 202, 247,1),),),
                                                            Text("N",style: TextStyle(color: Color.fromRGBO(146, 202, 247,1),),),
                                                            Text("O",style: TextStyle(color: Color.fromRGBO(146, 202, 247,1),),),
                                                          ],
                                                        ),
                                                      ),
                                                      if(Books[index].mode=="r")Padding(
                                                        padding: const EdgeInsets.only(left: 1,right: 1),
                                                        child: Column(
                                                          children: const[
                                                            SizedBox(height: 22,),
                                                            Text("R",style: TextStyle(color: Color.fromRGBO(146, 202, 247,1),),),
                                                            Text("A",style: TextStyle(color: Color.fromRGBO(146, 202, 247,1),),),
                                                            Text("S",style: TextStyle(color: Color.fromRGBO(146, 202, 247,1),),),
                                                            Text("P",style: TextStyle(color: Color.fromRGBO(146, 202, 247,1),),),
                                                            Text(".",style: TextStyle(color: Color.fromRGBO(146, 202, 247,1),),),
                                                            Text("P",style: TextStyle(color: Color.fromRGBO(146, 202, 247,1),),),
                                                            Text("I",style: TextStyle(color: Color.fromRGBO(146, 202, 247,1),),),
                                                          ],
                                                        ),
                                                      ),
                                                      if(Books[index].mode=="ep")Padding(
                                                        padding: const EdgeInsets.only(left: 1,right: 1),
                                                        child: Column(
                                                          children: const[
                                                            SizedBox(height: 22,),
                                                            Text(".",style: TextStyle(color: Color.fromRGBO(146, 202, 247,1),),),
                                                            Text("O",style: TextStyle(color: Color.fromRGBO(146, 202, 247,1),),),
                                                            Text("T",style: TextStyle(color: Color.fromRGBO(146, 202, 247,1),),),
                                                            Text("H",style: TextStyle(color: Color.fromRGBO(146, 202, 247,1),),),
                                                            Text("E",style: TextStyle(color: Color.fromRGBO(146, 202, 247,1),),),
                                                            Text("R",style: TextStyle(color: Color.fromRGBO(146, 202, 247,1),),),
                                                            Text(".",style: TextStyle(color: Color.fromRGBO(146, 202, 247,1),),),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              onTap: () async {
                                                if(Books[index].mode=="a"){
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => arduinoProject(id: Books[index].projectId, heading: Books[index].heading, description: Books[index].description, photoUrl: Books[index].photoUrl, youtubeUrl: Books[index].videoUrl)));
                                                }
                                                else if (Books[index].mode == "ep"){
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) => electronicProject(circuitDiagram:Books[index].circuitDiagram,id: Books[index].projectId, heading: Books[index].heading, description: Books[index].description, photoUrl: Books[index].photoUrl, youtubeUrl: Books[index].videoUrl)));

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

                      StreamBuilder<List<arduinoHomePageProjectsConvertor>>(
                          stream: readarduinoHomePageProjects(),
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
                                          "Arduino Projects are not available",
                                          style: TextStyle(color: Colors.blue),
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
                                            "Arduino Projects",
                                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500,color: Color.fromRGBO(195, 228, 250, 1),),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 300,
                                          child: GridView.builder(
                                              scrollDirection: Axis.horizontal,
                                              physics:const BouncingScrollPhysics(),
                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 5,
                                                  mainAxisSpacing: 5,
                                                childAspectRatio: 0.73,
                                              ),
                                              itemCount: Books.length,
                                              itemBuilder: (BuildContext ctx, index) {
                                                return InkWell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.black38,
                                                        borderRadius: BorderRadius.circular(15),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height: 135,
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                                color: Colors.black54,
                                                                borderRadius: BorderRadius.circular(15),
                                                                image: DecorationImage(
                                                                  image: NetworkImage(
                                                                    Books[index].photoUrl,
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

                                                                const Spacer(),
                                                                Align(
                                                                  alignment: Alignment.bottomLeft,
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.black.withOpacity(0.4),
                                                                      borderRadius: BorderRadius.circular(15),

                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Text(Books[index].heading,style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Colors.white), maxLines: 2,
                                                                        overflow: TextOverflow.ellipsis,),
                                                                    ),
                                                                  ),

                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 10,right: 10),
                                                            child: Text("by ${Books[index].creator}",style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 11,color: Color.fromRGBO(164, 209, 245,1)),
                                                              maxLines: 1,

                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => arduinoProject(id: Books[index].projectId,heading: Books[index].heading,description: Books[index].description,photoUrl: Books[index].photoUrl, youtubeUrl:Books[index].videoUrl,))
                                                    );
                                                  },
                                                );
                                              }),
                                        ),

                                      ],
                                    );
                                  }
                                }
                            }
                          }),

                      // StreamBuilder<List<raspberrypiProjectsConvertor>>(
                      //     stream: readraspberrypiProjects(),
                      //     builder: (context, snapshot) {
                      //       final Books = snapshot.data;
                      //       switch (snapshot.connectionState) {
                      //         case ConnectionState.waiting:
                      //           return const Center(
                      //               child: CircularProgressIndicator(
                      //                 strokeWidth: 0.3,
                      //                 color: Colors.cyan,
                      //               ));
                      //         default:
                      //           if (snapshot.hasError) {
                      //             return const Center(child: Text('Error with TextBooks Data or\n Check Internet Connection'));
                      //           } else {
                      //             if (Books!.length < 1) {
                      //
                      //               return const Center(
                      //                 child: Padding(
                      //                   padding:  EdgeInsets.all(8.0),
                      //                   child: Text(
                      //                     "No ECE Books",
                      //                     style: TextStyle(color: Colors.blue),
                      //                   ),
                      //                 ),
                      //               );
                      //             } else {
                      //               return Column(
                      //                 crossAxisAlignment: CrossAxisAlignment.start,
                      //                 children: [
                      //                   const Padding(
                      //                     padding: EdgeInsets.only(left: 10, top: 20,bottom: 8),
                      //                     child: Text(
                      //                       "Raspberry pi Projects",
                      //                       style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                      //                     ),
                      //                   ),
                      //                   SizedBox(
                      //                     height: 300,
                      //                     child: GridView.builder(
                      //                         scrollDirection: Axis.horizontal,
                      //                         physics:const BouncingScrollPhysics(),
                      //                         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      //                           crossAxisCount: 2,
                      //                           crossAxisSpacing: 5,
                      //                           mainAxisSpacing: 5,
                      //                           childAspectRatio: 0.73,
                      //                         ),
                      //                         itemCount: Books.length,
                      //                         itemBuilder: (BuildContext ctx, index) {
                      //                           if(Books[index].isHomePage == true){
                      //                             return InkWell(
                      //                               child: Container(
                      //                                 decoration: BoxDecoration(
                      //                                   color: Colors.black38,
                      //                                   borderRadius: BorderRadius.circular(15),
                      //                                 ),
                      //                                 child: Column(
                      //                                   children: [
                      //                                     Container(
                      //                                       height: 135,
                      //                                       alignment: Alignment.center,
                      //                                       decoration: BoxDecoration(
                      //                                           color: Colors.black54,
                      //                                           borderRadius: BorderRadius.circular(15),
                      //                                           image: DecorationImage(
                      //                                             image: NetworkImage(
                      //                                               Books[index].photoUrl,
                      //                                             ),
                      //                                             fit: BoxFit.cover,
                      //                                           )
                      //                                       ),
                      //                                       child: Column(
                      //                                         children: [
                      //                                           Row(
                      //                                             children: [
                      //                                               Align(
                      //                                                 alignment: Alignment.topLeft,
                      //                                                 child: Padding(
                      //                                                   padding: const EdgeInsets.all(3.0),
                      //                                                   child: Container(
                      //                                                       decoration: BoxDecoration(
                      //                                                         color: Colors.black.withOpacity(0.1),
                      //                                                         borderRadius: BorderRadius.circular(15),
                      //
                      //                                                       ),
                      //                                                       child: Column(
                      //                                                         children: const [
                      //                                                           Icon(Icons.favorite_border,size: 30,color: Colors.red,),
                      //                                                           Icon(Icons.library_add_check_outlined,size: 30,color: Colors.tealAccent,),
                      //                                                         ],
                      //                                                       )
                      //                                                   ),
                      //                                                 ),
                      //
                      //                                               ),
                      //                                               const Spacer(),
                      //                                               Container(
                      //                                                 decoration: BoxDecoration(
                      //                                                   color: Colors.black.withOpacity(0.1),
                      //                                                   borderRadius: BorderRadius.circular(25),
                      //
                      //                                                 ),
                      //                                                 child: const Padding(
                      //                                                   padding:  EdgeInsets.all(3.5),
                      //                                                   child: Align(
                      //                                                     alignment: Alignment.topRight,
                      //                                                     child: Icon(Icons.add_shopping_cart,size: 30,color: Colors.white,),
                      //                                                   ),
                      //                                                 ),
                      //                                               ),
                      //                                             ],
                      //                                           ),
                      //
                      //                                           const Spacer(),
                      //                                           Align(
                      //                                             alignment: Alignment.bottomLeft,
                      //                                             child: Container(
                      //                                               decoration: BoxDecoration(
                      //                                                 color: Colors.black.withOpacity(0.4),
                      //                                                 borderRadius: BorderRadius.circular(15),
                      //
                      //                                               ),
                      //                                               child: Padding(
                      //                                                 padding:  EdgeInsets.all(8.0),
                      //                                                 child: Text(Books[index].heading,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Colors.white), maxLines: 2,
                      //                                                   overflow: TextOverflow.ellipsis,),
                      //                                               ),
                      //                                             ),
                      //
                      //                                           ),
                      //                                         ],
                      //                                       ),
                      //                                     ),
                      //                                     Padding(
                      //                                       padding:  EdgeInsets.only(left: 10,right: 10),
                      //                                       child: Text(Books[index].creator,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 11,color: Colors.white),
                      //                                         maxLines: 1,
                      //
                      //                                       ),
                      //                                     )
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                               onTap: (){
                      //                                 Navigator.push(context,  MaterialPageRoute(
                      //                                     builder: (context) =>  raspberrypiProject(description: Books[index].description,heading: Books[index].heading,photoUrl: Books[index].photoUrl,id: Books[index].id,)));
                      //
                      //                               },
                      //                             );
                      //                           }else{
                      //                             return Container();
                      //                           }
                      //                         }),
                      //                   ),
                      //
                      //                 ],
                      //               );
                      //             }
                      //           }
                      //       }
                      //     }),
                      //
                      StreamBuilder<List<electronicProjectsConvertor>>(
                        stream: readelectronicProjects(),
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
                                      padding:  EdgeInsets.all(8.0),
                                      child: Text(
                                        "Other Projects are not available",
                                        style: TextStyle(color: Colors.blue),
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
                                          "Other Projects",
                                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500,color: Color.fromRGBO(195, 228, 250, 1),),
                                        ),
                                      ),
                                      Container(
                                        height: 148,
                                        child: ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: Books.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context, int index) {
                                            final SubjectsData = Books[index];
                                            if (SubjectsData.home) {
                                              return InkWell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10),
                                                  child: Container(
                                                    width: 220,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black38,
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 135,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                              color: Colors.black54,
                                                              borderRadius: BorderRadius.circular(15),
                                                              image:  DecorationImage(
                                                                image: NetworkImage(
                                                                  SubjectsData.photoUrl,
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
                                                                            children: [
                                                                              InkWell(
                                                                                child: StreamBuilder<DocumentSnapshot>(
                                                                                  stream: FirebaseFirestore.instance.collection("electronicProjects").doc(SubjectsData.id).collection("likes").doc(fullUserId()).snapshots(),
                                                                                  builder: (context, snapshot) {
                                                                                    if (snapshot.hasData) {
                                                                                      if (snapshot.data!.exists) {
                                                                                        return const Icon(Icons.favorite,color: Colors.red,size: 30,);
                                                                                      } else {
                                                                                        return const Icon(Icons.favorite_border,color: Colors.red,size: 30,);
                                                                                      }
                                                                                    } else {
                                                                                      return Container();
                                                                                    }
                                                                                  },
                                                                                ),
                                                                                onTap:
                                                                                    () {
                                                                                  updateLike(
                                                                                      SubjectsData.id, fullUserId()
                                                                                  );
                                                                                },
                                                                              ),
                                                                              InkWell(
                                                                                child: StreamBuilder<DocumentSnapshot>(
                                                                                  stream: FirebaseFirestore.instance.collection('users').doc(fullUserId()).collection("savedElectronicProjects").doc(SubjectsData.id).snapshots(),
                                                                                  builder: (context, snapshot) {
                                                                                    if (snapshot.hasData) {
                                                                                      if (snapshot.data!.exists) {
                                                                                        return const Icon(
                                                                                          Icons.library_add_check,
                                                                                          size: 30, color: Colors.cyanAccent
                                                                                        );
                                                                                      } else {
                                                                                        return const Icon(
                                                                                          Icons.library_add_check_outlined,
                                                                                          size: 30,
                                                                                          color: Colors.cyanAccent,
                                                                                        );
                                                                                      }
                                                                                    } else {
                                                                                      return Container();
                                                                                    }
                                                                                  },
                                                                                ),
                                                                                onTap:
                                                                                    () async {
                                                                                  try {
                                                                                    await FirebaseFirestore
                                                                                        .instance
                                                                                        .collection('users')
                                                                                        .doc(fullUserId())
                                                                                        .collection("savedElectronicProjects")
                                                                                        .doc(SubjectsData.id)
                                                                                        .get()
                                                                                        .then((docSnapshot) {
                                                                                      if (docSnapshot.exists) {
                                                                                        FirebaseFirestore.instance.collection('users').doc(fullUserId()).collection("savedElectronicProjects").doc(SubjectsData.id).delete();
                                                                                        showToast("Removed from saved list");
                                                                                      } else {
                                                                                        createsavedelectronicProjects(projectId: SubjectsData.id, user: fullUserId(), description: SubjectsData.description, photoUrl: SubjectsData.photoUrl, videoUrl: SubjectsData.youtubeUrl, heading: SubjectsData.heading, circuitDiagram: SubjectsData.circuitDiagram, creator: SubjectsData.creator, creatorPhoto: SubjectsData.creatorPhoto, sourceName: SubjectsData.sourceName, source: SubjectsData.source);
                                                                                        showToast("Added to Save List");
                                                                                      }
                                                                                    });
                                                                                  } catch (e) {
                                                                                    print(
                                                                                        e);
                                                                                  }
                                                                                },
                                                                              ),
                                                                            ],
                                                                          )
                                                                      ),
                                                                    ),

                                                                  ),
                                                                  const Spacer(),
                                                                  InkWell(
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.black.withOpacity(0.1),
                                                                        borderRadius: BorderRadius.circular(25),

                                                                      ),
                                                                      child: const Padding(
                                                                        padding:  EdgeInsets.all(3.5),
                                                                        child: Align(
                                                                          alignment: Alignment.topRight,
                                                                          child: Icon(Icons.add_shopping_cart,size: 30,color: Colors.white,),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    onTap: (){
                                                                      showToast("Coming Soon");
                                                                    },
                                                                  ),
                                                                ],
                                                              ),

                                                              const Spacer(),
                                                              Align(
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
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:  const EdgeInsets.only(left: 10,right: 10),
                                                          child: Text("by ${SubjectsData.creator}",style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 11,color: Color.fromRGBO(164, 209, 245,1)),
                                                            maxLines: 1,

                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                onTap: () async {
                                                  if (fullUserId()!=ownnerId) {
                                                    try {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                          "electronicProjects")
                                                          .doc(SubjectsData.id)
                                                          .get()
                                                          .then(
                                                              (docSnapshot) async {
                                                            if (docSnapshot
                                                                .exists) {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                  "electronicProjects")
                                                                  .doc(SubjectsData
                                                                  .id)
                                                                  .update({
                                                                "views": docSnapshot
                                                                    .data()![
                                                                "views"] +
                                                                    1
                                                              });
                                                              showToast("+1 view");
                                                            } else {
                                                              showToast(
                                                                  "Error with adding views");
                                                            }
                                                          });
                                                    } catch (e) {
                                                      if (kDebugMode) {
                                                        print(e);
                                                      }
                                                    }
                                                  }
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => electronicProject(youtubeUrl: SubjectsData.youtubeUrl,circuitDiagram:SubjectsData.circuitDiagram,id: SubjectsData.id,heading: SubjectsData.heading,description: SubjectsData.description,photoUrl: SubjectsData.photoUrl, creatorPhoto: SubjectsData.creatorPhoto,creator: SubjectsData.creator, source: SubjectsData.source,sourceName: SubjectsData.sourceName,)));

                                                },
                                              );
                                            }
                                            else {
                                              return Container();                                              }
                                          },

                                        ),
                                      ),

                                    ],
                                  );
                                }
                              }
                          }
                        },
                      ),
                      SizedBox(height: 10,)
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


Stream<List<statusConvertor>> readStatus() => FirebaseFirestore.instance
    .collection('status')
    .snapshots()
    .map((snapshot) => snapshot.docs
    .map((doc) => statusConvertor.fromJson(doc.data()))
    .toList());

Future createStatus(
    {required String heading,
      required String description,
      required String circuitDiagram,
      required String projectId,
      required String mode,
      required String photoUrl,
      required String videoUrl
    }) async {
  final docflash = FirebaseFirestore.instance.collection("status").doc();
  final flash = statusConvertor(videoUrl:videoUrl,heading: heading,circuitDiagram:circuitDiagram,id: docflash.id,photoUrl: photoUrl,description: description,projectId: projectId,mode: mode);
  final json = flash.toJson();
  await docflash.set(json);
}

class statusConvertor {
  String id;
  final String photoUrl,mode,projectId,heading,circuitDiagram,description,videoUrl;

  statusConvertor({this.id = "",required this.circuitDiagram,required this.videoUrl,required this.description,required this.heading,required this.photoUrl,required this.projectId,required this.mode});

  Map<String, dynamic> toJson() => {
    "id": id,
    "photoUrl":photoUrl,
    "mode":mode,
    "projectId":projectId,
    "heading":heading,
    "description":description,
    "videoUrl":videoUrl,
    "circuitDiagram":circuitDiagram
  };

  static statusConvertor fromJson(Map<String, dynamic> json) =>
      statusConvertor(videoUrl:json["videoUrl"],circuitDiagram: json["circuitDiagram"],heading:json["heading"],description:json["description"],id: json['id'],photoUrl: json["photoUrl"],projectId: json["projectId"],mode: json["mode"]);
}

Stream<List<treadingProjectsConvertor>> readtreadingProjects() => FirebaseFirestore.instance
    .collection('treading projects')
    .orderBy("heading", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => treadingProjectsConvertor.fromJson(doc.data())).toList());

Future createtreadingProjects({required String heading,required String description, required String videoUrl, required String creator,required String photoUrl,required String circuitDiagram,required String mode,required String projectId}) async {
  final docflash = FirebaseFirestore.instance.collection('treading projects').doc();
  final flash = treadingProjectsConvertor(id: docflash.id,heading: heading,description: description,creator: creator,photoUrl: photoUrl,videoUrl:videoUrl,projectId: projectId,circuitDiagram: circuitDiagram,mode: mode);
  final json = flash.toJson();
  await docflash.set(json);
}

class treadingProjectsConvertor {
  String id;
  final String heading,description,creator,photoUrl,videoUrl,mode,projectId,circuitDiagram;



  treadingProjectsConvertor({this.id = "",required this.videoUrl,required this.heading,required this.description,required this.creator,required this.photoUrl,required this.projectId,required this.circuitDiagram,required this.mode});

  Map<String, dynamic> toJson() => {
    "id": id,
    "heading":heading,
    "description":description,
    "creator":creator,
    "photoUrl":photoUrl,
    "videoUrl":videoUrl,
    "mode":mode,
    "circuitDiagram":circuitDiagram,
    "projectId":projectId
  };

  static treadingProjectsConvertor fromJson(Map<String, dynamic> json) =>
      treadingProjectsConvertor(id: json['id'],videoUrl: json["videoUrl"],heading: json["heading"],description: json["description"],creator: json["creator"],photoUrl: json["photoUrl"],projectId: json["projectId"],mode: json["mode"],circuitDiagram: json["circuitDiagram"]);
}


Stream<List<projectListConvertor>> readProjectList() => FirebaseFirestore.instance
    .collection('typeOfProjects')
    .orderBy("index", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => projectListConvertor.fromJson(doc.data())).toList());

Future createLabSubjects({required String heading, required String description, required String Date, required String PhotoUrl,required String regulation}) async {
  final docflash = FirebaseFirestore.instance.collection("typeOfProjects").doc();
  final flash = projectListConvertor(id: docflash.id,heading: heading,description: description,photoUrl: PhotoUrl,index: 0);
  final json = flash.toJson();
  await docflash.set(json);
}

class projectListConvertor {
  String id;
  final String heading,description,photoUrl;
  final int index;


  projectListConvertor({this.id = "",required this.heading,required this.description,required this.photoUrl,required this.index});

  Map<String, dynamic> toJson() => {
    "id": id,
    "heading":heading,
    "description":description,
    "photoUrl":photoUrl,
    "index":index
  };

  static projectListConvertor fromJson(Map<String, dynamic> json) =>
      projectListConvertor(id: json['id'],heading: json["heading"],description: json["description"],photoUrl: json['photoUrl'],index: json["index"]);
}

Stream<List<arduinoHomePageProjectsConvertor>> readarduinoHomePageProjects() => FirebaseFirestore.instance
    .collection('arduino').doc("homePage").collection("projects")
    .orderBy("heading", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => arduinoHomePageProjectsConvertor.fromJson(doc.data())).toList());

Future createarduinoHomePageProjects({required String heading,required String description,  required String creator,required String photoUrl,required String videoUrl,required String projectId}) async {
  final docflash = FirebaseFirestore.instance.collection('arduino').doc("homePage").collection("projects").doc();
  final flash = arduinoHomePageProjectsConvertor(id: docflash.id,heading: heading,description: description,creator: creator,photoUrl: photoUrl,videoUrl:videoUrl,projectId: projectId);
  final json = flash.toJson();
  await docflash.set(json);
}

class arduinoHomePageProjectsConvertor {
  String id;
  final String heading,description,creator,photoUrl,videoUrl,projectId;


  arduinoHomePageProjectsConvertor({required this.projectId,this.id = "",required this.videoUrl,required this.heading,required this.description,required this.creator,required this.photoUrl});

  Map<String, dynamic> toJson() => {
    "id": id,
    "heading":heading,
    "description":description,
    "creator":creator,
    "photoUrl":photoUrl,
    "videoUrl":videoUrl,
    "projectId":projectId,
  };

  static arduinoHomePageProjectsConvertor fromJson(Map<String, dynamic> json) =>
      arduinoHomePageProjectsConvertor(id: json['id'],videoUrl: json["videoUrl"],heading: json["heading"],description: json["description"],creator: json["creator"],photoUrl: json["photoUrl"],projectId: json["projectId"]);
}


