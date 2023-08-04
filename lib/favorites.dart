import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'HomePage.dart';
import 'SubPages.dart';
import 'functins.dart';

class favorites extends StatefulWidget {
  final String branch;
  final double size;
  final double height;
  final double width;
  const favorites(
      {Key? key,
      required this.branch,
      required this.width,
      required this.size,
      required this.height})
      : super(key: key);

  @override
  State<favorites> createState() => _favoritesState();
}

class _favoritesState extends State<favorites> {
  String folderPath = "";

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();

    setState(() {
      folderPath = '${directory.path}';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                StreamBuilder<List<FavouriteSubjectsConvertor>>(
                    stream: readFavouriteSubjects(),
                    builder: (context, snapshot) {
                      final Favourites = snapshot.data;
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator(
                            strokeWidth: 0.3,
                            color: Colors.cyan,
                          ));
                        default:
                          if (snapshot.hasError) {
                            return Center(child: Text("Error"));
                          } else {
                            if (Favourites!.length > 0)
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: widget.height * 8,
                                        left: widget.width * 25,
                                        bottom: widget.height * 10),
                                    child: Text(
                                      "Favorite Subjects",
                                      style: TextStyle(
                                          color: Colors.deepOrangeAccent,
                                          fontSize: widget.size * 25,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: widget.width * 20,
                                        right: widget.width * 10),
                                    child: ListView.separated(
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: Favourites.length,
                                        itemBuilder: (context, int index) {
                                          final Favourite = Favourites[index];
                                          final Uri uri =
                                              Uri.parse(Favourite.photoUrl);
                                          final String fileName =
                                              uri.pathSegments.last;
                                          var name = fileName.split("/").last;
                                          final file = File(
                                              "${folderPath}/${widget.branch.toLowerCase()}_subjects/$name");
                                          return InkWell(
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.black38,
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(
                                                          widget.size * 10))),
                                              child: SingleChildScrollView(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width:
                                                          widget.width * 90.0,
                                                      height:
                                                          widget.height * 50.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    widget.size *
                                                                        8.0)),
                                                        color: Colors.redAccent,
                                                        image: DecorationImage(
                                                          image:
                                                              FileImage(file),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: widget.width * 10,
                                                    ),
                                                    Expanded(
                                                        child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              Favourite.name,
                                                              style: TextStyle(
                                                                fontSize: widget
                                                                        .size *
                                                                    20.0,
                                                                color: Colors
                                                                    .orangeAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                  right: widget
                                                                          .width *
                                                                      20),
                                                              child: InkWell(
                                                                child: Icon(
                                                                  Icons
                                                                      .highlight_remove_outlined,
                                                                  color: Colors
                                                                      .red,
                                                                  size: widget
                                                                          .size *
                                                                      28,
                                                                ),
                                                                onTap: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Dialog(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(widget.size * 20)),
                                                                        elevation:
                                                                            16,
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(color: Colors.tealAccent),
                                                                            borderRadius:
                                                                                BorderRadius.circular(widget.size * 20),
                                                                          ),
                                                                          child:
                                                                              ListView(
                                                                            shrinkWrap:
                                                                                true,
                                                                            children: <Widget>[
                                                                              SizedBox(height: widget.height * 10),
                                                                              SizedBox(height: widget.height * 5),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(left: widget.width * 15),
                                                                                child: Text(
                                                                                  "Do you want Remove from Favourites",
                                                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: widget.size * 18),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: widget.height * 5,
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
                                                                                          borderRadius: BorderRadius.circular(widget.size * 25),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.only(left: widget.width * 15, right: widget.width * 15, top: widget.height * 5, bottom: widget.height * 5),
                                                                                          child: Text("Back"),
                                                                                        ),
                                                                                      ),
                                                                                      onTap: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: widget.width * 10,
                                                                                    ),
                                                                                    InkWell(
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(
                                                                                          color: Colors.red,
                                                                                          border: Border.all(color: Colors.black),
                                                                                          borderRadius: BorderRadius.circular(widget.size * 25),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.only(left: widget.width * 15, right: widget.width * 15, top: widget.height * 5, bottom: widget.height * 5),
                                                                                          child: Text(
                                                                                            "Delete",
                                                                                            style: TextStyle(color: Colors.white),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      onTap: () {
                                                                                        FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.email!).collection("FavouriteSubject").doc(Favourite.id).delete();
                                                                                        Navigator.pop(context);
                                                                                        showToastText("${Favourite.name} as been removed");
                                                                                      },
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: widget.width * 20,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: widget.height * 10,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              widget.height * 2,
                                                        ),
                                                        Text(
                                                          Favourite.description,
                                                          style: TextStyle(
                                                            fontSize:
                                                                widget.size *
                                                                    13.0,
                                                            color:
                                                                Colors.white70,
                                                          ),
                                                        ),
                                                      ],
                                                    ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          subjectUnitsData(
                                                            width: widget.width,
                                                            height:
                                                                widget.height,
                                                            size: widget.size,
                                                            branch: Favourite
                                                                .branch,
                                                            ID: Favourite
                                                                .subjectId,
                                                            mode: "Subjects",
                                                            name:
                                                                Favourite.name,
                                                            fullName: Favourite
                                                                .description,
                                                            photoUrl: Favourite
                                                                .photoUrl,
                                                          )));
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                              height: widget.height * 6,
                                            )),
                                  ),
                                ],
                              );
                            else
                              return Center(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: widget.height * 10),
                                  child: InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white30),
                                          borderRadius: BorderRadius.circular(
                                              widget.size * 20),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.all(widget.size * 8.0),
                                          child: Text(
                                            "No Favorite Subjects",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: widget.size * 18),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        showToastText("Add Subjects");
                                      }),
                                ),
                              );
                          }
                      }
                    }),
                //TODO Favourite Lab Subjects Stream Builder
                StreamBuilder<List<FavouriteLabSubjectsConvertor>>(
                    stream: readFavouriteLabSubjects(),
                    builder: (context, snapshot) {
                      final Favourites = snapshot.data;
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator(
                            strokeWidth: 0.3,
                            color: Colors.cyan,
                          ));
                        default:
                          if (snapshot.hasError) {
                            return Center(child: Text("Error"));
                          } else {
                            if (Favourites!.length > 0)
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: widget.height * 15,
                                        left: widget.width * 20,
                                        bottom: widget.height * 10),
                                    child: Text(
                                      "Favorite Lab Subjects",
                                      style: TextStyle(
                                          color: Colors.deepOrangeAccent,
                                          fontSize: widget.size * 25,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: widget.width * 20,
                                        right: widget.width * 10),
                                    child: ListView.separated(
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: Favourites.length,
                                        itemBuilder: (context, int index) {
                                          final Favourite = Favourites[index];
                                          final Uri uri =
                                              Uri.parse(Favourite.photoUrl);
                                          final String fileName =
                                              uri.pathSegments.last;
                                          var name = fileName.split("/").last;
                                          final file = File(
                                              "${folderPath}/${widget.branch.toLowerCase()}_labsubjects/$name");
                                          return InkWell(
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.black38,
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(
                                                          widget.size * 10))),
                                              child: SingleChildScrollView(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width:
                                                          widget.width * 90.0,
                                                      height:
                                                          widget.height * 50.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    widget.size *
                                                                        8.0)),
                                                        color: Colors.redAccent,
                                                        image: DecorationImage(
                                                          image:
                                                              FileImage(file),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: widget.width * 10,
                                                    ),
                                                    Expanded(
                                                        child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              Favourite.name,
                                                              style: TextStyle(
                                                                fontSize: widget
                                                                        .size *
                                                                    20.0,
                                                                color: Colors
                                                                    .orangeAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                  right: widget
                                                                          .width *
                                                                      20),
                                                              child: InkWell(
                                                                child: Icon(
                                                                  Icons
                                                                      .highlight_remove_outlined,
                                                                  color: Colors
                                                                      .red,
                                                                  size: widget
                                                                          .size *
                                                                      28,
                                                                ),
                                                                onTap: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Dialog(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(widget.size * 20)),
                                                                        elevation:
                                                                            16,
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(color: Colors.tealAccent),
                                                                            borderRadius:
                                                                                BorderRadius.circular(widget.size * 20),
                                                                          ),
                                                                          child:
                                                                              ListView(
                                                                            shrinkWrap:
                                                                                true,
                                                                            children: <Widget>[
                                                                              SizedBox(height: widget.height * 15),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(left: widget.width * 15),
                                                                                child: Text(
                                                                                  "Do you want Remove from Favourites",
                                                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: widget.size * 18),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: widget.height * 5,
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
                                                                                          borderRadius: BorderRadius.circular(widget.size * 25),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.only(left: widget.width * 15, right: widget.width * 15, top: widget.height * 5, bottom: widget.height * 5),
                                                                                          child: Text("Back"),
                                                                                        ),
                                                                                      ),
                                                                                      onTap: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: widget.width * 10,
                                                                                    ),
                                                                                    InkWell(
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(
                                                                                          color: Colors.red,
                                                                                          border: Border.all(color: Colors.black),
                                                                                          borderRadius: BorderRadius.circular(widget.size * 25),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.only(left: widget.width * 15, right: widget.width * 15, top: widget.height * 5, bottom: widget.height * 5),
                                                                                          child: Text(
                                                                                            "Delete",
                                                                                            style: TextStyle(color: Colors.white),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      onTap: () {
                                                                                        FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.email!).collection("FavouriteLabSubjects").doc(Favourite.id).delete();
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: widget.width * 20,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: widget.height * 10,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              widget.height * 2,
                                                        ),
                                                        Text(
                                                          Favourite.description,
                                                          style: TextStyle(
                                                            fontSize:
                                                                widget.size *
                                                                    13.0,
                                                            color: Colors
                                                                .lightBlueAccent,
                                                          ),
                                                        ),
                                                      ],
                                                    ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          subjectUnitsData(
                                                            width: widget.width,
                                                            height:
                                                                widget.height,
                                                            size: widget.size,
                                                            branch: Favourite
                                                                .branch,
                                                            ID: Favourite
                                                                .subjectId,
                                                            mode: "LabSubjects",
                                                            name:
                                                                Favourite.name,
                                                            fullName: Favourite
                                                                .description,
                                                            photoUrl: Favourite
                                                                .photoUrl,
                                                          )));
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                              height: widget.height * 5,
                                            )),
                                  ),
                                ],
                              );
                            else
                              return Padding(
                                padding:
                                    EdgeInsets.only(top: widget.height * 15),
                                child: Center(
                                  child: InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.tealAccent),
                                          borderRadius: BorderRadius.circular(
                                              widget.size * 20),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.all(widget.size * 8.0),
                                          child: Text(
                                            "No Favorite Lab Subjects",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        showToastText("Add La Subjects");
                                      }),
                                ),
                              );
                          }
                      }
                    }),
                //TODO Favourite Books Stream Builder
                StreamBuilder<List<FavouriteBooksConvertor>>(
                    stream: readFavouriteBooks(),
                    builder: (context, snapshot) {
                      final Favourites = snapshot.data;
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator(
                            strokeWidth: 0.3,
                            color: Colors.cyan,
                          ));
                        default:
                          if (snapshot.hasError) {
                            return Center(child: Text("Error"));
                          } else {
                            if (Favourites!.length > 0)
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: widget.height * 20,
                                        left: widget.width * 20,
                                        bottom: widget.height * 10),
                                    child: Text(
                                      "Based on ECE",
                                      style: TextStyle(
                                          color: Colors.deepOrangeAccent,
                                          fontSize: widget.size * 25,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: Favourites.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final Uri uri =
                                          Uri.parse(Favourites[index].photoUrl);
                                      final String fileName =
                                          uri.pathSegments.last;
                                      var name = fileName.split("/").last;
                                      final file = File(
                                          "${folderPath}/${widget.branch.toLowerCase()}_books/$name");
                                      return InkWell(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: widget.width * 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          widget.size * 8),
                                                  color: Colors.black
                                                      .withOpacity(0.4),
                                                  image: DecorationImage(
                                                    image: FileImage(file),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                width: widget.width * 95,
                                                height: 130,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Spacer(),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              left:
                                                                  widget.width *
                                                                      10,
                                                              right:
                                                                  widget.width *
                                                                      2),
                                                          child: InkWell(
                                                            child: Icon(
                                                              Icons
                                                                  .highlight_remove_outlined,
                                                              color: Colors.red,
                                                              size:
                                                                  widget.size *
                                                                      28,
                                                            ),
                                                            onTap: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return Dialog(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(widget.size *
                                                                                20)),
                                                                    elevation:
                                                                        16,
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border.all(
                                                                            color:
                                                                                Colors.tealAccent),
                                                                        borderRadius:
                                                                            BorderRadius.circular(widget.size *
                                                                                20),
                                                                      ),
                                                                      child:
                                                                          ListView(
                                                                        shrinkWrap:
                                                                            true,
                                                                        children: <Widget>[
                                                                          SizedBox(
                                                                              height: widget.height * 15),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: widget.width * 15),
                                                                            child:
                                                                                Text(
                                                                              "Do you want Remove from Favourites",
                                                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: widget.size * 18),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                widget.height * 5,
                                                                          ),
                                                                          Center(
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Spacer(),
                                                                                InkWell(
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.black26,
                                                                                      border: Border.all(color: Colors.black),
                                                                                      borderRadius: BorderRadius.circular(widget.size * 25),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.only(left: widget.width * 15, right: widget.width * 15, top: widget.height * 5, bottom: widget.height * 5),
                                                                                      child: Text("Back"),
                                                                                    ),
                                                                                  ),
                                                                                  onTap: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                ),
                                                                                SizedBox(
                                                                                  width: widget.width * 10,
                                                                                ),
                                                                                InkWell(
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.red,
                                                                                      border: Border.all(color: Colors.black),
                                                                                      borderRadius: BorderRadius.circular(widget.size * 25),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.only(left: widget.width * 15, right: widget.width * 15, top: widget.height * 5, bottom: widget.height * 5),
                                                                                      child: Text(
                                                                                        "Delete",
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  onTap: () {
                                                                                    FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.email!).collection("FavouriteBooks").doc(Favourites[index].id).delete();
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                ),
                                                                                SizedBox(
                                                                                  width: widget.width * 20,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                widget.height * 10,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .horizontal(
                                                                right: Radius
                                                                    .circular(
                                                                        10)),
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                        // border: Border.all(color: Colors.white),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child:
                                                            SingleChildScrollView(
                                                          physics:
                                                              BouncingScrollPhysics(),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                Favourites[
                                                                        index]
                                                                    .heading,
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        widget.size *
                                                                            16,
                                                                    color: Colors
                                                                        .orange),
                                                              ),
                                                              Text(
                                                                Favourites[
                                                                        index]
                                                                    .Author,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        widget.size *
                                                                            13,
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                              Text(
                                                                Favourites[
                                                                        index]
                                                                    .edition,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        widget.size *
                                                                            13,
                                                                    color: Colors
                                                                        .lightBlueAccent),
                                                              ),
                                                              SizedBox(
                                                                height: widget
                                                                        .height *
                                                                    5,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  booksDownloadButton(
                                                                    branch: widget
                                                                        .branch,
                                                                    width: widget
                                                                        .width,
                                                                    height: widget
                                                                        .height,
                                                                    size: widget
                                                                        .size,
                                                                    path:
                                                                        folderPath,
                                                                    pdfLink: Favourites[
                                                                            index]
                                                                        .link,
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: widget.width * 20,
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () async {},
                                      );
                                    },
                                    shrinkWrap: true,
                                  ),
                                ],
                              );
                            else {
                              return Center(
                                child: InkWell(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: widget.height * 15),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.tealAccent),
                                          borderRadius: BorderRadius.circular(
                                              widget.width * 20),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              widget.width * 8.0),
                                          child: Text(
                                            "No Favorites Books",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      showToastText("Add Books");
                                      // showDialog(
                                      //   context: context,
                                      //   builder: (context) {
                                      //     return Dialog(
                                      //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      //       elevation: 16,
                                      //       child: Container(
                                      //         decoration: BoxDecoration(
                                      //           border: Border.all(color: Colors.tealAccent),
                                      //           borderRadius: BorderRadius.circular(20),
                                      //         ),
                                      //         child: ListView(
                                      //           shrinkWrap: true,
                                      //           children: <Widget>[
                                      //             SizedBox(height: 10),
                                      //             Center(
                                      //                 child: Text(
                                      //                   'Note',
                                      //                   style: TextStyle(color: Colors.black87, fontSize: 20),
                                      //                 )),
                                      //             Divider(
                                      //               color: Colors.tealAccent,
                                      //             ),
                                      //             SizedBox(height: 5),
                                      //             Padding(
                                      //               padding: const EdgeInsets.only(left: 15),
                                      //               child: Text("1. Click on 'See More' option"),
                                      //             ),
                                      //             Padding(
                                      //               padding: const EdgeInsets.only(left: 15),
                                      //               child: Text("2. Long Press on Subject u need to add as important"),
                                      //             ),
                                      //             Padding(
                                      //               padding: const EdgeInsets.only(left: 15),
                                      //               child: Text("3. Restart the application"),
                                      //             ),
                                      //             Divider(
                                      //               color: Colors.tealAccent,
                                      //             ),
                                      //             Padding(
                                      //               padding: const EdgeInsets.only(left: 15),
                                      //               child: Text("1. Long Press on Subject u need to remove as important"),
                                      //             ),
                                      //             Divider(
                                      //               color: Colors.tealAccent,
                                      //             ),
                                      //             Center(
                                      //               child: InkWell(
                                      //                 child: Container(
                                      //                   decoration: BoxDecoration(
                                      //                     color: Colors.black26,
                                      //                     border: Border.all(color: Colors.black),
                                      //                     borderRadius: BorderRadius.circular(25),
                                      //                   ),
                                      //                   child: Padding(
                                      //                     padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                      //                     child: Text("Back"),
                                      //                   ),
                                      //                 ),
                                      //                 onTap: () {
                                      //                   Navigator.pop(context);
                                      //                 },
                                      //               ),
                                      //             ),
                                      //             SizedBox(
                                      //               height: 10,
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     );
                                      //   },
                                      // );
                                    }),
                              );
                            }
                          }
                      }
                    }),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
          Positioned(
              top: 0,
              right: 0,
              left: 20,
              child: Text(
                "Favorites",
                style: TextStyle(
                    fontSize: widget.size * 35,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepOrange),
              ))
        ],
      ),
    );
  }
}

