import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srkr_study_app/SubPages.dart';
import 'package:srkr_study_app/settings.dart';
import 'package:srkr_study_app/srkr_page.dart';
import 'SubPages.dart';
import 'TextField.dart';
import 'package:url_launcher/url_launcher.dart';
import '../SubPages.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'add subjects.dart';
import 'auth_page.dart';
import 'favorites.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'net.dart';
import 'package:path/path.dart' as p;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final InputController = TextEditingController();
  String folderPath = "";

  Future<void> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      folderPath = '${directory.path}/';
    });
  }

  @override
  void dispose() {
    InputController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    getPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
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
            child: SafeArea(
                child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("user")
                  .doc(fullUserId())
                  .snapshots(),
              builder: (context, mainsnapshot) {
                if (mainsnapshot.connectionState == 200) {
                  return CircularProgressIndicator();
                } else if (mainsnapshot.hasData) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Center(
                                child: Text(
                              "ECE",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            )),
                            flex: 5,
                          ),
                          InkWell(
                              child: Container(
                                height: 35,
                                width: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white.withOpacity(0.7),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "https://firebasestorage.googleapis.com/v0/b/e-srkr.appspot.com/o/logo.png?alt=media&token=f008662e-2638-4990-a010-2081c2f4631b"),
                                        fit: BoxFit.fill)),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SRKRPage()));
                              }),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.white,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StreamBuilder<List<HomeUpdateConvertor>>(
                                  stream: readHomeUpdate(),
                                  builder: (context, snapshot) {
                                    final HomeUpdates = snapshot.data;
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
                                                  'Error with TextBooks Data or\n Check Internet Connection'));
                                        } else {
                                          if (HomeUpdates!.length == 0) {
                                            return Container();
                                          } else
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, bottom: 10),
                                                  child: Text(
                                                    "Updates",
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, right: 10),
                                                  child: ListView.separated(
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          HomeUpdates.length,
                                                      itemBuilder:
                                                          (context, int index) {
                                                        final HomeUpdate =
                                                            HomeUpdates[index];
                                                        final Uri uri =
                                                            Uri.parse(HomeUpdate
                                                                .photoUrl);
                                                        final String fileName =
                                                            uri.pathSegments
                                                                .last;
                                                        var name = fileName
                                                            .split("/")
                                                            .last;
                                                        final file = File(
                                                            "${folderPath}/ece_updates/$name");
                                                        if (file.existsSync()) {
                                                          return InkWell(
                                                            child: Row(
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Container(
                                                                      width: 30,
                                                                      height:
                                                                          30,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              FileImage(file),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      splitDate(
                                                                          HomeUpdate
                                                                              .date),
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              8),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            5.0),
                                                                    child: Container(
                                                                        child: Text(
                                                                      HomeUpdate
                                                                          .heading,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            15.0,
                                                                        color: Color.fromRGBO(
                                                                            204,
                                                                            207,
                                                                            222,
                                                                            1),
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    )),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            onTap: () {
                                                              if (HomeUpdate
                                                                      .link
                                                                      .length >
                                                                  0) {
                                                                _ExternalLaunchUrl(
                                                                    HomeUpdate
                                                                        .link);
                                                              } else {
                                                                showToast(
                                                                    "No Link");
                                                              }
                                                            },
                                                          );
                                                        } else {
                                                          download(
                                                              HomeUpdate
                                                                  .photoUrl,
                                                              "ece_updates");
                                                          return InkWell(
                                                            child: Row(
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Container(
                                                                      width: 30,
                                                                      height:
                                                                          30,
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        imageUrl:
                                                                            HomeUpdate.photoUrl,
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                CircularProgressIndicator(),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            Icon(Icons.error),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      splitDate(
                                                                          HomeUpdate
                                                                              .date),
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              8),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            5.0),
                                                                    child: Container(
                                                                        child: Text(
                                                                      HomeUpdate
                                                                          .heading,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            15.0,
                                                                        color: Color.fromRGBO(
                                                                            204,
                                                                            207,
                                                                            222,
                                                                            1),
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    )),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            onTap: () {
                                                              if (HomeUpdate
                                                                      .link
                                                                      .length >
                                                                  0) {
                                                                _ExternalLaunchUrl(
                                                                    HomeUpdate
                                                                        .link);
                                                              } else {
                                                                showToast(
                                                                    "No Link");
                                                              }
                                                            },
                                                          );
                                                        }
                                                        // return InkWell(
                                                        //   child: Row(
                                                        //     children: [
                                                        //       Column(
                                                        //         children: [
                                                        //           Container(
                                                        //             width: 30,
                                                        //             height: 30,
                                                        //             decoration: BoxDecoration(
                                                        //               borderRadius: BorderRadius.circular(15),
                                                        //               image: DecorationImage(
                                                        //                 image: ,
                                                        //                 // image: NetworkImage(
                                                        //                 //   HomeUpdate.photoUrl,
                                                        //                 // ),
                                                        //                 fit: BoxFit.cover,
                                                        //               ),
                                                        //             ),
                                                        //           ),
                                                        //           Text(splitDate(HomeUpdate.date),style: TextStyle(color: Colors.white,fontSize: 8),)
                                                        //         ],
                                                        //       ),
                                                        //       SizedBox(
                                                        //         width: 5,
                                                        //       ),
                                                        //       Expanded(
                                                        //         child: Padding(
                                                        //           padding: const EdgeInsets.all(5.0),
                                                        //           child: Container(
                                                        //             child: Text(
                                                        //                 HomeUpdate.heading,
                                                        //               style: const TextStyle(
                                                        //                 fontSize: 15.0,
                                                        //                 color: Color.fromRGBO(204, 207, 222, 1),
                                                        //                 fontWeight: FontWeight.w400,
                                                        //               ),
                                                        //             )
                                                        //           ),
                                                        //         ),
                                                        //       )
                                                        //     ],
                                                        //   ),
                                                        // onTap: (){
                                                        //     if(HomeUpdate.link.length>0){
                                                        //       _ExternalLaunchUrl(HomeUpdate.link);
                                                        //     }else{
                                                        //       showToast("No Link");
                                                        //     }
                                                        // },
                                                        // );
                                                      },
                                                      separatorBuilder:
                                                          (context, index) =>
                                                              const SizedBox(
                                                                height: 5,
                                                              )),
                                                ),
                                              ],
                                            );
                                        }
                                    }
                                  }),
                              //Branch News
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 15, bottom: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      "ECE News",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                    Spacer(),
                                    if (userId() == "gmail.com")
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            border:
                                                Border.all(color: Colors.white),
                                          ),
                                          child: InkWell(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Text("+Add"),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          NewsCreator()));
                                            },
                                          ),
                                        ),
                                      ),
                                    InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[500],
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border:
                                              Border.all(color: Colors.white),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          child: Text("see more"),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NewsPage()));
                                      },
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ),
                              StreamBuilder<List<BranchNewConvertor>>(
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
                                          return const Center(
                                              child: Text(
                                                  'Error with TextBooks Data or\n Check Internet Connection'));
                                        } else {
                                          if (BranchNews!.length == 0) {
                                            return Center(
                                                child: Text(
                                              "No ECE News",
                                              style: TextStyle(
                                                  color:
                                                      Colors.lightBlueAccent),
                                            ));
                                          } else
                                            return CarouselSlider(
                                              items: List.generate(
                                                  BranchNews.length,
                                                  (int index) {
                                                final BranchNew =
                                                    BranchNews[index];
                                                final Uri uri = Uri.parse(
                                                    BranchNew.photoUrl);
                                                final String fileName =
                                                    uri.pathSegments.last;
                                                var name =
                                                    fileName.split("/").last;
                                                final file = File(
                                                    "${folderPath}/ece_news/$name");
                                                if (file.existsSync()) {
                                                  return InkWell(
                                                    child: Image.file(file),
                                                    onTap: () async {
                                                      _BranchNewsBottomSheet(
                                                          context,
                                                          BranchNew,
                                                          file);
                                                    },
                                                    onLongPress: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ImageZoom(
                                                                      url: BranchNew
                                                                          .photoUrl)));
                                                    },
                                                  );
                                                } else {
                                                  download(BranchNew.photoUrl,
                                                      "ece_news");
                                                  return InkWell(
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          BranchNew.photoUrl,
                                                      placeholder: (context,
                                                              url) =>
                                                          CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                    onTap: () async {
                                                      _BranchNewsBottomSheet(
                                                          context,
                                                          BranchNew,
                                                          file);
                                                    },
                                                    onLongPress: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ImageZoom(
                                                                      url: BranchNew
                                                                          .photoUrl)));
                                                    },
                                                  );
                                                }
                                              }),
                                              //Slider Container properties
                                              options: CarouselOptions(
                                                viewportFraction: 0.85,
                                                enlargeCenterPage: true,
                                                height: 210,
                                                autoPlayAnimationDuration:
                                                    Duration(
                                                        milliseconds: 1800),
                                                autoPlay: true,
                                              ),
                                            );
                                        }
                                    }
                                  }),
                              //Subjects
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 15),
                                child: Row(
                                  children: [
                                    Text(
                                      "Regulation : ",
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        "${mainsnapshot.data!["reg"].toString()}",
                                        style: TextStyle(
                                            color: Colors.orangeAccent,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.red.withOpacity(1),
                                          border:
                                              Border.all(color: Colors.white),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          child: Text(
                                            "Change",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              backgroundColor:
                                                  Colors.black.withOpacity(0.1),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              elevation: 16,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white
                                                          .withOpacity(0.5)),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: ListView(
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  children: <Widget>[
                                                    const Center(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(
                                                          "Select Regulation and Year",
                                                          style: TextStyle(
                                                              fontSize: 22,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .orange),
                                                        ),
                                                      ),
                                                    ),
                                                    StreamBuilder<
                                                            List<
                                                                RegulationConvertor>>(
                                                        stream:
                                                            readRegulation(),
                                                        builder: (context,
                                                            snapshot) {
                                                          final user =
                                                              snapshot.data;
                                                          switch (snapshot
                                                              .connectionState) {
                                                            case ConnectionState
                                                                .waiting:
                                                              return const Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                strokeWidth:
                                                                    0.3,
                                                                color:
                                                                    Colors.cyan,
                                                              ));
                                                            default:
                                                              if (snapshot
                                                                  .hasError) {
                                                                return const Center(
                                                                    child: Text(
                                                                        'Error with TextBooks Data or\n Check Internet Connection'));
                                                              } else {
                                                                return ListView
                                                                    .separated(
                                                                        physics:
                                                                            const BouncingScrollPhysics(),
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount: user!
                                                                            .length,
                                                                        itemBuilder: (context,
                                                                            int
                                                                                index) {
                                                                          final SubjectsData =
                                                                              user[index];
                                                                          return Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10, bottom: 5),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      "${SubjectsData.heading}",
                                                                                      style: TextStyle(color: Colors.white, fontSize: 30),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    InkWell(
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              " ADD",
                                                                                              style: TextStyle(color: Colors.redAccent, fontSize: 20),
                                                                                            ),
                                                                                            Icon(
                                                                                              Icons.add,
                                                                                              color: Colors.red,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      onTap: () {
                                                                                        showDialog(
                                                                                          context: context,
                                                                                          builder: (context) {
                                                                                            return Dialog(
                                                                                              backgroundColor: Colors.black.withOpacity(0.1),
                                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                                                              elevation: 16,
                                                                                              child: Container(
                                                                                                decoration: BoxDecoration(
                                                                                                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                                                                                                  borderRadius: BorderRadius.circular(20),
                                                                                                ),
                                                                                                child: ListView(
                                                                                                  physics: BouncingScrollPhysics(),
                                                                                                  shrinkWrap: true,
                                                                                                  children: <Widget>[
                                                                                                    Padding(
                                                                                                      padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                                                                                                      child: Text(
                                                                                                        "x year x sem",
                                                                                                        style: TextStyle(color: Colors.white, fontSize: 30),
                                                                                                      ),
                                                                                                    ),
                                                                                                    Padding(
                                                                                                      padding: const EdgeInsets.only(left: 10, bottom: 3, right: 10),
                                                                                                      child: Container(
                                                                                                        decoration: BoxDecoration(
                                                                                                          color: Colors.grey[200],
                                                                                                          border: Border.all(color: Colors.white),
                                                                                                          borderRadius: BorderRadius.circular(14),
                                                                                                        ),
                                                                                                        child: Padding(
                                                                                                          padding: const EdgeInsets.only(left: 20),
                                                                                                          child: TextFormField(
                                                                                                            //obscureText: true,
                                                                                                            controller: InputController,
                                                                                                            textInputAction: TextInputAction.next,
                                                                                                            decoration: InputDecoration(
                                                                                                              border: InputBorder.none,
                                                                                                              hintText: 'Description or Full name',
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    InkWell(
                                                                                                      child: Container(
                                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                                                                                        child: Text(
                                                                                                          "Create",
                                                                                                          style: TextStyle(color: Colors.white),
                                                                                                        ),
                                                                                                      ),
                                                                                                      onTap: () {
                                                                                                        FirebaseFirestore.instance.collection("ECE").doc("regulation").collection("regulation").doc(SubjectsData.id).collection("year").doc(getID()).set({
                                                                                                          "id": getTime(),
                                                                                                          "heading": InputController.text.trim()
                                                                                                        });
                                                                                                        Navigator.pop(context);
                                                                                                      },
                                                                                                    )
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
                                                                              ),
                                                                              StreamBuilder<List<RegulationYearConvertor>>(
                                                                                  stream: readRegulationYear(SubjectsData.id),
                                                                                  builder: (context, snapshot) {
                                                                                    final user1 = snapshot.data;
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
                                                                                              itemCount: user1!.length,
                                                                                              itemBuilder: (context, int index) {
                                                                                                final SubjectsData1 = user1[index];
                                                                                                return InkWell(
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.only(left: 25),
                                                                                                    child: Text(
                                                                                                      "${SubjectsData1.heading}",
                                                                                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                                    ),
                                                                                                  ),
                                                                                                  onTap: () {
                                                                                                    FirebaseFirestore.instance.collection("user").doc(fullUserId()).update({
                                                                                                      "YearId": SubjectsData1.id,
                                                                                                      "regId": SubjectsData.id,
                                                                                                      "reg": "${SubjectsData.heading}-${SubjectsData1.heading}"
                                                                                                    });

                                                                                                    Navigator.pop(context);
                                                                                                  },
                                                                                                  onLongPress: () {
                                                                                                    if (userId() == "gmail.com") FirebaseFirestore.instance.collection("ECE").doc("regulation").collection("regulation").doc(SubjectsData.id).collection("year").doc(SubjectsData1.id).delete();
                                                                                                  },
                                                                                                );
                                                                                              },
                                                                                              separatorBuilder: (context, index) => const SizedBox(
                                                                                                    height: 1,
                                                                                                  ));
                                                                                        }
                                                                                    }
                                                                                  }),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10, right: 10),
                                                                                child: Divider(
                                                                                  color: Colors.white,
                                                                                  thickness: 0.3,
                                                                                ),
                                                                              )
                                                                            ],
                                                                          );
                                                                        },
                                                                        separatorBuilder: (context,
                                                                                index) =>
                                                                            const SizedBox(
                                                                              height: 1,
                                                                            ));
                                                              }
                                                          }
                                                        }),
                                                    const SizedBox(
                                                      height: 10,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(width: 20),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Divider(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              if (mainsnapshot.data!["reg"]
                                  .toString()
                                  .isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 8, bottom: 8),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          "Time Table :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      StreamBuilder<List<TimeTableConvertor>>(
                                          stream: readTimeTable(
                                              id: mainsnapshot.data!["regId"]
                                                  .toString(),
                                              id1: mainsnapshot.data!["YearId"]
                                                  .toString()),
                                          builder: (context, snapshot) {
                                            final user = snapshot.data;
                                            switch (snapshot.connectionState) {
                                              case ConnectionState.waiting:
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                  strokeWidth: 0.3,
                                                  color: Colors.cyan,
                                                ));
                                              default:
                                                if (snapshot.hasError) {
                                                  return const Center(
                                                      child: Text(
                                                          'Error with TextBooks Data or\n Check Internet Connection'));
                                                } else {
                                                  return SizedBox(
                                                    height: 74,
                                                    child: ListView.separated(
                                                        physics:
                                                            const BouncingScrollPhysics(),
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount: user!.length,
                                                        itemBuilder: (context,
                                                            int index) {
                                                          final classess =
                                                              user[index];
                                                          final Uri uri =
                                                              Uri.parse(classess
                                                                  .photoUrl);
                                                          final String
                                                              fileName = uri
                                                                  .pathSegments
                                                                  .last;
                                                          var name = fileName
                                                              .split("/")
                                                              .last;
                                                          final file = File(
                                                              "${folderPath}/ece_timetable/$name");
                                                          if (file
                                                              .existsSync()) {
                                                            return InkWell(
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    height: 60,
                                                                    width: 70,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                40),
                                                                        image: DecorationImage(
                                                                            image:
                                                                                FileImage(file),
                                                                            fit: BoxFit.fill)),
                                                                  ),
                                                                  Center(
                                                                      child:
                                                                          Text(
                                                                    "${classess.heading}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ))
                                                                ],
                                                              ),
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            ImageZoom(
                                                                              url: classess.photoUrl,
                                                                            )));
                                                              },
                                                            );
                                                          } else {
                                                            download(
                                                                classess
                                                                    .photoUrl,
                                                                "ece_timetable");

                                                            return InkWell(
                                                              child: Container(
                                                                width: 70,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            40),
                                                                    image: DecorationImage(
                                                                        image: NetworkImage(classess
                                                                            .photoUrl),
                                                                        fit: BoxFit
                                                                            .fill)),
                                                                child: Center(
                                                                    child: Text(
                                                                        "${classess.heading}")),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        separatorBuilder:
                                                            (context, index) =>
                                                                const SizedBox(
                                                                  height: 1,
                                                                )),
                                                  );
                                                }
                                            }
                                          }),
                                    ],
                                  ),
                                ),
                              if (mainsnapshot.data!["reg"]
                                  .toString()
                                  .isNotEmpty)
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        "Subjects",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white54,
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          child: Text("see more"),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Subjects()));
                                      },
                                    ),
                                    SizedBox(
                                      width: 20,
                                    )
                                  ],
                                ),
                              if (mainsnapshot.data!["reg"]
                                  .toString()
                                  .isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 20, right: 10, bottom: 5),
                                  child: StreamBuilder<List<FlashConvertor>>(
                                      stream: readFlashNews(),
                                      builder: (context, snapshot) {
                                        final Favourites = snapshot.data;
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting:
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                              strokeWidth: 0.3,
                                              color: Colors.cyan,
                                            ));
                                          default:
                                            if (snapshot.hasError) {
                                              return Center(
                                                  child: Text("Error"));
                                            } else {
                                              if (Favourites!.length > 0)
                                                return ListView.builder(
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: Favourites.length,
                                                  itemBuilder:
                                                      (context, int index) {
                                                    final SubjectsData =
                                                        Favourites[index];
                                                    if (SubjectsData.regulation
                                                        .toString()
                                                        .startsWith(mainsnapshot
                                                            .data!["reg"]
                                                            .toString())) {
                                                      final Uri uri = Uri.parse(
                                                          SubjectsData
                                                              .PhotoUrl);
                                                      final String fileName =
                                                          uri.pathSegments.last;
                                                      var name = fileName
                                                          .split("/")
                                                          .last;
                                                      final file = File(
                                                          "${folderPath}/ece_subjects/$name");
                                                      if (file.existsSync()) {
                                                        return InkWell(
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black38,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                            child:
                                                                SingleChildScrollView(
                                                              physics:
                                                                  const BouncingScrollPhysics(),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width: 90.0,
                                                                    height:
                                                                        70.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(8.0)),
                                                                      color: Colors
                                                                          .redAccent,
                                                                      image:
                                                                          DecorationImage(
                                                                        image: FileImage(
                                                                            file),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Expanded(
                                                                      child:
                                                                          Column(
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
                                                                            SubjectsData.heading,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 20.0,
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          Spacer(),
                                                                          InkWell(
                                                                            child:
                                                                                StreamBuilder<DocumentSnapshot>(
                                                                              stream: FirebaseFirestore.instance.collection('ECE').doc("Subjects").collection("Subjects").doc(SubjectsData.id).collection("likes").doc(fullUserId()).snapshots(),
                                                                              builder: (context, snapshot) {
                                                                                if (snapshot.hasData) {
                                                                                  if (snapshot.data!.exists) {
                                                                                    return const Icon(
                                                                                      Icons.favorite,
                                                                                      color: Colors.red,
                                                                                      size: 26,
                                                                                    );
                                                                                  } else {
                                                                                    return const Icon(
                                                                                      Icons.favorite_border,
                                                                                      color: Colors.red,
                                                                                      size: 26,
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
                                                                                await FirebaseFirestore.instance.collection('ECE').doc("Subjects").collection("Subjects").doc(SubjectsData.id).collection("likes").doc(fullUserId()).get().then((docSnapshot) {
                                                                                  if (docSnapshot.exists) {
                                                                                    FirebaseFirestore.instance.collection('ECE').doc("Subjects").collection("Subjects").doc(SubjectsData.id).collection("likes").doc(fullUserId()).delete();
                                                                                    showToast("Unliked");
                                                                                  } else {
                                                                                    FirebaseFirestore.instance.collection('ECE').doc("Subjects").collection("Subjects").doc(SubjectsData.id).collection("likes").doc(fullUserId()).set({
                                                                                      "id": fullUserId()
                                                                                    });
                                                                                    showToast("Liked");
                                                                                  }
                                                                                });
                                                                              } catch (e) {
                                                                                print(e);
                                                                              }
                                                                            },
                                                                          ),
                                                                          StreamBuilder<
                                                                              QuerySnapshot>(
                                                                            stream:
                                                                                FirebaseFirestore.instance.collection('ECE').doc("Subjects").collection("Subjects").doc(SubjectsData.id).collection("likes").snapshots(),
                                                                            builder:
                                                                                (context, snapshot) {
                                                                              if (snapshot.hasData) {
                                                                                return Text(
                                                                                  " ${snapshot.data!.docs.length}",
                                                                                  style: const TextStyle(fontSize: 16, color: Colors.white),
                                                                                );
                                                                              } else {
                                                                                return const Text("0");
                                                                              }
                                                                            },
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          InkWell(
                                                                            child:
                                                                                StreamBuilder<DocumentSnapshot>(
                                                                              stream: FirebaseFirestore.instance.collection('user').doc(fullUserId()).collection("FavouriteSubject").doc(SubjectsData.id).snapshots(),
                                                                              builder: (context, snapshot) {
                                                                                if (snapshot.hasData) {
                                                                                  if (snapshot.data!.exists) {
                                                                                    return const Icon(Icons.library_add_check, size: 26, color: Colors.cyanAccent);
                                                                                  } else {
                                                                                    return const Icon(
                                                                                      Icons.library_add_outlined,
                                                                                      size: 26,
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
                                                                                await FirebaseFirestore.instance.collection('user').doc(fullUserId()).collection("FavouriteSubject").doc(SubjectsData.id).get().then((docSnapshot) {
                                                                                  if (docSnapshot.exists) {
                                                                                    FirebaseFirestore.instance.collection('user').doc(fullUserId()).collection("FavouriteSubject").doc(SubjectsData.id).delete();
                                                                                    showToast("Removed from saved list");
                                                                                  } else {
                                                                                    FavouriteSubjects(SubjectId: SubjectsData.id, name: SubjectsData.heading, description: SubjectsData.description, photoUrl: SubjectsData.PhotoUrl);
                                                                                    showToast("${SubjectsData.heading} in favorites");
                                                                                  }
                                                                                });
                                                                              } catch (e) {
                                                                                print(e);
                                                                              }
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            2,
                                                                      ),
                                                                      Text(
                                                                        SubjectsData
                                                                            .description,
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              13.0,
                                                                          color: Color.fromRGBO(
                                                                              204,
                                                                              207,
                                                                              222,
                                                                              1),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            1,
                                                                      ),
                                                                      Text(
                                                                        'Added :${SubjectsData.Date}',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              9.0,
                                                                          color:
                                                                              Colors.white60,
                                                                          //   fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      if (userId() ==
                                                                          "gmail.com")
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(right: 10),
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                              color: Colors.black.withOpacity(0.3),
                                                                              border: Border.all(color: Colors.white.withOpacity(0.5)),
                                                                            ),
                                                                            width:
                                                                                70,
                                                                            child:
                                                                                InkWell(
                                                                              child: Row(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  Icon(
                                                                                    Icons.edit,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 3, right: 3),
                                                                                    child: Text(
                                                                                      "Edit",
                                                                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 18),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              onTap: () {
                                                                                Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                        builder: (context) => SubjectsCreator(
                                                                                              Id: SubjectsData.id,
                                                                                              heading: SubjectsData.heading,
                                                                                              description: SubjectsData.description,
                                                                                              photoUrl: SubjectsData.PhotoUrl,
                                                                                              mode: "Subjects",
                                                                                            )));
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
                                                                    builder:
                                                                        (context) =>
                                                                            subjectUnitsData(
                                                                              ID: SubjectsData.id,
                                                                              mode: "Subjects",
                                                                              name: SubjectsData.heading,
                                                                              fullName: SubjectsData.description,
                                                                              photoUrl: SubjectsData.PhotoUrl,
                                                                            )));
                                                          },
                                                        );
                                                      } else {
                                                        download(
                                                            SubjectsData
                                                                .PhotoUrl,
                                                            "ece_subjects");
                                                        return InkWell(
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black38,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                            child:
                                                                SingleChildScrollView(
                                                              physics:
                                                                  const BouncingScrollPhysics(),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width: 90.0,
                                                                    height:
                                                                        70.0,
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl:
                                                                          SubjectsData
                                                                              .PhotoUrl,
                                                                      placeholder:
                                                                          (context, url) =>
                                                                              CircularProgressIndicator(),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Icon(Icons
                                                                              .error),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Expanded(
                                                                      child:
                                                                          Column(
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
                                                                            SubjectsData.heading,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 20.0,
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          Spacer(),
                                                                          InkWell(
                                                                            child:
                                                                                StreamBuilder<DocumentSnapshot>(
                                                                              stream: FirebaseFirestore.instance.collection('ECE').doc("Subjects").collection("Subjects").doc(SubjectsData.id).collection("likes").doc(fullUserId()).snapshots(),
                                                                              builder: (context, snapshot) {
                                                                                if (snapshot.hasData) {
                                                                                  if (snapshot.data!.exists) {
                                                                                    return const Icon(
                                                                                      Icons.favorite,
                                                                                      color: Colors.red,
                                                                                      size: 26,
                                                                                    );
                                                                                  } else {
                                                                                    return const Icon(
                                                                                      Icons.favorite_border,
                                                                                      color: Colors.red,
                                                                                      size: 26,
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
                                                                                await FirebaseFirestore.instance.collection('ECE').doc("Subjects").collection("Subjects").doc(SubjectsData.id).collection("likes").doc(fullUserId()).get().then((docSnapshot) {
                                                                                  if (docSnapshot.exists) {
                                                                                    FirebaseFirestore.instance.collection('ECE').doc("Subjects").collection("Subjects").doc(SubjectsData.id).collection("likes").doc(fullUserId()).delete();
                                                                                    showToast("Unliked");
                                                                                  } else {
                                                                                    FirebaseFirestore.instance.collection('ECE').doc("Subjects").collection("Subjects").doc(SubjectsData.id).collection("likes").doc(fullUserId()).set({
                                                                                      "id": fullUserId()
                                                                                    });
                                                                                    showToast("Liked");
                                                                                  }
                                                                                });
                                                                              } catch (e) {
                                                                                print(e);
                                                                              }
                                                                            },
                                                                          ),
                                                                          StreamBuilder<
                                                                              QuerySnapshot>(
                                                                            stream:
                                                                                FirebaseFirestore.instance.collection('ECE').doc("Subjects").collection("Subjects").doc(SubjectsData.id).collection("likes").snapshots(),
                                                                            builder:
                                                                                (context, snapshot) {
                                                                              if (snapshot.hasData) {
                                                                                return Text(
                                                                                  " ${snapshot.data!.docs.length}",
                                                                                  style: const TextStyle(fontSize: 16, color: Colors.white),
                                                                                );
                                                                              } else {
                                                                                return const Text("0");
                                                                              }
                                                                            },
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          InkWell(
                                                                            child:
                                                                                StreamBuilder<DocumentSnapshot>(
                                                                              stream: FirebaseFirestore.instance.collection('user').doc(fullUserId()).collection("FavouriteSubject").doc(SubjectsData.id).snapshots(),
                                                                              builder: (context, snapshot) {
                                                                                if (snapshot.hasData) {
                                                                                  if (snapshot.data!.exists) {
                                                                                    return const Icon(Icons.library_add_check, size: 26, color: Colors.cyanAccent);
                                                                                  } else {
                                                                                    return const Icon(
                                                                                      Icons.library_add_outlined,
                                                                                      size: 26,
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
                                                                                await FirebaseFirestore.instance.collection('user').doc(fullUserId()).collection("FavouriteSubject").doc(SubjectsData.id).get().then((docSnapshot) {
                                                                                  if (docSnapshot.exists) {
                                                                                    FirebaseFirestore.instance.collection('user').doc(fullUserId()).collection("FavouriteSubject").doc(SubjectsData.id).delete();
                                                                                    showToast("Removed from saved list");
                                                                                  } else {
                                                                                    FavouriteSubjects(SubjectId: SubjectsData.id, name: SubjectsData.heading, description: SubjectsData.description, photoUrl: SubjectsData.PhotoUrl);
                                                                                    showToast("${SubjectsData.heading} in favorites");
                                                                                  }
                                                                                });
                                                                              } catch (e) {
                                                                                print(e);
                                                                              }
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            2,
                                                                      ),
                                                                      Text(
                                                                        SubjectsData
                                                                            .description,
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              13.0,
                                                                          color: Color.fromRGBO(
                                                                              204,
                                                                              207,
                                                                              222,
                                                                              1),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            1,
                                                                      ),
                                                                      Text(
                                                                        'Added :${SubjectsData.Date}',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              9.0,
                                                                          color:
                                                                              Colors.white60,
                                                                          //   fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      if (userId() ==
                                                                          "gmail.com")
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(right: 10),
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                              color: Colors.black.withOpacity(0.3),
                                                                              border: Border.all(color: Colors.white.withOpacity(0.5)),
                                                                            ),
                                                                            width:
                                                                                70,
                                                                            child:
                                                                                InkWell(
                                                                              child: Row(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  Icon(
                                                                                    Icons.edit,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 3, right: 3),
                                                                                    child: Text(
                                                                                      "Edit",
                                                                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 18),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              onTap: () {
                                                                                Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                        builder: (context) => SubjectsCreator(
                                                                                              Id: SubjectsData.id,
                                                                                              heading: SubjectsData.heading,
                                                                                              description: SubjectsData.description,
                                                                                              photoUrl: SubjectsData.PhotoUrl,
                                                                                              mode: "Subjects",
                                                                                            )));
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
                                                                    builder:
                                                                        (context) =>
                                                                            subjectUnitsData(
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
                                                        );
                                                      }
                                                    } else {
                                                      return Container();
                                                    }
                                                  },
                                                );
                                              else
                                                return InkWell(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .tealAccent),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            "No Subjects are Liked"),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Dialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            elevation: 16,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .tealAccent),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              child: ListView(
                                                                shrinkWrap:
                                                                    true,
                                                                children: <
                                                                    Widget>[
                                                                  SizedBox(
                                                                      height:
                                                                          10),
                                                                  Center(
                                                                      child:
                                                                          Text(
                                                                    'Note',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black87,
                                                                        fontSize:
                                                                            20),
                                                                  )),
                                                                  Divider(
                                                                    color: Colors
                                                                        .tealAccent,
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          5),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15),
                                                                    child: Text(
                                                                        "1. Click on 'See More' option"),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15),
                                                                    child: Text(
                                                                        "2. Long Press on Subject u need to add as important"),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15),
                                                                    child: Text(
                                                                        "3. Restart the application"),
                                                                  ),
                                                                  Divider(
                                                                    color: Colors
                                                                        .tealAccent,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15),
                                                                    child: Text(
                                                                        "1. Long Press on Subject u need to remove as important"),
                                                                  ),
                                                                  Divider(
                                                                    color: Colors
                                                                        .tealAccent,
                                                                  ),
                                                                  Center(
                                                                    child:
                                                                        InkWell(
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.black26,
                                                                          border:
                                                                              Border.all(color: Colors.black),
                                                                          borderRadius:
                                                                              BorderRadius.circular(25),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 15,
                                                                              right: 15,
                                                                              top: 5,
                                                                              bottom: 5),
                                                                          child:
                                                                              Text("Back"),
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
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
                                                    });
                                            }
                                        }
                                      }),
                                )
                              else
                                Center(
                                    child: Column(
                                  children: [
                                    Text(
                                      "Regulation and Year is Not Selected for Subjects",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white54,
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          child: Text("see more"),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Subjects()));
                                      },
                                    ),
                                  ],
                                )),
                              //Lab Subjects
                              if (mainsnapshot.data!["reg"]
                                  .toString()
                                  .isNotEmpty)
                                StreamBuilder<List<LabSubjectsConvertor>>(
                                  stream: readLabSubjects(),
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
                                          return Text("Error with fireBase");
                                        } else {
                                          if (Subjects!.length > 0)
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20,
                                                  top: 10,
                                                  bottom: 10,
                                                  right: 10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Lab Subjects",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Spacer(),
                                                      InkWell(
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Colors.white54,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10,
                                                                    right: 10,
                                                                    top: 5,
                                                                    bottom: 5),
                                                            child: Text(
                                                                "see more"),
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const LabSubjects()));
                                                        },
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  ListView.builder(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: Subjects.length,
                                                    itemBuilder:
                                                        (context, int index) {
                                                      final LabSubjectsData =
                                                          Subjects[index];
                                                      if (LabSubjectsData
                                                          .regulation
                                                          .toString()
                                                          .startsWith(
                                                              mainsnapshot
                                                                  .data!["reg"]
                                                                  .toString())) {
                                                        final Uri uri =
                                                            Uri.parse(
                                                                LabSubjectsData
                                                                    .PhotoUrl);
                                                        final String fileName =
                                                            uri.pathSegments
                                                                .last;
                                                        var name = fileName
                                                            .split("/")
                                                            .last;
                                                        final file = File(
                                                            "${folderPath}/ece_labsubjects/$name");
                                                        if (file.existsSync()) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 5,
                                                                    left: 5,
                                                                    right: 5),
                                                            child: InkWell(
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .black38,
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10))),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  physics:
                                                                      const BouncingScrollPhysics(),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            90.0,
                                                                        height:
                                                                            70.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(8.0)),
                                                                          color:
                                                                              Colors.redAccent,
                                                                          image:
                                                                              DecorationImage(
                                                                            image:
                                                                                FileImage(file),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Expanded(
                                                                          child:
                                                                              Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
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
                                                                                child: StreamBuilder<DocumentSnapshot>(
                                                                                  stream: FirebaseFirestore.instance.collection('ECE').doc("LabSubjects").collection("LabSubjects").doc(LabSubjectsData.id).collection("likes").doc(fullUserId()).snapshots(),
                                                                                  builder: (context, snapshot) {
                                                                                    if (snapshot.hasData) {
                                                                                      if (snapshot.data!.exists) {
                                                                                        return const Icon(
                                                                                          Icons.favorite,
                                                                                          color: Colors.red,
                                                                                          size: 26,
                                                                                        );
                                                                                      } else {
                                                                                        return const Icon(
                                                                                          Icons.favorite_border,
                                                                                          color: Colors.red,
                                                                                          size: 26,
                                                                                        );
                                                                                      }
                                                                                    } else {
                                                                                      return Container();
                                                                                    }
                                                                                  },
                                                                                ),
                                                                                onTap: () async {
                                                                                  try {
                                                                                    await FirebaseFirestore.instance.collection('ECE').doc("LabSubjects").collection("LabSubjects").doc(LabSubjectsData.id).collection("likes").doc(fullUserId()).get().then((docSnapshot) {
                                                                                      if (docSnapshot.exists) {
                                                                                        FirebaseFirestore.instance.collection('ECE').doc("LabSubjects").collection("LabSubjects").doc(LabSubjectsData.id).collection("likes").doc(fullUserId()).delete();
                                                                                        showToast("Unliked");
                                                                                      } else {
                                                                                        FirebaseFirestore.instance.collection('ECE').doc("LabSubjects").collection("LabSubjects").doc(LabSubjectsData.id).collection("likes").doc(fullUserId()).set({
                                                                                          "id": fullUserId()
                                                                                        });
                                                                                        showToast("Liked");
                                                                                      }
                                                                                    });
                                                                                  } catch (e) {
                                                                                    print(e);
                                                                                  }
                                                                                },
                                                                              ),
                                                                              StreamBuilder<QuerySnapshot>(
                                                                                stream: FirebaseFirestore.instance.collection('ECE').doc("LabSubjects").collection("LabSubjects").doc(LabSubjectsData.id).collection("likes").snapshots(),
                                                                                builder: (context, snapshot) {
                                                                                  if (snapshot.hasData) {
                                                                                    return Text(
                                                                                      " ${snapshot.data!.docs.length}",
                                                                                      style: const TextStyle(fontSize: 16, color: Colors.white),
                                                                                    );
                                                                                  } else {
                                                                                    return const Text("0");
                                                                                  }
                                                                                },
                                                                              ),
                                                                              SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              InkWell(
                                                                                child: StreamBuilder<DocumentSnapshot>(
                                                                                  stream: FirebaseFirestore.instance.collection('user').doc(fullUserId()).collection("FavouriteLabSubjects").doc(LabSubjectsData.id).snapshots(),
                                                                                  builder: (context, snapshot) {
                                                                                    if (snapshot.hasData) {
                                                                                      if (snapshot.data!.exists) {
                                                                                        return const Icon(Icons.library_add_check, size: 26, color: Colors.cyanAccent);
                                                                                      } else {
                                                                                        return const Icon(
                                                                                          Icons.library_add_outlined,
                                                                                          size: 26,
                                                                                          color: Colors.cyanAccent,
                                                                                        );
                                                                                      }
                                                                                    } else {
                                                                                      return Container();
                                                                                    }
                                                                                  },
                                                                                ),
                                                                                onTap: () async {
                                                                                  try {
                                                                                    await FirebaseFirestore.instance.collection('user').doc(fullUserId()).collection("FavouriteLabSubjects").doc(LabSubjectsData.id).get().then((docSnapshot) {
                                                                                      if (docSnapshot.exists) {
                                                                                        FirebaseFirestore.instance.collection('user').doc(fullUserId()).collection("FavouriteLabSubjects").doc(LabSubjectsData.id).delete();
                                                                                        showToast("Removed from saved list");
                                                                                      } else {
                                                                                        FavouriteLabSubjectsSubjects(SubjectId: LabSubjectsData.id, name: LabSubjectsData.heading, description: LabSubjectsData.description, photoUrl: LabSubjectsData.PhotoUrl);
                                                                                        showToast("${LabSubjectsData.heading} in favorites");
                                                                                      }
                                                                                    });
                                                                                  } catch (e) {
                                                                                    print(e);
                                                                                  }
                                                                                },
                                                                              ),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              )
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                2,
                                                                          ),
                                                                          Text(
                                                                            LabSubjectsData.description,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 13.0,
                                                                              color: Color.fromRGBO(204, 207, 222, 1),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                1,
                                                                          ),
                                                                          Text(
                                                                            'Added :${LabSubjectsData.Date}',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 9.0,
                                                                              color: Colors.white60,
                                                                              //   fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          if (userId() ==
                                                                              "gmail.com")
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
                                                                                    Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                            builder: (context) => SubjectsCreator(
                                                                                                  Id: LabSubjectsData.id,
                                                                                                  heading: LabSubjectsData.heading,
                                                                                                  description: LabSubjectsData.description,
                                                                                                  photoUrl: LabSubjectsData.PhotoUrl,
                                                                                                  mode: "LabSubjects",
                                                                                                )));
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
                                                                        builder: (context) =>
                                                                            subjectUnitsData(
                                                                              ID: LabSubjectsData.id,
                                                                              mode: "LabSubjects",
                                                                              name: LabSubjectsData.heading,
                                                                              fullName: LabSubjectsData.description,
                                                                              photoUrl: LabSubjectsData.PhotoUrl,
                                                                            )));
                                                              },
                                                              onLongPress: () {
                                                                FavouriteLabSubjectsSubjects(
                                                                    SubjectId:
                                                                        LabSubjectsData
                                                                            .id,
                                                                    name: LabSubjectsData
                                                                        .heading,
                                                                    description:
                                                                        LabSubjectsData
                                                                            .description,
                                                                    photoUrl:
                                                                        LabSubjectsData
                                                                            .PhotoUrl);
                                                              },
                                                            ),
                                                          );
                                                        } else {
                                                          download(
                                                              LabSubjectsData
                                                                  .PhotoUrl,
                                                              "ece_labsubjects");
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 5,
                                                                    left: 5,
                                                                    right: 5),
                                                            child: InkWell(
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .black38,
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10))),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  physics:
                                                                      const BouncingScrollPhysics(),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            90.0,
                                                                        height:
                                                                            70.0,
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          imageUrl:
                                                                              LabSubjectsData.PhotoUrl,
                                                                          placeholder: (context, url) =>
                                                                              CircularProgressIndicator(),
                                                                          errorWidget: (context, url, error) =>
                                                                              Icon(
                                                                            Icons.error,
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Expanded(
                                                                          child:
                                                                              Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
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
                                                                                child: StreamBuilder<DocumentSnapshot>(
                                                                                  stream: FirebaseFirestore.instance.collection('ECE').doc("LabSubjects").collection("LabSubjects").doc(LabSubjectsData.id).collection("likes").doc(fullUserId()).snapshots(),
                                                                                  builder: (context, snapshot) {
                                                                                    if (snapshot.hasData) {
                                                                                      if (snapshot.data!.exists) {
                                                                                        return const Icon(
                                                                                          Icons.favorite,
                                                                                          color: Colors.red,
                                                                                          size: 26,
                                                                                        );
                                                                                      } else {
                                                                                        return const Icon(
                                                                                          Icons.favorite_border,
                                                                                          color: Colors.red,
                                                                                          size: 26,
                                                                                        );
                                                                                      }
                                                                                    } else {
                                                                                      return Container();
                                                                                    }
                                                                                  },
                                                                                ),
                                                                                onTap: () async {
                                                                                  try {
                                                                                    await FirebaseFirestore.instance.collection('ECE').doc("LabSubjects").collection("LabSubjects").doc(LabSubjectsData.id).collection("likes").doc(fullUserId()).get().then((docSnapshot) {
                                                                                      if (docSnapshot.exists) {
                                                                                        FirebaseFirestore.instance.collection('ECE').doc("LabSubjects").collection("LabSubjects").doc(LabSubjectsData.id).collection("likes").doc(fullUserId()).delete();
                                                                                        showToast("Unliked");
                                                                                      } else {
                                                                                        FirebaseFirestore.instance.collection('ECE').doc("LabSubjects").collection("LabSubjects").doc(LabSubjectsData.id).collection("likes").doc(fullUserId()).set({
                                                                                          "id": fullUserId()
                                                                                        });
                                                                                        showToast("Liked");
                                                                                      }
                                                                                    });
                                                                                  } catch (e) {
                                                                                    print(e);
                                                                                  }
                                                                                },
                                                                              ),
                                                                              StreamBuilder<QuerySnapshot>(
                                                                                stream: FirebaseFirestore.instance.collection('ECE').doc("LabSubjects").collection("LabSubjects").doc(LabSubjectsData.id).collection("likes").snapshots(),
                                                                                builder: (context, snapshot) {
                                                                                  if (snapshot.hasData) {
                                                                                    return Text(
                                                                                      " ${snapshot.data!.docs.length}",
                                                                                      style: const TextStyle(fontSize: 16, color: Colors.white),
                                                                                    );
                                                                                  } else {
                                                                                    return const Text("0");
                                                                                  }
                                                                                },
                                                                              ),
                                                                              SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              InkWell(
                                                                                child: StreamBuilder<DocumentSnapshot>(
                                                                                  stream: FirebaseFirestore.instance.collection('user').doc(fullUserId()).collection("FavouriteLabSubjects").doc(LabSubjectsData.id).snapshots(),
                                                                                  builder: (context, snapshot) {
                                                                                    if (snapshot.hasData) {
                                                                                      if (snapshot.data!.exists) {
                                                                                        return const Icon(Icons.library_add_check, size: 26, color: Colors.cyanAccent);
                                                                                      } else {
                                                                                        return const Icon(
                                                                                          Icons.library_add_outlined,
                                                                                          size: 26,
                                                                                          color: Colors.cyanAccent,
                                                                                        );
                                                                                      }
                                                                                    } else {
                                                                                      return Container();
                                                                                    }
                                                                                  },
                                                                                ),
                                                                                onTap: () async {
                                                                                  try {
                                                                                    await FirebaseFirestore.instance.collection('user').doc(fullUserId()).collection("FavouriteLabSubjects").doc(LabSubjectsData.id).get().then((docSnapshot) {
                                                                                      if (docSnapshot.exists) {
                                                                                        FirebaseFirestore.instance.collection('user').doc(fullUserId()).collection("FavouriteLabSubjects").doc(LabSubjectsData.id).delete();
                                                                                        showToast("Removed from saved list");
                                                                                      } else {
                                                                                        FavouriteLabSubjectsSubjects(SubjectId: LabSubjectsData.id, name: LabSubjectsData.heading, description: LabSubjectsData.description, photoUrl: LabSubjectsData.PhotoUrl);
                                                                                        showToast("${LabSubjectsData.heading} in favorites");
                                                                                      }
                                                                                    });
                                                                                  } catch (e) {
                                                                                    print(e);
                                                                                  }
                                                                                },
                                                                              ),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              )
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                2,
                                                                          ),
                                                                          Text(
                                                                            LabSubjectsData.description,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 13.0,
                                                                              color: Color.fromRGBO(204, 207, 222, 1),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                1,
                                                                          ),
                                                                          Text(
                                                                            'Added :${LabSubjectsData.Date}',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 9.0,
                                                                              color: Colors.white60,
                                                                              //   fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          if (userId() ==
                                                                              "gmail.com")
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
                                                                                    Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                            builder: (context) => SubjectsCreator(
                                                                                                  Id: LabSubjectsData.id,
                                                                                                  heading: LabSubjectsData.heading,
                                                                                                  description: LabSubjectsData.description,
                                                                                                  photoUrl: LabSubjectsData.PhotoUrl,
                                                                                                  mode: "LabSubjects",
                                                                                                )));
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
                                                                        builder: (context) =>
                                                                            subjectUnitsData(
                                                                              ID: LabSubjectsData.id,
                                                                              mode: "LabSubjects",
                                                                              name: LabSubjectsData.heading,
                                                                              fullName: LabSubjectsData.description,
                                                                              photoUrl: LabSubjectsData.PhotoUrl,
                                                                            )));
                                                              },
                                                              onLongPress: () {
                                                                FavouriteLabSubjectsSubjects(
                                                                    SubjectId:
                                                                        LabSubjectsData
                                                                            .id,
                                                                    name: LabSubjectsData
                                                                        .heading,
                                                                    description:
                                                                        LabSubjectsData
                                                                            .description,
                                                                    photoUrl:
                                                                        LabSubjectsData
                                                                            .PhotoUrl);
                                                              },
                                                            ),
                                                          );
                                                        }
                                                        //   return Padding(
                                                        //       padding: const EdgeInsets.only(top: 3),
                                                        //       child: InkWell(
                                                        //   child: Container(
                                                        //       width: double.infinity,
                                                        //       decoration: BoxDecoration(color: Colors.white.withOpacity(0.07), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                        //       child: SingleChildScrollView(
                                                        //         physics: const BouncingScrollPhysics(),
                                                        //         child: Row(
                                                        //           children: [
                                                        //             Container(
                                                        //               width: 90.0,
                                                        //               height: 70.0,
                                                        //               decoration: BoxDecoration(
                                                        //                 borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                        //                 color: Colors.black.withOpacity(0.6),
                                                        //                 image: DecorationImage(
                                                        //                   image: NetworkImage(
                                                        //                     SubjectsData.PhotoUrl,
                                                        //                   ),
                                                        //                   fit: BoxFit.cover,
                                                        //                 ),
                                                        //               ),
                                                        //             ),
                                                        //             const SizedBox(
                                                        //               width: 10,
                                                        //             ),
                                                        //             Expanded(
                                                        //                 child: Column(
                                                        //               mainAxisAlignment: MainAxisAlignment.center,
                                                        //               crossAxisAlignment: CrossAxisAlignment.start,
                                                        //               children: [
                                                        //                 Row(
                                                        //                   children: [
                                                        //                     Text(
                                                        //                       SubjectsData.heading,
                                                        //                       style: const TextStyle(
                                                        //                         fontSize: 20.0,
                                                        //                         color: Colors.white,
                                                        //                         fontWeight: FontWeight.w600,
                                                        //                       ),
                                                        //                     ),
                                                        //                     Spacer(),
                                                        //                     InkWell(
                                                        //                       child: StreamBuilder<DocumentSnapshot>(
                                                        //                         stream: FirebaseFirestore.instance.collection('ECE')
                                                        //                             .doc("LabSubjects")
                                                        //                             .collection("LabSubjects").doc(SubjectsData.id).collection("likes").doc(fullUserId()).snapshots(),
                                                        //                         builder: (context, snapshot) {
                                                        //                           if (snapshot.hasData) {
                                                        //                             if (snapshot.data!.exists) {
                                                        //                               return const Icon(Icons.favorite,color: Colors.red,size: 26,);
                                                        //                             } else {
                                                        //                               return const Icon(Icons.favorite_border,color: Colors.red,size: 26,);
                                                        //                             }
                                                        //                           } else {
                                                        //                             return Container();
                                                        //                           }
                                                        //                         },
                                                        //                       ),
                                                        //                       onTap:
                                                        //                           ()async {
                                                        //
                                                        //                         try {
                                                        //                           await FirebaseFirestore.instance.
                                                        //                           collection('ECE')
                                                        //                               .doc("LabSubjects")
                                                        //                               .collection("LabSubjects").doc(SubjectsData.id).collection("likes").doc(fullUserId())
                                                        //                               .get()
                                                        //                               .then((docSnapshot) {
                                                        //                             if (docSnapshot.exists) {
                                                        //                               FirebaseFirestore.instance.
                                                        //                               collection('ECE')
                                                        //                                   .doc("LabSubjects")
                                                        //                                   .collection("LabSubjects").doc(SubjectsData.id).collection("likes").doc(fullUserId())
                                                        //                                   .delete();
                                                        //                               showToast("Unliked");
                                                        //                             } else {
                                                        //                               FirebaseFirestore.instance.
                                                        //                               collection('ECE')
                                                        //                                   .doc("LabSubjects")
                                                        //                                   .collection("LabSubjects").doc(SubjectsData.id).collection("likes").doc(fullUserId())
                                                        //                                   .set({"id": fullUserId()});
                                                        //                               showToast("Liked");
                                                        //                             }
                                                        //                           });
                                                        //                         } catch (e) {
                                                        //                           print(e);
                                                        //                         }
                                                        //                       },
                                                        //                     ),
                                                        //                     StreamBuilder<QuerySnapshot>(
                                                        //                       stream: FirebaseFirestore.instance
                                                        //                           .collection('ECE')
                                                        //                           .doc("LabSubjects")
                                                        //                           .collection("LabSubjects").doc(SubjectsData.id).collection("likes")
                                                        //                           .snapshots(),
                                                        //                       builder: (context, snapshot) {
                                                        //                         if (snapshot.hasData) {
                                                        //                           return Text(" ${snapshot.data!.docs.length}",style: const TextStyle(fontSize: 16,color: Colors.white),);
                                                        //                         } else {
                                                        //                           return const Text("0");
                                                        //                         }
                                                        //                       },
                                                        //                     ),
                                                        //                     SizedBox(width: 5,),
                                                        //
                                                        //                     InkWell(
                                                        //                       child: StreamBuilder<DocumentSnapshot>(
                                                        //                         stream: FirebaseFirestore.instance.collection('user').doc(fullUserId()).collection("FavouriteLabSubjects").doc(SubjectsData.id).snapshots(),
                                                        //                         builder: (context, snapshot) {
                                                        //                           if (snapshot.hasData) {
                                                        //                             if (snapshot.data!.exists) {
                                                        //                               return const Icon(
                                                        //                                   Icons.library_add_check,
                                                        //                                   size: 26, color: Colors.cyanAccent
                                                        //                               );
                                                        //                             } else {
                                                        //                               return const Icon(
                                                        //                                 Icons.library_add_outlined,
                                                        //                                 size: 26,
                                                        //                                 color: Colors.cyanAccent,
                                                        //                               );
                                                        //                             }
                                                        //                           } else {
                                                        //                             return Container();
                                                        //                           }
                                                        //                         },
                                                        //                       ),
                                                        //                       onTap: () async{
                                                        //                         try {
                                                        //                           await FirebaseFirestore
                                                        //                               .instance
                                                        //                               .collection('user').doc(fullUserId()).collection("FavouriteLabSubjects").doc(SubjectsData.id)
                                                        //                               .get()
                                                        //                               .then((docSnapshot) {
                                                        //                             if (docSnapshot.exists) {
                                                        //                               FirebaseFirestore.instance.collection('user').doc(fullUserId()).collection("FavouriteLabSubjects").doc(SubjectsData.id).delete();
                                                        //                               showToast("Removed from saved list");
                                                        //                             } else {
                                                        //                               FavouriteLabSubjectsSubjects(SubjectId: SubjectsData.id,name: SubjectsData.heading,description: SubjectsData.description,photoUrl: SubjectsData.PhotoUrl);
                                                        //                               showToast("${SubjectsData.heading} in favorites");                                                         }
                                                        //                           });
                                                        //                         } catch (e) {
                                                        //                           print(
                                                        //                               e);
                                                        //                         }
                                                        //
                                                        //                       },
                                                        //                     ),
                                                        //
                                                        //                   ],
                                                        //                 ),
                                                        //                 SizedBox(
                                                        //                   height: 2,
                                                        //                 ),
                                                        //                 Text(
                                                        //                   SubjectsData.description,
                                                        //                   style: const TextStyle(
                                                        //                     fontSize: 13.0,
                                                        //                     color: Color.fromRGBO(204, 207, 222, 1),
                                                        //                   ),
                                                        //                 ),
                                                        //                 SizedBox(
                                                        //                   height: 1,
                                                        //                 ),
                                                        //                 Text(
                                                        //                   'Added :${SubjectsData.Date}',
                                                        //                   style: const TextStyle(
                                                        //                     fontSize: 9.0,
                                                        //                     color: Colors.white60,
                                                        //                     //   fontWeight: FontWeight.bold,
                                                        //                   ),
                                                        //                 ),
                                                        //               ],
                                                        //             ))
                                                        //           ],
                                                        //         ),
                                                        //       ),
                                                        //   ),
                                                        //   onTap: () {
                                                        //       Navigator.push(
                                                        //           context,
                                                        //           MaterialPageRoute(
                                                        //               builder: (context) => subjectUnitsData(
                                                        //                     ID: SubjectsData.id,
                                                        //                     mode: "LabSubjects",
                                                        //                     name: SubjectsData.heading,
                                                        //                 photoUrl: SubjectsData.PhotoUrl,
                                                        //                 fullName: SubjectsData.description,
                                                        //
                                                        //                   )));
                                                        //   },
                                                        // ),
                                                        //     );
                                                      } else {
                                                        return Container();
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          else
                                            return Center(
                                                child: Text(
                                                    "No Lab Subjects For Your Regulation"));
                                        }
                                    }
                                  },
                                ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                child: StreamBuilder<List<BooksConvertor>>(
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
                                            return const Center(
                                                child: Text(
                                                    'Error with TextBooks Data or\n Check Internet Connection'));
                                          } else {
                                            if (Books!.length < 1) {
                                              return Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "No ECE Books",
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  ),
                                                ),
                                              );
                                            } else
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            bottom: 10),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Based on ECE",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        Spacer(),
                                                        if (userId() ==
                                                            "gmail.com")
                                                          InkWell(
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.5),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                        top: 5,bottom: 5),
                                                                child: Text(
                                                                    "+Add"),
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              BooksCreator()));
                                                            },
                                                          ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        InkWell(
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.5),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                        top: 5,
                                                                        bottom:
                                                                            5),
                                                                child: Text(
                                                                    "See More"),
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              allBooks()));
                                                            }),
                                                        SizedBox(
                                                          width: 20,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 125,
                                                    child: ListView.builder(
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: Books.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        final Uri uri =
                                                            Uri.parse(
                                                                Books[index]
                                                                    .photoUrl);
                                                        final String fileName =
                                                            uri.pathSegments
                                                                .last;
                                                        var name = fileName
                                                            .split("/")
                                                            .last;
                                                        final file = File(
                                                            "${folderPath}/ece_books/$name");

                                                        final Uri uri1 =
                                                            Uri.parse(
                                                                Books[index]
                                                                    .link);
                                                        final String fileName1 =
                                                            uri1.pathSegments
                                                                .last;
                                                        var name1 = fileName1
                                                            .split("/")
                                                            .last;
                                                        final file1 = File(
                                                            "${folderPath}/pdfs/$name1");
                                                        if (file.existsSync()) {
                                                          return InkWell(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.3),
                                                                  // border: Border.all(color: Colors.white),
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.4),
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              FileImage(file),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                      height:
                                                                          140,
                                                                      width: 90,
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            120,
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          physics:
                                                                              BouncingScrollPhysics(),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                Books[index].heading,
                                                                                maxLines: 2,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
                                                                              ),
                                                                              Text(
                                                                                Books[index].Author,
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: Colors.white),
                                                                              ),
                                                                              Text(
                                                                                Books[index].edition,
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: Colors.white),
                                                                              ),
                                                                              Text(
                                                                                Books[index].description,
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13, color: Colors.white),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              if (file1.existsSync())
                                                                                InkWell(
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(8),
                                                                                        color: Colors.black.withOpacity(0.5),
                                                                                        border: Border.all(color: Colors.green),
                                                                                      ),
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.only(left: 3, right: 3),
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Icon(
                                                                                              Icons.download_outlined,
                                                                                              color: Colors.green,
                                                                                            ),
                                                                                            Text(
                                                                                              " & ",
                                                                                              style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                            ),
                                                                                            Text(
                                                                                              "Open",
                                                                                              style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                            ),
                                                                                            Icon(
                                                                                              Icons.open_in_new,
                                                                                              color: Colors.greenAccent,
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    onTap: () {
                                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewerPage(pdfUrl: "${folderPath}/pdfs/$name1")));
                                                                                    })
                                                                              else
                                                                                InkWell(
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(8),
                                                                                      color: Colors.black.withOpacity(0.5),
                                                                                      border: Border.all(color: Colors.white),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(left: 3, right: 3),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.download_outlined,
                                                                                            color: Colors.red,
                                                                                          ),
                                                                                          Text(
                                                                                            " & ",
                                                                                            style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                          ),
                                                                                          Text(
                                                                                            "Open",
                                                                                            style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                          ),
                                                                                          Icon(
                                                                                            Icons.open_in_new,
                                                                                            color: Colors.greenAccent,
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  onTap: () async {
                                                                                    showToast("Downloading...");
                                                                                    await download(Books[index].link, "pdfs");
                                                                                    setState(() {
                                                                                      showToast("Downloaded");
                                                                                    });
                                                                                  },
                                                                                )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 20,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              _BooksBottomSheet(
                                                                  context,
                                                                  Books[index],
                                                                  file,
                                                                  file1);
                                                            },
                                                          );
                                                        } else {
                                                          download(
                                                              Books[index]
                                                                  .photoUrl,
                                                              "ece_books");
                                                          return InkWell(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.3),
                                                                  // border: Border.all(color: Colors.white),
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.4),
                                                                      ),
                                                                      height:
                                                                          140,
                                                                      width: 90,
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        imageUrl:
                                                                            Books[index].photoUrl,
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                CircularProgressIndicator(),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            Icon(Icons.error),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            120,
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          physics:
                                                                              BouncingScrollPhysics(),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                Books[index].heading,
                                                                                maxLines: 2,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
                                                                              ),
                                                                              Text(
                                                                                Books[index].Author,
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: Colors.white),
                                                                              ),
                                                                              Text(
                                                                                Books[index].edition,
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: Colors.white),
                                                                              ),
                                                                              Text(
                                                                                Books[index].description,
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13, color: Colors.white),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              if (file1.existsSync())
                                                                                InkWell(
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(8),
                                                                                        color: Colors.black.withOpacity(0.5),
                                                                                        border: Border.all(color: Colors.green),
                                                                                      ),
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.only(left: 3, right: 3),
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Icon(
                                                                                              Icons.download_outlined,
                                                                                              color: Colors.green,
                                                                                            ),
                                                                                            Text(
                                                                                              " & ",
                                                                                              style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                            ),
                                                                                            Text(
                                                                                              "Open",
                                                                                              style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                            ),
                                                                                            Icon(
                                                                                              Icons.open_in_new,
                                                                                              color: Colors.greenAccent,
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    onTap: () {
                                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewerPage(pdfUrl: "${folderPath}/pdfs/$name")));
                                                                                    })
                                                                              else
                                                                                InkWell(
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(8),
                                                                                      color: Colors.black.withOpacity(0.5),
                                                                                      border: Border.all(color: Colors.white),
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(left: 3, right: 3),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.download_outlined,
                                                                                            color: Colors.red,
                                                                                          ),
                                                                                          Text(
                                                                                            " & ",
                                                                                            style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                          ),
                                                                                          Text(
                                                                                            "Open",
                                                                                            style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                          ),
                                                                                          Icon(
                                                                                            Icons.open_in_new,
                                                                                            color: Colors.greenAccent,
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  onTap: () async {
                                                                                    download(Books[index].link, "pdfs");
                                                                                  },
                                                                                )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 20,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              _BooksBottomSheet(
                                                                  context,
                                                                  Books[index],
                                                                  file,
                                                                  file1);
                                                            },
                                                          );
                                                        }
                                                      },
                                                      shrinkWrap: true,
                                                    ),
                                                  ),
                                                ],
                                              );
                                          }
                                      }
                                    }),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(
                    child: Text("kjshd"),
                  );
                }
              },
            )),
          ),
        ),
      );

  splitDate(String date) {
    var out = date.split(":");
    return out[0];
  }
}

