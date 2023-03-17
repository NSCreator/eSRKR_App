import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'arduino.dart';
import 'electronicProjects.dart';
import 'homepage.dart';
import 'raspberrypi.dart';
import 'sensors.dart';

class searchBar extends StatefulWidget {
  const searchBar({Key? key}) : super(key: key);

  @override
  State<searchBar> createState() => _searchBarState();
}

class _searchBarState extends State<searchBar> {
  String name = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey.shade800,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [ Color.fromRGBO(53, 166, 204, 1),Color.fromRGBO(24, 45, 74, 1),Color.fromRGBO(21, 47, 61, 1)]
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding (
                  padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextField(
                        onChanged: (val) {
                          setState(() {
                            name = val;
                          });
                        },
                        decoration: InputDecoration(

                          border: InputBorder.none,
                          hintText: 'Search Bar',
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Arduino",style: TextStyle(fontSize: 22,color: Colors.white),),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('arduino').doc("arduinoProjects").collection("projects").snapshots(),
                            builder: (context, snapshots) {
                              return (snapshots.connectionState == ConnectionState.waiting)
                                  ? const Center(
                                child: CircularProgressIndicator(),
                              )
                                  : ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshots.data!.docs.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var data = snapshots.data!.docs[index].data()
                                    as Map<String, dynamic>;
                                    if (name.isEmpty) {
                                      return InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.5),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black38, borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    data["photoUrl"],
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.5), borderRadius: const BorderRadius.all(Radius.circular(15)),
                                              ),

                                              child: Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Color.fromRGBO(174, 228, 242,0.3)),
                                                      color: Colors.black38, borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          data["photoUrl"],
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),),
                                                    height: 70,
                                                    width: 110,
                                                  ),
                                                  Expanded(
                                                      child: Container(

                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(data["heading"],style: TextStyle(fontSize: 19,color: Colors.white), maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,),
                                                    ),
                                                        decoration: BoxDecoration(
                                                          // border: Border.all(color: Color.fromRGBO(174, 228, 242,0.3)),
                                                          color:Colors.black.withOpacity(0.7),
                                                          borderRadius: const BorderRadius.only(
                                                            topRight: Radius.circular(10),
                                                            bottomRight: Radius.circular(10)
                                                          ),
                                                        ),
                                                  ))
                                                ],
                                              ),
                                            )
                                          ),
                                        ),
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => arduinoProject(youtubeUrl:data["videoUrl"],id: data["id"],heading: data["heading"],description: data["description"],photoUrl: data["photoUrl"],creator: data["creator"],)));

                                        },
                                      );
                                    }
                                    if (data['heading']
                                        .toString()
                                        .toLowerCase()
                                        .startsWith(name.toLowerCase())) {
                                      return InkWell(
                                        child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: const Color.fromRGBO(174, 228, 242,0.3)),
                                              color: Colors.black38, borderRadius: const BorderRadius.all(Radius.circular(15)),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  data["photoUrl"],

                                                ),
                                                fit: BoxFit.cover,
                                              ),),
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: const Color.fromRGBO(174, 228, 242,0.3)),
                                                    color: Colors.black38, borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        data["photoUrl"],
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
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(data["heading"],style: const TextStyle(fontSize: 19,color: Colors.white), maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,),
                                                      ),
                                                    ))
                                              ],
                                            )
                                        ),
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => arduinoProject(youtubeUrl:data["videoUrl"],id: data["id"],heading: data["heading"],description: data["description"],photoUrl: data["photoUrl"],creator: data["creator"],)));

                                        },
                                      );
                                    }
                                    return Container();
                                  });
                            },
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('arduino').doc("arduinoBoards").collection("Board").snapshots(),
                            builder: (context, snapshots) {
                              return (snapshots.connectionState == ConnectionState.waiting)
                                  ? const Center(
                                child: CircularProgressIndicator(),
                              )
                                  : ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshots.data!.docs.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var data = snapshots.data!.docs[index].data()
                                    as Map<String, dynamic>;
                                    if (name.isEmpty) {
                                      return InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black38, borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    data["photoUrl"],
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
                                                            data["photoUrl"],
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),),
                                                      height: 70,
                                                      width: 110,
                                                    ),
                                                    Expanded(
                                                        child: Container(

                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(data["name"],style: TextStyle(fontSize: 19,color: Colors.white), maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,),
                                                          ),
                                                          decoration: BoxDecoration(
                                                            // border: Border.all(color: Color.fromRGBO(174, 228, 242,0.3)),
                                                            color:Colors.black.withOpacity(0.7),
                                                            borderRadius: const BorderRadius.only(
                                                                topRight: Radius.circular(10),
                                                                bottomRight: Radius.circular(10)
                                                            ),
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              )
                                          ),
                                        ),
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => arduinoBoard(pinDiagram:data["pinDiagram"],mainFeatures: data["mainFeatures"],id: data["id"],heading: data["name"],description: data["description"],photoUrl: data["photoUrl"],)));


                                        },
                                      );
                                    }
                                    if (data['name']
                                        .toString()
                                        .toLowerCase()
                                        .startsWith(name.toLowerCase())) {
                                      return InkWell(
                                        child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: const Color.fromRGBO(174, 228, 242,0.3)),
                                              color: Colors.black38, borderRadius: const BorderRadius.all(Radius.circular(15)),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  data["photoUrl"],

                                                ),
                                                fit: BoxFit.cover,
                                              ),),
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: const Color.fromRGBO(174, 228, 242,0.3)),
                                                    color: Colors.black38, borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        data["photoUrl"],
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
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(data["name"],style: const TextStyle(fontSize: 19,color: Colors.white), maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,),
                                                      ),
                                                    ))
                                              ],
                                            )
                                        ),
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => arduinoBoard(pinDiagram:data["pinDiagram"],mainFeatures: data["mainFeatures"],id: data["id"],heading: data["name"],description: data["description"],photoUrl: data["photoUrl"],)));


                                        },
                                      );
                                    }
                                    return  Container();
                                  });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Raspberry Pi",style: TextStyle(fontSize: 22,color: Colors.white),),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('raspberrypi').doc("raspberrypiBoard").collection("Boards").snapshots(),
                            builder: (context, snapshots) {
                              return (snapshots.connectionState == ConnectionState.waiting)
                                  ? const Center(
                                child: CircularProgressIndicator(),
                              )
                                  : ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshots.data!.docs.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var data = snapshots.data!.docs[index].data()
                                    as Map<String, dynamic>;
                                    if (name.isEmpty) {
                                      return InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black38, borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    data["photoUrl"],
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
                                                            data["photoUrl"],
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),),
                                                      height: 70,
                                                      width: 110,
                                                    ),
                                                    Expanded(
                                                        child: Container(

                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(data["name"],style: TextStyle(fontSize: 19,color: Colors.white), maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,),
                                                          ),
                                                          decoration: BoxDecoration(
                                                            // border: Border.all(color: Color.fromRGBO(174, 228, 242,0.3)),
                                                            color:Colors.black.withOpacity(0.7),
                                                            borderRadius: const BorderRadius.only(
                                                                topRight: Radius.circular(10),
                                                                bottomRight: Radius.circular(10)
                                                            ),
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              )
                                          ),
                                        ),
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => raspberrypiBoard(id: data["id"],heading: data["name"],description: data["description"],photoUrl: data["photoUrl"],)));

                                        },
                                      );
                                    }
                                    if (data['name']
                                        .toString()
                                        .toLowerCase()
                                        .startsWith(name.toLowerCase())) {
                                      return InkWell(
                                        child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: const Color.fromRGBO(174, 228, 242,0.3)),
                                              color: Colors.black38, borderRadius: const BorderRadius.all(Radius.circular(15)),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  data["photoUrl"],

                                                ),
                                                fit: BoxFit.cover,
                                              ),),
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: const Color.fromRGBO(174, 228, 242,0.3)),
                                                    color: Colors.black38, borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        data["photoUrl"],
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
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(data["name"],style: const TextStyle(fontSize: 19,color: Colors.white), maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,),
                                                      ),
                                                    ))
                                              ],
                                            )
                                        ),
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => raspberrypiBoard(id: data["id"],heading: data["name"],description: data["description"],photoUrl: data["photoUrl"],)));

                                        },
                                      );
                                    }
                                    return Container();
                                  });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("DIY Electronic Project",style: TextStyle(fontSize: 22,color: Colors.white),),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('electronicProjects').snapshots(),
                            builder: (context, snapshots) {
                              return (snapshots.connectionState == ConnectionState.waiting)
                                  ? const Center(
                                child: CircularProgressIndicator(),
                              )
                                  : ListView.builder(
                                  itemCount: snapshots.data!.docs.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var data = snapshots.data!.docs[index].data()
                                    as Map<String, dynamic>;
                                    if (name.isEmpty) {
                                      return InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black38, borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    data["photoUrl"],
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
                                                            data["photoUrl"],
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),),
                                                      height: 70,
                                                      width: 110,
                                                    ),
                                                    Expanded(
                                                        child: Container(

                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(data["heading"],style: TextStyle(fontSize: 19,color: Colors.white), maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,),
                                                          ),
                                                          decoration: BoxDecoration(
                                                            // border: Border.all(color: Color.fromRGBO(174, 228, 242,0.3)),
                                                            color:Colors.black.withOpacity(0.7),
                                                            borderRadius: const BorderRadius.only(
                                                                topRight: Radius.circular(10),
                                                                bottomRight: Radius.circular(10)
                                                            ),
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              )
                                          ),
                                        ),
                                        onTap: () {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => electronicProject(youtubeUrl: data["videoUrl"],circuitDiagram:data["circuitDiagram"],id: data["id"],heading: data["heading"],description: data["description"],photoUrl: data["photoUrl"],)));

                                        },
                                      );
                                    }
                                    if (data['heading']
                                        .toString()
                                        .toLowerCase()
                                        .startsWith(name.toLowerCase())) {
                                      return InkWell(
                                        child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: const Color.fromRGBO(174, 228, 242,0.3)),
                                              color: Colors.black38, borderRadius: const BorderRadius.all(Radius.circular(15)),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  data["photoUrl"],

                                                ),
                                                fit: BoxFit.cover,
                                              ),),
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: const Color.fromRGBO(174, 228, 242,0.3)),
                                                    color: Colors.black38, borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        data["photoUrl"],
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
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(data["heading"],style: const TextStyle(fontSize: 19,color: Colors.white), maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,),
                                                      ),
                                                    ))
                                              ],
                                            )
                                        ),
                                        onTap: () {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => electronicProject(youtubeUrl: data["videoUrl"],circuitDiagram:data["circuitDiagram"],id: data["id"],heading: data["heading"],description: data["description"],photoUrl: data["photoUrl"],)));

                                        },
                                      );
                                    }
                                    return Container();
                                  });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Sensors",style: TextStyle(fontSize: 22,color: Colors.white),),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('sensors').snapshots(),
                            builder: (context, snapshots) {
                              return (snapshots.connectionState == ConnectionState.waiting)
                                  ? const Center(
                                child: CircularProgressIndicator(),
                              )
                                  : ListView.builder(
                                  itemCount: snapshots.data!.docs.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var data = snapshots.data!.docs[index].data()
                                    as Map<String, dynamic>;
                                    if (name.isEmpty) {
                                      return InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black38, borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    data["photoUrl"],
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
                                                            data["photoUrl"],
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),),
                                                      height: 70,
                                                      width: 110,
                                                    ),
                                                    Expanded(
                                                        child: Container(

                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(data["name"],style: TextStyle(fontSize: 19,color: Colors.white), maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,),
                                                          ),
                                                          decoration: BoxDecoration(
                                                            // border: Border.all(color: Color.fromRGBO(174, 228, 242,0.3)),
                                                            color:Colors.black.withOpacity(0.7),
                                                            borderRadius: const BorderRadius.only(
                                                                topRight: Radius.circular(10),
                                                                bottomRight: Radius.circular(10)
                                                            ),
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              )
                                          ),
                                        ),
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => sensor(pinDiagram:data["pinDiagram"],id: data["id"],heading: data["name"],description: data["description"],photoUrl: data["photoUrl"],)));
                                        },
                                      );
                                    }
                                    if (data['name']
                                        .toString()
                                        .toLowerCase()
                                        .startsWith(name.toLowerCase())) {
                                      return InkWell(
                                        child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: const Color.fromRGBO(174, 228, 242,0.3)),
                                              color: Colors.black38, borderRadius: const BorderRadius.all(Radius.circular(15)),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  data["photoUrl"],

                                                ),
                                                fit: BoxFit.cover,
                                              ),),
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: const Color.fromRGBO(174, 228, 242,0.3)),
                                                    color: Colors.black38, borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        data["photoUrl"],
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
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(data["name"],style: const TextStyle(fontSize: 19,color: Colors.white), maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,),
                                                      ),
                                                    ))
                                              ],
                                            )
                                        ),
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => sensor(pinDiagram:data["pinDiagram"],id: data["id"],heading: data["name"],description: data["description"],photoUrl: data["photoUrl"],)));
                                        },
                                      );
                                    }
                                    return Container();
                                  });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

