// ignore_for_file: must_be_immutable, unnecessary_import
import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:srkr_study_app/SubPages.dart';
import 'package:srkr_study_app/notification.dart';
import 'package:srkr_study_app/search%20bar.dart';
import 'package:srkr_study_app/settings.dart';
import 'package:srkr_study_app/srkr_page.dart';
import 'add subjects.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'favorites.dart';
import 'functins.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  final String branch;
  final String reg;
  final int index;
  final double size;
  final double height;
  final double width;

  const HomePage(
      {Key? key,
      required this.branch,
      required this.reg,
      required this.index,
      required this.width,
      required this.size,
      required this.height})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      setState(() {
        getPath();
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://i.pinimg.com/736x/01/c7/f7/01c7f72511cc6ce7858e65b45d4f8c9c.jpg"),
                    fit: BoxFit.fill)),
            child: Scaffold(
              backgroundColor: Colors.black.withOpacity(0.8),
      body: DefaultTabController(
        initialIndex: 0,
        length: 6,
        child: NestedScrollView(
            // floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),

                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            child: Padding(
                              padding:
                              EdgeInsets.only(right: widget.width * 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        widget.size * 13),
                                    color: Colors.white10),
                                child: Padding(
                                  padding: EdgeInsets.all(widget.size * 4.0),
                                  child: Icon(
                                    Icons.person_outline,
                                    color: Colors.white,
                                    size: widget.size * 30,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration:
                                  const Duration(milliseconds: 300),
                                  pageBuilder: (context, animation,
                                      secondaryAnimation) =>
                                      settings(
                                        width: widget.width,
                                        height: widget.height,
                                        size: widget.size,
                                        index: widget.index,
                                        reg: widget.reg,
                                        branch: widget.branch,
                                      ),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    final fadeTransition = FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );

                                    return Container(
                                      color: Colors.black
                                          .withOpacity(animation.value),
                                      child: AnimatedOpacity(
                                          duration:
                                          Duration(milliseconds: 300),
                                          opacity:
                                          animation.value.clamp(0.3, 1.0),
                                          child: fadeTransition),
                                    );
                                  },
                                ),
                              );
                            }),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: Colors.black.withOpacity(0.8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          widget.size * 20)),
                                  elevation: 16,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white38),
                                      borderRadius:
                                      BorderRadius.circular(widget.size * 20),
                                    ),
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: <Widget>[
                                        branchYear(
                                          isUpdate: true,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Text(
                            "NSIdeas",
                            style: TextStyle(
                              fontSize: 28.0,
                              color: Color.fromRGBO(192, 237, 252, 1),
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                        ),
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.white54),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Icon(
                                Icons.notifications_active,
                                color: Colors.white70,
                                size: 30,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                const Duration(milliseconds: 300),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        notifications(
                                          width: widget.width,
                                          size: widget.size,
                                          height: widget.height,
                                          branch: widget.branch,
                                        ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  final fadeTransition = FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );

                                  return Container(
                                    color: Colors.black
                                        .withOpacity(animation.value),
                                    child: AnimatedOpacity(
                                        duration: Duration(milliseconds: 300),
                                        opacity:
                                        animation.value.clamp(0.3, 1.0),
                                        child: fadeTransition),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.white54),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Icon(
                                Icons.person,
                                color: Colors.white70,
                                size: 30,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                const Duration(milliseconds: 300),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                 MyAppq(branch: '', reg: '', width: 0, size: 0, height: 0,),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  final fadeTransition = FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );

                                  return Container(
                                    color: Colors.black
                                        .withOpacity(animation.value),
                                    child: AnimatedOpacity(
                                        duration: Duration(milliseconds: 300),
                                        opacity:
                                        animation.value.clamp(0.3, 1.0),
                                        child: fadeTransition),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                floating: true,
                primary: true,
                snap: true,
              ),
              SliverAppBar(
                backgroundColor: Colors.black38,
                flexibleSpace: TabBar(
                  isScrollable: true,
                  tabs: [
                    Tab(text: 'Home'),
                    Tab(text: 'Regulation'),
                    Tab(text: 'Favorites'),
                    Tab(text: 'Books'),
                    Tab(text: 'News'),
                    Tab(text: 'Updates'),

                  ],
                ),
                floating: false,
                primary: false,
                snap: false,
                pinned: true,
              ),
            ],
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      homePageUpdate(
                        branch: widget.branch,
                        width: widget.width,
                        height: widget.height,
                        size: widget.size,
                        path: folderPath,
                      ),
                      StreamBuilder<List<BranchNewConvertor>>(
                          stream: readBranchNew(widget.branch),
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
                                          "No ${widget.branch} News",
                                          style: TextStyle(color: Colors.lightBlueAccent),
                                        ));
                                  } else
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: widget.width * 15,
                                              vertical: widget.height * 10),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${widget.branch} News",
                                                style: TextStyle(
                                                    fontSize: widget.size * 30,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                              ),
                                              InkWell(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        widget.size * 8),
                                                    color:
                                                    Colors.black.withOpacity(0.7),
                                                    border: Border.all(
                                                        color: Colors.white
                                                            .withOpacity(0.3)),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: widget.width * 10,
                                                        right: widget.width * 10,
                                                        top: widget.height * 5,
                                                        bottom: widget.height * 5),
                                                    child: Text(
                                                      "See More",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: widget.size * 20,
                                                          fontWeight:
                                                          FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                      transitionDuration:
                                                      const Duration(
                                                          milliseconds: 300),
                                                      pageBuilder: (context,
                                                          animation,
                                                          secondaryAnimation) =>
                                                          NewsPage(
                                                            width: widget.width,
                                                            height: widget.height,
                                                            size: widget.size,
                                                            branch: widget.branch,
                                                          ),
                                                      transitionsBuilder: (context,
                                                          animation,
                                                          secondaryAnimation,
                                                          child) {
                                                        final fadeTransition =
                                                        FadeTransition(
                                                          opacity: animation,
                                                          child: child,
                                                        );

                                                        return Container(
                                                          color: Colors.black
                                                              .withOpacity(
                                                              animation.value),
                                                          child: AnimatedOpacity(
                                                              duration: Duration(
                                                                  milliseconds: 300),
                                                              opacity: animation.value
                                                                  .clamp(0.3, 1.0),
                                                              child: fadeTransition),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        CarouselSlider(
                                          items: List.generate(BranchNews.length,
                                                  (int index) {
                                                final BranchNew = BranchNews[index];
                                                final Uri uri =
                                                Uri.parse(BranchNew.photoUrl);
                                                final String fileName =
                                                    uri.pathSegments.last;
                                                var name = fileName.split("/").last;
                                                final file = File(
                                                    "${folderPath}/${widget.branch.toLowerCase()}_news/$name");
                                                return InkWell(
                                                  child: Image.file(file),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        transitionDuration:
                                                        const Duration(
                                                            milliseconds: 300),
                                                        pageBuilder: (context, animation,
                                                            secondaryAnimation) =>
                                                            ImageZoom(
                                                              size: widget.size,
                                                              width: widget.width,
                                                              height: widget.height,
                                                              url: "",
                                                              file: file,
                                                            ),
                                                        transitionsBuilder: (context,
                                                            animation,
                                                            secondaryAnimation,
                                                            child) {
                                                          final fadeTransition =
                                                          FadeTransition(
                                                            opacity: animation,
                                                            child: child,
                                                          );

                                                          return Container(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                animation.value),
                                                            child: AnimatedOpacity(
                                                                duration: Duration(
                                                                    milliseconds: 300),
                                                                opacity: animation.value
                                                                    .clamp(0.3, 1.0),
                                                                child: fadeTransition),
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                );
                                              }),
                                          //Slider Container properties
                                          options: CarouselOptions(
                                            viewportFraction: 0.85,
                                            enlargeCenterPage: true,
                                            height: widget.height * 210,
                                            autoPlayAnimationDuration:
                                            Duration(milliseconds: 1800),
                                            autoPlay:
                                            BranchNews.length > 1 ? true : false,
                                          ),
                                        ),
                                      ],
                                    );
                                }
                            }
                          }),

                      // if (widget.reg.isNotEmpty)
                      //   Padding(
                      //     padding: EdgeInsets.symmetric(
                      //       horizontal: widget.width * 15,
                      //       vertical: widget.width * 10,
                      //     ),
                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         StreamBuilder<List<TimeTableConvertor>>(
                      //             stream: readTimeTable(
                      //                 reg: widget.reg, branch: widget.branch),
                      //             builder: (context, snapshot) {
                      //               final user = snapshot.data;
                      //               switch (snapshot.connectionState) {
                      //                 case ConnectionState.waiting:
                      //                   return const Center(
                      //                       child: CircularProgressIndicator(
                      //                     strokeWidth: 0.3,
                      //                     color: Colors.cyan,
                      //                   ));
                      //                 default:
                      //                   if (snapshot.hasError) {
                      //                     return const Center(
                      //                         child: Text(
                      //                             'Error with TextBooks Data or\n Check Internet Connection'));
                      //                   } else {
                      //                     if (user!.length > 0)
                      //                       return Column(
                      //                         mainAxisAlignment:
                      //                             MainAxisAlignment.start,
                      //                         crossAxisAlignment:
                      //                             CrossAxisAlignment.start,
                      //                         children: [
                      //                           Padding(
                      //                             padding: EdgeInsets.only(
                      //                                 bottom: widget.height * 10,
                      //                                 top: 10),
                      //                             child: Row(
                      //                               mainAxisAlignment:
                      //                                   MainAxisAlignment
                      //                                       .spaceBetween,
                      //                               children: [
                      //                                 Text(
                      //                                   "Time Table :",
                      //                                   style: TextStyle(
                      //                                       color: Colors.white,
                      //                                       fontSize:
                      //                                           widget.size * 30,
                      //                                       fontWeight:
                      //                                           FontWeight.w500),
                      //                                 ),
                      //                                 Icon(
                      //                                   Icons.info_outline,
                      //                                   size: 30,
                      //                                   color: Colors.white,
                      //                                 )
                      //                               ],
                      //                             ),
                      //                           ),
                      //                           SizedBox(
                      //                             height: widget.height * 74,
                      //                             child: ListView.builder(
                      //                               physics:
                      //                                   const BouncingScrollPhysics(),
                      //                               shrinkWrap: true,
                      //                               scrollDirection: Axis.horizontal,
                      //                               itemCount: user.length,
                      //                               itemBuilder:
                      //                                   (context, int index) {
                      //                                 final classess = user[index];
                      //                                 final Uri uri = Uri.parse(
                      //                                     classess.photoUrl);
                      //                                 final String fileName =
                      //                                     uri.pathSegments.last;
                      //                                 var name =
                      //                                     fileName.split("/").last;
                      //                                 final file = File(
                      //                                     "${folderPath}/${widget.branch.toLowerCase()}_timetable/$name");
                      //                                 if (file.existsSync()) {
                      //                                   return InkWell(
                      //                                     child: Column(
                      //                                       children: [
                      //                                         Container(
                      //                                           height:
                      //                                               widget.height *
                      //                                                   60,
                      //                                           width:
                      //                                               widget.width * 70,
                      //                                           decoration: BoxDecoration(
                      //                                               color:
                      //                                                   Colors.white,
                      //                                               borderRadius:
                      //                                                   BorderRadius.circular(
                      //                                                       widget.size *
                      //                                                           40),
                      //                                               image: DecorationImage(
                      //                                                   image:
                      //                                                       FileImage(
                      //                                                           file),
                      //                                                   fit: BoxFit
                      //                                                       .fill)),
                      //                                         ),
                      //                                         Text(
                      //                                           "${classess.heading}",
                      //                                           style: TextStyle(
                      //                                               color: Colors
                      //                                                   .lightBlueAccent),
                      //                                         )
                      //                                       ],
                      //                                     ),
                      //                                     onTap: () {
                      //                                       Navigator.push(
                      //                                           context,
                      //                                           MaterialPageRoute(
                      //                                               builder:
                      //                                                   (context) =>
                      //                                                       ImageZoom(
                      //                                                         url: "",
                      //                                                         file:
                      //                                                             file,
                      //                                                       )));
                      //                                     },
                      //                                   );
                      //                                 } else {
                      //                                   download(classess.photoUrl,
                      //                                       "${widget.branch.toLowerCase()}_timetable");
                      //
                      //                                   return InkWell(
                      //                                     child: Container(
                      //                                       width: widget.width * 70,
                      //                                       decoration: BoxDecoration(
                      //                                           color: Colors.white,
                      //                                           borderRadius:
                      //                                               BorderRadius
                      //                                                   .circular(
                      //                                                       widget.size *
                      //                                                           40),
                      //                                           image: DecorationImage(
                      //                                               image: NetworkImage(
                      //                                                   classess
                      //                                                       .photoUrl),
                      //                                               fit:
                      //                                                   BoxFit.fill)),
                      //                                       child: Center(
                      //                                           child: Text(
                      //                                         "${classess.heading}",
                      //                                         style: TextStyle(
                      //                                             color: Colors
                      //                                                 .lightBlueAccent),
                      //                                       )),
                      //                                     ),
                      //                                   );
                      //                                 }
                      //                               },
                      //                             ),
                      //                           ),
                      //                         ],
                      //                       );
                      //                     else
                      //                       return Container();
                      //                   }
                      //               }
                      //             }),
                      //       ],
                      //     ),
                      //   ),
                      if (widget.reg.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: widget.width * 15,
                              vertical: widget.height * 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Subjects",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.size * 30,
                                    fontWeight: FontWeight.w500),
                              ),
                              InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(widget.size * 8),
                                    color: Colors.black.withOpacity(0.7),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.3)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: widget.width * 10,
                                        right: widget.width * 10,
                                        top: widget.height * 5,
                                        bottom: widget.height * 5),
                                    child: Text(
                                      "See More",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: widget.size * 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                      const Duration(milliseconds: 300),
                                      pageBuilder:
                                          (context, animation, secondaryAnimation) =>
                                          Subjects(
                                            branch: widget.branch,
                                            reg: widget.reg,
                                            width: widget.width,
                                            height: widget.height,
                                            size: widget.size,
                                          ),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        final fadeTransition = FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );

                                        return Container(
                                          color: Colors.black
                                              .withOpacity(animation.value),
                                          child: AnimatedOpacity(
                                              duration: Duration(milliseconds: 300),
                                              opacity:
                                              animation.value.clamp(0.3, 1.0),
                                              child: fadeTransition),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      if (widget.reg.isNotEmpty)
                        StreamBuilder<List<FlashConvertor>>(
                            stream: readFlashNews(widget.branch),
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
                                    List<FlashConvertor> filteredItems = Favourites!
                                        .where((item) => item.regulation
                                        .toString()
                                        .startsWith(widget.reg))
                                        .toList();
                                    if (Favourites.length > 0)
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: widget.width * 20),
                                        child: GridView.builder(
                                          physics: const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisSpacing: widget.size * 10,
                                            crossAxisCount: 3,
                                          ),
                                          itemCount: filteredItems.length,
                                          itemBuilder: (context, int index) {
                                            final SubjectsData = filteredItems[index];
                                            final Uri uri =
                                            Uri.parse(SubjectsData.PhotoUrl);
                                            final String fileName =
                                                uri.pathSegments.last;
                                            var name = fileName.split("/").last;
                                            final file = File(
                                                "${folderPath}/${widget.branch.toLowerCase()}_subjects/$name");
                                            return InkWell(
                                              child: Column(
                                                children: [
                                                  file.existsSync()
                                                      ? AspectRatio(
                                                    aspectRatio: 16 / 10,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                widget.size *
                                                                    8.0)),
                                                        color: Colors.black,
                                                        image: DecorationImage(
                                                          image:
                                                          FileImage(file),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  widget.size *
                                                                      8),
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                  0.8)),
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .all(widget
                                                                .size *
                                                                5),
                                                            child: Text(
                                                              SubjectsData
                                                                  .heading,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                  widget.size *
                                                                      25,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                      : AspectRatio(
                                                    aspectRatio: 16 / 10,
                                                    child: Container(
                                                      child: Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  widget.size *
                                                                      8),
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                  0.8)),
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .all(widget
                                                                .size *
                                                                5),
                                                            child: Text(
                                                              SubjectsData
                                                                  .heading,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                  widget.size *
                                                                      25,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: widget.height * 3,
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    height: widget.height * 20,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(
                                                              widget.size * 8.0)),
                                                      color: Colors.black38,
                                                    ),
                                                    child: Marquee(
                                                      text: SubjectsData
                                                          .description.isNotEmpty
                                                          ? SubjectsData.description
                                                          : "No Full Name",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: widget.size * 18),
                                                      scrollAxis: Axis.horizontal,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      blankSpace: 20.0,
                                                      // Set the spacing between the end and the beginning of the text
                                                      velocity: 50.0,
                                                      // Set the scrolling speed
                                                      pauseAfterRound:
                                                      Duration(seconds: 1),
                                                      // Set the pause duration after each round
                                                      startPadding: 0.0,
                                                      // Set the initial padding at the start of the text
                                                      accelerationDuration:
                                                      Duration(seconds: 1),
                                                      // Set the duration for text acceleration
                                                      accelerationCurve:
                                                      Curves.linear,
                                                      // Set the curve for text acceleration
                                                      decelerationDuration:
                                                      Duration(milliseconds: 500),
                                                      // Set the duration for text deceleration
                                                      decelerationCurve: Curves
                                                          .easeOut, // Set the curve for text deceleration
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    transitionDuration:
                                                    const Duration(
                                                        milliseconds: 300),
                                                    pageBuilder: (context, animation,
                                                        secondaryAnimation) =>
                                                        subjectUnitsData(
                                                          width: widget.width,
                                                          height: widget.height,
                                                          size: widget.size,
                                                          branch: widget.branch,
                                                          ID: SubjectsData.id,
                                                          mode: "Subjects",
                                                          name: SubjectsData.heading,
                                                          fullName:
                                                          SubjectsData.description,
                                                          photoUrl: SubjectsData.PhotoUrl,
                                                        ),
                                                    transitionsBuilder: (context,
                                                        animation,
                                                        secondaryAnimation,
                                                        child) {
                                                      final fadeTransition =
                                                      FadeTransition(
                                                        opacity: animation,
                                                        child: child,
                                                      );

                                                      return Container(
                                                        color: Colors.black
                                                            .withOpacity(
                                                            animation.value),
                                                        child: AnimatedOpacity(
                                                            duration: Duration(
                                                                milliseconds: 300),
                                                            opacity: animation.value
                                                                .clamp(0.3, 1.0),
                                                            child: fadeTransition),
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    else
                                      return Container(
                                        decoration: BoxDecoration(
                                          border:
                                          Border.all(color: Colors.tealAccent),
                                          borderRadius:
                                          BorderRadius.circular(widget.size * 20),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(widget.size * 8.0),
                                          child: Text(
                                            "No Subjects in this Regulation",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      );
                                  }
                              }
                            }),
                      //Lab Subjects
                      if (widget.reg.isNotEmpty)
                        StreamBuilder<List<LabSubjectsConvertor>>(
                          stream: readLabSubjects(widget.branch),
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
                                  List<LabSubjectsConvertor> filteredItems = Subjects!
                                      .where((item) => item.regulation
                                      .toString()
                                      .startsWith(widget.reg))
                                      .toList();
                                  if (Subjects.length > 0)
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: widget.width * 15),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Lab Subjects",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: widget.size * 30,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              InkWell(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        widget.size * 8),
                                                    color:
                                                    Colors.black.withOpacity(0.7),
                                                    border: Border.all(
                                                        color: Colors.white
                                                            .withOpacity(0.3)),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: widget.width * 10,
                                                        right: widget.width * 10,
                                                        top: widget.height * 5,
                                                        bottom: widget.height * 5),
                                                    child: Text(
                                                      "See More",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: widget.size * 20,
                                                          fontWeight:
                                                          FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                      transitionDuration:
                                                      const Duration(
                                                          milliseconds: 300),
                                                      pageBuilder: (context,
                                                          animation,
                                                          secondaryAnimation) =>
                                                          LabSubjects(
                                                            branch: widget.branch,
                                                            reg: widget.reg,
                                                            width: widget.width,
                                                            height: widget.height,
                                                            size: widget.size,
                                                          ),
                                                      transitionsBuilder: (context,
                                                          animation,
                                                          secondaryAnimation,
                                                          child) {
                                                        final fadeTransition =
                                                        FadeTransition(
                                                          opacity: animation,
                                                          child: child,
                                                        );

                                                        return Container(
                                                          color: Colors.black
                                                              .withOpacity(
                                                              animation.value),
                                                          child: AnimatedOpacity(
                                                              duration: Duration(
                                                                  milliseconds: 300),
                                                              opacity: animation.value
                                                                  .clamp(0.3, 1.0),
                                                              child: fadeTransition),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: widget.height * 10,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: widget.width * 20),
                                          child: GridView.builder(
                                              physics: const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing: widget.width * 10,
                                                crossAxisCount: 3,
                                              ),
                                              itemCount: filteredItems.length,
                                              itemBuilder: (context, int index) {
                                                final LabSubjectsData =
                                                Subjects[index];
                                                if (LabSubjectsData.regulation
                                                    .toString()
                                                    .startsWith(widget.reg)) {
                                                  final Uri uri = Uri.parse(
                                                      LabSubjectsData.PhotoUrl);
                                                  final String fileName =
                                                      uri.pathSegments.last;
                                                  var name = fileName.split("/").last;
                                                  final file = File(
                                                      "${folderPath}/${widget.branch.toLowerCase()}_labsubjects/$name");

                                                  return InkWell(
                                                    child: Column(
                                                      children: [
                                                        file.existsSync()
                                                            ? AspectRatio(
                                                          aspectRatio: 16 / 10,
                                                          child: Container(
                                                            decoration:
                                                            BoxDecoration(
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(
                                                                      widget.size *
                                                                          8.0)),
                                                              color:
                                                              Colors.black,
                                                              image:
                                                              DecorationImage(
                                                                image:
                                                                FileImage(
                                                                    file),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        widget.size *
                                                                            8),
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                        0.8)),
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .all(widget
                                                                      .size *
                                                                      5),
                                                                  child: Text(
                                                                    LabSubjectsData
                                                                        .heading,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                        widget.size *
                                                                            25,
                                                                        fontWeight:
                                                                        FontWeight.w500),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                            : AspectRatio(
                                                          aspectRatio: 16 / 10,
                                                          child: Container(
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        widget.size *
                                                                            8),
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                        0.8)),
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .all(widget
                                                                      .size *
                                                                      5),
                                                                  child: Text(
                                                                    LabSubjectsData
                                                                        .heading,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                        widget.size *
                                                                            25,
                                                                        fontWeight:
                                                                        FontWeight.w500),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: widget.height * 3,
                                                        ),
                                                        Container(
                                                          width: double.infinity,
                                                          height: widget.height * 20,
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    widget.size *
                                                                        8.0)),
                                                            color: Colors.black38,
                                                          ),
                                                          child: Marquee(
                                                            text: LabSubjectsData
                                                                .description
                                                                .isNotEmpty
                                                                ? LabSubjectsData
                                                                .description
                                                                : "No Full Name",
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize:
                                                                widget.size * 18),
                                                            scrollAxis:
                                                            Axis.horizontal,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            blankSpace: 20.0,
                                                            // Set the spacing between the end and the beginning of the text
                                                            velocity: 50.0,
                                                            // Set the scrolling speed
                                                            pauseAfterRound:
                                                            Duration(seconds: 1),
                                                            // Set the pause duration after each round
                                                            startPadding: 0.0,
                                                            // Set the initial padding at the start of the text
                                                            accelerationDuration:
                                                            Duration(seconds: 1),
                                                            // Set the duration for text acceleration
                                                            accelerationCurve:
                                                            Curves.linear,
                                                            // Set the curve for text acceleration
                                                            decelerationDuration:
                                                            Duration(
                                                                milliseconds:
                                                                500),
                                                            // Set the duration for text deceleration
                                                            decelerationCurve: Curves
                                                                .easeOut, // Set the curve for text deceleration
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                          transitionDuration:
                                                          const Duration(
                                                              milliseconds: 300),
                                                          pageBuilder: (context,
                                                              animation,
                                                              secondaryAnimation) =>
                                                              subjectUnitsData(
                                                                width: widget.width,
                                                                height: widget.height,
                                                                size: widget.size,
                                                                branch: widget.branch,
                                                                ID: LabSubjectsData.id,
                                                                mode: "LabSubjects",
                                                                name: LabSubjectsData
                                                                    .heading,
                                                                fullName: LabSubjectsData
                                                                    .description,
                                                                photoUrl: LabSubjectsData
                                                                    .PhotoUrl,
                                                              ),
                                                          transitionsBuilder:
                                                              (context,
                                                              animation,
                                                              secondaryAnimation,
                                                              child) {
                                                            final fadeTransition =
                                                            FadeTransition(
                                                              opacity: animation,
                                                              child: child,
                                                            );

                                                            return Container(
                                                              color: Colors.black
                                                                  .withOpacity(
                                                                  animation
                                                                      .value),
                                                              child: AnimatedOpacity(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                      300),
                                                                  opacity: animation
                                                                      .value
                                                                      .clamp(
                                                                      0.3, 1.0),
                                                                  child:
                                                                  fadeTransition),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                                return Container();
                                              }),
                                        ),
                                      ],
                                    );
                                  else
                                    return Center(
                                        child: Text(
                                            "No Lab Subjects For Your Regulation"));
                                }
                            }
                          },
                        ),

                      StreamBuilder<List<BooksConvertor>>(
                          stream: ReadBook(widget.branch),
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
                                        padding: EdgeInsets.all(widget.size * 8.0),
                                        child: Text(
                                          "No ${widget.branch} Books",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    );
                                  } else
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: widget.width * 15,
                                              vertical: widget.height * 10),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Based on ${widget.branch}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: widget.size * 30,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              InkWell(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          widget.size * 8),
                                                      color: Colors.black
                                                          .withOpacity(0.7),
                                                      border: Border.all(
                                                          color: Colors.white
                                                              .withOpacity(0.3)),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: widget.width * 10,
                                                          right: widget.width * 10,
                                                          top: widget.height * 5,
                                                          bottom: widget.height * 5),
                                                      child: Text(
                                                        "See More",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                            widget.size * 20,
                                                            fontWeight:
                                                            FontWeight.w500),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        transitionDuration:
                                                        const Duration(
                                                            milliseconds: 300),
                                                        pageBuilder: (context,
                                                            animation,
                                                            secondaryAnimation) =>
                                                            allBooks(
                                                              reg: widget.reg,
                                                              size: widget.size,
                                                              height: widget.height,
                                                              width: widget.width,
                                                              branch: widget.branch,
                                                            ),
                                                        transitionsBuilder: (context,
                                                            animation,
                                                            secondaryAnimation,
                                                            child) {
                                                          final fadeTransition =
                                                          FadeTransition(
                                                            opacity: animation,
                                                            child: child,
                                                          );

                                                          return Container(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                animation.value),
                                                            child: AnimatedOpacity(
                                                                duration: Duration(
                                                                    milliseconds:
                                                                    300),
                                                                opacity: animation
                                                                    .value
                                                                    .clamp(0.3, 1.0),
                                                                child:
                                                                fadeTransition),
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  }),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: widget.height * 125,
                                          child: ListView.builder(
                                            physics: BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: Books.length,
                                            itemBuilder:
                                                (BuildContext context, int index) {
                                              final Uri uri =
                                              Uri.parse(Books[index].photoUrl);
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
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .horizontal(
                                                                  right: Radius
                                                                      .circular(
                                                                      widget.size *
                                                                          10)),
                                                              color: Colors.black
                                                                  .withOpacity(0.6),
                                                              // border: Border.all(color: Colors.white),
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets.all(
                                                                  widget.size * 8.0),
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
                                                                      Books[index]
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
                                                                      Books[index]
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
                                                                      Books[index]
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
                                                                    booksDownloadButton(
                                                                      branch: widget
                                                                          .branch,
                                                                      width: widget
                                                                          .width,
                                                                      height: widget
                                                                          .height,
                                                                      size:
                                                                      widget.size,
                                                                      path:
                                                                      folderPath,
                                                                      pdfLink:
                                                                      Books[index]
                                                                          .link,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
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
                                        ),
                                      ],
                                    );
                                }
                            }
                          }),
                      SizedBox(
                        height: widget.height * 100,
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Colors.white30)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 15),
                                child: Text(" Theory ",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w500),),
                              ),
                            ),
                            onTap: (){
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration:
                                  const Duration(milliseconds: 300),
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) =>
                                      Subjects(
                                        branch: widget.branch,
                                        reg: widget.reg,
                                        width: widget.width,
                                        height: widget.height,
                                        size: widget.size,
                                      ),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    final fadeTransition = FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );

                                    return Container(
                                      color: Colors.black
                                          .withOpacity(animation.value),
                                      child: AnimatedOpacity(
                                          duration: Duration(milliseconds: 300),
                                          opacity:
                                          animation.value.clamp(0.3, 1.0),
                                          child: fadeTransition),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Colors.white30)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 15),
                                child: Text("Experiment",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w500),),
                              ),
                            ),
                            onTap: (){
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration:
                                  const Duration(milliseconds: 300),
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) =>
                                      LabSubjects(
                                        branch: widget.branch,
                                        reg: widget.reg,
                                        width: widget.width,
                                        height: widget.height,
                                        size: widget.size,
                                      ),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    final fadeTransition = FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );

                                    return Container(
                                      color: Colors.black
                                          .withOpacity(animation.value),
                                      child: AnimatedOpacity(
                                          duration: Duration(milliseconds: 300),
                                          opacity:
                                          animation.value.clamp(0.3, 1.0),
                                          child: fadeTransition),
                                    );
                                  },
                                ),
                              );
                            },
                          )
                        ],
                      ),
                      if (widget.reg.isNotEmpty)
                        StreamBuilder<List<FlashConvertor>>(
                            stream: readFlashNews(widget.branch),
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
                                    List<FlashConvertor> filteredItems = Favourites!
                                        .where((item) => item.regulation
                                        .toString()
                                        .startsWith(widget.reg))
                                        .toList();
                                    if (Favourites.length > 0) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: widget.width * 20),
                                        child: Container(

                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                GridView.builder(
                                                  physics: const BouncingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisSpacing: widget.size * 10,
                                                    crossAxisCount: 2,
                                                  ),
                                                  itemCount: filteredItems.length,
                                                  itemBuilder: (context, int index) {
                                                    final SubjectsData = filteredItems[index];
                                                    final Uri uri =
                                                    Uri.parse(SubjectsData.PhotoUrl);
                                                    final String fileName =
                                                        uri.pathSegments.last;
                                                    var name = fileName.split("/").last;
                                                    final file = File(
                                                        "${folderPath}/${widget.branch.toLowerCase()}_subjects/$name");
                                                    return InkWell(
                                                      child: Column(
                                                        children: [
                                                          file.existsSync()
                                                              ? AspectRatio(
                                                            aspectRatio: 16 / 10,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        widget.size *
                                                                            8.0)),
                                                                color: Colors.black,
                                                                image: DecorationImage(
                                                                  image:
                                                                  FileImage(file),
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                          widget.size *
                                                                              8),
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                          0.8)),
                                                                  child: Padding(
                                                                    padding: EdgeInsets
                                                                        .all(widget
                                                                        .size *
                                                                        5),
                                                                    child: Text(
                                                                      SubjectsData
                                                                          .heading,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                          widget.size *
                                                                              25,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                              : AspectRatio(
                                                            aspectRatio: 16 / 10,
                                                            child: Container(
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                          widget.size *
                                                                              8),
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                          0.8)),
                                                                  child: Padding(
                                                                    padding: EdgeInsets
                                                                        .all(widget
                                                                        .size *
                                                                        5),
                                                                    child: Text(
                                                                      SubjectsData
                                                                          .heading,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                          widget.size *
                                                                              25,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: widget.height * 3,
                                                          ),
                                                          Container(
                                                            width: double.infinity,
                                                            height: widget.height * 20,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(
                                                                      widget.size * 8.0)),
                                                              color: Colors.black38,
                                                            ),
                                                            // child: Marquee(
                                                            //   text: SubjectsData
                                                            //           .description.isNotEmpty
                                                            //       ? SubjectsData.description
                                                            //       : "No Full Name",
                                                            //   style: TextStyle(
                                                            //       color: Colors.white,
                                                            //       fontSize: widget.size * 18),
                                                            //   scrollAxis: Axis.horizontal,
                                                            //   crossAxisAlignment:
                                                            //       CrossAxisAlignment.start,
                                                            //   blankSpace: 20.0,
                                                            //   // Set the spacing between the end and the beginning of the text
                                                            //   velocity: 50.0,
                                                            //   // Set the scrolling speed
                                                            //   pauseAfterRound:
                                                            //       Duration(seconds: 1),
                                                            //   // Set the pause duration after each round
                                                            //   startPadding: 0.0,
                                                            //   // Set the initial padding at the start of the text
                                                            //   accelerationDuration:
                                                            //       Duration(seconds: 1),
                                                            //   // Set the duration for text acceleration
                                                            //   accelerationCurve:
                                                            //       Curves.linear,
                                                            //   // Set the curve for text acceleration
                                                            //   decelerationDuration:
                                                            //       Duration(milliseconds: 500),
                                                            //   // Set the duration for text deceleration
                                                            //   decelerationCurve: Curves
                                                            //       .easeOut, // Set the curve for text deceleration
                                                            // ),
                                                          ),
                                                        ],
                                                      ),
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          PageRouteBuilder(
                                                            transitionDuration:
                                                            const Duration(
                                                                milliseconds: 300),
                                                            pageBuilder: (context, animation,
                                                                secondaryAnimation) =>
                                                                subjectUnitsData(
                                                                  width: widget.width,
                                                                  height: widget.height,
                                                                  size: widget.size,
                                                                  branch: widget.branch,
                                                                  ID: SubjectsData.id,
                                                                  mode: "Subjects",
                                                                  name: SubjectsData.heading,
                                                                  fullName:
                                                                  SubjectsData.description,
                                                                  photoUrl: SubjectsData.PhotoUrl,
                                                                ),
                                                            transitionsBuilder: (context,
                                                                animation,
                                                                secondaryAnimation,
                                                                child) {
                                                              final fadeTransition =
                                                              FadeTransition(
                                                                opacity: animation,
                                                                child: child,
                                                              );

                                                              return Container(
                                                                color: Colors.black
                                                                    .withOpacity(
                                                                    animation.value),
                                                                child: AnimatedOpacity(
                                                                    duration: Duration(
                                                                        milliseconds: 300),
                                                                    opacity: animation.value
                                                                        .clamp(0.3, 1.0),
                                                                    child: fadeTransition),
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                                InkWell(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(30),
                                                        border: Border.all(color: Colors.white30)
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 15),
                                                      child: Text("See More",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w500),),
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        transitionDuration:
                                                        const Duration(milliseconds: 300),
                                                        pageBuilder:
                                                            (context, animation, secondaryAnimation) =>
                                                            Subjects(
                                                              branch: widget.branch,
                                                              reg: widget.reg,
                                                              width: widget.width,
                                                              height: widget.height,
                                                              size: widget.size,
                                                            ),
                                                        transitionsBuilder: (context, animation,
                                                            secondaryAnimation, child) {
                                                          final fadeTransition = FadeTransition(
                                                            opacity: animation,
                                                            child: child,
                                                          );

                                                          return Container(
                                                            color: Colors.black
                                                                .withOpacity(animation.value),
                                                            child: AnimatedOpacity(
                                                                duration: Duration(milliseconds: 300),
                                                                opacity:
                                                                animation.value.clamp(0.3, 1.0),
                                                                child: fadeTransition),
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            border: Border.all(color: Colors.white30)
                                          ),
                                        ),
                                      );
                                    } else
                                      return Container(
                                        decoration: BoxDecoration(
                                          border:
                                          Border.all(color: Colors.tealAccent),
                                          borderRadius:
                                          BorderRadius.circular(widget.size * 20),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(widget.size * 8.0),
                                          child: Text(
                                            "No Subjects in this Regulation",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      );
                                  }
                              }
                            }),
                      //Lab Subjects
                      if (widget.reg.isNotEmpty)
                        StreamBuilder<List<LabSubjectsConvertor>>(
                          stream: readLabSubjects(widget.branch),
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
                                  List<LabSubjectsConvertor> filteredItems = Subjects!
                                      .where((item) => item.regulation
                                      .toString()
                                      .startsWith(widget.reg))
                                      .toList();
                                  if (Subjects.length > 0)
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: widget.width * 15),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Lab Subjects",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: widget.size * 30,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              InkWell(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        widget.size * 8),
                                                    color:
                                                    Colors.black.withOpacity(0.7),
                                                    border: Border.all(
                                                        color: Colors.white
                                                            .withOpacity(0.3)),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: widget.width * 10,
                                                        right: widget.width * 10,
                                                        top: widget.height * 5,
                                                        bottom: widget.height * 5),
                                                    child: Text(
                                                      "See More",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: widget.size * 20,
                                                          fontWeight:
                                                          FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                      transitionDuration:
                                                      const Duration(
                                                          milliseconds: 300),
                                                      pageBuilder: (context,
                                                          animation,
                                                          secondaryAnimation) =>
                                                          LabSubjects(
                                                            branch: widget.branch,
                                                            reg: widget.reg,
                                                            width: widget.width,
                                                            height: widget.height,
                                                            size: widget.size,
                                                          ),
                                                      transitionsBuilder: (context,
                                                          animation,
                                                          secondaryAnimation,
                                                          child) {
                                                        final fadeTransition =
                                                        FadeTransition(
                                                          opacity: animation,
                                                          child: child,
                                                        );

                                                        return Container(
                                                          color: Colors.black
                                                              .withOpacity(
                                                              animation.value),
                                                          child: AnimatedOpacity(
                                                              duration: Duration(
                                                                  milliseconds: 300),
                                                              opacity: animation.value
                                                                  .clamp(0.3, 1.0),
                                                              child: fadeTransition),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: widget.height * 10,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: widget.width * 20),
                                          child: GridView.builder(
                                              physics: const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing: widget.width * 10,
                                                crossAxisCount: 3,
                                              ),
                                              itemCount: filteredItems.length,
                                              itemBuilder: (context, int index) {
                                                final LabSubjectsData =
                                                Subjects[index];
                                                if (LabSubjectsData.regulation
                                                    .toString()
                                                    .startsWith(widget.reg)) {
                                                  final Uri uri = Uri.parse(
                                                      LabSubjectsData.PhotoUrl);
                                                  final String fileName =
                                                      uri.pathSegments.last;
                                                  var name = fileName.split("/").last;
                                                  final file = File(
                                                      "${folderPath}/${widget.branch.toLowerCase()}_labsubjects/$name");

                                                  return InkWell(
                                                    child: Column(
                                                      children: [
                                                        file.existsSync()
                                                            ? AspectRatio(
                                                          aspectRatio: 16 / 10,
                                                          child: Container(
                                                            decoration:
                                                            BoxDecoration(
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(
                                                                      widget.size *
                                                                          8.0)),
                                                              color:
                                                              Colors.black,
                                                              image:
                                                              DecorationImage(
                                                                image:
                                                                FileImage(
                                                                    file),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        widget.size *
                                                                            8),
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                        0.8)),
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .all(widget
                                                                      .size *
                                                                      5),
                                                                  child: Text(
                                                                    LabSubjectsData
                                                                        .heading,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                        widget.size *
                                                                            25,
                                                                        fontWeight:
                                                                        FontWeight.w500),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                            : AspectRatio(
                                                          aspectRatio: 16 / 10,
                                                          child: Container(
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        widget.size *
                                                                            8),
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                        0.8)),
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .all(widget
                                                                      .size *
                                                                      5),
                                                                  child: Text(
                                                                    LabSubjectsData
                                                                        .heading,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                        widget.size *
                                                                            25,
                                                                        fontWeight:
                                                                        FontWeight.w500),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: widget.height * 3,
                                                        ),
                                                        Container(
                                                          width: double.infinity,
                                                          height: widget.height * 20,
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    widget.size *
                                                                        8.0)),
                                                            color: Colors.black38,
                                                          ),
                                                          // child: Marquee(
                                                          //   text: LabSubjectsData
                                                          //           .description
                                                          //           .isNotEmpty
                                                          //       ? LabSubjectsData
                                                          //           .description
                                                          //       : "No Full Name",
                                                          //   style: TextStyle(
                                                          //       color: Colors.white,
                                                          //       fontSize:
                                                          //           widget.size * 18),
                                                          //   scrollAxis:
                                                          //       Axis.horizontal,
                                                          //   crossAxisAlignment:
                                                          //       CrossAxisAlignment
                                                          //           .start,
                                                          //   blankSpace: 20.0,
                                                          //   // Set the spacing between the end and the beginning of the text
                                                          //   velocity: 50.0,
                                                          //   // Set the scrolling speed
                                                          //   pauseAfterRound:
                                                          //       Duration(seconds: 1),
                                                          //   // Set the pause duration after each round
                                                          //   startPadding: 0.0,
                                                          //   // Set the initial padding at the start of the text
                                                          //   accelerationDuration:
                                                          //       Duration(seconds: 1),
                                                          //   // Set the duration for text acceleration
                                                          //   accelerationCurve:
                                                          //       Curves.linear,
                                                          //   // Set the curve for text acceleration
                                                          //   decelerationDuration:
                                                          //       Duration(
                                                          //           milliseconds:
                                                          //               500),
                                                          //   // Set the duration for text deceleration
                                                          //   decelerationCurve: Curves
                                                          //       .easeOut, // Set the curve for text deceleration
                                                          // ),
                                                        ),
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                          transitionDuration:
                                                          const Duration(
                                                              milliseconds: 300),
                                                          pageBuilder: (context,
                                                              animation,
                                                              secondaryAnimation) =>
                                                              subjectUnitsData(
                                                                width: widget.width,
                                                                height: widget.height,
                                                                size: widget.size,
                                                                branch: widget.branch,
                                                                ID: LabSubjectsData.id,
                                                                mode: "LabSubjects",
                                                                name: LabSubjectsData
                                                                    .heading,
                                                                fullName: LabSubjectsData
                                                                    .description,
                                                                photoUrl: LabSubjectsData
                                                                    .PhotoUrl,
                                                              ),
                                                          transitionsBuilder:
                                                              (context,
                                                              animation,
                                                              secondaryAnimation,
                                                              child) {
                                                            final fadeTransition =
                                                            FadeTransition(
                                                              opacity: animation,
                                                              child: child,
                                                            );

                                                            return Container(
                                                              color: Colors.black
                                                                  .withOpacity(
                                                                  animation
                                                                      .value),
                                                              child: AnimatedOpacity(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                      300),
                                                                  opacity: animation
                                                                      .value
                                                                      .clamp(
                                                                      0.3, 1.0),
                                                                  child:
                                                                  fadeTransition),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                                return Container();
                                              }),
                                        ),
                                      ],
                                    );
                                  else
                                    return Center(
                                        child: Text(
                                            "No Lab Subjects For Your Regulation"));
                                }
                            }
                          },
                        ),
                      StreamBuilder<List<BooksConvertor>>(
                          stream: ReadBook(widget.branch),
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
                                        padding: EdgeInsets.all(widget.size * 8.0),
                                        child: Text(
                                          "No ${widget.branch} Books",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    );
                                  } else
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: widget.width * 15,
                                              vertical: widget.height * 10),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Based on ${widget.branch}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: widget.size * 30,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              InkWell(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          widget.size * 8),
                                                      color: Colors.black
                                                          .withOpacity(0.7),
                                                      border: Border.all(
                                                          color: Colors.white
                                                              .withOpacity(0.3)),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: widget.width * 10,
                                                          right: widget.width * 10,
                                                          top: widget.height * 5,
                                                          bottom: widget.height * 5),
                                                      child: Text(
                                                        "See More",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                            widget.size * 20,
                                                            fontWeight:
                                                            FontWeight.w500),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        transitionDuration:
                                                        const Duration(
                                                            milliseconds: 300),
                                                        pageBuilder: (context,
                                                            animation,
                                                            secondaryAnimation) =>
                                                            allBooks(
                                                              reg: widget.reg,
                                                              size: widget.size,
                                                              height: widget.height,
                                                              width: widget.width,
                                                              branch: widget.branch,
                                                            ),
                                                        transitionsBuilder: (context,
                                                            animation,
                                                            secondaryAnimation,
                                                            child) {
                                                          final fadeTransition =
                                                          FadeTransition(
                                                            opacity: animation,
                                                            child: child,
                                                          );

                                                          return Container(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                animation.value),
                                                            child: AnimatedOpacity(
                                                                duration: Duration(
                                                                    milliseconds:
                                                                    300),
                                                                opacity: animation
                                                                    .value
                                                                    .clamp(0.3, 1.0),
                                                                child:
                                                                fadeTransition),
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  }),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: widget.height * 125,
                                          child: ListView.builder(
                                            physics: BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: Books.length,
                                            itemBuilder:
                                                (BuildContext context, int index) {
                                              final Uri uri =
                                              Uri.parse(Books[index].photoUrl);
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
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .horizontal(
                                                                  right: Radius
                                                                      .circular(
                                                                      widget.size *
                                                                          10)),
                                                              color: Colors.black
                                                                  .withOpacity(0.6),
                                                              // border: Border.all(color: Colors.white),
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets.all(
                                                                  widget.size * 8.0),
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
                                                                      Books[index]
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
                                                                      Books[index]
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
                                                                      Books[index]
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
                                                                    booksDownloadButton(
                                                                      branch: widget
                                                                          .branch,
                                                                      width: widget
                                                                          .width,
                                                                      height: widget
                                                                          .height,
                                                                      size:
                                                                      widget.size,
                                                                      path:
                                                                      folderPath,
                                                                      pdfLink:
                                                                      Books[index]
                                                                          .link,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
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
                                        ),
                                      ],
                                    );
                                }
                            }
                          }),
                    ],
                  ),
                ),

                favorites(
                  width: widget.width,
                  height: widget.height,
                  size: widget.size,
                  branch: widget.branch,
                ),
                allBooks(
                  reg: widget.reg,
                  size: widget.size,
                  height: widget.height,
                  width: widget.width,
                  branch: widget.branch,
                ),
                NewsPage(
                  width: widget.width,
                  height: widget.height,
                  size: widget.size,
                  branch: widget.branch,
                ),
                updatesPage(
                  width: widget.width,
                  height: widget.height,

                  size: widget.size,
                  branch: widget.branch,
                ),

              ],
            ),
        ),
      ),
            ),
          ));
}