Stream<List<HomeUpdateConvertor>> readHomeUpdate() => FirebaseFirestore.instance
    .collection('ECE')
    .doc("update")
    .collection("update")
    .orderBy("date", descending: true)
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => HomeUpdateConvertor.fromJson(doc.data()))
        .toList());

Future createHomeUpdate(
    {required String heading,
    required String Date,
    required String photoUrl,
    required link}) async {
  final docflash = FirebaseFirestore.instance
      .collection("ECE")
      .doc("update")
      .collection("update")
      .doc();
  final flash = HomeUpdateConvertor(
      id: docflash.id,
      heading: heading,
      date: getTime(),
      photoUrl: photoUrl,
      link: link);
  final json = flash.toJson();
  await docflash.set(json);
}

class HomeUpdateConvertor {
  String id;
  final String heading, photoUrl, date, link;

  HomeUpdateConvertor(
      {this.id = "",
      required this.heading,
      required this.date,
      required this.photoUrl,
      required this.link});

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "date": date,
        "photoUrl": photoUrl,
        "link": link
      };

  static HomeUpdateConvertor fromJson(Map<String, dynamic> json) =>
      HomeUpdateConvertor(
          link: json["link"],
          id: json['id'],
          heading: json["heading"],
          date: json["date"],
          photoUrl: json["photoUrl"]);
}