Stream<List<FavouriteSubjectsConvertor>> readFavouriteSubjects() =>
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.email!)
        .collection("FavouriteSubject")
        .orderBy("name", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FavouriteSubjectsConvertor.fromJson(doc.data()))
            .toList());

Future FavouriteSubjects(
    {required SubjectId,
    required name,
    required description,
    required photoUrl,
    required branch}) async {
  final docflash = FirebaseFirestore.instance
      .collection("user")
      .doc(FirebaseAuth.instance.currentUser!.email!)
      .collection("FavouriteSubject")
      .doc(SubjectId);
  final flash = FavouriteSubjectsConvertor(
      id: SubjectId,
      subjectId: SubjectId,
      name: name,
      description: description,
      branch: branch,
      photoUrl: photoUrl);
  final json = flash.toJson();
  await docflash.set(json);
}

class FavouriteSubjectsConvertor {
  String id;
  final String subjectId, name, description, photoUrl, branch;

  FavouriteSubjectsConvertor(
      {this.id = "",
      required this.subjectId,
      required this.photoUrl,
      required this.name,
      required this.description,
      required this.branch});

  Map<String, dynamic> toJson() => {
        "id": id,
        "subjectId": subjectId,
        "description": description,
        "name": name,
        "photoUrl": photoUrl,
        "branch": branch
      };