class booksDownloadButton extends StatefulWidget {
  final String branch;
  final double size;
  final String pdfLink;
  final String path;

  final double height;
  final double width;
  const booksDownloadButton(
      {Key? key,
      required this.branch,
      required this.width,
      required this.size,
      required this.height,
      required this.pdfLink,
      required this.path})
      : super(key: key);

  @override
  State<booksDownloadButton> createState() => _booksDownloadButtonState();
}

class _booksDownloadButtonState extends State<booksDownloadButton> {
  bool isDownloaded = false;
  late File file1;
  String name1 = "";
  void getFile() {
    final Uri uri1 = Uri.parse(widget.pdfLink);
    String fileName1 = uri1.pathSegments.last;
    name1 = fileName1.split("/").last;
    file1 = File("${widget.path}/pdfs/$name1");

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFile();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.size * 8),
        color: Colors.white.withOpacity(0.07),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.size * 8),
                  color: Colors.black.withOpacity(0.5),
                  border: Border.all(
                      color: file1.existsSync() ? Colors.green : Colors.white),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: widget.width * 3),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: widget.height * 3,
                            horizontal: widget.width * 5),
                        child: Text(
                          file1.existsSync() ? "Open" : "Download",
                          style: TextStyle(
                              color: Colors.white, fontSize: widget.size * 20),
                        ),
                      ),
                      !isDownloaded
                          ? Icon(
                              file1.existsSync()
                                  ? Icons.open_in_new
                                  : Icons.download_for_offline_outlined,
                              color: Colors.greenAccent,
                            )
                          : SizedBox(
                              height: widget.height * 20,
                              width: widget.width * 20,
                              child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ),
              onTap: () async {
                if (file1.existsSync()) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PdfViewerPage(
                              pdfUrl: "${widget.path}/pdfs/${name1}")));
                } else {
                  setState(() {
                    isDownloaded = true;
                  });
                  showToastText("Downloading...");
                  await download(widget.pdfLink, "pdfs");
                  setState(() {
                    isDownloaded = false;
                    showToastText("Downloaded");
                  });
                }
              }),
          if (file1.existsSync())
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: widget.width * 5, vertical: widget.height * 1),
              child: InkWell(
                child: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                  size: widget.size * 25,
                ),
                onTap: () async {
                  if (file1.existsSync()) {
                    await file1.delete();
                  }
                  setState(() {});
                  showToastText("File has been deleted");
                },
              ),
            )
        ],
      ),
    );
  }
}