Stream<List<RegulationConvertor>> readRegulation() => FirebaseFirestore.instance
    .collection('ECE')
    .doc("regulation")
    .collection("regulation")
    .orderBy("heading", descending: true)
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => RegulationConvertor.fromJson(doc.data()))
        .toList());

Future createRegulation({required String heading}) async {
  final docflash = FirebaseFirestore.instance
      .collection("ECE")
      .doc("regulation")
      .collection("regulation")
      .doc();
  final flash = RegulationConvertor(id: docflash.id, heading: heading);
  final json = flash.toJson();
  await docflash.set(json);
}

class RegulationConvertor {
  String id;
  final String heading;

  RegulationConvertor({this.id = "", required this.heading});

  Map<String, dynamic> toJson() => {"id": id, "heading": heading};

  static RegulationConvertor fromJson(Map<String, dynamic> json) =>
      RegulationConvertor(id: json['id'], heading: json["heading"]);
}

Stream<List<RegulationYearConvertor>> readRegulationYear(String id) =>
    FirebaseFirestore.instance
        .collection('ECE')
        .doc("regulation")
        .collection("regulation")
        .doc(id)
        .collection("year")
        .orderBy("heading", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RegulationYearConvertor.fromJson(doc.data()))
            .toList());

Future createClassRegulation({required String heading}) async {
  final docflash = FirebaseFirestore.instance
      .collection("ECE")
      .doc("regulation")
      .collection("regulation")
      .doc();
  final flash = RegulationYearConvertor(id: docflash.id, heading: heading);
  final json = flash.toJson();
  await docflash.set(json);
}