  static FavouriteSubjectsConvertor fromJson(Map<String, dynamic> json) =>
      FavouriteSubjectsConvertor(
          id: json['id'],
          subjectId: json["subjectId"],
          branch: json['branch'],
          photoUrl: json["photoUrl"],
          name: json["name"],
          description: json["description"]);
}

Stream<List<FavouriteLabSubjectsConvertor>> readFavouriteLabSubjects() =>
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.email!)
        .collection("FavouriteLabSubjects")
        .orderBy("name", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FavouriteLabSubjectsConvertor.fromJson(doc.data()))
            .toList());

Future FavouriteLabSubjectsSubjects(
    {required SubjectId,
    required name,
    required description,
    required photoUrl,
    required branch}) async {
  final docflash = FirebaseFirestore.instance
      .collection("user")
      .doc(FirebaseAuth.instance.currentUser!.email!)
      .collection("FavouriteLabSubjects")
      .doc(SubjectId);
  final flash = FavouriteLabSubjectsConvertor(
      id: SubjectId,
      subjectId: SubjectId,
      name: name,
      description: description,
      branch: branch,
      photoUrl: photoUrl);
  final json = flash.toJson();
  await docflash.set(json);
}

class FavouriteLabSubjectsConvertor {
  String id;
  final String subjectId, name, description, photoUrl, branch;