class homePageUpdate extends StatefulWidget {
  final String branch;
  final String path;
  final double size;
  final double height;
  final double width;

  const homePageUpdate(
      {Key? key,
      required this.branch,
      required this.width,
      required this.size,
      required this.height,
      required this.path})
      : super(key: key);

  @override
  State<homePageUpdate> createState() => _homePageUpdateState();
}

class _homePageUpdateState extends State<homePageUpdate> {
  bool isBranch = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height * 149,
      child: StreamBuilder<List<UpdateConvertor>>(
          stream: readUpdate(widget.branch),
          builder: (context, snapshot) {
            final Updates = snapshot.data;
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
                          'Error with updates Data or\n Check Internet Connection'));
                } else {
                  if (Updates!.length == 0) {
                    return Container();
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: widget.height * 10,
                              horizontal: widget.width * 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Updates",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.size * 30,
                                    fontWeight: FontWeight.w500),
                              ),
                              InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius:
                                        BorderRadius.circular(widget.size * 8),
                                    border: isBranch
                                        ? Border.all(
                                            color:
                                                Colors.green.withOpacity(0.8))
                                        : Border.all(
                                            color:
                                                Colors.white.withOpacity(0.3)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: widget.width * 10,
                                        right: widget.width * 10,
                                        top: widget.height * 3,
                                        bottom: widget.height * 3),
                                    child: Text(
                                      "Branch",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: widget.size * 18),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    isBranch = !isBranch;
                                  });
                                },
                              ),
                              InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(widget.size * 8),
                                    color: Colors.black.withOpacity(0.7),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.3)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: widget.width * 10,
                                        right: widget.width * 10,
                                        top: widget.height * 5,
                                        bottom: widget.height * 5),
                                    child: Text(
                                      "See More",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: widget.size * 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 300),
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          updatesPage(
                                        width: widget.width,
                                        height: widget.height,

                                        size: widget.size,
                                        branch: widget.branch,
                                      ),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        final fadeTransition = FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );

                                        return Container(
                                          color: Colors.black
                                              .withOpacity(animation.value),
                                          child: AnimatedOpacity(
                                              duration:
                                                  Duration(milliseconds: 300),
                                              opacity: animation.value
                                                  .clamp(0.3, 1.0),
                                              child: fadeTransition),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: widget.height * 95,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: min(
                                Updates.length, 5), // Display only top 5 items
                            itemBuilder: (context, int index) {
                              final filteredUpdates = Updates.where((update) {
                                if (isBranch) {
                                  return update.branch == widget.branch;
                                } else {
                                  return update.heading != "all";
                                }
                              }).toList();

                              if (filteredUpdates.length <= index) {
                                return SizedBox.shrink();
                              }

                              final BranchNew = filteredUpdates[index];
                              final Uri uri = Uri.parse(BranchNew.photoUrl);
                              final String fileName = uri.pathSegments.last;
                              var name = fileName.split("/").last;
                              final file = File("${widget.path}/updates/$name");

                              return Padding(
                                padding:
                                    EdgeInsets.only(left: widget.width * 10),
                                child: InkWell(
                                  child: Container(
                                    padding: EdgeInsets.all(widget.size * 5),
                                    width: screenWidth(context) / 1.35,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(
                                          widget.size * 15),
                                      border: Border.all(color: Colors.white10),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: widget.width * 35,
                                              height: widget.height * 35,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        widget.size * 17),
                                                image: DecorationImage(
                                                  image: FileImage(file),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        widget.width * 5),
                                                child: Text(
                                                  BranchNew.heading,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          widget.size * 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: widget.width * 45,
                                              right: widget.width * 10,
                                              bottom: widget.height * 5),
                                          child: Row(
                                            children: [
                                              Text(
                                                BranchNew.description,
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: widget.size * 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: widget.width * 40,
                                              right: widget.width * 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.favorite,
                                                      color: BranchNew.likedBy
                                                              .contains(
                                                                  user0Id())
                                                          ? Colors.redAccent
                                                          : Colors.white,
                                                      size: widget.size * 20,
                                                    ),
                                                    Text(
                                                      BranchNew.likedBy.length >
                                                              0
                                                          ? " ${BranchNew.likedBy.length} Likes"
                                                          : " ${BranchNew.likedBy.length} Like",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              widget.size * 18),
                                                    )
                                                  ],
                                                ),
                                                onTap: () {
                                                  like(
                                                      !BranchNew.likedBy
                                                          .contains(user0Id()),
                                                      BranchNew.id);
                                                },
                                              ),
                                              if (BranchNew.link.isNotEmpty)
                                                InkWell(
                                                  child: Text(
                                                    "Open (Link)",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .lightBlueAccent),
                                                  ),
                                                  onTap: () {
                                                    ExternalLaunchUrl(
                                                        BranchNew.link);
                                                  },
                                                ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: widget.height * 5),
                                                child: Text(
                                                  BranchNew.date,
                                                  style: TextStyle(
                                                      color: Colors.white38,
                                                      fontSize:
                                                          widget.size * 10),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onLongPress: () {
                                    if (isUser()) {
                                      final deleteFlashNews = FirebaseFirestore
                                          .instance
                                          .collection("update")
                                          .doc(BranchNew.id);
                                      deleteFlashNews.delete();
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    );
                  }
                }
            }
          }),
    );
  }
}