class RegulationYearConvertor {
  String id;
  final String heading;

  RegulationYearConvertor({this.id = "", required this.heading});

  Map<String, dynamic> toJson() => {"id": id, "heading": heading};

  static RegulationYearConvertor fromJson(Map<String, dynamic> json) =>
      RegulationYearConvertor(id: json['id'], heading: json["heading"]);
}

Stream<List<TimeTableConvertor>> readTimeTable(
        {required String id, required String id1}) =>
    FirebaseFirestore.instance
        .collection('ECE')
        .doc("regulation")
        .collection("regulation")
        .doc(id)
        .collection("year")
        .doc(id1)
        .collection("class")
        .orderBy("heading", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TimeTableConvertor.fromJson(doc.data()))
            .toList());

Future createTimeTable(
    {required String heading,
    required String photoUrl,
    required String id,
    required String id1}) async {
  final docflash = FirebaseFirestore.instance
      .collection('ECE')
      .doc("regulation")
      .collection("regulation")
      .doc(id)
      .collection("year")
      .doc(id1)
      .collection("class")
      .doc();
  final flash =
      TimeTableConvertor(id: docflash.id, heading: heading, photoUrl: photoUrl);
  final json = flash.toJson();
  await docflash.set(json);
}

class TimeTableConvertor {
  String id;
  final String heading, photoUrl;