  FavouriteLabSubjectsConvertor(
      {this.id = "",
      required this.subjectId,
      required this.photoUrl,
      required this.name,
      required this.description,
      required this.branch});

  Map<String, dynamic> toJson() => {
        "id": id,
        "subjectId": subjectId,
        "description": description,
        "name": name,
        "photoUrl": photoUrl,
        "branch": branch
      };

  static FavouriteLabSubjectsConvertor fromJson(Map<String, dynamic> json) =>
      FavouriteLabSubjectsConvertor(
          id: json['id'],
          subjectId: json["subjectId"],
          branch: json['branch'],
          photoUrl: json["photoUrl"],
          name: json["name"],
          description: json["description"]);
}

Stream<List<FavouriteBooksConvertor>> readFavouriteBooks() =>
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.email!)
        .collection("FavouriteBooks")
        .orderBy("Heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FavouriteBooksConvertor.fromJson(doc.data()))
            .toList());

Future FavouriteBooksSubjects(
    {required String id,
    required String heading,
    required String description,
    required String link,
    required String photoUrl,
    required String edition,
    required String Author,
    required String branch}) async {
  final docBook = FirebaseFirestore.instance
      .collection("user")
      .doc(FirebaseAuth.instance.currentUser!.email!)
      .collection("FavouriteBooks")
      .doc(id);
  final flash = FavouriteBooksConvertor(
      id: id,
      heading: heading,
      link: link,
      description: description,
      photoUrl: photoUrl,
      Author: Author,
      edition: edition,
      branch: branch);
  final json = flash.toJson();
  await docBook.set(json);
}

class FavouriteBooksConvertor {
  String id;
  final String heading, link, description, photoUrl, edition, Author, branch;

  FavouriteBooksConvertor(
      {this.id = "",
      required this.heading,
      required this.link,
      required this.description,
      required this.photoUrl,
      required this.edition,
      required this.Author,
      required this.branch});

  Map<String, dynamic> toJson() => {
        "id": id,
        "Heading": heading,
        "Link": link,
        "Description": description,
        "Photo Url": photoUrl,
        "Author": Author,
        "Edition": edition,
        "branch": branch
      };

  static FavouriteBooksConvertor fromJson(Map<String, dynamic> json) =>
      FavouriteBooksConvertor(
        id: json['id'],
        heading: json["Heading"],
        link: json["Link"],
        description: json["Description"],
        photoUrl: json["Photo Url"],
        Author: json["Author"],
        branch: json["branch"],
        edition: json["Edition"],
      );
}