Stream<List<UpdateConvertor>> readUpdate(String branch) =>
    FirebaseFirestore.instance
        .collection("update")
        .orderBy("id", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UpdateConvertor.fromJson(doc.data()))
            .toList());

Future createHomeUpdate({
  required String heading,
  required String photoUrl,
  required link,
  required String branch,
  required String description,
}) async {
  final docflash = FirebaseFirestore.instance.collection("update").doc(getID());

  final flash = UpdateConvertor(
      id: getID(),
      heading: heading,
      branch: branch,
      description: description,
      date: getDate(),
      photoUrl: photoUrl,
      link: link);
  final json = flash.toJson();
  await docflash.set(json);
}

class UpdateConvertor {
  String id;
  final String heading, photoUrl, date, link, description, branch;
  List<String> likedBy;

  UpdateConvertor({
    this.id = "",
    required this.heading,
    required this.date,
    required this.photoUrl,
    required this.link,
    required this.branch,
    required this.description,
    List<String>? likedBy,
  }) : likedBy = likedBy ?? [];

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "date": date,
        "photoUrl": photoUrl,
        "link": link,
        "likedBy": likedBy,
        "description": description,
        "branch": branch,
      };

  static UpdateConvertor fromJson(Map<String, dynamic> json) => UpdateConvertor(
        id: json['id'],
        heading: json["heading"],
        date: json["date"],
        photoUrl: json["photoUrl"],
        link: json["link"],
        description: json["description"],
        branch: json["branch"],
        likedBy:
            json["likedBy"] != null ? List<String>.from(json["likedBy"]) : [],
      );
}