  TimeTableConvertor(
      {this.id = "", required this.heading, required this.photoUrl});

  Map<String, dynamic> toJson() =>
      {"id": id, "heading": heading, "photoUrl": photoUrl};

  static TimeTableConvertor fromJson(Map<String, dynamic> json) =>
      TimeTableConvertor(
          id: json['id'], heading: json["heading"], photoUrl: json['photoUrl']);
}

Stream<List<RegulationYearClassConvertor>> readRegulationYearClass(
        {required String id, required String id1}) =>
    FirebaseFirestore.instance
        .collection('ECE')
        .doc("regulation")
        .collection("regulation")
        .doc(id)
        .collection("year")
        .doc(id1)
        .collection("class")
        .orderBy("heading", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RegulationYearClassConvertor.fromJson(doc.data()))
            .toList());

Future createClassRegulationClass({required String heading}) async {
  final docflash = FirebaseFirestore.instance
      .collection("ECE")
      .doc("regulation")
      .collection("regulation")
      .doc();
  final flash = RegulationYearConvertor(id: docflash.id, heading: heading);
  final json = flash.toJson();
  await docflash.set(json);
}

class RegulationYearClassConvertor {
  String id;
  final String heading;

  RegulationYearClassConvertor({this.id = "", required this.heading});

  Map<String, dynamic> toJson() => {"id": id, "heading": heading};

  static RegulationYearClassConvertor fromJson(Map<String, dynamic> json) =>
      RegulationYearClassConvertor(id: json['id'], heading: json["heading"]);
}

Stream<List<BranchNewConvertor>> readBranchNew() => FirebaseFirestore.instance
    .collection('ECE')
    .doc("ECENews")
    .collection("ECENews")
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => BranchNewConvertor.fromJson(doc.data()))
        .toList());

Future createBranchNew(
    {required String heading,
    required String description,
    required String Date,
    required String photoUrl}) async {
  final docflash = FirebaseFirestore.instance
      .collection("ECE")
      .doc("ECENews")
      .collection("ECENews")
      .doc();
  final flash = BranchNewConvertor(
      id: docflash.id,
      heading: heading,
      photoUrl: photoUrl,
      description: description,
      Date: Date,
      link: "");
  final json = flash.toJson();
  await docflash.set(json);
}

class BranchNewConvertor {
  String id;
  final String heading, photoUrl, description, Date, link;

  BranchNewConvertor(
      {this.id = "",
      required this.heading,
      required this.photoUrl,
      required this.description,
      required this.Date,
      required this.link});

  Map<String, dynamic> toJson() => {
        "id": id,
        "Heading": heading,
        "Photo Url": photoUrl,
        "Description": description,
        "Date": Date,
        "link": link
      };