Stream<List<RegulationConvertor>> readRegulation(String branch) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("regulation")
        .collection("regulation")
        .orderBy("id", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RegulationConvertor.fromJson(doc.data()))
            .toList());

Future createRegulation({required String name, required String branch}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc("regulation")
      .collection("regulation")
      .doc(name);
  final flash = RegulationConvertor(id: name);
  final json = flash.toJson();
  await docflash.set(json);
}

class RegulationConvertor {
  String id;

  RegulationConvertor({this.id = ""});

  Map<String, dynamic> toJson() => {"id": id};

  static RegulationConvertor fromJson(Map<String, dynamic> json) =>
      RegulationConvertor(id: json['id']);
}

Stream<List<TimeTableConvertor>> readTimeTable(
        {required String reg, required String branch}) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("regulation")
        .collection("regulation")
        .doc(reg)
        .collection("timeTables")
        .orderBy("heading", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TimeTableConvertor.fromJson(doc.data()))
            .toList());

Future createTimeTable(
    {required String branch,
    required String heading,
    required String photoUrl,
    required String reg,
    required String id1}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc("regulation")
      .collection("regulation")
      .doc(reg)
      .collection("timeTables")
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

Stream<List<BranchNewConvertor>> readBranchNew(String branch) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("${branch}News")
        .collection("${branch}News")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BranchNewConvertor.fromJson(doc.data()))
            .toList());

Future createBranchNew(
    {required String heading,
    required String description,
    required String branch,
    required String Date,
    required String photoUrl}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
      .doc("${branch}News")
      .collection("${branch}News")
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

Stream<List<FlashConvertor>> readFlashNews(String branch) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("Subjects")
        .collection("Subjects")
        .orderBy("Heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FlashConvertor.fromJson(doc.data()))
            .toList());

Future createSubjects(
    {required String heading,
    required String branch,
    required String description,
    required String date,
    required String PhotoUrl,
    required String regulation}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
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

Stream<List<LabSubjectsConvertor>> readLabSubjects(String branch) =>
    FirebaseFirestore.instance
        .collection(branch)
        .doc("LabSubjects")
        .collection("LabSubjects")
        .orderBy("Heading", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LabSubjectsConvertor.fromJson(doc.data()))
            .toList());

Future createLabSubjects(
    {required String branch,
    required String heading,
    required String description,
    required String Date,
    required String PhotoUrl,
    required String regulation}) async {
  final docflash = FirebaseFirestore.instance
      .collection(branch)
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

Stream<List<BooksConvertor>> ReadBook(String branch) =>
    FirebaseFirestore.instance
        .collection(branch)
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
    required String branch,
    required String photoUrl,
    required String edition,
    required String Author,
    required String date}) async {
  final docBook = FirebaseFirestore.instance
      .collection(branch)
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

class ImageZoom extends StatefulWidget {
  String url;
  File file;
  final double size;
  final double height;
  final double width;
  ImageZoom(
      {Key? key,
      required this.url,
      required this.file,
      required this.width,
      required this.size,
      required this.height})
      : super(key: key);

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
            // Flexible(
            //   flex: 10,
            //   // child: PhotoView(
            //   //   imageProvider: FileImage(widget.file),
            //   // ),
            // ),
          ],
        ));
  }
}