  static BranchNewConvertor fromJson(Map<String, dynamic> json) =>
      BranchNewConvertor(
          id: json['id'],
          heading: json["Heading"],
          photoUrl: json["Photo Url"],
          description: json["Description"],
          Date: json["Date"],
          link: json['link']);
}

Stream<List<FlashConvertor>> readFlashNews() => FirebaseFirestore.instance
    .collection('ECE')
    .doc("Subjects")
    .collection("Subjects")
    .orderBy("Heading", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => FlashConvertor.fromJson(doc.data()))
        .toList());

Future createSubjects(
    {required String heading,
    required String description,
    required String date,
    required String PhotoUrl,
    required String regulation}) async {
  final docflash = FirebaseFirestore.instance
      .collection("ECE")
      .doc("Subjects")
      .collection("Subjects")
      .doc();
  final flash = FlashConvertor(
      id: docflash.id,
      heading: heading,
      PhotoUrl: PhotoUrl,
      description: description,
      Date: date,
      regulation: regulation);
  final json = flash.toJson();
  await docflash.set(json);
}

class FlashConvertor {
  String id;
  final String heading, PhotoUrl, description, Date, regulation;

  FlashConvertor(
      {this.id = "",
      required this.regulation,
      required this.heading,
      required this.PhotoUrl,
      required this.description,
      required this.Date});

  Map<String, dynamic> toJson() => {
        "id": id,
        "Heading": heading,
        "Date": Date,
        "Description": description,
        "Photo Url": PhotoUrl,
        "regulation": regulation
      };

  static FlashConvertor fromJson(Map<String, dynamic> json) => FlashConvertor(
      id: json['id'],
      regulation: json["regulation"],
      heading: json["Heading"],
      PhotoUrl: json["Photo Url"],
      description: json["Description"],
      Date: json["Date"]);
}

Stream<List<LabSubjectsConvertor>> readLabSubjects() =>
    FirebaseFirestore.instance
        .collection('ECE')
        .doc("LabSubjects")
        .collection("LabSubjects")
        .orderBy("Heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LabSubjectsConvertor.fromJson(doc.data()))
            .toList());

Future createLabSubjects(
    {required String heading,
    required String description,
    required String Date,
    required String PhotoUrl,
    required String regulation}) async {
  final docflash = FirebaseFirestore.instance
      .collection("ECE")
      .doc("LabSubjects")
      .collection("LabSubjects")
      .doc();
  final flash = LabSubjectsConvertor(
      id: docflash.id,
      heading: heading,
      PhotoUrl: PhotoUrl,
      description: description,
      Date: Date,
      regulation: regulation);
  final json = flash.toJson();
  await docflash.set(json);
}

class LabSubjectsConvertor {
  String id;
  final String heading, PhotoUrl, description, Date, regulation;

  LabSubjectsConvertor(
      {this.id = "",
      required this.heading,
      required this.PhotoUrl,
      required this.description,
      required this.Date,
      required this.regulation});

  Map<String, dynamic> toJson() => {
        "id": id,
        "Heading": heading,
        "Photo Url": PhotoUrl,
        "Description": description,
        "Date": Date,
        "regulation": regulation,
      };

  static LabSubjectsConvertor fromJson(Map<String, dynamic> json) =>
      LabSubjectsConvertor(
          regulation: json["regulation"],
          id: json['id'],
          heading: json["Heading"],
          PhotoUrl: json["Photo Url"],
          description: json["Description"],
          Date: json["Date"]);
}

Stream<List<BooksConvertor>> ReadBook() => FirebaseFirestore.instance
    .collection('ECE')
    .doc("Books")
    .collection("CoreBooks")
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => BooksConvertor.fromJson(doc.data()))
        .toList());

Future createBook(
    {required String heading,
    required String description,
    required String link,
    required String photoUrl,
    required String edition,
    required String Author,
    required String date}) async {
  final docBook = FirebaseFirestore.instance
      .collection("ECE")
      .doc("Books")
      .collection("CoreBooks")
      .doc();
  final Book = BooksConvertor(
      id: docBook.id,
      heading: heading,
      link: link,
      description: description,
      photoUrl: photoUrl,
      Author: Author,
      edition: edition,
      date: date);
  final json = Book.toJson();
  await docBook.set(json);
}

class BooksConvertor {
  String id;
  final String heading, link, description, photoUrl, edition, Author, date;

  BooksConvertor(
      {this.id = "",
      required this.heading,
      required this.link,
      required this.description,
      required this.photoUrl,
      required this.edition,
      required this.Author,
      required this.date});

  Map<String, dynamic> toJson() => {
        "id": id,
        "Heading": heading,
        "Link": link,
        "Description": description,
        "Photo Url": photoUrl,
        "Author": Author,
        "Edition": edition,
        "Date": date
      };

  static BooksConvertor fromJson(Map<String, dynamic> json) => BooksConvertor(
        id: json['id'],
        heading: json["Heading"],
        link: json["Link"],
        description: json["Description"],
        photoUrl: json["Photo Url"],
        Author: json["Author"],
        date: json["Date"],
        edition: json["Edition"],
      );
}

Future showToast(String message) async {
  await Fluttertoast.cancel();
  Fluttertoast.showToast(msg: message, fontSize: 18);
}

_ExternalLaunchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $urlIn';
  }
}

_LaunchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn, mode: LaunchMode.inAppWebView)) {
    throw 'Could not launch $urlIn';
  }
}

void _BooksBottomSheet(
    BuildContext context, BooksConvertor data, File file, File file1) {
  showModalBottomSheet(
    backgroundColor: Colors.black54,
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
      top: Radius.circular(30),
    )),
    builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        maxChildSize: 0.55,
        minChildSize: 0.32,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -15,
                  child: Container(
                    width: 60,
                    height: 7,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white.withOpacity(0.3),
                                    border: Border.all(color: Colors.white),
                                    image: DecorationImage(
                                        image: FileImage(file),
                                        fit: BoxFit.fill)),
                                height: 130,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              flex: 5,
                              //fit: FlexFit.tight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Text(
                                        '${data.heading}',
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Author : ${data.Author}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Edition : ${data.edition}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Text(
                              "Date : ${data.date}",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Description : \n",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "       ${data.description}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, bottom: 10),
                          child: Text(
                            "Download options : ",
                            style: TextStyle(
                                color: Colors.tealAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.3)),
                                    color: Colors.black.withOpacity(0.5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.download_outlined,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "Download",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                showToast("Downloaded");
                              },
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              child: StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('user')
                                    .doc(fullUserId())
                                    .collection("FavouriteBooks")
                                    .doc(data.id)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data!.exists) {
                                      return InkWell(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.3)),
                                              color: Colors.black
                                                  .withOpacity(0.5)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.save,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  "Saved",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: () async {
                                          try {
                                            await FirebaseFirestore.instance
                                                .collection('user')
                                                .doc(fullUserId())
                                                .collection("FavouriteBooks")
                                                .doc(data.id)
                                                .get()
                                                .then((docSnapshot) {
                                              if (docSnapshot.exists) {
                                                FirebaseFirestore.instance
                                                    .collection('user')
                                                    .doc(fullUserId())
                                                    .collection(
                                                        "FavouriteBooks")
                                                    .doc(data.id)
                                                    .delete();
                                                showToast(
                                                    "Removed from saved list");
                                              } else {
                                                FavouriteBooksSubjects(
                                                    description:
                                                        data.description,
                                                    heading: data.heading,
                                                    link: data.link,
                                                    photoUrl: data.photoUrl,
                                                    Author: data.Author,
                                                    edition: data.edition,
                                                    date: data.date,
                                                    id: data.id);
                                                showToast(
                                                    "${data.heading} in favorites");
                                              }
                                            });
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                      );
                                    } else {
                                      return InkWell(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.3)),
                                              color: Colors.black
                                                  .withOpacity(0.5)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.save,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  "Save",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: () async {
                                          try {
                                            await FirebaseFirestore.instance
                                                .collection('user')
                                                .doc(fullUserId())
                                                .collection("FavouriteBooks")
                                                .doc(data.id)
                                                .get()
                                                .then((docSnapshot) {
                                              if (docSnapshot.exists) {
                                                FirebaseFirestore.instance
                                                    .collection('user')
                                                    .doc(fullUserId())
                                                    .collection(
                                                        "FavouriteBooks")
                                                    .doc(data.id)
                                                    .delete();
                                                showToast(
                                                    "Removed from saved list");
                                              } else {
                                                FavouriteBooksSubjects(
                                                    description:
                                                        data.description,
                                                    heading: data.heading,
                                                    link: data.link,
                                                    photoUrl: data.photoUrl,
                                                    Author: data.Author,
                                                    edition: data.edition,
                                                    date: data.date,
                                                    id: data.id);
                                                showToast(
                                                    "${data.heading} in favorites");
                                              }
                                            });
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                      );
                                    }
                                  } else {
                                    return InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.3)),
                                            color:
                                                Colors.black.withOpacity(0.5)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.save,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "Saved",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        showToast("Saved in app");
                                      },
                                    );
                                  }
                                },
                              ),
                              onTap: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('user')
                                      .doc(fullUserId())
                                      .collection("FavouriteBooks")
                                      .doc(data.id)
                                      .get()
                                      .then((docSnapshot) {
                                    if (docSnapshot.exists) {
                                      FirebaseFirestore.instance
                                          .collection('user')
                                          .doc(fullUserId())
                                          .collection("FavouriteBooks")
                                          .doc(data.id)
                                          .delete();
                                      showToast("Removed from saved list");
                                    } else {
                                      FavouriteBooksSubjects(
                                          description: data.description,
                                          heading: data.heading,
                                          link: data.link,
                                          photoUrl: data.photoUrl,
                                          Author: data.Author,
                                          edition: data.edition,
                                          date: data.date,
                                          id: data.id);
                                      showToast("${data.heading} in favorites");
                                    }
                                  });
                                } catch (e) {
                                  print(e);
                                }
                              },
                            ),
                          ],
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text("View :     ",style: TextStyle(color: Colors.cyanAccent,fontSize: 20),),
                            if (file1.existsSync())
                              Row(
                                children: [
                                  InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.black.withOpacity(0.5),
                                          border: Border.all(color: Colors.green),
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(left: 3, right: 3),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.download_outlined,
                                                color: Colors.green,
                                              ),
                                              Text(
                                                " & ",
                                                style: TextStyle(
                                                    color: Colors.white, fontSize: 20),
                                              ),
                                              Text(
                                                "Open",
                                                style: TextStyle(
                                                    color: Colors.white, fontSize: 20),
                                              ),
                                              Icon(
                                                Icons.open_in_new,
                                                color: Colors.greenAccent,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        // Navigator
                                        //     .push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             PdfViewerPage(
                                        //                 pdfUrl: "${folderPath}/pdfs/$name1")));
                                      }),
                                ],
                              )
                            else
                              Row(
                                children: [
                                  InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.black.withOpacity(0.5),
                                          border: Border.all(color: Colors.white),
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(left: 3, right: 3),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.download_outlined,
                                                color: Colors.red,
                                              ),
                                              Text(
                                                " & ",
                                                style: TextStyle(
                                                    color: Colors.white, fontSize: 20),
                                              ),
                                              Text(
                                                "Open",
                                                style: TextStyle(
                                                    color: Colors.white, fontSize: 20),
                                              ),
                                              Icon(
                                                Icons.open_in_new,
                                                color: Colors.greenAccent,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) => Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  CircularProgressIndicator(),
                                                  Text("Downloading",style: TextStyle(color: Colors.white),)
                                                ],
                                              ),
                                            ));
                                        try {
                                          await download(data.link, "pdfs");
                                        } on FirebaseException catch (e) {
                                          print(e);
                                          Utils.showSnackBar(e.message);
                                        }
                                        Navigator.pop(context);
                                      }),
                                ],
                              )
                          ],
                        ),
                      )
                      ]),
                )
              ],
            ),
          );
        }),
  );
}

void _BranchNewsBottomSheet(
    BuildContext context, BranchNewConvertor data, File file) {
  showModalBottomSheet(
    backgroundColor: Colors.black.withOpacity(0.8),
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      ),
    ),
    builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        maxChildSize: 0.63,
        minChildSize: 0.32,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            controller: scrollController,
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -15,
                  child: Container(
                    width: 60,
                    height: 7,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white60,
                    ),
                    child: Center(
                        child: Text(
                      "ECE News",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 8,
                          fontWeight: FontWeight.w500),
                    )),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 5, bottom: 5),
                            child: Row(
                              children: [
                                Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/ece image 64x64.png"),
                                    ),
                                  ),
                                ),
                                if (data.heading.isNotEmpty)
                                  Text(" ${data.heading}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400))
                                else
                                  Text(" ECE (SRKR)",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Image.file(file)),
                          Row(
                            children: [
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  data.Date,
                                  style: TextStyle(
                                      color: Colors.white54, fontSize: 10),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text("Details : ${data.description}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (data.link.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, bottom: 10),
                              child: InkWell(
                                child: Text("Link : ${data.link}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400)),
                                onTap: () {
                                  _ExternalLaunchUrl(data.link);
                                },
                              ),
                            ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15, bottom: 10),
                            child: Text(
                              "Download options : ",
                              style: TextStyle(
                                  color: Colors.tealAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.white.withOpacity(0.3)),
                                      color: Colors.black.withOpacity(0.5)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.download_outlined,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Download",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  showToast("Downloading...");
                                  final Uri uri = Uri.parse(data.photoUrl);
                                  final String fileName = uri.pathSegments.last;
                                  var name = fileName.split("/").last;
                                  final response =
                                      await http.get(Uri.parse(data.photoUrl));

                                  final file = File(
                                      '/storage/emulated/0/Download/$name');
                                  await file.writeAsBytes(response.bodyBytes);
                                  showToast(file.path);
                                  showToast("Downloaded");
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.white.withOpacity(0.3)),
                                      color: Colors.black.withOpacity(0.5)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.save,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Save",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  download(data.photoUrl, fullUserId());
                                  showToast("Saved");
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          )
                        ]),
                  ),
                )
              ],
            ),
          );
        }),
  );
}

class ImageZoom extends StatefulWidget {
  String url;

  ImageZoom({Key? key, required this.url}) : super(key: key);

  @override
  State<ImageZoom> createState() => _ImageZoomState();
}

class _ImageZoomState extends State<ImageZoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Flexible(
              flex: 10,
              child: PhotoView(
                imageProvider: NetworkImage(widget.url),
              ),
            ),
            Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black.withOpacity(0.5)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.download_outlined,
                                color: Colors.white,
                              ),
                              Text(
                                "Download",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () async {
                        showToast("Downloading...");
                        final Uri uri = Uri.parse(widget.url);
                        final String fileName = uri.pathSegments.last;
                        var name = fileName.split("/").last;
                        final response = await http.get(Uri.parse(widget.url));

                        final file = File('/storage/emulated/0/Download/$name');
                        await file.writeAsBytes(response.bodyBytes);
                        showToast(file.path);
                        showToast("Downloaded");
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black.withOpacity(0.5)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.save,
                                color: Colors.white,
                              ),
                              Text(
                                "Save",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        download(widget.url, fullUserId());
                        showToast("Saved in app");
                      },
                    ),
                  ],
                ))
          ],
        ));
  }
}

download(String photoUrl, String path) async {
  final Uri uri = Uri.parse(photoUrl);
  final String fileName = uri.pathSegments.last;
  var name = fileName.split("/").last;
  final response = await http.get(Uri.parse(photoUrl));
  final documentDirectory = await getApplicationDocumentsDirectory();
  final newDirectory = Directory('${documentDirectory.path}/$path');
  if (!await newDirectory.exists()) {
    await newDirectory.create(recursive: true);
    final file = File('${newDirectory.path}/${name}');
    await file.writeAsBytes(response.bodyBytes);
    showToast(file.path);
  } else {
    final file = File('${newDirectory.path}/${name}');
    await file.writeAsBytes(response.bodyBytes);
    showToast(file.path);
  }
}


